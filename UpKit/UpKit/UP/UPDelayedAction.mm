//
//  UPDelayedAction.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPAssertions.h"
#import "UPMacros.h"
#import "UPDelayedAction.h"
#import "UPMath.h"
#import "UPTimeSpanning.h"

@interface UPDelayedAction ()

@property (nonatomic, readwrite) UP::Band band;
@property (nonatomic, readwrite) uint32_t serialNumber;

@property (nonatomic, readwrite) UPDelayedActionState state;
@property (nonatomic, readwrite) CFTimeInterval duration;
@property (nonatomic, copy, readwrite) void (^block)(void);

@property (nonatomic, readwrite) CFTimeInterval remainingDuration;
@property (nonatomic) CFTimeInterval previousTick;

@end

static uint32_t _InstanceCount;

@implementation UPDelayedAction

+ (UPDelayedAction *)delayedAction:(const char *)band duration:(CFTimeInterval)duration block:(void (^)(void))block
{
    return [[self alloc] init:band duration:duration block:block];
}

- (instancetype)init:(const char *)band duration:(CFTimeInterval)duration block:(void (^)(void))block
{
    self = [super init];
    self.state = UPDelayedActionStateNone;
    self.band = band;
    self.duration = duration;
    self.remainingDuration = self.duration;
    self.block = block;
    self.serialNumber = UP::next_serial_number();
    
    self.previousTick = CACurrentMediaTime();

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
    return [NSString stringWithFormat:@"<%@:%d : %s> ", self.class, self.serialNumber, self.band];
}

- (void)start
{
    self.previousTick = CACurrentMediaTime();
    self.state = UPDelayedActionStateRunning;
    [[UPTicker instance] addTicking:self];
    UP::TimeSpanning::add(self);
}

- (void)pause
{
    self.previousTick = CACurrentMediaTime();
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
    self.previousTick = CACurrentMediaTime();
    self.state = UPDelayedActionStateCancelled;
    [[UPTicker instance] removeTicking:self];
    UP::TimeSpanning::remove(self);
}

- (void)call
{
    ASSERT(self.state != UPDelayedActionStateCalled);

    UPDelayedAction *ref = self;
    UP_ALLOW_UNUSED(ref);
    
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
    self.remainingDuration -= (now - self.previousTick);
    self.previousTick = now;
    self.remainingDuration = UPMaxT(CFTimeInterval, self.remainingDuration, 0);
    if (up_is_fuzzy_zero(self.remainingDuration)) {
        [self call];
    }
}

@end
