//
//  UPDelayedAction.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPAssertions.h"
#import "UPDelayedAction.h"
#import "UPMath.h"
#import "UPTimeSpanning.h"

@interface UPDelayedAction ()

@property (nonatomic, readwrite) UP::Role role;
@property (nonatomic, readwrite) uint32_t serialNumber;

@property (nonatomic, readwrite) UPDelayedActionState state;
@property (nonatomic, readwrite) CFTimeInterval duration;
@property (nonatomic, copy, readwrite) void (^block)(void);

@property (nonatomic, readwrite) CFTimeInterval remainingDuration;
@property (nonatomic) CFTimeInterval previousTick;

@end

static uint32_t _InstanceCount;

@implementation UPDelayedAction

+ (UPDelayedAction *)delayedAction:(const char *)role duration:(CFTimeInterval)duration block:(void (^)(void))block
{
    return [[self alloc] init:role duration:duration block:block];
}

- (instancetype)init:(const char *)role duration:(CFTimeInterval)duration block:(void (^)(void))block
{
    self = [super init];
    self.state = UPDelayedActionStateNone;
    self.role = role;
    self.duration = duration;
    self.remainingDuration = self.duration;
    self.block = block;
    self.serialNumber = UP::next_serial_number();
    
    self.previousTick = 0;

    _InstanceCount++;
    LOG(Leaks, "delay+: %@ (%d)", self, _InstanceCount);

    return self;
}

- (void)dealloc
{
    _InstanceCount--;
    LOG(Leaks, "delay-: %@ (%d)", self, _InstanceCount);
    UP::TimeSpanning::remove(self);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%d : %s> ", self.class, self.serialNumber, self.role];
}

- (void)start
{
    self.state = UPDelayedActionStateRunning;
    [[UPTicker instance] addTicking:self];
    UP::TimeSpanning::add(self);
}

- (void)pause
{
    self.previousTick = 0;
    self.state = UPDelayedActionStatePaused;
    [[UPTicker instance] removeTicking:self];
}

- (void)reset
{
    self.state = UPDelayedActionStateRunning;
    self.remainingDuration = self.duration;
    UP::TimeSpanning::add(self);
}

- (void)cancel
{
    self.previousTick = 0;
    self.state = UPDelayedActionStateCancelled;
    [[UPTicker instance] removeTicking:self];
    UP::TimeSpanning::remove(self);
}

- (void)call
{
    ASSERT(self.state != UPDelayedActionStateCalled);

    UPDelayedAction *ref = self;

    self.state = UPDelayedActionStateCalled;
    [[UPTicker instance] removeTicking:self];
    if (self.block) {
        self.block();
    }

    UP::TimeSpanning::remove(self);
    ref = nil;
}

- (void)tick:(CFTimeInterval)now
{
    if (self.state != UPDelayedActionStateRunning) {
        return;
    }
    if (up_is_fuzzy_zero(self.previousTick)) {
        self.remainingDuration -= UPTickerInterval;
    }
    else {
        self.remainingDuration -= (now - self.previousTick);
    }
    self.previousTick = now;
    self.remainingDuration = UPMaxT(CFTimeInterval, self.remainingDuration, 0);
    if (up_is_fuzzy_zero(self.remainingDuration)) {
        [self call];
    }
}

@end
