//
//  UIColor+UP.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UIColor+UP.h"
#import "UPColor.h"
#import "UPMath.h"

NSString * const UPThemeColorsChangedNotification = @"UPThemeColorsChangedNotification";

using UP::RGBF;
using UP::HSVF;
using UP::LABF;
using UP::to_labf;
using UP::to_rgbf;
using UP::to_hsvf;
using UP::mix_channel;
using UP::mix_lightness;

static UPColorStyle _ThemeStyle = UPColorStyleDefault;
static CGFloat _ThemeHue = 222;

#include "UPThemeColors.c"

@implementation UIColor (UP)

+ (void)setThemeStyle:(UPColorStyle)style
{
    _ThemeStyle = style;
    [[NSNotificationCenter defaultCenter] postNotificationName:UPThemeColorsChangedNotification object:nil];
}

+ (UPColorStyle)themeStyle
{
    return _ThemeStyle;
}

+ (void)setThemeHue:(CGFloat)hue;
{
    _ThemeHue = UPClampT(CGFloat, hue, 0, 360);
    [[NSNotificationCenter defaultCenter] postNotificationName:UPThemeColorsChangedNotification object:nil];
}

+ (CGFloat)themeHue
{
    return _ThemeHue;
}

+ (UIColor *)themeColorWithCategory:(UPColorCategory)category
{
    return [self themeColorWithStyle:_ThemeStyle hue:_ThemeHue category:category];
}

+ (UIColor *)themeColorWithStyle:(UPColorStyle)style hue:(CGFloat)hue category:(UPColorCategory)category
{
    switch (category) {
        case UPColorCategoryWhite:
            return [UIColor whiteColor];
        case UPColorCategoryBlack:
            return [UIColor blackColor];
        case UPColorCategoryClear:
            return [UIColor clearColor];
        default: {
            static const size_t ColorsPerHue = 22;
            static const size_t HueCount = 360;
            size_t themeOffset = (style == UPColorStyleDefault ? 0 : (size_t)style - 1) * HueCount;
            CGFloat effectiveHue = UPClampT(CGFloat, hue, 0, 360);
            size_t hueOffset = (effectiveHue * ColorsPerHue);
            size_t categoryOffset = (category == UPColorCategoryDefault ? 0 : (size_t)category - 1);
            size_t idx = (themeOffset * ColorsPerHue) + hueOffset + categoryOffset;
            _UPRGBColorComponents c = _UPThemeColorComponents[idx];
            return [UIColor colorWithRed:c.r green:c.g blue:c.b alpha:c.a];
        }
    }
}

+ (CGFloat)themeDisabledAlphaForStyle:(UPColorStyle)style
{
    switch (_ThemeStyle) {
        case UPColorStyleDefault:
        case UPColorStyleLight:
        case UPColorStyleLightStark:
            return 0.5;
        case UPColorStyleDark:
        case UPColorStyleDarkStark:
            return 0.62;
    }
}

+ (CGFloat)themeDisabledAlpha
{
    return [UIColor themeDisabledAlphaForStyle:_ThemeStyle];
}

+ (CGFloat)themeModalBackgroundAlphaForStyle:(UPColorStyle)style
{
    switch (_ThemeStyle) {
        case UPColorStyleDefault:
        case UPColorStyleLight:
        case UPColorStyleLightStark:
            return 0.03;
        case UPColorStyleDark:
        case UPColorStyleDarkStark:
            return 0.03;
    }
}

+ (CGFloat)themeModalBackgroundAlpha
{
    return [UIColor themeModalBackgroundAlphaForStyle:_ThemeStyle];
}

+ (CGFloat)themeModalActiveAlphaForStyle:(UPColorStyle)style
{
    switch (_ThemeStyle) {
        case UPColorStyleDefault:
        case UPColorStyleLight:
        case UPColorStyleLightStark:
        case UPColorStyleDark:
        case UPColorStyleDarkStark:
            return 0.25;
    }
}

+ (CGFloat)themeModalActiveAlpha
{
    return [UIColor themeModalActiveAlphaForStyle:_ThemeStyle];
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
    CGFloat r2, g2, b2, a2;
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];

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
