//
//  UPLabel.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import <UPKit/UPAssertions.h>
#import <UPKit/UPGeometry.h>

#import "UPLabel.h"

#define TextLayer() ((CATextLayer *)self.layer)

@interface UPLabel ()
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) Class stringClass;
@end

@implementation UPLabel

+ (Class)layerClass
{
    return [CATextLayer class];
}

+ (UPLabel *)label
{
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    TextLayer().contentsScale = [[UIScreen mainScreen] scale];
    self.opaque = NO;
    self.backgroundColorCategory = UPColorCategoryClear;
    self.textColorCategory = UPColorCategoryInformation;
    [self updateThemeColors];
    return self;
}

@dynamic string;
- (NSString *)string
{
    id string = TextLayer().string;
    if ([string isKindOfClass:[NSString class]]) {
        return (NSString *)string;
    }
    else if ([string isKindOfClass:[NSAttributedString class]]) {
        return (NSString *)[string string];
    }
    return nil;
}

- (void)setString:(NSString *)string
{
    TextLayer().string = string;
    self.stringClass = [NSString class];
    [self updateThemeColors];
}

@dynamic attributedString;
- (NSAttributedString *)attributedString
{
    id string = TextLayer().string;
    if ([string isKindOfClass:[NSString class]]) {
        return [[NSAttributedString alloc] initWithString:string attributes:@{
            NSFontAttributeName: self.font
        }];
    }
    else if ([string isKindOfClass:[NSAttributedString class]]) {
        return (NSAttributedString *)string;
    }
    return nil;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    TextLayer().string = attributedString;
    self.stringClass = [NSAttributedString class];
//    [self updateThemeColors];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    TextLayer().font = (__bridge CTFontRef)(_font);
    TextLayer().fontSize = font.pointSize;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    NSString *alignmentMode = kCAAlignmentNatural;
    switch (_textAlignment) {
        case NSTextAlignmentLeft:
            alignmentMode = kCAAlignmentLeft;
            break;
        case NSTextAlignmentCenter:
            alignmentMode = kCAAlignmentCenter;
            break;
        case NSTextAlignmentRight:
            alignmentMode = kCAAlignmentRight;
            break;
        case NSTextAlignmentJustified:
            alignmentMode = kCAAlignmentJustified;
            break;
        case NSTextAlignmentNatural:
            alignmentMode = kCAAlignmentNatural;
            break;
    }
    TextLayer().alignmentMode = alignmentMode;
}

- (void)setBackgroundColorCategory:(UPColorCategory)backgroundColorCategory
{
    _backgroundColorCategory = backgroundColorCategory;
    [self updateThemeColors];
}

- (void)setTextColorCategory:(UPColorCategory)textColorCategory
{
    _textColorCategory = textColorCategory;
    [self updateThemeColors];
}

@dynamic backgroundColor;
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    TextLayer().backgroundColor = backgroundColor ? backgroundColor.CGColor : nil;
}

@dynamic textColor;
- (void)setTextColor:(UIColor *)textColor
{
    if (self.stringClass == [NSString class]) {
        TextLayer().foregroundColor = textColor ? textColor.CGColor : nil;
    }
    else if (self.stringClass == [NSAttributedString class]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attributedString.length)];
        TextLayer().string = attributedString;
    }
}

- (UIColor *)textColor
{
    return TextLayer().foregroundColor ? [UIColor colorWithCGColor:TextLayer().foregroundColor] : nil;
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self.attributedString size];
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.backgroundColor = [UIColor themeColorWithCategory:self.backgroundColorCategory];
    self.textColor = [UIColor themeColorWithCategory:self.textColorCategory];
}

@end
