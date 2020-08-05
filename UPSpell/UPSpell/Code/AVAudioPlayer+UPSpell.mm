//
//  AVAudioPlayer+UPSpell.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>

#import "AVAudioPlayer+UPSpell.h"

@implementation AVAudioPlayer (UPSpell)

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

@dynamic tuneID;
- (void)setTuneID:(UPTuneID)tuneID
{
    objc_setAssociatedObject(self, @selector(tuneID), @(tuneID), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UPTuneID)tuneID
{
    id obj = objc_getAssociatedObject(self, @selector(tuneID));
    return obj ? (UPTuneID)[obj unsignedIntegerValue] : UPTuneIDNone;
}

@dynamic segment;
- (void)setSegment:(UPTuneSegment)segment
{
    objc_setAssociatedObject(self, @selector(segment), @(segment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UPTuneSegment)segment
{
    id obj = objc_getAssociatedObject(self, @selector(segment));
    return obj ? (UPTuneSegment)[obj unsignedIntegerValue] : UPTuneSegmentNone;
}

@end
