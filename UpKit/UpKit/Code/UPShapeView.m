//
//  UPShapeView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPShapeView.h"

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
//    [self.layer setValue:shape forKey:NSStringFromSelector(@selector(shape))];
    self.path = _shape.CGPath;
}

//- (void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    ShapeLayer().fillColor = backgroundColor ? backgroundColor.CGColor : nil;
//    [self.layer setValue:backgroundColor forKey:NSStringFromSelector(@selector(backgroundColor))];
//}
//
//- (UIColor *)backgroundColor
//{
//    return ShapeLayer().fillColor ? [UIColor colorWithCGColor:ShapeLayer().fillColor] : nil;
//}

@dynamic shapeFillColor;
- (void)setShapeFillColor:(UIColor *)shapeFillColor
{
    ShapeLayer().fillColor = shapeFillColor ? shapeFillColor.CGColor : nil;
//    [self.layer setValue:shapeFillColor forKey:NSStringFromSelector(@selector(shapeFillColor))];
}

- (UIColor *)shapeFillColor
{
    return ShapeLayer().fillColor ? [UIColor colorWithCGColor:ShapeLayer().fillColor] : nil;
}

@dynamic strokeColor;
- (void)setStrokeColor:(UIColor *)strokeColor
{
    ShapeLayer().strokeColor = strokeColor ? strokeColor.CGColor : nil;
}

- (UIColor *)strokeColor
{
    return ShapeLayer().strokeColor ? [UIColor colorWithCGColor:ShapeLayer().strokeColor] : nil;
}

@dynamic lineWidth;
- (void)setLineWidth:(CGFloat)lineWidth
{
    ShapeLayer().lineWidth = lineWidth;
}

- (CGFloat)lineWidth
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

#pragma mark - CoreAnimation

#if 0
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key
{
//    NSLog(@"*** mirrorAnimation: %@ => %@", key, layer);
    if ([key isEqualToString:NSStringFromSelector(@selector(shapeFillColor))]) {
        NSObject<CAAction> *action = (NSObject<CAAction> *)[self actionForLayer:layer forKey:NSStringFromSelector(@selector(backgroundColor))];
        if (![action isKindOfClass:[NSNull class]] && [action isKindOfClass:[CAAnimation class]] ) {
            CAAnimation *mirrorAnimation = (CAAnimation *)action;
//            NSLog(@"*** mirrorAnimation: %@ => %@", key, layer);

            UIColor *currentFillColor = [layer valueForKey:NSStringFromSelector(@selector(shapeFillColor))];
            CGColorRef presentationFillColor = (__bridge CGColorRef)([layer.presentationLayer valueForKey:NSStringFromSelector(@selector(fillColor))]);
            CGColorRef currentColor = currentFillColor.CGColor;
            CGColorRef targetColor = self.shapeFillColor.CGColor;

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
            animation.fromValue = (__bridge id _Nullable)(presentationFillColor);
            animation.toValue = (__bridge id _Nullable)(targetColor);
            
            animation.beginTime = mirrorAnimation.beginTime;
            animation.duration = mirrorAnimation.duration;
            animation.speed = mirrorAnimation.speed;
            animation.timeOffset = mirrorAnimation.timeOffset;
            animation.repeatCount = mirrorAnimation.repeatCount;
            animation.repeatDuration = mirrorAnimation.repeatDuration;
            animation.autoreverses = mirrorAnimation.autoreverses;
            animation.fillMode = mirrorAnimation.fillMode;
            animation.timingFunction = mirrorAnimation.timingFunction;
            animation.delegate = mirrorAnimation.delegate;
            animation.removedOnCompletion = mirrorAnimation.removedOnCompletion;

            [self.layer addAnimation:animation forKey:@"shapeFillColor"];
        }
    }

    if ([key isEqualToString:NSStringFromSelector(@selector(shape))]) {
        NSObject<CAAction> *action = (NSObject<CAAction> *)[self actionForLayer:layer forKey:NSStringFromSelector(@selector(backgroundColor))];
        NSLog(@"*** action: %@ => %@", action, layer);
        if (![action isKindOfClass:[NSNull class]] && [action isKindOfClass:[CAAnimation class]] ) {
            CAAnimation *mirrorAnimation = (CAAnimation *)action;

            UIBezierPath *currentShape = [layer valueForKey:NSStringFromSelector(@selector(shape))];
            UIBezierPath *targetShape = self.shape;

            CGPathRef currentPath = currentShape.CGPath;
            CGPathRef targetPath = targetShape.CGPath;

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.fromValue = (__bridge id _Nullable)(currentPath);
            animation.toValue = (__bridge id _Nullable)(targetPath);
            
            animation.beginTime = mirrorAnimation.beginTime;
            animation.duration = mirrorAnimation.duration;
            animation.speed = mirrorAnimation.speed;
            animation.timeOffset = mirrorAnimation.timeOffset;
            animation.repeatCount = mirrorAnimation.repeatCount;
            animation.repeatDuration = mirrorAnimation.repeatDuration;
            animation.autoreverses = mirrorAnimation.autoreverses;
            animation.fillMode = mirrorAnimation.fillMode;
            animation.timingFunction = mirrorAnimation.timingFunction;
            animation.delegate = mirrorAnimation.delegate;
            animation.removedOnCompletion = mirrorAnimation.removedOnCompletion;

            [self.layer addAnimation:animation forKey:@"path"];
        }
    }
    return [super actionForLayer:layer forKey:key];
}
#endif

@end
