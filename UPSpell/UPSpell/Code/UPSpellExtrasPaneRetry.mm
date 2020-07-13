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
@property (nonatomic) UPBallot *quickRetryCheckbox;
@property (nonatomic) UPLabel *topDescription;
@property (nonatomic) UPLabel *bottomDescription;
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

    self.topDescription = [UPLabel label];
    self.topDescription.frame = layout.frame_for(Role::ExtrasRetryTopDescription);
    self.topDescription.font = layout.settings_description_font();
    self.topDescription.colorCategory = UPColorCategoryControlText;
    self.topDescription.textAlignment = NSTextAlignmentCenter;
    self.topDescription.string = @"Tap RETRY to repeat a game. Try to improve\nyour score using the same sequence of letters.";
    [self addSubview:self.topDescription];

    self.quickRetryCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.quickRetryCheckbox.labelString = @"QUICK RETRY";
    [self.quickRetryCheckbox setTarget:self action:@selector(quickRetryCheckboxTapped)];
    self.quickRetryCheckbox.frame = layout.frame_for(Role::ExtrasRetryQuickRetry);
    [self addSubview:self.quickRetryCheckbox];

    self.bottomDescription = [UPLabel label];
    self.bottomDescription.frame = layout.frame_for(Role::ExtrasRetryBottomDescription);
    self.bottomDescription.font = layout.settings_description_font();
    self.bottomDescription.colorCategory = UPColorCategoryControlText;
    self.bottomDescription.textAlignment = NSTextAlignmentCenter;
    self.bottomDescription.string = @"Adds a RETRY checkbox to the GAME OVER screen.\nCheck it and tap PLAY to repeat the last game.";
    [self addSubview:self.bottomDescription];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    UPSpellSettings *settings = [UPSpellSettings instance];
    [self.quickRetryCheckbox setSelected:settings.quickRetry];
}

- (void)quickRetryCheckboxTapped
{
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.quickRetry = self.quickRetryCheckbox.selected;
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
