//
//  UPGeometry.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <simd/simd.h>

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UPKit/UPMacros.h>
#import <UPKit/UPMath.h>
#import <UPKit/UPTypes.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct __attribute__((objc_boxable)) UPQuad {
    CGPoint tl, tr, bl, br;
} UPQuad;

typedef struct __attribute__((objc_boxable)) UPOffset {
    CGFloat dx, dy;
} UPOffset;

typedef struct __attribute__((objc_boxable)) UPQuadOffsets {
    UPOffset tl, tr, bl, br;
} UPQuadOffsets;

UP_STATIC_CONST UPQuad UPQuadZero = (UPQuad){0, 0, 0, 0};
UP_STATIC_CONST UPOffset UPOffsetZero = (UPOffset){0, 0};
UP_STATIC_CONST UPQuadOffsets UPQuadOffsetsZero = (UPQuadOffsets){0, 0, 0, 0, 0, 0, 0, 0};

UP_STATIC_INLINE UPQuad UPQuadMake(CGPoint tl, CGPoint tr, CGPoint bl, CGPoint br) {
    return (UPQuad){tl, tr, bl, br};
}

UP_STATIC_INLINE UPOffset UPOffsetMake(CGFloat dx, CGFloat dy) {
    return (UPOffset){dx, dy};
}
UP_STATIC_INLINE UPQuad UPQuadMakeWithRectAndOffsets(CGRect rect, UPQuadOffsets offsets) {
    CGPoint tl = CGPointMake(CGRectGetMinX(rect) + offsets.tl.dx, CGRectGetMinY(rect) + offsets.tl.dy);
    CGPoint tr = CGPointMake(CGRectGetMaxX(rect) + offsets.tr.dx, CGRectGetMinY(rect) + offsets.tr.dy);
    CGPoint bl = CGPointMake(CGRectGetMinX(rect) + offsets.bl.dx, CGRectGetMaxY(rect) + offsets.bl.dy);
    CGPoint br = CGPointMake(CGRectGetMaxX(rect) + offsets.br.dx, CGRectGetMaxY(rect) + offsets.br.dy);
    return UPQuadMake(tl, tr, bl, br);
}
UP_STATIC_INLINE UPQuad UPQuadMakeWithRect(CGRect rect) {
    return UPQuadMakeWithRectAndOffsets(rect, UPQuadOffsetsZero);
}
UP_STATIC_INLINE UPQuadOffsets UPQuadOffsetsMake(UPOffset tl, UPOffset tr, UPOffset bl, UPOffset br) {
    return (UPQuadOffsets){tl, tr, bl, br};
}
UP_STATIC_INLINE CGRect UPQuadBoundingBox(UPQuad q) {
    CGFloat xmin = UPMultiMinT(CGFloat, q.tl.x, q.tr.x, q.bl.x, q.br.x);
    CGFloat ymin = UPMultiMinT(CGFloat, q.tl.y, q.tr.y, q.bl.y, q.br.y);
    CGFloat xmax = UPMultiMaxT(CGFloat, q.tl.x, q.tr.x, q.bl.x, q.br.x);
    CGFloat ymax = UPMultiMaxT(CGFloat, q.tl.y, q.tr.y, q.bl.y, q.br.y);
    return CGRectMake(xmin, ymin, xmax - xmin, ymax - ymin);
}

UP_STATIC_INLINE CGFloat up_point_distance(CGPoint p1, CGPoint p2)
{
    simd_double2 s1 = simd_make_double2(p1.x, p1.y);
    simd_double2 s2 = simd_make_double2(p2.x, p2.y);
    return simd_distance(s1, s2);
}

CGRect up_rect_centered_in_rect(CGRect rectToCenter, CGRect referenceRect);
CGRect up_rect_centered_x_in_rect(CGRect rectToCenter, CGRect referenceRect);
CGRect up_rect_centered_y_in_rect(CGRect rectToCenter, CGRect referenceRect);
CGRect up_rect_scaled_centered_in_rect(CGRect rectToCenter, CGFloat scale, CGRect referenceRect);
CGRect up_rect_scaled_centered_x_in_rect(CGRect rectToCenter, CGFloat scale, CGRect referenceRect);
CGRect up_rect_scaled_centered_y_in_rect(CGRect rectToCenter, CGFloat scale, CGRect referenceRect);
CGRect up_rect_centered_around_point(CGRect rectToCenter, CGPoint referencePoint);
CGPoint up_rect_center(CGRect);
CGFloat up_aspect_ratio_for_size(CGSize);
CGFloat up_aspect_ratio_for_rect(CGRect);

CGFloat up_bezier_quadratic(CGFloat A, CGFloat B, CGFloat C, CGFloat t);
CGFloat up_bezier_cubic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat t);
CGFloat up_bezier_quartic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat t);
CGFloat up_bezier_quintic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat F, CGFloat t);
CGFloat up_bezier_sextic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat F, CGFloat G, CGFloat t);

CATransform3D up_transform_for_rect_to_quad(CGRect rect, UPQuadOffsets offsets);

UP_STATIC_INLINE CGFloat up_angular_difference(CGFloat a, CGFloat b)
{
    return 360.0 - fabs(360.0 - fabs(a - b));
}

UP_STATIC_INLINE CGFloat up_radian_difference(CGFloat a, CGFloat b)
{
    return M_PI - fabs(M_PI - fabs(a - b));
}

UP_STATIC_INLINE double up_lerp_doubles(double a, double b, UPUnit f)
{
    return a + ((b - a) * f);
}

UP_STATIC_INLINE CGPoint up_lerp_points(CGPoint a, CGPoint b, UPUnit f)
{
    return CGPointMake(a.x + ((b.x - a.x) * f), a.y + ((b.y - a.y) * f));
}

UP_STATIC_INLINE CGSize up_lerp_sizes(CGSize a, CGSize b, UPUnit f)
{
    return CGSizeMake(a.width + ((b.width - a.width) * f), a.height + ((b.height - a.height) * f));
}

UP_STATIC_INLINE CGRect up_lerp_rects(CGRect a, CGRect b, UPUnit f)
{
    CGPoint p = up_lerp_points(a.origin, b.origin, f);
    CGSize s = up_lerp_sizes(a.size, b.size, f);
    return CGRectMake(p.x, p.y, s.width, s.height);
}

UP_STATIC_INLINE CGAffineTransform up_lerp_transforms(CGAffineTransform a, CGAffineTransform b, UPUnit f)
{
    CGFloat fa = a.a + ((b.a - a.a) * f);
    CGFloat fb = a.b + ((b.b - a.b) * f);
    CGFloat fc = a.c + ((b.c - a.c) * f);
    CGFloat fd = a.d + ((b.d - a.d) * f);
    CGFloat ftx = a.tx + ((b.tx - a.tx) * f);
    CGFloat fty = a.ty + ((b.ty - a.ty) * f);
    return CGAffineTransformMake(fa, fb, fc, fd, ftx, fty);
}

#ifdef __OBJC__
NSString *NSStringFromUPQuad(UPQuad);
NSString *NSStringFromUPOffset(UPOffset);
NSString *NSStringFromUPQuadOffsets(UPQuadOffsets);
#endif  // __OBJC__

#ifdef __cplusplus
}  // extern "C"
#endif
