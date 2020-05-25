//
//  UPTicker.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class UPTickAnimator;

@interface UPTicker : NSObject

@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) NSMutableSet<UPTickAnimator *> *animators;

+ (UPTicker *)instance;

- (void)addAnimator:(UPTickAnimator *)animator;
- (void)removeAnimator:(UPTickAnimator *)animator;

@end

@interface NSObject (UPTicking)
- (void)tick:(CFTimeInterval)currentTick;
@end
