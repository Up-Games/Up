//
//  UPSpellExtrasPaneRetry.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPDivider.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLayoutRule.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPPlacard.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPBallot.h"
#import "UPControl+UPSpell.h"
#import "UPDialogTopMenu.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasPaneRetry.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameRetry.h"
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
@property (nonatomic) UPBallot *retryCheckbox;
@property (nonatomic) UPLabel *retryDescription;
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

    self.retryDescription = [UPLabel label];
    self.retryDescription.frame = layout.frame_for(Role::ExtrasRetryDescription);
    self.retryDescription.font = layout.settings_description_font();
    self.retryDescription.colorCategory = UPColorCategoryControlText;
    self.retryDescription.textAlignment = NSTextAlignmentLeft;
    self.retryDescription.string =
       @"RETRY repeats the letter sequence from a previous\n"
        "game, giving you a chance to improve your score.\n\n"
        "Enable to show the RETRY menu after tapping PLAY\n"
        "on the main screen, with options to retry your\n"
        "high score game, your last game, or play a new game.\n";
    [self addSubview:self.retryDescription];

    self.retryCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.retryCheckbox.labelString = @"RETRY MENU";
    [self.retryCheckbox setTarget:self action:@selector(retryCheckboxTapped)];
    self.retryCheckbox.frame = layout.frame_for(Role::ExtrasRetryCheckbox);
    [self addSubview:self.retryCheckbox];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    UPSpellSettings *settings = [UPSpellSettings instance];
    [self.retryCheckbox setSelected:settings.retryMode];
}

- (void)retryCheckboxTapped
{
    BOOL selected = self.retryCheckbox.selected;
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.retryMode = selected;
    
    // It's a wart that this code knows about UPDialogTopMenu
    UPDialogTopMenu *dialogTopMenu = [UPDialogTopMenu instance];
    dialogTopMenu.playButton.behavior = selected ? UPTextButtonBehaviorModeButton : UPTextButtonBehaviorPushButton;
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
