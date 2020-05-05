//
//  ColorChip.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

extern NSString *const ColorChipNameKey;
extern NSString *const ColorChipGrayValueKey;
extern NSString *const ColorChipHueKey;
extern NSString *const ColorChipSaturationKey;
extern NSString *const ColorChipLightnessKey;

@interface ColorChip : NSObject <NSCopying>
@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGFloat grayValue;
@property (nonatomic) CGFloat hue;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat lightness;
@property (nonatomic, readonly) UIColor *color;

- (instancetype)initWithName:(NSString *)name grayValue:(CGFloat)grayValue hue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction;

- (void)takeValuesFrom:(ColorChip *)chip;

- (NSDictionary *)dictionary;
- (NSAttributedString *)attributedDescription;

@end
