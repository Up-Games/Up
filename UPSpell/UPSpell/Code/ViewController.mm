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
#import "UPSpellLayout.h"
#import "UPTile.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "ViewController.h"

using Action = UP::SpellModel::Action;
using Opcode = UP::SpellModel::Opcode;
using TileIndex = UP::TileIndex;

using UP::GameCode;
using UP::Lexicon;
using UP::Random;
using UP::SpellLayout;
using UP::SpellModel;
using UP::Tile;
using UP::TileCount;
using UP::TilePaths;
using UP::TileSequence;
using UP::valid;

using UP::TimeSpanning::bloop;
using UP::TimeSpanning::fade;
using UP::TimeSpanning::shake;
using UP::TimeSpanning::slide;
using UP::TimeSpanning::slide_to;
using UP::TimeSpanning::spring;

using UP::TimeSpanning::cancel_all;
using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::pause_all;
using UP::TimeSpanning::pause;
using UP::TimeSpanning::start_all;
using UP::TimeSpanning::start;

using UP::TimeSpanning::AnimationLabel;
using UP::TimeSpanning::DelayLabel;
using UP::TimeSpanning::TestLabel;

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
@property (nonatomic) UIFont *gameInformationFont;
@property (nonatomic) UIFont *gameInformationSuperscriptFont;
@property (nonatomic) CGPoint panStartPoint;
@property (nonatomic) CGFloat panTotalDistance;
@property (nonatomic) CGFloat panFurthestDistance;
@property (nonatomic) CGFloat panCurrentDistance;
@property (nonatomic) BOOL panEverMovedUp;
@property (nonatomic) SpellModel *model;
@end

@implementation ViewController

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);
    LOG_CHANNEL_ON(Gestures);
    //LOG_CHANNEL_ON(Layout);
    //LOG_CHANNEL_ON(Leaks);

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
    [UIColor setThemeHue:300];
    SpellLayout &layout_manager = SpellLayout::create_instance();
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

    UIBezierPath *wordTrayMaskPath = [self wordTrayMaskPath];
    self.tileContainerClipView = [UPBezierPathView bezierPathView];
    self.tileContainerClipView.canonicalSize = UP::SpellLayout::CanonicalWordTrayMaskFrame.size;
    self.tileContainerClipView.path = wordTrayMaskPath;
    self.tileContainerClipView.fillColor = [UIColor blackColor];
    self.tileContainerView.layer.mask = self.tileContainerClipView.shapeLayer;

    self.roundControlButtonPause = [UPControl roundControlButtonPause];
    self.roundControlButtonPause.frame = layout_manager.game_controls_left_button_frame();
    self.roundControlButtonPause.chargeSize = layout_manager.game_controls_button_charge_size();
    [self.roundControlButtonPause addTarget:self action:@selector(roundControlButtonPauseTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonPause];

    self.roundControlButtonTrash = [UPControl roundControlButtonTrash];
    self.roundControlButtonTrash.frame = layout_manager.game_controls_right_button_frame();
    self.roundControlButtonTrash.chargeSize = layout_manager.game_controls_button_charge_size();
    [self.roundControlButtonTrash addTarget:self action:@selector(roundControlButtonTrashTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonTrash];

    self.roundControlButtonClear = [UPControl roundControlButtonClear];
    self.roundControlButtonClear.frame = layout_manager.game_controls_right_button_frame();
    self.roundControlButtonClear.chargeSize = layout_manager.game_controls_button_charge_size();
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

    self.wordTrayView.frame = layout_manager.word_tray_layout_frame();

    self.roundControlButtonClear.alpha = 0;
    [self viewOpUpdateGameControls];

    delay(0.2, ^{
        [self viewOpFillPlayerTray];
    });
}

- (void)dealloc
{
    delete self.model;
}

- (void)viewDidLayoutSubviews
{
    SpellLayout &layout_manager = SpellLayout::instance();
    self.infinityView.frame = self.view.bounds;
    self.tileContainerView.frame = self.view.bounds;
    self.tileContainerClipView.frame = layout_manager.word_tray_mask_frame();
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

#pragma mark - View mapping

- (NSArray *)playerTrayTileViews
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : self.model->player_tray()) {
        if (tile.view()) {
            [array addObject:tile.view()];
        }
    }
    return array;
}

- (NSArray *)wordTrayTileViews
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : self.model->word_tray()) {
        if (tile.view()) {
            [array addObject:tile.view()];
        }
    }
    return array;
}

- (TileIndex)playerTrayIndexOfView:(UPTileView *)view
{
    TileIndex idx = 0;
    for (const auto &tile : self.model->player_tray()) {
        if (view == tile.view()) {
            return idx;
        }
        idx++;
    }
    return UP::NotATileIndex;
}

- (UPTileView *)playerTrayTileViewAtIndex:(TileIndex)index
{
    ASSERT_IDX(index);
    return self.model->player_tray()[index].view();
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

- (BOOL)beginTracking:(UPTileView *)tileView touch:(UITouch *)touch event:(UIEvent *)event
{
    TileIndex tileIndex = [self playerTrayIndexOfView:tileView];
    ASSERT_IDX(tileIndex);
    if (UP::is_marked(self.model->player_marked(), tileIndex)) {
        tileView.highlighted = NO;
        return NO;
    }
    else {
        tileView.highlighted = YES;
        return YES;
    }
}

- (BOOL)continueTracking:(UPTileView *)tileView touch:(UITouch *)touch event:(UIEvent *)event
{
    return YES;
}

- (void)endTracking:(UPTileView *)tileView touch:(UITouch *)touch event:(UIEvent *)event
{
}

- (void)cancelTracking:(UPTileView *)tileView event:(UIEvent *)event
{
}

- (void)tileViewTapped:(UPTileView *)tileView
{
    if (tileView.tap.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    TileIndex tileIndex = [self playerTrayIndexOfView:tileView];
    ASSERT_IDX(tileIndex);
    
    if (UP::is_marked(self.model->player_marked(), tileIndex)) {
        [self wordTrayTapped];
    }
    else {
        [self applyActionAdd:tileIndex];
    }
}

- (void)tileViewPanned:(UPTileView *)tileView
{
    UIPanGestureRecognizer *pan = tileView.pan;
    switch (pan.state) {
        case UIGestureRecognizerStatePossible: {
            // no-op
            break;
        }
        case UIGestureRecognizerStateBegan: {
            TileIndex tileIndex = [self playerTrayIndexOfView:tileView];
            ASSERT_IDX(tileIndex);
            [self applyActionPick:tileIndex];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            SpellLayout &layout_manager = SpellLayout::instance();
            CGPoint t = [pan translationInView:tileView];
            CGPoint center = CGPointMake(self.panStartPoint.x + t.x, self.panStartPoint.y + t.y);
            CGRect tdr = layout_manager.tile_drag_frame();
            if (center.x < up_rect_min_x(tdr)) {
                CGFloat dx = up_rect_min_x(tdr) - center.x;
                center.x = up_rect_min_x(tdr) - sqrt(dx);
            }
            else if (center.x > up_rect_max_x(tdr)) {
                CGFloat dx = center.x - up_rect_max_x(tdr);
                center.x = up_rect_max_x(tdr) + sqrt(dx);
            }
            if (center.y < up_rect_min_y(tdr)) {
                CGFloat dy = up_rect_min_y(tdr) - center.y;
                center.y = up_rect_min_y(tdr) - sqrt(dy);
            }
            else if (center.y > up_rect_max_y(tdr)) {
                CGFloat dy = center.y - up_rect_max_y(tdr);
                center.y = up_rect_max_y(tdr) + sqrt(dy);
            }
            
            self.panTotalDistance += up_point_distance(tileView.center, center);
            self.panFurthestDistance = UPMaxT(CGFloat, self.panFurthestDistance, up_point_distance(CGPointZero, t));
            self.panCurrentDistance = up_point_distance(self.panStartPoint, center);
            
            CGPoint v = [pan velocityInView:tileView];
            if (!self.panEverMovedUp) {
                self.panEverMovedUp = v.y < 0;
            }
            
            tileView.center = center;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            TileIndex tileIndex = [self playerTrayIndexOfView:tileView];
            ASSERT_IDX(tileIndex);
            CGPoint v = [pan velocityInView:tileView];
            BOOL moved = self.panFurthestDistance >= 25;
            BOOL putBack = self.panCurrentDistance < 10;
            BOOL movingUp = v.y < -50;
            LOG(Gestures, "pan ended: d: %.2f ; f: %.2f ; c: %.2f ; v: %.2f",
                self.panTotalDistance, self.panFurthestDistance, self.panCurrentDistance, v.y);
            LOG(Gestures, "   moved:     %s", moved ? "Y" : "N");
            LOG(Gestures, "   put back:  %s", putBack ? "Y" : "N");
            LOG(Gestures, "   moving up: %s", movingUp ? "Y" : "N");
            LOG(Gestures, "   ever up:   %s", self.panEverMovedUp ? "Y" : "N");
            LOG(Gestures, "   add:       %s", ((!moved && putBack) || movingUp || !self.panEverMovedUp) ? "Y" : "N");
            if ((!moved && putBack) || movingUp || !self.panEverMovedUp) {
                [self applyActionAdd:tileIndex];
            }
            else {
                [self applyActionDrop:tileIndex];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            TileIndex tileIndex = [self playerTrayIndexOfView:tileView];
            ASSERT_IDX(tileIndex);
            [self applyActionDrop:tileIndex];
            break;
        }
    }    
}

#pragma mark - Actions

- (void)applyActionAdd:(TileIndex)tile_idx
{
    cancel(DelayLabel);

    NSArray *wordTrayTileViews = [self wordTrayTileViews];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::ADD, tile_idx));

    SpellLayout &layout_manager = SpellLayout::instance();

    start(slide(AnimationLabel, wordTrayTileViews, 0.15, layout_manager.word_tray_tile_offset(), nil));

    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(self.model->word_length());
    const size_t word_idx = self.model->word_length() - 1;
    CGPoint word_tray_center = word_tray_tile_centers[word_idx];
    UPTileView *tileView = [self playerTrayTileViewAtIndex:tile_idx];
    [self.tileContainerView bringSubviewToFront:tileView];
    start(bloop(@[tileView], 0.4, word_tray_center, nil));

    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionPick:(TileIndex)tile_idx
{
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::PICK, tile_idx));

    UPTileView *tileView = [self playerTrayTileViewAtIndex:tile_idx];
    [self.tileContainerView bringSubviewToFront:tileView];
    CGPoint pointInView = [tileView.pan locationInView:tileView];
    CGPoint center = up_rect_center(tileView.bounds);
    CGFloat dx = center.x - pointInView.x;
    CGFloat dy = center.y - pointInView.y;
    CGPoint pointInSuperview = [tileView.pan locationInView:tileView.superview];
    self.panStartPoint = CGPointMake(pointInSuperview.x + dx, pointInSuperview.y + dy);
    self.panTotalDistance = 0;
    self.panFurthestDistance = 0;
    self.panCurrentDistance = 0;
    self.panEverMovedUp = NO;
    tileView.highlighted = YES;
}

- (void)applyActionDrop:(TileIndex)tile_idx
{
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DROP, tile_idx));

    SpellLayout &layout_manager = SpellLayout::instance();
    UPTileView *tileView = [self playerTrayTileViewAtIndex:tile_idx];
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();
    CGPoint tile_center = player_tray_tile_centers[tile_idx];
    start(bloop(@[tileView], 0.4, tile_center, nil));
    
    tileView.highlighted = NO;
}

- (void)applyActionClear
{
    cancel(DelayLabel);
    cancel(AnimationLabel);

    [self viewOpApplyTranslationToFrame:[self wordTrayTileViews]];
    [self viewOpClearWordTray];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::CLEAR));
    [self viewOpUpdateGameControls];
}

- (void)applyActionSubmit
{
    cancel(DelayLabel);

    [self viewOpScoreWord];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::SUBMIT));
    delay(0.25, ^{
        [self viewOpFillPlayerTray];
        [self viewOpUpdateGameControls];
    });
}

- (void)applyActionReject
{
    cancel(DelayLabel);

    [self viewOpLockUserInterface];

    // assess time penalty and shake word tray side-to-side
    [self viewOpPenaltyForReject:[self playerTrayTileViews]];
    SpellLayout &layout_manager = SpellLayout::instance();
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.wordTrayView];
    [views addObjectsFromArray:[self wordTrayTileViews]];
    start(shake(views, 0.9, layout_manager.word_tray_shake_offset(), ^(UIViewAnimatingPosition) {
        delay(0.25, ^{
            [self viewOpPenaltyFinished];
            delay(0.1, ^{
                [self applyActionClear];
                [self viewOpUnlockUserInterface];
            });
        });
    }));
}

- (void)applyActionDump
{
    ASSERT(self.wordTrayTileViews.count == 0);

    cancel(DelayLabel);

    [self viewOpLockUserInterface];

    NSArray *playerTrayTileViews = [self playerTrayTileViews];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [UIView animateWithDuration:0.1 animations:^{
        [self viewOpPenaltyForDump:playerTrayTileViews];
    } completion:^(BOOL finished) {
        [self viewOpDumpPlayerTray:playerTrayTileViews];
        delay(1.65, ^{
            [self viewOpPenaltyFinished];
            [self viewOpFillPlayerTrayWithCompletion:^{
                [self viewOpUnlockUserInterface];
            }];
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

- (void)viewOpApplyTranslationToFrame:(NSArray *)tileViews
{
    for (UPTileView *tileView in tileViews) {
        CGAffineTransform transform = tileView.transform;
        tileView.transform = CGAffineTransformIdentity;
        CGRect frame = CGRectOffset(tileView.frame, transform.tx, transform.ty);
        tileView.frame = frame;
    }
}

- (void)viewOpClearWordTray
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    ASSERT(wordTrayTileViews.count > 0);

    SpellLayout &layout_manager = SpellLayout::instance();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();
    
    for (UPTileView *tileView in wordTrayTileViews) {
        TileIndex idx = [self playerTrayIndexOfView:tileView];
        CGPoint player_tray_center = player_tray_tile_centers[idx];
        start(bloop(@[tileView], 0.4, player_tray_center, nil));
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveLinear animations:^{
            tileView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

- (void)viewOpScoreWord
{
    SpellLayout &layout_manager = SpellLayout::instance();

    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    
    for (UPTileView *tileView in wordTrayTileViews) {
        tileView.userInteractionEnabled = NO;
    }

    CGPoint slidePoint = CGPointMake(UP::NotACoordinate, layout_manager.score_tile_center_y());
    UPAnimator *slideAnimator = slide_to(wordTrayTileViews, 0.1, slidePoint, ^(UIViewAnimatingPosition) {
        [wordTrayTileViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    });

    UIOffset springOffset = UIOffsetMake(0, layout_manager.score_tile_spring_down_offset_y());
    UPAnimator *springAnimator = spring(wordTrayTileViews, 0.13, springOffset, ^(UIViewAnimatingPosition) {
        start(slideAnimator);
    });
    
    start(springAnimator);
}

- (void)viewOpDumpPlayerTray:(NSArray *)playerTrayTileViews
{
    SpellLayout &layout_manager = SpellLayout::instance();
    Random &random = Random::instance();
    const auto &offscreen_tray_tile_centers = layout_manager.prefill_tile_centers();

    std::array<size_t, TileCount> idxs;
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        idxs[idx] = idx;
    }
    std::shuffle(idxs.begin(), idxs.end(), random.generator());

    CFTimeInterval baseDelay = 0.125;
    int count = 0;
    for (const auto idx : idxs) {
        UPTileView *tileView = playerTrayTileViews[idx];
        CGPoint center = tileView.center;
        CGPoint offscreenPoint = offscreen_tray_tile_centers[idx];
        UIOffset offset = UIOffsetMake(offscreenPoint.x - center.x, offscreenPoint.y - center.y);
        UPAnimator *animator = slide(@[tileView], 1.1, offset, ^(UIViewAnimatingPosition) {
            [tileView removeFromSuperview];
        });
        delay(count * baseDelay, ^{
            start(animator);
        });
        count++;
    }
}

- (void)viewOpFillPlayerTray
{
    [self viewOpFillPlayerTrayWithCompletion:nil];
}

- (void)viewOpFillPlayerTrayWithCompletion:(void (^)(void))completion
{
    SpellLayout &layout_manager = SpellLayout::instance();
    const auto &prefill_tile_frames = layout_manager.prefill_tile_frames();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();

    TileIndex idx = 0;
    for (auto &tile : self.model->player_tray()) {
        if (tile.has_view<false>()) {
            UPTileView *tileView = [UPTileView viewWithGlyph:tile.glyph() score:tile.score() multiplier:tile.multiplier()];
            tile.set_view(tileView);
            tileView.gestureDelegate = self;
            tileView.frame = prefill_tile_frames[idx];
            [self.tileContainerView addSubview:tileView];
            start(bloop(@[tileView], 0.3, player_tray_tile_centers[idx], nil));
        }
        idx++;
    }

    // FIXME: make it possible to bloop views to their respective points as a collection
    delay(0.3, ^{
        if (completion) {
            completion();
        }
    });
}

- (void)viewOpPenaltyForDump:(NSArray *)tileViews
{
    ASSERT(!self.view.userInteractionEnabled);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.roundControlButtonTrash.highlightedOverride = YES;
    self.roundControlButtonTrash.highlighted = YES;
    self.wordTrayView.alpha = disabledAlpha;
    self.roundControlButtonPause.alpha = disabledAlpha;
    self.roundControlButtonClear.alpha = 0;
    for (UPTileView *tileView in tileViews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyForReject:(NSArray *)tileViews
{
    ASSERT(!self.view.userInteractionEnabled);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.wordTrayView.alpha = disabledAlpha;
    self.roundControlButtonPause.alpha = disabledAlpha;
    self.roundControlButtonClear.alpha = disabledAlpha;
    self.roundControlButtonTrash.alpha = 0;
    for (UPTileView *tileView in tileViews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyFinished
{
    ASSERT(!self.view.userInteractionEnabled);
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
    NSArray *playerTrayTileViews = [self playerTrayTileViews];
    for (UPTileView *tileView in playerTrayTileViews) {
        tileView.alpha = 1.0;
    }
}

- (void)viewOpLockUserInterface
{
    ASSERT(self.view.userInteractionEnabled);
    self.view.userInteractionEnabled = NO;
}

- (void)viewOpUnlockUserInterface
{
    ASSERT(!self.view.userInteractionEnabled);
    self.view.userInteractionEnabled = YES;
}

@end
