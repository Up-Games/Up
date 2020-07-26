//
//  UPSoundPlayer.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>
#import <mutex>

#import <objc/runtime.h>

#import <AVFoundation/AVFoundation.h>

#import <UpKit/UPAssertions.h>

#import "UPSoundPlayer.h"

// =========================================================================================================================================

@interface AVAudioPlayer (UP)
@property (nonatomic) NSString *filePath;
@property (nonatomic) UPSoundID soundID;
@end

@implementation AVAudioPlayer (UP)

@dynamic filePath;
- (void)setFilePath:(NSString *)filePath
{
    objc_setAssociatedObject(self, @selector(filePath), filePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)filePath
{
    return objc_getAssociatedObject(self, @selector(filePath));
}

@dynamic soundID;
- (void)setSoundID:(UPSoundID)soundID
{
    objc_setAssociatedObject(self, @selector(soundID), @(soundID), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UPSoundID)soundID
{
    id obj = objc_getAssociatedObject(self, @selector(soundID));
    return obj ? (UPSoundID)[obj unsignedIntegerValue] : UPSoundIDNone;
}

@end

// =========================================================================================================================================

@interface UPSoundPlayer () <AVAudioPlayerDelegate>
{
    std::multimap<UPSoundID, __strong AVAudioPlayer *> m_map;
    std::mutex m_mutex;
}
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
            LOG(Audio, "player device time: %.3f", player.deviceCurrentTime);
            playStarted = YES;
            break;
        }
    }
    if (!playStarted) {
        LOG(Audio, "player not available for soundID: %ld", soundID);
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [player prepareToPlay];
    });
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
        LOG(Audio, "unsuccessful audio play: %ld", player.soundID);
        [self _replacePlayer:player];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    std::lock_guard<std::mutex> guard(m_mutex);
    LOG(Audio, "audio decode error: %ld: %@", player.soundID, error);
    [self _replacePlayer:player];
}

@end
