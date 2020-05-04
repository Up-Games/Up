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
    UPColorModifierDefault,
    UPColorModifierQuark,
    UPColorModifierStark,
};

typedef NS_ENUM(NSInteger, UPColorCategory) {
    UPColorCategoryDefault,
    UPColorCategoryBackdrop,
    UPColorCategoryDisabledContent,
    UPColorCategorySecondaryContent,
    UPColorCategoryPrimaryContent,
    UPColorCategoryHighlight,
    UPColorCategoryAccent,
};

@interface UIColor (UP)

+ (UIColor *)colorWithHue:(CGFloat)hue category:(UPColorCategory)category;

+ (UIColor *)colorizedColorWithGrayValue:(CGFloat)grayValue hue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness;

@end
