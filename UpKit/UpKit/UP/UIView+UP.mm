//
//  UIView+UP.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>
#import <math.h>

#import "UPAssertions.h"
#import "POP.h"
#import "UPLayoutRule.h"
#import "UPGeometry.h"
#import "UPMath.h"
#import "UIView+UP.h"
#import "NSValue+UP.h"

@implementation UIView (UP)

+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize
{
    return [[[self class] alloc] initWithBoundsSize:boundsSize];
}

- (instancetype)initWithBoundsSize:(CGSize)boundsSize
{
    return [self initWithFrame:CGRectMake(0, 0, boundsSize.width, boundsSize.height)];
}

#pragma mark - UPLayoutRule

@dynamic layoutRule;

- (void)setLayoutRule:(UPLayoutRule *)layoutRule
{
    objc_setAssociatedObject(self, @selector(layoutRule), layoutRule, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UPLayoutRule *)layoutRule
{
    return objc_getAssociatedObject(self, @selector(layoutRule));
}

- (void)layoutWithRule
{
    self.frame = [self.layoutRule layoutFrameForBoundsSize:self.bounds.size];
}

#pragma mark - Quads

@dynamic quadOffsets;

- (void)setQuadOffsets:(UPQuadOffsets)quadOffsets
{
    NSValue *value = [NSValue valueWithQuadOffsets:quadOffsets];
    objc_setAssociatedObject(self, @selector(quadOffsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.transform = up_transform_for_rect_to_quad(self.frame, quadOffsets);
}

- (UPQuadOffsets)quadOffsets
{
    NSValue *value = objc_getAssociatedObject(self, @selector(quadOffsets));
    return [value quadOffsetsValue];
}

#pragma mark - Slide

- (void)slideWithDuration:(CFTimeInterval)duration toPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion
{
    [self slideWithDuration:duration delay:0 toPosition:position completion:completion];
}

- (void)slideWithDuration:(CFTimeInterval)duration delay:(CFTimeInterval)delay toPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion
{
    CGPoint center = self.center;

    POPBasicAnimation *slide = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    slide.duration = duration;
    slide.beginTime = CACurrentMediaTime() + delay;
    slide.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutCirc];
    slide.fromValue = [NSValue valueWithCGPoint:center];
    slide.toValue = [NSValue valueWithCGPoint:position];
    slide.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (completion) {
            completion(finished);
        }
    };
    [self pop_addAnimation:slide forKey:@"slide"];
}

- (void)addSlideWithDuration:(CFTimeInterval)duration deltaPosition:(CGPoint)deltaPosition completion:(void (^)(BOOL finished))completion
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveLinear animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, deltaPosition.x, deltaPosition.y);
    }];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition == UIViewAnimatingPositionEnd);
        }
    }];
    [animator startAnimation];
}

#pragma mark - Shake

- (void)shakeWithDuration:(CFTimeInterval)duration amount:(CGFloat)amount completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:duration * 0.125 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, -amount, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration * 0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.transform = CGAffineTransformTranslate(self.transform, (amount * 2), 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration * 0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.transform = CGAffineTransformTranslate(self.transform, (-amount * 2), 0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration * 0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.transform = CGAffineTransformTranslate(self.transform, (amount * 2), 0);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:duration * 0.125 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        self.transform = CGAffineTransformTranslate(self.transform, -amount, 0);
                    } completion:^(BOOL finished) {
                        if (completion) {
                            completion(YES);
                        }
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - Fade

- (void)fadeWithDuration:(CFTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration curve:UIViewAnimationCurveEaseIn animations:^{
        self.alpha = 0;
    }];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (completion) {
            completion(finalPosition == UIViewAnimatingPositionEnd);
        }
    }];
    [animator startAnimation];
}

#pragma mark - Bloop

- (void)bloopWithDuration:(CFTimeInterval)duration toPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion
{
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:0.7 animations:^{
        self.center = position;
    }];
    [animator startAnimation];
}

@end
