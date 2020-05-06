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

static const CGFloat _ClearGray = -1;

@interface ColorChip ()
@end

@implementation ColorChip

+ (ColorChip *)clearChipWithName:(NSString *)name
{
    return [[ColorChip alloc] initWithName:name hue:0 grayValue:_ClearGray saturation:0 lightness:0];
}

+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue grayValue:(CGFloat)grayValue  saturation:(CGFloat)saturation lightness:(CGFloat)lightness
{
    return [[ColorChip alloc] initWithName:name hue:hue grayValue:grayValue saturation:saturation lightness:lightness];
}

+ (ColorChip *)chipWithDictionary:(NSDictionary *)dictionary
{
    return [[ColorChip alloc] initWithDictionary:dictionary];
}

+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction
{
    return [[ColorChip alloc] initWithName:name hue:hue chipA:chipA chipB:chipB fraction:fraction];
}

- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue grayValue:(CGFloat)grayValue  saturation:(CGFloat)saturation lightness:(CGFloat)lightness
{
    self = [super init];
    
    self.name = name;
    self.hue = hue;
    self.grayValue = grayValue;
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

- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction
{
    self = [super init];
    
    self.name = name;
    self.hue = hue;
    self.grayValue = up_lerp_floats(chipA.grayValue, chipB.grayValue, fraction);
    self.saturation = up_lerp_floats(chipA.saturation, chipB.saturation, fraction);
    self.lightness = up_lerp_floats(chipA.lightness, chipB.lightness, fraction);
    
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

@dynamic isClear;
- (BOOL)isClear
{
    return self.grayValue < 0;
}

@dynamic color;
- (UIColor *)color
{
    return self.grayValue < 0 ? [UIColor clearColor] :
        [UIColor colorizedColorWithGrayValue:self.grayValue hue:self.hue saturation:self.saturation lightness:self.lightness];
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
    return [NSString stringWithFormat:@"%@: [%.2f, %.2f, %.2f]",
        self.name, self.grayValue, self.saturation, self.lightness];
}

- (NSAttributedString *)attributedDescription
{
    UIColor *color = [self color];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];

    NSDictionary *nameStringAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13]};
    NSDictionary *colorStringAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Menlo" size:12]};
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.name attributes:nameStringAttributes]];
    
    if (self.grayValue < 0) {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nclear" attributes:colorStringAttributes]];
    }
    else {
        NSString *chipString = [NSString stringWithFormat:@"\nchsl: %.2f, %.2f, %.2f",
            self.grayValue, self.saturation, self.lightness];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:chipString attributes:colorStringAttributes]];

        NSString *lightnessString = [NSString stringWithFormat:@"   L: %3.2f", color.lightness];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:lightnessString attributes:colorStringAttributes]];

        CGFloat r, g, b, a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        
        NSString *rgbString = [NSString stringWithFormat:@"\nrgba: %d, %d, %d, 1.0",
            (int)(r * 255), (int)(g * 255), (int)(b * 255)];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:rgbString attributes:colorStringAttributes]];
    }

    return string;
}

@end

