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
    
    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    m_game_key = GameKey::random();
//    m_game_key = GameKey("YFE-1906");
    [self setRotorsFromGameKey];
    
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
    LOG(General, "GameKey: %s", m_game_key.string().c_str());
}

- (void)gameKeyRotorsChanged
{
    [self setGameKeyFromRotors];
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
