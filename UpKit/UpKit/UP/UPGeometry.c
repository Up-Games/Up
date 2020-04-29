//
//  UPGeometry.c
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <simd/simd.h>

#import "UPGeometry.h"

#ifdef __cplusplus
extern "C" {
#endif

CGFloat up_point_distance(CGPoint p1, CGPoint p2)
{
    simd_double2 s1 = simd_make_double2(p1.x, p1.y);
    simd_double2 s2 = simd_make_double2(p2.x, p2.y);
    return simd_distance(s1, s2);
}

CGRect up_rect_centered_in_rect(CGRect rectToCenter, CGRect referenceRect)
{
    CGFloat x = CGRectGetMidX(referenceRect) - (CGRectGetWidth(rectToCenter) * 0.5);
    CGFloat y = CGRectGetMidY(referenceRect) - (CGRectGetHeight(rectToCenter) * 0.5);
    return CGRectMake(x, y, CGRectGetWidth(rectToCenter), CGRectGetHeight(rectToCenter));
}

CGRect up_rect_centered_x_in_rect(CGRect rectToCenter, CGRect referenceRect)
{
    CGFloat x = CGRectGetMidX(referenceRect) - (CGRectGetWidth(rectToCenter) * 0.5);
    return CGRectMake(x, CGRectGetMinY(rectToCenter), CGRectGetWidth(rectToCenter), CGRectGetHeight(rectToCenter));
}

CGRect up_rect_centered_y_in_rect(CGRect rectToCenter, CGRect referenceRect)
{
    CGFloat y = CGRectGetMidY(referenceRect) - (CGRectGetHeight(rectToCenter) * 0.5);
    return CGRectMake(CGRectGetMinX(rectToCenter), y, CGRectGetWidth(rectToCenter), CGRectGetHeight(rectToCenter));
}

CGRect up_rect_centered_around_point(CGRect rectToCenter, CGPoint referencePoint)
{
    CGFloat x = referencePoint.x - (CGRectGetWidth(rectToCenter) * 0.5);
    CGFloat y = referencePoint.y - (CGRectGetHeight(rectToCenter) * 0.5);
    return CGRectMake(x, y, CGRectGetWidth(rectToCenter), CGRectGetHeight(rectToCenter));
}

CGPoint up_rect_center(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGFloat up_bezier_mix(CGFloat a, CGFloat b, CGFloat t)
{
    // degree 1
    return a * (1.0f - t) + (b * t);
}

CGFloat up_bezier_quadratic(CGFloat A, CGFloat B, CGFloat C, CGFloat t)
{
    // degree 2
    CGFloat AB = up_bezier_mix(A, B, t);
    CGFloat BC = up_bezier_mix(B, C, t);
    return up_bezier_mix(AB, BC, t);
}

CGFloat up_bezier_cubic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat t)
{
    // degree 3
    CGFloat ABC = up_bezier_quadratic(A, B, C, t);
    CGFloat BCD = up_bezier_quadratic(B, C, D, t);
    return up_bezier_mix(ABC, BCD, t);
}

CGFloat up_bezier_quartic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat t)
{
    // degree 4
    CGFloat ABCD = up_bezier_cubic(A, B, C, D, t);
    CGFloat BCDE = up_bezier_cubic(B, C, D, E, t);
    return up_bezier_mix(ABCD, BCDE, t);
}

CGFloat up_bezier_quintic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat F, CGFloat t)
{
    // degree 5
    CGFloat ABCDE = up_bezier_quartic(A, B, C, D, E, t);
    CGFloat BCDEF = up_bezier_quartic(B, C, D, E, F, t);
    return up_bezier_mix(ABCDE, BCDEF, t);
}

CGFloat up_bezier_sextic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat F, CGFloat G, CGFloat t)
{
    // degree 6
    CGFloat ABCDEF = up_bezier_quintic(A, B, C, D, E, F, t);
    CGFloat BCDEFG = up_bezier_quintic(B, C, D, E, F, G, t);
    return up_bezier_mix(ABCDEF, BCDEFG, t);
}

#ifdef __cplusplus
}  // extern "C"
#endif
