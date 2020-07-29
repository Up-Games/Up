//
//  UPTunePlayer.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>
#import <mutex>

#import <objc/runtime.h>

#import <AVFoundation/AVFoundation.h>

#import <UpKit/UPAssertions.h>

#import "AVAudioPlayer+UPSpell.h"
#import "UPTunePlayer.h"

UP_STATIC_INLINE NSUInteger up_tune_player_key(UPTuneID tuneID, UPTuneSegment segment)
{
    return (segment << 8) | tuneID;
}


@interface UPTunePlayer () <AVAudioPlayerDelegate>
{
    std::map<NSUInteger, __strong AVAudioPlayer *> m_map;
    std::mutex m_mutex;
}

@end

@implementation UPTunePlayer

+ (UPTunePlayer *)instance
{
    static dispatch_once_t onceToken;
    static UPTunePlayer *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPTunePlayer alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    self = [super init];
    
    self.mainVolume = 1.0;
        
    return self;
}

- (NSError *)setFilePath:(NSString *)filePath forTuneID:(UPTuneID)tuneID segment:(UPTuneSegment)segment
{
    std::lock_guard<std::mutex> guard(m_mutex);

    m_map.erase(tuneID);

    NSError *error = nil;
    
    AVAudioPlayer *player = [self _createPlayerWithFilePath:filePath tuneID:tuneID segment:segment error:&error];
    if (!player) {
        return error;
    }
    m_map.insert_or_assign(up_tune_player_key(tuneID, segment), player);
    
    return error;
}

- (NSError *)playTuneID:(UPTuneID)tuneID segment:(UPTuneSegment)segment properties:(UPTuneProperties)properties
{
    std::lock_guard<std::mutex> guard(m_mutex);
    
    NSError *error = nil;

    auto it = m_map.find(up_tune_player_key(tuneID, segment));
    if (it == m_map.end()) {
        LOG(Sound, "no player available for tuneID/segment: %ld/%ld", tuneID, segment);
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EBUSY userInfo:nil];
    }
    else {
        AVAudioPlayer *player = it->second;
        player.volume = self.mainVolume * properties.volume;
        player.currentTime = UPClampT(CFTimeInterval, properties.soundTimeOffset, 0, player.duration);
        if (properties.beginTimeOffset > 0) {
            [player playAtTime:player.deviceCurrentTime + properties.beginTimeOffset];
        }
        else {
            [player play];
        }
    }
    
    return error;
}

- (void)stop
{
    std::lock_guard<std::mutex> guard(m_mutex);
    for (auto it = m_map.begin(); it != m_map.end(); ++it) {
        AVAudioPlayer *player = it->second;
        if (player.playing) {
            [player pause];
        }
    }
}

- (void)clear
{
    [self stop];
    
    std::lock_guard<std::mutex> guard(m_mutex);
    m_map.clear();
}

#pragma mark - Internal

- (AVAudioPlayer *)_createPlayerWithFilePath:(NSString *)filePath tuneID:(UPTuneID)tuneID segment:(UPTuneSegment)segment error:(NSError **)error
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
    player.tuneID = tuneID;
    player.segment = segment;

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
    
    auto range = m_map.equal_range(player.tuneID);
    for (auto it = range.first; it != range.second; ++it) {
        if (player == it->second) {
            [player stop];
            m_map.erase(it);
            break;
        }
    }
    NSError *error = nil;
    AVAudioPlayer *replacement = [self _createPlayerWithFilePath:player.filePath tuneID:player.tuneID segment:player.segment error:&error];
    if (!replacement) {
        return error;
    }
    m_map.insert_or_assign(up_tune_player_key(replacement.tuneID, replacement.segment), replacement);
    return error;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    std::lock_guard<std::mutex> guard(m_mutex);
    if (!flag) {
        LOG(Sound, "unsuccessful tune play: %ld", player.tuneID);
        [self _replacePlayer:player];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    std::lock_guard<std::mutex> guard(m_mutex);
    LOG(Sound, "tune decode error: %ld: %@", player.tuneID, error);
    [self _replacePlayer:player];
}


@end
