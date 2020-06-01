//
//  UPTickingAnimator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIScreen.h>
#import <QuartzCore/QuartzCore.h>

#import "UPAssertions.h"
#import "UPDelayedAction.h"
#import "UPTickingAnimator.h"
#import "UPTicker.h"
#import "UPTimeSpanning.h"
#import "UPMacros.h"
#import "UPMath.h"
#import "UPStringTools.h"
#import "UPUnitFunction.h"

// =========================================================================================================================================

static CGFloat compute_effective_fraction(CGFloat fraction, BOOL rebounds, NSUInteger repeatCount, UPUnitFunction *unitFunction)
{
    CGFloat effective_fraction = fraction;
    if (rebounds) {
        CGFloat ipart;
        CGFloat fpart = modf(fraction, &ipart);
        if (ipart >= (repeatCount * 2)) {
            effective_fraction = 0.0;
        }
        else {
            effective_fraction = fpart;
            if (((NSInteger)roundf(ipart)) % 2 == 1) {
                effective_fraction = 1.0 - effective_fraction;
            }
        }
    }
    else if (repeatCount > 1) {
        CGFloat ipart;
        CGFloat fpart = modf(fraction, &ipart);
        if (ipart >= repeatCount) {
            effective_fraction = 1.0;
        }
        else {
            effective_fraction = fpart;
        }
    }
    return [unitFunction valueForInput:effective_fraction];
}

UP_STATIC_INLINE CGFloat compute_completed_fraction(BOOL rebounds, NSUInteger repeatCount)
{
    return 1.0 * repeatCount * (rebounds ? 2.0 : 1.0);
}

// =========================================================================================================================================

@interface UPTickingAnimator ()

@property (nonatomic, readwrite) UP::Role role;
@property (nonatomic) CFTimeInterval duration;
@property (nonatomic) UPUnitFunction *unitFunction;
@property (nonatomic) NSUInteger repeatCount;
@property (nonatomic) BOOL rebounds;
@property (nonatomic, copy) UPTickingAnimatorApplier applier;
@property (nonatomic, copy) UPTickingAnimatorCompletion completion;

@property (nonatomic) CFTimeInterval remainingDuration;
@property (nonatomic) CFTimeInterval previousTick;
@property (nonatomic) CGFloat rate;
@property (nonatomic) BOOL completed;

@property (nonatomic) UIViewAnimatingState state;
@property (nonatomic) UIViewAnimatingPosition animatingPosition;
@property (nonatomic, readwrite) BOOL running;

@property (nonatomic, readwrite) uint32_t serialNumber;

- (void)tick:(CFTimeInterval)currentTick;

@end

@implementation UPTickingAnimator

+ (UPTickingAnimator *)animatorWithRole:(UP::Role)role duration:(CFTimeInterval)duration unitFunction:(UPUnitFunction *)unitFunction
    applier:(UPTickingAnimatorApplier)applier completion:(UPTickingAnimatorCompletion)completion
{
    return [self animatorWithRole:role duration:duration unitFunction:unitFunction repeatCount:1 rebounds:NO
        applier:applier completion:completion];
}

+ (UPTickingAnimator *)animatorWithRole:(UP::Role)role duration:(CFTimeInterval)duration unitFunction:(UPUnitFunction *)unitFunction
    repeatCount:(NSUInteger)repeatCount rebounds:(BOOL)rebounds applier:(UPTickingAnimatorApplier)applier
        completion:(UPTickingAnimatorCompletion)completion
{
    return [[self alloc] initWithRole:role duration:duration unitFunction:unitFunction repeatCount:1 rebounds:NO
        applier:applier completion:completion];
}

- (instancetype)initWithRole:(UP::Role)role duration:(CFTimeInterval)duration unitFunction:(UPUnitFunction *)unitFunction
    repeatCount:(NSUInteger)repeatCount rebounds:(BOOL)rebounds
        applier:(UPTickingAnimatorApplier)applier completion:(UPTickingAnimatorCompletion)completion;
{
    self = [super init];

    self.role = role;
    self.duration = duration;
    self.unitFunction = unitFunction;
    self.repeatCount = repeatCount;
    self.rebounds = rebounds;
    self.applier = applier;
    self.completion = completion;
    self.rate = 1.0;
    
    self.state = UIViewAnimatingStateInactive;
    self.animatingPosition = UIViewAnimatingPositionStart;
    self.remainingDuration = self.duration;
    self.previousTick = 0;

    self.serialNumber = UP::next_serial_number();

    return self;
}

- (void)clearBlocks
{
    self.applier = nil;
    self.completion = nil;
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
        _fractionComplete = effectiveFraction;
        self.animatingPosition = effectiveAnimatingPosition;
        if (self.applier) {
            self.applier(self, effectiveFraction);
        }
        [self stopAnimation:NO];
    }
    else {
        CGFloat fraction = 1.0 - (self.remainingDuration / self.duration);
        _fractionComplete = fraction;
        CGFloat completedFraction = compute_completed_fraction(self.rebounds, self.repeatCount);
        self.completed = fraction > completedFraction || up_is_fuzzy_equal(fraction, completedFraction);
        if (self.completed) {
            CGFloat effectiveFraction = compute_effective_fraction(completedFraction, self.rebounds, self.repeatCount, self.unitFunction);
            UIViewAnimatingPosition effectiveAnimatingPosition = UIViewAnimatingPositionCurrent;
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
            CGFloat effectiveFraction = compute_effective_fraction(fraction, self.rebounds, self.repeatCount, self.unitFunction);
            if (self.applier) {
                self.applier(self, effectiveFraction);
            }
        }
    }

    self.previousTick = now;
    ref = nil;
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
    UP::TimeSpanning::delay(self.role, delay, ^{
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
    if (self.state == UIViewAnimatingStateStopped) {
        return;
    }
    self.running = NO;
    self.previousTick = 0;
    if (self.state == UIViewAnimatingStateActive) {
        self.state = UIViewAnimatingStateStopped;
    }
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

- (void)setFractionComplete:(CGFloat)fractionComplete
{
    self.remainingDuration = fractionComplete * self.duration;
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
