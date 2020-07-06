//
//  UPSpellExtrasPaneStats.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPDivider.h>
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
using UP::SpellGameSummary;
using UP::SpellLayout;
using UP::SpellModel;
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

@interface UPGameSummaryTableViewHeaderView : UIView
@property (nonatomic) UPDivider *divider;
@end

@implementation UPGameSummaryTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];

    self.divider = [UPDivider divider];
    self.divider.colorCategory = UPColorCategoryInformation;
    [self addSubview:self.divider];
    
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.divider.frame = CGRectMake(0, up_rect_height(bounds) - 1, up_rect_width(bounds), 1);
}

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

- (void)drawRect:(CGRect)rect
{
    SpellLayout &layout = SpellLayout::instance();
    
    UIFont *font = [UIFont choiceControlFontOfSize:21];
    
    NSMutableParagraphStyle *centerAlignedParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    centerAlignedParagraphStyle.alignment = NSTextAlignmentCenter;
    centerAlignedParagraphStyle.paragraphSpacing = -5;
    
    NSDictionary *centerAlignedGameSummaryAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: centerAlignedParagraphStyle,
        NSFontAttributeName: font
    };
    
    CGFloat cellHeight = 72 * layout.layout_scale();
    CGFloat cellX = 0;
    CGFloat cellY = 0;
    
    CGFloat rankWidth = SpellLayout::CanonicalExtrasGamesRankColumnWidth * layout.layout_scale();
    cellX += rankWidth;
    
    CGFloat gameScoreWidth = SpellLayout::CanonicalExtrasGamesGameScoreColumnWidth * layout.layout_scale();
    CGRect gameScoreRect = CGRectMake(cellX, cellY, gameScoreWidth, cellHeight);
    NSString *gameScoreString = @"HIGH\nSCORES";
    [gameScoreString drawInRect:gameScoreRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += gameScoreWidth;
    
    CGFloat wordsSpelledWidth = SpellLayout::CanonicalExtrasGamesWordsSpelledColumnWidth * layout.layout_scale();
    CGRect wordsSpelledRect = CGRectMake(cellX, cellY, wordsSpelledWidth, cellHeight);
    NSString *wordsSpelledString = @"WORDS\nSPELLED";
    [wordsSpelledString drawInRect:wordsSpelledRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += wordsSpelledWidth;
    
    CGFloat wordScoreAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordScoreColumnWidth * layout.layout_scale();
    CGRect wordScoreAverageRect = CGRectMake(cellX, cellY, wordScoreAverageWidth, cellHeight);
    NSString *wordScoreAverageString = @"AVG WORD\nSCORE";
    [wordScoreAverageString drawInRect:wordScoreAverageRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += wordScoreAverageWidth;
    
    CGFloat wordLengthAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordLengthColumnWidth * layout.layout_scale();
    CGRect wordLengthAverageRect = CGRectMake(cellX, cellY, wordLengthAverageWidth, cellHeight);
    NSString *wordLengthAverageString = @"AVG WORD\nLENGTH";
    [wordLengthAverageString drawInRect:wordLengthAverageRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += wordLengthAverageWidth;
}

@end

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
    self.backgroundColor = [UIColor clearColor];

    return self;
}

- (void)setGameSummary:(const SpellGameSummary &)spell_game_summary
{
    m_spell_game_summary = spell_game_summary;
}

- (void)drawRect:(CGRect)rect
{
    SpellLayout &layout = SpellLayout::instance();

    UIFont *font = [UIFont checkboxControlFontOfSize:27];

    NSDictionary *leftAlignedAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSFontAttributeName: font
    };

    NSMutableParagraphStyle *centerAlignedParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [centerAlignedParagraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *centerAlignedGameSummaryAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: centerAlignedParagraphStyle,
        NSFontAttributeName: font
    };

    NSMutableParagraphStyle *rightAlignedParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [rightAlignedParagraphStyle setAlignment:NSTextAlignmentRight];

    NSDictionary *rightAlignedGameSummaryAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: rightAlignedParagraphStyle,
        NSFontAttributeName: font
    };

    CGFloat cellHeight = 57 * layout.layout_scale();
    CGSize cellTextSize = [@"0" sizeWithAttributes:leftAlignedAttributes];
    CGFloat cellX = 0;
    CGFloat cellY = (cellHeight - cellTextSize.height) / 2;

    CGFloat rankWidth = SpellLayout::CanonicalExtrasGamesRankColumnWidth * layout.layout_scale();
    CGRect rankRect = CGRectMake(cellX, cellY, rankWidth, cellHeight);
    NSString *rankString = [NSString stringWithFormat:@"#%d", self.rank];
    [rankString drawInRect:rankRect withAttributes:leftAlignedAttributes];
    cellX += rankWidth;

    CGFloat gameScoreWidth = SpellLayout::CanonicalExtrasGamesGameScoreColumnWidth * layout.layout_scale();
    CGRect gameScoreRect = CGRectMake(cellX, cellY, gameScoreWidth, cellHeight);
    NSString *gameScoreString = [NSString stringWithFormat:@"%d", m_spell_game_summary.game_score()];
    [gameScoreString drawInRect:gameScoreRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += gameScoreWidth;

    CGFloat wordsSpelledWidth = SpellLayout::CanonicalExtrasGamesWordsSpelledColumnWidth * layout.layout_scale();
    CGRect wordsSpelledRect = CGRectMake(cellX, cellY, wordsSpelledWidth, cellHeight);
    NSString *wordsSpelledString = [NSString stringWithFormat:@"%d", m_spell_game_summary.words_submitted_count()];
    [wordsSpelledString drawInRect:wordsSpelledRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += wordsSpelledWidth;

    CGFloat wordScoreAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordScoreColumnWidth * layout.layout_scale();
    CGRect wordScoreAverageRect = CGRectMake(cellX, cellY, wordScoreAverageWidth, cellHeight);
    NSString *wordScoreAverageString = [NSString stringWithFormat:@"%0.2f", m_spell_game_summary.word_score_average()];
    [wordScoreAverageString drawInRect:wordScoreAverageRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += wordScoreAverageWidth;

    CGFloat wordLengthAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordLengthColumnWidth * layout.layout_scale();
    CGRect wordLengthAverageColumnRect = CGRectMake(cellX, 0, wordScoreAverageWidth, cellHeight);
    CGSize wordLengthAverageSize = [@"00.00" sizeWithAttributes:rightAlignedGameSummaryAttributes];
    CGRect wordLengthAverageAlignmentRect = CGRectMake(0, cellY, wordLengthAverageSize.width, wordLengthAverageSize.height);
    CGRect wordLengthAverageRect = up_rect_centered_x_in_rect(wordLengthAverageAlignmentRect, wordLengthAverageColumnRect);
    NSString *wordLengthAverageString = [NSString stringWithFormat:@"%0.2f", m_spell_game_summary.word_length_average()];
    [wordLengthAverageString drawInRect:wordLengthAverageRect withAttributes:centerAlignedGameSummaryAttributes];
    cellX += wordLengthAverageWidth;
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
@property (nonatomic, readwrite) UIView *gamesHeader;
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
    
    self.gamesHeader = [[UPGameSummaryTableViewHeaderView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.gamesHeader];

    self.gamesTable = [[UITableView alloc] initWithFrame:CGRectZero];
    self.gamesTable.backgroundColor = [UIColor clearColor];
    self.gamesTable.backgroundView = nil;
    self.gamesTable.dataSource = self;
    self.gamesTable.delegate = self;
    self.gamesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.gamesTable.separatorColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    self.gamesTable.separatorInset = UIEdgeInsetsZero;
    self.gamesTable.sectionHeaderHeight = 0;
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
    self.gamesHeader.frame = layout.frame_for(Role::ExtrasStatsHeader);
    self.gamesTable.frame = layout.frame_for(Role::ExtrasStatsTable);

    m_best_games = SpellModel::best_games(SpellGameSummary::Metric::GameScore, 20);
    [self.gamesTable reloadData];
    [self.gamesHeader setNeedsDisplay];
}

- (void)cancelAnimations
{
}

#pragma mark - UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.gamesTable) {
        return m_best_games.size();
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSUInteger row = indexPath.row;
    
    if (tableView == self.gamesTable) {
        UPGameSummaryTableViewCell *gamesCell = [tableView dequeueReusableCellWithIdentifier:@"UPGameSummaryTableViewCell"];
        gamesCell.rank = (int)row + 1;
        [gamesCell setGameSummary:m_best_games[row]];
        cell = gamesCell;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpellLayout &layout = SpellLayout::instance();
    return 57 * layout.layout_scale();
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
