//
//  UPHueStepperIndicator.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLayoutRule.h>

#import "UPHueStepperIndicator.h"
#import "UPSpellLayout.h"
#import "UPStepper.h"

using UP::SpellLayout;

static const int HueCount = 360;
static const int MilepostHue = 15;

UIBezierPath *HueChipPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(71.99, 14.91)];
    [path addCurveToPoint: CGPointMake(71.29, 6.71) controlPoint1: CGPointMake(71.95, 12.11) controlPoint2: CGPointMake(71.97, 9.05)];
    [path addCurveToPoint: CGPointMake(63.34, 0.85) controlPoint1: CGPointMake(69.87, 1.88) controlPoint2: CGPointMake(65.55, 1.37)];
    [path addCurveToPoint: CGPointMake(43.98, -0) controlPoint1: CGPointMake(56.89, -0.2) controlPoint2: CGPointMake(50.43, 0.09)];
    [path addCurveToPoint: CGPointMake(28.02, -0) controlPoint1: CGPointMake(38.66, 0.01) controlPoint2: CGPointMake(33.34, 0.01)];
    [path addCurveToPoint: CGPointMake(8.67, 0.85) controlPoint1: CGPointMake(21.57, 0.09) controlPoint2: CGPointMake(15.11, -0.2)];
    [path addCurveToPoint: CGPointMake(0.71, 6.71) controlPoint1: CGPointMake(6.42, 1.37) controlPoint2: CGPointMake(2.14, 1.88)];
    [path addCurveToPoint: CGPointMake(0.01, 14.91) controlPoint1: CGPointMake(0.03, 9.05) controlPoint2: CGPointMake(0.05, 12.11)];
    [path addCurveToPoint: CGPointMake(0.01, 57.09) controlPoint1: CGPointMake(-0, 30.38) controlPoint2: CGPointMake(-0, 41.62)];
    [path addCurveToPoint: CGPointMake(0.71, 65.29) controlPoint1: CGPointMake(0.05, 59.89) controlPoint2: CGPointMake(0.03, 62.95)];
    [path addCurveToPoint: CGPointMake(8.67, 71.15) controlPoint1: CGPointMake(2.13, 70.12) controlPoint2: CGPointMake(6.45, 70.63)];
    [path addCurveToPoint: CGPointMake(26.44, 71.99) controlPoint1: CGPointMake(14.58, 72.13) controlPoint2: CGPointMake(20.51, 71.93)];
    [path addCurveToPoint: CGPointMake(45.56, 71.99) controlPoint1: CGPointMake(32.81, 72) controlPoint2: CGPointMake(39.19, 72)];
    [path addCurveToPoint: CGPointMake(58.87, 71.69) controlPoint1: CGPointMake(50, 71.99) controlPoint2: CGPointMake(54.43, 71.98)];
    [path addCurveToPoint: CGPointMake(67.57, 69.82) controlPoint1: CGPointMake(61.77, 71.41) controlPoint2: CGPointMake(64.7, 71.24)];
    [path addCurveToPoint: CGPointMake(71.29, 65.29) controlPoint1: CGPointMake(68.9, 69.08) controlPoint2: CGPointMake(70.39, 68.24)];
    [path addCurveToPoint: CGPointMake(71.99, 57.09) controlPoint1: CGPointMake(71.97, 62.95) controlPoint2: CGPointMake(71.95, 59.89)];
    [path addCurveToPoint: CGPointMake(71.99, 14.91) controlPoint1: CGPointMake(72, 41.62) controlPoint2: CGPointMake(72, 30.38)];
    [path closePath];
    return path;
}

@interface UPHueStepperIndicator ()
@property (nonatomic) UPLabel *label;
@property (nonatomic) UPBezierPathView *hueChipView;
@property (nonatomic) UPStepper *hueStepLess;
@property (nonatomic) UPStepper *hueStepMore;
@end

@implementation UPHueStepperIndicator

+ (UPHueStepperIndicator *)hueStepperIndicator
{
    return [[UPHueStepperIndicator alloc] _init];
}

- (instancetype)_init
{
    self = [super initWithFrame:CGRectZero];

    self.label = [UPLabel label];
    self.label.font = SpellLayout::instance().checkbox_font();
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColorCategory = UPColorCategoryControlText;
    self.label.backgroundColorCategory = UPColorCategoryClear;
    [self addSubview:self.label];

    self.hueChipView = [UPBezierPathView bezierPathView];
    self.hueChipView.path = HueChipPath();
    self.hueChipView.canonicalSize = CGSizeMake(72, 72);
    [self addSubview:self.hueChipView];

    self.hueStepLess = [UPStepper stepperWithDirection:UPStepperDirectionLeft];
    [self.hueStepLess setTarget:self action:@selector(handleHueStepLess)];
    [self addSubview:self.hueStepLess];
    
    self.hueStepMore = [UPStepper stepperWithDirection:UPStepperDirectionRight];
    [self.hueStepMore setTarget:self action:@selector(handleHueStepMore)];
    [self addSubview:self.hueStepMore];

    self.hue = 0;

    return self;
}

- (void)setHue:(CGFloat)hue
{
    _hue = roundf(hue);
    [self update];
}

- (int)prevHueForHue:(int)hue
{
    int dv = hue % MilepostHue;
    if (dv == 0) {
        dv = MilepostHue;
    }
    hue -= dv;
    if (hue < 0) {
        hue = HueCount - MilepostHue;
    }
    return hue;
}

- (int)nextHueForHue:(int)hue
{
    int dv = hue % MilepostHue;
    if (dv == 0) {
        hue += MilepostHue;
    }
    else {
        hue += (MilepostHue - dv);
    }
    if (hue >= HueCount) {
        hue = 0;
    }
    return hue;
}

- (void)handleHueStepLess
{
    self.hue = [self prevHueForHue:self.hue];
    [self.delegate hueStepperIndicatorDidUpdate:self];
}

- (void)handleHueStepMore
{
    self.hue = [self nextHueForHue:self.hue];
    [self.delegate hueStepperIndicatorDidUpdate:self];
}

- (void)update
{
    NSString *string = [NSString stringWithFormat:@"HUE #%03d", (int)self.hue];
    self.label.string = string;
//    self.hueChipView.fillColor = [UIColor colorizedGray:0.6 hue:self.hue saturation:0.7];
    self.hueChipView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryControlText];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGRect layoutBounds = CGRectInset(bounds, 4, 4);

    UPLayoutRule *hueChipRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutBounds
                                                                   hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
    self.hueChipView.frame = [hueChipRule layoutFrameForBoundsSize:CGSizeMake(60, 60)];

    [self.label sizeToFit];
    UPLayoutRule *labelRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutBounds
                                                                 hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalMiddle];
    self.label.frame = [labelRule layoutFrameForBoundsSize:self.label.frame.size];

    UPLayoutRule *lessStepperRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutBounds
                                                                   hLayout:UPLayoutHorizontalLeft vLayout:UPLayoutVerticalBottom];
    self.hueStepLess.frame = [lessStepperRule layoutFrameForBoundsSize:CGSizeMake(48, 48)];
    UPLayoutRule *moreStepperRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutBounds
                                                                       hLayout:UPLayoutHorizontalRight vLayout:UPLayoutVerticalBottom];
    self.hueStepMore.frame = [moreStepperRule layoutFrameForBoundsSize:CGSizeMake(48, 48)];

}

- (void)updateThemeColors
{
    [self.label updateThemeColors];
    [self.hueStepMore updateThemeColors];
    [self.hueStepLess updateThemeColors];
}

@end
