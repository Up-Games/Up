//
//  UPSpellExtrasStatsPane.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPCheckbox.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasPaneStats.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextButton.h"
#import "UPTileView.h"
#import "UPViewMove+UPSpell.h"

@interface UPSpellExtrasPaneStats ()
@end

using UP::BandSettingsUI;
using UP::BandSettingsAnimationDelay;
using UP::BandSettingsUpdateDelay;
using UP::SpellLayout;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Place;

@implementation UPSpellExtrasPaneStats

+ (UPSpellExtrasPaneStats *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

//    SpellLayout &layout = SpellLayout::instance();
    
    
    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;
    
//    SpellLayout &layout = SpellLayout::instance();
//    self.hueDescription.frame = layout.frame_for(Role::ExtrasColorsDescription);
//    self.exampleTilesContainer.center = layout.center_for(Role::ExtrasColorsExample);
//    self.iconPrompt.frame = layout.frame_for(Role::ExtrasColorsIconPrompt, Spot::OffBottomFar);
//    self.iconButtonNope.frame = layout.frame_for(Role::ExtrasColorsIconButtonNope, Spot::OffBottomFar);
//    self.iconButtonYep.frame = layout.frame_for(Role::ExtrasColorsIconButtonYep, Spot::OffBottomFar);
}

- (void)cancelAnimations
{
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
