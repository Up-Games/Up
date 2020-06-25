//
//  UIColor+UP.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPThemeColorStyle) {
    UPThemeColorStyleDefault,
    UPThemeColorStyleLight,
    UPThemeColorStyleDark,
    UPThemeColorStyleLightStark,
    UPThemeColorStyleDarkStark,
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

    UPColorCategoryCanonical,

    UPColorCategoryControlShapeFill,
    UPColorCategoryControlShapeActiveFill,
    UPColorCategoryControlShapeStroke,
    UPColorCategoryControlText,
    UPColorCategoryControlIndicator,

    UPColorCategoryOneBit,
    UPColorCategoryWhite,
    UPColorCategoryBlack,
    UPColorCategoryClear,
};

@interface UIColor (UP)

+ (void)setThemeColorStyle:(UPThemeColorStyle)style;
+ (UPThemeColorStyle)themeColorStyle;

+ (void)setThemeColorHue:(CGFloat)hue;
+ (CGFloat)themeColorHue;

+ (UIColor *)themeColorWithCategory:(UPColorCategory)category;
+ (UIColor *)themeColorWithStyle:(UPThemeColorStyle)style hue:(CGFloat)hue category:(UPColorCategory)category;

+ (CGFloat)themeDisabledAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeDisabledAlpha;

+ (CGFloat)themeModalBackgroundAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeModalBackgroundAlpha;

+ (CGFloat)themeModalActiveAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeModalActiveAlpha;

+ (CGFloat)themeModalGameOverAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeModalGameOverAlpha;

+ (UIColor *)colorizedGray:(CGFloat)gray hue:(CGFloat)hue saturation:(CGFloat)saturation;

+ (UIColor *)colorByMixingColor:(UIColor *)color1 color:(UIColor *)color2 fraction:(CGFloat)fraction;

- (CGFloat)LABLightness;

+ (UIColor *)testColor1;
+ (UIColor *)testColor2;
+ (UIColor *)testColor3;
+ (UIColor *)testColor4;

@end

@interface NSObject (UPThemeColors)
- (void)updateThemeColors;
@end
