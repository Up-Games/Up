//
//  ViewController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <memory>

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSceneDelegate.h"
#import "UPSpellModel.h"
#import "UPSpellLayoutManager.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "ViewController.h"

using Action = UP::SpellModel::Action;
using Opcode = UP::SpellModel::Opcode;
using TileIndex = UP::TileIndex;

using UP::GameCode;
using UP::Lexicon;
using UP::Random;
using UP::SpellLayoutManager;
using UP::SpellModel;
using UP::Tile;
using UP::TileCount;
using UP::TilePaths;
using UP::TileSequence;

using UP::TimeSpanning::bloop_animator;
using UP::TimeSpanning::fade_animator;
using UP::TimeSpanning::shake_animator;
using UP::TimeSpanning::slide_animator;
using UP::TimeSpanning::spring_animator;

using UP::TimeSpanning::pause;
using UP::TimeSpanning::start;
using UP::TimeSpanning::pause_all;
using UP::TimeSpanning::start_all;
using UP::TimeSpanning::cancel_all;
using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::AnimationLabel;
using UP::TimeSpanning::DelayLabel;
using UP::TimeSpanning::TestLabel;

static NSString * const GameTag = @"game";

@interface ViewController () <UPGameTimerObserver, UPTileViewGestureDelegate>
@property (nonatomic) UIView *infinityView;
@property (nonatomic) UPControl *wordTrayView;
@property (nonatomic) UIView *tileContainerView;
@property (nonatomic) UPBezierPathView *tileContainerClipView;
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
@property (nonatomic) UIFont *gameInformationFont;
@property (nonatomic) UIFont *gameInformationSuperscriptFont;
@property (nonatomic) SpellModel *model;
@end

@implementation ViewController

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);
    //LOG_CHANNEL_ON(LayoutManager);

    [super viewDidLoad];

    UP::TimeSpanning::init();
    Random::create_instance();
    Lexicon::set_language(UPLexiconLanguageEnglish);

    GameCode game_code = GameCode::random();
//    GameCode game_code = GameCode("WPQ-2701");
//    LOG(General, "code: %s", game_code.string().c_str());
//    LOG(General, "code: %d", game_code.value());
//
    self.model = new SpellModel(game_code);
    
    [UIColor setThemeStyle:UPColorStyleLight];
    [UIColor setThemeHue:200];
    SpellLayoutManager &layout_manager = SpellLayoutManager::create_instance();
    TilePaths::create_instance();
    
    layout_manager.set_screen_bounds([[UIScreen mainScreen] bounds]);
    layout_manager.set_screen_scale([[UIScreen mainScreen] scale]);
    layout_manager.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout_manager.calculate();
    
    self.infinityView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infinityView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];
    [self.view addSubview:self.infinityView];
        
    self.wordTrayView = [UPControl wordTray];
    [self.wordTrayView addTarget:self action:@selector(wordTrayTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wordTrayView];

    self.tileContainerView = [[UPContainerView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tileContainerView];

    self.tileContainerClipView = [UPBezierPathView bezierPathView];
    self.tileContainerClipView.canonicalSize = UP::SpellLayoutManager::CanonicalWordTrayMaskFrame.size;
    self.tileContainerClipView.path = [self wordTrayMaskPath];
    self.tileContainerClipView.fillColor = [UIColor blackColor];
    self.tileContainerView.layer.mask = self.tileContainerClipView.shapeLayer;

    self.roundControlButtonPause = [UPControl roundControlButtonPause];
    [self.roundControlButtonPause addTarget:self action:@selector(roundControlButtonPauseTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonPause];

    self.roundControlButtonTrash = [UPControl roundControlButtonTrash];
    [self.roundControlButtonTrash addTarget:self action:@selector(roundControlButtonTrashTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonTrash];

    self.roundControlButtonClear = [UPControl roundControlButtonClear];
    [self.roundControlButtonClear addTarget:self action:@selector(roundControlButtonClearTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonClear];

    UIFont *font = [UIFont gameInformationFontOfSize:layout_manager.game_information_font_metrics().point_size()];
    UIFont *superscriptFont = [UIFont gameInformationFontOfSize:layout_manager.game_information_superscript_font_metrics().point_size()];

    self.gameInformationFont = font;
    self.gameInformationSuperscriptFont = superscriptFont;

    self.gameTimerLabel = [UPGameTimerLabel label];
    self.gameTimerLabel.font = font;
    self.gameTimerLabel.superscriptFont = superscriptFont;
    self.gameTimerLabel.superscriptBaselineAdjustment = layout_manager.game_information_superscript_font_metrics().baseline_adjustment();
    self.gameTimerLabel.superscriptKerning = layout_manager.game_information_superscript_font_metrics().kerning();
    
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

    self.wordTrayView.frame = layout_manager.word_tray_layout_frame();

    self.roundControlButtonClear.alpha = 0;
    [self viewOpUpdateGameControls];

    for (TileIndex idx = 0; idx < TileCount; idx++) {
        UPTileView *tileView = [UPTileView viewWithSentinel];
        tileView.index = idx;
        [self.tileViews addObject:tileView];
    }

    delay(DelayLabel, 0.2, ^{
        [self viewOpFillPlayerTray];
    });
}

- (void)dealloc
{
    delete self.model;
}

- (void)viewDidLayoutSubviews
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    self.infinityView.frame = self.view.bounds;
    self.tileContainerView.frame = self.view.bounds;
    self.tileContainerClipView.frame = layout_manager.word_tray_mask_frame();
    self.roundControlButtonPause.frame = layout_manager.controls_button_pause_frame();
    self.roundControlButtonTrash.frame = layout_manager.controls_button_trash_frame();
    self.roundControlButtonClear.frame = layout_manager.controls_button_trash_frame();
    self.gameTimerLabel.frame = layout_manager.game_time_label_frame();
    self.scoreLabel.frame = layout_manager.game_score_label_frame();
}

- (UIBezierPath *)wordTrayMaskPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(874.89, 42.17)];
    [path addCurveToPoint: CGPointMake(874.92, 29.27) controlPoint1: CGPointMake(874.89, 37.87) controlPoint2: CGPointMake(874.9, 33.57)];
    [path addLineToPoint: CGPointMake(874.77, 29.3)];
    [path addCurveToPoint: CGPointMake(874.67, 21.61) controlPoint1: CGPointMake(874.74, 26.73) controlPoint2: CGPointMake(874.71, 24.17)];
    [path addCurveToPoint: CGPointMake(868.51, 10.28) controlPoint1: CGPointMake(874.43, 16.58) controlPoint2: CGPointMake(872.87, 12.34)];
    [path addCurveToPoint: CGPointMake(861.45, 7.53) controlPoint1: CGPointMake(866.21, 9.19) controlPoint2: CGPointMake(863.87, 8.03)];
    [path addCurveToPoint: CGPointMake(843.92, 4.64) controlPoint1: CGPointMake(855.64, 6.34) controlPoint2: CGPointMake(849.8, 5.14)];
    [path addCurveToPoint: CGPointMake(658, 0.19) controlPoint1: CGPointMake(782.07, -0.48) controlPoint2: CGPointMake(719.98, 0.61)];
    [path addCurveToPoint: CGPointMake(437.5, 0.01) controlPoint1: CGPointMake(586.97, 0.02) controlPoint2: CGPointMake(508.65, -0.02)];
    [path addCurveToPoint: CGPointMake(217, 0.19) controlPoint1: CGPointMake(366.35, -0.02) controlPoint2: CGPointMake(288.03, 0.02)];
    [path addCurveToPoint: CGPointMake(31.08, 4.64) controlPoint1: CGPointMake(155.02, 0.61) controlPoint2: CGPointMake(92.93, -0.48)];
    [path addCurveToPoint: CGPointMake(13.55, 7.53) controlPoint1: CGPointMake(25.2, 5.14) controlPoint2: CGPointMake(19.36, 6.34)];
    [path addCurveToPoint: CGPointMake(6.49, 10.28) controlPoint1: CGPointMake(11.13, 8.03) controlPoint2: CGPointMake(8.79, 9.19)];
    [path addCurveToPoint: CGPointMake(0.33, 21.61) controlPoint1: CGPointMake(2.13, 12.34) controlPoint2: CGPointMake(0.57, 16.58)];
    [path addCurveToPoint: CGPointMake(0.23, 29.3) controlPoint1: CGPointMake(0.29, 24.17) controlPoint2: CGPointMake(0.26, 26.73)];
    [path addLineToPoint: CGPointMake(0.08, 29.27)];
    [path addCurveToPoint: CGPointMake(0.11, 42.16) controlPoint1: CGPointMake(0.1, 33.57) controlPoint2: CGPointMake(0.11, 37.87)];
    [path addCurveToPoint: CGPointMake(0.07, 132) controlPoint1: CGPointMake(-0.02, 59.55) controlPoint2: CGPointMake(-0.03, 107.78)];
    [path addLineToPoint: CGPointMake(-0, 132)];
    [path addLineToPoint: CGPointMake(-0, 420)];
    [path addLineToPoint: CGPointMake(875, 420)];
    [path addLineToPoint: CGPointMake(875, 132)];
    [path addLineToPoint: CGPointMake(874.93, 132)];
    [path addCurveToPoint: CGPointMake(874.89, 42.17) controlPoint1: CGPointMake(875.04, 107.78) controlPoint2: CGPointMake(875.02, 59.55)];
    [path closePath];
    return path;
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

#pragma mark - Control target/action and gestures

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

- (void)tileViewTapped:(UPTileView *)tileView
{
    if (tileView.tap.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    if (UP::is_marked(self.model->player_marked(), tileView.index)) {
        [self wordTrayTapped];
    }
    else {
        [self applyActionTap:tileView.index];
    }
}

- (void)tileViewPanned:(UPTileView *)tileView
{
}

#pragma mark - Actions

- (void)applyActionTap:(TileIndex)tile_idx
{
    cancel(DelayLabel);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::TAP, tile_idx));

    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(self.model->word_length());
    
    CGPoint w1 = word_tray_tile_centers[0];
    CGPoint w2 = word_tray_tile_centers[1];
    UIOffset offset = UIOffsetMake((w1.x - w2.x) * 0.5, 0);
    UPAnimator *slideAnimator = [UPAnimator slideAnimatorWithLabel:AnimationLabel views:self.wordTrayTileViews duration:0.2
        offset:offset completion:nil];
    [slideAnimator startAnimation];
    
    const size_t word_idx = self.model->word_length() - 1;
    CGPoint word_tray_center = word_tray_tile_centers[word_idx];
    UPTileView *tileView = self.tileViews[tile_idx];
    [self.view bringSubviewToFront:tileView];
    [self.wordTrayTileViews addObject:tileView];

    UPAnimator *bloopAnimator = [UPAnimator bloopAnimatorWithLabel:AnimationLabel views:@[tileView] duration:0.4
        position:word_tray_center completion:nil];
    [bloopAnimator startAnimation];
        
    [self viewOpUpdateGameControls];
}

- (void)applyActionClear
{
    cancel(DelayLabel);

    [self viewOpClearWordTray];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::CLEAR));
    [self viewOpUpdateGameControls];
}

- (void)applyActionSubmit
{
    cancel(DelayLabel);

    [self viewOpScoreWord];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::SUBMIT));
    delay(DelayLabel, 0.25, ^{
        [self viewOpFillPlayerTray];
        [self viewOpUpdateGameControls];
    });
}

- (void)applyActionReject
{
    cancel(DelayLabel);

    // shake word tray side-to-side and assess time penalty
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    [self viewOpPenaltyForReject];
    UIOffset offset = UIOffsetMake(layout_manager.word_tray_shake_amount(), 0);
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.wordTrayView];
    [views addObjectsFromArray:self.wordTrayTileViews];
    UPAnimator *animator = [UPAnimator shakeAnimatorWithLabel:AnimationLabel views:views duration:0.9 offset:offset
        completion:^(UIViewAnimatingPosition finalPosition) {
            delay(DelayLabel, 0.25, ^{
                [self viewOpPenaltyFinished];
                delay(DelayLabel, 0.1, ^{
                    [self applyActionClear];
                });
            });
        }
    ];
    [animator startAnimation];
}

- (void)applyActionDump
{
    cancel(DelayLabel);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [UIView animateWithDuration:0.1 animations:^{
        [self viewOpPenaltyForDump];
    } completion:^(BOOL finished) {
        [self viewOpDumpPlayerTray];
        delay(DelayLabel, 1.6, ^{
            [self viewOpPenaltyFinished];
            [self viewOpFillPlayerTray];
        });
    }];
}

#pragma mark - View ops

- (void)viewOpUpdateGameControls
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

- (void)viewOpClearWordTray
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();
    TileIndex idx = 0;
    for (const auto &mark : self.model->player_marked()) {
        if (mark) {
            CGPoint player_tray_center = player_tray_tile_centers[idx];
            UPTileView *tileView = self.tileViews[idx];
            UPAnimator *bloopAnimator = [UPAnimator bloopAnimatorWithLabel:AnimationLabel views:@[tileView] duration:0.4
                position:player_tray_center completion:nil];
            [bloopAnimator startAnimation];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveLinear animations:^{
                tileView.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
        idx++;
    }
    [self.wordTrayTileViews removeAllObjects];
}

- (void)viewOpScoreWord
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    TileIndex idx = 0;
    for (const auto &mark : self.model->player_marked()) {
        if (mark) {
            UPTileView *tileView = self.tileViews[idx];
            tileView.userInteractionEnabled = NO;
            self.tileViews[idx] = [UPTileView viewWithSentinel];
        }
        idx++;
    }

    NSArray *wordTrayTileViewsCopy = [self.wordTrayTileViews copy];
    [self.wordTrayTileViews removeAllObjects];

    UIOffset slideOffset = UIOffsetMake(0, -up_size_height(layout_manager.tile_size()) * 1.25);
    UPAnimator *slideAnimator = slide_animator(AnimationLabel, wordTrayTileViewsCopy, 0.1, slideOffset, ^(UIViewAnimatingPosition) {
        [wordTrayTileViewsCopy makeObjectsPerformSelector:@selector(removeFromSuperview)];
    });

    UIOffset springOffset = UIOffsetMake(0, up_size_height(layout_manager.tile_size()) * 0.125);
    UPAnimator *springAnimator = spring_animator(AnimationLabel, wordTrayTileViewsCopy, 0.13, springOffset, ^(UIViewAnimatingPosition) {
        start(slideAnimator);
    });
    
    start(springAnimator);
}

- (void)viewOpDumpPlayerTray
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    Random &random = Random::instance();
    const auto &offscreen_tray_tile_centers = layout_manager.offscreen_tray_tile_centers();
    
    std::array<size_t, TileCount> idxs;
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        idxs[idx] = idx;
    }
    std::shuffle(idxs.begin(), idxs.end(), random.generator());

    CFTimeInterval delay = 0.125;
    int count = 0;
    for (const auto idx : idxs) {
        UPTileView *tileView = self.tileViews[idx];
        self.tileViews[idx] = [UPTileView viewWithSentinel];
        CGPoint center = tileView.center;
        CGPoint offscreenPoint = offscreen_tray_tile_centers[idx];
        UIOffset offset = UIOffsetMake(offscreenPoint.x - center.x, offscreenPoint.y - center.y);
        UPAnimator *animator = [UPAnimator slideAnimatorWithLabel:AnimationLabel views:@[tileView] duration:1.1 offset:offset
            completion:nil];
        [animator startAnimationAfterDelay:(count * delay)];
        count++;
    }
}

- (void)viewOpFillPlayerTray
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    const auto &fill_tray_tile_frames = layout_manager.offscreen_tray_tile_frames();
    const auto &fill_tray_tile_centers = layout_manager.offscreen_tray_tile_centers();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();

    TileIndex idx = 0;
    NSArray *copiedTileViews = [self.tileViews copy];
    for (UPTileView *tileView in copiedTileViews) {
        if (tileView.isSentinel) {
            UPTileView *newTileView = [UPTileView viewWithTile:self.model->player_tray()[idx]];
            newTileView.gestureDelegate = self;
            newTileView.index = idx;
            newTileView.frame = fill_tray_tile_frames[idx];
            self.tileViews[idx] = newTileView;
            [self.tileContainerView addSubview:newTileView];
            CGPoint fromPoint = fill_tray_tile_centers[idx];
            CGPoint toPoint = player_tray_tile_centers[idx];
            newTileView.center = fromPoint;
            UPAnimator *bloopAnimator = [UPAnimator bloopAnimatorWithLabel:AnimationLabel views:@[newTileView] duration:0.3
                position:toPoint completion:nil];
            [bloopAnimator startAnimation];
        }
        idx++;
    }
}

- (void)viewOpPenaltyForDump
{
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.view.userInteractionEnabled = NO;
    self.roundControlButtonTrash.highlightedOverride = YES;
    self.roundControlButtonTrash.highlighted = YES;
    self.wordTrayView.alpha = disabledAlpha;
    self.roundControlButtonPause.alpha = disabledAlpha;
    self.roundControlButtonClear.alpha = 0;
    for (UPTileView *tileView in self.tileViews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyForReject
{
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.view.userInteractionEnabled = NO;
    self.wordTrayView.alpha = disabledAlpha;
    self.roundControlButtonPause.alpha = disabledAlpha;
    self.roundControlButtonClear.alpha = disabledAlpha;
    self.roundControlButtonTrash.alpha = 0;
    for (UPTileView *tileView in self.tileViews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyFinished
{
    self.view.userInteractionEnabled = YES;
    self.roundControlButtonTrash.highlightedOverride = NO;
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

@end
