//
//  UPSoundPlayer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UpKit/UPMacros.h>
#import <UpKit/UPMath.h>

typedef NS_ENUM(NSInteger, UPSoundID) {
    UPSoundIDNone,
    UPSoundIDTap,
    UPSoundIDHappy1,
    UPSoundIDHappy2,
    UPSoundIDHappy3,
    UPSoundIDHappy4,
    UPSoundIDSad1,
    UPSoundIDSad2,
    UPSoundIDWhup,
    UPSoundIDWhoop,
};

struct UPSoundPlayProperties {
    float volume;
    CFTimeInterval beginTimeOffset;
    CFTimeInterval soundTimeOffset;
};

@interface UPSoundPlayer : NSObject

@property (nonatomic) float systemVolume;

+ (UPSoundPlayer *)instance;

- (instancetype)init NS_UNAVAILABLE;

- (NSError *)setFilePath:(NSString *)filePath forSoundID:(UPSoundID)soundID concurrentCount:(NSUInteger)concurrentCount;

- (NSError *)playSoundID:(UPSoundID)soundID;
- (NSError *)playSoundID:(UPSoundID)soundID volume:(float)volume;
- (NSError *)playSoundID:(UPSoundID)soundID properties:(UPSoundPlayProperties)properties;

- (void)pauseSoundID:(UPSoundID)soundID;
- (void)pauseAll;

- (void)fastPlaySoundID:(UPSoundID)soundID volume:(float)volume;

@end
