//
//  UIView+UP.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>
#import <math.h>

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

#pragma mark - quadOffsets

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

- (void)bloopWithDuration:(UPTick)duration toPosition:(CGPoint)position size:(CGSize)size
{
    static constexpr CGFloat _Divisor = M_PI * 0.75;
    static constexpr CGFloat _TL_A = M_PI * -0.75;
    static constexpr CGFloat _TR_A = M_PI * -0.25;
    static constexpr CGFloat _BL_A = M_PI * 0.75;
    static constexpr CGFloat _BR_A = M_PI * 0.25;

    CGRect startFrame = self.frame;
    CGPoint center = up_rect_center(startFrame);
    CGFloat dx = position.x - center.x;
    CGFloat dy = position.y - center.y;
    CGFloat angle = atan2(dy, dx);

    CGFloat tl_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_TL_A, angle) / _Divisor), 0);
    CGFloat tr_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_TR_A, angle) / _Divisor), 0);
    CGFloat bl_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_BL_A, angle) / _Divisor), 0);
    CGFloat br_f = UPMaxT(CGFloat, 1.0 - (up_radian_difference(_BR_A, angle) / _Divisor), 0);
 
    static constexpr CGFloat _MaxStretch = 20;
    static constexpr CGFloat _MaxStretchPercentage = 0.20;

    CGFloat effectiveMaxStretchX = UPMinT(CGFloat, CGRectGetWidth(startFrame) * _MaxStretchPercentage, _MaxStretch);
    CGFloat effectiveMaxStretchY = UPMinT(CGFloat, CGRectGetHeight(startFrame) * _MaxStretchPercentage, _MaxStretch);

    CGFloat dx_stretch = UPClampT(CGFloat, dx * 0.15, -effectiveMaxStretchX, effectiveMaxStretchX);
    CGFloat dy_stretch = UPClampT(CGFloat, dy * 0.15, -effectiveMaxStretchY, effectiveMaxStretchY);

    UPOffset tl_o = UPOffsetMake(tl_f * dx_stretch, tl_f * dy_stretch);
    UPOffset tr_o = UPOffsetMake(tr_f * dx_stretch, tr_f * dy_stretch);
    UPOffset bl_o = UPOffsetMake(bl_f * dx_stretch, bl_f * dy_stretch);
    UPOffset br_o = UPOffsetMake(br_f * dx_stretch, br_f * dy_stretch);

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

    CGRect endFrame = up_rect_centered_around_point(CGRectMake(0, 0, size.width, size.height), center);

    POPBasicAnimation *move = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    move.beginTime = moveDelay;
    move.duration = moveDuration;
    move.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOutBack];
    move.fromValue = [NSValue valueWithCGRect:startFrame];
    move.toValue = [NSValue valueWithCGRect:CGRectOffset(endFrame, dx, dy)];
    move.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//        NSLog(@"done: %@", finished ? @"Y" : @"N");
    };
    [self pop_addAnimation:move forKey:@"move"];
}

@end
