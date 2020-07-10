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
@property (nonatomic) UPRotor *rotor1;
@property (nonatomic) UPRotor *rotor2;
@property (nonatomic) UPRotor *rotor3;
@property (nonatomic) UPRotor *rotor4;
@property (nonatomic) UPRotor *rotor5;
@property (nonatomic) UPRotor *rotor6;
@property (nonatomic) UPRotor *rotor7;
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

    self.rotor1 = [UPRotor rotorWithType:UPRotorTypeAlphabet];
    self.rotor1.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor1Frame);
    [self addSubview:self.rotor1];

    self.rotor2 = [UPRotor rotorWithType:UPRotorTypeAlphabet];
    self.rotor2.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor2Frame);
    [self addSubview:self.rotor2];

    self.rotor3 = [UPRotor rotorWithType:UPRotorTypeAlphabet];
    self.rotor3.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor3Frame);
    [self addSubview:self.rotor3];

    self.rotor4 = [UPRotor rotorWithType:UPRotorTypeNumbers];
    self.rotor4.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor4Frame);
    [self addSubview:self.rotor4];

    self.rotor5 = [UPRotor rotorWithType:UPRotorTypeNumbers];
    self.rotor5.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor5Frame);
    [self addSubview:self.rotor5];

    self.rotor6 = [UPRotor rotorWithType:UPRotorTypeNumbers];
    self.rotor6.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor6Frame);
    [self addSubview:self.rotor6];

    self.rotor7 = [UPRotor rotorWithType:UPRotorTypeNumbers];
    self.rotor7.frame = layout.layout_relative_aspect_rect(SpellLayout::CanonicalExtrasObsessRotor7Frame);
    [self addSubview:self.rotor7];

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
