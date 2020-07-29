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
    UPSoundIDTub,
    UPSoundIDWhoop,
};

@interface UPSoundPlayer : NSObject

@property (nonatomic) float mainVolume;

+ (UPSoundPlayer *)instance;

- (instancetype)init NS_UNAVAILABLE;

- (NSError *)setFilePath:(NSString *)filePath forSoundID:(UPSoundID)soundID volume:(float)volume playerCount:(NSUInteger)playerCount;

- (void)playSoundID:(UPSoundID)soundID;

- (void)prepare;
- (void)stop;

@end
