//
//  UPTicker.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIScreen.h>

#import "UPAssertions.h"
#import "UPMacros.h"
#import "UPTickingAnimator.h"

CFTimeInterval UPTickerInterval = 1.0 / 60.0;

@interface UPTicker ()
@property (nonatomic) NSMutableSet<NSObject<UPTicking> *> *tickings;
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

    self.tickings = [NSMutableSet set];

    return self;
}

- (void)addTicking:(UPTickingAnimator *)animator
{
    [self.tickings addObject:animator];
    [self _startDisplayLinkIfNeeded];
}

- (void)removeTicking:(UPTickingAnimator *)animator
{
    [self.tickings removeObject:animator];
    [self _stopDisplayLinkIfNoTickings];
}

- (void)removeAllTickings
{
    [self.tickings removeAllObjects];
    [self stop];
}

- (void)start
{
    [self _startDisplayLinkIfNeeded];
}

- (void)stop
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

static BOOL tickIntervalChecked = NO;

- (void)_tick:(CADisplayLink *)sender
{
    if (UNLIKELY(!tickIntervalChecked)) {
        tickIntervalChecked = YES;
        UPTickerInterval = self.displayLink.duration;
    }
    CFTimeInterval now = CACurrentMediaTime();
    for (UPTickingAnimator *animator in self.tickings) {
        [animator tick:now];
    }
}

- (void)_startDisplayLinkIfNeeded
{
    if (!self.displayLink || self.tickings.count > 0) {
        tickIntervalChecked = NO;
        self.displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(_tick:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)_stopDisplayLinkIfNoTickings
{
    if (self.tickings.count == 0) {
        [self stop];
    }
}

@end
