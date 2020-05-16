//
//  UPLabel.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "UPLabel.h"

#define TextLayer() ((CATextLayer *)self.layer)

@interface UPLabel ()
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
    TextLayer().backgroundColor = [UIColor clearColor].CGColor;
    self.opaque = NO;
    return self;
}

@dynamic string;
- (NSString *)string
{
    return (NSString *)TextLayer().string;
}

- (void)setString:(NSString *)string
{
    TextLayer().string = string;
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

@dynamic backgroundColor;
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    TextLayer().backgroundColor = backgroundColor ? backgroundColor.CGColor : nil;
}

@dynamic textColor;
- (void)setTextColor:(UIColor *)textColor
{
    TextLayer().foregroundColor = textColor ? textColor.CGColor : nil;
}

- (UIColor *)textColor
{
    return TextLayer().foregroundColor ? [UIColor colorWithCGColor:TextLayer().foregroundColor] : nil;
}

@end
