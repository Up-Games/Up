//
//  UIView+UPLayout.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>

#import "UPLayoutRule.h"
#import "UPMath.h"
#import "UIView+UP.h"

@implementation UPViewState
@end

@implementation UIView (UP)

@dynamic layoutRule;

- (void)setLayoutRule:(UPLayoutRule *)layoutRule
{
    objc_setAssociatedObject(self, @selector(layoutRule), layoutRule, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UPLayoutRule *)layoutRule
{
    return objc_getAssociatedObject(self, @selector(layoutRule));
}

+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize
{
    return [[UIView alloc] initWithBoundsSize:boundsSize];
}

- (instancetype)initWithBoundsSize:(CGSize)boundsSize
{
    return [self initWithFrame:CGRectMake(0, 0, boundsSize.width, boundsSize.height)];
}

- (void)layoutWithRule
{
    self.frame = [self.layoutRule layoutFrameForBoundsSize:self.bounds.size];
}

- (UPViewState *)currentState
{
    UPViewState *currentState = [[UPViewState alloc] init];
    currentState.frame = self.frame;
    currentState.backgroundColor = self.backgroundColor;
    return currentState;
}

- (void)applyState:(UPViewState *)state
{
    self.backgroundColor = state.backgroundColor;
}

- (void)applyInterpolatedWithStartState:(UPViewState *)startState endState:(UPViewState *)endState fraction:(UPUnit)fraction
{
    self.frame = up_lerp_rects(startState.frame, endState.frame, fraction);
//    NSLog(@"fraction: %.2f : %@", fraction, NSStringFromCGRect(self.frame));
}

@end
