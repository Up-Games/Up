//
//  UPSoundPlayer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UpKit/UPMacros.h>
#import <UpKit/UPMath.h>

typedef NS_ENUM(NSInteger, UPSoundID) {
    UPSoundIDNone,
    UPSoundIDTick,
    UPSoundIDHappy1,
    UPSoundIDHappy2,
    UPSoundIDHappy3,
    UPSoundIDHappy4,
    UPSoundIDSad1,
    UPSoundIDSad2,
    UPSoundIDWhup,
    UPSoundIDClear,
    UPSoundIDGameOver,
    UPSoundIDTune1Intro,
    UPSoundIDTune1,
    UPSoundIDTune1Outro,
    UPSoundIDTune2Intro,
    UPSoundIDTune2,
    UPSoundIDTune2Outro,
    UPSoundIDTune3Intro,
    UPSoundIDTune3,
    UPSoundIDTune3Outro,
    UPSoundIDTune4Intro,
    UPSoundIDTune4,
    UPSoundIDTune4Outro,
    UPSoundIDTune5Intro,
    UPSoundIDTune5,
    UPSoundIDTune5Outro,
    UPSoundIDTune6Intro,
    UPSoundIDTune6,
    UPSoundIDTune6Outro,
};

UP_STATIC_INLINE UPSoundID up_sound_id_for_tune_number(NSInteger number)
{
    switch (number) {
        default:
        case 1:
            return UPSoundIDTune1;
        case 2:
            return UPSoundIDTune2;
        case 3:
            return UPSoundIDTune3;
        case 4:
            return UPSoundIDTune4;
        case 5:
            return UPSoundIDTune5;
        case 6:
            return UPSoundIDTune6;
    }
}

UP_STATIC_INLINE UPSoundID up_sound_id_for_intro_number(NSInteger number)
{
    switch (number) {
        default:
        case 1:
            return UPSoundIDTune1Intro;
        case 2:
            return UPSoundIDTune2Intro;
        case 3:
            return UPSoundIDTune3Intro;
        case 4:
            return UPSoundIDTune4Intro;
        case 5:
            return UPSoundIDTune5Intro;
        case 6:
            return UPSoundIDTune6Intro;
    }
}

UP_STATIC_INLINE UPSoundID up_sound_id_for_outro_number(NSInteger number)
{
    switch (number) {
        default:
        case 1:
            return UPSoundIDTune1Outro;
        case 2:
            return UPSoundIDTune2Outro;
        case 3:
            return UPSoundIDTune3Outro;
        case 4:
            return UPSoundIDTune4Outro;
        case 5:
            return UPSoundIDTune5Outro;
        case 6:
            return UPSoundIDTune6Outro;
    }
}

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

@end
