//
//  UPGeometry.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#ifdef __cplusplus
extern "C" {
#endif

CGFloat up_point_distance(CGPoint p1, CGPoint p2);
CGRect up_rect_centered_in_rect(CGRect rectToCenter, CGRect referenceRect);
CGRect up_rect_centered_x_in_rect(CGRect rectToCenter, CGRect referenceRect);
CGRect up_rect_centered_y_in_rect(CGRect rectToCenter, CGRect referenceRect);
CGRect up_rect_centered_around_point(CGRect rectToCenter, CGPoint referencePoint);
CGPoint up_rect_center(CGRect rect);

CGFloat up_bezier_quadratic(CGFloat A, CGFloat B, CGFloat C, CGFloat t);
CGFloat up_bezier_cubic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat t);
CGFloat up_bezier_quartic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat t);
CGFloat up_bezier_quintic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat F, CGFloat t);
CGFloat up_bezier_sextic(CGFloat A, CGFloat B, CGFloat C, CGFloat D, CGFloat E, CGFloat F, CGFloat G, CGFloat t);

#ifdef __cplusplus
}  // extern "C"
#endif
