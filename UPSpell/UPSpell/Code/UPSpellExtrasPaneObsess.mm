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

@interface UPSpellExtrasPaneObsess ()
{
    GameKey m_game_key;
}
@property (nonatomic) NSArray<UPRotor *> *rotors;
@property (nonatomic) UPBallot *obsessCheckbox;
@property (nonatomic) UPLabel *obsessDescription;
@property (nonatomic) UPButton *helpButton;
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

    UPRotorType rotor_types[SpellLayout::ExtrasObsessGameKeyPickerRotorCount] = {
        UPRotorTypeAlphabet, UPRotorTypeAlphabet, UPRotorTypeAlphabet,
        UPRotorTypeNumbers, UPRotorTypeNumbers, UPRotorTypeNumbers, UPRotorTypeNumbers
    };
    Role rotor_roles[SpellLayout::ExtrasObsessGameKeyPickerRotorCount] = {
        Role::ExtrasObsessGameKeyPickerRotor1, Role::ExtrasObsessGameKeyPickerRotor2, Role::ExtrasObsessGameKeyPickerRotor3,
        Role::ExtrasObsessGameKeyPickerRotor4, Role::ExtrasObsessGameKeyPickerRotor5, Role::ExtrasObsessGameKeyPickerRotor6,
        Role::ExtrasObsessGameKeyPickerRotor7 };
    NSMutableArray *rotors = [NSMutableArray array];
    for (int i = 0; i < SpellLayout::ExtrasObsessGameKeyPickerRotorCount; i++) {
        UPRotor *rotor = [UPRotor rotorWithType:rotor_types[i]];
        [rotor setTarget:self action:@selector(gameKeyRotorsChanged)];
        rotor.frame = layout.frame_for(rotor_roles[i]);
        [self addSubview:rotor];
        [rotors addObject:rotor];
    }
    self.rotors = rotors;
    
    self.obsessCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.obsessCheckbox.labelString = @"OBSESS";
    [self.obsessCheckbox setTarget:self action:@selector(obsessCheckboxTapped)];
    self.obsessCheckbox.frame = layout.frame_for(Role::ExtrasObsessCheckbox);
    [self addSubview:self.obsessCheckbox];

    self.obsessDescription = [UPLabel label];
    self.obsessDescription.frame = layout.frame_for(Role::ExtrasObsessDescription);
    self.obsessDescription.font = layout.settings_description_font();
    self.obsessDescription.textColorCategory = UPColorCategoryControlText;
    self.obsessDescription.backgroundColorCategory = UPColorCategoryClear;
    self.obsessDescription.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.obsessDescription];

    self.helpButton = [UPButton roundHelpButton];
    self.helpButton.frame = layout.frame_for(Role::ExtrasObsessHelp);
    [self addSubview:self.helpButton];

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

    [self setRotorsFromGameKey];
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

- (void)setRotorsFromGameKey
{
    NSString *gameKeyString = ns_str(m_game_key.string());
    for (int i = 0; i < SpellLayout::ExtrasObsessGameKeyPickerRotorCount; i++) {
        UPRotor *rotor = self.rotors[i];
        NSUInteger stringIndex = i <= 2 ? i : i + 1;
        NSString *string = [gameKeyString substringWithRange:NSMakeRange(stringIndex, 1)];
        if ([string isEqualToString:@"-"]) {
            continue;
        }
        NSUInteger index = [rotor.elements indexOfObject:string];
        ASSERT(index != NSNotFound);
        [rotor selectIndex:index];
    }
}

- (void)setGameKeyFromRotors
{
    NSMutableString *gameKeyString = [NSMutableString string];
    for (int i = 0; i < SpellLayout::ExtrasObsessGameKeyPickerRotorCount; i++) {
        UPRotor *rotor = self.rotors[i];
        [gameKeyString appendString:rotor.selectedString];
        if (gameKeyString.length == 3) {
            [gameKeyString appendString:@"-"];
        }
    }
    m_game_key = GameKey(cpp_str(gameKeyString));
}

- (void)gameKeyRotorsChanged
{
    [self setGameKeyFromRotors];
    [self updateObsessDescription];
    
    BOOL changing = NO;
    for (UPRotor *rotor in self.rotors) {
        if (rotor.changing) {
            changing = YES;
            break;
        }
    }
    if (changing) {
        // blank stats
    }
    else {
        if (self.obsessCheckbox.selected) {
            UPSpellSettings *settings = [UPSpellSettings instance];
            settings.obsessGameKeyValue = m_game_key.value();
        }
    }
}

- (void)updateObsessDescription
{
    NSMutableString *string = [NSMutableString string];
    if (self.obsessCheckbox.selected) {
        NSString *gameKeyString = ns_str(m_game_key.string());
        [string appendFormat:@"All new games use GAMEKEY %@ and repeat\nthe same sequence of letter tiles", gameKeyString];
    }
    else {
        [string appendString:@"Each new game uses a different GAMEKEY chosen\n"
         "at random to give a varied sequence of letter tiles"];
    }
    self.obsessDescription.string = string;
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
