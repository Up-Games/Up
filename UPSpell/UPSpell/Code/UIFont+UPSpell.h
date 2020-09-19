//
//  UIFont+UPSpell.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UPGameInformationFontName;

@interface UIFont (UPSpell)

+ (UIFont *)textButtonFontOfSize:(CGFloat)fontSize;
+ (UIFont *)textButtonFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)gameInformationFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameInformationFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)gameNoteFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameNoteFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)gameNoteWordFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameNoteWordFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)wordScoreFontOfSize:(CGFloat)fontSize;
+ (UIFont *)wordScoreFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)wordScoreBonusFontOfSize:(CGFloat)fontSize;
+ (UIFont *)wordScoreBonusFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)checkboxControlFontOfSize:(CGFloat)fontSize;
+ (UIFont *)checkboxControlFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)choiceControlFontOfSize:(CGFloat)fontSize;
+ (UIFont *)choiceControlFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)dialogTitleFontOfSize:(CGFloat)fontSize;
+ (UIFont *)dialogTitleFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)descriptionFontOfSize:(CGFloat)fontSize;
+ (UIFont *)descriptionFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)aboutFontOfSize:(CGFloat)fontSize;
+ (UIFont *)aboutFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)challengeFontOfSize:(CGFloat)fontSize;
+ (UIFont *)challengeFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)placardValueFontOfSize:(CGFloat)fontSize;
+ (UIFont *)placardValueFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)placardDescriptionFontOfSize:(CGFloat)fontSize;
+ (UIFont *)placardDescriptionFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)wordMarkFontOfSize:(CGFloat)fontSize;
+ (UIFont *)wordMarkFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)legalFontOfSize:(CGFloat)fontSize;
+ (UIFont *)legalFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)helpPromptFontOfSize:(CGFloat)fontSize;
+ (UIFont *)helpPromptFontWithCapHeight:(CGFloat)capHeight;

+ (UIFont *)dingbatsFontOfSize:(CGFloat)fontSize;
+ (UIFont *)dingbatsFontWithCapHeight:(CGFloat)capHeight;

@end
