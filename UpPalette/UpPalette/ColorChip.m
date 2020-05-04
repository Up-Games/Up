//
//  ColorChip.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIColor+UP.h>
#import "ColorChip.h"

@implementation ColorChip

- (instancetype)initWithName:(NSString *)name grayValue:(CGFloat)grayValue saturation:(CGFloat)saturation lightness:(CGFloat)lightness
{
    self = [super init];
    
    self.name = name;
    self.grayValue = grayValue;
    self.saturation = saturation;
    self.lightness = lightness;
    self.hue = 0.0;
    
    return self;
}

@dynamic color;
- (UIColor *)color
{
    return [UIColor colorizedColorWithGrayValue:self.grayValue hue:self.hue saturation:self.saturation lightness:self.lightness];
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
