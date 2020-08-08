//
//  UPSpellExtrasPaneTaunt.mm
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
#import "UPSpellDossier.h"
#import "UPHueWheel.h"
#import "UPSoundPlayer.h"
#import "UPSlider.h"
#import "UPSpellExtrasPaneTaunt.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameRetry.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextButton.h"
#import "UPTileView.h"
#import "UPTunePlayer.h"
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

@interface UPSpellExtrasPaneTaunt ()
@property (nonatomic) UPLabel *highScoreLabel;
@property (nonatomic) UPLabel *highScoreDescriptionLabel;
@property (nonatomic) UPLabel *lastGameScoreLabel;
@property (nonatomic) UPLabel *lastGameDescriptionLabel;
@property (nonatomic) UPTextButton *highScoreTauntButton;
@property (nonatomic) UPTextButton *lastGameTauntButton;
@property (nonatomic) UPLabel *tauntDescription;
@end

@implementation UPSpellExtrasPaneTaunt

+ (UPSpellExtrasPaneTaunt *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.tauntDescription = [UPLabel label];
    self.tauntDescription.frame = layout.frame_for(Role::ExtrasTauntDescription);
    self.tauntDescription.font = layout.settings_description_font();
    self.tauntDescription.colorCategory = UPColorCategoryControlText;
    self.tauntDescription.textAlignment = NSTextAlignmentCenter;
    self.tauntDescription.string = @"TAUNT creates a link to a game with the same\n"
        "letters as one of your previous games.\n"
        "Challenge family and friends to beat your score.";
    [self addSubview:self.tauntDescription];

    self.highScoreLabel = [UPLabel label];
    self.highScoreLabel.font = layout.placard_value_font();
    self.highScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.highScoreLabel.frame = layout.frame_for(Role::ExtrasTauntHighScoreValue);
    [self addSubview:self.highScoreLabel];

    self.highScoreDescriptionLabel = [UPLabel label];
    self.highScoreDescriptionLabel.font = layout.placard_description_font();
    self.highScoreDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.highScoreDescriptionLabel.frame = layout.frame_for(Role::ExtrasTauntHighScoreDescription);
    self.highScoreDescriptionLabel.string = @"HIGH SCORE";
    [self addSubview:self.highScoreDescriptionLabel];

    self.highScoreTauntButton = [UPTextButton smallTextButton];
    [self.highScoreTauntButton setTarget:self action:@selector(highScoreTauntButtonTapped)];
    self.highScoreTauntButton.labelString = @"TAUNT";
    self.highScoreTauntButton.frame = layout.frame_for(Role::ExtrasTauntHighScoreButton);
    [self addSubview:self.highScoreTauntButton];
    
    self.lastGameScoreLabel = [UPLabel label];
    self.lastGameScoreLabel.font = layout.placard_value_font();
    self.lastGameScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.lastGameScoreLabel.frame = layout.frame_for(Role::ExtrasTauntLastGameValue);
    [self addSubview:self.lastGameScoreLabel];

    self.lastGameDescriptionLabel = [UPLabel label];
    self.lastGameDescriptionLabel.font = layout.placard_description_font();
    self.lastGameDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.lastGameDescriptionLabel.frame = layout.frame_for(Role::ExtrasTauntLastGameDescription);
    self.lastGameDescriptionLabel.string = @"LAST GAME";
    [self addSubview:self.lastGameDescriptionLabel];
    
    self.lastGameTauntButton = [UPTextButton smallTextButton];
    [self.lastGameTauntButton setTarget:self action:@selector(lastGameTauntButtonTapped)];
    self.lastGameTauntButton.labelString = @"TAUNT";
    self.lastGameTauntButton.frame = layout.frame_for(Role::ExtrasTauntLastGameButton);
    [self addSubview:self.lastGameTauntButton];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    UPSpellDossier *dossier = [UPSpellDossier instance];

    if (dossier.totalGamesPlayed > 0) {
        self.highScoreLabel.string = [NSString stringWithFormat:@"%d", dossier.highScore];
        self.lastGameScoreLabel.string = [NSString stringWithFormat:@"%d", dossier.lastScore];
        self.highScoreLabel.colorCategory = UPColorCategoryInformation;
        self.lastGameScoreLabel.colorCategory = UPColorCategoryInformation;
        self.highScoreTauntButton.enabled = YES;
        self.lastGameTauntButton.enabled = YES;
    }
    else {
        self.highScoreLabel.string = @"–";
        self.lastGameScoreLabel.string = @"–";
        self.highScoreLabel.colorCategory = UPColorCategoryInactiveContent;
        self.lastGameScoreLabel.colorCategory = UPColorCategoryInactiveContent;
        self.highScoreTauntButton.enabled = NO;
        self.lastGameTauntButton.enabled = NO;
    }
    [self updateThemeColors];
}

#pragma mark - Target / Action

- (void)highScoreTauntButtonTapped
{
}

- (void)lastGameTauntButtonTapped
{
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
