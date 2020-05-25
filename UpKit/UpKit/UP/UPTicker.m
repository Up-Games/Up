//
//  UPTicker.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIScreen.h>

#import "UPAssertions.h"
#import "UPMacros.h"
#import "UPTicker.h"
#import "UPTickAnimator.h"

CFTimeInterval UPTickerInterval = 1.0 / 60.0;

@interface UPTicker ()
@property (nonatomic) CADisplayLink *displayLink;
@end

@implementation UPTicker

+ (UPTicker *)instance
{
    static dispatch_once_t onceToken;
    static UPTicker *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] _init];
    });
    return instance;
}

- (instancetype)_init
{
    self = [super init];

    self.animators = [NSMutableSet set];

    return self;
}

- (void)addAnimator:(UPTickAnimator *)animator
{
    [self.animators addObject:animator];
    [self _startDisplayLinkIfNeeded];
}

- (void)removeAnimator:(UPTickAnimator *)animator
{
    [self.animators removeObject:animator];
    [self _stopDisplayLinkIfNoTickers];
}

- (void)_tick:(CADisplayLink *)sender
{
    static BOOL tickIntervalChecked = NO;
    if (UNLIKELY(!tickIntervalChecked)) {
        tickIntervalChecked = YES;
        UPTickerInterval = self.displayLink.duration;
    }
    CFTimeInterval now = CACurrentMediaTime();
    for (UPTickAnimator *animator in self.animators) {
        [animator tick:now];
    }
}

- (void)_startDisplayLinkIfNeeded
{
    if (!self.displayLink || self.animators.count > 0) {
        self.displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(_tick:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)_stopDisplayLinkIfNoTickers
{
    if (self.animators.count == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

@end
