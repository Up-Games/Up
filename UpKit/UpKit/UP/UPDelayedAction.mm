//
//  UPDelayedAction.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPDelayedAction.h"
#import "UPMath.h"
#import "UPTimeSpanning.h"

@interface UPDelayedAction ()

@property (nonatomic, readwrite) const char *label;
@property (nonatomic, readwrite) uint32_t serialNumber;

@property (nonatomic, readwrite) UPDelayedActionState state;
@property (nonatomic, readwrite) CFTimeInterval duration;
@property (nonatomic, copy, readwrite) void (^block)(void);

@property (nonatomic, readwrite) CFTimeInterval remainingDuration;
@property (nonatomic) CFTimeInterval previousTick;

@end

@implementation UPDelayedAction

+ (UPDelayedAction *)delayedActionWithLabel:(const char *)label duration:(CFTimeInterval)duration block:(void (^)(void))block
{
    return [[self alloc] initWithLabel:label duration:duration block:block];
}

- (instancetype)initWithLabel:(const char *)label duration:(CFTimeInterval)duration block:(void (^)(void))block
{
    self = [super init];
    self.state = UPDelayedActionStateNone;
    self.label = label;
    self.duration = duration;
    self.remainingDuration = self.duration;
    self.block = block;
    self.serialNumber = UP::TimeSpanning::next_serial_number();
    
    self.previousTick = 0;
    
    return self;
}

- (void)dealloc
{
    UP::TimeSpanning::remove(self);
}

- (void)start
{
    self.state = UPDelayedActionStateRunning;
    [[UPTicker instance] addTicking:self];
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
    [[UPTicker instance] addTicking:self];
}

- (void)cancel
{
    self.previousTick = 0;
    self.state = UPDelayedActionStateCancelled;
    [[UPTicker instance] removeTicking:self];
}

- (void)call
{
    UPDelayedAction *ref = self;

    self.state = UPDelayedActionStateCalled;
    [[UPTicker instance] removeTicking:self];
    if (self.block) {
        self.block();
    }
    
    ref = nil;
}

- (void)tick:(CFTimeInterval)now
{
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
