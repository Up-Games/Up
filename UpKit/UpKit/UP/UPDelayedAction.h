//
//  UPDelayedAction.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UPKit/UPTicker.h>
#import <UPKit/UPTimeSpanning.h>

typedef NS_ENUM(NSInteger, UPDelayedActionState) {
    UPDelayedActionStateNone,
    UPDelayedActionStateRunning,
    UPDelayedActionStatePaused,
    UPDelayedActionStateCalled,
    UPDelayedActionStateCancelled,
};

@interface UPDelayedAction : NSObject <UPTicking, UPTimeSpanning>

@property (nonatomic, readonly) UP::Band band;
@property (nonatomic, readonly) uint32_t serialNumber;

@property (nonatomic, readonly) UPDelayedActionState state;
@property (nonatomic, readonly) CFTimeInterval duration;
@property (nonatomic, copy, readonly) void (^block)(void);

@property (nonatomic, readonly) CFTimeInterval remainingDuration;

+ (UPDelayedAction *)delayedAction:(const char *)band duration:(CFTimeInterval)duration block:(void (^)(void))block;

- (instancetype)init NS_UNAVAILABLE;

- (void)start;
- (void)pause;
- (void)reset;
- (void)cancel;

@end
