//
//  UPGameTimer.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UPGameTimer.h"
#import "UPMath.h"

const CFTimeInterval UPGameTimerInterval = 0.1;
const CFTimeInterval UPGameTimerDefaultDuration = 10;

@interface UPGameTimer ()
@property (nonatomic, readwrite) CFTimeInterval duration;
@property (nonatomic, copy, readwrite) UPGameTimerPeriodicBlock periodicBlock;
@property (nonatomic, readwrite) CFTimeInterval remainingTime;
@property (nonatomic, readwrite) CFTimeInterval now;
@property (nonatomic, readwrite) CFTimeInterval previousPeriodicTime;
@property (nonatomic, readwrite) CFTimeInterval previousCallbackTime;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) NSMutableSet *observers;
@end

@implementation UPGameTimer

+ (UPGameTimer *)defaultGameTimer
{
    return [self gameTimerWithDuration:UPGameTimerDefaultDuration periodicBlock:^BOOL(UPGameTimer *gameTimer) {
        if (gameTimer.remainingTime <= 5) {
            return YES;
        }
        if (gameTimer.elapsedSincePreviousPeriodicCallback >= 1.0 - (UPGameTimerInterval * 0.5)) {
            return YES;
        }
        return NO;
    }];
}

+ (UPGameTimer *)gameTimerWithDuration:(CFTimeInterval)duration periodicBlock:(UPGameTimerPeriodicBlock)periodicBlock
{
    return [[self alloc] initWithDuration:duration periodicBlock:periodicBlock];
}

- (instancetype)initWithDuration:(CFTimeInterval)duration periodicBlock:(UPGameTimerPeriodicBlock)periodicBlock
{
    self = [super init];
    self.duration = UPMaxT(CFTimeInterval, duration, 0.0);
    self.periodicBlock = periodicBlock;
    self.previousPeriodicTime = 0;
    self.previousCallbackTime = 0;
    self.observers = [NSMutableSet set];
    return self;
}

- (void)start
{
    if (self.timer) {
        return;
    }
    self.startTime = CACurrentMediaTime();
    self.previousPeriodicTime = self.startTime;
    self.previousCallbackTime = self.startTime;
    self.remainingTime = self.duration;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:UPGameTimerInterval repeats:YES block:^(NSTimer *timer) {
        CFTimeInterval now = CACurrentMediaTime();
        self.now = now;
        CFTimeInterval elapsed = now - self.startTime;
        self.remainingTime = UPMaxT(CFTimeInterval, self.duration - elapsed, 0.0);
        BOOL sendUpdate = YES;
        if (self.periodicBlock) {
            sendUpdate = self.periodicBlock(self);
        }
        if (sendUpdate) {
            for (id observer in self.observers) {
                [observer gameTimerPeriodicUpdate:self];
            }
            self.previousPeriodicTime = now;
        }
        self.previousCallbackTime = now;
        if (self.remainingTime <= 0) {
            [self stop];
        }
    }];
    for (id observer in self.observers) {
        [observer gameTimerStarted:self];
    }
}

- (void)stop
{
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
    for (id observer in self.observers) {
        [observer gameTimerStopped:self];
    }
}

- (void)reset
{
    [self stop];
    CFTimeInterval now = CACurrentMediaTime();
    self.startTime = now;
    self.remainingTime = self.duration;
    for (id observer in self.observers) {
        [observer gameTimerReset:self];
    }
    [self start];
}

@dynamic elapsedSincePreviousPeriodicCallback;
- (CFTimeInterval)elapsedSincePreviousPeriodicCallback
{
    return self.now - self.previousPeriodicTime;
}

@dynamic elapsedSincePreviousCallback;
- (CFTimeInterval)elapsedSincePreviousCallback
{
    return self.now - self.previousCallbackTime;
}

- (void)addObserver:(NSObject<UPGameTimerObserver> *)observer
{
    [self.observers addObject:observer];
}

- (void)removeObserver:(NSObject<UPGameTimerObserver> *)observer
{
    [self.observers removeObject:observer];
}

@end
