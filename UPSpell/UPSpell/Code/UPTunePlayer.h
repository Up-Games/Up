//
//  UPTunePlayer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UpKit/UPMacros.h>
#import <UpKit/UPMath.h>

UP_STATIC_INLINE_CONST NSUInteger UPTuneCount = 6;

typedef NS_ENUM(NSInteger, UPTuneID) {
    UPTuneIDNone,
    UPTuneID1,
    UPTuneID2,
    UPTuneID3,
    UPTuneID4,
    UPTuneID5,
    UPTuneID6,
};

typedef NS_ENUM(NSInteger, UPTuneSegment) {
    UPTuneSegmentNone,
    UPTuneSegmentIntro,
    UPTuneSegmentMain,
    UPTuneSegmentOutro,
    UPTuneSegmentOver,
};

struct UPTuneProperties {
    float volume;
    BOOL volumeOverride;
    CFTimeInterval beginTimeOffset;
    CFTimeInterval soundTimeOffset;
};

@interface UPTunePlayer : NSObject

@property (nonatomic) float volume;

+ (UPTunePlayer *)instance;

- (instancetype)init NS_UNAVAILABLE;

- (NSError *)setFilePath:(NSString *)filePath forTuneID:(UPTuneID)tuneID segment:(UPTuneSegment)segment;

- (NSError *)playTuneID:(UPTuneID)tuneID segment:(UPTuneSegment)segment properties:(UPTuneProperties)properties;

- (void)stop;
- (void)clear;

- (void)setVolumeFromLevel:(NSUInteger)level;

@end
