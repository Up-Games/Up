//
//  ColorChip.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

extern NSString *const ColorChipNameKey;
extern NSString *const ColorChipGrayKey;
extern NSString *const ColorChipHueKey;
extern NSString *const ColorChipSaturationKey;
extern NSString *const ColorChipTargetLABLightnessKey;

@interface ColorChip : NSObject <NSCopying>
@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGFloat gray;
@property (nonatomic) CGFloat hue;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat targetLABLightness;
@property (nonatomic, readonly) BOOL isClear;
@property (nonatomic, readonly) UIColor *color;

+ (ColorChip *)clearChipWithName:(NSString *)name;

+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue gray:(CGFloat)gray saturation:(CGFloat)saturation;
+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue gray:(CGFloat)gray saturation:(CGFloat)saturation
    targetLABLightness:(CGFloat)targetLABLightness;

+ (ColorChip *)chipWithName:(NSString *)name hue:(CGFloat)hue targetLABLightness:(CGFloat)targetLABLightness
    chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction;

+ (ColorChip *)chipWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue gray:(CGFloat)gray saturation:(CGFloat)saturation
    targetLABLightness:(CGFloat)targetLABLightness;

- (instancetype)initWithName:(NSString *)name hue:(CGFloat)hue targetLABLightness:(CGFloat)targetLABLightness
    chipA:(ColorChip *)chipA chipB:(ColorChip *)chipB fraction:(CGFloat)fraction;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)takeValuesFrom:(ColorChip *)chip;
- (ColorChip *)chipWithTargetLABLightness;

- (NSDictionary *)dictionary;

- (NSAttributedString *)attributedDescription;

@end
