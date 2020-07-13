//
//  UPSpellExtrasPaneRetry.mm
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
#import "UPSpellExtrasPaneRetry.h"
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
using UP::GameKey;
using UP::SpellGameSummary;
using UP::SpellLayout;
using UP::SpellModel;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;

using UP::cpp_str;
using UP::ns_str;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Place;

@interface UPSpellExtrasPaneRetry ()
{
    GameKey m_game_key;
}
@property (nonatomic) NSArray<UPRotor *> *rotors;
@property (nonatomic) UPBallot *obsessCheckbox;
@property (nonatomic) UPLabel *obsessDescription;
@end

@implementation UPSpellExtrasPaneRetry

+ (UPSpellExtrasPaneRetry *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.obsessCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.obsessCheckbox.labelString = @"OBSESS";
    [self.obsessCheckbox setTarget:self action:@selector(obsessCheckboxTapped)];
    self.obsessCheckbox.frame = layout.frame_for(Role::ExtrasObsessCheckbox);
    [self addSubview:self.obsessCheckbox];

    self.obsessDescription = [UPLabel label];
    self.obsessDescription.frame = layout.frame_for(Role::ExtrasObsessDescription);
    self.obsessDescription.font = layout.settings_description_font();
    self.obsessDescription.colorCategory = UPColorCategoryControlText;
    self.obsessDescription.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.obsessDescription];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    UPSpellSettings *settings = [UPSpellSettings instance];
    if (settings.obsessMode) {
        m_game_key = GameKey(settings.obsessGameKeyValue);
        [self.obsessCheckbox setSelected:YES];
    }
    else {
        m_game_key = GameKey::random();
        [self.obsessCheckbox setSelected:NO];
    }

    [self updateObsessDescription];
}

- (void)obsessCheckboxTapped
{
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.obsessMode = self.obsessCheckbox.selected;
    if (self.obsessCheckbox.selected) {
        UPSpellSettings *settings = [UPSpellSettings instance];
        settings.obsessGameKeyValue = m_game_key.value();
    }

    [self updateObsessDescription];
}

- (void)updateObsessDescription
{
    NSMutableString *string = [NSMutableString string];
    if (self.obsessCheckbox.selected) {
        NSString *gameKeyString = ns_str(m_game_key.string());
        [string appendFormat:@"New games use GAMEKEY %@ and repeat\nthe same sequence of letter tiles", gameKeyString];
    }
    else {
        [string appendString:@"New games use a GAMEKEY chosen at random\n"
         "to give a varied sequence of letter tiles."];
    }
    self.obsessDescription.string = string;
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
