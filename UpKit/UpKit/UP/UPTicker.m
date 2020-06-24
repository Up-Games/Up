//
//  UPTicker.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIScreen.h>

#import "UPAssertions.h"
#import "UPMacros.h"
#import "UPTicker.h"

CFTimeInterval UPTickerInterval = 1.0 / 60.0;

@interface UPTicker ()
@property (nonatomic) NSMutableSet<NSObject<UPTicking> *> *tickings;
@property (nonatomic) NSMutableArray<NSObject<UPTicking> *> *iterationTickings;
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
    self.iterationTickings = [NSMutableArray array];

    return self;
}

- (void)addTicking:(NSObject<UPTicking> *)ticking
{
    [self.tickings addObject:ticking];
    [self _startDisplayLinkIfNeeded];
}

- (void)removeTicking:(NSObject<UPTicking> *)ticking
{
    [self.tickings removeObject:ticking];
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
    [self.iterationTickings removeAllObjects];
    for (NSObject<UPTicking> *ticking in self.tickings) {
        [self.iterationTickings addObject:ticking];
    }
    
    if (self.iterationTickings.count > 1) {
        [self.iterationTickings sortUsingComparator:
            ^NSComparisonResult(id obj1, id obj2) {
                NSObject<UPTicking> *t1 = obj1;
                NSObject<UPTicking> *t2 = obj2;
                if (t1.serialNumber < t2.serialNumber) {
                    return NSOrderedAscending;
                }
                if (t1.serialNumber > t2.serialNumber) {
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
        }];
    }
  
    for (NSObject<UPTicking> *ticking in self.iterationTickings) {
        [ticking tick:now];
    }
}

- (void)_startDisplayLinkIfNeeded
{
    if (self.tickings.count == 0) {
        return;
    }
    if (!self.displayLink) {
        tickIntervalChecked = NO;
        self.displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(_tick:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)_stopDisplayLinkIfNoTickings
{
    if (self.tickings.count == 0) {
        [self stop];
    }
}

@end
