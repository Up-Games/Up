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

    UPColorCategoryWhite,
    UPColorCategoryBlack,
    UPColorCategoryClear,
};

@interface UIColor (UP)

+ (void)setThemeStyle:(UPColorStyle)style;
+ (UPColorStyle)themeStyle;

+ (void)setThemeHue:(CGFloat)hue;
+ (CGFloat)themeHue;

+ (UIColor *)themeColorWithCategory:(UPColorCategory)category;
+ (UIColor *)themeColorWithStyle:(UPColorStyle)style hue:(CGFloat)hue category:(UPColorCategory)category;

+ (UIColor *)colorizedGray:(CGFloat)gray hue:(CGFloat)hue saturation:(CGFloat)saturation;

- (CGFloat)LABLightness;

+ (UIColor *)testColor1;
+ (UIColor *)testColor2;
+ (UIColor *)testColor3;
+ (UIColor *)testColor4;

@end

extern NSString * const UPThemeColorsChangedNotification;

@interface NSObject (UPThemeColors)
- (void)updateThemeColors;
@end
