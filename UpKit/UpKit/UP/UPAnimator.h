//
//  UPAnimator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPAnimator : NSObject <UIViewAnimating>

+ (UPAnimator *)fadeOutViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)shakeViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration offset:(UIOffset)offset
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)slideViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration offset:(UIOffset)offset
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)springViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration offset:(UIOffset)offset
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

+ (UPAnimator *)bloopViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration position:(CGPoint)position
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;

@property(nonatomic, readonly) UIViewAnimatingState state;
@property(nonatomic, readonly, getter=isRunning) BOOL running;
@property(nonatomic, getter=isReversed) BOOL reversed;
@property(nonatomic) CGFloat fractionComplete;

- (void)startAnimation;
- (void)startAnimationAfterDelay:(NSTimeInterval)delay;
- (void)pauseAnimation;
- (void)stopAnimation:(BOOL)withoutFinishing;
- (void)finishAnimationAtPosition:(UIViewAnimatingPosition)finalPosition;

@end
