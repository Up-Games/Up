//
//  UPSpellExtrasPaneShare.mm
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
#import "UPActivityViewController.h"
#import "UPBallot.h"
#import "UPControl+UPSpell.h"
#import "UPDialogTopMenu.h"
#import "UPSpellDossier.h"
#import "UPSoundPlayer.h"
#import "UPSlider.h"
#import "UPSpellExtrasPaneShare.h"
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

@interface UPSpellExtrasPaneShare ()
@property (nonatomic) UPLabel *highScoreLabel;
@property (nonatomic) UPLabel *highScoreDescriptionLabel;
@property (nonatomic) UPLabel *lastGameScoreLabel;
@property (nonatomic) UPLabel *lastGameScoreDescriptionLabel;
@property (nonatomic) UPButton *highScoreShareButton;
@property (nonatomic) UPButton *lastGameScoreShareButton;
@property (nonatomic) UPLabel *shareDescription;
@property (nonatomic) UPLabel *highScoreEqualsLastGameDescription;
@end

@implementation UPSpellExtrasPaneShare

+ (UPSpellExtrasPaneShare *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.shareDescription = [UPLabel label];
    self.shareDescription.frame = layout.frame_for(Role::ExtrasShareDescription);
    self.shareDescription.font = layout.description_font();
    self.shareDescription.colorCategory = UPColorCategoryControlText;
    self.shareDescription.textAlignment = NSTextAlignmentCenter;
    self.shareDescription.string =
       @"SHARE a link to a new game with the same\n"
        "letters as one of your previous games.\n"
        "Challenge friends to top your score.";
    [self addSubview:self.shareDescription];

    self.highScoreLabel = [UPLabel label];
    self.highScoreLabel.colorCategory = UPColorCategoryControlText;
    self.highScoreLabel.font = layout.placard_value_font();
    self.highScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.highScoreLabel.frame = layout.frame_for(Role::ExtrasShareHighScoreValue);
    [self addSubview:self.highScoreLabel];

    self.highScoreDescriptionLabel = [UPLabel label];
    self.highScoreDescriptionLabel.colorCategory = UPColorCategoryControlText;
    self.highScoreDescriptionLabel.font = layout.placard_description_font();
    self.highScoreDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.highScoreDescriptionLabel.frame = layout.frame_for(Role::ExtrasShareHighScoreDescription);
    self.highScoreDescriptionLabel.string = @"HIGH SCORE";
    [self addSubview:self.highScoreDescriptionLabel];

    self.highScoreShareButton = [UPButton roundShareButton];
    [self.highScoreShareButton setTarget:self action:@selector(highScoreShareButtonTapped)];
    self.highScoreShareButton.frame = layout.frame_for(Role::ExtrasShareHighScoreButton);
    [self addSubview:self.highScoreShareButton];

    self.lastGameScoreLabel = [UPLabel label];
    self.lastGameScoreLabel.colorCategory = UPColorCategoryControlText;
    self.lastGameScoreLabel.font = layout.placard_value_font();
    self.lastGameScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.lastGameScoreLabel.frame = layout.frame_for(Role::ExtrasShareLastGameValue);
    [self addSubview:self.lastGameScoreLabel];

    self.lastGameScoreDescriptionLabel = [UPLabel label];
    self.lastGameScoreDescriptionLabel.colorCategory = UPColorCategoryControlText;
    self.lastGameScoreDescriptionLabel.font = layout.placard_description_font();
    self.lastGameScoreDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.lastGameScoreDescriptionLabel.frame = layout.frame_for(Role::ExtrasShareLastGameDescription);
    self.lastGameScoreDescriptionLabel.string = @"LAST GAME";
    [self addSubview:self.lastGameScoreDescriptionLabel];
    
    self.lastGameScoreShareButton = [UPButton roundShareButton];
    [self.lastGameScoreShareButton setTarget:self action:@selector(lastGameShareButtonTapped)];
    self.lastGameScoreShareButton.frame = layout.frame_for(Role::ExtrasShareLastGameButton);
    [self addSubview:self.lastGameScoreShareButton];

    self.highScoreEqualsLastGameDescription = [UPLabel label];
    self.highScoreEqualsLastGameDescription.colorCategory = UPColorCategoryControlText;
    self.highScoreEqualsLastGameDescription.font = layout.description_font();
    self.highScoreEqualsLastGameDescription.textAlignment = NSTextAlignmentCenter;
    self.highScoreEqualsLastGameDescription.frame = layout.frame_for(Role::ExtrasShareLastGameHighScoreEqualDescription);
    self.highScoreEqualsLastGameDescription.string = @"NOTE: last game was your high score.";
    [self addSubview:self.highScoreEqualsLastGameDescription];
    self.highScoreEqualsLastGameDescription.hidden = YES;
    
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
        self.highScoreShareButton.userInteractionEnabled = YES;
        self.lastGameScoreShareButton.userInteractionEnabled = YES;
        self.highScoreLabel.alpha = 1;
        self.highScoreDescriptionLabel.alpha = 1;
        self.highScoreShareButton.alpha = 1;
        self.lastGameScoreLabel.alpha = 1;
        self.lastGameScoreDescriptionLabel.alpha = 1;
        self.lastGameScoreShareButton.alpha = 1;
        self.shareDescription.string =
        @"SHARE a link to a new game with the same\n"
        "letters as one of your previous games.\n"
        "Challenge friends to top your score.";
        
        SpellLayout &layout = SpellLayout::instance();
        if ([dossier lastGameIsHighScore]) {
            self.highScoreEqualsLastGameDescription.hidden = NO;
            CGRect frame = layout.frame_for(Role::ExtrasShareDescription);
            frame.origin.y += up_float_scaled(SpellLayout::CanonicalExtrasShareLastGameHighScoreEqualGap, layout.layout_scale());
            self.shareDescription.frame = frame;

            self.lastGameScoreShareButton.userInteractionEnabled = NO;
            CGFloat alpha = [UIColor themeDisabledAlpha];
            self.lastGameScoreLabel.alpha = alpha;
            self.lastGameScoreDescriptionLabel.alpha = alpha;
            self.lastGameScoreShareButton.alpha = alpha;
        }
        else {
            self.highScoreEqualsLastGameDescription.hidden = YES;
            self.shareDescription.frame = layout.frame_for(Role::ExtrasShareDescription);
        }
        
    }
    else {
        self.highScoreLabel.string = @"–";
        self.lastGameScoreLabel.string = @"–";
        self.highScoreShareButton.userInteractionEnabled = NO;
        self.lastGameScoreShareButton.userInteractionEnabled = NO;
        CGFloat alpha = [UIColor themeDisabledAlpha];
        self.highScoreLabel.alpha = alpha;
        self.highScoreDescriptionLabel.alpha = alpha;
        self.highScoreShareButton.alpha = alpha;
        self.lastGameScoreLabel.alpha = alpha;
        self.lastGameScoreDescriptionLabel.alpha = alpha;
        self.lastGameScoreShareButton.alpha = alpha;
        self.shareDescription.string =
        @"Play some games, then return here to SHARE\n"
        "links to new games with the same letters.\n"
        "Challenge friends to top your score.";
    }
    [self updateThemeColors];
}

#pragma mark - Target / Action

- (void)highScoreShareButtonTapped
{
    [self presentShareSheetForShareType:UPShareTypeHighScore];
}

- (void)lastGameShareButtonTapped
{
    [self presentShareSheetForShareType:UPShareTypeLastGameScore];
}

- (void)presentShareSheetForShareType:(UPShareType)shareType
{
    UPSpellExtrasController *extrasController = [UPSpellExtrasController instance];
    UPActivityViewController *activityViewController = [[UPActivityViewController alloc] initWithShareType:shareType];
    [extrasController presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
