//
//  UPAnimator.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPBand.h"
#import "UIColor+UP.h"
#import "UIView+UP.h"
#import "UPAssertions.h"
#import "UPAnimator.h"
#import "UPBezierPathView.h"
#import "UPGeometry.h"
#import "UPLabel.h"
#import "UPTickingAnimator.h"
#import "UPUnitFunction.h"

@interface UPAnimator ()
@property (nonatomic, readwrite) UPAnimatorType type;
@property (nonatomic, readwrite) UP::Band band;
@property (nonatomic, readwrite) uint32_t serialNumber;
@property (nonatomic) NSObject<UIViewAnimating> *inner;
@property (nonatomic, readwrite) NSArray *views;
@property (nonatomic, readwrite) NSArray *moves;
@end

static uint32_t _InstanceCount;

@implementation UPAnimator

+ (UPAnimator *)bloopInAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                           completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithType:UPAnimatorTypeBloopIn band:band moves:moves];
    animator.type = UPAnimatorTypeBloopIn;
    UPTickingAnimator *inner = [UPTickingAnimator animatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutBack]
                                                         applier:^(UPTickingAnimator *animator_) {
        for (UPViewMove *move in moves) {
            move.view.center = up_lerp_points(move.beginning, move.destination, animator_.fractionComplete);
        }
    } completion:^(UPTickingAnimator *inner_, UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition);
        }
        [inner_ clearBlocks];
        UP::TimeSpanning::remove(animator);
    }];
    animator.inner = inner;
    return animator;

}

+ (UPAnimator *)bloopOutAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                           completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithType:UPAnimatorTypeBloopOut band:band moves:moves];
    animator.type = UPAnimatorTypeBloopOut;
    UPTickingAnimator *inner = [UPTickingAnimator animatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseInBack]
                                                         applier:^(UPTickingAnimator *animator_) {
        for (UPViewMove *move in moves) {
            move.view.center = up_lerp_points(move.beginning, move.destination, animator_.fractionComplete);
        }
    } completion:^(UPTickingAnimator *inner_, UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition);
        }
        [inner_ clearBlocks];
        UP::TimeSpanning::remove(animator);
    }];
    animator.inner = inner;
    return animator;
    
}

+ (UPAnimator *)fadeAnimatorInBand:(UP::Band)band views:(NSArray<UIView *> *)views duration:(CFTimeInterval)duration
    completion:(void (^)(UIViewAnimatingPosition finalPosition))completion;
{
    UPAnimator *animator = [[self alloc] _initWithType:UPAnimatorTypeFade band:band views:views];
    animator.type = UPAnimatorTypeFade;
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
    UPAnimator *animator = [[self alloc] _initWithType:UPAnimatorTypeShake band:band views:views];
    animator.type = UPAnimatorTypeShake;
    __block UIOffset roffset = UIOffsetZero;
    UPTickingAnimator *inner = [UPTickingAnimator animatorInBand:band duration:duration
        unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear]
        applier:^(UPTickingAnimator *animator_) {
            CGFloat factor = sin(5 * M_PI * animator_.fractionComplete);
            UIOffset foffset = UIOffsetMake(factor * offset.horizontal, factor * offset.vertical);
            UIOffset doffset = UIOffsetMake(foffset.horizontal - roffset.horizontal, foffset.vertical - roffset.vertical);
            roffset = foffset;
            for (UIView *view in views) {
                view.transform = CGAffineTransformTranslate(view.transform, doffset.horizontal, doffset.vertical);
            }
        }
        completion:^(UPTickingAnimator *inner_, UIViewAnimatingPosition finalPosition) {
            if (completion) {
                completion(finalPosition);
            }
            [inner_ clearBlocks];
            UP::TimeSpanning::remove(animator);
        }
    ];
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)slideAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                         completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithType:UPAnimatorTypeSlide band:band moves:moves];
    animator.type = UPAnimatorTypeSlide;
    UPTickingAnimator *inner = [UPTickingAnimator animatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear]
                                                         applier:^(UPTickingAnimator *animator_) {
        for (UPViewMove *move in moves) {
            move.view.center = up_lerp_points(move.beginning, move.destination, animator_.fractionComplete);
        }
    } completion:^(UPTickingAnimator *inner_, UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition);
        }
        [inner_ clearBlocks];
        UP::TimeSpanning::remove(animator);
    }
                                ];
    animator.inner = inner;
    return animator;
}

+ (UPAnimator *)easeAnimatorInBand:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves duration:(CFTimeInterval)duration
                         completion:(void (^)(UIViewAnimatingPosition finalPosition))completion
{
    UPAnimator *animator = [[self alloc] _initWithType:UPAnimatorTypeEase band:band moves:moves];
    animator.type = UPAnimatorTypeSlide;
    UPTickingAnimator *inner = [UPTickingAnimator animatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseInEaseOut]
                                                         applier:^(UPTickingAnimator *animator_) {
        for (UPViewMove *move in moves) {
            move.view.center = up_lerp_points(move.beginning, move.destination, animator_.fractionComplete);
        }
    } completion:^(UPTickingAnimator *inner_, UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition);
        }
        [inner_ clearBlocks];
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
    UPAnimator *animator = [[self alloc] _initWithType:UPAnimatorTypeSetColor band:band views:controls];
    animator.type = UPAnimatorTypeSetColor;
    UPTickingAnimator *inner = [UPTickingAnimator animatorInBand:band duration:duration
                                                    unitFunction:[UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutSine]
        applier:^(UPTickingAnimator *animator_) {
            if (element & UPControlElementFill) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control fillColorForState:fromControlState];
                    UIColor *c2 = [control fillColorForState:toControlState];
                    control.fillPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator_.fractionComplete];
                }
            }
            if (element & UPControlElementStroke) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control strokeColorForState:fromControlState];
                    UIColor *c2 = [control strokeColorForState:toControlState];
                    control.strokePathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator_.fractionComplete];
                }
            }
            if (element & UPControlElementContent) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control contentColorForState:fromControlState];
                    UIColor *c2 = [control contentColorForState:toControlState];
                    control.contentPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator_.fractionComplete];
                }
            }
            if (element & UPControlElementAuxiliary) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control contentColorForState:fromControlState];
                    UIColor *c2 = [control contentColorForState:toControlState];
                    control.auxiliaryPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator_.fractionComplete];
                }
            }
            if (element & UPControlElementAccent) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control contentColorForState:fromControlState];
                    UIColor *c2 = [control contentColorForState:toControlState];
                    control.accentPathView.fillColor = [UIColor colorByMixingColor:c1 color:c2 fraction:animator_.fractionComplete];
                }
            }
            if (element & UPControlElementLabel) {
                for (UPControl *control in controls) {
                    UIColor *c1 = [control labelColorForState:fromControlState];
                    UIColor *c2 = [control labelColorForState:toControlState];
                    UIColor *color = [UIColor colorByMixingColor:c1 color:c2 fraction:animator_.fractionComplete];
                    control.label.textColor = color;
                }
            }
        }
        completion:^(UPTickingAnimator *inner_, UIViewAnimatingPosition finalPosition) {
            if (completion) {
                completion(finalPosition);
            }
            [inner_ clearBlocks];
            UP::TimeSpanning::remove(animator);
        }
    ];
    animator.inner = inner;
    return animator;
}

- (instancetype)_initWithType:(UPAnimatorType)type band:(UP::Band)band views:(NSArray<UIView *> *)views
{
    ASSERT(band);
    
    self = [super init];
    self.type = type;
    self.band = band;
    self.views = views;
    self.serialNumber = UP::next_serial_number();
    
    _InstanceCount++;
    LOG(Leaks, "anim+: %@ (%d)", self, _InstanceCount);
    
    return self;
}

- (instancetype)_initWithType:(UPAnimatorType)type band:(UP::Band)band moves:(NSArray<UPViewMove *> *)moves
{
    ASSERT(band);
    
    self = [super init];
    self.type = type;
    self.band = band;
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

- (NSString *)stringForType:(UPAnimatorType)type
{
    switch (type) {
        case UPAnimatorTypeNone:
            return @"None";
        case UPAnimatorTypeBloopIn:
            return @"Bloop In";
        case UPAnimatorTypeBloopOut:
            return @"Bloop Out";
        case UPAnimatorTypeFade:
            return @"Fade";
        case UPAnimatorTypeShake:
            return @"Shake";
        case UPAnimatorTypeSlide:
            return @"Slide";
        case UPAnimatorTypeSetColor:
            return @"Set Color";
    }
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%d : %s:%@> ", self.class, self.serialNumber, self.band, [self stringForType:self.type]];
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
    if (self.running) {
        [self stopAnimation:NO];
    }
}

@end
