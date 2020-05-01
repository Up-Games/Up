//
//  UPShapeView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPShapeView.h"
#import "POPPathAnimation.h"

#define ShapeLayer() ((CAShapeLayer *)self.layer)

@interface UPShapeView ()
@property (nonatomic) CGPathRef path;
@end

@implementation UPShapeView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)setShape:(UIBezierPath *)shape
{
    _shape = shape;
    self.path = _shape.CGPath;
}

@dynamic shapeFillColor;
- (void)setShapeFillColor:(UIColor *)shapeFillColor
{
    ShapeLayer().fillColor = shapeFillColor ? shapeFillColor.CGColor : nil;
}

- (UIColor *)shapeFillColor
{
    return ShapeLayer().fillColor ? [UIColor colorWithCGColor:ShapeLayer().fillColor] : nil;
}

@dynamic shapeStrokeColor;
- (void)setShapeStrokeColor:(UIColor *)shapeStrokeColor
{
    ShapeLayer().strokeColor = shapeStrokeColor ? shapeStrokeColor.CGColor : nil;
}

- (UIColor *)strokeColor
{
    return ShapeLayer().strokeColor ? [UIColor colorWithCGColor:ShapeLayer().strokeColor] : nil;
}

@dynamic shapeLineWidth;
- (void)setShapeLineWidth:(CGFloat)shapeLineWidth
{
    ShapeLayer().lineWidth = shapeLineWidth;
}

- (CGFloat)shapeLineWidth
{
    return ShapeLayer().lineWidth;
}

@dynamic path;
- (void)setPath:(CGPathRef)path
{
    ShapeLayer().path = path;
}

- (CGPathRef)path
{
    return ShapeLayer().path;
}

#pragma mark - POPPathAnimationDelegate

- (void)pathAnimationUpdated:(POPPathAnimation *)animation
{
    self.shape = animation.interpolatedPath;
}


@end
