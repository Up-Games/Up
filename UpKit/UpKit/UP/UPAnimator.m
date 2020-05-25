//
//  UPAnimator.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPAssertions.h"
#import "UPAnimator.h"
#import "UPTickingAnimator.h"

@interface UPAnimator ()
@property (nonatomic) NSObject<UIViewAnimating> *inner;
@end

@implementation UPAnimator

+ (UPAnimator *)fadeOutViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveEaseOut animations:^{
        for (UIView *view in views) {
            view.alpha = 0;
        }
    }];
    if (completion) {
        [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    return [[self alloc] initWithInnerAnimator:animator];
}

+ (UPAnimator *)shakeViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration offset:(UIOffset)offset
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    __block UIOffset roffset = UIOffsetZero;
    UPTickingAnimator *animator = [UPTickingAnimator animatorWithDuration:duration
        unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear]
        applier:^(UPTickingAnimator *animator, CGFloat fractionCompleted) {
            CGFloat factor = sin(5 * M_PI * fractionCompleted);
            UIOffset foffset = UIOffsetMake(factor * offset.horizontal, factor * offset.vertical);
            UIOffset doffset = UIOffsetMake(foffset.horizontal - roffset.horizontal, foffset.vertical - roffset.vertical);
            roffset = foffset;
            for (UIView *view in views) {
                view.transform = CGAffineTransformTranslate(view.transform, doffset.horizontal, doffset.vertical);
            }
        }
        completion:^(UPTickingAnimator *animator, UIViewAnimatingPosition finalPosition) {
            if (completion) {
                completion(finalPosition);
            }
        }
    ];
    return [[self alloc] initWithInnerAnimator:animator];
}

+ (UPAnimator *)slideViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration offset:(UIOffset)offset
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
        curve:UIViewAnimationCurveLinear animations:^{
            for (UIView *view in views) {
                view.transform = CGAffineTransformTranslate(view.transform, offset.horizontal, offset.vertical);
            }
        }
    ];
    if (completion) {
        [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    return [[self alloc] initWithInnerAnimator:animator];
}

+ (UPAnimator *)springViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration offset:(UIOffset)offset
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:0.7
         animations:^{
            for (UIView *view in views) {
                view.transform = CGAffineTransformTranslate(view.transform, offset.horizontal, offset.vertical);
            }
        }
    ];
    if (completion) {
        [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    return [[self alloc] initWithInnerAnimator:animator];
}

+ (UPAnimator *)bloopViews:(NSArray<UIView *> *)views withDuration:(CFTimeInterval)duration position:(CGPoint)position
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:0.7 animations:^{
        for (UIView *view in views) {
            view.center = position;
        }
    }];
    if (completion) {
        [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    return [[self alloc] initWithInnerAnimator:animator];
}

- (instancetype)initWithInnerAnimator:(NSObject<UIViewAnimating> *)inner
{
    self = [super init];
    self.inner = inner;
    return self;
}

- (void)startAnimation
{
    [self.inner startAnimation];
}

- (void)startAnimationAfterDelay:(NSTimeInterval)delay
{
    [self.inner startAnimationAfterDelay:delay];
}

- (void)pauseAnimation
{
    [self.inner pauseAnimation];
}

- (void)stopAnimation:(BOOL)withoutFinishing
{
    [self.inner stopAnimation:withoutFinishing];
}

- (void)finishAnimationAtPosition:(UIViewAnimatingPosition)finalPosition
{
    [self.inner finishAnimationAtPosition:finalPosition];
}

@dynamic state;
- (UIViewAnimatingState)state
{
    return self.inner.state;
}

@dynamic running;
- (BOOL)isRunning
{
    return self.inner.isRunning;
}

@dynamic reversed;
- (BOOL)isReversed
{
    return self.inner.isReversed;
}

@dynamic fractionComplete;
- (CGFloat)fractionComplete
{
    return self.inner.fractionComplete;
}

@end
