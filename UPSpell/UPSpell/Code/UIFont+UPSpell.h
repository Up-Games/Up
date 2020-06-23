//
//  UIFont+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UPGameInformationFontName;

@interface UIFont (UPSpell)

+ (UIFont *)gameInformationFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameInformationFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)gameNoteFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameNoteFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)wordScoreFontOfSize:(CGFloat)fontSize;
+ (UIFont *)wordScoreFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)wordScoreBonusFontOfSize:(CGFloat)fontSize;
+ (UIFont *)wordScoreBonusFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)settingsControlFontOfSize:(CGFloat)fontSize;
+ (UIFont *)settingsControlFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)settingsDescriptionFontOfSize:(CGFloat)fontSize;
+ (UIFont *)settingsDescriptionFontWithCapHeight:(CGFloat)capHeight;

@end
