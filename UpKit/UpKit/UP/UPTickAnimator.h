//
//  UPTickAnimator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewAnimating.h>
#import <UPKit/UPUnitFunction.h>

@class UPTickAnimator;

typedef void (^UPTickAnimatorApplier)(UPTickAnimator *animator, CGFloat fractionCompleted);
typedef void (^UPTickAnimatorCompletion)(UPTickAnimator *animator, UIViewAnimatingPosition finalPosition);

@interface UPTickAnimator : NSObject <UIViewAnimating>

+ (UPTickAnimator *)animatorWithDuration:(CFTimeInterval)duration unitFunction:(UPUnitFunction *)unitFunction
    applier:(UPTickAnimatorApplier)applier completion:(UPTickAnimatorCompletion)completion;

+ (UPTickAnimator *)animatorWithDuration:(CFTimeInterval)duration unitFunction:(UPUnitFunction *)unitFunction
    repeatCount:(NSUInteger)repeatCount rebounds:(BOOL)rebounds
        applier:(UPTickAnimatorApplier)applier completion:(UPTickAnimatorCompletion)completion;

@property (nonatomic, readonly) UIViewAnimatingState state;
@property (nonatomic, readonly, getter=isRunning) BOOL running;
@property (nonatomic) CGFloat fractionComplete;

// In my opinion, this is a poorly-defined API that complicates the implementation beyond the possible utility.
// UPTickAnimator does not implement it. Asserts if called.
@property (nonatomic, getter=isReversed) BOOL reversed;

- (void)startAnimation;
- (void)startAnimationAfterDelay:(NSTimeInterval)delay;
- (void)pauseAnimation;
- (void)stopAnimation:(BOOL)withoutFinishing;
- (void)finishAnimationAtPosition:(UIViewAnimatingPosition)finalPosition;

@end
