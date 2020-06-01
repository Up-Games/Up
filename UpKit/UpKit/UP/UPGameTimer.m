//
//  UPGameTimer.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UPGameTimer.h"
#import "UPMath.h"

const CFTimeInterval UPGameTimerInterval = 0.1;
const CFTimeInterval UPGameTimerDefaultDuration = 120;

@interface UPGameTimer ()
@property (nonatomic, readwrite) CFTimeInterval duration;
@property (nonatomic, readwrite) CFTimeInterval remainingTime;
@property (nonatomic, readwrite) CFTimeInterval now;
@property (nonatomic, readwrite) CFTimeInterval previousCallbackTime;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) NSMutableSet *observers;
@end

@implementation UPGameTimer

+ (UPGameTimer *)defaultGameTimer
{
    return [self gameTimerWithDuration:UPGameTimerDefaultDuration];
}

+ (UPGameTimer *)gameTimerWithDuration:(CFTimeInterval)duration
{
    return [[self alloc] initWithDuration:duration];
}

- (instancetype)initWithDuration:(CFTimeInterval)duration
{
    self = [super init];
    self.duration = UPMaxT(CFTimeInterval, duration, 0.0);
    self.remainingTime = self.duration;
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
    self.previousCallbackTime = self.startTime;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:UPGameTimerInterval repeats:YES block:^(NSTimer *timer) {
        CFTimeInterval now = CACurrentMediaTime();
        self.now = now;
        CFTimeInterval elapsed = now - self.previousCallbackTime;
        self.remainingTime = UPMaxT(CFTimeInterval, self.remainingTime - elapsed, 0.0);
        for (id observer in self.observers) {
            [observer gameTimerUpdated:self];
        }
        self.previousCallbackTime = now;
        if (up_is_fuzzy_zero(self.remainingTime)) {
            self.remainingTime = 0.0;
            for (id observer in self.observers) {
                [observer gameTimerExpired:self];
            }
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

@dynamic elapsedTime;
- (CFTimeInterval)elapsedTime
{
    return self.duration - self.remainingTime;
}

@dynamic isRunning;
- (BOOL)isRunning
{
    return self.timer != nil;
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

- (void)notifyObservers
{
    for (id observer in self.observers) {
        [observer gameTimerUpdated:self];
    }
}

@end
