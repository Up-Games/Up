//
//  UIFont+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const UPGameplayInformationFontName;

@interface UIFont (UPSpell)

+ (UIFont *)gameplayInformationFontOfSize:(CGFloat)fontSize;
+ (UIFont *)gameplayInformationFontWithCapHeight:(CGFloat)capHeight;

@end
