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
    CGFloat dx = deltaPosition.x;
    CGFloat dy = deltaPosition.y;

    POPBasicAnimation *slide = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    slide.duration = duration;
    slide.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutCirc];
    slide.additive = YES;
    slide.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    slide.toValue = [NSValue valueWithCGPoint:CGPointMake(dx, dy)];
    slide.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (completion) {
            completion(finished);
        }
    };
    [self pop_addAnimation:slide forKey:@"addSlide"];
}

#pragma mark - Shake

- (void)shakeWithDuration:(CFTimeInterval)duration amount:(CGFloat)amount completion:(void (^)(BOOL finished))completion
{
    CGPoint center = self.center;
    CGPoint left = CGPointMake(center.x - amount, center.y);
    CGPoint right = CGPointMake(center.x + amount, center.y);

    //__block int repeatsFinished = 0;

    POPBasicAnimation *shakeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    shakeIn.duration = duration * 0.125;
    shakeIn.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear];
    shakeIn.toValue = [NSValue valueWithCGPoint:left];
    shakeIn.removedOnCompletion = NO;
    shakeIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            POPBasicAnimation *shakeRepeat = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            shakeRepeat.duration = duration * 0.25;
            shakeRepeat.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear];
//            shakeRepeat.fromValue = [NSValue valueWithCGPoint:left];
            shakeRepeat.toValue = [NSValue valueWithCGPoint:right];
            shakeRepeat.repeatCount = 3;
            shakeRepeat.autoreverses = YES;
            shakeRepeat.removedOnCompletion = NO;
            shakeRepeat.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//                repeatsFinished++;
//                LOG(General, "completion: %d : %d", repeatsFinished, finished);
                if (finished) {
                    POPBasicAnimation *shakeOut = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                    shakeOut.duration = duration * 0.125;
                    shakeOut.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear];
//                    shakeOut.fromValue = [NSValue valueWithCGPoint:right];
                    shakeOut.toValue = [NSValue valueWithCGPoint:center];
                    shakeOut.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                        [self pop_removeAnimationForKey:@"shake-repeat"];
                        [self pop_removeAnimationForKey:@"shake-in"];
                        if (completion) {
                            completion(finished);
                        }
                    };
                    [self pop_addAnimation:shakeOut forKey:@"shake-out"];
                }
            };
            [self pop_addAnimation:shakeRepeat forKey:@"shake-repeat"];
        }
    };
    [self pop_addAnimation:shakeIn forKey:@"shake-in"];
}

#pragma mark - Fade

- (void)fadeWithDuration:(CFTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    POPBasicAnimation *fade = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fade.duration = duration;
    fade.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutCirc];
    fade.toValue = @(0);
    fade.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (completion) {
            completion(finished);
        }
    };
    [self pop_addAnimation:fade forKey:@"fade"];
}

#pragma mark - Bloop

- (void)bloopWithDuration:(CFTimeInterval)duration toPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion
{
    static constexpr CGFloat _Divisor = M_PI * 0.75;
    static constexpr CGFloat _TL_A = M_PI * -0.75;
    static constexpr CGFloat _TR_A = M_PI * -0.25;
    static constexpr CGFloat _BL_A = M_PI * 0.75;
    static constexpr CGFloat _BR_A = M_PI * 0.25;

    CGRect bounds = self.bounds;
    CGPoint center = self.center;
    CGFloat dx = position.x - center.x;
    CGFloat dy = position.y - center.y;
    CGFloat angle = atan2(dy, dx);

    CGFloat tl_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_TL_A, angle) / _Divisor), 0);
    CGFloat tr_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_TR_A, angle) / _Divisor), 0);
    CGFloat bl_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_BL_A, angle) / _Divisor), 0);
    CGFloat br_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_BR_A, angle) / _Divisor), 0);

    static constexpr CGFloat _MaxStretch = 2.0;
    static constexpr CGFloat _MaxStretchPercentage = 0.02;

    static constexpr CGFloat _MaxSquish = 2.0;
    static constexpr CGFloat _MaxSquishPercentage = 0.02;

    CGFloat effectiveMaxStretchX = UPMinT(CGFloat, CGRectGetWidth(bounds) * _MaxStretchPercentage, _MaxStretch);
    CGFloat effectiveMaxStretchY = UPMinT(CGFloat, CGRectGetHeight(bounds) * _MaxStretchPercentage, _MaxStretch);

    CGFloat dx_stretch = UPClampT(CGFloat, dx * 0.15, -effectiveMaxStretchX, effectiveMaxStretchX);
    CGFloat dy_stretch = UPClampT(CGFloat, dy * 0.15, -effectiveMaxStretchY, effectiveMaxStretchY);

    CGFloat effectiveMaxSquishX = UPMinT(CGFloat, CGRectGetWidth(bounds) * _MaxSquishPercentage, _MaxSquish);
    CGFloat effectiveMaxSquishY = UPMinT(CGFloat, CGRectGetHeight(bounds) * _MaxSquishPercentage, _MaxSquish);

    CGFloat up_squish = 0;
    CGFloat down_squish = 0;
    CGFloat right_squish = 0;
    CGFloat left_squish = 0;

    CGFloat angle_deg = (RAD2DEG * angle) + 90;
    if ((angle_deg >= 0 && angle_deg < 90) || (angle_deg >= -90 && angle_deg < 0)) {
        up_squish = UPMinT(CGFloat, sin(angle) * _MaxStretch, effectiveMaxSquishX);
    }
    if (angle_deg >= 90 && angle_deg < 270) {
        down_squish = UPMinT(CGFloat, -sin(angle) * _MaxStretch, effectiveMaxSquishX);
    }
    if ((angle_deg >= 0 && angle_deg < 180)) {
        right_squish = UPMinT(CGFloat, -cos(angle) * _MaxStretch, effectiveMaxSquishY);
    }
    if ((angle_deg >= 180 && angle_deg < 270) || (angle_deg >= -90 && angle_deg < 0)) {
        left_squish = UPMinT(CGFloat, cos(angle) * _MaxStretch, effectiveMaxSquishY);
    }
    
    UPOffset tl_o = UPOffsetMake((tl_f * dx_stretch) + up_squish, (tl_f * dy_stretch) + left_squish);
    UPOffset tr_o = UPOffsetMake((tr_f * dx_stretch) - up_squish, (tr_f * dy_stretch) + right_squish);
    UPOffset bl_o = UPOffsetMake((bl_f * dx_stretch) + down_squish, (bl_f * dy_stretch) - left_squish);
    UPOffset br_o = UPOffsetMake((br_f * dx_stretch) - down_squish, (br_f * dy_stretch) - right_squish);

    UPQuadOffsets quadOffsets = UPQuadOffsetsMake(tl_o, tr_o, bl_o, br_o);

    static constexpr CFTimeInterval _MoveDelay = 4.0 / 60.0;

    CFTimeInterval stretchDuration = duration * 0.25;
    CFTimeInterval restoreDelay = stretchDuration;
    CFTimeInterval restoreDuration = duration - stretchDuration;
    CFTimeInterval moveDelay = duration < _MoveDelay * 2 ? 0 : _MoveDelay;
    CFTimeInterval moveDuration = duration - moveDelay;

    POPBasicAnimation *stretch = [POPBasicAnimation animationWithPropertyNamed:kPOPViewQuadOffsets];
    stretch.duration = stretchDuration;
    stretch.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear];
    stretch.fromValue = [NSValue valueWithQuadOffsets:UPQuadOffsetsZero];
    stretch.toValue = [NSValue valueWithQuadOffsets:quadOffsets];
    
    stretch.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        POPBasicAnimation *restore = [POPBasicAnimation animationWithPropertyNamed:kPOPViewQuadOffsets];
        restore.beginTime = restoreDelay;
        restore.duration = restoreDuration;
        restore.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutBack];
        restore.fromValue = [NSValue valueWithQuadOffsets:quadOffsets];
        restore.toValue = [NSValue valueWithQuadOffsets:UPQuadOffsetsZero];
        [self pop_addAnimation:restore forKey:@"restore"];
    };
    [self pop_addAnimation:stretch forKey:@"stretch"];

    POPBasicAnimation *move = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    move.beginTime = moveDelay;
    move.duration = moveDuration;
    move.additive = YES;
    move.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutBack];
    move.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    move.toValue = [NSValue valueWithCGPoint:CGPointMake(dx, dy)];
    move.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (completion) {
            completion(finished);
        }
    };
    [self pop_addAnimation:move forKey:@"move"];

    POPBasicAnimation *shadow1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowOpacity];
    shadow1.duration = duration * 0.5;
    shadow1.fromValue = @(0);
    shadow1.toValue = @(1);
    shadow1.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseInQuad];
    shadow1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        POPBasicAnimation *shadow2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerShadowOpacity];
        shadow2.duration = duration * 0.5;
        shadow2.fromValue = @(1);
        shadow2.toValue = @(0);
        shadow2.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutQuad];
        [self.layer pop_addAnimation:shadow2 forKey:@"shadow"];
    };
    [self.layer pop_addAnimation:shadow1 forKey:@"shadow"];
}

@end
