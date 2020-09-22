//
//  UPSoundPlayer.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
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
    UPSoundIDWhoops,
};

@interface UPSoundPlayer : NSObject

@property (nonatomic) float volume;

+ (UPSoundPlayer *)instance;

- (instancetype)init NS_UNAVAILABLE;

- (void)reset;

- (NSError *)setFilePath:(NSString *)filePath forSoundID:(UPSoundID)soundID volume:(float)volume playerCount:(NSUInteger)playerCount;

- (void)playSoundID:(UPSoundID)soundID;

- (void)prepare;
- (void)stop;

- (void)setVolumeFromLevel:(NSUInteger)level;

@end
