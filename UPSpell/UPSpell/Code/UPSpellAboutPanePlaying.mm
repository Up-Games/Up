//
//  UPSpellAboutPanePlaying.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPMath.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutPanePlaying.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;

@interface UPSpellAboutPanePlaying ()
@end

@implementation UPSpellAboutPanePlaying

+ (UPSpellAboutPanePlaying *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

//    SpellLayout &layout = SpellLayout::instance();

    self.backgroundColor = [UIColor testColor1];
    
    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    [self updateThemeColors];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
