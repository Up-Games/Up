//
//  UPShapeView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPShapeView : UIView
@property (nonatomic) UIBezierPath *shape;
@property (nonatomic) UIColor *shapeFillColor;
@property (nonatomic) UIColor *shapeStrokeColor;
@property (nonatomic) CGFloat shapeLineWidth;
@end
