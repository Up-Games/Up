//
//  UPAnimator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UIColor+UP.h"
#import "UPAssertions.h"
#import "UPAnimator.h"
#import "UPBezierPathView.h"
#import "UPGeometry.h"
#import "UPRole.h"
#import "UPTickingAnimator.h"
#import "UPUnitFunction.h"

@interface UPAnimator ()
@property (nonatomic, readwrite) UP::Role role;
@property (nonatomic, readwrite) uint32_t serialNumber;
@property (nonatomic) NSObject<UIViewAnimating> *inner;
@end

static uint32_t _InstanceCount;

@implementation UPAnimator

+ (UPAnimator *)bloopAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    position:(CGPoint)position completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithRole:role];
    UIViewPropertyAnimator *inner = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:0.7 animations:^{
        for (UIView *view in views) {
            view.center = position;
        }
    }];
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(animator);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)fadeAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;
{
    UPAnimator *animator = [[self alloc] _initWithRole:role];
    UIViewPropertyAnimator *inner = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveEaseOut animations:^{
        for (UIView *view in views) {
            view.alpha = 0;
        }
    }];
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(animator);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)shakeAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithRole:role];
    __block UIOffset roffset = UIOffsetZero;
    UPTickingAnimator *inner = [UPTickingAnimator animatorWithRole:role duration:duration
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
        completion:^(UPTickingAnimator *inner, UIViewAnimatingPosition finalPosition) {
            if (completion) {
                completion(finalPosition);
            }
            [inner clearBlocks];
            UP::TimeSpanning::remove(animator);
        }
    ];
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)slideAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithRole:role];
    UIViewPropertyAnimator *inner = [[UIViewPropertyAnimator alloc] initWithDuration:duration
        curve:UIViewAnimationCurveLinear animations:^{
            for (UIView *view in views) {
                view.transform = CGAffineTransformTranslate(view.transform, offset.horizontal, offset.vertical);
            }
        }
    ];
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(animator);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)slideToAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    point:(CGPoint)point completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithRole:role];
    UIViewPropertyAnimator *inner = [[UIViewPropertyAnimator alloc] initWithDuration:duration
        curve:UIViewAnimationCurveEaseInOut animations:^{
            for (UIView *view in views) {
                CGPoint center = up_rect_center(view.frame);
                CGFloat dx = isnan(point.x) ? 0 : point.x - center.x;
                CGFloat dy = isnan(point.y) ? 0 : point.y - center.y;
                view.transform = CGAffineTransformTranslate(view.transform, dx, dy);
            }
        }
    ];
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(animator);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)springAnimatorWithRole:(UP::Role)role views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithRole:role];
    UIViewPropertyAnimator *inner = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:0.7
         animations:^{
            for (UIView *view in views) {
                view.transform = CGAffineTransformTranslate(view.transform, offset.horizontal, offset.vertical);
            }
        }
    ];
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(animator);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)setColorAnimatorWithRole:(UP::Role)role controls:(NSArray<UPControl *> *)controls duration:(CFTimeInterval)duration
    element:(UPControlElement)element fromControlState:(UPControlState)fromControlState toControlState:(UPControlState)toControlState
        completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;
{
    UPAnimator *animator = [[self alloc] _initWithRole:role];
    UPTickingAnimator *inner = [UPTickingAnimator animatorWithRole:role duration:duration
        unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseInEaseOutExpo]
        applier:^(UPTickingAnimator *animator, CGFloat fractionCompleted) {
            if (element & UPControlElementFill) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control fillColorForControlStates:fromControlState];
                    UIColor *c2 = [control fillColorForControlStates:toControlState];
                    control.fillPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:fractionCompleted];
                }
            }
            if (element & UPControlElementStroke) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control strokeColorForControlStates:fromControlState];
                    UIColor *c2 = [control strokeColorForControlStates:toControlState];
                    control.strokePathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:fractionCompleted];
                }
            }
            if (element & UPControlElementContent) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control contentColorForControlStates:fromControlState];
                    UIColor *c2 = [control contentColorForControlStates:toControlState];
                    control.contentPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:fractionCompleted];
                }
            }
        }
        completion:^(UPTickingAnimator *inner, UIViewAnimatingPosition finalPosition) {
            if (completion) {
                completion(finalPosition);
            }
            [inner clearBlocks];
            UP::TimeSpanning::remove(animator);
        }
    ];
    animator.inner = inner;
    return animator;
}

- (instancetype)_initWithRole:(UP::Role)role
{
    ASSERT(role);

    _InstanceCount++;
    LOG(Leaks, "anim+: %@ (%d)", self, _InstanceCount);

    self = [super init];
    self.role = role;
    self.serialNumber = UP::next_serial_number();
    return self;
}

- (void)dealloc
{
    _InstanceCount--;
    LOG(Leaks, "anim-: %@ (%d)", self, _InstanceCount);
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
    UP::TimeSpanning::add(self);
}

- (void)startAnimationAfterDelay:(NSTimeInterval)delay
{
    [self.inner startAnimationAfterDelay:delay];
    UP::TimeSpanning::add(self);
}

- (void)pauseAnimation
{
    [self.inner pauseAnimation];
}

- (void)stopAnimation:(BOOL)withoutFinishing
{
    [self.inner stopAnimation:withoutFinishing];
    UP::TimeSpanning::remove(self);
}

- (void)finishAnimationAtPosition:(UIViewAnimatingPosition)finalPosition
{
    [self.inner finishAnimationAtPosition:finalPosition];
}

#pragma mark - UPTimeSpanning

- (void)start
{
    [self startAnimation];
}

- (void)pause
{
    [self pauseAnimation];
}

- (void)reset
{
    self.inner.fractionComplete = 0;
}

- (void)cancel
{
    [self stopAnimation:YES];
}

@end
