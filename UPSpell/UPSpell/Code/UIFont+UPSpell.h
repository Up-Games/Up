//
//  UIFont+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UPGameplayInformationFontName;
extern NSString * const UPTileGlyphFontName;
extern NSString * const UPTileScoreFontName;
extern NSString * const UPTileMultiplierFontName;

@interface UIFont (UPSpell)

+ (UIFont *)gameplayInformationFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameplayInformationFontWithCapHeight:(CGFloat)capHeight;
+ (UIFont *)tileGlyphFontOfSize:(CGFloat)fontSize;
+ (UIFont *)tileGlyphFontWithCapHeight:(CGFloat)capHeight;
+ (UIFont *)tileScoreFontOfSize:(CGFloat)fontSize;
+ (UIFont *)tileScoreFontWithCapHeight:(CGFloat)capHeight;
+ (UIFont *)tileMultiplierFontOfSize:(CGFloat)fontSize;
+ (UIFont *)tileMultiplierFontWithCapHeight:(CGFloat)capHeight;

@end
