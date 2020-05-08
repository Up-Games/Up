//
//  UIColor+UP.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPColorStyle) {
    UPColorStyleDefault,
    UPColorStyleLight,
    UPColorStyleDark,
    UPColorStyleLightStark,
    UPColorStyleDarkStark,
};

typedef NS_ENUM(NSInteger, UPColorCategory) {
    UPColorCategoryDefault,
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
    UPColorCategoryInformation,
    UPColorCategoryCanvas,

    UPColorCategoryDisabledFill,
    UPColorCategoryDisabledStroke,
    UPColorCategoryDisabledContent,
};

@interface UIColor (UP)

+ (void)setThemeStyle:(UPColorStyle)style;
+ (UPColorStyle)themeStyle;

+ (UIColor *)themeColorWithHue:(CGFloat)hue category:(UPColorCategory)category;

+ (UIColor *)colorizedGray:(CGFloat)gray hue:(CGFloat)hue saturation:(CGFloat)saturation;

- (CGFloat)LABLightness;

@end
