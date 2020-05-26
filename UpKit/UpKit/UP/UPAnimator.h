//
//  UPAnimator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UpTimeSpanning.h>

@interface UPAnimator : NSObject <UIViewAnimating, UPTimeSpanning>

+ (UPAnimator *)bloopAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    position:(CGPoint)position completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)fadeAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)shakeAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)slideAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)springAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

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
@property(nonatomic, readonly) const char *label;
@property(nonatomic, readonly) uint32_t serialNumber;
- (void)start;
- (void)pause;
- (void)reset;
- (void)cancel;

@end
