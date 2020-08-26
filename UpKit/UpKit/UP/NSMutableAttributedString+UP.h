//
//  NSMutableAttributedString+UP.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/NSAttributedString.h>
#import <UIKit/NSText.h>

@class UIColor;
@class UIFont;

@interface NSMutableAttributedString (UP)

- (void)setString:(NSString *)string;

- (void)setFont:(UIFont *)font;
- (void)setFont:(UIFont *)font range:(NSRange)range;

- (void)setTextColor:(UIColor *)color;
- (void)setTextColor:(UIColor *)color range:(NSRange)range;

- (void)setKerning:(CGFloat)kerning;
- (void)setKerning:(CGFloat)kerning range:(NSRange)range;

- (void)setBaselineOffset:(CGFloat)baselineOffset;
- (void)setBaselineOffset:(CGFloat)baselineOffset range:(NSRange)range;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setTextAlignment:(NSTextAlignment)textAlignment range:(NSRange)range;

- (void)setTextAlignment:(NSTextAlignment)textAlignment paragraphSpacing:(CGFloat)paragraphSpacing;
- (void)setTextAlignment:(NSTextAlignment)textAlignment paragraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;

@end
