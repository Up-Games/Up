//
//  UPBezierPathView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPBezierPathView.h"
#import "UPMath.h"
#import "POPPathAnimation.h"

#define ShapeLayer() ((CAShapeLayer *)self.layer)

@interface UPBezierPathView ()
@property (nonatomic, readwrite) CGAffineTransform pathTransform;
@property (nonatomic) UIBezierPath *effectivePath;
@property (nonatomic) BOOL needsPathUpdate;
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
    [self setNeedsPathUpdate];
}

- (void)setCanonicalSize:(CGSize)canonicalSize
{
    _canonicalSize = canonicalSize;
    [self setNeedsPathUpdate];
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

#pragma mark - POPPathAnimationDelegate

- (void)pathAnimationUpdated:(POPPathAnimation *)animation
{
    self.path = animation.interpolatedPath;
}

#pragma mark - Geometry and Layout

- (void)setNeedsPathUpdate
{
    self.needsPathUpdate = YES;
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    self.needsPathUpdate = YES;
}

- (void)layoutSubviews
{
    if (self.needsPathUpdate) {
        [self _updatePath];
    }
    self.needsPathUpdate = NO;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.path ? self.path.bounds.size : CGSizeZero;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsPathUpdate];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setNeedsPathUpdate];
}

- (void)_updatePath
{
    if (!self.path) {
        self.effectivePath = nil;
        ShapeLayer().path = nil;
        return;
    }

    CGRect bounds = self.bounds;
    CGFloat pathWidth = self.canonicalSize.width;
    CGFloat pathHeight = self.canonicalSize.height;
    switch (self.contentMode) {
        case UIViewContentModeScaleToFill: {
            if (up_is_fuzzy_equal(CGRectGetWidth(bounds), pathWidth) && up_is_fuzzy_equal(CGRectGetHeight(bounds), pathHeight)) {
                self.pathTransform = CGAffineTransformIdentity;
            }
            else {
                CGFloat sx = pathWidth > 0 ? (CGRectGetWidth(bounds) / pathWidth) : 0;
                CGFloat sy = pathHeight > 0 ? (CGRectGetHeight(bounds) / pathHeight) : 0;
                self.pathTransform = CGAffineTransformMakeScale(sx, sy);
            }
            break;
        }
        case UIViewContentModeScaleAspectFit: {
            break;
        }
        case UIViewContentModeScaleAspectFill: {
            break;
        }
        case UIViewContentModeRedraw: {
            break;
        }
        case UIViewContentModeCenter: {
            break;
        }
        case UIViewContentModeTop: {
            break;
        }
        case UIViewContentModeBottom: {
            break;
        }
        case UIViewContentModeLeft: {
            break;
        }
        case UIViewContentModeRight: {
            break;
        }
        case UIViewContentModeTopLeft: {
            break;
        }
        case UIViewContentModeTopRight: {
            break;
        }
        case UIViewContentModeBottomLeft: {
            break;
        }
        case UIViewContentModeBottomRight: {
            break;
        }
    }

    if (CGAffineTransformEqualToTransform(self.pathTransform, CGAffineTransformIdentity)) {
        self.effectivePath = self.path;
    }
    else {
        self.effectivePath = [self.path copy];
        [self.effectivePath applyTransform:self.pathTransform];
    }
    ShapeLayer().path = self.effectivePath.CGPath;
}

@end
