//
//  UIColor+UP.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UIColor+UP.h"
#import "UPColor.hpp"

using UP::RGBF;
using UP::HSVF;
using UP::to_rgbf;
using UP::to_hsvf;
using UP::to_hsvf;
using UP::mix_channel;
using UP::mix_lightness;

@implementation UIColor (UP)

+ (UIColor *)colorWithHue:(CGFloat)hue category:(UPColorCategory)category
{
    return nil;
}

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

@end

#if 0
// https://stackoverflow.com/a/9177602

static CGFloat blend2(CGFloat a, CGFloat b, CGFloat s)
{
    return (a * (1 - s)) + (b * s);
}

static CGFloat blend3(CGFloat b, CGFloat c, CGFloat w, CGFloat l)
{
    if (l < 0) {
        return blend2(b, c, l + 1);
    }
    else if (l > 0) {
        return blend2(c, w, l);
    }
    else {
        return c;
    }
}

static UIColor *colorizedGrayValue(CGFloat grayValue, CGFloat hueChange, CGFloat saturationChange, CGFloat lightnessChange)
{
    UIColor *hueRGBColor = [[UPColor colorWithHue:hueChange saturation:1.0 value:1.0 alpha:1.0] rgbColor];

    CGFloat r, g, b, a;
    [hueRGBColor getRed:&r green:&g blue:&b alpha:&a];

    CGFloat r2 = blend2(0.5, r, saturationChange);
    CGFloat g2 = blend2(0.5, g, saturationChange);
    CGFloat b2 = blend2(0.5, b, saturationChange);

    UIColor *outputColor = nil;
    if (lightnessChange <= -1) {
        outputColor = [UIColor blackColor];
    }
    else if (lightnessChange >= 1) {
        outputColor = [UIColor whiteColor];
    }

    else if (lightnessChange >= 0) {
        CGFloat r3 = blend3(0, r2, 1, 2 * (1 - lightnessChange) * (grayValue - 1) + 1);
        CGFloat g3 = blend3(0, g2, 1, 2 * (1 - lightnessChange) * (grayValue - 1) + 1);
        CGFloat b3 = blend3(0, b2, 1, 2 * (1 - lightnessChange) * (grayValue - 1) + 1);
        outputColor = [UIColor colorWithRed:r3 green:g3 blue:b3 alpha:1.0];
    }
    else {
        CGFloat r3 = blend3(0, r2, 1, 2 * (1 + lightnessChange) * (grayValue) - 1);
        CGFloat g3 = blend3(0, g2, 1, 2 * (1 + lightnessChange) * (grayValue) - 1);
        CGFloat b3 = blend3(0, b2, 1, 2 * (1 + lightnessChange) * (grayValue) - 1);
        outputColor = [UIColor colorWithRed:r3 green:g3 blue:b3 alpha:1.0];
    }
    
    return outputColor;
}
#endif
