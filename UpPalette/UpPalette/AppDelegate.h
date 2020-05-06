//
//  AppDelegate.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const PrimaryFillKey;
extern NSString *const InactiveFillKey;
extern NSString *const ActiveFillKey;
extern NSString *const HighlightedFillKey;
extern NSString *const SecondaryInactiveFillKey;
extern NSString *const SecondaryActiveFillKey;
extern NSString *const SecondaryHighlightedFillKey;
extern NSString *const PrimaryStrokeKey;
extern NSString *const InactiveStrokeKey;
extern NSString *const ActiveStrokeKey;
extern NSString *const HighlightedStrokeKey;
extern NSString *const ContentKey;
extern NSString *const InactiveContentKey;
extern NSString *const InformationKey;
extern NSString *const CanvasKey;

extern NSString *const ColorThemeLightKey;
extern NSString *const ColorThemeDarkKey;
extern NSString *const ColorThemeStarkLightKey;
extern NSString *const ColorThemeStarkDarkKey;

typedef NS_ENUM(NSInteger, ColorTheme) {
    ColorThemeLight,
    ColorThemeDark,
    ColorThemeStarkLight,
    ColorThemeStarkDark,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@end

