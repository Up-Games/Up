//
//  UPTextButton.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIFont+UP.h>
#import <UPKit/UPGeometry.h>
#import <UPKit/UPLabel.h>

#import "UIFont+UPSpell.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"

using UP::SpellLayout;

UIBezierPath *TextButtonFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(187.99, 17.78)];
    [path addLineToPoint: CGPointMake(187.96, 16.93)];
    [path addCurveToPoint: CGPointMake(185.49, 7.8) controlPoint1: CGPointMake(187.85, 14.17) controlPoint2: CGPointMake(187.73, 10.74)];
    [path addCurveToPoint: CGPointMake(164.5, 0.96) controlPoint1: CGPointMake(181.26, 2.33) controlPoint2: CGPointMake(171.17, 1.5)];
    [path addLineToPoint: CGPointMake(162.92, 0.83)];
    [path addCurveToPoint: CGPointMake(124.81, 0.02) controlPoint1: CGPointMake(150.2, 0.03) controlPoint2: CGPointMake(137.29, 0.03)];
    [path addCurveToPoint: CGPointMake(114.06, 0) controlPoint1: CGPointMake(121.24, 0.02) controlPoint2: CGPointMake(117.66, 0.02)];
    [path addCurveToPoint: CGPointMake(73.92, 0) controlPoint1: CGPointMake(100.69, 0) controlPoint2: CGPointMake(87.31, 0)];
    [path addCurveToPoint: CGPointMake(63.19, 0.02) controlPoint1: CGPointMake(70.34, 0.02) controlPoint2: CGPointMake(66.76, 0.02)];
    [path addCurveToPoint: CGPointMake(24.99, 0.83) controlPoint1: CGPointMake(50.71, 0.03) controlPoint2: CGPointMake(37.8, 0.03)];
    [path addLineToPoint: CGPointMake(23.5, 0.96)];
    [path addCurveToPoint: CGPointMake(2.49, 7.82) controlPoint1: CGPointMake(16.84, 1.5) controlPoint2: CGPointMake(6.77, 2.33)];
    [path addCurveToPoint: CGPointMake(0.05, 16.89) controlPoint1: CGPointMake(0.28, 10.72) controlPoint2: CGPointMake(0.15, 14.14)];
    [path addLineToPoint: CGPointMake(0.01, 17.78)];
    [path addCurveToPoint: CGPointMake(0.01, 58.22) controlPoint1: CGPointMake(-0, 32.61) controlPoint2: CGPointMake(-0, 43.39)];
    [path addLineToPoint: CGPointMake(0.05, 59.06)];
    [path addCurveToPoint: CGPointMake(2.51, 68.21) controlPoint1: CGPointMake(0.15, 61.82) controlPoint2: CGPointMake(0.27, 65.26)];
    [path addCurveToPoint: CGPointMake(23.51, 75.05) controlPoint1: CGPointMake(6.74, 73.67) controlPoint2: CGPointMake(16.83, 74.5)];
    [path addLineToPoint: CGPointMake(25.07, 75.18)];
    [path addCurveToPoint: CGPointMake(61.74, 75.98) controlPoint1: CGPointMake(37.32, 75.95) controlPoint2: CGPointMake(49.73, 75.96)];
    [path addCurveToPoint: CGPointMake(69.97, 75.99) controlPoint1: CGPointMake(64.48, 75.98) controlPoint2: CGPointMake(67.22, 75.98)];
    [path addCurveToPoint: CGPointMake(94, 76) controlPoint1: CGPointMake(77.98, 76) controlPoint2: CGPointMake(85.99, 76)];
    [path addCurveToPoint: CGPointMake(118.03, 75.99) controlPoint1: CGPointMake(102.01, 76) controlPoint2: CGPointMake(110.02, 76)];
    [path addCurveToPoint: CGPointMake(151.6, 75.7) controlPoint1: CGPointMake(128.96, 75.99) controlPoint2: CGPointMake(140.25, 75.98)];
    [path addLineToPoint: CGPointMake(153.29, 75.64)];
    [path addCurveToPoint: CGPointMake(174.07, 73.84) controlPoint1: CGPointMake(160.07, 75.4) controlPoint2: CGPointMake(167.08, 75.15)];
    [path addCurveToPoint: CGPointMake(185.51, 68.18) controlPoint1: CGPointMake(177.78, 73.05) controlPoint2: CGPointMake(182.4, 72.07)];
    [path addCurveToPoint: CGPointMake(187.95, 59.11) controlPoint1: CGPointMake(187.72, 65.28) controlPoint2: CGPointMake(187.85, 61.86)];
    [path addLineToPoint: CGPointMake(187.99, 58.22)];
    [path addCurveToPoint: CGPointMake(187.99, 17.78) controlPoint1: CGPointMake(188.01, 43.39) controlPoint2: CGPointMake(188.01, 32.61)];
    [path closePath];
    return path;
}

UIBezierPath *TextButtonStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(114.84, 0)];
    [path addCurveToPoint: CGPointMake(93.91, 0) controlPoint1: CGPointMake(107.87, 0) controlPoint2: CGPointMake(100.89, 0)];
    [path addCurveToPoint: CGPointMake(73.16, 0) controlPoint1: CGPointMake(86.99, 0) controlPoint2: CGPointMake(80.08, 0)];
    [path addCurveToPoint: CGPointMake(22.63, 0.9) controlPoint1: CGPointMake(56.31, 0.1) controlPoint2: CGPointMake(39.45, -0.21)];
    [path addCurveToPoint: CGPointMake(1.85, 7.08) controlPoint1: CGPointMake(16.76, 1.45) controlPoint2: CGPointMake(5.59, 1.99)];
    [path addCurveToPoint: CGPointMake(0.01, 15.74) controlPoint1: CGPointMake(0.08, 9.55) controlPoint2: CGPointMake(0.14, 12.78)];
    [path addCurveToPoint: CGPointMake(0.01, 60.26) controlPoint1: CGPointMake(-0.01, 32.07) controlPoint2: CGPointMake(-0.01, 43.93)];
    [path addCurveToPoint: CGPointMake(1.85, 68.92) controlPoint1: CGPointMake(0.13, 63.22) controlPoint2: CGPointMake(0.08, 66.45)];
    [path addCurveToPoint: CGPointMake(22.63, 75.1) controlPoint1: CGPointMake(5.57, 74.02) controlPoint2: CGPointMake(16.85, 74.56)];
    [path addCurveToPoint: CGPointMake(69.03, 75.99) controlPoint1: CGPointMake(38.07, 76.13) controlPoint2: CGPointMake(53.56, 75.92)];
    [path addCurveToPoint: CGPointMake(93.95, 76) controlPoint1: CGPointMake(77.34, 76) controlPoint2: CGPointMake(85.65, 76)];
    [path addCurveToPoint: CGPointMake(118.97, 75.99) controlPoint1: CGPointMake(102.29, 76) controlPoint2: CGPointMake(110.63, 76)];
    [path addCurveToPoint: CGPointMake(153.71, 75.68) controlPoint1: CGPointMake(130.55, 75.99) controlPoint2: CGPointMake(142.13, 75.98)];
    [path addCurveToPoint: CGPointMake(176.43, 73.7) controlPoint1: CGPointMake(161.3, 75.38) controlPoint2: CGPointMake(168.94, 75.2)];
    [path addCurveToPoint: CGPointMake(186.16, 68.92) controlPoint1: CGPointMake(179.91, 72.92) controlPoint2: CGPointMake(183.8, 72.03)];
    [path addCurveToPoint: CGPointMake(187.99, 60.26) controlPoint1: CGPointMake(187.92, 66.45) controlPoint2: CGPointMake(187.86, 63.22)];
    [path addCurveToPoint: CGPointMake(187.99, 15.74) controlPoint1: CGPointMake(188, 43.93) controlPoint2: CGPointMake(188, 32.07)];
    [path addCurveToPoint: CGPointMake(186.16, 7.08) controlPoint1: CGPointMake(187.87, 12.78) controlPoint2: CGPointMake(187.92, 9.55)];
    [path addCurveToPoint: CGPointMake(165.37, 0.9) controlPoint1: CGPointMake(182.43, 1.98) controlPoint2: CGPointMake(171.16, 1.44)];
    [path addCurveToPoint: CGPointMake(114.84, 0) controlPoint1: CGPointMake(148.55, -0.21) controlPoint2: CGPointMake(131.69, 0.1)];
    [path closePath];
    [path moveToPoint: CGPointMake(114.83, 4)];
    [path addCurveToPoint: CGPointMake(126.01, 4.02) controlPoint1: CGPointMake(118.56, 4.02) controlPoint2: CGPointMake(122.28, 4.02)];
    [path addCurveToPoint: CGPointMake(165.06, 4.89) controlPoint1: CGPointMake(138.84, 4.03) controlPoint2: CGPointMake(152.1, 4.04)];
    [path addCurveToPoint: CGPointMake(166.59, 5.03) controlPoint1: CGPointMake(165.53, 4.93) controlPoint2: CGPointMake(166.05, 4.98)];
    [path addCurveToPoint: CGPointMake(182.9, 9.41) controlPoint1: CGPointMake(171.14, 5.42) controlPoint2: CGPointMake(180.59, 6.24)];
    [path addCurveToPoint: CGPointMake(183.96, 15.08) controlPoint1: CGPointMake(183.81, 10.67) controlPoint2: CGPointMake(183.88, 12.81)];
    [path addLineToPoint: CGPointMake(183.99, 15.81)];
    [path addCurveToPoint: CGPointMake(183.99, 60.18) controlPoint1: CGPointMake(184, 31.98) controlPoint2: CGPointMake(184, 44.02)];
    [path addCurveToPoint: CGPointMake(183.96, 60.97) controlPoint1: CGPointMake(183.98, 60.44) controlPoint2: CGPointMake(183.97, 60.7)];
    [path addCurveToPoint: CGPointMake(182.93, 66.55) controlPoint1: CGPointMake(183.88, 63.19) controlPoint2: CGPointMake(183.8, 65.29)];
    [path addCurveToPoint: CGPointMake(175.6, 69.79) controlPoint1: CGPointMake(181.45, 68.46) controlPoint2: CGPointMake(178.48, 69.14)];
    [path addCurveToPoint: CGPointMake(155.31, 71.61) controlPoint1: CGPointMake(169.01, 71.1) controlPoint2: CGPointMake(162.05, 71.36)];
    [path addLineToPoint: CGPointMake(153.58, 71.68)];
    [path addCurveToPoint: CGPointMake(118.96, 71.99) controlPoint1: CGPointMake(141.88, 71.98) controlPoint2: CGPointMake(130.23, 71.99)];
    [path addCurveToPoint: CGPointMake(93.95, 72) controlPoint1: CGPointMake(110.63, 72) controlPoint2: CGPointMake(102.29, 72)];
    [path addCurveToPoint: CGPointMake(69.05, 71.99) controlPoint1: CGPointMake(85.65, 72) controlPoint2: CGPointMake(77.34, 72)];
    [path addCurveToPoint: CGPointMake(60.49, 71.97) controlPoint1: CGPointMake(66.2, 71.98) controlPoint2: CGPointMake(63.35, 71.98)];
    [path addCurveToPoint: CGPointMake(22.95, 71.11) controlPoint1: CGPointMake(48.16, 71.96) controlPoint2: CGPointMake(35.4, 71.94)];
    [path addCurveToPoint: CGPointMake(21.41, 70.98) controlPoint1: CGPointMake(22.47, 71.07) controlPoint2: CGPointMake(21.95, 71.02)];
    [path addCurveToPoint: CGPointMake(5.1, 66.59) controlPoint1: CGPointMake(16.87, 70.58) controlPoint2: CGPointMake(7.41, 69.76)];
    [path addCurveToPoint: CGPointMake(4.04, 60.92) controlPoint1: CGPointMake(4.19, 65.33) controlPoint2: CGPointMake(4.12, 63.19)];
    [path addLineToPoint: CGPointMake(4.01, 60.19)];
    [path addCurveToPoint: CGPointMake(4.01, 15.82) controlPoint1: CGPointMake(4, 44.03) controlPoint2: CGPointMake(3.99, 31.99)];
    [path addCurveToPoint: CGPointMake(4.04, 15.04) controlPoint1: CGPointMake(4.03, 15.56) controlPoint2: CGPointMake(4.03, 15.3)];
    [path addCurveToPoint: CGPointMake(5.07, 9.45) controlPoint1: CGPointMake(4.12, 12.79) controlPoint2: CGPointMake(4.2, 10.66)];
    [path addCurveToPoint: CGPointMake(21.4, 5.03) controlPoint1: CGPointMake(7.43, 6.24) controlPoint2: CGPointMake(16.87, 5.42)];
    [path addCurveToPoint: CGPointMake(22.94, 4.89) controlPoint1: CGPointMake(21.95, 4.98) controlPoint2: CGPointMake(22.46, 4.93)];
    [path addCurveToPoint: CGPointMake(62, 4.02) controlPoint1: CGPointMake(35.9, 4.04) controlPoint2: CGPointMake(49.17, 4.03)];
    [path addCurveToPoint: CGPointMake(73.15, 4) controlPoint1: CGPointMake(65.72, 4.02) controlPoint2: CGPointMake(69.45, 4.02)];
    [path addCurveToPoint: CGPointMake(93.91, 4) controlPoint1: CGPointMake(80.07, 4) controlPoint2: CGPointMake(86.99, 4)];
    [path addCurveToPoint: CGPointMake(114.83, 4) controlPoint1: CGPointMake(100.89, 4) controlPoint2: CGPointMake(107.86, 4)];
    [path closePath];
    return path;
}

@implementation UPTextButton

+ (UPTextButton *)textButton
{
    return [[UPTextButton alloc] initWithTarget:nil action:nullptr];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];

    self.canonicalSize = SpellLayout::CanonicalTextButtonSize;
    
    [self setFillPath:TextButtonFillPath() forState:UPControlStateNormal];
    [self setFillColorCategory:UPColorCategoryPrimaryFill forState:UPControlStateNormal];
    [self setFillColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [self setStrokePath:TextButtonStrokePath() forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryHighlightedStroke forState:UPControlStateHighlighted];

    SpellLayout &layout = SpellLayout::instance();

    self.label.font = layout.text_button_font();
    self.label.textColorCategory = UPColorCategoryContent;
    self.label.backgroundColorCategory = UPColorCategoryClear;
    self.label.textAlignment = NSTextAlignmentCenter;

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    CGRect bounds = self.bounds;

    [self.label sizeToFit];
    
    CGRect labelFrame = up_rect_centered_in_rect(self.label.frame, bounds);
    CGFloat labelOriginY = up_rect_min_y(labelFrame) + self.label.font.baselineAdjustment;
    labelFrame.origin = CGPointMake(0, labelOriginY);
    labelFrame.size.width = up_rect_width(bounds);
    self.label.frame = labelFrame;
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.label updateThemeColors];
}

@end
