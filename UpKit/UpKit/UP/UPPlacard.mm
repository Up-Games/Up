//
//  UPPlacard.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPAssertions.h"
#import "NSMutableAttributedString+UP.h"
#import "UPPlacard.h"

@implementation UPPlacard

+ (UPPlacard *)placard
{
    return [[UPPlacard alloc] init];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    self.backgroundColor = [UIColor clearColor];
    self.colorCategory = UPColorCategoryInformation;
    self.enabled = YES;
    return self;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    [self setNeedsDisplay];
}

- (void)setColorCategory:(UPColorCategory)colorCategory
{
    _colorCategory = colorCategory;
    [self updateThemeColors];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [self updateThemeColors];
}

- (void)drawRect:(CGRect)rect
{
    NSMutableAttributedString *drawString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
    UIColor *color = [UIColor themeColorWithCategory:self.colorCategory];
    if (!self.enabled) {
        color = [color colorWithAlphaComponent:[UIColor themeDisabledAlpha]];
    }
    [drawString setTextColor:color];
    [drawString drawInRect:self.bounds];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self setNeedsDisplay];
}

@end
