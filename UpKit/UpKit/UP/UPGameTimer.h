//
//  UPGameTimer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UPKit/UPMacros.h>

extern const CFTimeInterval UPGameTimerInterval;
extern const CFTimeInterval UPGameTimerDefaultDuration;

@class UPGameTimer;
@protocol UPGameTimerObserver;

typedef BOOL (^UPGameTimerPeriodicBlock)(UPGameTimer *);

@interface UPGameTimer : NSObject

@property (nonatomic, readonly) CFTimeInterval duration;
@property (nonatomic, copy, readonly) UPGameTimerPeriodicBlock periodicBlock;
@property (nonatomic, readonly) CFTimeInterval remainingTime;
@property (nonatomic, readonly) CFTimeInterval now;
@property (nonatomic, readonly) CFTimeInterval previousPeriodicTime;
@property (nonatomic, readonly) CFTimeInterval previousCallbackTime;
@property (nonatomic, readonly) CFTimeInterval elapsedSincePreviousPeriodicCallback;
@property (nonatomic, readonly) CFTimeInterval elapsedSincePreviousCallback;

+ (UPGameTimer *)defaultGameTimer;
+ (UPGameTimer *)gameTimerWithDuration:(CFTimeInterval)duration periodicBlock:(UPGameTimerPeriodicBlock)periodicBlock;
- (instancetype)initWithDuration:(CFTimeInterval)duration periodicBlock:(UPGameTimerPeriodicBlock)periodicBlock;

- (void)start;
- (void)stop;
- (void)reset;

- (void)addObserver:(NSObject<UPGameTimerObserver> *)observer;
- (void)removeObserver:(NSObject<UPGameTimerObserver> *)observer;

@end

@protocol UPGameTimerObserver <NSObject>
- (void)gameTimerStarted:(UPGameTimer *)gameTimer;
- (void)gameTimerStopped:(UPGameTimer *)gameTimer;
- (void)gameTimerReset:(UPGameTimer *)gameTimer;
- (void)gameTimerPeriodicUpdate:(UPGameTimer *)gameTimer;
@end
