//
//  ColorChip.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPMath.h>
#import "ColorChip.h"

NSString *const ColorChipNameKey = @"n";
NSString *const ColorChipGrayValueKey = @"g";
NSString *const ColorChipHueKey = @"h";
NSString *const ColorChipSaturationKey = @"s";
NSString *const ColorChipLightnessKey = @"l";

@implementation ColorChip

- (instancetype)initWithName:(NSString *)name grayValue:(CGFloat)grayValue hue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness
{
    self = [super init];
    
    self.name = name;
    self.grayValue = grayValue;
    self.hue = hue;
    self.saturation = saturation;
    self.lightness = lightness;
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }

    self = [super init];
    
    self.name = dictionary[ColorChipNameKey];
    self.grayValue = [dictionary[ColorChipGrayValueKey] floatValue];
    self.saturation = [dictionary[ColorChipSaturationKey] floatValue];
    self.lightness = [dictionary[ColorChipLightnessKey] floatValue];
    self.hue = [dictionary[ColorChipHueKey] floatValue];
    
    return self;
}

- (ColorChip *)copyWithZone:(NSZone *)zone
{
    return [[ColorChip alloc] initWithDictionary:self.dictionary];
}

- (void)takeValuesFrom:(ColorChip *)chip
{
    self.name = chip.name;
    self.grayValue = chip.grayValue;
    self.hue = chip.hue;
    self.saturation = chip.saturation;
    self.lightness = chip.lightness;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ColorChip class]]) {
        return NO;
    }
    
    ColorChip *other = (ColorChip *)object;
    return [self.name isEqualToString:other.name] &&
        up_is_fuzzy_equal(self.grayValue, other.grayValue) &&
        up_is_fuzzy_equal(self.hue, other.hue) &&
        up_is_fuzzy_equal(self.saturation, other.saturation) &&
        up_is_fuzzy_equal(self.lightness, other.lightness);
}

@dynamic color;
- (UIColor *)color
{
    return [UIColor colorizedColorWithGrayValue:self.grayValue hue:self.hue saturation:self.saturation lightness:self.lightness];
}

- (NSDictionary *)dictionary
{
    return @{
        ColorChipNameKey : self.name,
        ColorChipGrayValueKey : @(self.grayValue),
        ColorChipHueKey : @(self.hue),
        ColorChipSaturationKey : @(self.saturation),
        ColorChipLightnessKey : @(self.lightness),
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: [%.2f, %3.0f, %.2f, %.2f]",
        self.name, self.grayValue, self.hue, self.saturation, self.lightness];
}

- (NSAttributedString *)attributedDescription
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];

    NSDictionary *nameStringAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13]};
    NSDictionary *colorStringAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]};
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.name attributes:nameStringAttributes]];
    
    NSString *chipString = [NSString stringWithFormat:@"\nchsl: %.2f, %3.0f, %.2f, %.2f",
        self.grayValue, self.hue, self.saturation, self.lightness];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:chipString attributes:colorStringAttributes]];

    UIColor *color = [self color];
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    NSString *rgbString = [NSString stringWithFormat:@"\nrgba: %d, %d, %d, 1.0",
        (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:rgbString attributes:colorStringAttributes]];

    return string;
}

@end
