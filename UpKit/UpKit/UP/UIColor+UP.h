//
//  UIColor+UP.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPColorStyle) {
    UPColorStyleDefault,
    UPColorStyleLight,
    UPColorStyleDark,
};

typedef NS_ENUM(NSInteger, UPColorModifier) {
    UPColorModifierNone =  0,
    UPColorModifierQuark = 1 << 0,
    UPColorModifierStark = 1 << 1,
};

typedef NS_ENUM(NSInteger, UPColorCategory) {
    UPColorCategoryPrimaryFill,
    UPColorCategoryInactiveFill,
    UPColorCategoryActiveFill,
    UPColorCategoryHighlightedFill,
    UPColorCategorySecondaryInactiveFill,
    UPColorCategorySecondaryActiveFill,
    UPColorCategorySecondaryHighlightedFill,
    UPColorCategoryPrimaryStroke,
    UPColorCategoryInactiveStroke,
    UPColorCategoryActiveStroke,
    UPColorCategoryHighlightedStroke,
    UPColorCategoryContent,
    UPColorCategoryInactiveContent,
    UPColorCategoryCanvas,
    UPColorCategoryInformation,

    UPColorCategoryDisabledFill,
    UPColorCategoryDisabledStroke,
    UPColorCategoryDisabledContent,
};

@interface UIColor (UP)

+ (void)setThemeStyle:(UPColorStyle)style;
+ (UPColorStyle)themeStyle;

+ (void)setThemeModifier:(UPColorModifier)modifier;
+ (UPColorModifier)themeModifier;

+ (UIColor *)themeColorWithHue:(CGFloat)hue category:(UPColorCategory)category;
+ (UIColor *)themeColorWithHue:(CGFloat)hue category:(UPColorCategory)category style:(UPColorStyle)style modifier:(UPColorModifier)modifier;

+ (UIColor *)colorizedGray:(CGFloat)gray hue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness;

- (CGFloat)LABLightness;

@end
