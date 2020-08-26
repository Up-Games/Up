//
//  UPLabel.m
//  Copyright © 2020 Ken Kocienda. All rights reserved.
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
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    TextLayer().contentsScale = [[UIScreen mainScreen] scale];
    TextLayer().masksToBounds = NO;
    self.opaque = NO;
    self.colorCategory = UPColorCategoryInformation;
    [self updateThemeColors];
    self.backgroundColor = [UIColor clearColor];
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

- (void)setColorCategory:(UPColorCategory)textColorCategory
{
    _colorCategory = textColorCategory;
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

@dynamic wrapped;
- (void)setWrapped:(BOOL)wrapped
{
    TextLayer().wrapped = wrapped;
}

- (BOOL)wrapped
{
    return TextLayer().wrapped;
}

#pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitsSize = [self.attributedString size];
    if (self.addsLeftwardScoot) {
        fitsSize.width += 1;
    }
    return fitsSize;
}

- (void)layerWillDraw:(CALayer *)layer
{
    if (self.addsLeftwardScoot) {
        CGRect bounds = self.bounds;
        bounds.origin.x = -1;
        layer.bounds = bounds;
    }
}

- (void)centerInSuperview
{
    if (!self.superview) {
        return;
    }
    
    CGRect layoutFrame = self.superview.bounds;
    NSAttributedString *attrString = self.attributedString;
    CGSize attrStringSize = attrString.size;
    CGRect attrStringFrame = CGRectMake(0, 0, up_size_width(attrStringSize), up_size_height(attrStringSize));
    self.frame = up_rect_centered_x_in_rect(attrStringFrame, layoutFrame);
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.textColor = [UIColor themeColorWithCategory:self.colorCategory];
}

@end
