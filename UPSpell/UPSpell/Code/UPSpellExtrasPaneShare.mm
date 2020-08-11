//
//  UPSpellExtrasPaneShare.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <LinkPresentation/LinkPresentation.h>

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
#import "UPHueWheel.h"
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

typedef NS_ENUM(NSInteger, UPShareType) {
    UPShareTypeNone,
    UPShareTypeHighScore,
    UPShareTypeLastGameScore,
};

@interface UPSpellExtrasPaneShare () <UIActivityItemSource>
@property (nonatomic) UPLabel *highScoreLabel;
@property (nonatomic) UPLabel *highScoreDescriptionLabel;
@property (nonatomic) UPLabel *lastGameScoreLabel;
@property (nonatomic) UPLabel *lastGameScoreDescriptionLabel;
@property (nonatomic) UPButton *highScoreShareButton;
@property (nonatomic) UPButton *lastGameScoreShareButton;
@property (nonatomic) UPLabel *shareDescription;
@property (nonatomic) UPShareType shareType;
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
    self.shareDescription.font = layout.settings_description_font();
    self.shareDescription.colorCategory = UPColorCategoryControlText;
    self.shareDescription.textAlignment = NSTextAlignmentCenter;
    self.shareDescription.string =
       @"SHARE a link to a new game with the same\n"
        "letters as one of your previous games.\n"
        "Challenge friends to top your score.";
    [self addSubview:self.shareDescription];

    self.highScoreLabel = [UPLabel label];
    self.highScoreLabel.font = layout.placard_value_font();
    self.highScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.highScoreLabel.frame = layout.frame_for(Role::ExtrasShareHighScoreValue);
    [self addSubview:self.highScoreLabel];

    self.highScoreDescriptionLabel = [UPLabel label];
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
    self.lastGameScoreLabel.font = layout.placard_value_font();
    self.lastGameScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.lastGameScoreLabel.frame = layout.frame_for(Role::ExtrasShareLastGameValue);
    [self addSubview:self.lastGameScoreLabel];

    self.lastGameScoreDescriptionLabel = [UPLabel label];
    self.lastGameScoreDescriptionLabel.font = layout.placard_description_font();
    self.lastGameScoreDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.lastGameScoreDescriptionLabel.frame = layout.frame_for(Role::ExtrasShareLastGameDescription);
    self.lastGameScoreDescriptionLabel.string = @"LAST GAME";
    [self addSubview:self.lastGameScoreDescriptionLabel];
    
    self.lastGameScoreShareButton = [UPButton roundShareButton];
    [self.lastGameScoreShareButton setTarget:self action:@selector(lastGameShareButtonTapped)];
    self.lastGameScoreShareButton.frame = layout.frame_for(Role::ExtrasShareLastGameButton);
    [self addSubview:self.lastGameScoreShareButton];

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
        self.highScoreShareButton.enabled = YES;
        self.lastGameScoreShareButton.enabled = YES;
    }
    else {
        self.highScoreLabel.string = @"–";
        self.lastGameScoreLabel.string = @"–";
        self.highScoreLabel.colorCategory = UPColorCategoryInactiveContent;
        self.lastGameScoreLabel.colorCategory = UPColorCategoryInactiveContent;
        self.highScoreShareButton.enabled = NO;
        self.lastGameScoreShareButton.enabled = NO;
    }
    [self updateThemeColors];
}

#pragma mark - Target / Action

- (void)highScoreShareButtonTapped
{
    self.shareType = UPShareTypeHighScore;

    UPSpellExtrasController *extrasController = [UPSpellExtrasController instance];

    UPActivityViewController *activityViewController = [[UPActivityViewController alloc] initWithActivityItems:@[self]];
    activityViewController.excludedActivityTypes = @[
        UIActivityTypeAirDrop,
        UIActivityTypePrint,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypeMarkupAsPDF,
        UIActivityTypeAddToReadingList,
        UIActivityTypeOpenInIBooks
    ];

    [extrasController presentViewController:activityViewController animated:YES completion:^{
//        self.shareType = UPShareTypeNone;
    }];
}

- (void)lastGameShareButtonTapped
{
}

- (NSString *)shareURLString
{
    return @"https://upgames.dev/t/?g=upspell&k=GBK-1782&s=163";
}

- (NSURL *)shareURL
{
    return [NSURL URLWithString:[self shareURLString]];
}

- (NSString *)shareString
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    int score = 0;
    switch (self.shareType) {
        case UPShareTypeNone:
            break;
        case UPShareTypeHighScore:
            score = dossier.highScore;
            break;
        case UPShareTypeLastGameScore:
            score = dossier.lastScore;
            break;
    }
    
    return [NSString stringWithFormat:@"I scored %d in Up Spell. Top that!", score];
}

- (NSString *)shareStringWithURL
{
    return [NSString stringWithFormat:@"%@ %@", [self shareString], [self shareURLString]];
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return [self shareURL];

}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(UIActivityType)activityType
{
    return [self shareURL];
}

- (LPLinkMetadata *)activityViewControllerLinkMetadata:(UIActivityViewController *)activityViewController
{
    LPLinkMetadata *metadata = [[LPLinkMetadata alloc] init];
    metadata.originalURL = [self shareURL];
    metadata.URL = [self shareURL];
    metadata.title = [self shareString];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSString *iconName = [NSString stringWithFormat:@"%@@%dx", up_theme_icon_name(), (int)scale];
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *iconURL = [bundle URLForResource:[iconName lastPathComponent] withExtension:@"png"];
    metadata.iconProvider = [[NSItemProvider alloc] initWithContentsOfURL:iconURL];
    
    return metadata;
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
