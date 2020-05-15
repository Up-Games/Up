//
//  UPGeometry.c
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPGeometry.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma mark - Points, Sizes, and Rects

CGSize up_size_scaled(CGSize size, CGFloat scale)
{
    return CGSizeMake(size.width * scale, size.height * scale);
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

CGRect up_rect_scaled(CGRect rect, CGFloat scale)
{
    CGFloat x = CGRectGetMinX(rect) * scale;
    CGFloat y = CGRectGetMinY(rect) * scale;
    CGFloat w = CGRectGetWidth(rect) * scale;
    CGFloat h = CGRectGetHeight(rect) * scale;
    return CGRectMake(x, y, w, h);
}

CGRect up_rect_centered_in_rect_scaled(CGRect rectToCenter, CGFloat scale, CGRect referenceRect)
{
    CGFloat w = CGRectGetWidth(rectToCenter) * scale;
    CGFloat h = CGRectGetHeight(rectToCenter) * scale;
    return up_rect_centered_in_rect(CGRectMake(0, 0, w, h), referenceRect);
}

CGRect up_rect_scaled_centered_x_in_rect(CGRect rectToCenter, CGFloat scale, CGRect referenceRect)
{
    CGFloat y = CGRectGetMinY(referenceRect) + CGRectGetMinY(rectToCenter) * scale;
    CGFloat w = CGRectGetWidth(rectToCenter) * scale;
    CGFloat h = CGRectGetHeight(rectToCenter) * scale;
    return up_rect_centered_x_in_rect(CGRectMake(0, y, w, h), referenceRect);
}

CGRect up_rect_scaled_centered_y_in_rect(CGRect rectToCenter, CGFloat scale, CGRect referenceRect)
{
    CGFloat x = CGRectGetMinX(referenceRect) + CGRectGetMinX(rectToCenter) * scale;
    CGFloat w = CGRectGetWidth(rectToCenter) * scale;
    CGFloat h = CGRectGetHeight(rectToCenter) * scale;
    return up_rect_centered_y_in_rect(CGRectMake(x, 0, w, h), referenceRect);
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

CGFloat up_aspect_ratio_for_size(CGSize size)
{
    return size.width / size.height;
}

CGFloat up_aspect_ratio_for_rect(CGRect rect)
{
    return up_aspect_ratio_for_size(rect.size);
}

CGPoint up_pixel_point(CGPoint point, CGFloat screen_scale)
{
    CGFloat x = up_round_to_screen_scale(point.x, screen_scale);
    CGFloat y = up_round_to_screen_scale(point.y, screen_scale);
    return CGPointMake(x, y);
}

CGSize up_pixel_size(CGSize size, CGFloat screen_scale)
{
    CGFloat w = up_round_to_screen_scale(size.width, screen_scale);
    CGFloat h = up_round_to_screen_scale(size.height, screen_scale);
    return CGSizeMake(w, h);
}

CGRect up_pixel_rect(CGRect rect, CGFloat screen_scale)
{
    CGFloat x = up_round_to_screen_scale(CGRectGetMinX(rect), screen_scale);
    CGFloat y = up_round_to_screen_scale(CGRectGetMinY(rect), screen_scale);
    CGFloat w = up_round_to_screen_scale(CGRectGetWidth(rect), screen_scale);
    CGFloat h = up_round_to_screen_scale(CGRectGetHeight(rect), screen_scale);
    return CGRectMake(x, y, w, h);
}

// =========================================================================================================================================
#pragma mark - Bezier curves

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

// =========================================================================================================================================
#pragma mark - Quads

CATransform3D up_transform_for_rect_to_quad(CGRect rect, UPQuadOffsets offsets)
{
    UPQuad quad = UPQuadMakeWithRectAndOffsets(rect, offsets);
    CGRect bbox = UPQuadBoundingBox(quad);
    CGPoint bbox_tl = bbox.origin;

    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;

    CGFloat x1a = quad.tl.x - bbox_tl.x;
    CGFloat y1a = quad.tl.y - bbox_tl.y;
    CGFloat x2a = quad.tr.x - bbox_tl.x;
    CGFloat y2a = quad.tr.y - bbox_tl.y;
    CGFloat x3a = quad.bl.x - bbox_tl.x;
    CGFloat y3a = quad.bl.y - bbox_tl.y;
    CGFloat x4a = quad.br.x - bbox_tl.x;
    CGFloat y4a = quad.br.y - bbox_tl.y;

    CGFloat y21 = y2a - y1a;
    CGFloat y32 = y3a - y2a;
    CGFloat y43 = y4a - y3a;
    CGFloat y14 = y1a - y4a;
    CGFloat y31 = y3a - y1a;
    CGFloat y42 = y4a - y2a;

    CGFloat a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    CGFloat b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    CGFloat c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) -
        W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);

    CGFloat d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    CGFloat e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    CGFloat f = -(W*(x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a +
        x1a*Y*y3a*(-y2a + y4a)) - H*X*(x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)));

    CGFloat g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    CGFloat h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    CGFloat i = W*Y*(x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H*(X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) +
        W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));

    const double kEpsilon = 0.0001;

    if (fabs(i) < kEpsilon) {
        i = kEpsilon * (i > 0 ? 1.0 : -1.0);
    }

    CATransform3D transform = {a/i, d/i, 0, g/i, b/i, e/i, 0, h/i, 0, 0, 1, 0, c/i, f/i, 0, 1.0};

    CGPoint position = up_rect_center(rect);
    CGPoint anchorOffset = CGPointMake(position.x - bbox.origin.x, position.y - bbox.origin.y);
    CATransform3D transPos = CATransform3DMakeTranslation(anchorOffset.x, anchorOffset.y, 0.);
    CATransform3D transNeg = CATransform3DMakeTranslation(-anchorOffset.x, -anchorOffset.y, 0.);
    CATransform3D fullTransform = CATransform3DConcat(CATransform3DConcat(transPos, transform), transNeg);

    return fullTransform;
}

#ifdef __OBJC__

NSString *NSStringFromUPQuad(UPQuad q)
{
    return [NSString stringWithFormat:@"UPQuad: {tl: %.1f,%.1f; tr: %.1f,%.1f; bl: %.1f,%.1f; br: %.1f,%.1f}",
        q.tl.x, q.tl.y, q.tr.x, q.tr.y, q.bl.x, q.bl.y, q.br.x, q.br.y];
}

NSString *NSStringFromUPOffset(UPOffset q)
{
    return [NSString stringWithFormat:@"UPOffset: {dx,dy: %.1f,%.1f}", q.dx, q.dy];
}

NSString *NSStringFromUPQuadOffsets(UPQuadOffsets q)
{
    return [NSString stringWithFormat:@"UPQuadOffsets: {tl: %.1f,%.1f; tr: %.1f,%.1f; bl: %.1f,%.1f; br: %.1f,%.1f}",
        q.tl.dx, q.tl.dy, q.tr.dx, q.tr.dy, q.bl.dx, q.bl.dy, q.br.dx, q.br.dy];
}

#endif  // __OBJC__

#ifdef __cplusplus
}  // extern "C"
#endif
