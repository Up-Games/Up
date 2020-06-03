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
    UPColorCategorySecondaryFill,
    UPColorCategorySecondaryInactiveFill,
    UPColorCategorySecondaryActiveFill,
    UPColorCategorySecondaryHighlightedFill,
    UPColorCategoryPrimaryStroke,
    UPColorCategoryInactiveStroke,
    UPColorCategoryActiveStroke,
    UPColorCategoryHighlightedStroke,
    UPColorCategorySecondaryStroke,
    UPColorCategorySecondaryInactiveStroke,
    UPColorCategorySecondaryActiveStroke,
    UPColorCategorySecondaryHighlightedStroke,
    UPColorCategoryContent,
    UPColorCategoryInactiveContent,
    UPColorCategoryActiveContent,
    UPColorCategoryHighlightedContent,
    UPColorCategoryInformation,
    UPColorCategoryInfinity,

    UPColorCategoryDialogTitle,

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

+ (CGFloat)themeDisabledAlphaForStyle:(UPColorStyle)style;
+ (CGFloat)themeDisabledAlpha;

+ (CGFloat)themeModalBackgroundAlphaForStyle:(UPColorStyle)style;
+ (CGFloat)themeModalBackgroundAlpha;

+ (CGFloat)themeModalActiveAlphaForStyle:(UPColorStyle)style;
+ (CGFloat)themeModalActiveAlpha;

+ (CGFloat)themeModalInterstitialAlphaForStyle:(UPColorStyle)style;
+ (CGFloat)themeModalInterstitialAlpha;

+ (UIColor *)colorizedGray:(CGFloat)gray hue:(CGFloat)hue saturation:(CGFloat)saturation;

+ (UIColor *)colorByMixingColor:(UIColor *)color1 color:(UIColor *)color2 fraction:(CGFloat)fraction;

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
