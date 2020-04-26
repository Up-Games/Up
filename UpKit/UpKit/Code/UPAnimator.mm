//
//  UPAnimator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <UpKit/UPAnimator.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPTypes.h>
#import <UpKit/UPUnitFunction.h>

@interface UPAnimator ()

@property (nonatomic) UPTick duration;
@property (nonatomic) UPUnitFunction *unitFunction;
@property (nonatomic) NSUInteger repeatCount;
@property (nonatomic) BOOL rebounds;
@property (nonatomic, copy) UPAnimatorApplier applier;
@property (nonatomic, copy) UPAnimatorCompletion completion;

@property (nonatomic, readwrite) BOOL running;
@property (nonatomic) NSInteger tag;
@property (nonatomic) UPTick startTick;
@property (nonatomic) UPTick previousTick;
@property (nonatomic) UPTick accumulatedTicks;
@property (nonatomic) UPFloat rate;
@property (nonatomic) BOOL startTickNeedsUpdate;
@property (nonatomic) BOOL completed;

- (void)_step:(UPTick)currentTick;

@end

// ================================================================================================

@interface UPTicker : NSObject

@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) NSMutableArray<UPAnimator *> *animators;

- (void)addAnimator:(UPAnimator *)animator;
- (void)removeAnimator:(UPAnimator *)animator;

@end

@implementation UPTicker

+ (UPTicker *)instance
{
    static dispatch_once_t onceToken;
    static UPTicker *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];

    self.animators = [NSMutableArray array];

    return self;
}

- (void)addAnimator:(UPAnimator *)animator
{
    [self.animators addObject:animator];

    if (self.displayLink) {
        return;
    }

    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)removeAnimator:(UPAnimator *)animator
{
    [self.animators removeObject:animator];

    if (self.animators.count == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)_tick:(CADisplayLink *)sender
{
    UPTick currentTick = CACurrentMediaTime();
    for (UPAnimator *animator in self.animators) {
        [animator _step:currentTick];
    }
}

@end

// ================================================================================================

@implementation UPAnimator

+ (UPAnimator *)animatorWithDuration:(UPTick)duration
                        unitFunction:(UPUnitFunction *)unitFunction
                             applier:(UPAnimatorApplier)applier
                          completion:(UPAnimatorCompletion)completion
{
    return [self animatorWithDuration:duration unitFunction:unitFunction repeatCount:1 rebounds:NO autostart:YES
        applier:applier completion:completion];
}

+ (UPAnimator *)animatorWithDuration:(UPTick)duration
                        unitFunction:(UPUnitFunction *)unitFunction
                         repeatCount:(NSUInteger)repeatCount
                            rebounds:(BOOL)rebounds
                           autostart:(BOOL)autostart
                             applier:(UPAnimatorApplier)applier
                          completion:(UPAnimatorCompletion)completion
{
    return [[self alloc] initWithDuration:duration unitFunction:unitFunction repeatCount:1 rebounds:NO autostart:YES
        applier:applier completion:completion];
}

- (instancetype)initWithDuration:(UPTick)duration
                    unitFunction:(UPUnitFunction *)unitFunction
                     repeatCount:(NSUInteger)repeatCount
                        rebounds:(BOOL)rebounds
                       autostart:(BOOL)autostart
                         applier:(UPAnimatorApplier)applier
                      completion:(UPAnimatorCompletion)completion
{
    self = [super init];

    self.duration = duration;
    self.unitFunction = unitFunction;
    self.repeatCount = repeatCount;
    self.rebounds = rebounds;
    self.applier = applier;
    self.completion = completion;
    self.rate = UPFloatOne;

    if (autostart) {
        [self start];
    }

    return self;
}

- (void)stop
{
    self.running = NO;
    [[UPTicker instance] removeAnimator:self];
}

- (void)start
{
    self.running = YES;
    self.startTickNeedsUpdate = YES;
    [[UPTicker instance] addAnimator:self];
}

- (void)_step:(UPTick)currentTick
{
    if (!self.running || self.completed) {
        return;
    }

    // prevent self from being released before method finishes
    UPAnimator *ref = self;

    if (self.startTickNeedsUpdate) {
        self.startTickNeedsUpdate = NO;
        self.startTick = currentTick;
        self.previousTick = currentTick;
    }

    if (up_is_fuzzy_zero(self.duration)) {
        self.completed = YES;
        UPUnit effectiveFraction = self.rebounds ? UPUnitZero : UPUnitOne;
        if (self.applier) {
            self.applier(self, effectiveFraction);
        }
        if (self.completion) {
            self.completion(self, YES);
            [self stop];
        }
        self.running = NO;
    }
    else {
        self.accumulatedTicks += ((currentTick - self.startTick) - (self.previousTick - self.startTick)) * self.rate;
        UPUnit fraction = self.accumulatedTicks / self.duration;
        self.completed = [self _isCompletedWithFraction:fraction];
        if (self.completed) {
            UPUnit effectiveFraction = [self _computeEffectiveFraction:[self _completedFraction]];
            if (self.applier) {
                self.applier(self, effectiveFraction);
            }
            if (self.completion) {
                self.completion(self, YES);
                [self stop];
            }
            self.running = NO;
        }
        else {
            UPUnit effectiveFraction = [self _computeEffectiveFraction:fraction];
            if (self.applier) {
                self.applier(self, effectiveFraction);
            }
        }
    }

    self.previousTick = currentTick;
    ref = nil;
}

- (UPUnit)_computeEffectiveFraction:(UPFloat)fraction
{
    UPUnit effective_fraction = fraction;
    if (self.rebounds) {
        UPUnit ipart;
        UPUnit fpart = modf(fraction, &ipart);
        if (ipart >= (self.repeatCount * 2)) {
            effective_fraction = UPUnitZero;
        }
        else {
            effective_fraction = fpart;
            if (((NSInteger)roundf(ipart)) % 2 == 1) {
                effective_fraction = UPUnitOne - effective_fraction;
            }
        }
    }
    else if (self.repeatCount > 1) {
        UPUnit ipart;
        UPUnit fpart = modf(fraction, &ipart);
        if (ipart >= self.repeatCount) {
            effective_fraction = UPUnitOne;
        }
        else {
            effective_fraction = fpart;
        }
    }
    return [self.unitFunction valueForInput:effective_fraction];
}

- (BOOL)_isCompletedWithFraction:(UPUnit)fraction
{
    UPFloat completedFraction = [self _completedFraction];
    return fraction > completedFraction || up_is_fuzzy_equal(fraction, completedFraction);
}

- (UPUnit)_completedFraction
{
    return UPUnitOne * self.repeatCount * (self.rebounds ? UPUnitTwo : UPUnitOne);
}


@end
