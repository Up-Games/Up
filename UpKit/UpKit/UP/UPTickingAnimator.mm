//
//  UPTickAnimator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIScreen.h>
#import <QuartzCore/QuartzCore.h>

#import "UPAssertions.h"
#import "UPDelay.h"
#import "UPTickingAnimator.h"
#import "UPTicker.h"
#import "UPMath.h"
#import "UPStringTools.h"

@interface UPTickingAnimator ()

@property (nonatomic) CFTimeInterval duration;
@property (nonatomic) UPUnitFunction *unitFunction;
@property (nonatomic) NSUInteger repeatCount;
@property (nonatomic) BOOL rebounds;
@property (nonatomic, copy) UPTickAnimatorApplier applier;
@property (nonatomic, copy) UPTickAnimatorCompletion completion;

@property (nonatomic) NSString *tag;
@property (nonatomic) CFTimeInterval remainingDuration;
@property (nonatomic) CFTimeInterval previousTick;
@property (nonatomic) CGFloat rate;
@property (nonatomic) BOOL completed;

@property (nonatomic) UIViewAnimatingState state;
@property (nonatomic) UIViewAnimatingPosition animatingPosition;
@property (nonatomic, readwrite) BOOL running;

- (void)tick:(CFTimeInterval)currentTick;

@end

@implementation UPTickingAnimator

+ (UPTickingAnimator *)animatorWithDuration:(CFTimeInterval)duration
                            unitFunction:(UPUnitFunction *)unitFunction
                                 applier:(UPTickAnimatorApplier)applier
                              completion:(UPTickAnimatorCompletion)completion
{
    return [self animatorWithDuration:duration unitFunction:unitFunction repeatCount:1 rebounds:NO applier:applier completion:completion];
}

+ (UPTickingAnimator *)animatorWithDuration:(CFTimeInterval)duration
                            unitFunction:(UPUnitFunction *)unitFunction
                             repeatCount:(NSUInteger)repeatCount
                                rebounds:(BOOL)rebounds
                                 applier:(UPTickAnimatorApplier)applier
                              completion:(UPTickAnimatorCompletion)completion
{
    return [[self alloc] initWithDuration:duration unitFunction:unitFunction repeatCount:1 rebounds:NO
        applier:applier completion:completion];
}

- (instancetype)initWithDuration:(CFTimeInterval)duration
                    unitFunction:(UPUnitFunction *)unitFunction
                     repeatCount:(NSUInteger)repeatCount
                        rebounds:(BOOL)rebounds
                         applier:(UPTickAnimatorApplier)applier
                      completion:(UPTickAnimatorCompletion)completion;
{
    self = [super init];

    self.duration = duration;
    self.unitFunction = unitFunction;
    self.repeatCount = repeatCount;
    self.rebounds = rebounds;
    self.applier = applier;
    self.completion = completion;
    self.rate = 1.0;
    
    static int counter;
    self.tag = [NSString stringWithFormat:@"%@:%d", self.class, ++counter];

    self.state = UIViewAnimatingStateInactive;
    self.animatingPosition = UIViewAnimatingPositionStart;
    self.remainingDuration = self.duration;
    self.previousTick = 0;

    return self;
}

- (void)tick:(CFTimeInterval)now
{
    if (!self.running || self.completed) {
        return;
    }

    // prevent self from being released before method finishes
    UPTickingAnimator *ref = self;

    if (up_is_fuzzy_zero(self.previousTick)) {
        self.remainingDuration -= (UPTickerInterval * self.rate);
    }
    else {
        self.remainingDuration -= ((now - self.previousTick) * self.rate);
    }
    self.previousTick = now;
    self.remainingDuration = UPMaxT(CFTimeInterval, self.remainingDuration, 0);

    if (up_is_fuzzy_zero(self.remainingDuration)) {
        self.completed = YES;
        CGFloat effectiveFraction = 1.0;
        UIViewAnimatingPosition effectiveAnimatingPosition = UIViewAnimatingPositionEnd;
        if (self.rebounds) {
            effectiveFraction = 0.0;
            self.animatingPosition = effectiveAnimatingPosition;
        }
        self.fractionComplete = effectiveFraction;
        self.animatingPosition = effectiveAnimatingPosition;
        if (self.applier) {
            self.applier(self, effectiveFraction);
        }
        [self stopAnimation:NO];
    }
    else {
        CGFloat fraction = 1.0 - (self.remainingDuration / self.duration);
        self.completed = [self isCompletedWithFraction:fraction];
        if (self.completed) {
            CGFloat effectiveFraction = [self computeEffectiveFraction:[self completedFraction]];
            UIViewAnimatingPosition effectiveAnimatingPosition = UIViewAnimatingPositionCurrent;
            self.fractionComplete = effectiveFraction;
            if (up_is_fuzzy_zero(effectiveFraction)) {
                effectiveAnimatingPosition = UIViewAnimatingPositionStart;
            }
            else if (up_is_fuzzy_one(effectiveFraction)) {
                effectiveAnimatingPosition = UIViewAnimatingPositionEnd;
            }
            self.animatingPosition = effectiveAnimatingPosition;
            if (self.applier) {
                self.applier(self, effectiveFraction);
            }
            [self stopAnimation:NO];
        }
        else {
            CGFloat effectiveFraction = [self computeEffectiveFraction:fraction];
            self.fractionComplete = effectiveFraction;
            if (self.applier) {
                self.applier(self, effectiveFraction);
            }
        }
    }

    self.previousTick = now;
    ref = nil;
}

- (CGFloat)computeEffectiveFraction:(CGFloat)fraction
{
    CGFloat effective_fraction = fraction;
    if (self.rebounds) {
        CGFloat ipart;
        CGFloat fpart = modf(fraction, &ipart);
        if (ipart >= (self.repeatCount * 2)) {
            effective_fraction = 0.0;
        }
        else {
            effective_fraction = fpart;
            if (((NSInteger)roundf(ipart)) % 2 == 1) {
                effective_fraction = 1.0 - effective_fraction;
            }
        }
    }
    else if (self.repeatCount > 1) {
        CGFloat ipart;
        CGFloat fpart = modf(fraction, &ipart);
        if (ipart >= self.repeatCount) {
            effective_fraction = 1.0;
        }
        else {
            effective_fraction = fpart;
        }
    }
    return [self.unitFunction valueForInput:effective_fraction];
}

- (BOOL)isCompletedWithFraction:(CGFloat)fraction
{
    CGFloat completedFraction = [self completedFraction];
    return fraction > completedFraction || up_is_fuzzy_equal(fraction, completedFraction);
}

- (CGFloat)completedFraction
{
    return 1.0 * self.repeatCount * (self.rebounds ? 2.0 : 1.0);
}

#pragma mark - UIViewAnimating

- (void)startAnimation
{
    ASSERT(self.state != UIViewAnimatingStateStopped);
    if (self.running) {
        return;
    }
    self.completed = NO;
    self.running = YES;
    self.state = UIViewAnimatingStateActive;
    [[UPTicker instance] addTicking:self];
}

- (void)startAnimationAfterDelay:(NSTimeInterval)delay
{
    UP::delay(UP::cpp_str(self.tag), delay, ^{
        [self startAnimation];
    });
}

- (void)pauseAnimation
{
    ASSERT(self.state != UIViewAnimatingStateStopped);
    self.running = NO;
    self.previousTick = 0;
    self.state = UIViewAnimatingStateInactive;
    [[UPTicker instance] removeTicking:self];
}

- (void)stopAnimation:(BOOL)withoutFinishing
{
    ASSERT(self.state != UIViewAnimatingStateStopped);
    self.running = NO;
    self.previousTick = 0;
    self.state = UIViewAnimatingStateStopped;
    [[UPTicker instance] removeTicking:self];
    if (!withoutFinishing) {
        [self finishAnimationAtPosition:self.animatingPosition];
    }
}

- (void)finishAnimationAtPosition:(UIViewAnimatingPosition)finalPosition
{
    ASSERT(self.state == UIViewAnimatingStateStopped);
    switch (finalPosition) {
        case UIViewAnimatingPositionEnd:
            if (self.applier) {
                self.applier(self, 1.0);
            }
            break;
        case UIViewAnimatingPositionStart:
            if (self.applier) {
                self.applier(self, 0.0);
            }
            break;
        case UIViewAnimatingPositionCurrent:
            break;
    }
    self.animatingPosition = finalPosition;
    self.state = UIViewAnimatingStateInactive;
    if (self.completion) {
        self.completion(self, finalPosition);
    }
}

- (BOOL)reversed
{
    ASSERT(false);
    return NO;
}

- (void)setReversed:(BOOL)reversed
{
    ASSERT(false);
}

@end
