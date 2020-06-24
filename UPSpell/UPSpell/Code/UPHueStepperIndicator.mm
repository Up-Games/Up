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

@interface UPHueStepperIndicator ()
@property (nonatomic) UPLabel *label;
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
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGRect layoutBounds = CGRectInset(bounds, 4, 4);

    [self.label sizeToFit];
    UPLayoutRule *labelRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutBounds
                                                                 hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
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
