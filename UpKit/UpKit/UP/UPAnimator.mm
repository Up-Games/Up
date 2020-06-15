//
//  UPAnimator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UIColor+UP.h"
#import "UIView+UP.h"
#import "UPAssertions.h"
#import "UPAnimator.h"
#import "UPBezierPathView.h"
#import "UPGeometry.h"
#import "UPBand.h"
#import "UPTickingAnimator.h"
#import "UPUnitFunction.h"

@interface UPAnimator ()
@property (nonatomic, readwrite) UP::Band band;
@property (nonatomic, readwrite) uint32_t serialNumber;
@property (nonatomic) NSObject<UIViewAnimating> *inner;
@property (nonatomic) NSString *type;
@property (nonatomic, readwrite) NSArray *views;
@property (nonatomic, readwrite) NSArray *moves;
@end

static uint32_t _InstanceCount;

@implementation UPAnimator

+ (UPAnimator *)bloopInAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                           completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"bloop_in" moves:moves];
    UPTickingAnimator *inner = [UPTickingAnimator AnimatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutBack]
                                                         applier:^(UPTickingAnimator *animator) {
        for (UPViewMove *move in moves) {
            move.view.center = up_lerp_points(move.beginning, move.destination, animator.fractionComplete);
        }
    } completion:^(UPTickingAnimator *inner, UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition);
        }
        [inner clearBlocks];
        UP::TimeSpanning::remove(animator);
    }];
    animator.inner = inner;
    return animator;

}

+ (UPAnimator *)bloopOutAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                           completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"bloop_out" moves:moves];
    UPTickingAnimator *inner = [UPTickingAnimator AnimatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseInBack]
                                                         applier:^(UPTickingAnimator *animator) {
        for (UPViewMove *move in moves) {
            move.view.center = up_lerp_points(move.beginning, move.destination, animator.fractionComplete);
        }
    } completion:^(UPTickingAnimator *inner, UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition);
        }
        [inner clearBlocks];
        UP::TimeSpanning::remove(animator);
    }];
    animator.inner = inner;
    return animator;
    
}

+ (UPAnimator *)fadeAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"fade" views:views];
    UIViewPropertyAnimator *inner = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveEaseOut animations:^{
        for (UIView *view in views) {
            view.alpha = 0;
        }
    }];
    uint32_t serialNumber = animator.serialNumber;
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(serialNumber);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)shakeAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"shake" views:views];
    __block UIOffset roffset = UIOffsetZero;
    UPTickingAnimator *inner = [UPTickingAnimator AnimatorInBand:band duration:duration
        unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear]
        applier:^(UPTickingAnimator *animator) {
            CGFloat factor = sin(5 * M_PI * animator.fractionComplete);
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

+ (UPAnimator *)slideAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    offset:(UIOffset)offset completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"slide" views:views];
    UIViewPropertyAnimator *inner = [[UIViewPropertyAnimator alloc] initWithDuration:duration
        curve:UIViewAnimationCurveLinear animations:^{
            for (UIView *view in views) {
                view.transform = CGAffineTransformTranslate(view.transform, offset.horizontal, offset.vertical);
            }
        }
    ];
    uint32_t serialNumber = animator.serialNumber;
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(serialNumber);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)slideToAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    point:(CGPoint)point completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"slide_to" views:views];
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
    uint32_t serialNumber = animator.serialNumber;
    [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
        UP::TimeSpanning::remove(serialNumber);
    }];
    if (completion) {
        [inner addCompletion:^(UIViewAnimatingPosition finalPosition) {
            completion(finalPosition);
        }];
    }
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)slideAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                         completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"x_slide_to" moves:moves];
    UPTickingAnimator *inner = [UPTickingAnimator AnimatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear]
                                                         applier:^(UPTickingAnimator *animator) {
        for (UPViewMove *move in moves) {
            move.view.center = up_lerp_points(move.beginning, move.destination, animator.fractionComplete);
        }
    } completion:^(UPTickingAnimator *inner, UIViewAnimatingPosition finalPosition) {
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

+ (UPAnimator *)setColorAnimatorInBand:(UP::Band)band controls:(NSArray<UPControl *> *)controls duration:(CFTimeInterval)duration
    element:(UPControlElement)element fromControlState:(UPControlState)fromControlState toControlState:(UPControlState)toControlState
        completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;
{
    UPAnimator *animator = [[self alloc] _initInBand:band type:@"set_color" views:controls];
    UPTickingAnimator *inner = [UPTickingAnimator AnimatorInBand:band duration:duration
        unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseInEaseOutExpo]
        applier:^(UPTickingAnimator *animator) {
            if (element & UPControlElementFill) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control fillColorForState:fromControlState];
                    UIColor *c2 = [control fillColorForState:toControlState];
                    control.fillPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator.fractionComplete];
                }
            }
            if (element & UPControlElementStroke) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control strokeColorForState:fromControlState];
                    UIColor *c2 = [control strokeColorForState:toControlState];
                    control.strokePathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator.fractionComplete];
                }
            }
            if (element & UPControlElementContent) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control contentColorForState:fromControlState];
                    UIColor *c2 = [control contentColorForState:toControlState];
                    control.contentPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator.fractionComplete];
                }
            }
        if (element & UPControlElementAuxiliary) {
            for (UPControl *control in controls) {
                UIColor *c1 = [control contentColorForState:fromControlState];
                UIColor *c2 = [control contentColorForState:toControlState];
                control.auxiliaryPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator.fractionComplete];
            }
        }
        if (element & UPControlElementAccent) {
            for (UPControl *control in controls) {
                UIColor *c1 = [control contentColorForState:fromControlState];
                UIColor *c2 = [control contentColorForState:toControlState];
                control.accentPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator.fractionComplete];
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

- (instancetype)_initInBand:(UP::Band)band type:(NSString *)type views:(NSArray<UIView *> *)views
{
    ASSERT(band);
    
    self = [super init];
    self.band = band;
    self.type = type;
    self.views = views;
    self.serialNumber = UP::next_serial_number();
    
    _InstanceCount++;
    LOG(Leaks, "anim+: %@ (%d)", self, _InstanceCount);
    
    return self;
}

- (instancetype)_initInBand:(UP::Band)band type:(NSString *)type moves:(NSArray<UPViewMove *> *)moves
{
    ASSERT(band);
    
    self = [super init];
    self.band = band;
    self.type = type;
    self.moves = moves;
    self.serialNumber = UP::next_serial_number();
    
    _InstanceCount++;
    LOG(Leaks, "anim+: %@ (%d)", self, _InstanceCount);
    
    return self;
}

- (void)dealloc
{
    _InstanceCount--;
    LOG(Leaks, "anim-: %@ (%d)", self, _InstanceCount);
    UP::TimeSpanning::remove(self);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%d : %s:%@> ", self.class, self.serialNumber, self.band, self.type];
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
    if (withoutFinishing) {
        UP::TimeSpanning::remove(self);
    }
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
    [self stopAnimation:NO];
}

@end
