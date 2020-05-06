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
@property (nonatomic, readonly) BOOL isClear;
@property (nonatomic, readonly) UIColor *color;

+ (ColorChip *)clearChipWithName:(NSString *)name;
+ (ColorChip *)chipWithName:(NSString *)name grayValue:(CGFloat)grayValue hue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness;
+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction;
+ (ColorChip *)chipWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithName:(NSString *)name grayValue:(CGFloat)grayValue hue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness;
- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)takeValuesFrom:(ColorChip *)chip;

- (NSDictionary *)dictionary;
- (NSAttributedString *)attributedDescription;

@end
