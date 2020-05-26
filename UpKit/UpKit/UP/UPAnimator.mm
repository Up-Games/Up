//
//  UPAnimator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPAssertions.h"
#import "UPAnimator.h"
#import "UPTickingAnimator.h"
#import "UPUnitFunction.h"

@interface UPAnimator ()
@property (nonatomic, readwrite) const char *label;
@property (nonatomic, readwrite) uint32_t serialNumber;
@property (nonatomic) NSObject<UIViewAnimating> *inner;
@end

@implementation UPAnimator

+ (UPAnimator *)bloopAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    position:(CGPoint)position completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
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
    return [[self alloc] initWithLabel:label innerAnimator:animator];
}

+ (UPAnimator *)fadeAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;
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
    return [[self alloc] initWithLabel:label innerAnimator:animator];
}

+ (UPAnimator *)shakeAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
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
    return [[self alloc] initWithLabel:label innerAnimator:animator];
}

+ (UPAnimator *)slideAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
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
    return [[self alloc] initWithLabel:label innerAnimator:animator];
}

+ (UPAnimator *)springAnimatorWithLabel:(const char *)label views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
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
    return [[self alloc] initWithLabel:label innerAnimator:animator];
}

- (instancetype)initWithLabel:(const char *)label innerAnimator:(NSObject<UIViewAnimating> *)inner
{
    self = [super init];
    self.label = label;
    self.inner = inner;
    self.serialNumber = UP::next_serial_number();
    return self;
}

- (void)dealloc
{
    UP::TimeSpanning::remove(self);
}

#pragma mark - UIViewAnimating

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

- (void)setFractionComplete:(CGFloat)fractionComplete
{
    self.inner.fractionComplete = fractionComplete;
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

#pragma mark - UPTimeSpanning

- (void)start
{
    [self.inner startAnimation];
}

- (void)pause
{
    [self.inner pauseAnimation];
}

- (void)reset
{
    self.inner.fractionComplete = 0;
}

- (void)cancel
{
    [self.inner stopAnimation:NO];
}

@end
