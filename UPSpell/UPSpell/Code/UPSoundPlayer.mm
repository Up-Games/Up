//
//  UPSoundPlayer.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <map>
#import <mutex>

#import <AVFoundation/AVFoundation.h>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPMath.h>

#import "AVAudioPlayer+UPSpell.h"
#import "UPSoundPlayer.h"

// =========================================================================================================================================

@interface UPSound : NSObject
@property (nonatomic) AVAudioFile *file;
@property (nonatomic) AVAudioPlayerNode *player;
@property (nonatomic) AVAudioPCMBuffer *buffer;
@property (nonatomic) AVAudioMixerNode *outputMixer;
@property (nonatomic) BOOL playing;
@end

@implementation UPSound
@end

// =========================================================================================================================================

@interface UPSoundPlayer () <AVAudioPlayerDelegate>
{
    std::multimap<UPSoundID, __strong UPSound *> m_map;
}

@property (nonatomic) AVAudioEngine *engine;

@end

@implementation UPSoundPlayer

+ (UPSoundPlayer *)instance
{
    static dispatch_once_t onceToken;
    static UPSoundPlayer *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPSoundPlayer alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    self = [super init];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    BOOL result = [audioSession setCategory:AVAudioSessionCategoryAmbient mode:AVAudioSessionModeDefault
                                    options:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    if (!result || error) {
        LOG(General, "Can't set audio session category: %@", error);
    }

    self.volume = 0.5;

    [self reset];

    return self;
}

- (void)reset
{
    self.engine = [[AVAudioEngine alloc] init];
}

- (void)setVolume:(float)volume
{
    _volume = volume;
    
    [self prepare];
    self.engine.mainMixerNode.outputVolume = volume;
}

- (NSError *)setFilePath:(NSString *)filePath forSoundID:(UPSoundID)soundID volume:(float)volume playerCount:(NSUInteger)playerCount
{
    m_map.erase(soundID);

    NSError *error = nil;
    for (NSUInteger i = 0; i < playerCount; i++) {
        UPSound *sound = [self _createSoundWithFilePath:filePath error:&error];
        if (sound) {
            sound.outputMixer.outputVolume = volume;
            m_map.insert({ soundID, sound });
        }
    }
    
    return error;
}

- (void)playSoundID:(UPSoundID)soundID
{
    if (up_is_fuzzy_zero(self.volume)) {
        return;
    }
    
    [self prepare];
    
    BOOL played = NO;
    auto range = m_map.equal_range(soundID);
    for (auto it = range.first; it != range.second; ++it) {
        UPSound *sound = it->second;
        if (!sound.playing) {
            [self _playSound:sound];
            played = YES;
            break;
        }
    }
    if (!played) {
        if (range.first != range.second) {
            UPSound *sound = range.first->second;
            LOG(Sound, "play [backup]: %ld", soundID);
            [self _playSound:sound];
        }
        else {
            LOG(Sound, "no player available for soundID: %ld", soundID);
        }
    }
}

- (void)prepare
{
    @try {
        if (!self.engine.isRunning) {
            NSError *error = nil;
            [self.engine startAndReturnError:&error];
            if (error) {
                LOG(Sound, "error preparing audio engine: %@", error);
            }
        }
    }
    @catch (NSException *exception) {
        LOG(General, "exception preparing sound player: %@", exception);
    }
}

- (void)stop
{
    @try {
        for (auto it = m_map.begin(); it != m_map.end(); ++it) {
            UPSound *sound = it->second;
            sound.playing = NO;
            [sound.player pause];
        }
        [self.engine stop];
    }
    @catch (NSException *exception) {
        LOG(General, "exception stopping sound player: %@", exception);
    }
}

- (void)setVolumeFromLevel:(NSUInteger)level
{
    switch (level) {
        case 0:
            self.volume = 0.0f;
            break;
        case 1:
        default:
            self.volume = 0.05f;
            break;
        case 2:
            self.volume = 0.2f;
            break;
        case 3:
            self.volume = 0.4f;
            break;
        case 4:
            self.volume = 0.6f;
            break;
        case 5:
            self.volume = 0.72f;
            break;
        case 6:
            self.volume = 0.85f;
            break;
        case 7:
            self.volume = 1.0f;
            break;
    }
    [self playSoundID:UPSoundIDNone];
}

#pragma mark - Internal

- (void)_playSound:(UPSound *)sound
{
    AVAudioPlayerNode *player = sound.player;
    [player scheduleBuffer:sound.buffer atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:^{
        sound.playing = NO;
    }];
    sound.playing = YES;
    @try {
        [player play];
    }
    @catch (NSException *exception) {
        sound.playing = NO;
        LOG(General, "exception playing sound: %@", exception);
    }
}

- (UPSound *)_createSoundWithFilePath:(NSString *)filePath error:(NSError **)error
{
    NSError *localError = nil;
    
    UPSound *sound = [[UPSound alloc] init];
    
    sound.player = [[AVAudioPlayerNode alloc] init];
    [self.engine attachNode:sound.player];

    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    sound.file = [[AVAudioFile alloc] initForReading:fileURL error:&localError];
    if (localError) {
        LOG(Sound, "bad sound file: %@", &localError);
        sound = nil;
        if (error) {
            *error = localError;
        }
    }
    else {
        AVAudioChannelLayout *channelLayout = [[AVAudioChannelLayout alloc] initWithLayoutTag:kAudioChannelLayoutTag_Stereo];
        AVAudioFormat *channelFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100.0
                                                                       interleaved:NO channelLayout:channelLayout];
        sound.buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:channelFormat frameCapacity:AVAudioFrameCount(sound.file.length)];
        [sound.file readIntoBuffer:sound.buffer error:error];
        if (localError) {
            LOG(Sound, "bad sound buffer: %@", localError);
            sound = nil;
            if (error) {
                *error = localError;
            }
        }
        else {
            sound.outputMixer = [[AVAudioMixerNode alloc] init];
            [self.engine attachNode:sound.outputMixer];
            [self.engine connect:sound.player to:sound.outputMixer format:sound.file.processingFormat];
            [self.engine connect:sound.outputMixer to:self.engine.mainMixerNode format:sound.file.processingFormat];
            [sound.player prepareWithFrameCount:AVAudioFrameCount(sound.file.length)];
        }
    }
    
    return sound;
}

@end
