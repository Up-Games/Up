//
//  UPSpellExtrasPaneStats.mm
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

static NSDictionary *g_gamesHeaderStringAttributes;
static NSDictionary *g_gamesCellLeftAlignedStringAttributes;
static NSDictionary *g_gamesCellCenterAlignedStringAttributes;
static NSDictionary *g_gamesCellRightAlignedStringAttributes;
static CGRect g_gamesColumnRankRect;
static CGRect g_gamesColumnGameScoreRect;
static CGRect g_gamesColumnGameScoreTextRect;
static CGRect g_gamesColumnWordsSpelledRect;
static CGRect g_gamesColumnWordsSpelledTextRect;
static CGRect g_gamesColumnWordScoreAverageRect;
static CGRect g_gamesColumnWordScoreAverageTextRect;
static CGRect g_gamesColumnWordLengthAverageRect;
static CGRect g_gamesColumnWordLengthAverageTextRect;
static CGFloat g_gamesCellVerticalCenterY;

// =========================================================================================================================================

@interface UPGameSummaryTableViewHeaderView : UIView
@property (nonatomic) CGRect gameScoreRect;
@property (nonatomic) CGRect wordsSpelledRect;
@property (nonatomic) CGRect wordScoreAverageRect;
@property (nonatomic) CGRect wordLengthAverageRect;
@property (nonatomic) NSDictionary *stringAttributes;
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

    SpellLayout &layout = SpellLayout::instance();

    CGFloat cellHeight = 72 * layout.layout_scale();
    CGFloat cellX = 0;

    CGFloat rankWidth = SpellLayout::CanonicalExtrasGamesRankColumnWidth * layout.layout_scale();
    cellX += rankWidth;

    CGFloat gameScoreWidth = SpellLayout::CanonicalExtrasGamesGameScoreColumnWidth * layout.layout_scale();
    self.gameScoreRect = CGRectMake(cellX, 0, gameScoreWidth, cellHeight);
    cellX += gameScoreWidth;

    CGFloat wordsSpelledWidth = SpellLayout::CanonicalExtrasGamesWordsSpelledColumnWidth * layout.layout_scale();
    self.wordsSpelledRect = CGRectMake(cellX, 0, wordsSpelledWidth, cellHeight);
    cellX += wordsSpelledWidth;

    CGFloat wordScoreAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordScoreColumnWidth * layout.layout_scale();
    self.wordScoreAverageRect = CGRectMake(cellX, 0, wordScoreAverageWidth, cellHeight);
    cellX += wordScoreAverageWidth;

    CGFloat wordLengthAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordLengthColumnWidth * layout.layout_scale();
    self.wordLengthAverageRect = CGRectMake(cellX, 0, wordLengthAverageWidth, cellHeight);

    [self updateThemeColors];
    
    return self;
}

- (void)layoutSubviews
{
    SpellLayout &layout = SpellLayout::instance();
    CGFloat pixel = 1.0 / layout.screen_scale();
    CGRect bounds = self.bounds;
    self.divider.frame = CGRectMake(0, up_rect_height(bounds) - pixel, up_rect_width(bounds), pixel);
}

- (void)updateThemeColors
{
    [self.divider updateThemeColors];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.paragraphSpacing = -5;
    
    self.stringAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: [UIFont choiceControlFontOfSize:21]
    };

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSString *gameScoreString = @"GAME\nSCORE";
    [gameScoreString drawInRect:g_gamesColumnGameScoreRect withAttributes:g_gamesHeaderStringAttributes];
    
    NSString *wordsSpelledString = @"WORDS\nSPELLED";
    [wordsSpelledString drawInRect:g_gamesColumnWordsSpelledRect withAttributes:g_gamesHeaderStringAttributes];
    
    NSString *wordScoreAverageString = @"AVG WORD\nSCORE";
    [wordScoreAverageString drawInRect:g_gamesColumnWordScoreAverageRect withAttributes:g_gamesHeaderStringAttributes];
    
    NSString *wordLengthAverageString = @"AVG WORD\nLENGTH";
    [wordLengthAverageString drawInRect:g_gamesColumnWordLengthAverageRect withAttributes:g_gamesHeaderStringAttributes];
}

@end

// =========================================================================================================================================

@interface UPTableColumnSelectionView : UIView
@property (nonatomic) CGFloat selectionX;
@property (nonatomic) CGFloat selectionWidth;
@property (nonatomic) UIView *selectionView;
@property (nonatomic) UPColorCategory selectionColorCategory;
@end

@implementation UPTableColumnSelectionView

+ (UPTableColumnSelectionView *)tableColumnSelectionView
{
    return [[self alloc] _init];
}

- (instancetype)_init
{
    self = [super initWithFrame:CGRectZero];
    self.selectionView = [[UIView alloc] initWithFrame:CGRectZero];
    self.opaque = NO;
    self.selectionView.opaque = NO;
    [self addSubview:self.selectionView];
    [self updateThemeColors];
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGRect selectionFrame = CGRectMake(self.selectionX, 0, self.selectionWidth, up_rect_height(bounds));
    selectionFrame = CGRectInset(selectionFrame, 6, 0);
    self.selectionView.frame = selectionFrame;
}

#pragma mark - Update theme colors

- (void)setSelectionColorCategory:(UPColorCategory)selectionColorCategory
{
    _selectionColorCategory = selectionColorCategory;
    [self updateThemeColors];
}

- (void)updateThemeColors
{
    self.selectionView.backgroundColor = [UIColor themeColorWithCategory:self.selectionColorCategory];
}

@end

// =========================================================================================================================================

@interface UPGameSummaryTableViewCell : UITableViewCell
{
    SpellGameSummary m_spell_game_summary;
}
@property (nonatomic) NSString *message;
@property (nonatomic) UPDivider *divider;
@property (nonatomic) UPLabel *messageLabel;
@property (nonatomic) int rank;
@end

@implementation UPGameSummaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];

    self.messageLabel = [UPLabel label];
    self.messageLabel.textColorCategory = UPColorCategoryInformation;
    self.messageLabel.font = [UIFont choiceControlFontOfSize:20];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;

    self.divider = [UPDivider divider];
    self.divider.colorCategory = UPColorCategoryInformation;
    [self addSubview:self.divider];

    return self;
}

- (void)setGameSummary:(const SpellGameSummary &)spell_game_summary
{
    m_spell_game_summary = spell_game_summary;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    if (_message) {
        self.messageLabel.string = _message;
        [self addSubview:self.messageLabel];
        [self setNeedsLayout];
    }
    else {
        [self.messageLabel removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    SpellLayout &layout = SpellLayout::instance();
    CGFloat pixel = 1.0 / layout.screen_scale();
    CGRect bounds = self.bounds;
    self.divider.frame = CGRectMake(0, up_rect_height(bounds) - pixel, up_rect_width(bounds), pixel);

    if (self.message) {
        CGRect bounds = CGRectInset(self.bounds, 0, 3);
        CGSize messageSize = [self.messageLabel.attributedString size];
        messageSize.width = up_rect_width(bounds);
        UPLayoutRule *layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:bounds hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalBottom];
        self.messageLabel.frame = [layoutRule layoutFrameForBoundsSize:messageSize];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.message) {
        return;
    }
    
    BOOL isEmpty = m_spell_game_summary.is_empty();
    
    NSString *rankString = [NSString stringWithFormat:@"#%d", self.rank];
    [rankString drawInRect:CGRectOffset(g_gamesColumnRankRect, 0, g_gamesCellVerticalCenterY)
            withAttributes:g_gamesCellRightAlignedStringAttributes];

    NSString *gameScoreString = isEmpty ? @"–" : [NSString stringWithFormat:@"%d", m_spell_game_summary.game_score()];
    [gameScoreString drawInRect:CGRectOffset(g_gamesColumnGameScoreTextRect, 0, g_gamesCellVerticalCenterY)
                 withAttributes:isEmpty ? g_gamesCellCenterAlignedStringAttributes : g_gamesCellRightAlignedStringAttributes];

    NSString *wordsSpelledString = isEmpty ? @"–" : [NSString stringWithFormat:@"%d", m_spell_game_summary.words_submitted_count()];
    [wordsSpelledString drawInRect:CGRectOffset(g_gamesColumnWordsSpelledTextRect, 0, g_gamesCellVerticalCenterY)
                    withAttributes:isEmpty ? g_gamesCellCenterAlignedStringAttributes : g_gamesCellRightAlignedStringAttributes];

    NSString *wordScoreAverageString = isEmpty ? @"–" : [NSString stringWithFormat:@"%0.2f", m_spell_game_summary.word_score_average()];
    [wordScoreAverageString drawInRect:CGRectOffset(g_gamesColumnWordScoreAverageTextRect, 0, g_gamesCellVerticalCenterY)
                        withAttributes:isEmpty ? g_gamesCellCenterAlignedStringAttributes : g_gamesCellRightAlignedStringAttributes];

    NSString *wordLengthAverageString = isEmpty ? @"–" : [NSString stringWithFormat:@"%0.2f", m_spell_game_summary.word_length_average()];
    [wordLengthAverageString drawInRect:CGRectOffset(g_gamesColumnWordLengthAverageTextRect, 0, g_gamesCellVerticalCenterY)
                         withAttributes:isEmpty ? g_gamesCellCenterAlignedStringAttributes : g_gamesCellRightAlignedStringAttributes];
}

- (void)updateThemeColors
{
    [self.divider updateThemeColors];
    [self.messageLabel updateThemeColors];
}

@end

// =========================================================================================================================================

@interface UPSpellExtrasPaneStats () <UITableViewDataSource, UITableViewDelegate>
{
    std::vector<SpellGameSummary> m_best_games;
    SpellGameSummary m_most_recent_game;
}
@property (nonatomic) UPBallot *averagesTabRadioButton;
@property (nonatomic) UPBallot *gamesTabRadioButton;
@property (nonatomic) UPBallot *wordsTabRadioButton;
@property (nonatomic) NSArray<UPBallot *> *radioButtons;
@property (nonatomic) UILabel *noStatsLabel;
@property (nonatomic) UITableView *averagesTable;
@property (nonatomic) UPTableColumnSelectionView *gamesBackgroundView;
@property (nonatomic) UIView *gamesHeader;
@property (nonatomic) UITableView *gamesTable;
@property (nonatomic) UITableView *wordsTable;
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
    
//    self.gamesBackgroundView = [UPTableColumnSelectionView tableColumnSelectionView];
//    self.gamesBackgroundView.selectionColorCategory = UPColorCategorySecondaryInactiveFill;
//    [self addSubview:self.gamesBackgroundView];

    self.gamesHeader = [[UPGameSummaryTableViewHeaderView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.gamesHeader];

    self.gamesTable = [[UITableView alloc] initWithFrame:CGRectZero];
    self.gamesTable.backgroundView = nil;
    self.gamesTable.backgroundColor = [UIColor clearColor];
    self.gamesTable.allowsSelection = NO;
    self.gamesTable.scrollEnabled = NO;
    self.gamesTable.dataSource = self;
    self.gamesTable.delegate = self;
//    self.gamesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.gamesTable.separatorColor = [UIColor themeColorWithCategory:UPColorCategoryCanonical];
    self.gamesTable.separatorInset = UIEdgeInsetsZero;
    self.gamesTable.sectionHeaderHeight = 0;
    [self.gamesTable registerClass:[UPGameSummaryTableViewCell class] forCellReuseIdentifier:@"UPGameSummaryTableViewCell"];
    [self addSubview:self.gamesTable];

    [self updateThemeColors];

    {
        CGFloat cellHeight = 54 * layout.layout_scale();
        CGSize cellTextSize = [@"0" sizeWithAttributes:g_gamesCellLeftAlignedStringAttributes];
        CGFloat cellX = 0;
        g_gamesCellVerticalCenterY = (cellHeight - cellTextSize.height) / 2;
        CGFloat rectHeight = 72 * layout.layout_scale();

        CGFloat rankWidth = SpellLayout::CanonicalExtrasGamesRankColumnWidth * layout.layout_scale();
        g_gamesColumnRankRect = CGRectMake(cellX, 0, rankWidth, rectHeight);
        cellX += rankWidth;
        
        CGFloat gameScoreWidth = SpellLayout::CanonicalExtrasGamesGameScoreColumnWidth * layout.layout_scale();
        g_gamesColumnGameScoreRect = CGRectMake(cellX, 0, gameScoreWidth, rectHeight);
        CGSize gameScoreSize = [@"0000" sizeWithAttributes:g_gamesCellRightAlignedStringAttributes];
        CGRect gameScoreTextRect = CGRectMake(0, 0, gameScoreSize.width, gameScoreSize.height);
        g_gamesColumnGameScoreTextRect = up_rect_centered_x_in_rect(gameScoreTextRect, g_gamesColumnGameScoreRect);
        cellX += gameScoreWidth;
        
        CGFloat wordsSpelledWidth = SpellLayout::CanonicalExtrasGamesWordsSpelledColumnWidth * layout.layout_scale();
        g_gamesColumnWordsSpelledRect = CGRectMake(cellX, 0, wordsSpelledWidth, rectHeight);
        CGSize wordsSpelledSize = [@"00" sizeWithAttributes:g_gamesCellRightAlignedStringAttributes];
        CGRect wordsSpelledTextRect = CGRectMake(0, 0, wordsSpelledSize.width, wordsSpelledSize.height);
        g_gamesColumnWordsSpelledTextRect = up_rect_centered_x_in_rect(wordsSpelledTextRect, g_gamesColumnWordsSpelledRect);
        cellX += wordsSpelledWidth;
        
        CGFloat wordScoreAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordScoreColumnWidth * layout.layout_scale();
        g_gamesColumnWordScoreAverageRect = CGRectMake(cellX, 0, wordScoreAverageWidth, rectHeight);
        CGSize wordScoreAverageSize = [@"00.00" sizeWithAttributes:g_gamesCellRightAlignedStringAttributes];
        CGRect wordScoreAverageTextRect = CGRectMake(0, 0, wordScoreAverageSize.width, wordScoreAverageSize.height);
        g_gamesColumnWordScoreAverageTextRect = up_rect_centered_x_in_rect(wordScoreAverageTextRect, g_gamesColumnWordScoreAverageRect);
        cellX += wordScoreAverageWidth;
        
        CGFloat wordLengthAverageWidth = SpellLayout::CanonicalExtrasGamesAverageWordLengthColumnWidth * layout.layout_scale();
        g_gamesColumnWordLengthAverageRect = CGRectMake(cellX, 0, wordLengthAverageWidth, rectHeight);
        CGSize wordLengthAverageSize = [@"00.00" sizeWithAttributes:g_gamesCellRightAlignedStringAttributes];
        CGRect wordLengthAverageTextRect = CGRectMake(0, 0, wordLengthAverageSize.width, wordLengthAverageSize.height);
        g_gamesColumnWordLengthAverageTextRect = up_rect_centered_x_in_rect(wordLengthAverageTextRect, g_gamesColumnWordLengthAverageRect);
    }

    self.gamesBackgroundView.selectionX = up_rect_min_x(g_gamesColumnWordLengthAverageRect);
    self.gamesBackgroundView.selectionWidth = up_rect_width(g_gamesColumnWordLengthAverageRect);


    return self;
}

- (void)tabRadioButtonTapped:(UPBallot *)sender
{
    NSUInteger statsSelectedTabIndex = sender.tag;
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.statsSelectedTabIndex = statsSelectedTabIndex;
    
    [self updateRadioButtons:statsSelectedTabIndex];
    [self setSelectedTab:statsSelectedTabIndex];
}

- (void)updateRadioButtons:(NSUInteger)statsSelectedTabIndex
{
    for (UPBallot *radioButton in self.radioButtons) {
        radioButton.selected = (radioButton.tag == statsSelectedTabIndex);
        [radioButton invalidate];
        [radioButton update];
    }
}

- (void)setSelectedTab:(NSUInteger)statsSelectedTabIndex
{
    switch (statsSelectedTabIndex) {
        default:
        case 0: {
            [self orderInAverages];
            [self orderOutGames];
            [self orderOutWords];
            break;
        }
        case 1: {
            [self orderOutAverages];
            [self orderInGames];
            [self orderOutWords];
            break;
        }
        case 2: {
            [self orderOutAverages];
            [self orderOutGames];
            [self orderInWords];
            break;
        }
    }
}

- (void)orderInAverages
{
}

- (void)orderOutAverages
{
}

- (void)orderInGames
{
    [self addSubview:self.gamesBackgroundView];
    [self addSubview:self.gamesHeader];
    [self addSubview:self.gamesTable];

    m_best_games = SpellModel::best_games(SpellGameSummary::Metric::GameScore, 20);
    m_most_recent_game = SpellModel::most_recent_game();
    
    [self.gamesTable reloadData];
    [self.gamesHeader setNeedsDisplay];
}

- (void)orderOutGames
{
    [self.gamesBackgroundView removeFromSuperview];
    [self.gamesHeader removeFromSuperview];
    [self.gamesTable removeFromSuperview];
}

- (void)orderInWords
{
}

- (void)orderOutWords
{
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    SpellLayout &layout = SpellLayout::instance();
    self.gamesHeader.frame = layout.frame_for(Role::ExtrasStatsHeader);
    self.gamesTable.frame = layout.frame_for(Role::ExtrasStatsTable);
    
    CGRect gamesBackgroundViewFrame = self.gamesHeader.frame;
    gamesBackgroundViewFrame.size.height += up_rect_height(self.gamesTable.frame);
    self.gamesBackgroundView.frame = gamesBackgroundViewFrame;
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    [self updateRadioButtons:settings.statsSelectedTabIndex];
    [self setSelectedTab:settings.statsSelectedTabIndex];
}

- (void)cancelAnimations
{
}

#pragma mark - UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.gamesTable) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSUInteger row = indexPath.row;
    
    if (tableView == self.gamesTable) {
        UPGameSummaryTableViewCell *gamesCell = [tableView dequeueReusableCellWithIdentifier:@"UPGameSummaryTableViewCell"];
        gamesCell.message = nil;
        if (row < 3) {
            if (row >= m_best_games.size()) {
                [gamesCell setGameSummary:SpellGameSummary()];
            }
            else {
                [gamesCell setGameSummary:m_best_games[row]];
            }
        }
        else if (row == 3) {
            gamesCell.message = @"MOST RECENT GAME";
        }
        else {
            [gamesCell setGameSummary:m_most_recent_game];
        }
        gamesCell.rank = (int)row + 1;
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
    if (indexPath.row == 3) {
        return 74 * layout.layout_scale();
    }
    else {
        return 54 * layout.layout_scale();
    }
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    NSMutableParagraphStyle *leftAlignedParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [leftAlignedParagraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSMutableParagraphStyle *centerAlignedParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    centerAlignedParagraphStyle.paragraphSpacing = -5;
    [centerAlignedParagraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *rightAlignedParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [rightAlignedParagraphStyle setAlignment:NSTextAlignmentRight];
    
    UIFont *gamesHeaderFont = [UIFont choiceControlFontOfSize:20];
    UIFont *gamesCellFont = [UIFont checkboxControlFontOfSize:27];
    
    g_gamesHeaderStringAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: centerAlignedParagraphStyle,
        NSFontAttributeName: gamesHeaderFont
    };
    
    g_gamesCellLeftAlignedStringAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: leftAlignedParagraphStyle,
        NSFontAttributeName: gamesCellFont
    };
    
    g_gamesCellCenterAlignedStringAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: centerAlignedParagraphStyle,
        NSFontAttributeName: gamesCellFont
    };
    
    g_gamesCellRightAlignedStringAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSParagraphStyleAttributeName: rightAlignedParagraphStyle,
        NSFontAttributeName: gamesCellFont
    };
    
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.gamesTable.backgroundView updateThemeColors];
//    self.gamesTable.separatorColor = [UIColor themeColorWithCategory:UPColorCategoryCanonical];
    [self.gamesHeader setNeedsDisplay];
    [self.gamesTable reloadData];
}

@end
