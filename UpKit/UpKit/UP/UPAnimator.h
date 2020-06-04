//
//  UPAnimator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <limits>

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>
#import <UpKit/UPTimeSpanning.h>
#import <UpKit/UPViewMove.h>

namespace UP {
    static constexpr CGFloat NotACoordinate = std::numeric_limits<CGFloat>::quiet_NaN();
}

@interface UPAnimator : NSObject <UIViewAnimating, UPTimeSpanning>

+ (UPAnimator *)bloopInAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                           completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)bloopOutAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                            completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)fadeAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)shakeAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)slideAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)slideToAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    point:(CGPoint)point completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)slideAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                         completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)setColorAnimatorInBand:(UP::Band)band controls:(NSArray<UPControl *> *)controls duration:(CFTimeInterval)duration
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
@property(nonatomic, readonly) UP::Band band;
@property(nonatomic, readonly) uint32_t serialNumber;
- (void)start;
- (void)pause;
- (void)reset;
- (void)cancel;

@end
