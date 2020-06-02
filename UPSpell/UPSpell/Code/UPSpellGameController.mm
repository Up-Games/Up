//
//  UPSpellGameController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <limits>
#import <memory>

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogGameOver.h"
#import "UPDialogPause.h"
#import "UPSceneDelegate.h"
#import "UPSpellGameView.h"
#import "UPSpellModel.h"
#import "UPSpellLayout.h"
#import "UPTileModel.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "UPSpellGameController.h"

using Action = UP::SpellModel::Action;
using Opcode = UP::SpellModel::Opcode;
using State = UP::SpellModel::State;
using TileIndex = UP::TileIndex;
using TilePosition = UP::TilePosition;
using TileTray = UP::TileTray;

using UP::GameCode;
using UP::Lexicon;
using UP::Random;
using UP::SpellLayout;
using UP::SpellModel;
using UP::Tile;
using UP::TileModel;
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

using UP::RoleGameAll;
using UP::RoleGameDelay;
using UP::RoleGameUI;
using UP::RoleModeAll;
using UP::RoleModeDelay;
using UP::RoleModeUI;

@interface UPSpellGameController () <UPGameTimerObserver, UPTileViewGestureDelegate>
@property (nonatomic) UIView *infinityView;
@property (nonatomic) UPSpellGameView *gameView;
@property (nonatomic) UPGameTimer *gameTimer;
@property (nonatomic) BOOL showingRoundButtonClear;
@property (nonatomic) UPTileView *pickedView;
@property (nonatomic) TilePosition pickedPosition;
@property (nonatomic) CGPoint panStartPoint;
@property (nonatomic) CGFloat panFurthestDistance;
@property (nonatomic) CGFloat panCurrentDistance;
@property (nonatomic) BOOL panEverMovedUp;
@property (nonatomic) UPDialogGameOver *dialogGameOver;
@property (nonatomic) UPDialogPause *dialogPause;
@property (nonatomic) NSInteger userInterfaceLockCount;
@property (nonatomic) SpellModel *model;
@end

@implementation UPSpellGameController

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);
    //LOG_CHANNEL_ON(Gestures);
    LOG_CHANNEL_ON(Layout);
    //LOG_CHANNEL_ON(Leaks);
    //LOG_CHANNEL_ON(Mode);

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
    [UIColor setThemeHue:310];
    SpellLayout &layout = SpellLayout::create_instance();
    TilePaths::create_instance();
    
    layout.set_screen_bounds([[UIScreen mainScreen] bounds]);
    layout.set_screen_scale([[UIScreen mainScreen] scale]);
    layout.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout.calculate();
    
    self.infinityView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infinityView.frame = layout.screen_bounds();
    self.infinityView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];
    [self.view addSubview:self.infinityView];

    self.gameView = [UPSpellGameView instance];
    [self.gameView.wordTrayView addTarget:self action:@selector(wordTrayTapped) forEvents:UPControlEventTouchUpInside];
    [self.gameView.roundButtonPause addTarget:self action:@selector(roundButtonPauseTapped:) forEvents:UPControlEventTouchUpInside];
    [self.gameView.roundButtonTrash addTarget:self action:@selector(roundButtonTrashTapped:) forEvents:UPControlEventTouchUpInside];
    [self.gameView.roundButtonClear addTarget:self action:@selector(roundButtonClearTapped:) forEvents:UPControlEventTouchUpInside];
    [self.view addSubview:self.gameView];

    self.gameTimer = [UPGameTimer defaultGameTimer];
    [self.gameTimer addObserver:self.gameView.gameTimerLabel];
    [self.gameTimer addObserver:self];
    [self.gameTimer notifyObservers];

    self.dialogGameOver = [UPDialogGameOver instance];
    [self.view addSubview:self.dialogGameOver];
//    [self.dialogPause.quitButton addTarget:self action:@selector(dialogPauseQuitButtonTapped:) forEvents:UPControlEventTouchUpInside];
//    [self.dialogPause.resumeButton addTarget:self action:@selector(dialogPauseResumeButtonTapped:) forEvents:UPControlEventTouchUpInside];
    self.dialogGameOver.hidden = YES;
    self.dialogGameOver.frame = layout.screen_bounds();

    self.dialogPause = [UPDialogPause instance];
    [self.view addSubview:self.dialogPause];
    [self.dialogPause.quitButton addTarget:self action:@selector(dialogPauseQuitButtonTapped:) forEvents:UPControlEventTouchUpInside];
    [self.dialogPause.resumeButton addTarget:self action:@selector(dialogPauseResumeButtonTapped:) forEvents:UPControlEventTouchUpInside];
    self.dialogPause.hidden = YES;
    self.dialogPause.frame = layout.screen_bounds();

    [self viewOpUpdateGameControls];

    self.pickedView = nil;
    self.pickedPosition = TilePosition();

    self.mode = UPSpellGameModeMenu;
    self.mode = UPSpellGameModeCountdown;
    self.mode = UPSpellGameModePlay;

    delay(RoleGameDelay, 1.0, ^{
        [self.gameTimer start];
    });

    delay(RoleGameDelay, 0.2, ^{
        [self viewOpFillPlayerTray];
    });
}

- (void)dealloc
{
    delete self.model;
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
    [self setMode:UPSpellGameModeOverInterstitial animated:YES];
}

#pragma mark - View mapping

- (NSArray *)wordTrayTileViews
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : self.model->tiles()) {
        if (tile.in_word_tray()) {
            ASSERT(tile.has_view());
            [array addObject:tile.view()];
        }
    }
    return array;
}

- (NSArray *)wordTrayTileViewsExceptPickedView
{
    ASSERT(self.pickedView);
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : self.model->tiles()) {
        if (tile.in_word_tray()) {
            ASSERT(tile.has_view());
            if (tile.view() != self.pickedView) {
                [array addObject:tile.view()];
            }
        }
    }
    return array;
}

#pragma mark - Control target/action and gestures

- (void)dialogPauseQuitButtonTapped:(id)sender
{
}

- (void)dialogPauseResumeButtonTapped:(id)sender
{
    [self setMode:UPSpellGameModePlay animated:YES];
}

- (void)roundButtonPauseTapped:(id)sender
{
    [self setMode:UPSpellGameModePause animated:YES];
}

- (void)roundButtonTrashTapped:(id)sender
{
    [self applyActionDump];
}

- (void)roundButtonClearTapped:(id)sender
{
    [self applyActionClear];
}

- (void)wordTrayTapped
{
    if (self.gameView.wordTrayView.active) {
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
    const Tile &tile = self.model->find_tile(tileView);
    if (tile.in_word_tray()) {
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
    
    const Tile &tile = self.model->find_tile(tileView);
    if (tile.in_word_tray()) {
        [self wordTrayTapped];
    }
    else {
        [self applyActionAdd:tile];
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
            [self applyActionPick:self.model->find_tile(tileView)];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            ASSERT(self.pickedView == tileView);
            SpellLayout &layout = SpellLayout::instance();
            CGPoint t = [pan translationInView:tileView];
            CGPoint newCenter = CGPointMake(self.panStartPoint.x + t.x, self.panStartPoint.y + t.y);
            newCenter = up_point_with_exponential_barrier(newCenter, layout.tile_drag_barrier_frame());
            self.panFurthestDistance = UPMaxT(CGFloat, self.panFurthestDistance, up_point_distance(CGPointZero, t));
            self.panCurrentDistance = up_point_distance(self.panStartPoint, newCenter);
            self.panEverMovedUp = self.panEverMovedUp || [pan velocityInView:tileView].y < 0;
            tileView.center = newCenter;
            BOOL tileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), newCenter);
            Tile &tile = self.model->find_tile(tileView);
            if (tileInsideWordTray) {
                [self applyActionHoverIfNeeded:tile];
            }
            else {
                [self applyActionNoverIfNeeded:tile];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            ASSERT(self.pickedView == tileView);
            SpellLayout &layout = SpellLayout::instance();
            CGPoint v = [pan velocityInView:tileView];
            BOOL pannedFar = self.panFurthestDistance >= 25;
            BOOL putBack = self.panCurrentDistance < 10;
            BOOL movingUp = v.y < -50;
            CGFloat movingDownVelocity = UPMaxT(CGFloat, v.y, 0.0);
            BOOL tileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), tileView.center);
            CGPoint projectedDownCenter = CGPointMake(tileView.center.x, tileView.center.y + (movingDownVelocity * 0.15));
            BOOL projectedTileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), projectedDownCenter);
            LOG(Gestures, "pan ended: f: %.2f ; c: %.2f ; v: %.2f", self.panFurthestDistance, self.panCurrentDistance, v.y);
            LOG(Gestures, "   center:     %@", NSStringFromCGPoint(tileView.center));
            LOG(Gestures, "   projected:  %@", NSStringFromCGPoint(projectedDownCenter));
            LOG(Gestures, "   panned far: %s", pannedFar ? "Y" : "N");
            LOG(Gestures, "   put back:   %s", putBack ? "Y" : "N");
            LOG(Gestures, "   moving up:  %s", movingUp ? "Y" : "N");
            LOG(Gestures, "   ever up:    %s", self.panEverMovedUp ? "Y" : "N");
            LOG(Gestures, "   inside [c]: %s", tileInsideWordTray ? "Y" : "N");
            LOG(Gestures, "   inside [p]: %s", projectedTileInsideWordTray ? "Y" : "N");
            LOG(Gestures, "   move:       %s", projectedTileInsideWordTray ? "Y" : "N");
            LOG(Gestures, "   add:        %s", ((!pannedFar && putBack) || movingUp || !self.panEverMovedUp) ? "Y" : "N");
            Tile &tile = self.model->find_tile(tileView);
            if (self.pickedPosition.in_player_tray()) {
                if (projectedTileInsideWordTray) {
                    [self applyActionAdd:tile];
                }
                else if ((!pannedFar && putBack) || movingUp || !self.panEverMovedUp) {
                    [self applyActionAdd:tile];
                }
                else {
                    [self applyActionDrop:tile];
                }
            }
            else {
                if (projectedTileInsideWordTray) {
                    TilePosition hover_position = [self calculateHoverPosition:tile];
                    if (self.pickedPosition == hover_position) {
                        [self applyActionDrop:tile];
                    }
                    else {
                        [self applyActionMoveTile:tile toPosition:hover_position];
                    }
                }
                else {
                    [self applyActionRemove:tile];
                }
            }
            self.pickedView = nil;
            self.pickedPosition = TilePosition();
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (self.pickedView) {
                ASSERT(self.pickedView == tileView);
                [self applyActionDrop:self.model->find_tile(tileView)];
                self.pickedView = nil;
            }
            break;
        }
    }
}

- (TilePosition)calculateHoverPosition:(const Tile &)tile
{
    ASSERT(tile.has_view());
    UPTileView *tileView = tile.view();
    ASSERT(self.pickedView == tileView);
    ASSERT_POS(self.pickedPosition);

    // find the word position closest to the tile
    size_t word_length = self.pickedPosition.in_word_tray() ? self.model->word_length() : self.model->word_length() + 1;
    
    SpellLayout &layout = SpellLayout::instance();
    const auto &word_tray_tile_centers = layout.word_tray_tile_centers(word_length);
    CGPoint center = tileView.center;
    CGFloat min_d = std::numeric_limits<CGFloat>::max();
    TilePosition pos;
    for (auto it = word_tray_tile_centers.begin(); it != word_tray_tile_centers.end(); ++it) {
        CGFloat d = up_point_distance(center, *it);
        if (d < min_d) {
            min_d = d;
            pos = TilePosition(TileTray::Word, it - word_tray_tile_centers.begin());
        }
    }
    return pos;
}

#pragma mark - Actions

- (void)applyActionAdd:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(tile.in_player_tray());

    cancel(RoleGameDelay);

    NSArray *wordTrayTileViews = [self wordTrayTileViews];

    BOOL needSlide = wordTrayTileViews.count > 0;
    TilePosition word_pos = TilePosition(TileTray::Word, self.model->word_length());
    const State &state = self.model->back_state();
    if (state.action().opcode() == SpellModel::Opcode::HOVER) {
        word_pos = state.action().pos1();
        needSlide = NO;
    }

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::ADD, tile.position(), word_pos));

    SpellLayout &layout = SpellLayout::instance();
    if (needSlide) {
        start(slide(RoleGameUI, wordTrayTileViews, 0.15, layout.word_tray_tile_offset(), nil));
    }
    
    const auto &word_tray_tile_centers = layout.word_tray_tile_centers(self.model->word_length());
    CGPoint word_tray_center = word_tray_tile_centers[word_pos.index()];
    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    start(bloop(RoleGameUI, @[tileView], 0.4, word_tray_center, nil));

    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionRemove:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView);
    ASSERT_POS(self.pickedPosition);

    cancel(RoleGameDelay);

    UPTileView *tileView = tile.view();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REMOVE, tile.position()));

    [self viewOpSlideWordTrayViewsIntoPlace];

    SpellLayout &layout = SpellLayout::instance();
    const auto &player_tray_tile_centers = layout.player_tray_tile_centers();
    CGPoint center = player_tray_tile_centers[self.model->player_tray_index(tileView)];
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    start(bloop(RoleGameUI, @[tileView], 0.4, center, nil));

    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionMoveTile:(const Tile &)tile toPosition:(const TilePosition &)position
{
    ASSERT(tile.has_view());
    ASSERT(position.in_word_tray());

    cancel(RoleGameAll);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::MOVE, tile.position(), position));

    [self viewOpSlideWordTrayViewsIntoPlace];

    UPTileView *tileView = tile.view();
    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionPick:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView == nil);
    ASSERT_NPOS(self.pickedPosition);

    cancel(RoleGameAll);

    UPTileView *tileView = tile.view();
    [tileView cancelAnimations];

    self.pickedView = tileView;
    self.pickedPosition = tile.position();
    [self viewOpApplyTranslationToFrame:@[self.pickedView]];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::PICK, tile.position()));

    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    CGPoint pointInView = [tileView.pan locationInView:tileView];
    CGPoint center = up_rect_center(tileView.bounds);
    CGFloat dx = center.x - pointInView.x;
    CGFloat dy = center.y - pointInView.y;
    CGPoint pointInSuperview = [tileView.pan locationInView:tileView.superview];
    self.panStartPoint = CGPointMake(pointInSuperview.x + dx, pointInSuperview.y + dy);
    self.panFurthestDistance = 0;
    self.panCurrentDistance = 0;
    self.panEverMovedUp = NO;

    tileView.highlighted = YES;
}

- (void)applyActionHoverIfNeeded:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView == tile.view());
    ASSERT_POS(self.pickedPosition);

    cancel(RoleGameDelay);

    TilePosition hover_pos = [self calculateHoverPosition:tile];
    ASSERT_POS(hover_pos);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::HOVER, hover_pos));

    [self viewOpHover:hover_pos];
}

- (void)applyActionNoverIfNeeded:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView == tile.view());
    ASSERT_POS(self.pickedPosition);

    cancel(RoleGameDelay);

    const State &state = self.model->back_state();
    if (state.action().opcode() != SpellModel::Opcode::HOVER) {
        return;
    }

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::NOVER));

    [self viewOpNover];
    [self viewOpUpdateGameControls];
}

- (void)applyActionDrop:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView == tile.view());
    ASSERT_POS(self.pickedPosition);

    cancel(RoleGameDelay);

    UPTileView *tileView = tile.view();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DROP, self.pickedPosition));

    if (self.pickedPosition.in_word_tray()) {
        SpellLayout &layout = SpellLayout::instance();
        const auto &word_tray_tile_centers = layout.word_tray_tile_centers(self.model->word_length());
        CGPoint tile_center = word_tray_tile_centers[self.pickedPosition.index()];
        start(bloop(RoleGameUI, @[tileView], 0.4, tile_center, nil));
    }
    else {
        SpellLayout &layout = SpellLayout::instance();
        const auto &player_tray_tile_centers = layout.player_tray_tile_centers();
        CGPoint tile_center = player_tray_tile_centers[self.model->player_tray_index(tileView)];
        start(bloop(RoleGameUI, @[tileView], 0.4, tile_center, nil));
    }

    tileView.highlighted = NO;

    [self viewOpUpdateGameControls];
}

- (void)applyActionClear
{
    cancel(RoleGameDelay);
    cancel(RoleGameUI);

    [self viewOpApplyTranslationToFrame:[self wordTrayTileViews]];
    [self viewOpClearWordTray];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::CLEAR));
    [self viewOpUpdateGameControls];
}

- (void)applyActionSubmit
{
    cancel(RoleGameDelay);

    [self viewOpScoreWord];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::SUBMIT));
    delay(RoleGameDelay, 0.25, ^{
        [self viewOpFillPlayerTray];
        [self viewOpUpdateGameControls];
    });
}

- (void)applyActionReject
{
    cancel(RoleGameDelay);

    [self viewOpLockUserInterface];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REJECT));

    // assess time penalty and shake word tray side-to-side
    [self viewOpPenaltyForReject:self.model->all_tile_views()];
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.gameView.wordTrayView];
    [views addObjectsFromArray:[self wordTrayTileViews]];
    start(shake(RoleGameUI, views, 0.9, layout.word_tray_shake_offset(), ^(UIViewAnimatingPosition) {
        delay(RoleGameDelay, 0.25, ^{
            [self viewOpPenaltyFinished];
            delay(RoleGameDelay, 0.1, ^{
                [self applyActionClear];
                [self viewOpUnlockUserInterface];
            });
        });
    }));
}

- (void)applyActionDump
{
    ASSERT(self.wordTrayTileViews.count == 0);

    cancel(RoleGameDelay);

    [self viewOpLockUserInterface];

    NSArray *playerTrayTileViews = self.model->player_tray_tile_views();
    ASSERT(playerTrayTileViews.count == TileCount);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [self viewOpPenaltyForDump:playerTrayTileViews];
    [self viewOpDumpPlayerTray:playerTrayTileViews];
    delay(RoleGameDelay, 1.65, ^{
        [self viewOpFillPlayerTrayWithPostFillOp:^{
            [self viewOpPenaltyFinished];
        } completion:^{
            [self viewOpUnlockUserInterface];
        }];
    });
}

#pragma mark - View ops

- (void)viewOpUpdateGameControls
{
    // word tray
    self.gameView.wordTrayView.active = self.model->word_in_lexicon();

    // trash/clear button
    if (self.model->word_length()) {
        self.showingRoundButtonClear = YES;
        self.gameView.roundButtonClear.hidden = NO;
        self.gameView.roundButtonTrash.hidden = YES;
    }
    else {
        self.showingRoundButtonClear = NO;
        self.gameView.roundButtonClear.hidden = YES;
        self.gameView.roundButtonTrash.hidden = NO;
    }
    
    self.gameView.scoreLabel.string = [NSString stringWithFormat:@"%d", self.model->score()];
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

- (void)viewOpSlideWordTrayViewsIntoPlace
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    SpellLayout &layout = SpellLayout::instance();
    size_t word_length = self.model->word_length();
    const auto &word_tray_tile_centers = layout.word_tray_tile_centers(word_length);

    for (UPTileView *tileView in wordTrayTileViews) {
        const Tile &tile = self.model->find_tile(tileView);
        TileIndex idx = tile.position().index();
        CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
        start(slide_to(RoleGameUI, @[tileView], 0.2, word_tray_tile_center, nil));
    }
}

- (void)viewOpHover:(const TilePosition &)hover_pos
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    [self viewOpApplyTranslationToFrame:wordTrayTileViews];

    SpellLayout &layout = SpellLayout::instance();
    size_t word_length = self.pickedPosition.in_word_tray() ? self.model->word_length() : self.model->word_length() + 1;
    const auto &word_tray_tile_centers = layout.word_tray_tile_centers(word_length);

    if (self.pickedPosition.in_player_tray()) {
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
            if (idx >= hover_pos.index()) {
                word_tray_tile_center = word_tray_tile_centers[idx + 1];
            }
            start(slide_to(RoleGameUI, @[tileView], 0.2, word_tray_tile_center, nil));
        }
    }
    else {
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
            if (idx < self.pickedPosition.index() && hover_pos.index() <= idx) {
                word_tray_tile_center = word_tray_tile_centers[idx + 1];
            }
            else if (idx > self.pickedPosition.index() && hover_pos.index() >= idx) {
                word_tray_tile_center = word_tray_tile_centers[idx - 1];
            }
            start(slide_to(RoleGameUI, @[tileView], 0.2, word_tray_tile_center, nil));
        }
    }
}

- (void)viewOpNover
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    [self viewOpApplyTranslationToFrame:wordTrayTileViews];

    SpellLayout &layout = SpellLayout::instance();
    size_t word_length = self.pickedPosition.in_word_tray() ? self.model->word_length() - 1 : self.model->word_length();
    const auto &word_tray_tile_centers = layout.word_tray_tile_centers(word_length);

    if (self.pickedPosition.in_player_tray()) {
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
            start(slide_to(RoleGameUI, @[tileView], 0.2, word_tray_tile_center, nil));
        }
    }
    else {
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
            if (idx > self.pickedPosition.index()) {
                word_tray_tile_center = word_tray_tile_centers[idx - 1];
            }
            start(slide_to(RoleGameUI, @[tileView], 0.2, word_tray_tile_center, nil));
        }
    }
}

- (void)viewOpClearWordTray
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    ASSERT(wordTrayTileViews.count > 0);

    SpellLayout &layout = SpellLayout::instance();
    const auto &player_tray_tile_centers = layout.player_tray_tile_centers();
    
    for (UPTileView *tileView in wordTrayTileViews) {
        TileIndex idx = self.model->player_tray_index(tileView);
        CGPoint player_tray_center = player_tray_tile_centers[idx];
        start(bloop(RoleGameUI, @[tileView], 0.4, player_tray_center, nil));
    }
}

- (void)viewOpScoreWord
{
    SpellLayout &layout = SpellLayout::instance();

    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    
    for (UPTileView *tileView in wordTrayTileViews) {
        tileView.userInteractionEnabled = NO;
        [tileView clearGestures];
    }

    CGPoint slidePoint = CGPointMake(UP::NotACoordinate, layout.score_tile_center_y());
    UPAnimator *slideAnimator = slide_to(RoleGameUI, wordTrayTileViews, 0.1, slidePoint, ^(UIViewAnimatingPosition) {
        LOG(Leaks, "views [1]: %@", self.gameView.tileContainerView.subviews);
        [wordTrayTileViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        LOG(Leaks, "views [2]: %@", self.gameView.tileContainerView.subviews);
    });

    UIOffset springOffset = UIOffsetMake(0, layout.score_tile_spring_down_offset_y());
    UPAnimator *springAnimator = spring(RoleGameUI, wordTrayTileViews, 0.13, springOffset, ^(UIViewAnimatingPosition) {
        start(slideAnimator);
    });
    
    start(springAnimator);
}

- (void)viewOpDumpPlayerTray:(NSArray *)playerTrayTileViews
{
    SpellLayout &layout = SpellLayout::instance();
    Random &random = Random::instance();
    const auto &offscreen_tray_tile_centers = layout.prefill_tile_centers();

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
        UPAnimator *animator = slide(RoleGameUI, @[tileView], 1.1, offset, ^(UIViewAnimatingPosition) {
            [tileView removeFromSuperview];
        });
        delay(RoleGameDelay, count * baseDelay, ^{
            start(animator);
        });
        count++;
    }
}

- (void)viewOpFillPlayerTray
{
    [self viewOpFillPlayerTrayWithPostFillOp:nil completion:nil];
}

- (void)viewOpFillPlayerTrayWithPostFillOp:(void (^)(void))postFillOp completion:(void (^)(void))completion
{
    SpellLayout &layout = SpellLayout::instance();
    const auto &prefill_tile_frames = layout.prefill_tile_frames();
    const auto &player_tray_tile_centers = layout.player_tray_tile_centers();

    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        if (tile.has_view<false>()) {
            UPTileView *tileView = [UPTileView viewWithGlyph:tile.model().glyph() score:tile.model().score() multiplier:tile.model().multiplier()];
            tile.set_view(tileView);
            tileView.role = RoleGameUI;
            tileView.gestureDelegate = self;
            tileView.frame = prefill_tile_frames[idx];
            [self.gameView.tileContainerView addSubview:tileView];
            start(bloop(RoleGameUI, @[tileView], 0.3, player_tray_tile_centers[idx], nil));
        }
        idx++;
    }

    if (postFillOp) {
        postFillOp();
    }

    // FIXME: make it possible to bloop views to their respective points as a collection
    delay(RoleGameDelay, 0.3, ^{
        if (completion) {
            completion();
        }
    });
}

- (void)viewOpPenaltyForDump:(NSArray *)tileViews
{
    ASSERT(!self.view.userInteractionEnabled);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.roundButtonTrash.highlightedOverride = YES;
    self.gameView.roundButtonTrash.highlighted = YES;
    self.gameView.wordTrayView.alpha = disabledAlpha;
    self.gameView.roundButtonPause.alpha = disabledAlpha;
    for (UPTileView *tileView in tileViews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyForReject:(NSArray *)tileViews
{
    ASSERT(!self.view.userInteractionEnabled);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.wordTrayView.alpha = disabledAlpha;
    self.gameView.roundButtonPause.alpha = disabledAlpha;
    self.gameView.roundButtonClear.alpha = disabledAlpha;
    for (UPTileView *tileView in tileViews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyFinished
{
    ASSERT(!self.view.userInteractionEnabled);
    self.gameView.roundButtonTrash.highlightedOverride = NO;
    self.gameView.roundButtonTrash.highlighted = NO;
    self.gameView.wordTrayView.alpha = 1.0;
    self.gameView.roundButtonPause.alpha = 1.0;
    if (self.showingRoundButtonClear) {
        self.gameView.roundButtonClear.alpha = 1.0;
    }
    else {
        self.gameView.roundButtonTrash.alpha = 1.0;
    }
    NSArray *playerTrayTileViews = self.model->all_tile_views();
    for (UPTileView *tileView in playerTrayTileViews) {
        tileView.alpha = 1.0;
    }
}

- (void)viewOpEnterModal:(UPSpellGameMode)mode
{
    const CGFloat alpha = [UIColor themeModalBackgroundAlpha];
    if (mode == UPSpellGameModePause) {
        self.gameView.roundButtonPause.highlightedOverride = YES;
        self.gameView.roundButtonPause.highlighted = YES;
        self.gameView.roundButtonPause.alpha = [UIColor themeModalActiveAlpha];
        self.gameView.gameTimerLabel.alpha = alpha;
        self.gameView.scoreLabel.alpha = alpha;
    }
    else if (mode == UPSpellGameModeOverInterstitial) {
        self.gameView.roundButtonPause.alpha = alpha;
    }
    else {
        self.gameView.gameTimerLabel.alpha = alpha;
        self.gameView.scoreLabel.alpha = alpha;
        self.gameView.roundButtonPause.alpha = alpha;
    }
    if (self.showingRoundButtonClear) {
        self.gameView.roundButtonClear.alpha = alpha;
    }
    else {
        self.gameView.roundButtonTrash.alpha = alpha;
    }
    self.gameView.wordTrayView.alpha = alpha;

    self.gameView.wordTrayView.userInteractionEnabled = NO;
    self.gameView.roundButtonTrash.userInteractionEnabled = NO;
    self.gameView.roundButtonClear.userInteractionEnabled = NO;
    self.gameView.roundButtonPause.userInteractionEnabled = NO;

    for (UPTileView *tileView in self.model->all_tile_views()) {
        tileView.alpha = alpha;
        tileView.userInteractionEnabled = NO;
    }
}

- (void)viewOpExitModal
{
    self.gameView.roundButtonPause.highlightedOverride = NO;
    self.gameView.roundButtonPause.highlighted = NO;
    self.gameView.roundButtonPause.alpha = 1.0;

    self.gameView.wordTrayView.alpha = 1.0;
    if (self.showingRoundButtonClear) {
        self.gameView.roundButtonClear.alpha = 1.0;
    }
    else {
        self.gameView.roundButtonTrash.alpha = 1.0;
    }
    self.gameView.gameTimerLabel.alpha = 1.0;
    self.gameView.scoreLabel.alpha = 1.0;

    self.gameView.wordTrayView.userInteractionEnabled = YES;
    self.gameView.roundButtonTrash.userInteractionEnabled = YES;
    self.gameView.roundButtonClear.userInteractionEnabled = YES;
    self.gameView.roundButtonPause.userInteractionEnabled = YES;

    for (UPTileView *tileView in self.model->all_tile_views()) {
        tileView.alpha = 1.0;
        tileView.userInteractionEnabled = YES;
    }
}

- (void)viewOpLockUserInterface
{
    self.userInterfaceLockCount++;
    self.view.userInteractionEnabled = NO;
}

- (void)viewOpUnlockUserInterface
{
    ASSERT(self.userInterfaceLockCount > 0);
    self.userInterfaceLockCount = UPMaxT(NSInteger, self.userInterfaceLockCount - 1, 0);
    if (self.userInterfaceLockCount == 0) {
        self.view.userInteractionEnabled = YES;
    }
}

#pragma mark - Modes

- (void)setMode:(UPSpellGameMode)mode
{
    [self setMode:mode animated:NO];
}

- (void)setMode:(UPSpellGameMode)mode animated:(BOOL)animated
{
    if (_mode == mode) {
        return;
    }
    UPSpellGameMode prev = _mode;
    
    switch (prev) {
        case UPSpellGameModeStart: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModeCountdown:
                case UPSpellGameModePlay:
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModeMenu:
                    [self modeTransitionFromNoneToMenu:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModeOffscreenLeft: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModeCountdown:
                case UPSpellGameModePlay:
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModeMenu:
                    [self modeTransitionFromOffscreenLeftToMenu:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModeOffscreenRight: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModeCountdown:
                case UPSpellGameModePlay:
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModeMenu:
                    [self modeTransitionFromOffscreenRightToMenu:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModeMenu: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeMenu:
                case UPSpellGameModePlay:
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModeOffscreenLeft:
                    [self modeTransitionFromMenuToOffscreenLeft:animated];
                    break;
                case UPSpellGameModeOffscreenRight:
                    [self modeTransitionFromMenuToOffscreenRight:animated];
                    break;
                case UPSpellGameModeCountdown:
                    [self modeTransitionFromMenuToCountdown:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModeCountdown: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModeMenu:
                case UPSpellGameModeCountdown:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModePlay:
                    [self modeTransitionFromCountdownToPlay:animated];
                    break;
                case UPSpellGameModePause:
                    [self modeTransitionFromCountdownToPause:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModePlay: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModeMenu:
                case UPSpellGameModeCountdown:
                case UPSpellGameModePlay:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModePause:
                    [self modeTransitionFromPlayToPause:animated];
                    break;
                case UPSpellGameModeOverInterstitial:
                    [self modeTransitionFromPlayToOverInterstitial:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModePause: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModeCountdown:
                    [self modeTransitionFromPauseToCountdown:animated];
                    break;
                case UPSpellGameModeMenu:
                    [self modeTransitionFromPauseToMenu:animated];
                    break;
                case UPSpellGameModePlay:
                    [self modeTransitionFromPauseToPlay:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModeOverInterstitial: {
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModeMenu:
                case UPSpellGameModeCountdown:
                case UPSpellGameModePlay:
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModeOver:
                    [self modeTransitionFromOverInterstitialToOver:animated];
                    break;
            }
            break;
        }
        case UPSpellGameModeOver:
            switch (mode) {
                case UPSpellGameModeStart:
                case UPSpellGameModeOffscreenLeft:
                case UPSpellGameModeOffscreenRight:
                case UPSpellGameModePlay:
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModeMenu:
                    [self modeTransitionFromOverToMenu:animated];
                    break;
                case UPSpellGameModeCountdown:
                    [self modeTransitionFromOverToCountdown:animated];
                    break;
            }
            break;
    }

    // Change the mode
    _mode = mode;
}

- (void)modeTransitionFromNoneToMenu:(BOOL)animated
{
}

- (void)modeTransitionFromMenuToOffscreenLeft:(BOOL)animated
{
}

- (void)modeTransitionFromMenuToOffscreenRight:(BOOL)animated
{
}

- (void)modeTransitionFromOffscreenLeftToMenu:(BOOL)animated
{
}

- (void)modeTransitionFromOffscreenRightToMenu:(BOOL)animated
{
}

- (void)modeTransitionFromMenuToCountdown:(BOOL)animated
{
}

- (void)modeTransitionFromCountdownToPause:(BOOL)animated
{
}

- (void)modeTransitionFromPauseToCountdown:(BOOL)animated
{
}

- (void)modeTransitionFromCountdownToPlay:(BOOL)animated
{
}

- (void)modeTransitionFromPlayToPause:(BOOL)animated
{
    [self.gameTimer stop];
    pause(RoleGameAll);
    [self viewOpLockUserInterface];
    [UIView animateWithDuration:0.1 animations:^{
        [self viewOpEnterModal:UPSpellGameModePause];
    }];
    CGPoint center = self.view.center;
    CGPoint offscreenCenter = CGPointMake(center.x, center.y + (up_rect_height(self.view.bounds) * 0.5));
    self.dialogPause.center = offscreenCenter;
    self.dialogPause.transform = CGAffineTransformIdentity;
    self.dialogPause.hidden = NO;
    self.dialogPause.alpha = 1.0;
    start(bloop(RoleModeUI, @[self.dialogPause], 0.3, center, ^(UIViewAnimatingPosition) {
        [self viewOpUnlockUserInterface];
    }));
}

- (void)modeTransitionFromPauseToPlay:(BOOL)animated
{
    SpellLayout &layout = SpellLayout::instance();

    [self viewOpLockUserInterface];
    CGPoint center = self.dialogPause.center;
    CGPoint offscreenCenter = CGPointMake(center.x, center.y + (up_rect_height(self.view.bounds) * 0.5));

    UPAnimator *slideAnimator = slide_to(RoleModeUI, @[self.dialogPause], 0.15, offscreenCenter, ^(UIViewAnimatingPosition) {
        self.dialogPause.center = self.view.center;
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            [self viewOpExitModal];
        } completion:^(BOOL finished) {
            [self.gameTimer start];
            start(RoleGameDelay);
            start(RoleGameUI);
            self.gameView.roundButtonPause.highlightedOverride = NO;
            self.gameView.roundButtonPause.highlighted = NO;
            [self viewOpUnlockUserInterface];
        }];
    });

    UIOffset springOffset = UIOffsetMake(0, layout.dialog_spring_dismiss_offset_y());
    UPAnimator *springAnimator = spring(RoleModeUI, @[self.dialogPause], 0.13, springOffset, ^(UIViewAnimatingPosition) {
        start(slideAnimator);
    });

    start(springAnimator);
}

- (void)modeTransitionFromPauseToMenu:(BOOL)animated
{
}

- (void)modeTransitionFromPlayToOverInterstitial:(BOOL)animated
{
    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.titlePathView.frame = layout.dialog_over_interstitial_title_layout_frame();
    self.dialogGameOver.menuButton.frame = layout.dialog_over_interstitial_button_left_frame();
    self.dialogGameOver.playButton.frame = layout.dialog_over_interstitial_button_right_frame();
    self.dialogGameOver.noteLabel.frame = layout.dialog_over_interstitial_note_label_frame();
    self.dialogGameOver.menuButton.hidden = YES;
    self.dialogGameOver.playButton.hidden = YES;
    self.dialogGameOver.noteLabel.hidden = YES;

    cancel(RoleGameAll);
    [self viewOpLockUserInterface];

    [UIView animateWithDuration:0.1 animations:^{
        [self viewOpEnterModal:UPSpellGameModeOverInterstitial];
    }];
    CGPoint center = self.view.center;
    CGPoint offscreenCenter = CGPointMake(center.x, center.y + (up_rect_height(self.view.bounds) * 0.5));
    self.dialogGameOver.center = offscreenCenter;
    self.dialogGameOver.transform = CGAffineTransformIdentity;
    self.dialogGameOver.hidden = NO;
    self.dialogGameOver.alpha = 1.0;
    start(bloop(RoleModeUI, @[self.dialogGameOver], 0.3, center, ^(UIViewAnimatingPosition) {
        delay(RoleModeUI, 1.0, ^{
            [self setMode:UPSpellGameModeOver animated:YES];
        });
    }));
}

- (void)modeTransitionFromOverInterstitialToOver:(BOOL)animated
{
    [self viewOpUnlockUserInterface];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.titlePathView.frame = layout.dialog_over_interstitial_title_layout_frame();
    self.dialogGameOver.menuButton.frame = layout.dialog_over_interstitial_button_left_frame();
    self.dialogGameOver.playButton.frame = layout.dialog_over_interstitial_button_right_frame();
    self.dialogGameOver.noteLabel.frame = layout.dialog_over_interstitial_note_label_frame();
    self.dialogGameOver.menuButton.hidden = NO;
    self.dialogGameOver.playButton.hidden = NO;
    self.dialogGameOver.noteLabel.hidden = NO;

    CGPoint menuButtonCenter = up_rect_center(layout.dialog_over_button_left_frame());
    CGPoint playButtonCenter = up_rect_center(layout.dialog_over_button_right_frame());
    CGPoint noteLabelCenter = up_rect_center(layout.dialog_over_note_label_frame());
    CGPoint scoreLabelCenter = up_rect_center(layout.calculate_game_over_score_label_frame(self.gameView.scoreLabel.string));
    start(slide_to(RoleModeUI, @[self.dialogGameOver.menuButton], 0.75, menuButtonCenter, nil));
    start(slide_to(RoleModeUI, @[self.dialogGameOver.playButton], 0.75, playButtonCenter, nil));
    start(slide_to(RoleModeUI, @[self.dialogGameOver.noteLabel], 0.75, noteLabelCenter, nil));
    start(fade(RoleModeUI, @[self.gameView.gameTimerLabel], 0.3, nil));
    start(slide_to(RoleModeUI, @[self.gameView.scoreLabel], 0.75, scoreLabelCenter, nil));
}

- (void)modeTransitionFromOverToCountdown:(BOOL)animated
{
}

- (void)modeTransitionFromOverToMenu:(BOOL)animated
{
}

@end
