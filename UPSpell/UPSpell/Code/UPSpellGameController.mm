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
#import "UPDialogGameNote.h"
#import "UPDialogGameOver.h"
#import "UPDialogMenu.h"
#import "UPDialogPause.h"
#import "UPSceneDelegate.h"
#import "UPSpellGameView.h"
#import "UPSpellLayout.h"
#import "UPTileModel.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "UPSpellGameController.h"
#import "UPSpellNavigationController.h"
#import "UPViewMove+UPSpell.h"

using Action = UP::SpellModel::Action;
using Opcode = UP::SpellModel::Opcode;
using State = UP::SpellModel::State;
using TileIndex = UP::TileIndex;
using TilePosition = UP::TilePosition;
using TileTray = UP::TileTray;

using UP::GameKey;
using UP::Lexicon;
using UP::ModeTransition;
using UP::Random;
using UP::SpellLayout;
using UP::SpellModel;
using UP::Tile;
using UP::TileModel;
using UP::TileCount;
using UP::TilePaths;
using UP::TileSequence;
using UP::valid;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;
using UP::TimeSpanning::fade;
using UP::TimeSpanning::shake;
using UP::TimeSpanning::slide;

using UP::TimeSpanning::cancel_all;
using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::find_move;
using UP::TimeSpanning::pause_all;
using UP::TimeSpanning::pause;
using UP::TimeSpanning::start_all;
using UP::TimeSpanning::start;

using UP::BandGameAll;
using UP::BandGameDelay;
using UP::BandGameUI;
using UP::BandGameUITile;
using UP::BandGameUITileSlide;
using UP::BandModeAll;
using UP::BandModeDelay;
using UP::BandModeUI;

using UP::role_in_player_tray;
using UP::role_in_word;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;
using Mode = UP::Mode;
using ModeTransitionTable = UP::ModeTransitionTable;

@interface UPSpellGameController () <UPGameTimerObserver>
{
    ModeTransitionTable m_default_transition_table;
    ModeTransitionTable m_did_become_active_transition_table;
    ModeTransitionTable m_will_enter_foreground_transition_table;
    ModeTransitionTable m_will_resign_active_transition_table;
    ModeTransitionTable m_did_enter_background_transition_table;
}
@property (nonatomic) SpellModel *model;
@property (nonatomic) UPSpellGameView *gameView;
@property (nonatomic) UPGameTimer *gameTimer;
@property (nonatomic) BOOL showingWordScoreLabel;
@property (nonatomic) UPDialogGameOver *dialogGameOver;
@property (nonatomic) UPDialogGameNote *dialogGameNote;
@property (nonatomic) UPDialogPause *dialogPause;
@property (nonatomic) UPDialogMenu *dialogMenu;
@property (nonatomic) NSInteger lockCount;

@property (nonatomic) UITouch *activeTouch;
@property (nonatomic) UPControl *touchedControl;
@property (nonatomic) UPTileView *touchedTileView;
@property (nonatomic) UPTileView *pickedTileView;
@property (nonatomic) TilePosition pickedTilePosition;

@property (nonatomic) CGPoint activeTouchStartPoint;          // in window coordinates
@property (nonatomic) CGPoint activeTouchPoint;               // in window coordinates
@property (nonatomic) CGPoint activeTouchPreviousPoint;       // in window coordinates
@property (nonatomic) CGPoint activeTouchTranslation;         // as a point representing total distance
@property (nonatomic) CGPoint activeTouchVelocity;            // as a point representing points/second
@property (nonatomic) CGPoint activeTouchPanStartPoint;       // in superview coordinates
@property (nonatomic) CGPoint activeTouchPanPoint;            // in superview coordinates
@property (nonatomic) CGFloat activeTouchCurrentPanDistance;
@property (nonatomic) CGFloat activeTouchTotalPanDistance;
@property (nonatomic) CGFloat activeTouchFurthestPanDistance;
@property (nonatomic) BOOL activeTouchPanEverMovedUp;
@property (nonatomic) CFTimeInterval activeTouchPreviousTimestamp;

@end

static constexpr CFTimeInterval DefaultBloopDuration = 0.2;
static constexpr CFTimeInterval DefaultTileSlideDuration = 0.1;
static constexpr CFTimeInterval GameOverInOutBloopDuration = 0.5;
static constexpr CFTimeInterval GameOverRespositionBloopDelay = 0.4;
static constexpr CFTimeInterval GameOverRespositionBloopDuration = 0.85;

@implementation UPSpellGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SpellLayout &layout = SpellLayout::instance();

    self.gameView = [UPSpellGameView instance];
    [self.view addSubview:self.gameView];

    self.gameTimer = [UPGameTimer defaultGameTimer];
    [self.gameTimer addObserver:self.gameView.timerLabel];
    [self.gameTimer addObserver:self];
    [self.gameTimer notifyObservers];

    self.dialogGameOver = [UPDialogGameOver instance];
    [self.view addSubview:self.dialogGameOver];
    self.dialogGameOver.hidden = YES;
    self.dialogGameOver.frame = layout.screen_bounds();

    self.dialogGameNote = [UPDialogGameNote instance];
    [self.view addSubview:self.dialogGameNote];
    self.dialogGameNote.hidden = YES;
    self.dialogGameNote.frame = layout.screen_bounds();

    self.dialogMenu = [UPDialogMenu instance];
    self.dialogMenu.hidden = YES;
    self.dialogMenu.frame = layout.screen_bounds();

    self.dialogPause = [UPDialogPause instance];
    [self.view addSubview:self.dialogPause];
    [self.dialogPause.quitButton setTarget:self action:@selector(dialogPauseQuitButtonTapped:)];
    [self.dialogPause.resumeButton setTarget:self action:@selector(dialogPauseResumeButtonTapped:)];
    self.dialogPause.hidden = YES;
    self.dialogPause.frame = layout.screen_bounds();

    self.touchedTileView = nil;
    self.pickedTileView = nil;
    self.pickedTilePosition = TilePosition();

    [self configureModeTransitionTables];
    [self configureLifecycleNotifications];

    [self setMode:Mode::Init];
}

- (void)dealloc
{
    delete self.model;
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return self.mode == Mode::Play ? UIRectEdgeAll : UIRectEdgeNone;
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.gameView updateThemeColors];
    [self.dialogGameOver updateThemeColors];
    [self.dialogGameNote updateThemeColors];
    [self.dialogPause updateThemeColors];
}

#pragma mark - UPSpellNavigationController

- (UPSpellNavigationController *)spellNavigationController
{
    if ([self.navigationController isKindOfClass:[UPSpellNavigationController class]]) {
        return (UPSpellNavigationController *)self.navigationController;
    }
    return nil;
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
    [self setMode:Mode::GameOver];
}

- (void)gameTimerCanceled:(UPGameTimer *)gameTimer
{
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
    ASSERT(self.pickedTileView);
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : self.model->tiles()) {
        if (tile.in_word_tray()) {
            ASSERT(tile.has_view());
            if (tile.view() != self.pickedTileView) {
                [array addObject:tile.view()];
            }
        }
    }
    return array;
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.lockCount > 0) {
        if (self.touchedControl) {
            [self preemptTouchedControl];
        }
        return;
    }

    UPControl *incomingTouchedControl = self.touchedControl;
    
    for (UITouch *touch in touches) {
        if (touch != self.activeTouch) {
            CGPoint point = [touch locationInView:self.gameView];
            UPControl *hitControl = [self hitTestGameView:point withEvent:event];
            if (hitControl) {
                if (self.touchedControl && hitControl != self.touchedControl && hitControl != self.gameView.wordTrayControl) {
                    [self preemptTouchedControl];
                }
                self.touchedControl = hitControl;
                self.activeTouch = touch;
                self.touchedTileView = [self hitTestTileViews:point withEvent:event];
                self.touchedControl.highlighted = YES;
                break;
            }
        }
    }

    if (!self.activeTouch) {
        ASSERT(self.touchedControl == nil);
        ASSERT(self.pickedTileView == nil);
        return;
    }
    
    if (self.touchedControl && self.touchedControl != incomingTouchedControl) {
        [self resetActiveTouchTracking];
        if ([self.touchedControl isKindOfClass:[UPTileView class]]) {
            UPTileView *tileView = (UPTileView *)self.touchedControl;
            Tile &tile = self.model->find_tile(tileView);
            [self applyActionPick:tile];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.lockCount > 0) {
        if (self.touchedControl) {
            [self preemptTouchedControl];
        }
        return;
    }

    BOOL movedTouchIsActive = NO;
    for (UITouch *touch in touches) {
        if (touch == self.activeTouch) {
            movedTouchIsActive = YES;
            break;
        }
    }
    if (!movedTouchIsActive) {
        return;
    }

    self.activeTouchPoint = [self.activeTouch locationInView:self.touchedControl.window];
    CGFloat tx = self.activeTouchPoint.x - self.activeTouchStartPoint.x;
    CGFloat ty = self.activeTouchPoint.y - self.activeTouchStartPoint.y;
    self.activeTouchTranslation = CGPointMake(tx, ty);
    
    CGFloat dx = self.activeTouchPoint.x - self.activeTouchPreviousPoint.x;
    CGFloat dy = self.activeTouchPoint.y - self.activeTouchPreviousPoint.y;
    
    self.activeTouchPanPoint = CGPointMake(self.activeTouchPanStartPoint.x + tx, self.activeTouchPanStartPoint.y + ty);
    self.activeTouchTotalPanDistance += up_point_distance(self.activeTouchPoint, self.activeTouchPreviousPoint);
    self.activeTouchCurrentPanDistance = up_point_distance(self.activeTouchPoint, self.activeTouchStartPoint);
    self.activeTouchFurthestPanDistance = UPMaxT(CGFloat, self.activeTouchFurthestPanDistance, self.activeTouchCurrentPanDistance);
    
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval elapsed = now - self.activeTouchPreviousTimestamp;
    CGFloat vx = dx / elapsed;
    CGFloat vy = dy / elapsed;
    CGFloat avx = (self.activeTouchVelocity.x * 0.6) + (vx * 0.4);
    CGFloat avy = (self.activeTouchVelocity.y * 0.6) + (vy * 0.4);
    self.activeTouchVelocity = CGPointMake(avx, avy);
    self.activeTouchPreviousPoint = self.activeTouchPoint;
    self.activeTouchPreviousTimestamp = now;
    self.activeTouchPanEverMovedUp = self.activeTouchPanEverMovedUp || avy < 0;

    if (self.touchedControl == self.gameView.pauseControl ||
        self.touchedControl == self.gameView.clearControl ||
        self.touchedControl == self.gameView.wordTrayControl) {
        CGPoint point = [self.activeTouch locationInView:self.touchedControl];
        if ([self.touchedControl pointInside:point withEvent:event]) {
            self.touchedControl.highlighted = YES;
        }
        else {
            self.touchedControl.highlighted = NO;
        }
    }
    
    if (self.touchedControl == self.gameView.wordTrayControl && self.touchedTileView && self.activeTouchCurrentPanDistance > 25) {
        ASSERT(self.model->word_length() > 0);
        ASSERT(self.pickedTileView == nil);
        self.gameView.wordTrayControl.highlighted = NO;
        self.touchedTileView.highlighted = YES;
        self.touchedControl = self.touchedTileView;
        [self resetActiveTouchTracking];
        Tile &tile = self.model->find_tile(self.touchedTileView);
        [self applyActionPick:tile];
    }
    
    if ([self.touchedControl isKindOfClass:[UPTileView class]]) {
        UPTileView *tileView = (UPTileView *)self.touchedControl;
        if (self.pickedTileView) {
            ASSERT(self.pickedTileView == tileView);
            SpellLayout &layout = SpellLayout::instance();
            tileView.center = up_point_with_exponential_barrier(self.activeTouchPanPoint, layout.tile_drag_barrier_frame());
            BOOL tileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), self.activeTouchPanPoint);
            Tile &tile = self.model->find_tile(tileView);
            if (tileInsideWordTray) {
                [self applyActionHoverIfNeeded:tile];
            }
            else {
                [self applyActionNoverIfNeeded:tile];
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.lockCount > 0) {
        if (self.touchedControl) {
            [self preemptTouchedControl];
        }
        return;
    }

    BOOL endedTouchIsActive = NO;
    for (UITouch *touch in touches) {
        if (touch == self.activeTouch) {
            endedTouchIsActive = YES;
            break;
        }
    }
    if (!endedTouchIsActive) {
        return;
    }
        
    if (self.touchedControl == self.gameView.pauseControl ||
        self.touchedControl == self.gameView.clearControl ||
        self.touchedControl == self.gameView.wordTrayControl) {
        if (self.touchedControl.highlighted) {
            [self sendControlAction:self.touchedControl];
        }
    }
    else if ([self.touchedControl isKindOfClass:[UPTileView class]]) {
        UPTileView *tileView = (UPTileView *)self.touchedControl;
        [self touchEndedInTileView:tileView];
    }
    
    self.touchedControl.highlighted = NO;
    self.touchedTileView = nil;
    self.pickedTileView = nil;
    self.pickedTilePosition = TilePosition();
    self.touchedControl = nil;
    self.activeTouch = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelActiveTouch];
}

- (void)preemptTouchedControl
{
    ASSERT(self.touchedControl);
    
    if ([self.touchedControl isKindOfClass:[UPTileView class]]) {
        UPTileView *tileView = (UPTileView *)self.touchedControl;
        [self touchEndedInTileView:tileView];
    }
    else if (self.touchedControl == self.gameView.pauseControl ||
             self.touchedControl == self.gameView.clearControl ||
             self.touchedControl == self.gameView.wordTrayControl) {
        if (self.touchedControl.highlighted) {
            [self sendControlAction:self.touchedControl];
        }
    }
    self.touchedControl.highlighted = NO;
    self.touchedTileView = nil;
    self.pickedTileView = nil;
    self.pickedTilePosition = TilePosition();
    self.touchedControl = nil;
    self.activeTouch = nil;
}

- (void)sendControlAction:(UPControl *)control
{
    ASSERT(control == self.gameView.pauseControl || control == self.gameView.clearControl || control == self.gameView.wordTrayControl);
    ASSERT(control.highlighted);
    if (control == self.gameView.pauseControl) {
        [self roundButtonPauseTapped];
    }
    else if (control == self.gameView.clearControl) {
        [self roundButtonClearTapped];
    }
    else if (control == self.gameView.wordTrayControl) {
        [self wordTrayTapped];
    }
}

- (void)resetActiveTouchTracking
{
    CGPoint touchPointInView = [self.activeTouch locationInView:self.touchedControl];
    self.activeTouchPoint = [self.activeTouch locationInView:self.touchedControl.window];
    self.activeTouchStartPoint = self.activeTouchPoint;
    self.activeTouchTranslation = CGPointZero;
    
    self.activeTouchVelocity = CGPointZero;
    self.activeTouchPreviousPoint = self.activeTouchPoint;
    self.activeTouchPreviousTimestamp = CACurrentMediaTime();
    
    CGPoint center = up_rect_center(self.touchedControl.bounds);
    CGFloat dx = center.x - touchPointInView.x;
    CGFloat dy = center.y - touchPointInView.y;
    CGPoint pointInSuperview = [self.touchedControl convertPoint:touchPointInView toView:self.touchedControl.superview];
    self.activeTouchPanStartPoint = CGPointMake(pointInSuperview.x + dx, pointInSuperview.y + dy);
    self.activeTouchPanPoint = self.activeTouchPanStartPoint;
    self.activeTouchTotalPanDistance = 0;
    self.activeTouchFurthestPanDistance = 0;
    self.activeTouchPanEverMovedUp = NO;
}

- (void)touchEndedInTileView:(UPTileView *)tileView
{
    ASSERT(self.pickedTileView == tileView);
    SpellLayout &layout = SpellLayout::instance();
    CGPoint v = self.activeTouchVelocity;
    BOOL pannedFar = self.activeTouchFurthestPanDistance >= 25;
    BOOL putBack = self.activeTouchCurrentPanDistance < 10;
    BOOL movingUp = v.y < -50;
    CGFloat movingDownVelocity = UPMaxT(CGFloat, v.y, 0.0);
    BOOL tileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), tileView.center);
    CGPoint projectedDownCenter = CGPointMake(tileView.center.x, tileView.center.y + (movingDownVelocity * 0.15));
    BOOL projectedTileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), projectedDownCenter);
    LOG(Gestures, "pan ended: f: %.2f ; c: %.2f ; v: %.2f", self.activeTouchFurthestPanDistance, self.activeTouchCurrentPanDistance, v.y);
    LOG(Gestures, "   center:     %@", NSStringFromCGPoint(tileView.center));
    LOG(Gestures, "   projected:  %@", NSStringFromCGPoint(projectedDownCenter));
    LOG(Gestures, "   panned far: %s", pannedFar ? "Y" : "N");
    LOG(Gestures, "   put back:   %s", putBack ? "Y" : "N");
    LOG(Gestures, "   moving up:  %s", movingUp ? "Y" : "N");
    LOG(Gestures, "   ever up:    %s", self.activeTouchPanEverMovedUp ? "Y" : "N");
    LOG(Gestures, "   inside [c]: %s", tileInsideWordTray ? "Y" : "N");
    LOG(Gestures, "   inside [p]: %s", projectedTileInsideWordTray ? "Y" : "N");
    LOG(Gestures, "   move:       %s", projectedTileInsideWordTray ? "Y" : "N");
    LOG(Gestures, "   add:        %s", ((!pannedFar && putBack) || movingUp || !self.activeTouchPanEverMovedUp) ? "Y" : "N");
    Tile &tile = self.model->find_tile(tileView);
    if (self.pickedTilePosition.in_player_tray()) {
        if (projectedTileInsideWordTray) {
            [self applyActionAdd:tile];
        }
        else if ((!pannedFar && putBack) || movingUp || !self.activeTouchPanEverMovedUp) {
            [self applyActionAdd:tile];
        }
        else {
            [self applyActionDrop:tile];
        }
    }
    else {
        if (projectedTileInsideWordTray) {
            TilePosition hover_position = [self calculateHoverPosition:tile];
            if (self.pickedTilePosition == hover_position) {
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
}

- (void)cancelActiveTouch
{
    if ([self.touchedControl isKindOfClass:[UPTileView class]]) {
        UPTileView *tileView = (UPTileView *)self.touchedControl;
        Tile &tile = self.model->find_tile(tileView);
        [self applyActionDrop:tile];
    }
    self.touchedControl.highlighted = NO;
    self.touchedTileView = nil;
    self.pickedTileView = nil;
    self.pickedTilePosition = TilePosition();
    self.touchedControl = nil;
    self.activeTouch = nil;
}

- (UPControl *)hitTestGameView:(CGPoint)point withEvent:(UIEvent *)event
{
    UPControl *wordTrayControl = self.gameView.wordTrayControl;
    CGPoint wordTrayControlPoint = [wordTrayControl convertPoint:point fromView:self.gameView.window];
    if (wordTrayControl.userInteractionEnabled && [wordTrayControl pointInside:wordTrayControlPoint withEvent:event] &&
        self.model->word_length() > 0) {
        return wordTrayControl;
    }
    
    UPControl *pauseControl = self.gameView.pauseControl;
    CGPoint pausePoint = [pauseControl convertPoint:point fromView:self.gameView.window];
    if (pauseControl.userInteractionEnabled && [pauseControl pointInside:pausePoint withEvent:event]) {
        return pauseControl;
    }

    UPControl *clearControl = self.gameView.clearControl;
    CGPoint clearPoint = [clearControl convertPoint:point fromView:self.gameView.window];
    if (clearControl.userInteractionEnabled && [clearControl pointInside:clearPoint withEvent:event]) {
        return clearControl;
    }

    return [self hitTestTileViews:point withEvent:event];
}

- (UPTileView *)hitTestTileViews:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UPTileView *tileView in self.model->all_tile_views()) {
        CGPoint tilePoint = [tileView convertPoint:point fromView:self.gameView.window];
        if (tileView.userInteractionEnabled && [tileView pointInside:tilePoint withEvent:event]) {
            return tileView;
        }
    }
    
    return nil;
}

#pragma mark - Control target/action and gestures

- (void)wordTrayTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
}

- (void)wordTrayTapped
{
    ASSERT(self.mode == Mode::Play);
    
    if (self.gameView.wordTrayControl.active) {
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

- (void)dialogPauseQuitButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::Pause);
    [self setMode:Mode::Quit];
}

- (void)dialogPauseResumeButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::Pause);
    [self setMode:Mode::Play];
}

- (void)roundButtonPauseTapped
{
    ASSERT(self.mode == Mode::Play);
    [self setMode:Mode::Pause];
}

- (void)roundButtonClearTapped
{
    ASSERT(self.mode == Mode::Play);
    if (self.model->word_length()) {
        [self applyActionClear];
    }
    else {
        [self applyActionDump];
    }
}

- (void)tileViewTapped:(UPTileView *)tileView
{
    ASSERT(self.mode == Mode::Play);
    
    const Tile &tile = self.model->find_tile(tileView);
    if (tile.in_word_tray()) {
        [self wordTrayTapped];
    }
    else {
        [self applyActionAdd:tile];
    }
}

- (TilePosition)calculateHoverPosition:(const Tile &)tile
{
    ASSERT(tile.has_view());
    UPTileView *tileView = tile.view();
    ASSERT(self.pickedTileView == tileView);
    ASSERT_POS(self.pickedTilePosition);

    // find the word position closest to the tile
    size_t word_length = self.pickedTilePosition.in_word_tray() ? self.model->word_length() : self.model->word_length() + 1;
    SpellLayout &layout = SpellLayout::instance();
    CGPoint center = tileView.center;
    CGFloat min_d = std::numeric_limits<CGFloat>::max();
    TilePosition pos;
    for (TileIndex idx = 0; idx < word_length; idx++) {
        CGPoint p = layout.center_for(role_in_word(idx, word_length));
        CGFloat d = up_point_distance(center, p);
        if (d < min_d) {
            min_d = d;
            pos = TilePosition(TileTray::Word, idx);
        }
    }
    return pos;
}

#pragma mark - Actions

- (void)applyActionAdd:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(tile.in_player_tray());

    cancel(BandGameDelay);
    [self viewOrderOutWordScoreLabel];

    NSArray *wordTrayTileViews = [self wordTrayTileViews];

    BOOL wordTrayTilesNeedMoves = wordTrayTileViews.count > 0;
    TilePosition word_pos = TilePosition(TileTray::Word, self.model->word_length());
    const State &state = self.model->back_state();
    if (state.action().opcode() == SpellModel::Opcode::HOVER) {
        word_pos = state.action().pos1();
        wordTrayTilesNeedMoves = NO;
    }

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::ADD, tile.position(), word_pos));

    if (wordTrayTilesNeedMoves) {
        SpellLayout &layout = SpellLayout::instance();
        for (UPTileView *wordTrayTileView in wordTrayTileViews) {
            Tile &tile = self.model->find_tile(wordTrayTileView);
            ASSERT(tile.position().in_word_tray());
            Location location = role_in_word(tile.position().index(), self.model->word_length());
            UPViewMove *bloopMove = find_move(wordTrayTileView, UPAnimatorTypeBloopIn);
            if (bloopMove) {
                bloopMove.destination = layout.center_for(location);
            }
            else {
                UPViewMove *slideMove = find_move(wordTrayTileView, UPAnimatorTypeSlide);
                if (slideMove) {
                    slideMove.destination = layout.center_for(location);
                }
                else {
                    UPViewMove *move = UPViewMoveMake(wordTrayTileView, location);
                    start(UP::TimeSpanning::slide(BandGameUITileSlide, @[move], DefaultTileSlideDuration, nil));
                }
            }
        }
    }
    
    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    Location location(role_in_word(word_pos.index(), self.model->word_length()));
    start(bloop_in(BandGameUITile, @[UPViewMoveMake(tileView, location)], DefaultBloopDuration, nil));

    [self viewUpdateGameControls];
}

- (void)applyActionRemove:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView);
    ASSERT_POS(self.pickedTilePosition);

    cancel(BandGameDelay);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REMOVE, tile.position()));

    [self viewSlideWordTrayViewsIntoPosition];

    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, role_for(TileTray::Player, self.model->player_tray_index(tileView)))], 0.3, nil));

    [self viewUpdateGameControls];
}

- (void)applyActionMoveTile:(const Tile &)tile toPosition:(const TilePosition &)position
{
    ASSERT(tile.has_view());
    ASSERT(position.in_word_tray());

    cancel(BandGameAll);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::MOVE, tile.position(), position));

    [self viewSlideWordTrayViewsIntoPosition];
    [self viewUpdateGameControls];
}

- (void)applyActionPick:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == nil);
    ASSERT_NPOS(self.pickedTilePosition);

    [self viewOrderOutWordScoreLabel];

    UPTileView *tileView = tile.view();
    [tileView cancelAnimations];

    self.pickedTileView = tileView;
    self.pickedTilePosition = tile.position();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::PICK, tile.position()));

    [self.gameView.tileContainerView bringSubviewToFront:tileView];
}

- (void)applyActionHoverIfNeeded:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == tile.view());
    ASSERT_POS(self.pickedTilePosition);

    cancel(BandGameDelay);
    cancel(@[tile.view()], (UPAnimatorTypeBloopIn | UPAnimatorTypeSlide));

    TilePosition hover_pos = [self calculateHoverPosition:tile];
    ASSERT_POS(hover_pos);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::HOVER, hover_pos));

    [self viewHover:hover_pos];
}

- (void)applyActionNoverIfNeeded:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == tile.view());
    ASSERT_POS(self.pickedTilePosition);

    cancel(BandGameDelay);
    cancel(@[tile.view()], (UPAnimatorTypeBloopIn | UPAnimatorTypeSlide));

    const State &state = self.model->back_state();
    if (state.action().opcode() != SpellModel::Opcode::HOVER) {
        return;
    }

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::NOVER));

    [self viewNover];
    [self viewUpdateGameControls];
}

- (void)applyActionDrop:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == tile.view());
    ASSERT_POS(self.pickedTilePosition);

    cancel(BandGameDelay);

    UPTileView *tileView = tile.view();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DROP, self.pickedTilePosition));

    CFTimeInterval duration = DefaultBloopDuration;
    
    if (self.pickedTilePosition.in_word_tray()) {
        Location location(role_in_word(self.pickedTilePosition.index(), self.model->word_length()));
        start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, location)], duration, nil));
    }
    else {
        Tile &tile = self.model->find_tile(tileView);
        start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, role_for(TileTray::Player, tile.position().index()))], duration, nil));
    }

    [self viewUpdateGameControls];
}

- (void)applyActionDropForGameOver:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == tile.view());
    ASSERT_POS(self.pickedTilePosition);
    
    cancel(BandGameDelay);
    
    UPTileView *tileView = tile.view();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DROP, self.pickedTilePosition));
    
    CFTimeInterval duration = GameOverRespositionBloopDuration;
    
    delay(BandModeDelay, GameOverRespositionBloopDelay, ^{
        if (self.pickedTilePosition.in_word_tray()) {
            Location location(role_in_word(self.pickedTilePosition.index(), self.model->word_length()));
            start(bloop_in(BandModeUI, @[UPViewMoveMake(tileView, location)], duration, nil));
        }
        else {
            Tile &tile = self.model->find_tile(tileView);
            start(bloop_in(BandModeUI, @[UPViewMoveMake(tileView, role_for(TileTray::Player, tile.position().index()))], duration, nil));
        }
    });
}

- (void)applyActionClear
{
    cancel(BandGameDelay);
    cancel(BandGameUI);

    [self viewClearWordTray];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::CLEAR));
    [self viewUpdateGameControls];
}

- (void)applyActionSubmit
{
    const State &state = self.model->back_state();
    if (state.action().opcode() == SpellModel::Opcode::SUBMIT) {
        return;
    }

    cancel(BandGameDelay);

    [self viewSubmitWord];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::SUBMIT));
    delay(BandGameDelay, 0.25, ^{
        [self viewFillPlayerTray];
        [self viewUpdateGameControls];
    });
}

- (void)applyActionReject
{
    cancel(BandGameDelay);

    [self viewLockIncludingPause:NO];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REJECT));

    // assess time penalty and shake word tray side-to-side
    [self viewPenaltyForReject];
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.gameView.wordTrayControl];
    [views addObjectsFromArray:[self wordTrayTileViews]];
    delay(BandGameDelay, 0.1, ^{
        start(shake(BandGameUI, views, 0.9, layout.word_tray_shake_offset(), ^(UIViewAnimatingPosition finishedPosition) {
            if (finishedPosition == UIViewAnimatingPositionEnd) {
                delay(BandGameDelay, 0.15, ^{
                    [self viewPenaltyFinished];
                    delay(BandGameDelay, 0.1, ^{
                        [self applyActionClear];
                        [self viewUnlock];
                    });
                });
            }
            else {
                [self viewUnlock];
            }
        }));
    });
}

- (void)applyActionDump
{
    ASSERT(self.wordTrayTileViews.count == 0);

    cancel(BandGameDelay);
    [self viewOrderOutWordScoreLabel];

    [self viewLockIncludingPause:NO];

    NSArray *playerTrayTileViews = self.model->player_tray_tile_views();
    ASSERT(playerTrayTileViews.count == TileCount);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [self viewPenaltyForDump];
    [self viewDumpPlayerTray:playerTrayTileViews];
    delay(BandGameDelay, 1.65, ^{
        [self viewFillPlayerTrayWithCompletion:^{
            [self viewUnlock];
        }];
        [self viewPenaltyFinished];
    });
}

- (void)applyActionQuit
{
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::QUIT));
    [self setMode:Mode::Quit];
}

#pragma mark - View ops

- (void)viewUpdateGameControls
{
    // word tray
    self.gameView.wordTrayControl.active = self.model->word_in_lexicon();
    [self.gameView.wordTrayControl setNeedsUpdate];

    // clear button
    if (self.model->word_length()) {
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
    }
    else {
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];
    }
    [self.gameView.clearControl setNeedsUpdate];

    self.gameView.gameScoreLabel.string = [NSString stringWithFormat:@"%d", self.model->game_score()];
}

- (void)viewSlideWordTrayViewsIntoPosition
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    cancel(BandGameUITileSlide);
    
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        Tile &tile = self.model->find_tile(tileView);
        [moves addObject:UPViewMoveMake(tileView, role_in_word(tile.position().index(), self.model->word_length()))];
    }
    start(UP::TimeSpanning::slide(BandGameUITileSlide, moves, DefaultTileSlideDuration, nil));
}

- (void)viewHover:(const TilePosition &)hover_pos
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    size_t word_length = self.pickedTilePosition.in_word_tray() ? self.model->word_length() : self.model->word_length() + 1;

    if (self.pickedTilePosition.in_player_tray()) {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedTileView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            if (idx >= hover_pos.index()) {
                idx++;
            }
            [moves addObject:UPViewMoveMake(tileView, role_in_word(idx, word_length))];
        }
        start(slide(BandGameUI, moves, DefaultTileSlideDuration, nil));
    }
    else {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedTileView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            if (idx < self.pickedTilePosition.index() && hover_pos.index() <= idx) {
                idx++;
            }
            else if (idx > self.pickedTilePosition.index() && hover_pos.index() >= idx) {
                idx--;
            }
            Location location(role_in_word(idx, word_length));
            [moves addObject:UPViewMoveMake(tileView, location)];
        }
        start(slide(BandGameUI, moves, DefaultTileSlideDuration, nil));
    }
}

- (void)viewNover
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    size_t word_length = self.pickedTilePosition.in_word_tray() ? self.model->word_length() - 1 : self.model->word_length();

    if (self.pickedTilePosition.in_player_tray()) {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedTileView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            Location location(role_in_word(idx, word_length));
            [moves addObject:UPViewMoveMake(tileView, location)];
        }
        start(slide(BandGameUI, moves, DefaultTileSlideDuration, nil));
    }
    else {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedTileView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            if (idx > self.pickedTilePosition.index()) {
                idx--;
            }
            Location location(role_in_word(idx, word_length));
            [moves addObject:UPViewMoveMake(tileView, location)];
        }
        start(slide(BandGameUI, moves, DefaultTileSlideDuration, nil));
    }
}

- (void)viewClearWordTray
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    ASSERT(wordTrayTileViews.count > 0);

    cancel(BandGameUITile);
    cancel(BandGameUITileSlide);

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        TileIndex idx = self.model->player_tray_index(tileView);
        [moves addObject:UPViewMoveMake(tileView, Location(role_for(TileTray::Player, idx)))];
    }
    start(bloop_in(BandGameUI, moves, 0.3, nil));
}

- (void)viewSubmitWord
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    
    for (UPTileView *tileView in wordTrayTileViews) {
        tileView.userInteractionEnabled = NO;
    }

    cancel(BandGameUITile);
    cancel(BandGameUITileSlide);

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        Tile &tile = self.model->find_tile(tileView);
        ASSERT(tile.position().in_word_tray());
        Location location(role_in_word(tile.position().index(), self.model->word_length()), Spot::OffTopNear);
        tileView.submitLocation = location;
        [moves addObject:UPViewMoveMake(tileView, location)];
    }
    start(bloop_out(BandGameUI, moves, 0.3, nil));
    
    [self viewUpdateWordScoreLabel];

    Role role = (self.model->word_length() >= 5 || self.model->word_multiplier() > 1) ? Role::WordScoreBonus : Role::WordScore;

    SpellLayout &layout = SpellLayout::instance();
    self.gameView.wordScoreLabel.frame = layout.frame_for(role, Spot::OffBottomFar);
    self.gameView.wordScoreLabel.hidden = NO;
    
    UPViewMove *wordScoreInMove = UPViewMoveMake(self.gameView.wordScoreLabel, Location(role, Spot::Default));

    delay(BandGameDelay, 0.25, ^{
        self.showingWordScoreLabel = YES;
        start(bloop_in(BandGameUI, @[wordScoreInMove], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandGameDelay, 1.5, ^{
                [self viewBloopOutWordScoreLabelWithDuration:DefaultBloopDuration];
            });
        }));
    });
}

- (void)viewUpdateWordScoreLabel
{
    UIColor *wordScoreColor = [UIColor themeColorWithCategory:self.gameView.wordScoreLabel.textColorCategory];
    
    SpellLayout &layout = SpellLayout::instance();
    NSString *string = [NSString stringWithFormat:@"+%d \n", self.model->word_score()];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, string.length);
    [attrString addAttribute:NSFontAttributeName value:layout.word_score_font() range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:wordScoreColor range:range];
    
    Role role = Role::WordScore;
    
    const size_t word_length = self.model->word_length();
    const int word_multiplier = self.model->word_multiplier();
    BOOL has_length_bonus = word_length >= 5;
    BOOL has_multiplier_bonus = word_multiplier > 1;
    if (has_length_bonus || has_multiplier_bonus) {
        role = Role::WordScoreBonus;
        NSMutableString *bonusString = [NSMutableString string];
        if (has_length_bonus) {
            switch (word_length) {
                case 5:
                    [bonusString appendFormat:@"+%d FIVE TILES", SpellModel::FiveLetterWordBonus];
                    break;
                case 6:
                    [bonusString appendFormat:@"+%d SIX TILES", SpellModel::SixLetterWordBonus];
                    break;
                case 7:
                    [bonusString appendFormat:@"+%d SEVEN TILES", SpellModel::SevenLetterWordBonus];
                    break;
            }
        }
        if (has_multiplier_bonus) {
            if (has_length_bonus) {
                [bonusString appendString:@"  &  "];
            }
            [bonusString appendFormat:@"%d× WORD SCORE", word_multiplier];
        }
        
        NSMutableAttributedString *bonusAttrString = [[NSMutableAttributedString alloc] initWithString:bonusString];
        NSRange bonusRange = NSMakeRange(0, bonusString.length);
        [bonusAttrString addAttribute:NSFontAttributeName value:layout.word_score_bonus_font() range:bonusRange];
        [bonusAttrString addAttribute:NSForegroundColorAttributeName value:wordScoreColor range:bonusRange];
        CGFloat baseline_adjustment = layout.word_score_bonus_font_metrics().baseline_adjustment();
        [bonusAttrString addAttribute:(NSString *)kCTBaselineOffsetAttributeName value:@(baseline_adjustment) range:bonusRange];
        [attrString appendAttributedString:bonusAttrString];
    }
    
    self.gameView.wordScoreLabel.attributedString = attrString;
}

- (void)viewBloopOutWordScoreLabelWithDuration:(CFTimeInterval)duration
{
    if (self.showingWordScoreLabel) {
        UPViewMove *wordScoreOutMove = UPViewMoveMake(self.gameView.wordScoreLabel, Location(Role::WordScore, Spot::OffTopNear));
        start(bloop_out(BandGameUI, @[wordScoreOutMove], duration, ^(UIViewAnimatingPosition) {
            self.showingWordScoreLabel = NO;
            self.gameView.wordScoreLabel.hidden = YES;
        }));
    }
}

- (void)viewOrderOutWordScoreLabel
{
    self.gameView.wordScoreLabel.hidden = YES;
    self.showingWordScoreLabel = NO;
}

- (void)viewDumpPlayerTray:(NSArray *)playerTrayTileViews
{
    Random &random = Random::instance();

    std::array<size_t, TileCount> idxs;
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        idxs[idx] = idx;
    }
    std::shuffle(idxs.begin(), idxs.end(), random.generator());

    CFTimeInterval baseDelay = 0.125;
    int count = 0;
    for (const auto idx : idxs) {
        UPTileView *tileView = playerTrayTileViews[idx];
        Location location(role_in_player_tray(TilePosition(TileTray::Player, idx)), Spot::OffBottomNear);
        UPAnimator *animator = slide(BandGameUI, @[UPViewMoveMake(tileView, location)], 1.1, ^(UIViewAnimatingPosition) {
            [tileView removeFromSuperview];
        });
        delay(BandGameDelay, count * baseDelay, ^{
            if (self.mode == Mode::Play) {
                start(animator);
            }
        });
        count++;
    }
}

- (void)viewFillPlayerTray
{
    [self viewFillPlayerTrayWithCompletion:nil];
}

- (void)viewFillPlayerTrayWithCompletion:(void (^)(void))completion
{
    SpellLayout &layout = SpellLayout::instance();

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        if (tile.has_view<false>()) {
            const TileModel &model = tile.model();
            UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
            tile.set_view(tileView);
            tileView.band = UP::BandGameUIColor;
            Role role = role_in_player_tray(TilePosition(TileTray::Player, idx));
            tileView.frame = layout.frame_for(Location(role, Spot::OffBottomNear));
            [self.gameView.tileContainerView addSubview:tileView];
            [moves addObject:UPViewMoveMake(tileView, Location(role, Spot::Default))];
        }
        idx++;
    }
    start(bloop_in(BandGameUI, moves, 0.25, ^(UIViewAnimatingPosition) {
        if (completion) {
            completion();
        }
    }));
}

- (void)viewPenaltyForDump
{
    ASSERT(self.lockCount > 0);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.clearControl.highlightedLocked = YES;
    self.gameView.clearControl.highlighted = YES;
    self.gameView.wordTrayControl.alpha = disabledAlpha;
    self.gameView.tileContainerView.alpha = disabledAlpha;
}

- (void)viewPenaltyForReject
{
    ASSERT(self.lockCount > 0);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.wordTrayControl.highlightedLocked = YES;
    self.gameView.wordTrayControl.highlighted = YES;
    self.gameView.wordTrayControl.alpha = disabledAlpha;
    self.gameView.clearControl.alpha = disabledAlpha;
    self.gameView.tileContainerView.alpha = disabledAlpha;
}

- (void)viewPenaltyFinished
{
    ASSERT(self.lockCount > 0);
    self.gameView.wordTrayControl.highlightedLocked = NO;
    self.gameView.wordTrayControl.highlighted = NO;
    self.gameView.clearControl.highlightedLocked = NO;
    self.gameView.clearControl.highlighted = NO;
    self.gameView.clearControl.alpha = 1.0;
    self.gameView.wordTrayControl.alpha = 1.0;
    self.gameView.tileContainerView.alpha = 1.0;
}

- (void)viewSetGameAlpha:(CGFloat)alpha
{
    ASSERT(self.lockCount > 0);
    for (UIView *view in self.gameView.subviews) {
        view.alpha = alpha;
    }
}

- (void)viewRestoreGameAlpha
{
    ASSERT(self.lockCount > 0);
    for (UIView *view in self.gameView.subviews) {
        view.alpha = 1.0;
    }
}

- (void)viewLock
{
    [self viewLockIncludingPause:YES];
}

- (void)viewLockIncludingPause:(BOOL)includingPause
{
    self.lockCount++;

    self.dialogMenu.userInteractionEnabled = NO;
    self.dialogPause.userInteractionEnabled = NO;

    UIView *roundButtonPause = self.gameView.pauseControl;
    for (UIView *view in self.gameView.subviews) {
        if (!includingPause && view == roundButtonPause) {
            continue;
        }
        view.userInteractionEnabled = NO;
    }
    
    // This lock/unlock do-si-do cancels gestures and touches on tile views
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        BOOL userInteractionEnabled = tileView.userInteractionEnabled;
        tileView.userInteractionEnabled = NO;
        tileView.userInteractionEnabled = userInteractionEnabled;
    }
}

- (void)viewUnlock
{
    ASSERT(self.lockCount > 0);
    self.lockCount = UPMaxT(NSInteger, self.lockCount - 1, 0);
    if (self.lockCount > 0) {
        return;
    }

    self.dialogMenu.userInteractionEnabled = YES;
    self.dialogPause.userInteractionEnabled = YES;

    for (UIView *view in self.gameView.subviews) {
        view.userInteractionEnabled = YES;
    }
}

- (void)viewUnhighlightTileViews
{
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        [tileView setFillColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
        [tileView setStrokeColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
        tileView.highlightedLocked = NO;
        tileView.highlighted = NO;
        [tileView update];
    }
}

- (void)viewFillUpSpellTileViews
{
    ASSERT(self.model->is_blank_filled());
    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SpellLayout &layout = SpellLayout::instance();
    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        TileModel model;
        switch (idx) {
            case 0:
                model = TileModel(U'U');
                break;
            case 1:
                model = TileModel(U'P');
                break;
            case 2:
                model = TileModel(U'S');
                break;
            case 3:
                model = TileModel(U'P');
                break;
            case 4:
                model = TileModel(U'E');
                break;
            case 5:
                model = TileModel(U'L');
                break;
            case 6:
                model = TileModel(U'L');
                break;
        }
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tile.set_view(tileView);
        tileView.band = BandGameUI;
        tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
        [self.gameView.tileContainerView addSubview:tileView];
        idx++;
    }
}

- (void)viewFillBlankTileViews
{
    ASSERT(self.model->is_blank_filled());
    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SpellLayout &layout = SpellLayout::instance();
    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        if (tile.has_view<false>()) {
            const TileModel &model = tile.model();
            UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
            tile.set_view(tileView);
            tileView.band = BandGameUI;
            tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
            [self.gameView.tileContainerView addSubview:tileView];
        }
        idx++;
    }
}

- (void)viewBloopTileViewsToPlayerTrayWithDuration:(CFTimeInterval)duration completion:(void (^)(void))completion
{
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (const auto &tile : self.model->tiles()) {
        if (tile.has_view()) {
            UPTileView *tileView = tile.view();
            [moves addObject:UPViewMoveMake(tileView, role_in_player_tray(tile.position()))];
        }
    }
    start(bloop_in(BandModeUI, moves, duration, nil));
}

- (void)viewBloopOutExistingTileViewsWithCompletion:(void (^)(void))completion
{
    [self viewBloopOutExistingTileViewsWithDuration:DefaultBloopDuration completion:completion];
}

- (void)viewBloopOutExistingTileViewsWithDuration:(CFTimeInterval)duration completion:(void (^)(void))completion
{
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    NSMutableSet *submittedTileViews = [NSMutableSet setWithArray:self.gameView.tileContainerView.subviews];
    for (const auto &tile : self.model->tiles()) {
        if (tile.has_view()) {
            UPTileView *tileView = tile.view();
            if (tile.in_word_tray()) {
                Role role = role_in_word(tile.position().index(), self.model->word_length());
                [moves addObject:UPViewMoveMake(tileView, role, Spot::OffBottomNear)];
            }
            else {
                [moves addObject:UPViewMoveMake(tileView, role_in_player_tray(tile.position()), Spot::OffBottomNear)];
            }
            [submittedTileViews removeObject:tileView];
        }
    }
    for (UPTileView *tileView in submittedTileViews) {
        ASSERT(tileView.submitLocation.role() != Role::None);
        [moves addObject:UPViewMoveMake(tileView, tileView.submitLocation)];
    }
    start(bloop_out(BandModeUI, moves, duration, ^(UIViewAnimatingPosition) {
        [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (completion) {
            completion();
        }
    }));
}

- (void)viewBloopInBlankTileViewsWithCompletion:(void (^)(void))completion
{
    [self viewBloopInBlankTileViewsWithDuration:DefaultBloopDuration completion:completion];
}

- (void)viewBloopInBlankTileViewsWithDuration:(CFTimeInterval)duration completion:(void (^)(void))completion
{
    ASSERT(self.model->is_blank_filled());
    ASSERT(self.model->is_player_tray_filled());
    
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray<UPViewMove *> *tileInMoves = [NSMutableArray array];
    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        const TileModel &model = tile.model();
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tile.set_view(tileView);
        tileView.band = BandModeUI;
        Role role = role_in_player_tray(tile.position());
        tileView.frame = layout.frame_for(Location(role, Spot::OffBottomNear));
        [self.gameView.tileContainerView addSubview:tileView];
        [tileInMoves addObject:UPViewMoveMake(tileView, Location(role, Spot::Default))];
        idx++;
    }
    start(bloop_in(BandModeUI, tileInMoves, duration, ^(UIViewAnimatingPosition) {
        if (completion) {
            completion();
        }
    }));
}

- (void)viewBloopInUpSpellTileViewsWithDuration:(CFTimeInterval)duration completion:(void (^)(void))completion
{
    ASSERT(self.model->is_blank_filled());
    ASSERT(self.model->is_player_tray_filled());

    [self viewFillUpSpellTileViews];

    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray<UPViewMove *> *tileInMoves = [NSMutableArray array];
    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        UPTileView *tileView = tile.view();
        Role role = role_in_player_tray(tile.position());
        tileView.frame = layout.frame_for(Location(role, Spot::OffBottomNear));
        [tileInMoves addObject:UPViewMoveMake(tileView, Location(role, Spot::Default))];
        idx++;
    }

    start(bloop_in(BandModeUI, tileInMoves, duration, ^(UIViewAnimatingPosition) {
        if (completion) {
            completion();
        }
    }));
}

- (void)viewDumpAllTilesFromCurrentPosition
{
    Random &random = Random::instance();
    
    std::array<size_t, TileCount> idxs;
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        idxs[idx] = idx;
    }
    std::shuffle(idxs.begin(), idxs.end(), random.generator());
    
    const UP::TileArray &tiles = self.model->tiles();
    CFTimeInterval baseDelay = 0.125;
    int count = 0;
    for (const auto idx : idxs) {
        const Tile &tile = tiles[idx];
        if (tile.has_view()) {
            UPTileView *tileView = tile.view();
            Location location;
            if (tile.in_word_tray()) {
                location = Location(role_in_word(tile.position().index(), self.model->word_length()), Spot::OffBottomNear);
            }
            else {
                location = Location(role_in_player_tray(tile.position()), Spot::OffBottomNear);
            }
            UPAnimator *animator = slide(BandModeUI, @[UPViewMoveMake(tileView, location)], 0.75, ^(UIViewAnimatingPosition) {
                [tileView removeFromSuperview];
            });
            delay(BandModeDelay, count * baseDelay, ^{
                start(animator);
            });
        }
        count++;
    }
}


- (void)viewOrderInAboutWithCompletion:(void (^)(void))completion
{
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffLeftFar));
    UPViewMove *extrasButtonMove = UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft, Spot::OffLeftFar));
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Location(Role::Screen, Spot::OffLeftNear));
    UPViewMove *dialogGameOverMove = UPViewMoveMake(self.dialogGameOver, Location(Role::Screen, Spot::OffLeftNear));
    UPViewMove *dialogGameNoteMove = UPViewMoveMake(self.dialogGameNote, Location(Role::Screen, Spot::OffLeftNear));

    CFTimeInterval duration = 0.75;
    
    start(bloop_out(BandModeUI, @[extrasButtonMove], duration, nil));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_out(BandModeUI, @[playButtonMove], duration - 0.1, nil));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_out(BandModeUI, @[gameViewMove, dialogGameOverMove, dialogGameNoteMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.aboutButton.userInteractionEnabled = NO;
            [self viewUnlock];
            if (completion) {
                completion();
            }
        }));
    });
}

- (void)viewOrderInExtrasWithCompletion:(void (^)(void))completion
{
    cancel_all();
    
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffRightFar));
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight, Spot::OffRightFar));
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Location(Role::Screen, Spot::OffRightNear));
    UPViewMove *dialogGameOverMove = UPViewMoveMake(self.dialogGameOver, Location(Role::Screen, Spot::OffRightNear));
    UPViewMove *dialogGameNoteMove = UPViewMoveMake(self.dialogGameNote, Location(Role::Screen, Spot::OffRightNear));

    CFTimeInterval duration = 0.75;
    
    start(bloop_out(BandModeUI, @[aboutButtonMove], duration, nil));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_out(BandModeUI, @[playButtonMove], duration - 0.1, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_out(BandModeUI, @[gameViewMove, dialogGameOverMove, dialogGameNoteMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.extrasButton.userInteractionEnabled = NO;
            [self viewUnlock];
            if (completion) {
                completion();
            }
        }));
    });
}

- (void)viewOrderOutGameEnd
{
    ASSERT(self.lockCount > 0);
    
    // reset game controls
    self.model->reset_game_score();
    [self.gameTimer reset];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    [self viewSetGameAlpha:[UIColor themeDisabledAlpha]];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.messagePathView.center = layout.center_for(Role::DialogMessageCenter, Spot::OffBottomNear);
    self.dialogGameOver.transform = CGAffineTransformIdentity;
    self.dialogGameOver.hidden = YES;
    self.dialogGameNote.noteLabel.center = layout.center_for(Role::DialogNote, Spot::OffBottomFar);
    self.dialogGameNote.hidden = YES;
}

- (void)viewMakeReadyWithCompletion:(void (^)(void))completion
{
    ASSERT(self.model->is_blank_filled());
    ASSERT(self.lockCount > 0);
    
    // lock play button in highlighted state
    self.dialogMenu.playButton.highlightedLocked = YES;
    self.dialogMenu.playButton.highlighted = YES;
    
    // reset game controls
    self.model->reset_game_score();
    [self.gameTimer reset];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    
    delay(BandModeDelay, 0.1, ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self viewSetGameAlpha:[UIColor themeDisabledAlpha]];
        }];
    });
    
    // move extras and about buttons offscreen
    NSArray<UPViewMove *> *outGameOverMoves = @[
        UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageCenter, Spot::OffBottomNear),
        UPViewMoveMake(self.dialogGameNote.noteLabel, Role::DialogNote, Spot::OffBottomFar),
    ];
    start(bloop_out(BandModeUI, outGameOverMoves, 0.2, nil));
    NSArray<UPViewMove *> *outMoves = @[
        UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft, Spot::OffTopNear)),
        UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight, Spot::OffTopNear)),
    ];
    start(bloop_out(BandModeUI, outMoves, 0.3, ^(UIViewAnimatingPosition) {
        self.dialogGameOver.transform = CGAffineTransformIdentity;
        
        delay(BandModeDelay, 0.35, ^{
            // move play button
            UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
            start(slide(BandModeUI, @[playButtonMove], 0.3, nil));
            // change transform of game view
            [UIView animateWithDuration:0.75 animations:^{
                self.gameView.transform = CGAffineTransformIdentity;
            }];
            delay(BandModeDelay, 0.45, ^{
                // bloop in ready message
                self.dialogMenu.messagePathView.alpha = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.dialogMenu.messagePathView.alpha = 1;
                }];
                UPViewMove *readyMove = UPViewMoveMake(self.dialogMenu.messagePathView, Location(Role::DialogMessageHigh));
                start(bloop_in(BandModeUI, @[readyMove], 0.3,  ^(UIViewAnimatingPosition) {
                    delay(BandModeDelay, 1.5, ^{
                        if (completion) {
                            completion();
                        }
                    });
                }));
            });
        });
    }));
}

#pragma mark - Model management

- (void)createNewGameModel
{
    if (self.model) {
        delete self.model;
    }
    GameKey game_code = GameKey::random();
    self.model = new SpellModel(game_code);
}

#pragma mark - Lifecycle notifications

- (void)configureLifecycleNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
    }];
    
    [nc addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
    }];
    
    [nc addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        if (self.mode == Mode::Play) {
            [self setMode:Mode::Pause transitionScenario:UPModeTransitionScenarioWillResignActive];
        }
    }];
    [nc addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        if (self.mode == Mode::Play) {
            [self setMode:Mode::Pause transitionScenario:UPModeTransitionScenarioDidEnterBackground];
        }
    }];
}

#pragma mark - Modes

- (void)configureModeTransitionTables
{
    m_default_transition_table = {
        { Mode::None,     Mode::Init,     @selector(modeTransitionFromNoneToInit) },
        { Mode::Init,     Mode::Attract,  @selector(modeTransitionFromInitToAttract) },
        { Mode::Init,     Mode::About,    @selector(modeTransitionFromInitToAbout) },
        { Mode::Init,     Mode::Extras,   @selector(modeTransitionFromInitToExtras) },
        { Mode::Init,     Mode::Ready,    @selector(modeTransitionFromInitToReady) },
        { Mode::About,    Mode::Init,     @selector(modeTransitionFromAboutToInit) },
        { Mode::Extras,   Mode::Init,     @selector(modeTransitionFromExtrasToInit) },
        { Mode::Attract,  Mode::About,    @selector(modeTransitionFromAttractToAbout) },
        { Mode::Attract,  Mode::Extras,   @selector(modeTransitionFromAttractToExtras) },
        { Mode::Attract,  Mode::Ready,    @selector(modeTransitionFromAttractToReady) },
        { Mode::Ready,    Mode::Play,     @selector(modeTransitionFromReadyToPlay) },
        { Mode::Play,     Mode::Pause,    @selector(modeTransitionFromPlayToPause) },
        { Mode::Play,     Mode::GameOver, @selector(modeTransitionFromPlayToGameOver) },
        { Mode::Pause,    Mode::Play,     @selector(modeTransitionFromPauseToPlay) },
        { Mode::Pause,    Mode::Quit,     @selector(modeTransitionFromPauseToQuit) },
        { Mode::GameOver, Mode::End,      @selector(modeTransitionFromOverToEnd) },
        { Mode::End,      Mode::About,    @selector(modeTransitionFromEndToAbout) },
        { Mode::End,      Mode::Extras,   @selector(modeTransitionFromEndToExtras) },
        { Mode::End,      Mode::Ready,    @selector(modeTransitionFromEndToReady) },
        { Mode::Quit,     Mode::End,      @selector(modeTransitionFromQuitToEnd) },
    };

    m_did_become_active_transition_table = {
        { Mode::Play,     Mode::Pause,    @selector(modeTransitionImmediateFromPlayToPause) },
    };

    m_will_enter_foreground_transition_table = {};

    m_will_resign_active_transition_table = {
        { Mode::Play,     Mode::Pause,    @selector(modeTransitionImmediateFromPlayToPause) },
    };

    m_did_enter_background_transition_table = {
        { Mode::Play,     Mode::Pause,    @selector(modeTransitionImmediateFromPlayToPause) },
    };
}

- (void)setMode:(Mode)mode transitionScenario:(UPModeTransitionScenario)transitionScenario
{
    if (_mode == mode) {
        return;
    }
    Mode prev = _mode;
    _mode = mode;
    
    SEL selector = nullptr;
    switch (transitionScenario) {
        case UPModeTransitionScenarioDefault:
            selector = UP::transition_selector(prev, mode, m_default_transition_table);
            break;
        case UPModeTransitionScenarioDidBecomeActive:
            selector = UP::transition_selector(prev, mode, m_did_become_active_transition_table);
            break;
        case UPModeTransitionScenarioWillEnterForeground:
            selector = UP::transition_selector(prev, mode, m_will_enter_foreground_transition_table);
            break;
        case UPModeTransitionScenarioWillResignActive:
            selector = UP::transition_selector(prev, mode, m_will_resign_active_transition_table);
            break;
        case UPModeTransitionScenarioDidEnterBackground:
            selector = UP::transition_selector(prev, mode, m_did_enter_background_transition_table);
            break;
    }
    
    if (selector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector];
#pragma clang diagnostic pop
    }
}

- (void)setMode:(Mode)mode
{
    [self setMode:mode transitionScenario:UPModeTransitionScenarioDefault];
}

- (void)modeTransitionFromNoneToInit
{
    [self createNewGameModel];
    
    SpellLayout &layout = SpellLayout::instance();

    self.dialogMenu.transform = CGAffineTransformIdentity;
    self.dialogMenu.hidden = NO;
    self.dialogMenu.alpha = 1.0;
    self.dialogMenu.messagePathView.frame = layout.frame_for(Role::DialogMessageCenter, Spot::OffBottomNear);

    self.gameView.transform = layout.menu_game_view_transform();
    [self viewUpdateGameControls];
    [self viewFillUpSpellTileViews];
    [self viewLock];
    [self viewSetGameAlpha:[UIColor themeDisabledAlpha]];
    [self viewUnlock];
}

- (void)modeTransitionFromInitToAttract
{
    ASSERT_NOT_REACHED();
}

- (void)modeTransitionFromInitToAbout
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewOrderInAboutWithCompletion:^{
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromInitToExtras
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewOrderInExtrasWithCompletion:^{
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromInitToReady
{
    ASSERT(self.model->is_blank_filled());
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewMakeReadyWithCompletion:^{
        [self viewBloopOutExistingTileViewsWithCompletion:nil];
        [self setMode:Mode::Play];
    }];
}

- (void)modeTransitionFromAboutToInit
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Role::DialogButtonTopCenter);
    UPViewMove *extrasButtonMove = UPViewMoveMake(self.dialogMenu.extrasButton, Role::DialogButtonTopLeft);
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Role::Screen);
    
    CFTimeInterval duration = 0.75;
    
    start(bloop_in(BandModeUI, @[extrasButtonMove], duration, nil));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_in(BandModeUI, @[playButtonMove], duration - 0.1, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_in(BandModeUI, @[gameViewMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.aboutButton.userInteractionEnabled = YES;
            [self viewUnlock];
        }));
    });
}

- (void)modeTransitionFromExtrasToInit
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Role::DialogButtonTopCenter);
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogMenu.aboutButton, Role::DialogButtonTopRight);
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Role::Screen);
    
    CFTimeInterval duration = 0.75;
    
    start(bloop_in(BandModeUI, @[aboutButtonMove], duration, nil));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_in(BandModeUI, @[playButtonMove], duration - 0.1, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_in(BandModeUI, @[gameViewMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.extrasButton.userInteractionEnabled = YES;
            [self viewUnlock];
        }));
    });
}

- (void)modeTransitionFromAttractToAbout
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewOrderInAboutWithCompletion:^{
        // FIXME: clean up after attract, return game view to start
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromAttractToExtras
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewOrderInExtrasWithCompletion:^{
        // FIXME: clean up after attract, return game view to start
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromAttractToReady
{
    [self viewBloopOutExistingTileViewsWithCompletion:^{
        [self createNewGameModel];
        [self viewBloopInBlankTileViewsWithCompletion:^{
            [self viewLock];
            [self viewMakeReadyWithCompletion:^{
                [self viewBloopOutExistingTileViewsWithCompletion:nil];
                [self setMode:Mode::Play];
            }];
        }];
    }];
}

- (void)modeTransitionFromReadyToPlay
{
    ASSERT(self.lockCount == 1);

    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    self.model->apply(Action(Opcode::PLAY));
    
    // bloop out ready message
    UPViewMove *readyMove = UPViewMoveMake(self.dialogMenu.messagePathView, Location(Role::DialogMessageHigh, Spot::OffBottomNear));
    start(bloop_out(BandModeUI, @[readyMove], 0.25, nil));
    // animate game view to full alpha and fade out dialog menu
    [UIView animateWithDuration:0.1 delay:0.2 options:0 animations:^{
        [self viewRestoreGameAlpha];
    } completion:nil];
    // keep the tile views alpha disabled until just before filling them with game tiles
    self.gameView.tileContainerView.alpha = [UIColor themeDisabledAlpha];
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        self.dialogMenu.alpha = 0.0;
    } completion:^(BOOL finished) {
        // animate game view to full alpha and restore alpha of dialog menu
        self.dialogMenu.alpha = 1.0;
        self.dialogMenu.hidden = YES;
        self.dialogGameOver.alpha = 1.0;
        self.dialogGameOver.hidden = YES;
        self.dialogGameNote.alpha = 1.0;
        self.dialogGameNote.hidden = YES;
        delay(BandModeDelay, 0.1, ^{
            // create new game model and start game
            [self viewRestoreGameAlpha];
            [self viewUnlock];
            [self viewFillPlayerTrayWithCompletion:^{
                [self.gameTimer start];
            }];
        });
    }];
}

- (void)modeTransitionFromPlayToPause
{
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    [self cancelActiveTouch];
    [self.gameTimer stop];
    pause(BandGameAll);
    [self viewLock];
    [self viewSetGameAlpha:[UIColor themeModalBackgroundAlpha]];

    // special modal fixups for pause
    self.gameView.pauseControl.highlightedLocked = YES;
    self.gameView.pauseControl.highlighted = YES;
    self.gameView.pauseControl.alpha = [UIColor themeModalActiveAlpha];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageHigh, Spot::OffBottomNear);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse, Spot::OffBottomFar);
    
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Role::DialogButtonAlternativeResponse),
        UPViewMoveMake(self.dialogPause.resumeButton, Role::DialogButtonDefaultResponse),
    ];
    start(bloop_in(BandModeUI, farMoves, DefaultBloopDuration, ^(UIViewAnimatingPosition) {
        [self viewUnlock];
    }));
    
    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Role::DialogMessageHigh),
    ];
    start(bloop_in(BandModeUI, nearMoves, 0.25, nil));
    
    self.dialogPause.hidden = NO;
    self.dialogPause.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogPause.alpha = 1.0;
    }];
}

- (void)modeTransitionImmediateFromPlayToPause
{
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    [self.gameTimer stop];
    pause(BandGameAll);
    [self viewLock];
    [self viewSetGameAlpha:[UIColor themeModalBackgroundAlpha]];
    
    // special modal fixups for pause
    self.gameView.pauseControl.highlightedLocked = YES;
    self.gameView.pauseControl.highlighted = YES;
    self.gameView.pauseControl.alpha = [UIColor themeModalActiveAlpha];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageHigh);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse);
    self.dialogPause.hidden = NO;
    self.dialogPause.alpha = 1.0;
    [self viewUnlock];
}

- (void)modeTransitionFromPauseToPlay
{
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    [self viewLock];

    [UIView animateWithDuration:0.15 delay:0.15 options:0 animations:^{
        self.dialogPause.alpha = 0.0;
    } completion:nil];

    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Location(Role::DialogMessageHigh, Spot::OffBottomNear)),
    ];
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Location(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogPause.resumeButton, Location(Role::DialogButtonDefaultResponse, Spot::OffBottomFar)),
    ];

    start(bloop_out(BandModeUI, farMoves, 0.25, nil));

    start(bloop_out(BandModeUI, nearMoves, DefaultBloopDuration, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.gameView.pauseControl.highlightedLocked = NO;
            self.gameView.pauseControl.highlighted = NO;
            [self viewRestoreGameAlpha];
        } completion:^(BOOL finished) {
            [self.gameTimer start];
            start(BandGameAll);
            self.gameView.pauseControl.highlightedLocked = NO;
            self.gameView.pauseControl.highlighted = NO;
            [self viewUnlock];
        }];
    }));
}

- (void)modeTransitionFromPauseToQuit
{
    ASSERT(self.lockCount == 0);

    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::QUIT));

    [self viewLock];
    cancel(BandGameAll);
    [self.gameTimer cancel];
    [self viewUpdateGameControls];
    [self cancelActiveTouch];
    [self viewUnhighlightTileViews];
    [self viewOrderOutWordScoreLabel];

    [self.gameView.pauseControl setStrokeColorAnimationDuration:0.3 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self.gameView.pauseControl setStrokeColorAnimationDuration:0.3 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    self.gameView.pauseControl.highlightedLocked = NO;
    self.gameView.pauseControl.highlighted = NO;
    self.gameView.pauseControl.alpha = [UIColor themeModalBackgroundAlpha];
    [self.gameView.pauseControl setStrokeColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self.gameView.pauseControl setStrokeColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];

    [UIView animateWithDuration:0.15 delay:0.15 options:0 animations:^{
        self.dialogPause.alpha = 0.0;
    } completion:nil];
    
    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Location(Role::DialogMessageHigh, Spot::OffBottomNear)),
    ];
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Location(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogPause.resumeButton, Location(Role::DialogButtonDefaultResponse, Spot::OffBottomFar)),
    ];
    start(bloop_out(BandModeUI, farMoves, DefaultBloopDuration, nil));
    start(bloop_out(BandModeUI, nearMoves, 0.35, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        delay(BandModeDelay, 0.35, ^{
            [self setMode:Mode::End];
        });
    }));
}

- (void)modeTransitionFromPlayToGameOver
{
    cancel(BandGameAll);
    while (self.lockCount > 0) {
        [self viewUnlock];
    }
    [self viewLock];

    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    [self viewUpdateGameControls];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::OVER));

    [self cancelActiveTouch];
    [self viewUnhighlightTileViews];
    [self viewBloopTileViewsToPlayerTrayWithDuration:GameOverRespositionBloopDuration completion:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.gameView.wordTrayControl.transform = CGAffineTransformIdentity;
    }];
    
    [self viewSetGameAlpha:[UIColor themeModalGameOverAlpha]];
    self.gameView.timerLabel.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.gameScoreLabel.alpha = [UIColor themeModalActiveAlpha];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.messagePathView.center = layout.center_for(Role::DialogMessageHigh, Spot::OffBottomNear);
    self.dialogGameOver.center = layout.center_for(Location(Role::Screen));
    self.dialogGameOver.hidden = NO;
    self.dialogGameOver.alpha = 0.0;
    self.dialogGameNote.noteLabel.center = layout.center_for(Role::DialogNote, Spot::OffBottomNear);
    self.dialogGameNote.center = layout.center_for(Location(Role::Screen));
    self.dialogGameNote.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogGameOver.alpha = 1.0;
    }];

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageHigh),
    ];
    start(bloop_in(BandModeUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        delay(BandModeUI, 1.75, ^{
            [self setMode:Mode::End];
        });
    }));
}

- (void)modeTransitionFromOverToEnd
{
    ASSERT(self.lockCount == 1);

    SpellLayout &layout = SpellLayout::instance();
    [UIView animateWithDuration:1.0 animations:^{
        self.dialogGameOver.transform = layout.menu_game_view_transform();
        self.gameView.transform = layout.menu_game_view_transform();
        [self viewSetGameAlpha:[UIColor themeModalBackgroundAlpha]];
    }];
    self.gameView.timerLabel.alpha = 1.0;
    self.gameView.gameScoreLabel.alpha = 1.0;

    [self viewBloopOutWordScoreLabelWithDuration:GameOverInOutBloopDuration];

    [self viewBloopOutExistingTileViewsWithDuration:GameOverInOutBloopDuration completion:^{
        self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::END));
        [self viewBloopInBlankTileViewsWithDuration:GameOverInOutBloopDuration completion:nil];

        self.dialogMenu.hidden = NO;
        self.dialogMenu.alpha = 1;
        self.dialogMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Spot::OffTopNear));
        self.dialogMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
        self.dialogMenu.aboutButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Spot::OffTopNear));
        self.dialogMenu.playButton.highlightedLocked = NO;
        self.dialogMenu.playButton.highlighted = NO;
        NSArray<UPViewMove *> *buttonMoves = @[
            UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft)),
            UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter)),
            UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight)),
            UPViewMoveMake(self.dialogGameNote.noteLabel, Role::DialogNote),
        ];
        start(bloop_in(BandModeUI, buttonMoves, GameOverInOutBloopDuration, ^(UIViewAnimatingPosition) {
            [self viewUnlock];
        }));
    }];
}

- (void)modeTransitionFromEndToAbout
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewOrderInAboutWithCompletion:^{
        [self viewOrderOutGameEnd];
        [self viewFillUpSpellTileViews];
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromEndToExtras
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewOrderInExtrasWithCompletion:^{
        [self viewOrderOutGameEnd];
        [self viewFillUpSpellTileViews];
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromEndToReady
{
    [self createNewGameModel];
    [self viewLock];
    [self viewFillUpSpellTileViews];
    [self viewMakeReadyWithCompletion:^{
        [self viewBloopOutExistingTileViewsWithCompletion:nil];
        [self setMode:Mode::Play];
    }];
}

- (void)modeTransitionFromQuitToEnd
{
    ASSERT(self.lockCount == 1);

    [self viewDumpAllTilesFromCurrentPosition];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::END));

    SpellLayout &layout = SpellLayout::instance();

    [UIView animateWithDuration:1.2 animations:^{
        self.gameView.transform = layout.menu_game_view_transform();
        [self viewSetGameAlpha:[UIColor themeDisabledAlpha]];
    } completion:^(BOOL finished) {
        self.dialogMenu.hidden = NO;
        self.dialogMenu.alpha = 1;
        self.dialogMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Spot::OffTopNear));
        self.dialogMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
        self.dialogMenu.aboutButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Spot::OffTopNear));
        self.dialogMenu.playButton.highlightedLocked = NO;
        self.dialogMenu.playButton.highlighted = NO;
        delay(BandModeDelay, 0.1, ^{
            NSArray<UPViewMove *> *menuButtonMoves = @[
                UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft)),
                UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter)),
                UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight)),
            ];
            start(bloop_in(BandModeUI, menuButtonMoves, 0.3, nil));
            [self viewBloopInUpSpellTileViewsWithDuration:0.3 completion:^{
                [self viewUnlock];
            }];
        });
    }];
}

@end
