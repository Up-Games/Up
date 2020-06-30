//
//  UPBezierPathView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPBezierPathView.h"
#import "UPMath.h"

#define ShapeLayer() ((CAShapeLayer *)self.layer)

@interface UPBezierPathView ()
@property (nonatomic, readwrite) CGAffineTransform pathTransform;
@property (nonatomic) UIBezierPath *effectivePath;
@end

@implementation UPBezierPathView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

+ (UPBezierPathView *)bezierPathView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

+ (UPBezierPathView *)bezierPathViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.pathTransform = CGAffineTransformIdentity;
    return self;
}

- (void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsUpdate];
}

- (void)setCanonicalSize:(CGSize)canonicalSize
{
    _canonicalSize = canonicalSize;
    [self setNeedsUpdate];
}

@dynamic shapeLayer;
- (CAShapeLayer *)shapeLayer
{
    return ShapeLayer();
}

@dynamic fillColor;
- (void)setFillColor:(UIColor *)fillColor
{
    ShapeLayer().fillColor = fillColor ? fillColor.CGColor : nil;
}

- (UIColor *)fillColor
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

@dynamic fillRule;
- (void)setFillRule:(CAShapeLayerFillRule)fillRule
{
    ShapeLayer().fillRule = fillRule;
}

- (CAShapeLayerFillRule)fillRule
{
    return ShapeLayer().fillRule;
}

@dynamic transformedPath;
- (UIBezierPath *)transformedPath
{
    return [self.effectivePath copy];
}

#pragma mark - Geometry and Layout

- (void)setNeedsUpdate
{
    [[UPNeedsUpdater instance] setNeedsUpdate:self order:UPNeedsUpdaterOrderSecond];
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    [self setNeedsUpdate];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.path ? self.path.bounds.size : CGSizeZero;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsUpdate];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setNeedsUpdate];
}

- (void)update
{
    if (!self.path) {
        self.effectivePath = nil;
        ShapeLayer().path = nil;
        return;
    }

    // This code could conceivably switch on -contentMode, and if I were writing
    // a framework, I would do so. However, since I'm writing an app, and all I
    // care about is scaling the path to fill a view's whose aspect ratio will
    // never change, that's all this code does.
    CGRect bounds = self.bounds;
    CGFloat pathWidth = self.canonicalSize.width;
    CGFloat pathHeight = self.canonicalSize.height;
    if (up_is_fuzzy_equal(CGRectGetWidth(bounds), pathWidth) && up_is_fuzzy_equal(CGRectGetHeight(bounds), pathHeight)) {
        self.pathTransform = CGAffineTransformIdentity;
        self.effectivePath = self.path;
    }
    else {
        CGFloat sx = pathWidth > 0 ? (CGRectGetWidth(bounds) / pathWidth) : 0;
        CGFloat sy = pathHeight > 0 ? (CGRectGetHeight(bounds) / pathHeight) : 0;
        self.pathTransform = CGAffineTransformMakeScale(sx, sy);
        self.effectivePath = [self.path copy];
        [self.effectivePath applyTransform:self.pathTransform];
    }

    ShapeLayer().path = self.effectivePath.CGPath;
}

@end
