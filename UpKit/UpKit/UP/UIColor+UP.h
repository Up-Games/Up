//
//  UIColor+UP.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPMacros.h>

typedef NS_ENUM(NSInteger, UPTheme) {
    UPThemeDefault,
    UPThemeBlueLight = 0,
    UPThemeGreenLight,
    UPThemeRedLight,
    UPThemeBlueDark,
    UPThemeGreenDark,
    UPThemePurpleDark,
    UPThemeBlueLightStark,
    UPThemePurpleLightStark,
    UPThemeRedLightStark,
    UPThemeGreenDarkStark,
    UPThemePurpleDarkStark,
    UPThemeYellowDarkStark,
};

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
    UPColorCategoryControlShapeInactiveFill,
    UPColorCategoryControlShapeStroke,
    UPColorCategoryControlShapeInactiveStroke,
    UPColorCategoryControlAccentFill,
    UPColorCategoryControlAccentInactiveFill,
    UPColorCategoryControlAccentStroke,
    UPColorCategoryControlAccentInactiveStroke,
    UPColorCategoryControlText,
    UPColorCategoryControlTextInactive,
    UPColorCategoryControlIndicator,

    UPColorCategoryPulse,

    UPColorCategoryOneBit,
    UPColorCategoryWhite,
    UPColorCategoryBlack,
    UPColorCategoryClear,
};

@interface UIColor (UP)

+ (void)setTheme:(UPTheme)theme;
+ (UPTheme)theme;

+ (void)setThemeColorStyle:(UPThemeColorStyle)style;
+ (UPThemeColorStyle)themeColorStyle;

+ (void)setThemeColorHue:(CGFloat)hue;
+ (CGFloat)themeColorHue;

+ (UIColor *)themeColorWithCategory:(UPColorCategory)category;
+ (UIColor *)themeColorWithStyle:(UPThemeColorStyle)style hue:(CGFloat)hue category:(UPColorCategory)category;

+ (CGFloat)themeDisabledAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeDisabledAlpha;

+ (CGFloat)themePulseAlphaForTheme:(UPTheme)theme;
+ (CGFloat)themePulseAlpha;

+ (CGFloat)themeModalBackgroundAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeModalBackgroundAlpha;

+ (CGFloat)themeModalActiveAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeModalActiveAlpha;

+ (CGFloat)themeModalGameOverAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeModalGameOverAlpha;

+ (CGFloat)themeControlContentInactiveAlphaForStyle:(UPThemeColorStyle)style;
+ (CGFloat)themeControlContentInactiveAlpha;

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

#ifdef __cplusplus
extern "C" {
#endif

UP_STATIC_INLINE UIColor *up_rgb(int r, int g, int b) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

UP_STATIC_INLINE UIColor *up_rgba(int r, int g, int b, CGFloat a) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

extern const int UPHueCount;
extern const int UPHueMilepost;

int up_previous_milepost_hue(int);
int up_next_milepost_hue(int);
int up_theme_milepost_hue(void);
int up_closest_milepost_hue(int);
NSString *up_theme_icon_name(void);

#ifdef __cplusplus
}  // extern "C"
#endif

