//
//  ColorChip.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPMath.h>
#import "ColorChip.h"

NSString *const ColorChipNameKey = @"n";
NSString *const ColorChipGrayKey = @"g";
NSString *const ColorChipHueKey = @"h";
NSString *const ColorChipSaturationKey = @"s";
NSString *const ColorChipTargetLABLightnessKey = @"L*";

static const CGFloat _ClearGray = -1;
static const CGFloat _NotATarget = -1;

@interface ColorChip ()
@end

@implementation ColorChip

+ (ColorChip *)clearChipWithName:(NSString *)name
{
    return [[ColorChip alloc] initWithName:name hue:0 gray:_ClearGray saturation:0 targetLABLightness:0];
}

+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue gray:(CGFloat)gray saturation:(CGFloat)saturation
{
    return [[ColorChip alloc] initWithName:name hue:hue gray:gray saturation:saturation
        targetLABLightness:_NotATarget];
}


+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue gray:(CGFloat)gray saturation:(CGFloat)saturation
    targetLABLightness:(CGFloat)targetLABLightness
{
    return [[ColorChip alloc] initWithName:name hue:hue gray:gray saturation:saturation
        targetLABLightness:targetLABLightness];
}

+ (ColorChip *)chipWithDictionary:(NSDictionary *)dictionary
{
    return [[ColorChip alloc] initWithDictionary:dictionary];
}

+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue targetLABLightness:(CGFloat)targetLABLightness
    chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction
{
    return [[ColorChip alloc] initWithName:name hue:hue targetLABLightness:targetLABLightness chipA:chipA chipB:chipB fraction:fraction];
}

- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue gray:(CGFloat)gray saturation:(CGFloat)saturation
    targetLABLightness:(CGFloat)targetLABLightness
{
    self = [super init];
    
    self.name = name;
    self.hue = hue;
    self.gray = gray;
    self.saturation = saturation;
    self.targetLABLightness = targetLABLightness;
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }

    self = [super init];
    
    self.name = dictionary[ColorChipNameKey];
    self.hue = [dictionary[ColorChipHueKey] floatValue];
    self.gray = [dictionary[ColorChipGrayKey] floatValue];
    self.saturation = [dictionary[ColorChipSaturationKey] floatValue];
    self.targetLABLightness = [dictionary[ColorChipTargetLABLightnessKey] floatValue];
    
    return self;
}

- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue targetLABLightness:(CGFloat)targetLABLightness
    chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction
{
    self = [super init];
    
    self.name = name;
    self.hue = hue;
    self.gray = up_lerp_floats(chipA.gray, chipB.gray, fraction);
    self.saturation = up_lerp_floats(chipA.saturation, chipB.saturation, fraction);
    self.targetLABLightness = targetLABLightness;
    
    return self;
}

- (ColorChip *)copyWithZone:(NSZone *)zone
{
    return [[ColorChip alloc] initWithDictionary:self.dictionary];
}

- (void)takeValuesFrom:(ColorChip *)chip
{
    self.name = chip.name;
    self.gray = chip.gray;
    self.hue = chip.hue;
    self.saturation = chip.saturation;
    self.targetLABLightness = chip.targetLABLightness;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ColorChip class]]) {
        return NO;
    }
    
    static const float _Epsilon = 0.001;
    
    ColorChip *other = (ColorChip *)object;
    return [self.name isEqualToString:other.name] &&
        up_is_fuzzy_equal_with_epsilon(self.gray, other.gray, _Epsilon) &&
        up_is_fuzzy_equal_with_epsilon(self.hue, other.hue, _Epsilon) &&
        up_is_fuzzy_equal_with_epsilon(self.saturation, other.saturation, _Epsilon) &&
        up_is_fuzzy_equal(self.targetLABLightness, other.targetLABLightness);
}

@dynamic isClear;
- (BOOL)isClear
{
    return self.gray < 0;
}

@dynamic color;
- (UIColor *)color
{
    return self.isClear ? [UIColor clearColor] :
        [UIColor colorizedGray:self.gray hue:self.hue saturation:self.saturation];
}

- (ColorChip *)chipWithTargetLABLightness
{
    if (self.isClear) {
        return self;
    }
    UIColor *unadjustedColor = self.color;
    if (self.targetLABLightness == _NotATarget || up_is_fuzzy_equal(unadjustedColor.LABLightness, self.targetLABLightness)) {
        return self;
    }
    CGFloat unadjustedLABLightness = unadjustedColor.LABLightness;
    CGFloat deltaGray = unadjustedLABLightness > self.targetLABLightness ? -0.0001 : 0.0001;
    UIColor *adjustedColor = unadjustedColor;
    CGFloat adjustedGray = self.gray;
    do {
        adjustedGray += deltaGray;
        adjustedColor = [UIColor colorizedGray:adjustedGray hue:self.hue saturation:self.saturation];
        CGFloat adjustedLABLightness = adjustedColor.LABLightness;
        if (up_is_fuzzy_equal_with_epsilon(adjustedLABLightness, self.targetLABLightness, 0.05)) {
            return [ColorChip chipWithName:self.name hue:self.hue gray:adjustedGray saturation:self.saturation
                targetLABLightness:self.targetLABLightness];
        }
    } while (adjustedGray >= 0 && adjustedGray <= 1);
    return self;
}

- (NSDictionary *)dictionary
{
    return @{
        ColorChipNameKey : self.name,
        ColorChipGrayKey : @(self.gray),
        ColorChipHueKey : @(self.hue),
        ColorChipSaturationKey : @(self.saturation),
        ColorChipTargetLABLightnessKey : @(self.targetLABLightness),
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: [%.2f, %.2f, / %.2f]",
        self.name, self.gray, self.saturation, self.targetLABLightness];
}

- (NSAttributedString *)attributedDescription
{
    UIColor *color = self.color;

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];

    NSDictionary *nameStringAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12]};
    NSDictionary *colorStringAttributes = @{NSFontAttributeName: [UIFont monospacedSystemFontOfSize:10 weight:0]};
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.name attributes:nameStringAttributes]];
    
    if (self.gray < 0) {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nclear" attributes:colorStringAttributes]];
    }
    else {
        NSString *chipString = [NSString stringWithFormat:@"\nchip: %.2f, %.2f / %.0f",
            self.gray, self.saturation, self.targetLABLightness];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:chipString attributes:colorStringAttributes]];

        NSString *lightnessString = [NSString stringWithFormat:@"; L*: %3.2f", color.LABLightness];
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

