//
//  UPChoice.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPTouchGestureRecognizer.h>

#import "UPSpellLayout.h"
#import "UPChoice.h"

using UP::SpellLayout;

static UIBezierPath *ChoiceFillPath()
{
    return [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 280, 76)];
}

static UIBezierPath *ChoiceStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, 76)];
    [path addLineToPoint: CGPointMake(280, 76)];
    [path addLineToPoint: CGPointMake(280, 0)];
    [path addLineToPoint: CGPointMake(0, 0)];
    [path addLineToPoint: CGPointMake(0, 76)];
    [path closePath];
    [path moveToPoint: CGPointMake(3, 3)];
    [path addLineToPoint: CGPointMake(277, 3)];
    [path addLineToPoint: CGPointMake(277, 73)];
    [path addLineToPoint: CGPointMake(3, 73)];
    [path addLineToPoint: CGPointMake(3, 3)];
    [path closePath];
    return path;
}

static UIBezierPath *ChoiceStrokePathWithWidth(CGFloat width)
{
    SpellLayout &layout = SpellLayout::instance();
    const CGFloat W = width;
    const CGFloat I = up_float_scaled(3, layout.layout_scale());
    const CGFloat H = up_float_scaled(76, layout.layout_scale());
    const CGFloat IX = I;
    const CGFloat IY = I;
    const CGFloat IW = W - I;
    const CGFloat IH = H - I;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, H)];
    [path addLineToPoint: CGPointMake(W, H)];
    [path addLineToPoint: CGPointMake(W, 0)];
    [path addLineToPoint: CGPointMake(0, 0)];
    [path closePath];
    [path moveToPoint: CGPointMake(IX, IY)];
    [path addLineToPoint: CGPointMake(IW, IY)];
    [path addLineToPoint: CGPointMake(IW, IH)];
    [path addLineToPoint: CGPointMake(IX, IH)];
    [path closePath];
    return path;
}

static UIBezierPath *ChoiceLeftFillPathSelected()
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(70.28, 24.34)];
    [path addCurveToPoint: CGPointMake(69.92, 23.9) controlPoint1: CGPointMake(70.17, 24.18) controlPoint2: CGPointMake(70.05, 24.04)];
    [path addLineToPoint: CGPointMake(69.25, 23.23)];
    [path addCurveToPoint: CGPointMake(68.59, 22.57) controlPoint1: CGPointMake(69.03, 23.01) controlPoint2: CGPointMake(68.81, 22.79)];
    [path addCurveToPoint: CGPointMake(68.15, 22.21) controlPoint1: CGPointMake(68.45, 22.44) controlPoint2: CGPointMake(68.3, 22.32)];
    [path addCurveToPoint: CGPointMake(67.07, 22.06) controlPoint1: CGPointMake(67.84, 22) controlPoint2: CGPointMake(67.47, 21.94)];
    [path addCurveToPoint: CGPointMake(66.38, 22.37) controlPoint1: CGPointMake(66.85, 22.12) controlPoint2: CGPointMake(66.63, 22.22)];
    [path addCurveToPoint: CGPointMake(64.83, 23.5) controlPoint1: CGPointMake(65.85, 22.67) controlPoint2: CGPointMake(65.38, 23.04)];
    [path addCurveToPoint: CGPointMake(62.69, 25.44) controlPoint1: CGPointMake(64.17, 24.06) controlPoint2: CGPointMake(63.47, 24.7)];
    [path addCurveToPoint: CGPointMake(59.78, 28.29) controlPoint1: CGPointMake(61.72, 26.39) controlPoint2: CGPointMake(60.74, 27.33)];
    [path addCurveToPoint: CGPointMake(47.38, 40.69) controlPoint1: CGPointMake(55.64, 32.42) controlPoint2: CGPointMake(51.51, 36.55)];
    [path addCurveToPoint: CGPointMake(45.45, 42.62) controlPoint1: CGPointMake(46.73, 41.33) controlPoint2: CGPointMake(46.09, 41.97)];
    [path addLineToPoint: CGPointMake(45.33, 42.14)];
    [path addCurveToPoint: CGPointMake(44.48, 38.97) controlPoint1: CGPointMake(45.04, 41.08) controlPoint2: CGPointMake(44.76, 40.02)];
    [path addLineToPoint: CGPointMake(44.45, 38.88)];
    [path addCurveToPoint: CGPointMake(43.52, 35.9) controlPoint1: CGPointMake(44.19, 37.89) controlPoint2: CGPointMake(43.91, 36.88)];
    [path addCurveToPoint: CGPointMake(43.05, 34.98) controlPoint1: CGPointMake(43.42, 35.64) controlPoint2: CGPointMake(43.27, 35.3)];
    [path addCurveToPoint: CGPointMake(42.46, 34.4) controlPoint1: CGPointMake(42.92, 34.79) controlPoint2: CGPointMake(42.74, 34.57)];
    [path addCurveToPoint: CGPointMake(41.37, 34.25) controlPoint1: CGPointMake(42.16, 34.23) controlPoint2: CGPointMake(41.8, 34.18)];
    [path addCurveToPoint: CGPointMake(40.85, 34.37) controlPoint1: CGPointMake(41.2, 34.28) controlPoint2: CGPointMake(41.02, 34.32)];
    [path addLineToPoint: CGPointMake(38.61, 34.97)];
    [path addCurveToPoint: CGPointMake(38.1, 35.13) controlPoint1: CGPointMake(38.44, 35.01) controlPoint2: CGPointMake(38.27, 35.07)];
    [path addCurveToPoint: CGPointMake(37.23, 35.8) controlPoint1: CGPointMake(37.7, 35.28) controlPoint2: CGPointMake(37.4, 35.5)];
    [path addCurveToPoint: CGPointMake(37.01, 36.6) controlPoint1: CGPointMake(37.07, 36.09) controlPoint2: CGPointMake(37.03, 36.36)];
    [path addCurveToPoint: CGPointMake(37.06, 37.64) controlPoint1: CGPointMake(36.98, 36.99) controlPoint2: CGPointMake(37.02, 37.36)];
    [path addCurveToPoint: CGPointMake(37.77, 40.76) controlPoint1: CGPointMake(37.21, 38.68) controlPoint2: CGPointMake(37.49, 39.71)];
    [path addCurveToPoint: CGPointMake(39.8, 48.33) controlPoint1: CGPointMake(38.44, 43.29) controlPoint2: CGPointMake(39.12, 45.81)];
    [path addCurveToPoint: CGPointMake(40.13, 49.46) controlPoint1: CGPointMake(39.9, 48.71) controlPoint2: CGPointMake(40.02, 49.08)];
    [path addLineToPoint: CGPointMake(40.32, 50.08)];
    [path addCurveToPoint: CGPointMake(40.83, 51.33) controlPoint1: CGPointMake(40.47, 50.56) controlPoint2: CGPointMake(40.64, 50.97)];
    [path addCurveToPoint: CGPointMake(41.42, 52.15) controlPoint1: CGPointMake(40.96, 51.59) controlPoint2: CGPointMake(41.13, 51.89)];
    [path addCurveToPoint: CGPointMake(41.87, 52.42) controlPoint1: CGPointMake(41.56, 52.27) controlPoint2: CGPointMake(41.71, 52.36)];
    [path addCurveToPoint: CGPointMake(42.37, 52.5) controlPoint1: CGPointMake(42.02, 52.47) controlPoint2: CGPointMake(42.19, 52.5)];
    [path addCurveToPoint: CGPointMake(42.79, 52.46) controlPoint1: CGPointMake(42.51, 52.5) controlPoint2: CGPointMake(42.64, 52.49)];
    [path addCurveToPoint: CGPointMake(43.46, 52.3) controlPoint1: CGPointMake(42.98, 52.42) controlPoint2: CGPointMake(43.18, 52.38)];
    [path addLineToPoint: CGPointMake(43.71, 52.23)];
    [path addCurveToPoint: CGPointMake(43.86, 52.18) controlPoint1: CGPointMake(43.76, 52.22) controlPoint2: CGPointMake(43.81, 52.2)];
    [path addCurveToPoint: CGPointMake(45.06, 51.43) controlPoint1: CGPointMake(44.3, 51.98) controlPoint2: CGPointMake(44.7, 51.71)];
    [path addCurveToPoint: CGPointMake(46.7, 50.05) controlPoint1: CGPointMake(45.68, 50.96) controlPoint2: CGPointMake(46.26, 50.45)];
    [path addLineToPoint: CGPointMake(46.98, 49.79)];
    [path addCurveToPoint: CGPointMake(51.8, 45.11) controlPoint1: CGPointMake(48.57, 48.33) controlPoint2: CGPointMake(50.04, 46.87)];
    [path addCurveToPoint: CGPointMake(64.2, 32.71) controlPoint1: CGPointMake(55.94, 40.98) controlPoint2: CGPointMake(60.07, 36.85)];
    [path addCurveToPoint: CGPointMake(67.05, 29.79) controlPoint1: CGPointMake(65.15, 31.75) controlPoint2: CGPointMake(66.1, 30.77)];
    [path addCurveToPoint: CGPointMake(68.99, 27.65) controlPoint1: CGPointMake(67.79, 29.02) controlPoint2: CGPointMake(68.42, 28.32)];
    [path addCurveToPoint: CGPointMake(70.12, 26.11) controlPoint1: CGPointMake(69.36, 27.21) controlPoint2: CGPointMake(69.79, 26.69)];
    [path addCurveToPoint: CGPointMake(70.43, 25.41) controlPoint1: CGPointMake(70.27, 25.86) controlPoint2: CGPointMake(70.37, 25.64)];
    [path addCurveToPoint: CGPointMake(70.28, 24.34) controlPoint1: CGPointMake(70.54, 25.01) controlPoint2: CGPointMake(70.49, 24.64)];
    [path closePath];
    return path;
}

static UIBezierPath *ChoiceRightFillPathSelected()
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(248.28, 21.09)];
    [path addCurveToPoint: CGPointMake(247.91, 20.65) controlPoint1: CGPointMake(248.17, 20.93) controlPoint2: CGPointMake(248.05, 20.79)];
    [path addLineToPoint: CGPointMake(247.25, 19.98)];
    [path addCurveToPoint: CGPointMake(246.59, 19.32) controlPoint1: CGPointMake(247.03, 19.76) controlPoint2: CGPointMake(246.81, 19.54)];
    [path addCurveToPoint: CGPointMake(246.15, 18.96) controlPoint1: CGPointMake(246.45, 19.19) controlPoint2: CGPointMake(246.3, 19.07)];
    [path addCurveToPoint: CGPointMake(245.07, 18.81) controlPoint1: CGPointMake(245.84, 18.75) controlPoint2: CGPointMake(245.47, 18.69)];
    [path addCurveToPoint: CGPointMake(244.38, 19.12) controlPoint1: CGPointMake(244.85, 18.87) controlPoint2: CGPointMake(244.63, 18.97)];
    [path addCurveToPoint: CGPointMake(242.83, 20.25) controlPoint1: CGPointMake(243.85, 19.42) controlPoint2: CGPointMake(243.38, 19.79)];
    [path addCurveToPoint: CGPointMake(240.69, 22.19) controlPoint1: CGPointMake(242.17, 20.81) controlPoint2: CGPointMake(241.47, 21.45)];
    [path addCurveToPoint: CGPointMake(237.78, 25.04) controlPoint1: CGPointMake(239.72, 23.14) controlPoint2: CGPointMake(238.74, 24.08)];
    [path addCurveToPoint: CGPointMake(225.38, 37.44) controlPoint1: CGPointMake(233.64, 29.17) controlPoint2: CGPointMake(229.51, 33.3)];
    [path addCurveToPoint: CGPointMake(223.45, 39.37) controlPoint1: CGPointMake(224.73, 38.08) controlPoint2: CGPointMake(224.09, 38.72)];
    [path addLineToPoint: CGPointMake(223.32, 38.89)];
    [path addCurveToPoint: CGPointMake(222.48, 35.72) controlPoint1: CGPointMake(223.04, 37.83) controlPoint2: CGPointMake(222.76, 36.77)];
    [path addLineToPoint: CGPointMake(222.45, 35.63)];
    [path addCurveToPoint: CGPointMake(221.52, 32.65) controlPoint1: CGPointMake(222.19, 34.64) controlPoint2: CGPointMake(221.91, 33.63)];
    [path addCurveToPoint: CGPointMake(221.05, 31.73) controlPoint1: CGPointMake(221.42, 32.39) controlPoint2: CGPointMake(221.27, 32.05)];
    [path addCurveToPoint: CGPointMake(220.46, 31.15) controlPoint1: CGPointMake(220.92, 31.54) controlPoint2: CGPointMake(220.74, 31.32)];
    [path addCurveToPoint: CGPointMake(219.37, 31) controlPoint1: CGPointMake(220.16, 30.98) controlPoint2: CGPointMake(219.79, 30.93)];
    [path addCurveToPoint: CGPointMake(218.85, 31.12) controlPoint1: CGPointMake(219.2, 31.03) controlPoint2: CGPointMake(219.02, 31.07)];
    [path addLineToPoint: CGPointMake(216.61, 31.72)];
    [path addCurveToPoint: CGPointMake(216.1, 31.88) controlPoint1: CGPointMake(216.44, 31.76) controlPoint2: CGPointMake(216.26, 31.82)];
    [path addCurveToPoint: CGPointMake(215.23, 32.55) controlPoint1: CGPointMake(215.7, 32.03) controlPoint2: CGPointMake(215.4, 32.25)];
    [path addCurveToPoint: CGPointMake(215.01, 33.35) controlPoint1: CGPointMake(215.07, 32.84) controlPoint2: CGPointMake(215.03, 33.11)];
    [path addCurveToPoint: CGPointMake(215.06, 34.39) controlPoint1: CGPointMake(214.98, 33.74) controlPoint2: CGPointMake(215.02, 34.11)];
    [path addCurveToPoint: CGPointMake(215.77, 37.51) controlPoint1: CGPointMake(215.21, 35.43) controlPoint2: CGPointMake(215.49, 36.46)];
    [path addCurveToPoint: CGPointMake(217.8, 45.08) controlPoint1: CGPointMake(216.44, 40.04) controlPoint2: CGPointMake(217.12, 42.56)];
    [path addCurveToPoint: CGPointMake(218.13, 46.21) controlPoint1: CGPointMake(217.9, 45.46) controlPoint2: CGPointMake(218.02, 45.83)];
    [path addLineToPoint: CGPointMake(218.32, 46.83)];
    [path addCurveToPoint: CGPointMake(218.83, 48.08) controlPoint1: CGPointMake(218.47, 47.31) controlPoint2: CGPointMake(218.64, 47.72)];
    [path addCurveToPoint: CGPointMake(219.42, 48.9) controlPoint1: CGPointMake(218.96, 48.34) controlPoint2: CGPointMake(219.13, 48.64)];
    [path addCurveToPoint: CGPointMake(219.87, 49.17) controlPoint1: CGPointMake(219.56, 49.02) controlPoint2: CGPointMake(219.71, 49.11)];
    [path addCurveToPoint: CGPointMake(220.37, 49.25) controlPoint1: CGPointMake(220.02, 49.22) controlPoint2: CGPointMake(220.19, 49.25)];
    [path addCurveToPoint: CGPointMake(220.79, 49.21) controlPoint1: CGPointMake(220.51, 49.25) controlPoint2: CGPointMake(220.64, 49.24)];
    [path addCurveToPoint: CGPointMake(221.46, 49.05) controlPoint1: CGPointMake(220.98, 49.17) controlPoint2: CGPointMake(221.18, 49.13)];
    [path addLineToPoint: CGPointMake(221.7, 48.98)];
    [path addCurveToPoint: CGPointMake(221.86, 48.93) controlPoint1: CGPointMake(221.76, 48.97) controlPoint2: CGPointMake(221.81, 48.95)];
    [path addCurveToPoint: CGPointMake(223.06, 48.18) controlPoint1: CGPointMake(222.3, 48.73) controlPoint2: CGPointMake(222.7, 48.46)];
    [path addCurveToPoint: CGPointMake(224.7, 46.8) controlPoint1: CGPointMake(223.68, 47.71) controlPoint2: CGPointMake(224.26, 47.2)];
    [path addLineToPoint: CGPointMake(224.98, 46.54)];
    [path addCurveToPoint: CGPointMake(229.8, 41.86) controlPoint1: CGPointMake(226.57, 45.08) controlPoint2: CGPointMake(228.04, 43.62)];
    [path addCurveToPoint: CGPointMake(242.19, 29.46) controlPoint1: CGPointMake(233.93, 37.73) controlPoint2: CGPointMake(238.07, 33.6)];
    [path addCurveToPoint: CGPointMake(245.05, 26.54) controlPoint1: CGPointMake(243.15, 28.5) controlPoint2: CGPointMake(244.1, 27.52)];
    [path addCurveToPoint: CGPointMake(246.99, 24.4) controlPoint1: CGPointMake(245.79, 25.77) controlPoint2: CGPointMake(246.42, 25.07)];
    [path addCurveToPoint: CGPointMake(248.12, 22.86) controlPoint1: CGPointMake(247.36, 23.96) controlPoint2: CGPointMake(247.79, 23.44)];
    [path addCurveToPoint: CGPointMake(248.43, 22.16) controlPoint1: CGPointMake(248.27, 22.61) controlPoint2: CGPointMake(248.37, 22.39)];
    [path addCurveToPoint: CGPointMake(248.28, 21.09) controlPoint1: CGPointMake(248.54, 21.76) controlPoint2: CGPointMake(248.49, 21.39)];
    [path closePath];
    return path;
}

@interface UPChoice ()
@property (nonatomic, readwrite) UPChoiceSide side;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPChoice

+ (UPChoice *)choiceWithSide:(UPChoiceSide)side;
{
    return [[UPChoice alloc] initWithSide:side target:nil action:nullptr];
}

- (instancetype)initWithSide:(UPChoiceSide)side target:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    self.side = side;
    self.target = target;
    self.action = action;

    self.canonicalSize = SpellLayout::CanonicalChoiceSize;
    [self addGestureRecognizer:[UPTouchGestureRecognizer gestureWithTarget:self action:@selector(handleTouch:)]];

    [self setFillPath:ChoiceFillPath() forState:UPControlStateSelected];
    [self setFillColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [self setFillColorCategory:UPColorCategoryControlShapeActiveFill forState:UPControlStateSelected];
    [self setFillColorCategory:UPColorCategoryClear forState:UPControlStateDisabled];

    [self setStrokePath:ChoiceStrokePath() forState:UPControlStateSelected];
    [self setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateSelected];
    [self setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateDisabled];

    [self setAuxiliaryColorCategory:UPColorCategoryControlText forState:UPControlStateSelected];

    switch (self.side) {
        case UPChoiceSideDefault:
        case UPChoiceSideLeft:
            [self setAuxiliaryPath:ChoiceLeftFillPathSelected() forState:UPControlStateSelected];
            break;
        case UPChoiceSideRight:
            [self setAuxiliaryPath:ChoiceRightFillPathSelected() forState:UPControlStateSelected];
            break;
    }

    self.label.font = SpellLayout::instance().choice_control_font();
    [self setLabelColorCategory:UPColorCategoryControlText forState:UPControlStateNormal];
    [self setLabelColorCategory:UPColorCategoryControlText forState:UPControlStateSelected];
    [self setLabelColorCategory:UPColorCategoryControlTextInactive forState:UPControlStateDisabled];
    self.label.addsLeftwardScoot = YES;
    
    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)handleTouch:(UPTouchGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    if (self.selected || !self.enabled) {
        return;
    }

    [self setSelected];
    [self invalidate];
    [self update];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.target respondsToSelector:self.action]) {
        if ([NSStringFromSelector(self.action) hasSuffix:@":"]) {
            [self.target performSelector:self.action withObject:self];
        }
        else {
            [self.target performSelector:self.action];
        }
    }
    else if (self.target || self.action) {
        LOG(General, "Target does not respond to selector: %@ : %@", self.target, NSStringFromSelector(self.action));
    }
#pragma clang diagnostic pop
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    SpellLayout &layout = SpellLayout::instance();
    
    CGRect bounds = self.bounds;
    
    [self.label sizeToFit];
    
    CGRect labelFrame = CGRectInset(self.label.frame, -3, 0);
    CGFloat labelOriginY = up_rect_height(bounds) - up_rect_height(labelFrame) + layout.choice_control_font().baselineAdjustment;

    switch (self.side) {
        case UPChoiceSideDefault:
        case UPChoiceSideLeft:
            labelFrame.origin = CGPointMake(layout.choice_control_label_left_margin(), labelOriginY);
            break;
        case UPChoiceSideRight: {
            CGFloat labelOriginX = up_rect_width(bounds) - up_rect_width(labelFrame) - layout.choice_control_label_right_margin();
            labelFrame.origin = CGPointMake(labelOriginX, labelOriginY);
            break;
        }
    }

    self.label.frame = labelFrame;

    if (self.variableWidth) {
        CGSize defaultSize = up_size_scaled(SpellLayout::CanonicalChoiceSize, layout.layout_scale());
        self.auxiliaryPathView.frame = CGRectMake(0, 0, defaultSize.width, defaultSize.height);
        
        UIBezierPath *path = ChoiceStrokePathWithWidth(up_rect_width(self.label.frame) + SpellLayout::CanonicalChoiceLabelLeftMargin);
        self.strokePathView.canonicalSize = up_pixel_size(path.bounds.size, layout.screen_scale());
        [self setStrokePath:path forState:UPControlStateSelected];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    SpellLayout &layout = SpellLayout::instance();

    if (!self.variableWidth) {
        return up_size_scaled(SpellLayout::CanonicalChoiceSize, layout.layout_scale());
    }

    CGSize fitsSize = size;
    [self.label sizeToFit];
    CGSize labelSize = self.label.bounds.size;
    CGFloat width = labelSize.width;
    switch (self.side) {
        case UPChoiceSideDefault:
        case UPChoiceSideLeft:
            width += (layout.choice_control_label_left_margin() * 1.6);
            break;
        case UPChoiceSideRight: {
            width += (layout.choice_control_label_right_margin() * 1.6);
            break;
        }
    }
    fitsSize.width = width;
    return fitsSize;
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.label updateThemeColors];
}

@end
