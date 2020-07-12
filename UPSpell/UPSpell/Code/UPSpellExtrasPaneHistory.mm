//
//  UPSpellExtrasPaneHistory.mm
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
#import "UPSpellExtrasPaneHistory.h"
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

using UP::ns_str;

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
static CGRect g_gamesColumnChevronRect;
static CGRect g_gamesColumnGameScoreRect;
static CGRect g_gamesColumnGameScoreTextRect;
static CGRect g_gamesColumnGameIDRect;
static CGRect g_gamesColumnGameIDTextRect;
static CGRect g_gamesColumnGameKeyRect;
static CGRect g_gamesColumnGameKeyTextRect;
static CGFloat g_gamesCellVerticalCenterY;

static UIBezierPath *ChevronPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(43, 21.8)];
    [path addCurveToPoint: CGPointMake(40.09, 24.71) controlPoint1: CGPointMake(42.03, 22.77) controlPoint2: CGPointMake(41.05, 23.74)];
    [path addCurveToPoint: CGPointMake(36.29, 28.63) controlPoint1: CGPointMake(38.8, 26) controlPoint2: CGPointMake(37.51, 27.28)];
    [path addCurveToPoint: CGPointMake(35.24, 29.87) controlPoint1: CGPointMake(35.92, 29.03) controlPoint2: CGPointMake(35.57, 29.44)];
    [path addCurveToPoint: CGPointMake(34.7, 30.74) controlPoint1: CGPointMake(35.03, 30.15) controlPoint2: CGPointMake(34.84, 30.43)];
    [path addCurveToPoint: CGPointMake(34.7, 31.5) controlPoint1: CGPointMake(34.58, 31.02) controlPoint2: CGPointMake(34.56, 31.28)];
    [path addCurveToPoint: CGPointMake(34.91, 31.77) controlPoint1: CGPointMake(34.76, 31.6) controlPoint2: CGPointMake(34.83, 31.69)];
    [path addCurveToPoint: CGPointMake(35.47, 32.33) controlPoint1: CGPointMake(35.09, 31.96) controlPoint2: CGPointMake(35.28, 32.15)];
    [path addCurveToPoint: CGPointMake(35.72, 32.59) controlPoint1: CGPointMake(35.55, 32.42) controlPoint2: CGPointMake(35.64, 32.5)];
    [path addCurveToPoint: CGPointMake(35.76, 32.62) controlPoint1: CGPointMake(35.74, 32.6) controlPoint2: CGPointMake(35.75, 32.61)];
    [path addCurveToPoint: CGPointMake(36.03, 32.89) controlPoint1: CGPointMake(35.85, 32.71) controlPoint2: CGPointMake(35.94, 32.8)];
    [path addCurveToPoint: CGPointMake(36.3, 33.11) controlPoint1: CGPointMake(36.11, 32.97) controlPoint2: CGPointMake(36.21, 33.04)];
    [path addCurveToPoint: CGPointMake(37.07, 33.1) controlPoint1: CGPointMake(36.52, 33.25) controlPoint2: CGPointMake(36.78, 33.22)];
    [path addCurveToPoint: CGPointMake(37.93, 32.56) controlPoint1: CGPointMake(37.38, 32.96) controlPoint2: CGPointMake(37.66, 32.77)];
    [path addCurveToPoint: CGPointMake(39.18, 31.51) controlPoint1: CGPointMake(38.36, 32.24) controlPoint2: CGPointMake(38.77, 31.88)];
    [path addCurveToPoint: CGPointMake(43.09, 27.72) controlPoint1: CGPointMake(40.52, 30.29) controlPoint2: CGPointMake(41.81, 29)];
    [path addCurveToPoint: CGPointMake(46, 24.81) controlPoint1: CGPointMake(44.06, 26.75) controlPoint2: CGPointMake(45.03, 25.78)];
    [path addCurveToPoint: CGPointMake(48.91, 27.72) controlPoint1: CGPointMake(46.97, 25.78) controlPoint2: CGPointMake(47.94, 26.75)];
    [path addCurveToPoint: CGPointMake(52.83, 31.51) controlPoint1: CGPointMake(50.19, 29) controlPoint2: CGPointMake(51.48, 30.29)];
    [path addCurveToPoint: CGPointMake(54.07, 32.56) controlPoint1: CGPointMake(53.23, 31.88) controlPoint2: CGPointMake(53.64, 32.24)];
    [path addCurveToPoint: CGPointMake(54.93, 33.1) controlPoint1: CGPointMake(54.34, 32.77) controlPoint2: CGPointMake(54.62, 32.96)];
    [path addCurveToPoint: CGPointMake(55.7, 33.11) controlPoint1: CGPointMake(55.22, 33.22) controlPoint2: CGPointMake(55.48, 33.25)];
    [path addCurveToPoint: CGPointMake(55.97, 32.89) controlPoint1: CGPointMake(55.79, 33.04) controlPoint2: CGPointMake(55.89, 32.97)];
    [path addCurveToPoint: CGPointMake(56.53, 32.34) controlPoint1: CGPointMake(56.16, 32.71) controlPoint2: CGPointMake(56.34, 32.52)];
    [path addCurveToPoint: CGPointMake(56.79, 32.08) controlPoint1: CGPointMake(56.62, 32.25) controlPoint2: CGPointMake(56.7, 32.16)];
    [path addCurveToPoint: CGPointMake(56.82, 32.04) controlPoint1: CGPointMake(56.8, 32.07) controlPoint2: CGPointMake(56.81, 32.05)];
    [path addCurveToPoint: CGPointMake(57.09, 31.77) controlPoint1: CGPointMake(56.91, 31.95) controlPoint2: CGPointMake(57, 31.86)];
    [path addCurveToPoint: CGPointMake(57.31, 31.5) controlPoint1: CGPointMake(57.17, 31.69) controlPoint2: CGPointMake(57.24, 31.6)];
    [path addCurveToPoint: CGPointMake(57.3, 30.74) controlPoint1: CGPointMake(57.45, 31.28) controlPoint2: CGPointMake(57.42, 31.02)];
    [path addCurveToPoint: CGPointMake(56.76, 29.87) controlPoint1: CGPointMake(57.16, 30.43) controlPoint2: CGPointMake(56.97, 30.15)];
    [path addCurveToPoint: CGPointMake(55.71, 28.63) controlPoint1: CGPointMake(56.43, 29.44) controlPoint2: CGPointMake(56.08, 29.03)];
    [path addCurveToPoint: CGPointMake(51.92, 24.71) controlPoint1: CGPointMake(54.49, 27.28) controlPoint2: CGPointMake(53.2, 26)];
    [path addCurveToPoint: CGPointMake(49.01, 21.8) controlPoint1: CGPointMake(50.95, 23.74) controlPoint2: CGPointMake(49.97, 22.77)];
    [path addCurveToPoint: CGPointMake(46, 18.8) controlPoint1: CGPointMake(48, 20.8) controlPoint2: CGPointMake(47, 19.8)];
    [path addCurveToPoint: CGPointMake(43, 21.8) controlPoint1: CGPointMake(45, 19.8) controlPoint2: CGPointMake(44, 20.8)];
    [path closePath];
    return path;
}

// =========================================================================================================================================

@interface UPGameSummaryTableViewHeaderView : UIView
@property (nonatomic) CGRect gameScoreRect;
@property (nonatomic) CGRect gameIDRect;
@property (nonatomic) CGRect gameKeyRect;
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

    CGFloat cellHeight = 36 * layout.layout_scale();
    CGFloat cellX = 0;

    CGFloat gameScoreWidth = SpellLayout::CanonicalExtrasHistoryGameScoreColumnWidth * layout.layout_scale();
    self.gameScoreRect = CGRectMake(cellX, 0, gameScoreWidth, cellHeight);
    cellX += gameScoreWidth;

    CGFloat gameIDWidth = SpellLayout::CanonicalExtrasHistoryGameIDColumnWidth * layout.layout_scale();
    self.gameIDRect = CGRectMake(cellX, 0, gameIDWidth, cellHeight);
    cellX += gameIDWidth;

    CGFloat gameKeyWidth = SpellLayout::CanonicalExtrasHistoryGameKeyColumnWidth * layout.layout_scale();
    self.gameKeyRect = CGRectMake(cellX, 0, gameKeyWidth, cellHeight);
    cellX += gameKeyWidth;

    CGFloat chevronWidth = SpellLayout::CanonicalExtrasHistoryChevronColumnWidth * layout.layout_scale();
    cellX += chevronWidth;
    
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
    
    self.stringAttributes = @{
        NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryInformation],
        NSFontAttributeName: [UIFont choiceControlFontOfSize:21]
    };

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSString *gameScoreString = @"SCORE";
    [gameScoreString drawInRect:g_gamesColumnGameScoreRect withAttributes:g_gamesHeaderStringAttributes];
    
    NSString *wordsSpelledString = @"GAME #";
    [wordsSpelledString drawInRect:g_gamesColumnGameIDRect withAttributes:g_gamesHeaderStringAttributes];
    
    NSString *wordScoreAverageString = @"GAMEKEY";
    [wordScoreAverageString drawInRect:g_gamesColumnGameKeyRect withAttributes:g_gamesHeaderStringAttributes];
    
    NSString *wordLengthAverageString = @"OBSESS";
    [wordLengthAverageString drawInRect:g_gamesColumnChevronRect withAttributes:g_gamesHeaderStringAttributes];
}

@end

// =========================================================================================================================================

@interface UPGameSummaryTableViewCell : UITableViewCell
{
    SpellGameSummary m_spell_game_summary;
}
@property (nonatomic) NSString *message;
@property (nonatomic) UPDivider *divider;
@end

@implementation UPGameSummaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];

    self.divider = [UPDivider divider];
    self.divider.colorCategory = UPColorCategoryInformation;
    [self addSubview:self.divider];

    return self;
}

- (void)setGameSummary:(const SpellGameSummary &)spell_game_summary
{
    m_spell_game_summary = spell_game_summary;
}

- (void)layoutSubviews
{
    SpellLayout &layout = SpellLayout::instance();
    CGFloat pixel = 1.0 / layout.screen_scale();
    CGRect bounds = self.bounds;
    self.divider.frame = CGRectMake(0, up_rect_height(bounds) - pixel, up_rect_width(bounds), pixel);
}

- (void)drawRect:(CGRect)rect
{
    if (self.message) {
        return;
    }
    
    NSString *gameScoreString = [NSString stringWithFormat:@"%d", m_spell_game_summary.game_score()];
    [gameScoreString drawInRect:CGRectOffset(g_gamesColumnGameScoreTextRect, 0, g_gamesCellVerticalCenterY)
                 withAttributes:g_gamesCellRightAlignedStringAttributes];

    NSString *gameIDString = [NSString stringWithFormat:@"%05llu", m_spell_game_summary.game_id()];
    [gameIDString drawInRect:CGRectOffset(g_gamesColumnGameIDTextRect, 0, g_gamesCellVerticalCenterY)
                    withAttributes:g_gamesCellRightAlignedStringAttributes];

    NSString *gameKeyString = ns_str(m_spell_game_summary.game_key().string());
    [gameKeyString drawInRect:CGRectOffset(g_gamesColumnGameKeyTextRect, 0, g_gamesCellVerticalCenterY)
                        withAttributes:g_gamesCellRightAlignedStringAttributes];

//    NSString *chevronString = @"^";
//    [chevronString drawInRect:CGRectOffset(g_gamesColumnChevronRect, 0, g_gamesCellVerticalCenterY)
//            withAttributes:g_gamesCellCenterAlignedStringAttributes];

    static UIBezierPath *chevronPath = ChevronPath();

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPathRef path = chevronPath.CGPath;
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, up_rect_min_x(g_gamesColumnChevronRect), up_rect_min_y(g_gamesColumnChevronRect));
    CGContextSetFillColorWithColor(ctx, [UIColor themeColorWithCategory:UPColorCategoryInformation].CGColor);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}

- (void)updateThemeColors
{
    [self.divider updateThemeColors];
}

@end

// =========================================================================================================================================

@interface UPSpellExtrasPaneHistory () <UITableViewDataSource, UITableViewDelegate>
{
    std::vector<SpellGameSummary> m_games;
}
@property (nonatomic) UILabel *noStatsLabel;
@property (nonatomic) UIView *gamesHeader;
@property (nonatomic) UITableView *gamesTable;
@end


@implementation UPSpellExtrasPaneHistory

+ (UPSpellExtrasPaneHistory *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();
    
    self.gamesHeader = [[UPGameSummaryTableViewHeaderView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.gamesHeader];

    self.gamesTable = [[UITableView alloc] initWithFrame:CGRectZero];
    self.gamesTable.backgroundView = nil;
    self.gamesTable.backgroundColor = [UIColor clearColor];
    self.gamesTable.allowsSelection = NO;
    self.gamesTable.scrollEnabled = NO;
    self.gamesTable.dataSource = self;
    self.gamesTable.delegate = self;
    self.gamesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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

        CGFloat gameScoreWidth = SpellLayout::CanonicalExtrasHistoryGameScoreColumnWidth * layout.layout_scale();
        g_gamesColumnGameScoreRect = CGRectMake(cellX, 0, gameScoreWidth, rectHeight);
        CGSize gameScoreSize = [@"0000" sizeWithAttributes:g_gamesCellRightAlignedStringAttributes];
        CGRect gameScoreTextRect = CGRectMake(0, 0, gameScoreSize.width, gameScoreSize.height);
        g_gamesColumnGameScoreTextRect = up_rect_centered_x_in_rect(gameScoreTextRect, g_gamesColumnGameScoreRect);
        cellX += gameScoreWidth;
        
        CGFloat gameIDWidth = SpellLayout::CanonicalExtrasHistoryGameIDColumnWidth * layout.layout_scale();
        g_gamesColumnGameIDRect = CGRectMake(cellX, 0, gameIDWidth, rectHeight);
        CGSize gameIDSize = [@"00000" sizeWithAttributes:g_gamesCellRightAlignedStringAttributes];
        CGRect gameIDTextRect = CGRectMake(0, 0, gameIDSize.width, gameIDSize.height);
        g_gamesColumnGameIDTextRect = up_rect_centered_x_in_rect(gameIDTextRect, g_gamesColumnGameIDRect);
        cellX += gameIDWidth;
        
        CGFloat gameKeyWidth = SpellLayout::CanonicalExtrasHistoryGameKeyColumnWidth * layout.layout_scale();
        g_gamesColumnGameKeyRect = CGRectMake(cellX, 0, gameKeyWidth, rectHeight);
        CGSize gameKeySize = [@"MMM-0000" sizeWithAttributes:g_gamesCellRightAlignedStringAttributes];
        CGRect gameKeyTextRect = CGRectMake(0, 0, gameKeySize.width, gameKeySize.height);
        g_gamesColumnGameKeyTextRect = up_rect_centered_x_in_rect(gameKeyTextRect, g_gamesColumnGameKeyRect);
        cellX += gameKeyWidth;

        CGFloat chevronWidth = SpellLayout::CanonicalExtrasHistoryChevronColumnWidth * layout.layout_scale();
        g_gamesColumnChevronRect = CGRectMake(cellX, 0, chevronWidth, rectHeight);
        cellX += chevronWidth;
        
    }

    return self;
}

- (void)updateSelectedColumn:(NSUInteger)selectedColumnIndex
{
    
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    SpellLayout &layout = SpellLayout::instance();
    self.gamesHeader.frame = layout.frame_for(Role::ExtrasStatsHeader);
    self.gamesTable.frame = layout.frame_for(Role::ExtrasStatsTable);
        
    UPSpellSettings *settings = [UPSpellSettings instance];
    [self updateSelectedColumn:settings.historySelectedColumnTag];

    m_games = SpellModel::best_games(SpellGameSummary::Metric::GameScore, 20);
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
        return m_games.size();
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSUInteger row = indexPath.row;
    
    if (tableView == self.gamesTable) {
        UPGameSummaryTableViewCell *gamesCell = [tableView dequeueReusableCellWithIdentifier:@"UPGameSummaryTableViewCell"];
        [gamesCell setGameSummary:m_games[row]];
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
    return 54 * layout.layout_scale();
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
    [self.gamesHeader setNeedsDisplay];
    [self.gamesTable reloadData];
}

@end
