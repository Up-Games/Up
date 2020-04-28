//
//  UPAnimator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UpKit/UPTypes.h>
#import <UpKit/UPUnitFunction.h>

@class UPAnimator;

typedef void (^UPAnimatorApplier)(UPAnimator *animator, UPUnit fraction);
typedef void (^UPAnimatorCompletion)(UPAnimator *animator, BOOL completed);

@interface UPAnimator : NSObject

@property (nonatomic, readonly) BOOL running;

+ (UPAnimator *)animatorWithDuration:(CFTimeInterval)duration
                    unitFunctionType:(UPUnitFunctionType)unitFunctionType
                             applier:(UPAnimatorApplier)applier
                          completion:(UPAnimatorCompletion)completion;

+ (UPAnimator *)animatorWithDuration:(CFTimeInterval)duration
                        unitFunction:(UPUnitFunction *)unitFunction
                             applier:(UPAnimatorApplier)applier
                          completion:(UPAnimatorCompletion)completion;

+ (UPAnimator *)animatorWithDuration:(CFTimeInterval)duration
                        unitFunction:(UPUnitFunction *)unitFunction
                         repeatCount:(NSUInteger)repeatCount
                            rebounds:(BOOL)rebounds
                           autostart:(BOOL)autostart
                             applier:(UPAnimatorApplier)applier
                          completion:(UPAnimatorCompletion)completion;

- (void)stop;
- (void)start;

@end
