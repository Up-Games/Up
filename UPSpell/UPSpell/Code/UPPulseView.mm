//
//  UPPulseView.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>

#import "UPPulseView.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

@implementation UPPulseView

- (instancetype)init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.screen_bounds()];
    self.userInteractionEnabled = NO;
    self.alpha = 0;
    [self updateThemeColors];
    return self;
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
}

- (void)updateThemeColors
{
    self.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryPulse];
}

@end
