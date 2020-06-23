//
//  UPHueWheel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPAssertions.h>
#import <UPKit/UPBand.h>
#import <UPKit/UPBezierPathView.h>
#import <UPKit/UIColor+UP.h>
#import <UPKit/UPColor.h>
#import <UPKit/UPGeometry.h>
#import <UPKit/UPMath.h>
#import <UPKit/UPTicker.h>
#import <UPKit/UPTimeSpanning.h>

#import "UPHueWheel.h"
#import "UPSpellLayout.h"

using UP::BandSettingsDelay;
using UP::SpellLayout;
using UP::TimeSpanning::cancel;

static UIBezierPath *HuePointerPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(113, 100.46)];
    [path addLineToPoint: CGPointMake(113, 96.52)];
    [path addLineToPoint: CGPointMake(111, 9.51)];
    [path addLineToPoint: CGPointMake(109, 9.51)];
    [path addLineToPoint: CGPointMake(107, 96.52)];
    [path addLineToPoint: CGPointMake(107, 100.46)];
    [path addCurveToPoint: CGPointMake(100, 110) controlPoint1: CGPointMake(102.94, 101.73) controlPoint2: CGPointMake(100, 105.52)];
    [path addCurveToPoint: CGPointMake(110, 120) controlPoint1: CGPointMake(100, 115.52) controlPoint2: CGPointMake(104.48, 120)];
    [path addCurveToPoint: CGPointMake(120, 110) controlPoint1: CGPointMake(115.52, 120) controlPoint2: CGPointMake(120, 115.52)];
    [path addCurveToPoint: CGPointMake(113, 100.46) controlPoint1: CGPointMake(120, 105.52) controlPoint2: CGPointMake(117.06, 101.73)];
    [path closePath];
    return path;
}

@interface UPHueWheel ()
@property (nonatomic) UPBezierPathView *spinnerView;
@property (nonatomic) CGFloat hueDelta;
@property (nonatomic) CGFloat unroundedHue;
@property (nonatomic) CGFloat previousUnroundedHue;
@end

@implementation UPHueWheel

+ (UPHueWheel *)hueWheel
{
    return [[UPHueWheel alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.multipleTouchEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.spinnerView = [UPBezierPathView bezierPathView];
    self.spinnerView.path = HuePointerPath();
    self.spinnerView.fillColor = [UIColor blackColor];
    self.spinnerView.canonicalSize = SpellLayout::CanonicalHuePickerSize;
    self.spinnerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self addSubview:self.spinnerView];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
    
    return self;
}

- (void)setHue:(CGFloat)hue
{
    if (self.previousUnroundedHue != self.unroundedHue) {
        self.previousUnroundedHue = self.unroundedHue;
    }
    self.unroundedHue = UPClampT(CGFloat, hue, 0, 360);
    _hue = roundf(self.unroundedHue);
    [self updateSpinner];
    [self.delegate hueWheelDidUpdate:self];
}

- (void)updateSpinner
{
    CGFloat angle = up_degrees_to_radians(self.hue);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.spinnerView.transform = transform;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    CGFloat radius = up_rect_mid_x(bounds);
    CGFloat innerRadius = radius * 0.9;
    CGPoint center = up_rect_center(bounds);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < 360; i++) {
        CGFloat angle = i - 90.0 + 0.5;
        while (angle < 0) {
            angle += 360;
        }
        while (angle > 360) {
            angle -= 360;
        }
        CGFloat angle1 = up_degrees_to_radians(angle);
        CGFloat x1 = center.x + radius * cos(angle1);
        CGFloat y1 = center.y + radius * sin(angle1);
        int plus = 2;
        if (i == 359) {
            plus = 1;
        }
        CGFloat angle2 = up_degrees_to_radians(angle + plus);
        CGFloat x2 = center.x + radius * cos(angle2);
        CGFloat y2 = center.y + radius * sin(angle2);
        CGContextSaveGState(ctx);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGContextAddLineToPoint(ctx, x1, y1);
        CGContextAddLineToPoint(ctx, x2, y2);
        CGContextClosePath(ctx);
        UIColor *color = [UIColor colorizedGray:0.7 hue:i saturation:0.9];
        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        CGContextSetRGBFillColor(ctx, r, g, b, a);
        CGContextFillPath(ctx);
        CGContextSaveGState(ctx);
    }

    for (int i = 0; i < 360; i += 15) {
        CGFloat hashAngle = up_degrees_to_radians(i);
        CGFloat x3 = center.x + radius * cos(hashAngle);
        CGFloat y3 = center.y + radius * sin(hashAngle);
        CGFloat x4 = center.x + innerRadius * cos(hashAngle);
        CGFloat y4 = center.y + innerRadius * sin(hashAngle);
        CGContextSaveGState(ctx);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, x3, y3);
        CGContextAddLineToPoint(ctx, x4, y4);
        CGContextClosePath(ctx);
        CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
        CGContextSetLineWidth(ctx, 1.5);
        CGContextStrokePath(ctx);
        CGContextSaveGState(ctx);
    }
    
    CGContextSaveGState(ctx);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    CGContextAddEllipseInRect(ctx, CGRectInset(bounds, 2.5, 2.5));
    CGContextSetLineWidth(ctx, 5);
    CGContextStrokePath(ctx);
    CGContextSaveGState(ctx);
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.spinnerView.center = up_rect_center(bounds);
    self.spinnerView.bounds = bounds;
}

- (void)updateHueWithPoint:(CGPoint)point
{
    CGRect bounds = self.bounds;
    CGPoint center = up_rect_center(bounds);
    CGFloat radians = atan2((center.y - point.y), (center.x - point.x));
    CGFloat angle = up_radians_to_degrees(radians);
    angle -= 90;
    while (angle < 0) {
        angle += 360;
    }
    while (angle > 360) {
        angle -= 360;
    }
    self.previousUnroundedHue = self.unroundedHue;
    self.hue = angle;
}

- (void)updateHueWithVelocity:(CGPoint)velocity
{
    CGFloat length = up_point_distance(CGPointZero, velocity);
    if (fabs(length) > 0.5) {
        CGFloat hue = self.unroundedHue + self.hueDelta;
        while (hue < 0) {
            hue += 360;
        }
        while (hue > 360) {
            hue -= 360;
        }
        self.hue = hue;
        UP::TimeSpanning::delay(BandSettingsDelay, UPTickerInterval, ^{
            CGFloat vx = UPClampT(CGFloat, velocity.x * 0.995, -5, 5);
            CGFloat vy = UPClampT(CGFloat, velocity.y * 0.995, -5, 5);
            if (self.hueDelta > 0 && self.hueDelta < 0.01) {
                self.hueDelta = 0.01;
            }
            else if (self.hueDelta < 0 && self.hueDelta > -0.01) {
                self.hueDelta = -0.01;
            }
            else {
                self.hueDelta = UPClampT(CGFloat, self.hueDelta * 0.99, -10, 10);
            }
            [self updateHueWithVelocity:CGPointMake(vx, vy)];
        });
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    cancel(BandSettingsDelay);
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self updateHueWithPoint:point];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStatePossible:
            // no-op
            break;
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [pan locationInView:self];
            [self updateHueWithPoint:point];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [pan velocityInView:self];
            CGFloat length = up_point_distance(CGPointZero, velocity);
            if (length > 100) {
                self.hueDelta = self.unroundedHue - self.previousUnroundedHue;
                if (self.hueDelta > 0 && self.hueDelta < 1) {
                    self.hueDelta = 1;
                }
                else if (self.hueDelta < 0 && self.hueDelta > -1) {
                    self.hueDelta = -1;
                }
                [self updateHueWithVelocity:velocity];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            break;
        }
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)cancelAnimations
{
    cancel(BandSettingsDelay);
}

@end
