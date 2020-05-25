//
//  UPTicker.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class UPTickAnimator;

extern CFTimeInterval UPTickerInterval;

@interface UPTicker : NSObject

@property (nonatomic) NSMutableSet<UPTickAnimator *> *animators;

+ (UPTicker *)instance;
- (instancetype)init NS_UNAVAILABLE;

- (void)addAnimator:(UPTickAnimator *)animator;
- (void)removeAnimator:(UPTickAnimator *)animator;

@end

@interface NSObject (UPTicking)
- (void)tick:(CFTimeInterval)currentTick;
@end
