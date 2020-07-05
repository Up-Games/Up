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
    UPSpellExtrasPaneStatsCategoryBestGames,
    UPSpellExtrasPaneStatsCategoryBestWords,
};

@interface UPGameSummaryTableViewCell : UITableViewCell
{
    SpellGameSummary m_spell_game_summary;
}
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

@end

@interface UPSpellExtrasPaneStats () <UITableViewDataSource, UITableViewDelegate>
{
    std::vector<SpellGameSummary> m_best_games;
}
@property (nonatomic, readwrite) UPBallot *averagesTabRadioButton;
@property (nonatomic, readwrite) UPBallot *bestGamesTabRadioButton;
@property (nonatomic, readwrite) UPBallot *bestWordsTabRadioButton;
@property (nonatomic) NSArray<UPBallot *> *radioButtons;
@property (nonatomic, readwrite) UILabel *noStatsLabel;
@property (nonatomic, readwrite) UITableView *bestGamesTable;
@end


@implementation UPSpellExtrasPaneStats

+ (UPSpellExtrasPaneStats *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

//    SpellLayout &layout = SpellLayout::instance();

    self.averagesTabRadioButton = [UPBallot ballotWithType:UPBallotTypeRadio];
    self.averagesTabRadioButton.labelString = @"AVERAGES";
    self.averagesTabRadioButton.tag = 0;
    [self.averagesTabRadioButton setTarget:self action:@selector(radioButtonTapped:)];
//    self.averagesTabRadioButton.frame = layout.frame_for(Role::ExtrasColorsDarkMode);
    self.averagesTabRadioButton.frame = CGRectMake(380, 334, 40 * 0.785, 36 * 0.785);
    [self addSubview:self.averagesTabRadioButton];

    self.bestGamesTabRadioButton = [UPBallot ballotWithType:UPBallotTypeRadio];
    self.bestGamesTabRadioButton.labelString = @"GAMES";
    self.bestGamesTabRadioButton.tag = 1;
    [self.bestGamesTabRadioButton setTarget:self action:@selector(radioButtonTapped:)];
    //    self.bestGamesTabRadioButton.frame = layout.frame_for(Role::ExtrasColorsDarkMode);
    self.bestGamesTabRadioButton.frame = CGRectMake(558, 334, 40 * 0.785, 36 * 0.785);
    [self addSubview:self.bestGamesTabRadioButton];
    
    self.bestWordsTabRadioButton = [UPBallot ballotWithType:UPBallotTypeRadio];
    self.bestWordsTabRadioButton.labelString = @"WORDS";
    self.bestWordsTabRadioButton.tag = 2;
    [self.bestWordsTabRadioButton setTarget:self action:@selector(radioButtonTapped:)];
    //    self.bestWordsTabRadioButton.frame = layout.frame_for(Role::ExtrasColorsDarkMode);
    self.bestWordsTabRadioButton.frame = CGRectMake(700, 334, 40 * 0.785, 36 * 0.785);
    [self addSubview:self.bestWordsTabRadioButton];
    
    self.radioButtons = @[ self.averagesTabRadioButton, self.bestGamesTabRadioButton, self.bestWordsTabRadioButton ];
    
    self.bestGamesTable = [[UITableView alloc] initWithFrame:CGRectZero];
    self.bestGamesTable.dataSource = self;
    self.bestGamesTable.delegate = self;

    
    
    [self.bestGamesTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Stats"];

    return self;
}

- (void)radioButtonTapped:(UPBallot *)sender
{
    for (UPBallot *radioButton in self.radioButtons) {
        if (radioButton != sender) {
            radioButton.selected = NO;
            [radioButton invalidate];
            [radioButton update];
        }
    }
    
//    NSUInteger extrasSelectedIndex = sender.tag;
//    [self setSelectedPane:self.panes[extrasSelectedIndex] duration:0.65];
//
//    UPSpellSettings *settings = [UPSpellSettings instance];
//    settings.extrasSelectedIndex = extrasSelectedIndex;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    
//    SpellLayout &layout = SpellLayout::instance();
//    self.hueDescription.frame = layout.frame_for(Role::ExtrasColorsDescription);
//    self.exampleTilesContainer.center = layout.center_for(Role::ExtrasColorsExample);
//    self.iconPrompt.frame = layout.frame_for(Role::ExtrasColorsIconPrompt, Spot::OffBottomFar);
//    self.iconButtonNope.frame = layout.frame_for(Role::ExtrasColorsIconButtonNope, Spot::OffBottomFar);
//    self.iconButtonYep.frame = layout.frame_for(Role::ExtrasColorsIconButtonYep, Spot::OffBottomFar);
}

- (void)cancelAnimations
{
}

#pragma mark - UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.bestGamesTable) {
        return m_best_games.size();
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.bestGamesTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Stats"];
//        NSString *key = self.colorKeys[indexPath.row];
//        if (self.selectedChip && [self.selectedChip.name isEqualToString:key]) {
//            cell.colorChip = self.selectedChip;
//        }
//        else {
//            cell.colorChip = self.colorChips[key];
//        }
    }

    return cell;
}

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)column row:(int)row
//{
//    return nil;
//}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
