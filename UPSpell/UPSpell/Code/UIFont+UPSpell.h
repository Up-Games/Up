//
//  UIFont+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UPLetterGameplayInformationFontName;
extern NSString * const UPTileGlyphFontName;
extern NSString * const UPTileScoreFontName;

@interface UIFont (UPSpell)

+ (UIFont *)gameplayInformationFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameplayInformationFontWithCapHeight:(CGFloat)capHeight;
+ (UIFont *)letterTileGlyphFontOfSize:(CGFloat)fontSize;
+ (UIFont *)letterTileScoreFontOfSize:(CGFloat)fontSize;

@end
