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

@interface UPSoundPlayer () <AVAudioPlayerDelegate>
{
    std::multimap<UPSoundID, __strong AVAudioPlayer *> m_map;
    std::mutex m_mutex;
}

@property (nonatomic) AVAudioEngine *engine;
@property (nonatomic) AVAudioFile *tapFile;
@property (nonatomic) AVAudioPlayerNode *tapNode;
@property (nonatomic) AVAudioPCMBuffer *tapBuffer;

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
    
    NSError *error = nil;
    self.engine = [[AVAudioEngine alloc] init];
    self.tapNode = [[AVAudioPlayerNode alloc] init];
    [self.engine attachNode:self.tapNode];

    if (error) {
        LOG(Sound, "bad engine: %@", error);
    }
    else {
        NSBundle *bundle = [NSBundle mainBundle];
        NSURL *fileURL = [bundle URLForResource:@"Tile-Tick-E" withExtension:@"aif"];
        self.tapFile = [[AVAudioFile alloc] initForReading:fileURL error:&error];
        if (error) {
            LOG(Sound, "bad file: %@", error);
        }
        else {
            
            AVAudioMixerNode *mainMixer = self.engine.mainMixerNode;
            [self.engine connect:self.tapNode to:mainMixer format:self.tapFile.processingFormat];
            AVAudioChannelLayout *channelLayout = [[AVAudioChannelLayout alloc] initWithLayoutTag:kAudioChannelLayoutTag_Stereo];
            AVAudioFormat *channelFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:44100.0
                                                                      interleaved:NO channelLayout:channelLayout];
            self.tapBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:channelFormat frameCapacity:1024];
            [self.tapFile readIntoBuffer:self.tapBuffer error:&error];
            if (error) {
                LOG(Sound, "bad buffer: %@", error);
            }
        }

        [self.engine startAndReturnError:&error];
        if (error) {
            LOG(Sound, "bad engine: %@", error);
        }
    }
    
    return self;
}

- (NSError *)setFilePath:(NSString *)filePath forSoundID:(UPSoundID)soundID concurrentCount:(NSUInteger)concurrentCount
{
    std::lock_guard<std::mutex> guard(m_mutex);

    m_map.erase(soundID);

    NSError *error = nil;
    
    for (NSUInteger i = 0; i < concurrentCount; i++) {
        AVAudioPlayer *player = [self _createPlayerWithFilePath:filePath soundID:soundID error:&error];
        if (!player) {
            return error;
        }
        m_map.insert({ soundID, player });
    }
    
    return error;
}

- (NSError *)playSoundID:(UPSoundID)soundID
{
    return [self playSoundID:soundID properties:{ 1, 0, 0 }];
}

- (NSError *)playSoundID:(UPSoundID)soundID volume:(float)volume
{
    return [self playSoundID:soundID properties:{ volume, 0, 0 }];
}

- (NSError *)playSoundID:(UPSoundID)soundID properties:(UPSoundPlayProperties)properties
{
    std::lock_guard<std::mutex> guard(m_mutex);
    
    NSError *error = nil;

    BOOL playStarted = NO;
    auto range = m_map.equal_range(soundID);
    for (auto it = range.first; it != range.second; ++it) {
        AVAudioPlayer *player = it->second;
        if (!player.playing) {
            player.volume = self.systemVolume * properties.volume;
            player.currentTime = UPClampT(CFTimeInterval, properties.soundTimeOffset, 0, player.duration);
            if (properties.beginTimeOffset > 0) {
                [player playAtTime:player.deviceCurrentTime + properties.beginTimeOffset];
            }
            else {
                [player play];
            }
            LOG(Sound, "play: %.3f : %.3f", player.deviceCurrentTime, properties.beginTimeOffset);
            playStarted = YES;
            break;
        }
    }
    if (!playStarted) {
        LOG(Sound, "player not available for soundID: %ld", soundID);
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EBUSY userInfo:nil];
    }
    
    return error;
}

- (void)pauseSoundID:(UPSoundID)soundID
{
    std::lock_guard<std::mutex> guard(m_mutex);
    auto range = m_map.equal_range(soundID);
    for (auto it = range.first; it != range.second; ++it) {
        AVAudioPlayer *player = it->second;
        if (player.playing) {
            [player pause];
        }
    }
}

- (void)pauseAll
{
    std::lock_guard<std::mutex> guard(m_mutex);
    for (auto it = m_map.begin(); it != m_map.end(); ++it) {
        AVAudioPlayer *player = it->second;
        if (player.playing) {
            [player pause];
        }
    }
}

#pragma mark - Internal

- (AVAudioPlayer *)_createPlayerWithFilePath:(NSString *)filePath soundID:(UPSoundID)soundID error:(NSError **)error
{
    // lock must already be taken
    ASSERT(!m_mutex.try_lock());

    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:error];
    if (!data) {
        return nil;
    }
    
    AVAudioPlayer *player = [self _createPlayerWithData:data error:error];
    if (!player) {
        return nil;
    }
    
    player.filePath = filePath;
    player.soundID = soundID;
    
    return player;
}

- (AVAudioPlayer *)_createPlayerWithData:(NSData *)data error:(NSError **)error
{
    // lock must already be taken
    ASSERT(!m_mutex.try_lock());

    if (!data) {
        return nil;
    }
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:error];
    if (!player) {
        return nil;
    }
    
    [player prepareToPlay];
    player.delegate = self;
    
    return player;
}

- (NSError *)_replacePlayer:(AVAudioPlayer *)player
{
    // lock must already be taken
    ASSERT(!m_mutex.try_lock());
    
    auto range = m_map.equal_range(player.soundID);
    for (auto it = range.first; it != range.second; ++it) {
        if (player == it->second) {
            [player stop];
            m_map.erase(it);
            break;
        }
    }
    NSError *error = nil;
    AVAudioPlayer *replacedPlayer = [self _createPlayerWithFilePath:player.filePath soundID:player.soundID error:&error];
    if (!replacedPlayer) {
        return error;
    }
    m_map.insert({ replacedPlayer.soundID, replacedPlayer });
    return error;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    std::lock_guard<std::mutex> guard(m_mutex);
    if (!flag) {
        LOG(Sound, "unsuccessful audio play: %ld", player.soundID);
        [self _replacePlayer:player];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    std::lock_guard<std::mutex> guard(m_mutex);
    LOG(Sound, "audio decode error: %ld: %@", player.soundID, error);
    [self _replacePlayer:player];
}


- (void)fastPlaySoundID:(UPSoundID)soundID volume:(float)volume
{
    [self.tapNode scheduleBuffer:self.tapBuffer atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [self.tapNode play];
}


@end
