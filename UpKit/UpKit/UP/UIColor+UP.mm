//
//  UIColor+UP.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UIColor+UP.h"
#import "UPColor.hpp"

using UP::RGBF;
using UP::HSVF;
using UP::LABF;
using UP::LCHF;
using UP::to_labf;
using UP::to_rgbf;
using UP::to_lchf;
using UP::to_hsvf;
using UP::to_hsvf;
using UP::mix_channel;
using UP::mix_lightness;

static UPColorStyle _ThemeStyle = UPColorStyleDefault;
static UPColorModifier _ThemeModifier = UPColorModifierNone;

@implementation UIColor (UP)

+ (void)setThemeStyle:(UPColorStyle)style
{
    _ThemeStyle = style;
}

+ (UPColorStyle)themeStyle
{
    return _ThemeStyle;
}

+ (void)setThemeModifier:(UPColorModifier)modifier
{
    _ThemeModifier = modifier;
}

+ (UPColorModifier)themeModifier
{
    return _ThemeModifier;
}

+ (UIColor *)themeColorWithHue:(CGFloat)hue category:(UPColorCategory)category
{
    return nil;
}

+ (UIColor *)themeColorWithHue:(CGFloat)hue category:(UPColorCategory)category style:(UPColorStyle)style modifier:(UPColorModifier)modifier
{
    return nil;
}

// https://stackoverflow.com/a/9177602
+ (UIColor *)colorizedColorWithGrayValue:(CGFloat)grayValue hue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness
{
    if (lightness <= -1) {
        return [UIColor blackColor];
    }
    else if (lightness >= 1) {
        return [UIColor whiteColor];
    }

    RGBF rgbf1 = to_rgbf(HSVF(hue, 1.0, 1.0, 1.0));
    RGBF rgbf2 = RGBF(mix_channel(0.5, rgbf1.red(), saturation),
                      mix_channel(0.5, rgbf1.green(), saturation),
                      mix_channel(0.5, rgbf1.blue(), saturation),
                      1.0);
    
    UIColor *outputColor = nil;
    if (lightness >= 0) {
        const UPFloat factor = 2 * (1 - lightness) * (grayValue - 1) + 1;
        CGFloat r3 = mix_lightness(rgbf2.red(), factor);
        CGFloat g3 = mix_lightness(rgbf2.green(), factor);
        CGFloat b3 = mix_lightness(rgbf2.blue(), factor);
        outputColor = [UIColor colorWithRed:r3 green:g3 blue:b3 alpha:1.0];
    }
    else {
        const UPFloat factor = 2 * (1 + lightness) * (grayValue) - 1;
        CGFloat r3 = mix_lightness(rgbf2.red(), factor);
        CGFloat g3 = mix_lightness(rgbf2.green(), factor);
        CGFloat b3 = mix_lightness(rgbf2.blue(), factor);
        outputColor = [UIColor colorWithRed:r3 green:g3 blue:b3 alpha:1.0];
    }
    
    return outputColor;
}

- (CGFloat)lightness
{
    CGFloat r, g, b, a;
    BOOL ok = [self getRed:&r green:&g blue:&b alpha:&a];
    if (!ok) {
        return 0;
    }

    LABF labf = to_labf(RGBF(r, g, b, a));
    return labf.lightness();
}

@end
