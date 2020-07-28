//
//  UPSoundPlayer.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>
#import <mutex>

#import <AVFoundation/AVFoundation.h>

#import <UpKit/UPAssertions.h>

#import "AVAudioPlayer+UPSpell.h"
#import "UPSoundPlayer.h"

// =========================================================================================================================================

@interface UPSound : NSObject
@property (nonatomic) AVAudioFile *file;
@property (nonatomic) AVAudioPlayerNode *player;
@property (nonatomic) AVAudioPCMBuffer *buffer;
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
    
    self.systemVolume = 1.0;
    self.engine = [[AVAudioEngine alloc] init];

    return self;
}

- (NSError *)setFilePath:(NSString *)filePath forSoundID:(UPSoundID)soundID concurrentCount:(NSUInteger)concurrentCount
{
    m_map.erase(soundID);

    NSError *error = nil;
    
    for (NSUInteger i = 0; i < concurrentCount; i++) {
        
        UPSound *sound = [self _createSoundWithFilePath:filePath error:&error];
        if (sound) {
            m_map.insert({ soundID, sound });
        }
    }
    
    return error;
}

- (void)playSoundID:(UPSoundID)soundID
{
    [self playSoundID:soundID volume:1.0];
}

- (void)playSoundID:(UPSoundID)soundID volume:(float)volume
{
    BOOL played = NO;
    auto range = m_map.equal_range(soundID);
    for (auto it = range.first; it != range.second; ++it) {
        UPSound *sound = it->second;
        if (!sound.playing) {
            [self _playSound:sound volume:volume];
            played = YES;
            break;
        }
    }
    if (!played) {
        if (range.first != range.second) {
            UPSound *sound = range.first->second;
            LOG(Sound, "play [backup]: %ld (%.2f)", soundID, volume);
            [self _playSound:sound volume:volume];
        }
        else {
            LOG(Sound, "no player available for soundID: %ld", soundID);
        }
    }
}

- (void)prepare
{
    [self stop];
    
    if (!self.engine.isRunning) {
        NSError *error = nil;
        [self.engine startAndReturnError:&error];
        if (error) {
            LOG(Sound, "error preparing audio engine: %@", error);
        }
    }
}

- (void)stop
{
    for (auto it = m_map.begin(); it != m_map.end(); ++it) {
        UPSound *sound = it->second;
        sound.playing = NO;
        [sound.player pause];
    }
    [self.engine stop];
}

#pragma mark - Internal

- (void)_playSound:(UPSound *)sound volume:(float)volume
{
    AVAudioPlayerNode *player = sound.player;
    player.volume = self.systemVolume * volume;
    [player scheduleBuffer:sound.buffer atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:^{
        sound.playing = NO;
    }];
    sound.playing = YES;
    [player play];
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
            [self.engine connect:sound.player to:self.engine.mainMixerNode format:sound.file.processingFormat];
            [sound.player prepareWithFrameCount:AVAudioFrameCount(sound.file.length)];
        }
    }
    
    return sound;
}

@end
