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

@interface UPGameTimer : NSObject

@property (nonatomic, readonly) CFTimeInterval duration;
@property (nonatomic, readonly) CFTimeInterval elapsedTime;
@property (nonatomic, readonly) CFTimeInterval remainingTime;
@property (nonatomic, readonly) CFTimeInterval now;
@property (nonatomic, readonly) CFTimeInterval previousCallbackTime;
@property (nonatomic, readonly) CFTimeInterval elapsedSincePreviousCallback;
@property (nonatomic, readonly) BOOL isRunning;

+ (UPGameTimer *)defaultGameTimer;
+ (UPGameTimer *)gameTimerWithDuration:(CFTimeInterval)duration;
- (instancetype)initWithDuration:(CFTimeInterval)duration;

- (void)start;
- (void)stop;
- (void)reset;
- (void)resetTo:(CFTimeInterval)remainingTime;
- (void)cancel;

- (void)addObserver:(NSObject<UPGameTimerObserver> *)observer;
- (void)removeObserver:(NSObject<UPGameTimerObserver> *)observer;
- (void)notifyObservers;

@end

@protocol UPGameTimerObserver <NSObject>
- (void)gameTimerStarted:(UPGameTimer *)gameTimer;
- (void)gameTimerStopped:(UPGameTimer *)gameTimer;
- (void)gameTimerReset:(UPGameTimer *)gameTimer;
- (void)gameTimerUpdated:(UPGameTimer *)gameTimer;
- (void)gameTimerExpired:(UPGameTimer *)gameTimer; // ran to full duration
- (void)gameTimerCanceled:(UPGameTimer *)gameTimer;
@end
