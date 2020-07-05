//
//  UPSpellExtrasPaneStats.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPBallot.h"
#import "UPControl+UPSpell.h"
#import "UPHueWheel.h"
#import "UPSpellGameSummary.h"
#import "UPSpellExtrasPaneStats.h"
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
using UP::SpellLayout;
using UP::SpellGameSummary;
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

typedef NS_ENUM(NSInteger, UPSpellExtrasPaneStatsCategory) {
    UPSpellExtrasPaneStatsCategoryDefault,
    UPSpellExtrasPaneStatsCategoryAverages,
    UPSpellExtrasPaneStatsCategoryGames,
    UPSpellExtrasPaneStatsCategoryWords,
};

@interface UPGameSummaryTableViewCell : UITableViewCell
{
    SpellGameSummary m_spell_game_summary;
}
@property (nonatomic) int rank;
@property (nonatomic) UPLabel *rankLabel;
@property (nonatomic) UPLabel *gameScoreLabel;
@property (nonatomic) UPLabel *wordsSubmittedCountLabel;
@property (nonatomic) UPLabel *wordScoreAverageLabel;
@property (nonatomic) UPLabel *wordLengthAverageLabel;
@property (nonatomic) UPLabel *gameKeyLabel;
@end

@implementation UPGameSummaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        
    return self;
}

- (void)setGameSummary:(const SpellGameSummary &)spell_game_summary
{
    m_spell_game_summary = spell_game_summary;
}

- (void)drawRect:(CGRect)rect
{
    SpellLayout &layout = SpellLayout::instance();

    UIFont *font = [UIFont checkboxControlFontOfSize:25];
    CGFloat x = 0;

    NSDictionary *rankAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSFontAttributeName: font
    };
    CGFloat rankWidth = SpellLayout::CanonicalExtrasGamesRankColumnWidth * layout.layout_scale();
    CGRect rankRect = CGRectMake(x, 0, rankWidth, 28);
    
    NSString *rankString = [NSString stringWithFormat:@"#%d", self.rank];
    [rankString drawInRect:rankRect withAttributes:rankAttributes];
}

@end

@interface UPSpellExtrasPaneStats () <UITableViewDataSource, UITableViewDelegate>
{
    std::vector<SpellGameSummary> m_best_games;
}
@property (nonatomic, readwrite) UPBallot *averagesTabRadioButton;
@property (nonatomic, readwrite) UPBallot *gamesTabRadioButton;
@property (nonatomic, readwrite) UPBallot *wordsTabRadioButton;
@property (nonatomic) NSArray<UPBallot *> *radioButtons;
@property (nonatomic, readwrite) UILabel *noStatsLabel;
@property (nonatomic, readwrite) UITableView *averagesTable;
@property (nonatomic, readwrite) UITableView *gamesTable;
@property (nonatomic, readwrite) UITableView *wordsTable;
@end


@implementation UPSpellExtrasPaneStats

+ (UPSpellExtrasPaneStats *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.averagesTabRadioButton = [UPBallot ballotWithType:UPBallotTypeRadioButton];
    self.averagesTabRadioButton.labelString = @"AVERAGES";
    self.averagesTabRadioButton.tag = 0;
    [self.averagesTabRadioButton setTarget:self action:@selector(tabRadioButtonTapped:)];
    self.averagesTabRadioButton.frame = layout.frame_for(Role::ExtrasStatsAveragesTabButton);
    [self addSubview:self.averagesTabRadioButton];

    self.gamesTabRadioButton = [UPBallot ballotWithType:UPBallotTypeRadioButton];
    self.gamesTabRadioButton.labelString = @"GAMES";
    self.gamesTabRadioButton.tag = 1;
    [self.gamesTabRadioButton setTarget:self action:@selector(tabRadioButtonTapped:)];
    self.gamesTabRadioButton.frame = layout.frame_for(Role::ExtrasStatsGamesTabButton);
    [self addSubview:self.gamesTabRadioButton];
    
    self.wordsTabRadioButton = [UPBallot ballotWithType:UPBallotTypeRadioButton];
    self.wordsTabRadioButton.labelString = @"WORDS";
    self.wordsTabRadioButton.tag = 2;
    [self.wordsTabRadioButton setTarget:self action:@selector(tabRadioButtonTapped:)];
    self.wordsTabRadioButton.frame = layout.frame_for(Role::ExtrasStatsWordsTabButton);
    [self addSubview:self.wordsTabRadioButton];
    
    self.radioButtons = @[ self.averagesTabRadioButton, self.gamesTabRadioButton, self.wordsTabRadioButton ];
    
    self.gamesTable = [[UITableView alloc] initWithFrame:CGRectZero];
    self.gamesTable.dataSource = self;
    self.gamesTable.delegate = self;
    [self.gamesTable registerClass:[UPGameSummaryTableViewCell class] forCellReuseIdentifier:@"UPGameSummaryTableViewCell"];
    [self addSubview:self.gamesTable];
//    self.gamesTable.backgroundColor = [UIColor testColor1];
    
    return self;
}

- (void)tabRadioButtonTapped:(UPBallot *)sender
{
    for (UPBallot *radioButton in self.radioButtons) {
        if (radioButton != sender) {
            radioButton.selected = NO;
            [radioButton invalidate];
            [radioButton update];
        }
    }
    
    NSUInteger statsSelectedTabIndex = sender.tag;

    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.statsSelectedTabIndex = statsSelectedTabIndex;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    SpellLayout &layout = SpellLayout::instance();
    self.gamesTable.frame = layout.frame_for(Role::ExtrasStatsTable);
}

- (void)cancelAnimations
{
}

#pragma mark - UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.gamesTable) {
        return 12; //m_best_games.size();
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.gamesTable) {
        UPGameSummaryTableViewCell *gamesCell = [tableView dequeueReusableCellWithIdentifier:@"UPGameSummaryTableViewCell"];
        gamesCell.rank = (int)indexPath.row + 1;
        cell = gamesCell;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpellLayout &layout = SpellLayout::instance();
    return 50 * layout.layout_scale();
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
