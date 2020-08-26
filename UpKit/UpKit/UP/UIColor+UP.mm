//
//  UIColor+UP.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPAssertions.h"
#import "UIColor+UP.h"
#import "UIDevice+UP.h"
#import "UPColor.h"
#import "UPGeometry.h"
#import "UPMath.h"

using UP::RGBF;
using UP::HSVF;
using UP::LABF;
using UP::to_labf;
using UP::to_rgbf;
using UP::to_hsvf;
using UP::mix_channel;
using UP::mix_lightness;

static UPTheme _Theme = UPThemeBlueLight;
static UPThemeColorStyle _ThemeStyle = UPThemeColorStyleDefault;
static CGFloat _ThemeHue = 225;

#include "UPThemeColors.c"

@implementation UIColor (UP)

+ (void)setTheme:(UPTheme)theme
{
    _Theme = theme;
    switch (_Theme) {
        case UPThemeBlueLight:
            [self setThemeColorHue:225];
            [self setThemeColorStyle:UPThemeColorStyleLight];
            break;
        case UPThemeGreenLight:
            [self setThemeColorHue:120];
            [self setThemeColorStyle:UPThemeColorStyleLight];
            break;
        case UPThemeRedLight:
            [self setThemeColorHue:0];
            [self setThemeColorStyle:UPThemeColorStyleLight];
            break;
        case UPThemeBlueDark:
            [self setThemeColorHue:225];
            [self setThemeColorStyle:UPThemeColorStyleDark];
            break;
        case UPThemeGreenDark:
            [self setThemeColorHue:120];
            [self setThemeColorStyle:UPThemeColorStyleDark];
            break;
        case UPThemePurpleDark:
            [self setThemeColorHue:285];
            [self setThemeColorStyle:UPThemeColorStyleDark];
            break;
        case UPThemeBlueLightStark:
            [self setThemeColorHue:225];
            [self setThemeColorStyle:UPThemeColorStyleLightStark];
            break;
        case UPThemePurpleLightStark:
            [self setThemeColorHue:285];
            [self setThemeColorStyle:UPThemeColorStyleLightStark];
            break;
        case UPThemeRedLightStark:
            [self setThemeColorHue:0];
            [self setThemeColorStyle:UPThemeColorStyleLightStark];
            break;
        case UPThemeGreenDarkStark:
            [self setThemeColorHue:120];
            [self setThemeColorStyle:UPThemeColorStyleDarkStark];
            break;
        case UPThemePurpleDarkStark:
            [self setThemeColorHue:285];
            [self setThemeColorStyle:UPThemeColorStyleDarkStark];
            break;
        case UPThemeYellowDarkStark:
            [self setThemeColorHue:45];
            [self setThemeColorStyle:UPThemeColorStyleDarkStark];
            break;
    }
}

+ (UPTheme)theme
{
    return _Theme;
}

+ (void)setThemeColorStyle:(UPThemeColorStyle)style
{
    _ThemeStyle = style;
}

+ (UPThemeColorStyle)themeColorStyle
{
    return _ThemeStyle;
}

+ (void)setThemeColorHue:(CGFloat)hue
{
    _ThemeHue = UPClampT(CGFloat, hue, 0, 359);
}

+ (CGFloat)themeColorHue
{
    return _ThemeHue;
}

+ (UIColor *)themeColorWithCategory:(UPColorCategory)category
{
    return [self themeColorWithStyle:_ThemeStyle hue:_ThemeHue category:category];
}

+ (UIColor *)themeColorWithStyle:(UPThemeColorStyle)style hue:(CGFloat)hue category:(UPColorCategory)category
{
    UPColorCategory effectiveCategory = [self themeEffectiveColorCategoryWithStyle:style category:category];
    switch (effectiveCategory) {
        case UPColorCategoryOneBit:
        case UPColorCategoryCanonical:
        case UPColorCategoryControlShapeFill:
        case UPColorCategoryControlShapeActiveFill:
        case UPColorCategoryControlShapeInactiveFill:
        case UPColorCategoryControlShapeStroke:
        case UPColorCategoryControlShapeInactiveStroke:
        case UPColorCategoryControlAccentFill:
        case UPColorCategoryControlAccentInactiveFill:
        case UPColorCategoryControlAccentStroke:
        case UPColorCategoryControlAccentInactiveStroke:
        case UPColorCategoryControlText:
        case UPColorCategoryControlTextInactive:
        case UPColorCategoryControlIndicator:
        case UPColorCategoryPulse:
            ASSERT_NOT_REACHED();
            return nil;
        case UPColorCategoryWhite:
            return [UIColor whiteColor];
        case UPColorCategoryBlack:
            return [UIColor blackColor];
        case UPColorCategoryClear:
            return [UIColor clearColor];
        case UPColorCategoryDefault:
        case UPColorCategoryPrimaryFill:
        case UPColorCategoryInactiveFill:
        case UPColorCategoryActiveFill:
        case UPColorCategoryHighlightedFill:
        case UPColorCategorySecondaryFill:
        case UPColorCategorySecondaryInactiveFill:
        case UPColorCategorySecondaryActiveFill:
        case UPColorCategorySecondaryHighlightedFill:
        case UPColorCategoryPrimaryStroke:
        case UPColorCategoryInactiveStroke:
        case UPColorCategoryActiveStroke:
        case UPColorCategoryHighlightedStroke:
        case UPColorCategorySecondaryStroke:
        case UPColorCategorySecondaryInactiveStroke:
        case UPColorCategorySecondaryActiveStroke:
        case UPColorCategorySecondaryHighlightedStroke:
        case UPColorCategoryContent:
        case UPColorCategoryInactiveContent:
        case UPColorCategoryActiveContent:
        case UPColorCategoryHighlightedContent:
        case UPColorCategoryInformation:
        case UPColorCategoryInfinity: {
            static const size_t ColorsPerHue = 22;
            size_t categoryOffset = (effectiveCategory == UPColorCategoryDefault ? 0 : (size_t)effectiveCategory - 1);
            size_t idx = (_Theme * ColorsPerHue) + categoryOffset;
            _UPRGBColorComponents c = _UPThemeColorComponents[idx];
            ASSERT(c.r >= 0);
            ASSERT(c.r <= 1);
            ASSERT(c.g >= 0);
            ASSERT(c.g <= 1);
            ASSERT(c.b >= 0);
            ASSERT(c.b <= 1);
            ASSERT(c.a >= 0);
            ASSERT(c.a <= 1);
            return [UIColor colorWithRed:c.r green:c.g blue:c.b alpha:c.a];
        }
    }
}

+ (UPColorCategory)themeEffectiveColorCategoryWithStyle:(UPThemeColorStyle)style category:(UPColorCategory)category
{
    switch (category) {
        case UPColorCategoryDefault:
            return UPColorCategoryPrimaryFill;
        case UPColorCategoryPrimaryFill:
        case UPColorCategoryInactiveFill:
        case UPColorCategoryActiveFill:
        case UPColorCategoryHighlightedFill:
        case UPColorCategorySecondaryFill:
        case UPColorCategorySecondaryInactiveFill:
        case UPColorCategorySecondaryActiveFill:
        case UPColorCategorySecondaryHighlightedFill:
        case UPColorCategoryPrimaryStroke:
        case UPColorCategoryInactiveStroke:
        case UPColorCategoryActiveStroke:
        case UPColorCategoryHighlightedStroke:
        case UPColorCategorySecondaryStroke:
        case UPColorCategorySecondaryInactiveStroke:
        case UPColorCategorySecondaryActiveStroke:
        case UPColorCategorySecondaryHighlightedStroke:
        case UPColorCategoryContent:
        case UPColorCategoryInactiveContent:
        case UPColorCategoryActiveContent:
        case UPColorCategoryHighlightedContent:
        case UPColorCategoryInformation:
        case UPColorCategoryInfinity:
        case UPColorCategoryWhite:
        case UPColorCategoryBlack:
        case UPColorCategoryClear:
            return category;
        case UPColorCategoryCanonical: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryPrimaryFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryPrimaryStroke;
            }
        }
        case UPColorCategoryPulse: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryHighlightedFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryHighlightedStroke;
            }
        }
        case UPColorCategoryControlShapeFill: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryPrimaryFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryClear;
            }
        }
        case UPColorCategoryControlShapeActiveFill: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryActiveFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryClear;
            }
        }
        case UPColorCategoryControlShapeInactiveFill: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryInactiveFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryClear;
            }
        }
        case UPColorCategoryControlShapeStroke: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryClear;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryPrimaryStroke;
            }
        }
        case UPColorCategoryControlShapeInactiveStroke: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryClear;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryInactiveStroke;
            }
        }
        case UPColorCategoryControlText:
        case UPColorCategoryControlIndicator: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryPrimaryFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryContent;
            }
        }
        case UPColorCategoryControlAccentFill: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryPrimaryFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryClear;
            }
        }
        case UPColorCategoryControlAccentInactiveFill: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryInactiveFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryClear;
            }
        }
        case UPColorCategoryControlAccentStroke: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryClear;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryContent;
            }
        }
        case UPColorCategoryControlAccentInactiveStroke: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryClear;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryInactiveStroke;
            }
        }
        case UPColorCategoryControlTextInactive: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleDark:
                    return UPColorCategoryInactiveFill;
                case UPThemeColorStyleLightStark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryInactiveContent;
            }
        }
        case UPColorCategoryOneBit: {
            switch (style) {
                case UPThemeColorStyleDefault:
                case UPThemeColorStyleLight:
                case UPThemeColorStyleLightStark:
                    return UPColorCategoryBlack;
                case UPThemeColorStyleDark:
                case UPThemeColorStyleDarkStark:
                    return UPColorCategoryWhite;
            }
        }
    }
}

+ (CGFloat)themeDisabledAlphaForStyle:(UPThemeColorStyle)style
{
    switch (_ThemeStyle) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
        case UPThemeColorStyleLightStark:
            return 0.5;
        case UPThemeColorStyleDark:
            return 0.7;
        case UPThemeColorStyleDarkStark:
            return 0.62;
    }
}

+ (CGFloat)themeDisabledAlpha
{
    return [UIColor themeDisabledAlphaForStyle:_ThemeStyle];
}

+ (CGFloat)themePulseAlphaForTheme:(UPTheme)theme
{
    switch (theme) {
        case UPThemeBlueLight:
            return 0.2;
        case UPThemeGreenLight:
            return 0.125;
        case UPThemeRedLight:
            return 0.125;
        case UPThemeBlueDark:
            return 0.125;
        case UPThemeGreenDark:
            return 0.125;
        case UPThemePurpleDark:
            return 0.125;
        case UPThemeBlueLightStark:
            return 0.075;
        case UPThemePurpleLightStark:
            return 0.075;
        case UPThemeRedLightStark:
            return 0.075;
        case UPThemeGreenDarkStark:
            return 0.125;
        case UPThemePurpleDarkStark:
            return 0.125;
        case UPThemeYellowDarkStark:
            return 0.125;
    }
}

+ (CGFloat)themePulseAlpha
{
    return [UIColor themePulseAlphaForTheme:_Theme];
}

+ (CGFloat)themeModalBackgroundAlphaForStyle:(UPThemeColorStyle)style
{
    switch (_ThemeStyle) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
        case UPThemeColorStyleLightStark:
            return 0.03;
        case UPThemeColorStyleDark:
        case UPThemeColorStyleDarkStark:
            return 0.08;
    }
}

+ (CGFloat)themeModalBackgroundAlpha
{
    return [UIColor themeModalBackgroundAlphaForStyle:_ThemeStyle];
}

+ (CGFloat)themeModalActiveAlphaForStyle:(UPThemeColorStyle)style
{
    switch (_ThemeStyle) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
        case UPThemeColorStyleLightStark:
        case UPThemeColorStyleDark:
        case UPThemeColorStyleDarkStark:
            return 0.35;
    }
}

+ (CGFloat)themeModalActiveAlpha
{
    return [UIColor themeModalActiveAlphaForStyle:_ThemeStyle];
}

+ (CGFloat)themeModalGameOverAlphaForStyle:(UPThemeColorStyle)style
{
    switch (_ThemeStyle) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
        case UPThemeColorStyleLightStark:
        case UPThemeColorStyleDark:
        case UPThemeColorStyleDarkStark:
            return 0.1;
    }
}

+ (CGFloat)themeModalGameOverAlpha
{
    return [UIColor themeModalGameOverAlphaForStyle:_ThemeStyle];
}

+ (CGFloat)themeControlContentInactiveAlphaForStyle:(UPThemeColorStyle)style
{
    switch (_ThemeStyle) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
        case UPThemeColorStyleDark:
            return 0.3;
        case UPThemeColorStyleLightStark:
        case UPThemeColorStyleDarkStark:
            return 0.2;
    }
}

+ (CGFloat)themeControlContentInactiveAlpha
{
    return [UIColor themeControlContentInactiveAlphaForStyle:_ThemeStyle];
}

// https://stackoverflow.com/a/9177602
+ (UIColor *)colorizedGray:(CGFloat)gray hue:(CGFloat)hue saturation:(CGFloat)saturation
{
    RGBF rgbf1 = to_rgbf(HSVF(hue, 1.0, 1.0, 1.0));
    RGBF rgbf2 = RGBF(mix_channel(0.5, rgbf1.red(), saturation),
                      mix_channel(0.5, rgbf1.green(), saturation),
                      mix_channel(0.5, rgbf1.blue(), saturation),
                      1.0);

    UIColor *outputColor = nil;
    const UPFloat factor = (2 * (gray - 1)) + 1;
    CGFloat r3 = mix_lightness(rgbf2.red(), factor);
    CGFloat g3 = mix_lightness(rgbf2.green(), factor);
    CGFloat b3 = mix_lightness(rgbf2.blue(), factor);
    outputColor = [UIColor colorWithRed:r3 green:g3 blue:b3 alpha:1.0];

    return outputColor;
}

+ (UIColor *)colorByMixingColor:(UIColor *)color1 color:(UIColor *)color2 fraction:(CGFloat)fraction
{
    CGFloat r1, g1, b1, a1;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    if (up_is_fuzzy_zero(r1) && up_is_fuzzy_zero(g1) && up_is_fuzzy_zero(b1) && up_is_fuzzy_zero(a1)) {
        return [color2 colorWithAlphaComponent:fraction];  // treat this as a fade
    }

    CGFloat r2, g2, b2, a2;
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    if (up_is_fuzzy_zero(r2) && up_is_fuzzy_zero(g2) && up_is_fuzzy_zero(b2) && up_is_fuzzy_zero(a2)) {
        return [color1 colorWithAlphaComponent:(1.0 - fraction)];  // treat this as a fade
    }

    CGFloat r3 = mix_channel(r1, r2, fraction);
    CGFloat g3 = mix_channel(g1, g2, fraction);
    CGFloat b3 = mix_channel(b1, b2, fraction);
    CGFloat a3 = mix_channel(a1, a2, fraction);
    return [UIColor colorWithRed:r3 green:g3 blue:b3 alpha:a3];
}

- (CGFloat)LABLightness
{
    CGFloat r, g, b, a;
    BOOL ok = [self getRed:&r green:&g blue:&b alpha:&a];
    if (!ok) {
        return 0;
    }

    LABF labf = to_labf(RGBF(r, g, b, a));
    return labf.lightness();
}

+ (UIColor *)testColor1
{
    return [[UIColor orangeColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)testColor2
{
    return [[UIColor blueColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)testColor3
{
    return [[UIColor greenColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)testColor4
{
    return [[UIColor purpleColor] colorWithAlphaComponent:0.5];
}

@end

// =========================================================================================================================================

const int UPHueCount = 360;
const int UPHueMilepost = 15;

int up_previous_milepost_hue(int hue)
{
    int dv = hue % UPHueMilepost;
    if (dv == 0) {
        dv = UPHueMilepost;
    }
    hue -= dv;
    if (hue < 0) {
        hue = UPHueCount - UPHueMilepost;
    }
    return hue;
}

int up_next_milepost_hue(int hue)
{
    int dv = hue % UPHueMilepost;
    if (dv == 0) {
        hue += UPHueMilepost;
    }
    else {
        hue += (UPHueMilepost - dv);
    }
    if (hue >= UPHueCount) {
        hue = 0;
    }
    return hue;
}

int up_theme_milepost_hue(void)
{
    return up_closest_milepost_hue([UIColor themeColorHue]);
}

int up_closest_milepost_hue(int hue)
{
    if (hue < 0 || hue > 360) {
        return 0;
    }
    
    if (hue % UPHueMilepost == 0) {
        return hue;
    }
    
    int hueLess = up_previous_milepost_hue(hue);
    int hueMore = up_next_milepost_hue(hue);

    int result = hue;
    CGFloat diffMore = up_angular_difference(hue, hueMore);
    CGFloat diffLess = up_angular_difference(hue, hueLess);
    if (diffMore < diffLess) {
        result = hueMore;
    }
    else {
        result = hueLess;
    }
    if (up_is_fuzzy_equal(hue, 360)) {
        result = 0;
    }

    return result;
}

NSString *up_theme_icon_name(void)
{
    int hue = up_theme_milepost_hue();
    UIDevice *device = [UIDevice currentDevice];
    NSString *iconName = nil;
    if ([device.model isEqualToString:@"iPhone"]) {
        iconName = [NSString stringWithFormat:@"up-games-icon-%03d-60", hue];
    }
    else if ([device.model isEqualToString:@"iPad"]) {
        if ([device isiPadPro]) {
            iconName = [NSString stringWithFormat:@"up-games-icon-%03d-83", hue];
        }
        else {
            iconName = [NSString stringWithFormat:@"up-games-icon-%03d-76", hue];
        }
    }
    //LOG(General, "iconName: %@ : %@ : %@", iconName, device.model, [device fullModel]);
    return iconName;
}
