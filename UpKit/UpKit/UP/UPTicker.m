//
//  UPTicker.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIScreen.h>

#import "UPTicker.h"
#import "UPTickAnimator.h"

@implementation UPTicker

+ (UPTicker *)instance
{
    static dispatch_once_t onceToken;
    static UPTicker *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];

    self.animators = [NSMutableSet set];

    return self;
}

- (void)addAnimator:(UPTickAnimator *)animator
{
    [self.animators addObject:animator];

    if (self.displayLink) {
        return;
    }

    self.displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(_tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)removeAnimator:(UPTickAnimator *)animator
{
    [self.animators removeObject:animator];

    if (self.animators.count == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)_tick:(CADisplayLink *)sender
{
    CFTimeInterval currentTick = CACurrentMediaTime();
    for (UPTickAnimator *animator in self.animators) {
        [animator tick:currentTick];
    }
}

@end
