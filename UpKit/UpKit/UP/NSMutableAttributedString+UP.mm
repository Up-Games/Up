//
//  NSMutableAttributedString+UP.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIColor.h>
#import <UIKit/UIFont.h>
#import <UIKit/NSParagraphStyle.h>

#import "NSMutableAttributedString+UP.h"

@implementation NSMutableAttributedString (UP)

- (void)setString:(NSString *)string
{
    [self replaceCharactersInRange:NSMakeRange(0, self.length) withString:string];
}

- (void)setFont:(UIFont *)font
{
    [self setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setFont:(UIFont *)font range:(NSRange)range
{
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)setTextColor:(UIColor *)color
{
    [self setTextColor:color range:NSMakeRange(0, self.length)];
}

- (void)setTextColor:(UIColor *)color range:(NSRange)range
{
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)setKerning:(CGFloat)kerning
{
    [self setKerning:kerning range:NSMakeRange(0, self.length)];
}

- (void)setKerning:(CGFloat)kerning range:(NSRange)range
{
    [self addAttribute:NSKernAttributeName value:@(kerning) range:range];
}

- (void)setBaselineOffset:(CGFloat)baselineOffset
{
    [self setBaselineOffset:baselineOffset range:NSMakeRange(0, self.length)];
}

- (void)setBaselineOffset:(CGFloat)baselineOffset range:(NSRange)range
{
    [self addAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset) range:range];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [self setTextAlignment:textAlignment range:NSMakeRange(0, self.length)];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment range:(NSRange)range
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = textAlignment;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

@end
