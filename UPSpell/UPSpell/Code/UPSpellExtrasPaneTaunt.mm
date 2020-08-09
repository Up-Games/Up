//
//  UPSpellExtrasPaneTaunt.mm
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

typedef NS_ENUM(NSInteger, UPTauntType) {
    UPTauntTypeNone,
    UPTauntTypeHighScore,
    UPTauntTypeLastGameScore,
};

@interface UPSpellExtrasPaneTaunt () <UIActivityItemSource>
@property (nonatomic) UPLabel *highScoreLabel;
@property (nonatomic) UPLabel *highScoreDescriptionLabel;
@property (nonatomic) UPLabel *lastGameScoreLabel;
@property (nonatomic) UPLabel *lastGameScoreDescriptionLabel;
@property (nonatomic) UPTextButton *highScoreTauntButton;
@property (nonatomic) UPTextButton *lastGameScoreTauntButton;
@property (nonatomic) UPLabel *tauntDescription;
@property (nonatomic) UPTauntType tauntType;
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

    self.lastGameScoreDescriptionLabel = [UPLabel label];
    self.lastGameScoreDescriptionLabel.font = layout.placard_description_font();
    self.lastGameScoreDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.lastGameScoreDescriptionLabel.frame = layout.frame_for(Role::ExtrasTauntLastGameDescription);
    self.lastGameScoreDescriptionLabel.string = @"LAST GAME";
    [self addSubview:self.lastGameScoreDescriptionLabel];
    
    self.lastGameScoreTauntButton = [UPTextButton smallTextButton];
    [self.lastGameScoreTauntButton setTarget:self action:@selector(lastGameTauntButtonTapped)];
    self.lastGameScoreTauntButton.labelString = @"TAUNT";
    self.lastGameScoreTauntButton.frame = layout.frame_for(Role::ExtrasTauntLastGameButton);
    [self addSubview:self.lastGameScoreTauntButton];

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
        self.lastGameScoreTauntButton.enabled = YES;
    }
    else {
        self.highScoreLabel.string = @"–";
        self.lastGameScoreLabel.string = @"–";
        self.highScoreLabel.colorCategory = UPColorCategoryInactiveContent;
        self.lastGameScoreLabel.colorCategory = UPColorCategoryInactiveContent;
        self.highScoreTauntButton.enabled = NO;
        self.lastGameScoreTauntButton.enabled = NO;
    }
    [self updateThemeColors];
}

#pragma mark - Target / Action

- (void)highScoreTauntButtonTapped
{
    self.tauntType = UPTauntTypeHighScore;

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
//        self.tauntType = UPTauntTypeNone;
    }];
}

- (void)lastGameTauntButtonTapped
{
}

- (NSString *)tauntURLString
{
    return @"https://upgames.dev/t/?g=upspell&k=GBK-1782&s=163";
}

- (NSURL *)tauntURL
{
    return [NSURL URLWithString:[self tauntURLString]];
}

- (NSString *)tauntString
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    int score = 0;
    switch (self.tauntType) {
        case UPTauntTypeNone:
            break;
        case UPTauntTypeHighScore:
            score = dossier.highScore;
            break;
        case UPTauntTypeLastGameScore:
            score = dossier.lastScore;
            break;
    }
    
    return [NSString stringWithFormat:@"I scored %d in Up Spell. Top that!", score];
}

- (NSString *)tauntStringWithURL
{
    return [NSString stringWithFormat:@"%@ %@", [self tauntString], [self tauntURLString]];
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return [self tauntURL];

}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(UIActivityType)activityType
{
    return [self tauntURL];
}

- (LPLinkMetadata *)activityViewControllerLinkMetadata:(UIActivityViewController *)activityViewController
{
    LPLinkMetadata *metadata = [[LPLinkMetadata alloc] init];
    metadata.originalURL = [self tauntURL];
    metadata.URL = [self tauntURL];
    metadata.title = [self tauntString];
    
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
