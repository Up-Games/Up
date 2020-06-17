//
//  UPTickingAnimator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewAnimating.h>
#import <UPKit/UPBand.h>
#import <UPKit/UPTicker.h>

@class UPTickingAnimator;
@class UPUnitFunction;

typedef void (^UPTickingAnimatorApplier)(UPTickingAnimator *animator);
typedef void (^UPTickingAnimatorCompletion)(UPTickingAnimator *animator, UIViewAnimatingPosition finalPosition);

@interface UPTickingAnimator : NSObject <UIViewAnimating, UPTicking>

+ (UPTickingAnimator *)animatorInBand:(UP::Band)band duration:(CFTimeInterval)duration unitFunction:(UPUnitFunction *)unitFunction
    applier:(UPTickingAnimatorApplier)applier completion:(UPTickingAnimatorCompletion)completion;

+ (UPTickingAnimator *)animatorInBand:(UP::Band)band duration:(CFTimeInterval)duration unitFunction:(UPUnitFunction *)unitFunction
    repeatCount:(NSUInteger)repeatCount rebounds:(BOOL)rebounds
        applier:(UPTickingAnimatorApplier)applier completion:(UPTickingAnimatorCompletion)completion;

// UPTickingAnimator
@property (nonatomic, readonly) UP::Band band;
@property (nonatomic) CGFloat previousFractionComplete;

// UIViewAnimating
@property (nonatomic, readonly) UIViewAnimatingState state;
@property (nonatomic, readonly, getter=isRunning) BOOL running;
@property (nonatomic) CGFloat fractionComplete;

// In my opinion, this is a poorly-defined API that complicates the implementation beyond the possible utility.
// UPTickingAnimator does not implement it. Asserts if called.
@property (nonatomic, getter=isReversed) BOOL reversed;

- (void)startAnimation;
- (void)startAnimationAfterDelay:(NSTimeInterval)delay;
- (void)pauseAnimation;
- (void)stopAnimation:(BOOL)withoutFinishing;
- (void)finishAnimationAtPosition:(UIViewAnimatingPosition)finalPosition;

// UPTicking
@property (nonatomic, readonly) uint32_t serialNumber;
- (void)tick:(CFTimeInterval)now;

// aid in breaking retain cycles
- (void)clearBlocks;

@end
