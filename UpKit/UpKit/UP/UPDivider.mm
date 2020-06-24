//
//  UPDivider.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPDivider.h"

@implementation UPDivider

#pragma mark - Update theme colors

+ (UPDivider *)divider
{
    return [[UPDivider alloc] _init];
}

- (instancetype)_init
{
    self = [super initWithFrame:CGRectZero];
    self.colorCategory = UPColorCategoryPrimaryFill;
    return self;
}

- (void)setColorCategory:(UPColorCategory)colorCategory
{
    _colorCategory = colorCategory;
    [self updateThemeColors];
}

- (void)updateThemeColors
{
    self.backgroundColor = [UIColor themeColorWithCategory:self.colorCategory];
}

@end
