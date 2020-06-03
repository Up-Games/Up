//
//  UPAnimator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <limits>

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>
#import <UpKit/UPTimeSpanning.h>

namespace UP {
    static constexpr CGFloat NotACoordinate = std::numeric_limits<CGFloat>::quiet_NaN();
}

@interface UPAnimator : NSObject <UIViewAnimating, UPTimeSpanning>

+ (UPAnimator *)bloopAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    position:(CGPoint)position completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)fadeAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)shakeAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)slideAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)slideToAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    point:(CGPoint)point completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)springAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)setColorAnimatorWithRole:(UP::Role)role controls:(NSArray<UPControl *> *)controls duration:(CFTimeInterval)duration
    element:(UPControlElement)element fromControlState:(UPControlState)fromControlState toControlState:(UPControlState)toControlState
        completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

// UPAnimator

@property (nonatomic, readonly) NSArray<UIView *> *views;
- (instancetype)init NS_UNAVAILABLE;

// UIViewAnimating

@property(nonatomic, readonly) UIViewAnimatingState state;
@property(nonatomic, readonly, getter=isRunning) BOOL running;
@property(nonatomic, getter=isReversed) BOOL reversed;
@property(nonatomic) CGFloat fractionComplete;

- (void)startAnimation;
- (void)startAnimationAfterDelay:(NSTimeInterval)delay;
- (void)pauseAnimation;
- (void)stopAnimation:(BOOL)withoutFinishing;
- (void)finishAnimationAtPosition:(UIViewAnimatingPosition)finalPosition;

// UPTimeSpanning
@property(nonatomic, readonly) UP::Role role;
@property(nonatomic, readonly) uint32_t serialNumber;
- (void)start;
- (void)pause;
- (void)reset;
- (void)cancel;

@end