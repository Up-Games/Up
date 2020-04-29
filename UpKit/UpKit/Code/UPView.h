//
//  UPView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPTypes.h>
#import <UpKit/UPUnitFunction.h>

@class UPLayoutRule;

@interface UPView : UIView

@property (nonatomic) UPLayoutRule *layoutRule;
+ (UPView *)viewWithBoundsSize:(CGSize)boundsSize;
- (instancetype)initWithBoundsSize:(CGSize)boundsSize;
- (void)layoutWithRule;

//+ (void)runAnimatorWithDuration:(UPTick)duration unitFunctionType:(UPUnitFunctionType)unitFunctionType animations:(void (^)(void))animations
//                     completion:(void (^)(BOOL finished))completion;

//- (UPViewState *)currentState;
//- (void)applyState:(UPViewState *)state;
//- (void)applyInterpolatedWithStartState:(UPViewState *)startState endState:(UPViewState *)endState fraction:(UPUnit)fraction;
//- (void)applyInterpolatedStateWithFraction:(UPUnit)fraction;

@end
