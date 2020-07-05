//
//  UPChoice.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPTouchGestureRecognizer.h>

#import "UPSpellLayout.h"
#import "UPChoice.h"

using UP::SpellLayout;

UIBezierPath *ChoiceFillPath()
{
    return [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 300, 76)];
}

UIBezierPath *ChoiceStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, 76)];
    [path addLineToPoint: CGPointMake(300, 76)];
    [path addLineToPoint: CGPointMake(300, 0)];
    [path addLineToPoint: CGPointMake(0, 0)];
    [path addLineToPoint: CGPointMake(0, 76)];
    [path closePath];
    [path moveToPoint: CGPointMake(3, 3)];
    [path addLineToPoint: CGPointMake(297, 3)];
    [path addLineToPoint: CGPointMake(297, 73)];
    [path addLineToPoint: CGPointMake(3, 73)];
    [path addLineToPoint: CGPointMake(3, 3)];
    [path closePath];
    return path;
}

UIBezierPath *ChoiceLeftFillPathSelected()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(69.28, 25.09)];
    [path addCurveToPoint: CGPointMake(68.92, 24.65) controlPoint1: CGPointMake(69.17, 24.93) controlPoint2: CGPointMake(69.05, 24.79)];
    [path addLineToPoint: CGPointMake(68.25, 23.98)];
    [path addCurveToPoint: CGPointMake(67.59, 23.32) controlPoint1: CGPointMake(68.03, 23.76) controlPoint2: CGPointMake(67.81, 23.54)];
    [path addCurveToPoint: CGPointMake(67.15, 22.96) controlPoint1: CGPointMake(67.45, 23.19) controlPoint2: CGPointMake(67.3, 23.07)];
    [path addCurveToPoint: CGPointMake(66.07, 22.81) controlPoint1: CGPointMake(66.84, 22.75) controlPoint2: CGPointMake(66.47, 22.69)];
    [path addCurveToPoint: CGPointMake(65.38, 23.12) controlPoint1: CGPointMake(65.85, 22.87) controlPoint2: CGPointMake(65.63, 22.97)];
    [path addCurveToPoint: CGPointMake(63.83, 24.25) controlPoint1: CGPointMake(64.85, 23.42) controlPoint2: CGPointMake(64.38, 23.79)];
    [path addCurveToPoint: CGPointMake(61.69, 26.19) controlPoint1: CGPointMake(63.17, 24.81) controlPoint2: CGPointMake(62.47, 25.45)];
    [path addCurveToPoint: CGPointMake(58.78, 29.04) controlPoint1: CGPointMake(60.72, 27.14) controlPoint2: CGPointMake(59.74, 28.08)];
    [path addCurveToPoint: CGPointMake(46.38, 41.44) controlPoint1: CGPointMake(54.64, 33.17) controlPoint2: CGPointMake(50.51, 37.3)];
    [path addCurveToPoint: CGPointMake(44.45, 43.37) controlPoint1: CGPointMake(45.73, 42.08) controlPoint2: CGPointMake(45.09, 42.72)];
    [path addLineToPoint: CGPointMake(44.33, 42.89)];
    [path addCurveToPoint: CGPointMake(43.48, 39.72) controlPoint1: CGPointMake(44.04, 41.83) controlPoint2: CGPointMake(43.76, 40.77)];
    [path addLineToPoint: CGPointMake(43.45, 39.63)];
    [path addCurveToPoint: CGPointMake(42.52, 36.65) controlPoint1: CGPointMake(43.19, 38.64) controlPoint2: CGPointMake(42.91, 37.63)];
    [path addCurveToPoint: CGPointMake(42.05, 35.73) controlPoint1: CGPointMake(42.42, 36.39) controlPoint2: CGPointMake(42.27, 36.05)];
    [path addCurveToPoint: CGPointMake(41.46, 35.15) controlPoint1: CGPointMake(41.92, 35.54) controlPoint2: CGPointMake(41.74, 35.32)];
    [path addCurveToPoint: CGPointMake(40.37, 35) controlPoint1: CGPointMake(41.16, 34.98) controlPoint2: CGPointMake(40.8, 34.93)];
    [path addCurveToPoint: CGPointMake(39.85, 35.12) controlPoint1: CGPointMake(40.2, 35.03) controlPoint2: CGPointMake(40.02, 35.07)];
    [path addLineToPoint: CGPointMake(37.61, 35.72)];
    [path addCurveToPoint: CGPointMake(37.1, 35.88) controlPoint1: CGPointMake(37.44, 35.76) controlPoint2: CGPointMake(37.27, 35.82)];
    [path addCurveToPoint: CGPointMake(36.23, 36.55) controlPoint1: CGPointMake(36.7, 36.03) controlPoint2: CGPointMake(36.4, 36.25)];
    [path addCurveToPoint: CGPointMake(36.01, 37.35) controlPoint1: CGPointMake(36.07, 36.84) controlPoint2: CGPointMake(36.03, 37.11)];
    [path addCurveToPoint: CGPointMake(36.06, 38.39) controlPoint1: CGPointMake(35.98, 37.74) controlPoint2: CGPointMake(36.02, 38.11)];
    [path addCurveToPoint: CGPointMake(36.77, 41.51) controlPoint1: CGPointMake(36.21, 39.43) controlPoint2: CGPointMake(36.49, 40.46)];
    [path addCurveToPoint: CGPointMake(38.8, 49.08) controlPoint1: CGPointMake(37.44, 44.04) controlPoint2: CGPointMake(38.12, 46.56)];
    [path addCurveToPoint: CGPointMake(39.13, 50.21) controlPoint1: CGPointMake(38.9, 49.46) controlPoint2: CGPointMake(39.02, 49.83)];
    [path addLineToPoint: CGPointMake(39.32, 50.83)];
    [path addCurveToPoint: CGPointMake(39.83, 52.08) controlPoint1: CGPointMake(39.47, 51.31) controlPoint2: CGPointMake(39.64, 51.72)];
    [path addCurveToPoint: CGPointMake(40.42, 52.9) controlPoint1: CGPointMake(39.96, 52.34) controlPoint2: CGPointMake(40.13, 52.64)];
    [path addCurveToPoint: CGPointMake(40.87, 53.17) controlPoint1: CGPointMake(40.56, 53.02) controlPoint2: CGPointMake(40.71, 53.11)];
    [path addCurveToPoint: CGPointMake(41.37, 53.25) controlPoint1: CGPointMake(41.02, 53.22) controlPoint2: CGPointMake(41.19, 53.25)];
    [path addCurveToPoint: CGPointMake(41.79, 53.21) controlPoint1: CGPointMake(41.51, 53.25) controlPoint2: CGPointMake(41.64, 53.24)];
    [path addCurveToPoint: CGPointMake(42.46, 53.05) controlPoint1: CGPointMake(41.98, 53.17) controlPoint2: CGPointMake(42.18, 53.13)];
    [path addLineToPoint: CGPointMake(42.71, 52.98)];
    [path addCurveToPoint: CGPointMake(42.86, 52.93) controlPoint1: CGPointMake(42.76, 52.97) controlPoint2: CGPointMake(42.81, 52.95)];
    [path addCurveToPoint: CGPointMake(44.06, 52.18) controlPoint1: CGPointMake(43.3, 52.73) controlPoint2: CGPointMake(43.7, 52.46)];
    [path addCurveToPoint: CGPointMake(45.7, 50.8) controlPoint1: CGPointMake(44.68, 51.71) controlPoint2: CGPointMake(45.26, 51.2)];
    [path addLineToPoint: CGPointMake(45.98, 50.54)];
    [path addCurveToPoint: CGPointMake(50.8, 45.86) controlPoint1: CGPointMake(47.57, 49.08) controlPoint2: CGPointMake(49.04, 47.62)];
    [path addCurveToPoint: CGPointMake(63.2, 33.46) controlPoint1: CGPointMake(54.94, 41.73) controlPoint2: CGPointMake(59.07, 37.6)];
    [path addCurveToPoint: CGPointMake(66.05, 30.54) controlPoint1: CGPointMake(64.15, 32.5) controlPoint2: CGPointMake(65.1, 31.52)];
    [path addCurveToPoint: CGPointMake(67.99, 28.4) controlPoint1: CGPointMake(66.79, 29.77) controlPoint2: CGPointMake(67.42, 29.07)];
    [path addCurveToPoint: CGPointMake(69.12, 26.86) controlPoint1: CGPointMake(68.36, 27.96) controlPoint2: CGPointMake(68.79, 27.44)];
    [path addCurveToPoint: CGPointMake(69.43, 26.16) controlPoint1: CGPointMake(69.27, 26.61) controlPoint2: CGPointMake(69.37, 26.39)];
    [path addCurveToPoint: CGPointMake(69.28, 25.09) controlPoint1: CGPointMake(69.54, 25.76) controlPoint2: CGPointMake(69.49, 25.39)];
    [path closePath];
    return path;
}

UIBezierPath *ChoiceRightFillPathSelected()
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(268.28, 23.09)];
    [path addCurveToPoint: CGPointMake(267.91, 22.65) controlPoint1: CGPointMake(268.17, 22.93) controlPoint2: CGPointMake(268.05, 22.79)];
    [path addLineToPoint: CGPointMake(267.25, 21.98)];
    [path addCurveToPoint: CGPointMake(266.59, 21.32) controlPoint1: CGPointMake(267.03, 21.76) controlPoint2: CGPointMake(266.81, 21.54)];
    [path addCurveToPoint: CGPointMake(266.15, 20.96) controlPoint1: CGPointMake(266.45, 21.19) controlPoint2: CGPointMake(266.3, 21.07)];
    [path addCurveToPoint: CGPointMake(265.07, 20.81) controlPoint1: CGPointMake(265.84, 20.75) controlPoint2: CGPointMake(265.47, 20.69)];
    [path addCurveToPoint: CGPointMake(264.38, 21.12) controlPoint1: CGPointMake(264.85, 20.87) controlPoint2: CGPointMake(264.63, 20.97)];
    [path addCurveToPoint: CGPointMake(262.83, 22.25) controlPoint1: CGPointMake(263.85, 21.42) controlPoint2: CGPointMake(263.38, 21.79)];
    [path addCurveToPoint: CGPointMake(260.69, 24.19) controlPoint1: CGPointMake(262.17, 22.81) controlPoint2: CGPointMake(261.47, 23.45)];
    [path addCurveToPoint: CGPointMake(257.78, 27.04) controlPoint1: CGPointMake(259.72, 25.14) controlPoint2: CGPointMake(258.74, 26.08)];
    [path addCurveToPoint: CGPointMake(245.38, 39.44) controlPoint1: CGPointMake(253.64, 31.17) controlPoint2: CGPointMake(249.51, 35.3)];
    [path addCurveToPoint: CGPointMake(243.45, 41.37) controlPoint1: CGPointMake(244.73, 40.08) controlPoint2: CGPointMake(244.09, 40.72)];
    [path addLineToPoint: CGPointMake(243.32, 40.89)];
    [path addCurveToPoint: CGPointMake(242.48, 37.72) controlPoint1: CGPointMake(243.04, 39.83) controlPoint2: CGPointMake(242.76, 38.77)];
    [path addLineToPoint: CGPointMake(242.45, 37.63)];
    [path addCurveToPoint: CGPointMake(241.52, 34.65) controlPoint1: CGPointMake(242.19, 36.64) controlPoint2: CGPointMake(241.91, 35.63)];
    [path addCurveToPoint: CGPointMake(241.05, 33.73) controlPoint1: CGPointMake(241.42, 34.39) controlPoint2: CGPointMake(241.27, 34.05)];
    [path addCurveToPoint: CGPointMake(240.46, 33.15) controlPoint1: CGPointMake(240.92, 33.54) controlPoint2: CGPointMake(240.74, 33.32)];
    [path addCurveToPoint: CGPointMake(239.37, 33) controlPoint1: CGPointMake(240.16, 32.98) controlPoint2: CGPointMake(239.79, 32.93)];
    [path addCurveToPoint: CGPointMake(238.85, 33.12) controlPoint1: CGPointMake(239.2, 33.03) controlPoint2: CGPointMake(239.02, 33.07)];
    [path addLineToPoint: CGPointMake(236.61, 33.72)];
    [path addCurveToPoint: CGPointMake(236.1, 33.88) controlPoint1: CGPointMake(236.44, 33.76) controlPoint2: CGPointMake(236.26, 33.82)];
    [path addCurveToPoint: CGPointMake(235.23, 34.55) controlPoint1: CGPointMake(235.7, 34.03) controlPoint2: CGPointMake(235.4, 34.25)];
    [path addCurveToPoint: CGPointMake(235.01, 35.35) controlPoint1: CGPointMake(235.07, 34.84) controlPoint2: CGPointMake(235.03, 35.11)];
    [path addCurveToPoint: CGPointMake(235.06, 36.39) controlPoint1: CGPointMake(234.98, 35.74) controlPoint2: CGPointMake(235.02, 36.11)];
    [path addCurveToPoint: CGPointMake(235.77, 39.51) controlPoint1: CGPointMake(235.21, 37.43) controlPoint2: CGPointMake(235.49, 38.46)];
    [path addCurveToPoint: CGPointMake(237.8, 47.08) controlPoint1: CGPointMake(236.44, 42.04) controlPoint2: CGPointMake(237.12, 44.56)];
    [path addCurveToPoint: CGPointMake(238.13, 48.21) controlPoint1: CGPointMake(237.9, 47.46) controlPoint2: CGPointMake(238.02, 47.83)];
    [path addLineToPoint: CGPointMake(238.32, 48.83)];
    [path addCurveToPoint: CGPointMake(238.83, 50.08) controlPoint1: CGPointMake(238.47, 49.31) controlPoint2: CGPointMake(238.64, 49.72)];
    [path addCurveToPoint: CGPointMake(239.42, 50.9) controlPoint1: CGPointMake(238.96, 50.34) controlPoint2: CGPointMake(239.13, 50.64)];
    [path addCurveToPoint: CGPointMake(239.87, 51.17) controlPoint1: CGPointMake(239.56, 51.02) controlPoint2: CGPointMake(239.71, 51.11)];
    [path addCurveToPoint: CGPointMake(240.37, 51.25) controlPoint1: CGPointMake(240.02, 51.22) controlPoint2: CGPointMake(240.19, 51.25)];
    [path addCurveToPoint: CGPointMake(240.79, 51.21) controlPoint1: CGPointMake(240.51, 51.25) controlPoint2: CGPointMake(240.64, 51.24)];
    [path addCurveToPoint: CGPointMake(241.46, 51.05) controlPoint1: CGPointMake(240.98, 51.17) controlPoint2: CGPointMake(241.18, 51.13)];
    [path addLineToPoint: CGPointMake(241.7, 50.98)];
    [path addCurveToPoint: CGPointMake(241.86, 50.93) controlPoint1: CGPointMake(241.76, 50.97) controlPoint2: CGPointMake(241.81, 50.95)];
    [path addCurveToPoint: CGPointMake(243.06, 50.18) controlPoint1: CGPointMake(242.3, 50.73) controlPoint2: CGPointMake(242.7, 50.46)];
    [path addCurveToPoint: CGPointMake(244.7, 48.8) controlPoint1: CGPointMake(243.68, 49.71) controlPoint2: CGPointMake(244.26, 49.2)];
    [path addLineToPoint: CGPointMake(244.98, 48.54)];
    [path addCurveToPoint: CGPointMake(249.8, 43.86) controlPoint1: CGPointMake(246.57, 47.08) controlPoint2: CGPointMake(248.04, 45.62)];
    [path addCurveToPoint: CGPointMake(262.19, 31.46) controlPoint1: CGPointMake(253.93, 39.73) controlPoint2: CGPointMake(258.07, 35.6)];
    [path addCurveToPoint: CGPointMake(265.05, 28.54) controlPoint1: CGPointMake(263.15, 30.5) controlPoint2: CGPointMake(264.1, 29.52)];
    [path addCurveToPoint: CGPointMake(266.99, 26.4) controlPoint1: CGPointMake(265.79, 27.77) controlPoint2: CGPointMake(266.42, 27.07)];
    [path addCurveToPoint: CGPointMake(268.12, 24.86) controlPoint1: CGPointMake(267.36, 25.96) controlPoint2: CGPointMake(267.79, 25.44)];
    [path addCurveToPoint: CGPointMake(268.43, 24.16) controlPoint1: CGPointMake(268.27, 24.61) controlPoint2: CGPointMake(268.37, 24.39)];
    [path addCurveToPoint: CGPointMake(268.28, 23.09) controlPoint1: CGPointMake(268.54, 23.76) controlPoint2: CGPointMake(268.49, 23.39)];
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
    return [[UPChoice alloc] initWithWithSide:side target:nil action:nullptr];
}

+ (UPChoice *)choiceWithSide:(UPChoiceSide)side target:(id)target action:(SEL)action;
{
    return [[UPChoice alloc] initWithWithSide:side target:target action:action];
}

- (instancetype)initWithWithSide:(UPChoiceSide)side target:(id)target action:(SEL)action
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

    [self setStrokePath:ChoiceStrokePath() forState:UPControlStateSelected];
    [self setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateSelected];

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
    self.label.textColorCategory = UPColorCategoryControlText;
    self.label.backgroundColorCategory = UPColorCategoryClear;

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
    
    CGRect labelFrame = self.label.frame;
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
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.label updateThemeColors];
}

@end
