//
//  UPSpellExtrasPaneObsess.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPDivider.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLayoutRule.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPBallot.h"
#import "UPControl+UPSpell.h"
#import "UPHueWheel.h"
#import "UPRotor.h"
#import "UPSpellGameSummary.h"
#import "UPSpellExtrasPaneObsess.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextButton.h"
#import "UPTileView.h"
#import "UPViewMove+UPSpell.h"

using UP::BandSettingsUI;
using UP::BandSettingsAnimationDelay;
using UP::BandSettingsUpdateDelay;
using UP::SpellGameSummary;
using UP::SpellLayout;
using UP::SpellModel;
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

@interface UPSpellExtrasPaneObsess ()
@property (nonatomic) UPRotor *rotor;
@end

@implementation UPSpellExtrasPaneObsess

+ (UPSpellExtrasPaneObsess *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.rotor = [UPRotor rotorWithType:UPRotorTypeNumbers];
    self.rotor.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor1Frame);
    [self addSubview:self.rotor];
    
    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

//    SpellLayout &layout = SpellLayout::instance();
//    self.gamesHeader.frame = layout.frame_for(Role::ExtrasObsessHeader);
//    self.gamesTable.frame = layout.frame_for(Role::ExtrasObsessTable);
//
//    CGRect gamesBackgroundViewFrame = self.gamesHeader.frame;
//    gamesBackgroundViewFrame.size.height += up_rect_height(self.gamesTable.frame);
//    self.gamesBackgroundView.frame = gamesBackgroundViewFrame;
//
//    UPSpellSettings *settings = [UPSpellSettings instance];
//    [self updateRadioButtons:settings.statsSelectedTabIndex];
//    [self setSelectedTab:settings.statsSelectedTabIndex];
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
