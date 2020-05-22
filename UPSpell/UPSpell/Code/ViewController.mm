//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <memory>

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSceneDelegate.h"
#import "UPSpellGameModel.h"
#import "UPSpellLayoutManager.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "ViewController.h"

using UP::GameCode;
using UP::Tile;
using UP::LetterSequence;
using UP::SpellGameModel;
using Action = UP::SpellGameModel::Action;
using Opcode = UP::SpellGameModel::Opcode;
using Position = UP::SpellGameModel::Position;

@interface ViewController () <UPGameTimerObserver, UPTileViewGestureDelegate>
@property (nonatomic) UIView *infinityView;
@property (nonatomic) UPControl *wordTrayView;
@property (nonatomic) UIView *tileFrameView;
@property (nonatomic) UPControl *roundControlButtonPause;
@property (nonatomic) UPControl *roundControlButtonTrash;
@property (nonatomic) UPControl *roundControlButtonClear;
@property (nonatomic) BOOL showingRoundControlButtonClear;
@property (nonatomic) UPGameTimer *gameTimer;
@property (nonatomic) UPGameTimerLabel *gameTimerLabel;
@property (nonatomic) UPLabel *scoreLabel;
@property (nonatomic) NSMutableArray *tileViews;
@property (nonatomic) NSMutableArray *wordTrayTileViews;
@property (nonatomic) NSMutableArray *playerTrayGhostTileViews;
@property (nonatomic) UIFont *gameplayInformationFont;
@property (nonatomic) UIFont *gameplayInformationSuperscriptFont;
@property (nonatomic) std::shared_ptr<SpellGameModel> model;
@end

@implementation ViewController

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);
    //LOG_CHANNEL_ON(LayoutManager);

    [super viewDidLoad];

    UP::Random::create_instance();
    UP::Lexicon::set_language(UPLexiconLanguageEnglish);

    GameCode game_code = GameCode::random();
////    GameCode code = GameCode("WPQ-2701");
    NSLog(@"code: %s", game_code.string().c_str());
    NSLog(@"code: %d", game_code.value());
//

    self.model = std::make_shared<SpellGameModel>(game_code);
    
    [UIColor setThemeStyle:UPColorStyleLight];
//    [UIColor setThemeHue:0];
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::create_instance();
    UP::TilePaths::create_instance();
    
    layout_manager.set_screen_bounds([[UIScreen mainScreen] bounds]);
    layout_manager.set_screen_scale([[UIScreen mainScreen] scale]);
    layout_manager.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout_manager.calculate();
    
    self.infinityView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infinityView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];
    [self.view addSubview:self.infinityView];
    
    self.roundControlButtonPause = [UPControl roundControlButtonPause];
    [self.roundControlButtonPause addTarget:self action:@selector(roundControlButtonPauseTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonPause];

    self.roundControlButtonTrash = [UPControl roundControlButtonTrash];
    [self.roundControlButtonTrash addTarget:self action:@selector(roundControlButtonTrashTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonTrash];

    self.roundControlButtonClear = [UPControl roundControlButtonClear];
    [self.roundControlButtonClear addTarget:self action:@selector(roundControlButtonClearTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonClear];

    self.wordTrayView = [UPControl wordTray];
    [self.wordTrayView addTarget:self action:@selector(wordTrayTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wordTrayView];

    UIFont *font = [UIFont gameplayInformationFontOfSize:layout_manager.gameplay_information_font_metrics().point_size()];
    UIFont *superscriptFont = [UIFont gameplayInformationFontOfSize:layout_manager.gameplay_information_superscript_font_metrics().point_size()];

    self.gameplayInformationFont = font;
    self.gameplayInformationSuperscriptFont = superscriptFont;

    self.gameTimerLabel = [UPGameTimerLabel label];
    self.gameTimerLabel.font = font;
    self.gameTimerLabel.superscriptFont = superscriptFont;
    self.gameTimerLabel.superscriptBaselineAdjustment = layout_manager.gameplay_information_superscript_font_metrics().baseline_adjustment();
    self.gameTimerLabel.superscriptKerning = layout_manager.gameplay_information_superscript_font_metrics().kerning();
    
    self.gameTimer = [UPGameTimer defaultGameTimer];
    [self.gameTimer addObserver:self.gameTimerLabel];
    [self.gameTimer notifyObservers];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gameTimer start];
    });

    self.gameTimerLabel.textColorCategory = UPColorCategoryInformation;
    self.gameTimerLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.gameTimerLabel];

    self.scoreLabel = [UPLabel label];
    self.scoreLabel.string = @"0";
    self.scoreLabel.font = font;
    self.scoreLabel.textColorCategory = UPColorCategoryInformation;
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.scoreLabel];

    self.tileViews = [NSMutableArray array];
    self.wordTrayTileViews = [NSMutableArray array];
    size_t idx = 0;

    for (const auto &tile : self.model->player_tray()) {
        UPTileView *tileView = [UPTileView viewWithTile:tile];
        tileView.gestureDelegate = self;
        tileView.position = UP::player_tray_position(idx);
        [self.view addSubview:tileView];
        [self.tileViews addObject:tileView];
        idx++;
    }

    const std::array<CGRect, SpellGameModel::TileCount> tile_frames = layout_manager.player_tray_tile_frames();
    for (UPTileView *tileView in self.tileViews) {
        tileView.frame = tile_frames.at(SpellGameModel::index(tileView.position));
    }
    
    self.roundControlButtonClear.alpha = 0;
    [self viewUpdateGameControls];
}

- (void)viewDidLayoutSubviews
{
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    self.infinityView.frame = self.view.bounds;
    self.wordTrayView.frame = layout_manager.word_tray_layout_frame();
    self.roundControlButtonPause.frame = layout_manager.controls_button_pause_frame();
    self.roundControlButtonTrash.frame = layout_manager.controls_button_trash_frame();
    self.roundControlButtonClear.frame = layout_manager.controls_button_trash_frame();
    self.gameTimerLabel.frame = layout_manager.game_time_label_frame();
    self.scoreLabel.frame = layout_manager.game_score_label_frame();
}

#pragma mark - Control target/action

- (void)roundControlButtonPauseTapped:(id)sender
{
}

- (void)roundControlButtonTrashTapped:(id)sender
{
    [self applyActionDump];
}

- (void)roundControlButtonClearTapped:(id)sender
{
    [self applyActionClear];
}

- (void)wordTrayTapped
{
    if (self.wordTrayView.active) {
        [self applyActionSubmit];
    }
    else if (self.model->word_length() == 0) {
        // Don't penalize. In the case it's a stray tap, let the player off the hook.
        // FIXME: beep
    }
    else {
        [self applyActionReject];
    }
}

#pragma mark - UPTileViewGestureDelegate

- (void)tileViewTapped:(UPTileView *)tileView
{
    if (tileView.tap.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    if (UP::is_marked(self.model->player_marked(), tileView.position)) {
        [self wordTrayTapped];
    }
    else {
        [self applyActionTap:tileView.position];
    }
}

- (void)tileViewPanned:(UPTileView *)tileView
{
}

#pragma mark - Actions

- (void)applyActionTap:(Position)pos
{
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::TAP, pos));

    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(self.model->word_length());
    
    size_t idx = 0;
    for (UPTileView *wordTrayTileView in self.wordTrayTileViews) {
        CGPoint word_tray_center = word_tray_tile_centers[idx];
        [wordTrayTileView bloopWithDuration:0.2 toPosition:word_tray_center completion:nil];
        idx++;
    }
    
    const size_t word_idx = self.model->word_length() - 1;
    CGPoint word_tray_center = word_tray_tile_centers[word_idx];
    UPTileView *tileView = self.tileViews[index(pos)];
    [tileView bloopWithDuration:0.4 toPosition:word_tray_center completion:nil];
    
    [self.wordTrayTileViews addObject:tileView];
    
    [self viewUpdateGameControls];
}

- (void)applyActionClear
{
    [self viewUpdateClearWordTray];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::CLEAR));
    [self viewUpdateGameControls];
}

- (void)applyActionSubmit
{
    [self viewUpdateScoreWord];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::SUBMIT));
    [self viewUpdateFillPlayerTray];
    [self viewUpdateGameControls];
}

- (void)applyActionReject
{
    

    CGPoint origin = self.wordTrayView.frame.origin;
    
    // shake word tray side-to-side and assess time penalty
    for (UPTileView *tileView in self.wordTrayTileViews) {
        CGRect frame = CGRectOffset(tileView.frame, -origin.x, -origin.y);
        [self.wordTrayView addSubview:tileView];
        tileView.frame = frame;
    }
 
    CGFloat amount = up_rect_width(self.wordTrayView.frame) * 0.04;
    [self.wordTrayView shakeWithDuration:0.7 amount:amount completion:nil];

    [UIView animateWithDuration:0.1 animations:^{
        [self viewUpdatePenaltyBlockControlsForReject];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                [self viewUpdatePenaltyUnblockControls];
            } completion:^(BOOL finished) {
                for (UPTileView *tileView in self.wordTrayTileViews) {
                    CGRect frame = CGRectOffset(tileView.frame, origin.x, origin.y);
                    [self.view addSubview:tileView];
                    tileView.frame = frame;
                }
            }];
        });
    }];
}

- (void)applyActionDump
{
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [UIView animateWithDuration:0.1 animations:^{
        [self viewUpdatePenaltyBlockControlsForDump];
    } completion:^(BOOL finished) {
        [self viewUpdateDumpPlayerTray];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self viewUpdatePenaltyUnblockControls];
            [self viewUpdateFillPlayerTray];
        });
    }];
}


#pragma mark - view updating

- (void)viewUpdateGameControls
{
    // word tray
    self.wordTrayView.active = self.model->word_in_lexicon();

    // trash/clear button
    if (self.model->word_length()) {
        if (!self.showingRoundControlButtonClear) {
            self.showingRoundControlButtonClear = YES;
            self.roundControlButtonClear.alpha = 1;
            self.roundControlButtonTrash.alpha = 0;
        }
    }
    else {
        if (self.showingRoundControlButtonClear) {
            self.showingRoundControlButtonClear = NO;
            self.roundControlButtonClear.alpha = 0;
            self.roundControlButtonTrash.alpha = 1;
        }
    }
    
    self.scoreLabel.string = [NSString stringWithFormat:@"%d", self.model->game_score()];
}

- (void)viewUpdateClearWordTray
{
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();
    size_t idx = 0;
    for (const auto &mark : self.model->player_marked()) {
        if (mark) {
            CGPoint player_tray_center = player_tray_tile_centers[idx];
            UPTileView *tileView = self.tileViews[idx];
            [tileView bloopWithDuration:0.4 toPosition:player_tray_center completion:^(BOOL finished) {
            }];
        }
        idx++;
    }
    [self.wordTrayTileViews removeAllObjects];
}

- (void)viewUpdateScoreWord
{
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    size_t idx = 0;
    for (const auto &mark : self.model->player_marked()) {
        if (mark) {
            UPTileView *tileView = self.tileViews[idx];
            tileView.userInteractionEnabled = NO;
            CGRect frame = tileView.frame;
            CGPoint center = up_rect_center(frame);
            center.y -= up_size_height(layout_manager.tile_size()) * 0.8;
            self.tileViews[idx] = [UPTileView viewWithSentinel];
            [tileView fadeWithDuration:0.2 completion:nil];
            [tileView bloopWithDuration:0.3 toPosition:center completion:^(BOOL finished) {
                [tileView removeFromSuperview];
            }];
        }
        idx++;
    }
    [self.wordTrayTileViews removeAllObjects];
}

- (void)viewUpdateDumpPlayerTray
{
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    UP::Random &random = UP::Random::instance();
    const auto &offscreen_tray_tile_centers = layout_manager.offscreen_tray_tile_centers();
    
    std::array<size_t, UP::SpellGameModel::TileCount> idxs;
    for (size_t idx = 0; idx < UP::SpellGameModel::TileCount; idx++) {
        idxs[idx] = idx;
    }
    std::shuffle(idxs.begin(), idxs.end(), random.generator());

    CFTimeInterval delay = 0.1;
    int count = 0;
    for (const auto idx : idxs) {
        UPTileView *tileView = self.tileViews[idx];
        self.tileViews[idx] = [UPTileView viewWithSentinel];
        CGPoint point = offscreen_tray_tile_centers[idx];
        [tileView slideWithDuration:0.4 delay:(count * delay) toPosition:point completion:nil];
        count++;
    }
}

- (void)viewUpdateFillPlayerTray
{
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    const auto &fill_tray_tile_frames = layout_manager.offscreen_tray_tile_frames();
    const auto &fill_tray_tile_centers = layout_manager.offscreen_tray_tile_centers();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();

    size_t idx = 0;
    NSArray *copiedTileViews = [self.tileViews copy];
    for (UPTileView *tileView in copiedTileViews) {
        if (tileView.isSentinel) {
            UPTileView *newTileView = [UPTileView viewWithTile:self.model->player_tray()[idx]];
            newTileView.gestureDelegate = self;
            newTileView.position = UP::player_tray_position(idx);
            newTileView.frame = fill_tray_tile_frames[idx];
            self.tileViews[idx] = newTileView;
            [self.view addSubview:newTileView];
            CGPoint fromPoint = fill_tray_tile_centers[idx];
            CGPoint toPoint = player_tray_tile_centers[idx];
            newTileView.center = fromPoint;
            [newTileView bloopWithDuration:0.25 toPosition:toPoint completion:nil];
        }
        idx++;
    }
}

- (void)viewUpdatePenaltyBlockControlsForDump
{
    self.view.userInteractionEnabled = NO;
    self.roundControlButtonTrash.highlighted = YES;
    self.wordTrayView.alpha = 0.5;
    self.roundControlButtonPause.alpha = 0.5;
    self.roundControlButtonClear.alpha = 0;
    for (UPTileView *tileView in self.tileViews) {
        tileView.alpha = 0.5;
    }
}

- (void)viewUpdatePenaltyBlockControlsForReject
{
    self.view.userInteractionEnabled = NO;
    self.wordTrayView.alpha = 0.5;
    self.roundControlButtonPause.alpha = 0.5;
    self.roundControlButtonClear.alpha = 0.5;
    self.roundControlButtonTrash.alpha = 0;
    for (UPTileView *tileView in self.tileViews) {
        tileView.alpha = 0.5;
    }
}

- (void)viewUpdatePenaltyUnblockControls
{
    self.view.userInteractionEnabled = YES;
    self.roundControlButtonTrash.highlighted = NO;
    self.wordTrayView.alpha = 1.0;
    self.roundControlButtonPause.alpha = 1.0;
    if (self.showingRoundControlButtonClear) {
        self.roundControlButtonClear.alpha = 1.0;
    }
    else {
        self.roundControlButtonTrash.alpha = 1.0;
    }
    for (UPTileView *tileView in self.tileViews) {
        tileView.alpha = 1.0;
    }
}

#pragma mark - UPGameTimerObserver

- (void)gameTimerStarted:(UPGameTimer *)gameTimer
{
//    NSLog(@"gameTimerStarted");
}

- (void)gameTimerStopped:(UPGameTimer *)gameTimer
{
//    NSLog(@"gameTimerStopped");
}

- (void)gameTimerReset:(UPGameTimer *)gameTimer
{
//    NSLog(@"gameTimerReset");
}

- (void)gameTimerUpdated:(UPGameTimer *)gameTimer
{
//    NSLog(@"gameTimerPeriodicUpdate: %.2f", gameTimer.remainingTime);
}

- (void)gameTimerExpired:(UPGameTimer *)gameTimer
{
//    NSLog(@"gameTimerExpired");
}


@end
