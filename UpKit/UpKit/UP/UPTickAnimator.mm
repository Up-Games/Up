//
//  UPTickAnimator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIScreen.h>
#import <QuartzCore/QuartzCore.h>

#import "UPAssertions.h"
#import "UPDelay.h"
#import "UPTickAnimator.h"
#import "UPTicker.h"
#import "UPMath.h"
#import "UPStringTools.h"

@interface UPTickAnimator ()

@property (nonatomic) CFTimeInterval duration;
@property (nonatomic) UPUnitFunction *unitFunction;
@property (nonatomic) NSUInteger repeatCount;
@property (nonatomic) BOOL rebounds;
@property (nonatomic, copy) UPTickAnimatorApplier applier;
@property (nonatomic, copy) UPTickAnimatorCompletion completion;

@property (nonatomic) NSString *tag;
@property (nonatomic) CFTimeInterval startTick;
@property (nonatomic) CFTimeInterval previousTick;
@property (nonatomic) CFTimeInterval accumulatedTicks;
@property (nonatomic) CGFloat rate;
@property (nonatomic) BOOL startTickNeedsUpdate;
@property (nonatomic) BOOL completed;

@property (nonatomic) UIViewAnimatingState state;
@property (nonatomic) UIViewAnimatingPosition animatingPosition;
@property (nonatomic, readwrite) BOOL running;

- (void)tick:(CFTimeInterval)currentTick;

@end

@implementation UPTickAnimator

+ (UPTickAnimator *)animatorWithDuration:(CFTimeInterval)duration
                            unitFunction:(UPUnitFunction *)unitFunction
                                 applier:(UPTickAnimatorApplier)applier
                              completion:(UPTickAnimatorCompletion)completion
{
    return [self animatorWithDuration:duration unitFunction:unitFunction repeatCount:1 rebounds:NO applier:applier completion:completion];
}

+ (UPTickAnimator *)animatorWithDuration:(CFTimeInterval)duration
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
    self.startTickNeedsUpdate = YES;

    return self;
}

- (void)tick:(CFTimeInterval)currentTick
{
    if (!self.running || self.completed) {
        return;
    }

    // prevent self from being released before method finishes
    UPTickAnimator *ref = self;

    if (self.startTickNeedsUpdate) {
        self.startTickNeedsUpdate = NO;
        self.startTick = currentTick;
        self.previousTick = currentTick;
    }

    if (up_is_fuzzy_zero(self.duration)) {
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
        if (self.completion) {
            self.completion(self, self.animatingPosition);
            [self stop];
        }
        self.running = NO;
    }
    else {
        self.accumulatedTicks += ((currentTick - self.startTick) - (self.previousTick - self.startTick)) * self.rate;
        CGFloat fraction = self.accumulatedTicks / self.duration;
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
            if (self.completion) {
                self.completion(self, self.animatingPosition);
                [self stop];
            }
            self.running = NO;
        }
        else {
            CGFloat effectiveFraction = [self computeEffectiveFraction:fraction];
            self.fractionComplete = effectiveFraction;
            if (self.applier) {
                self.applier(self, effectiveFraction);
            }
        }
    }

    self.previousTick = currentTick;
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

- (void)stop
{
    self.running = NO;
    if (self.completed) {
        self.state = UIViewAnimatingStateInactive;
    }
    else {
        self.state = UIViewAnimatingStateStopped;
    }
    [[UPTicker instance] removeAnimator:self];
    self.startTickNeedsUpdate = YES;
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
    [[UPTicker instance] addAnimator:self];
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
    self.state = UIViewAnimatingStateInactive;
    [[UPTicker instance] removeAnimator:self];
}

- (void)stopAnimation:(BOOL)withoutFinishing
{
    ASSERT(self.state != UIViewAnimatingStateStopped);
    [self stop];
    if (!withoutFinishing && self.completion) {
        self.completion(self, self.animatingPosition);
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
