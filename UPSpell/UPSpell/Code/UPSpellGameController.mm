//
//  UPSpellGameController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <limits>
#import <memory>
#import <vector>

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPChoice.h"
#import "UPDialogGameNote.h"
#import "UPDialogGameOver.h"
#import "UPDialogTopMenu.h"
#import "UPDialogPause.h"
#import "UPDialogPlayMenu.h"
#import "UPSceneDelegate.h"
#import "UPSoundPlayer.h"
#import "UPSpellGameSummary.h"
#import "UPSpellGameView.h"
#import "UPSpellLayout.h"
#import "UPSpellDossier.h"
#import "UPSpellSettings.h"
#import "UPTextButton.h"
#import "UPTileModel.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "UPTunePlayer.h"
#import "UPSpellGameController.h"
#import "UPSpellNavigationController.h"
#import "UPViewMove+UPSpell.h"

using Action = UP::SpellModel::Action;
using Opcode = UP::SpellModel::Opcode;
using State = UP::SpellModel::State;
using TileArray = UP::TileArray;
using TileIndex = UP::TileIndex;
using TilePosition = UP::TilePosition;
using TileTray = UP::TileTray;

using UP::GameKey;
using UP::Lexicon;
using UP::ModeTransition;
using UP::Random;
using UP::SpellGameSummary;
using UP::SpellLayout;
using UP::SpellModel;
using UP::SpellModelPtr;
using UP::Tile;
using UP::TileModel;
using UP::TileCount;
using UP::TilePaths;
using UP::TileSequence;
using UP::valid;
using UP::Word;

using UP::ns_str;

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
using UP::BandWordScore;

using UP::role_in_player_tray;
using UP::role_in_word;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Place = UP::SpellLayout::Place;
using Mode = UP::Mode;
using ModeTransitionTable = UP::ModeTransitionTable;

typedef NS_ENUM(NSInteger, UPSpellGameAlphaStateReason) {
    UPSpellGameAlphaStateReasonDefault,
    UPSpellGameAlphaStateReasonInit,
    UPSpellGameAlphaStateReasonPlayMenu,
    UPSpellGameAlphaStateReasonReady,
    UPSpellGameAlphaStateReasonPrePlay,
    UPSpellGameAlphaStateReasonPlay,
    UPSpellGameAlphaStateReasonReject,
    UPSpellGameAlphaStateReasonDump,
    UPSpellGameAlphaStateReasonRestoredPause,
    UPSpellGameAlphaStateReasonPause,
    UPSpellGameAlphaStateReasonGameOver,
    UPSpellGameAlphaStateReasonQuitToEnd,
    UPSpellGameAlphaStateReasonOverToEnd,
    UPSpellGameAlphaStateReasonOrderOutGameEnd,
};

@interface UPSpellGameController () <UPGameTimerObserver>
{
    std::shared_ptr<SpellModel> m_spell_model;
    ModeTransitionTable m_default_transition_table;
    ModeTransitionTable m_did_become_active_transition_table;
    ModeTransitionTable m_will_enter_foreground_transition_table;
    ModeTransitionTable m_will_resign_active_transition_table;
    ModeTransitionTable m_did_enter_background_transition_table;
    std::vector<UPSpellGameAlphaStateReason> m_alpha_reason_stack;
}
@property (nonatomic) UPSpellGameView *gameView;
@property (nonatomic) UPGameTimer *gameTimer;
@property (nonatomic) BOOL showingWordScoreLabel;
@property (nonatomic) UPDialogGameOver *dialogGameOver;
@property (nonatomic) UPDialogGameNote *dialogGameNote;
@property (nonatomic) UPDialogPause *dialogPause;
@property (nonatomic) UPDialogPlayMenu *dialogPlayMenu;
@property (nonatomic) UPDialogTopMenu *dialogTopMenu;
@property (nonatomic) NSInteger lockCount;
@property (nonatomic) UPChoice *playMenuChoice;

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
@property (nonatomic) CFTimeInterval activeTouchStartTimestamp;
@property (nonatomic) CFTimeInterval activeTouchPreviousTimestamp;

@property (nonatomic) NSInteger tuneNumber;
@property (nonatomic) CFTimeInterval tapSoundTimestamp;
@property (nonatomic) BOOL soundEffectsEnabled;
@property (nonatomic) BOOL tunesEnabled;

@end

static constexpr CFTimeInterval GameStartDelay = 0.64;
static constexpr CFTimeInterval DefaultBloopDuration = 0.2;
static constexpr CFTimeInterval DefaultTileSlideDuration = 0.05;
static constexpr CFTimeInterval GameOverInOutBloopDuration = 0.5;
static constexpr CFTimeInterval GameOverRespositionBloopDuration = 0.4;
static constexpr CFTimeInterval GameOverOutroDuration = 5;
static constexpr CFTimeInterval TapToTubInterval = 0.15;

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

    self.dialogTopMenu = [UPDialogTopMenu instance];
    self.dialogTopMenu.hidden = YES;
    self.dialogTopMenu.frame = layout.screen_bounds();

    self.dialogPause = [UPDialogPause instance];
    [self.view addSubview:self.dialogPause];
    [self.dialogPause.quitButton setTarget:self action:@selector(dialogPauseQuitButtonTapped:)];
    [self.dialogPause.resumeButton setTarget:self action:@selector(dialogPauseResumeButtonTapped:)];
    self.dialogPause.hidden = YES;
    self.dialogPause.frame = layout.screen_bounds();

    self.dialogPlayMenu = [UPDialogPlayMenu instance];
    [self.view addSubview:self.dialogPlayMenu];
    [self.dialogPlayMenu.backButton setTarget:self action:@selector(playChoiceBackButtonTapped:)];
    [self.dialogPlayMenu.goButton setTarget:self action:@selector(playChoiceGoButtonTapped:)];
    self.dialogPlayMenu.hidden = YES;
    self.dialogPlayMenu.frame = layout.screen_bounds();

    self.touchedTileView = nil;
    self.pickedTileView = nil;
    self.pickedTilePosition = TilePosition();

    [self configureModeTransitionTables];
    [self configureLifecycleNotifications];
    [self configureSounds];

    [UPSpellDossier instance]; // restores data from disk
    
    m_spell_model = [self restoreInProgressGameIfExists];
    if (m_spell_model) {
        [self setMode:Mode::Pause];
    }
    else {
        [self setMode:Mode::Init];
    }
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
    for (const auto &tile : m_spell_model->tiles()) {
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
    for (const auto &tile : m_spell_model->tiles()) {
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
    if (self.mode != Mode::Play) {
        return;
    }
    
    UPControl *incomingTouchedControl = self.touchedControl;
    
    for (UITouch *touch in touches) {
        if (touch != self.activeTouch) {
            CGPoint point = [touch locationInView:self.gameView];
            UPControl *hitControl = [self hitTestGameView:point withEvent:event];
            if (hitControl && hitControl.userInteractionEnabled) {
                if (self.touchedControl && hitControl != self.touchedControl) {
                    BOOL touchedControlIsTile = [self.touchedControl isKindOfClass:[UPTileView class]];
                    BOOL hitControlIsTile = [hitControl isKindOfClass:[UPTileView class]];
                    BOOL hitControlIsWordTray = (hitControl == self.gameView.wordTrayControl);
                    if ((touchedControlIsTile && hitControlIsTile) || (touchedControlIsTile && hitControlIsWordTray)) {
                        [self acceptTouchedControl];
                    }
                    else {
                        [self cancelActiveTouch];
                    }
                }
                self.touchedControl = hitControl;
                self.activeTouch = touch;
                self.activeTouchStartTimestamp = CACurrentMediaTime();
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
            Tile &tile = m_spell_model->find_tile(tileView);
            [self applyActionPick:tile];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.mode != Mode::Play) {
        return;
    }

    if (self.touchedControl && !self.touchedControl.userInteractionEnabled) {
        [self cancelActiveTouch];
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
        ASSERT(m_spell_model->word().length() > 0);
        ASSERT(self.pickedTileView == nil);
        self.gameView.wordTrayControl.highlighted = NO;
        self.touchedTileView.highlighted = YES;
        self.touchedControl = self.touchedTileView;
        [self resetActiveTouchTracking];
        Tile &tile = m_spell_model->find_tile(self.touchedTileView);
        [self applyActionPick:tile];
    }
    
    if ([self.touchedControl isKindOfClass:[UPTileView class]]) {
        UPTileView *tileView = (UPTileView *)self.touchedControl;
        if (self.pickedTileView) {
            ASSERT(self.pickedTileView == tileView);
            SpellLayout &layout = SpellLayout::instance();
            tileView.center = up_point_with_exponential_barrier(self.activeTouchPanPoint, layout.tile_drag_barrier_frame());
            BOOL tileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), self.activeTouchPanPoint);
            Tile &tile = m_spell_model->find_tile(tileView);
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
    if (self.mode != Mode::Play) {
        return;
    }

    if (self.touchedControl && !self.touchedControl.userInteractionEnabled) {
        [self cancelActiveTouch];
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

- (void)acceptTouchedControl
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
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval elapsed = now - self.activeTouchStartTimestamp;
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
    LOG(Gestures, "   elapsed:    %.3f", elapsed);
    Tile &tile = m_spell_model->find_tile(tileView);
    if (self.pickedTilePosition.in_player_tray()) {
        if (elapsed <= 0.5 || !pannedFar || projectedTileInsideWordTray) {
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
        Tile &tile = m_spell_model->find_tile(tileView);
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
        m_spell_model->word().length() > 0) {
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
    for (UPTileView *tileView in m_spell_model->all_tile_views()) {
        CGPoint tilePoint = [tileView convertPoint:point fromView:self.gameView.window];
        if (tileView.userInteractionEnabled && [tileView pointInside:tilePoint withEvent:event]) {
            return tileView;
        }
    }
    
    return nil;
}

#pragma mark - Control target/action and gestures

- (void)wordTrayTapped
{
    ASSERT(self.mode == Mode::Play);
    
    if (self.gameView.wordTrayControl.active) {
        [self applyActionSubmit];
    }
    else if (m_spell_model->word().length() == 0) {
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

- (void)playChoiceBackButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::PlayMenu);
    [self setMode:Mode::Init];
}

- (void)playChoiceGoButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::PlayMenu);
    [self setMode:Mode::Ready];
}

- (void)roundButtonPauseTapped
{
    ASSERT(self.mode == Mode::Play);
    [self setMode:Mode::Pause];
}

- (void)roundButtonClearTapped
{
    ASSERT(self.mode == Mode::Play);
    if (m_spell_model->word().length()) {
        [self applyActionClear];
    }
    else {
        [self applyActionDump];
    }
}

- (void)tileViewTapped:(UPTileView *)tileView
{
    ASSERT(self.mode == Mode::Play);
    
    const Tile &tile = m_spell_model->find_tile(tileView);
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
    size_t word_length = self.pickedTilePosition.in_word_tray() ? m_spell_model->word().length() : m_spell_model->word().length() + 1;
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
    TilePosition word_pos = TilePosition(TileTray::Word, m_spell_model->word().length());
    const State &state = m_spell_model->back_state();
    if (state.action().opcode() == SpellModel::Opcode::HOVER) {
        word_pos = state.action().pos1();
        wordTrayTilesNeedMoves = NO;
    }

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::ADD, tile.position(), word_pos));

    if (wordTrayTilesNeedMoves) {
        SpellLayout &layout = SpellLayout::instance();
        for (UPTileView *wordTrayTileView in wordTrayTileViews) {
            Tile &tile = m_spell_model->find_tile(wordTrayTileView);
            ASSERT(tile.position().in_word_tray());
            Location location = role_in_word(tile.position().index(), m_spell_model->word().length());
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
    Location location(role_in_word(word_pos.index(), m_spell_model->word().length()));
    start(bloop_in(BandGameUITile, @[UPViewMoveMake(tileView, location)], DefaultBloopDuration, nil));

    [self viewUpdateGameControls];
}

- (void)applyActionRemove:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView);
    ASSERT_POS(self.pickedTilePosition);

    cancel(BandGameDelay);

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::REMOVE, tile.position()));

    [self viewSlideWordTrayViewsIntoPosition];

    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];

    Tile &tileBefore = m_spell_model->find_tile(tileView);
    [self viewMoveTileToClosestOpenPlayerTrayPosition:tileBefore];
    Tile &tileAfter = m_spell_model->find_tile(tileView);
    start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, role_for(TileTray::Player, tileAfter.position().index()))], DefaultBloopDuration, nil));

    [self viewUpdateGameControls];
}

- (void)applyActionMoveTile:(const Tile &)tile toPosition:(const TilePosition &)position
{
    ASSERT(tile.has_view());
    ASSERT(position.in_word_tray());

    cancel(BandGameAll);

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::MOVE, tile.position(), position));

    [self viewSlideWordTrayViewsIntoPosition];
    [self viewUpdateGameControls];
}

- (void)applyActionPick:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == nil);
    ASSERT_NPOS(self.pickedTilePosition);

    [self playSoundIDIfEnabled:UPSoundIDTap];
    self.tapSoundTimestamp = CACurrentMediaTime();
    
    [self viewOrderOutWordScoreLabel];

    UPTileView *tileView = tile.view();
    [tileView cancelAnimations];

    self.pickedTileView = tileView;
    self.pickedTilePosition = tile.position();

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::PICK, tile.position()));

    [self.gameView.tileContainerView bringSubviewToFront:tileView];
}

- (void)applyActionHoverIfNeeded:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == tile.view());
    ASSERT_POS(self.pickedTilePosition);

    cancel(BandGameDelay);
    cancel(@[tile.view()], (UPAnimatorTypeBloopIn | UPAnimatorTypeSlide));

    TilePosition hover_position = [self calculateHoverPosition:tile];
    ASSERT_POS(hover_position);

    const State &state = m_spell_model->back_state();
    if (state.action().opcode() != SpellModel::Opcode::HOVER || state.action().pos1() != hover_position) {
        if (tile.position().in_player_tray() || m_spell_model->back_opcode() != SpellModel::Opcode::PICK) {
            if ([self shouldPlayTubSound]) {
                [self playSoundIDIfEnabled:UPSoundIDTub];
            }
        }
        m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::HOVER, hover_position));
    }
    
    [self viewHover:hover_position];
    [self viewUpdateGameControls];
}

- (void)applyActionNoverIfNeeded:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedTileView == tile.view());
    ASSERT_POS(self.pickedTilePosition);

    cancel(BandGameDelay);
    cancel(@[tile.view()], (UPAnimatorTypeBloopIn | UPAnimatorTypeSlide));

    if (m_spell_model->back_opcode() != SpellModel::Opcode::HOVER) {
        return;
    }
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::NOVER));

    if ([self shouldPlayTubSound]) {
        [self playSoundIDIfEnabled:UPSoundIDTub];
    }

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

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::DROP, self.pickedTilePosition));

    CFTimeInterval duration = DefaultBloopDuration;
    
    if (self.pickedTilePosition.in_word_tray()) {
        Location location(role_in_word(self.pickedTilePosition.index(), m_spell_model->word().length()));
        start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, location)], duration, nil));
    }
    else {
        Tile &tileBefore = m_spell_model->find_tile(tileView);
        [self viewMoveTileToClosestOpenPlayerTrayPosition:tileBefore];
        Tile &tileAfter = m_spell_model->find_tile(tileView);
        start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, role_for(TileTray::Player, tileAfter.position().index()))], duration, nil));
    }

    [self viewUpdateGameControls];
}

- (void)applyActionClear
{
    cancel(BandGameDelay);
    cancel(BandGameUI);

    [self viewClearWordTray];
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::CLEAR));

    [self playSoundIDIfEnabled:UPSoundIDWhoops];

    [self viewUpdateGameControls];
}

- (void)applyActionSubmit
{
    const Word &word = m_spell_model->word();
    const State &state = m_spell_model->back_state();
    if (state.action().opcode() == SpellModel::Opcode::SUBMIT) {
        return;
    }

    UPSoundID soundID = UPSoundIDHappy1;
    if (word.total_score() >= 30) {
        soundID = UPSoundIDHappy4;
    }
    else if (word.total_score() >= 20) {
        soundID = UPSoundIDHappy3;
    }
    else if (word.total_score() >= 10) {
        soundID = UPSoundIDHappy2;
    }
    [self playSoundIDIfEnabled:soundID];

    cancel(BandGameDelay);

    [self viewSubmitWord];
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::SUBMIT));
    delay(BandGameDelay, 0.25, ^{
        [self viewFillPlayerTray];
        [self viewUpdateGameControls];
    });
}

- (void)applyActionReject
{
    cancel(BandGameDelay);

    [self viewLockIncludingPause:NO];

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::REJECT));

    [self playSoundIDIfEnabled:UPSoundIDSad1];

    // assess time penalty and shake word tray side-to-side
    [UIView animateWithDuration:0.15 animations:^{
        [self viewPenaltyForReject];
    }];

    self.gameView.wordTrayControl.active = NO;
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.gameView.wordTrayControl];
    [views addObjectsFromArray:[self wordTrayTileViews]];
    delay(BandGameDelay, 0.1, ^{
        start(shake(BandGameUI, views, 0.9, layout.word_tray_shake_offset(), ^(UIViewAnimatingPosition finishedPosition) {
            if (finishedPosition == UIViewAnimatingPositionEnd) {
                delay(BandGameDelay, 0.1, ^{
                    [UIView animateWithDuration:0.15 animations:^{
                        [self viewPenaltyFinished];
                    }];
                });
                delay(BandGameDelay, 0.25, ^{
                    [self applyActionClear];
                    [self viewUnlock];
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

    NSArray *playerTrayTileViews = m_spell_model->player_tray_tile_views();
    ASSERT(playerTrayTileViews.count == TileCount);

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::DUMP));

    [self playSoundIDIfEnabled:UPSoundIDSad2];

    [UIView animateWithDuration:0.15 animations:^{
        [self viewPenaltyForDump];
    }];
    [self viewDumpPlayerTray:playerTrayTileViews];
    delay(BandGameDelay, 1.65, ^{
        delay(BandGameDelay, 0.1, ^{
            [self viewPenaltyFinished];
        });
        [self viewFillPlayerTrayWithCompletion:^{
            [self viewUnlock];
        }];
    });
}

- (void)applyActionQuit
{
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::QUIT));
    [self setMode:Mode::Quit];
}

#pragma mark - View ops

- (void)viewUpdateGameControls
{
    // word tray
    if (self.mode == Mode::Attract || self.mode == Mode::Play || self.mode == Mode::Pause) {
        Opcode back = m_spell_model->back_opcode();
        BOOL active = m_spell_model->word().in_lexicon() && back != Opcode::HOVER && back != Opcode::NOVER;
        self.gameView.wordTrayControl.active = active;
    }
    else {
        self.gameView.wordTrayControl.active = NO;
    }
    [self.gameView.wordTrayControl setNeedsUpdate];

    // clear button
    if (m_spell_model->word().length()) {
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
    }
    else {
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];
    }
    [self.gameView.clearControl setNeedsUpdate];

    self.gameView.gameScoreLabel.string = [NSString stringWithFormat:@"%d", m_spell_model->game_score()];
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
        Tile &tile = m_spell_model->find_tile(tileView);
        [moves addObject:UPViewMoveMake(tileView, role_in_word(tile.position().index(), m_spell_model->word().length()))];
    }
    start(UP::TimeSpanning::slide(BandGameUITileSlide, moves, DefaultTileSlideDuration, nil));
}

- (void)viewHover:(const TilePosition &)hover_pos
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    size_t word_length = self.pickedTilePosition.in_word_tray() ? m_spell_model->word().length() : m_spell_model->word().length() + 1;

    if (self.pickedTilePosition.in_player_tray()) {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedTileView);
            const Tile &tile = m_spell_model->find_tile(tileView);
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
            const Tile &tile = m_spell_model->find_tile(tileView);
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

    size_t word_length = self.pickedTilePosition.in_word_tray() ? m_spell_model->word().length() - 1 : m_spell_model->word().length();

    if (self.pickedTilePosition.in_player_tray()) {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedTileView);
            const Tile &tile = m_spell_model->find_tile(tileView);
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
            const Tile &tile = m_spell_model->find_tile(tileView);
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

    m_spell_model->move_word_tray_tiles_back_to_player_tray();
    
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        TileIndex idx = m_spell_model->player_tray_index(tileView);
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
        Tile &tile = m_spell_model->find_tile(tileView);
        ASSERT(tile.position().in_word_tray());
        Location location(role_in_word(tile.position().index(), m_spell_model->word().length()), Place::OffTopNear);
        tileView.submitLocation = location;
        [moves addObject:UPViewMoveMake(tileView, location)];
    }
    start(bloop_out(BandGameUI, moves, 0.3, nil));
    
    [self viewUpdateWordScoreLabel];

    Role role = (m_spell_model->word().length() >= 5 || m_spell_model->word().total_multiplier() > 1) ? Role::WordScoreBonus : Role::WordScore;

    SpellLayout &layout = SpellLayout::instance();
    self.gameView.wordScoreLabel.frame = layout.frame_for(role, Place::OffBottomFar);
    self.gameView.wordScoreLabel.hidden = NO;
    
    UPViewMove *wordScoreInMove = UPViewMoveMake(self.gameView.wordScoreLabel, Location(role, Place::Default));

    delay(BandGameDelay, 0.25, ^{
        self.showingWordScoreLabel = YES;
        start(bloop_in(BandWordScore, @[wordScoreInMove], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandGameDelay, 1.5, ^{
                [self viewBloopOutWordScoreLabelWithDuration:DefaultBloopDuration];
            });
        }));
    });
}

- (void)viewUpdateWordScoreLabel
{
    UIColor *wordScoreColor = [UIColor themeColorWithCategory:self.gameView.wordScoreLabel.colorCategory];
    
    SpellLayout &layout = SpellLayout::instance();
    NSString *string = [NSString stringWithFormat:@"+%d \n", m_spell_model->word().total_score()];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, string.length);
    [attrString addAttribute:NSFontAttributeName value:layout.word_score_font() range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:wordScoreColor range:range];
    
    Role role = Role::WordScore;
    
    const size_t word_length = m_spell_model->word().length();
    const int word_multiplier = m_spell_model->word().total_multiplier();
    NSString *lengthBonusString = nil;
    switch (word_length) {
        case 5:
            lengthBonusString = [NSString stringWithFormat:@"TILES +%d", SpellModel::FiveLetterWordBonus];
            break;
        case 6:
            lengthBonusString = [NSString stringWithFormat:@"TILES +%d", SpellModel::SixLetterWordBonus];
            break;
        case 7:
            lengthBonusString = [NSString stringWithFormat:@"TILES +%d", SpellModel::SevenLetterWordBonus];
            break;
    }
    BOOL has_length_bonus = lengthBonusString != nil;
    BOOL has_multiplier_bonus = word_multiplier > 1;
    if (has_length_bonus || has_multiplier_bonus) {
        role = Role::WordScoreBonus;
        NSMutableString *bonusString = [NSMutableString string];
        if (has_multiplier_bonus && has_length_bonus) {
            [bonusString appendFormat:@"%d× WORD & ", word_multiplier];
            [bonusString appendString:lengthBonusString];
        }
        else if (has_multiplier_bonus) {
            [bonusString appendFormat:@"%d× WORD ", word_multiplier];
        }
        else {
            [bonusString appendString:lengthBonusString];
        }
        
        NSMutableAttributedString *bonusAttrString = [[NSMutableAttributedString alloc] initWithString:bonusString];
        NSRange bonusRange = NSMakeRange(0, bonusString.length);
        [bonusAttrString addAttribute:NSFontAttributeName value:layout.word_score_bonus_font() range:bonusRange];
        [bonusAttrString addAttribute:NSForegroundColorAttributeName value:wordScoreColor range:bonusRange];
        CGFloat baselineAdjustment = layout.word_score_bonus_font().baselineAdjustment;
        [bonusAttrString addAttribute:(NSString *)kCTBaselineOffsetAttributeName value:@(baselineAdjustment) range:bonusRange];
        [attrString appendAttributedString:bonusAttrString];
    }
    
    self.gameView.wordScoreLabel.attributedString = attrString;
}

- (void)viewBloopOutWordScoreLabelWithDuration:(CFTimeInterval)duration
{
    if (self.showingWordScoreLabel) {
        UPViewMove *wordScoreOutMove = UPViewMoveMake(self.gameView.wordScoreLabel, Location(Role::WordScore, Place::OffTopNear));
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

- (void)viewMoveTileToClosestOpenPlayerTrayPosition:(Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(tile.in_player_tray());

    SpellLayout &layout = SpellLayout::instance();
    
    UPTileView *tileView = tile.view();
    CGPoint existingTileCenter = layout.center_for(Location(role_for(TileTray::Player, tile.position().index())));
    CGFloat minDistance = up_point_distance(tileView.center, existingTileCenter);
    TileIndex pidx = tile.position().index();
    
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    for (UPTileView *tv in wordTrayTileViews) {
        TileIndex idx = m_spell_model->player_tray_index(tv);
        CGPoint center = layout.center_for(Location(role_for(TileTray::Player, idx)));
        CGFloat distance = up_point_distance(tileView.center, center);
        if (minDistance > distance) {
            minDistance = distance;
            pidx = idx;
        }
    }
    
    if (tile.position().index() != pidx) {
        TileIndex tidx = tile.position().index();
        tile.set_position(TilePosition(TileTray::Player, pidx));
        m_spell_model->swap_tiles_at_indices(tidx, pidx);
    }
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
        Location location(role_in_player_tray(TilePosition(TileTray::Player, idx)), Place::OffBottomNear);
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
    for (auto &tile : m_spell_model->tiles()) {
        if (tile.has_view<false>()) {
            const TileModel &model = tile.model();
            UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
            tile.set_view(tileView);
            tileView.band = UP::BandGameUIColor;
            Role role = role_in_player_tray(TilePosition(TileTray::Player, idx));
            tileView.frame = layout.frame_for(Location(role, Place::OffBottomNear));
            [self.gameView.tileContainerView addSubview:tileView];
            [moves addObject:UPViewMoveMake(tileView, Location(role, Place::Default))];
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
    self.gameView.clearControl.highlightedLocked = YES;
    self.gameView.clearControl.highlighted = YES;
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonDump];
}

- (void)viewPenaltyForReject
{
    ASSERT(self.lockCount > 0);
    self.gameView.wordTrayControl.highlightedLocked = YES;
    self.gameView.wordTrayControl.highlighted = YES;
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonReject];
}

- (void)viewPenaltyFinished
{
    ASSERT(self.lockCount > 0);
    self.gameView.wordTrayControl.highlightedLocked = NO;
    self.gameView.wordTrayControl.highlighted = NO;
    self.gameView.clearControl.highlightedLocked = NO;
    self.gameView.clearControl.highlighted = NO;
    m_alpha_reason_stack.clear();
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPlay];
}

- (void)viewSetGameAlphaWithReason:(UPSpellGameAlphaStateReason)reason
{
    ASSERT(self.lockCount > 0);

    switch (reason) {
        case UPSpellGameAlphaStateReasonInit:
        case UPSpellGameAlphaStateReasonOrderOutGameEnd:
        case UPSpellGameAlphaStateReasonReady:
        case UPSpellGameAlphaStateReasonQuitToEnd: {
            CGFloat alpha = [UIColor themeDisabledAlpha];
            for (UIView *view in self.gameView.subviews) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonRestoredPause: {
            CGFloat alpha = [UIColor themeModalBackgroundAlpha];
            for (UIView *view in self.gameView.subviews) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonPause: {
            CGFloat alpha = [UIColor themeModalBackgroundAlpha];
            for (UIView *view in self.gameView.subviews) {
                view.alpha = alpha;
            }
            break;
        }
        case UPSpellGameAlphaStateReasonPlayMenu: {
            CGFloat alpha = 0.02;
            for (UIView *view in self.gameView.subviews) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonPrePlay: {
            for (UIView *view in self.gameView.subviews) {
                if (view == self.gameView.tileContainerView) {
                    continue;
                }
                view.alpha = 1.0;
            }
            self.gameView.tileContainerView.alpha = [UIColor themeDisabledAlpha];
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonDefault:
        case UPSpellGameAlphaStateReasonPlay: {
            if (m_alpha_reason_stack.size()) {
                if (m_alpha_reason_stack.back() == UPSpellGameAlphaStateReasonReject) {
                    for (UIView *view in self.gameView.subviews) {
                        if (view == self.gameView.wordTrayControl ||
                            view == self.gameView.clearControl ||
                            view == self.gameView.tileContainerView) {
                            view.alpha = [UIColor themeDisabledAlpha];
                        }
                        else {
                            view.alpha = 1.0;
                        }
                    }
                }
                else if (m_alpha_reason_stack.back() == UPSpellGameAlphaStateReasonDump) {
                    for (UIView *view in self.gameView.subviews) {
                        if (view == self.gameView.wordTrayControl ||
                            view == self.gameView.tileContainerView) {
                            view.alpha = [UIColor themeDisabledAlpha];
                        }
                        else {
                            view.alpha = 1.0;
                        }
                    }
                }
            }
            else {
                CGFloat alpha = 1.0;
                for (UIView *view in self.gameView.subviews) {
                    view.alpha = alpha;
                }
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonReject: {
            CGFloat alpha = [UIColor themeDisabledAlpha];
            for (UIView *view in @[ self.gameView.wordTrayControl, self.gameView.clearControl, self.gameView.tileContainerView ]) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.push_back(UPSpellGameAlphaStateReasonReject);
            break;
        }
        case UPSpellGameAlphaStateReasonDump: {
            CGFloat alpha = [UIColor themeDisabledAlpha];
            for (UIView *view in @[ self.gameView.tileContainerView ]) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.push_back(UPSpellGameAlphaStateReasonDump);
            break;
            break;
        }
        case UPSpellGameAlphaStateReasonGameOver: {
            CGFloat alpha = [UIColor themeModalGameOverAlpha];
            for (UIView *view in self.gameView.subviews) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonOverToEnd: {
            CGFloat alpha = [UIColor themeModalBackgroundAlpha];
            for (UIView *view in self.gameView.subviews) {
                view.alpha = alpha;
            }
            break;
        }
    }
    
}

- (void)viewLock
{
    [self viewLockIncludingPause:YES];
}

- (void)viewLockIncludingPause:(BOOL)includingPause
{
    self.lockCount++;

    self.dialogTopMenu.userInteractionEnabled = NO;

    UIView *roundButtonPause = self.gameView.pauseControl;
    for (UIView *view in self.gameView.subviews) {
        if (!includingPause && view == roundButtonPause) {
            continue;
        }
        view.userInteractionEnabled = NO;
    }
    
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        tileView.userInteractionEnabled = NO;
    }
}

- (void)viewUnlock
{
    ASSERT(self.lockCount > 0);
    self.lockCount = UPMaxT(NSInteger, self.lockCount - 1, 0);
    if (self.lockCount > 0) {
        return;
    }

    self.dialogTopMenu.userInteractionEnabled = YES;

    for (UIView *view in self.gameView.subviews) {
        view.userInteractionEnabled = YES;
    }
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        tileView.userInteractionEnabled = YES;
    }
}

- (void)viewUnhighlightTileViews
{
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        [tileView setFillColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
        [tileView setStrokeColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
        tileView.highlightedLocked = NO;
        tileView.highlighted = NO;
        [tileView invalidate];
        [tileView update];
        [tileView freeze];
    }
}

- (BOOL)viewIsUpSpellFilled
{
    TileIndex idx = 0;
    TileIndex ok = 0;
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        TileModel model = TileModel(tileView.glyph, tileView.multiplier);
        switch (idx) {
            case 0:
                if (model == TileModel(U'U')) {
                    ok++;
                }
                break;
            case 1:
                if (model == TileModel(U'P')) {
                    ok++;
                }
                break;
            case 2:
                if (model == TileModel(U'S')) {
                    ok++;
                }
                break;
            case 3:
                if (model == TileModel(U'P')) {
                    ok++;
                }
                break;
            case 4:
                if (model == TileModel(U'E')) {
                    ok++;
                }
                break;
            case 5:
                if (model == TileModel(U'L')) {
                    ok++;
                }
                break;
            case 6:
                if (model == TileModel(U'L')) {
                    ok++;
                }
                break;
        }
        idx++;
    }
    return ok == TileCount;
}

- (void)viewFillUpSpellTileViews
{
    ASSERT(m_spell_model->is_blank_filled());
    
    if ([self viewIsUpSpellFilled]) {
        return;
    }
    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SpellLayout &layout = SpellLayout::instance();
    TileIndex idx = 0;
    for (auto &tile : m_spell_model->tiles()) {
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
    ASSERT(m_spell_model->is_blank_filled());
    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SpellLayout &layout = SpellLayout::instance();
    TileIndex idx = 0;
    for (auto &tile : m_spell_model->tiles()) {
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

- (void)viewRestoreInProgressGame
{
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SpellLayout &layout = SpellLayout::instance();
    TileIndex idx = 0;
    for (auto &tile : m_spell_model->tiles()) {
        if (tile.has_view<false>()) {
            const TileModel &model = tile.model();
            UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
            tile.set_view(tileView);
            tileView.band = BandGameUI;
            if (tile.in_word_tray()) {
                tileView.frame = layout.frame_for(role_in_word(tile.position().index(), m_spell_model->word().length()));
            }
            else {
                tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
            }

            [self.gameView.tileContainerView addSubview:tileView];
        }
        idx++;
    }
}

- (void)viewBloopTileViewsToPlayerTrayWithDuration:(CFTimeInterval)duration completion:(void (^)(void))completion
{
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (const auto &tile : m_spell_model->tiles()) {
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
    [self viewBloopOutExistingTileViewsWithDuration:duration tiles:m_spell_model->tiles() wordLength:m_spell_model->word().length() completion:completion];
}

- (void)viewBloopOutExistingTileViewsWithDuration:(CFTimeInterval)duration
                                            tiles:(const TileArray &)tiles
                                       wordLength:(size_t)wordLength
                                       completion:(void (^)(void))completion
{
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    NSMutableSet *submittedTileViews = [NSMutableSet setWithArray:self.gameView.tileContainerView.subviews];
    for (const auto &tile : tiles) {
        if (tile.has_view()) {
            UPTileView *tileView = tile.view();
            if (tile.in_word_tray()) {
                Role role = role_in_word(tile.position().index(), wordLength);
                [moves addObject:UPViewMoveMake(tileView, role, Place::OffBottomNear)];
            }
            else {
                [moves addObject:UPViewMoveMake(tileView, role_in_player_tray(tile.position()), Place::OffBottomNear)];
            }
            [submittedTileViews removeObject:tileView];
        }
    }
    for (UPTileView *tileView in submittedTileViews) {
        if (tileView.submitLocation.role() != Role::None) {
            [moves addObject:UPViewMoveMake(tileView, tileView.submitLocation)];
        }
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
    ASSERT(m_spell_model->is_blank_filled());
    ASSERT(m_spell_model->is_player_tray_filled());
    
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray<UPViewMove *> *tileInMoves = [NSMutableArray array];
    TileIndex idx = 0;
    for (auto &tile : m_spell_model->tiles()) {
        const TileModel &model = tile.model();
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tile.set_view(tileView);
        tileView.band = BandModeUI;
        Role role = role_in_player_tray(tile.position());
        tileView.frame = layout.frame_for(Location(role, Place::OffBottomNear));
        [self.gameView.tileContainerView addSubview:tileView];
        [tileInMoves addObject:UPViewMoveMake(tileView, Location(role, Place::Default))];
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
    ASSERT(m_spell_model->is_blank_filled());
    ASSERT(m_spell_model->is_player_tray_filled());

    [self viewFillUpSpellTileViews];

    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray<UPViewMove *> *tileInMoves = [NSMutableArray array];
    TileIndex idx = 0;
    for (auto &tile : m_spell_model->tiles()) {
        UPTileView *tileView = tile.view();
        Role role = role_in_player_tray(tile.position());
        tileView.frame = layout.frame_for(Location(role, Place::OffBottomNear));
        [tileInMoves addObject:UPViewMoveMake(tileView, Location(role, Place::Default))];
        idx++;
    }

    start(bloop_in(BandModeUI, tileInMoves, duration, ^(UIViewAnimatingPosition) {
        if (completion) {
            completion();
        }
    }));
}

- (void)viewDumpAllTilesFromCurrentPosition:(const TileArray &)tiles wordLength:(size_t)wordLength
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
        const Tile &tile = tiles[idx];
        if (tile.has_view()) {
            UPTileView *tileView = tile.view();
            Location location;
            if (tile.in_word_tray()) {
                location = Location(role_in_word(tile.position().index(), wordLength), Place::OffBottomNear);
            }
            else {
                location = Location(role_in_player_tray(tile.position()), Place::OffBottomNear);
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
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogTopMenu.playButton, Location(Role::DialogButtonTopCenter, Place::OffLeftFar));
    UPViewMove *extrasButtonMove = UPViewMoveMake(self.dialogTopMenu.extrasButton, Location(Role::DialogButtonTopLeft, Place::OffLeftFar));
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Location(Role::Screen, Place::OffLeftNear));
    UPViewMove *dialogGameOverMove = UPViewMoveMake(self.dialogGameOver, Location(Role::Screen, Place::OffLeftNear));
    UPViewMove *dialogGameNoteMove = UPViewMoveMake(self.dialogGameNote, Location(Role::Screen, Place::OffLeftNear));

    CFTimeInterval duration = 0.75;
    CFTimeInterval stagger = 0.075;

    start(bloop_out(BandModeUI, @[extrasButtonMove], duration, nil));
    delay(BandModeDelay, stagger, ^{
        start(bloop_out(BandModeUI, @[playButtonMove], duration - stagger, nil));
    });
    delay(BandModeDelay, (1.5 * stagger), ^{
        start(bloop_out(BandModeUI, @[gameViewMove, dialogGameOverMove, dialogGameNoteMove], duration - (1.5 * stagger),
                        ^(UIViewAnimatingPosition) {
            self.dialogTopMenu.aboutButton.userInteractionEnabled = NO;
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
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogTopMenu.playButton, Location(Role::DialogButtonTopCenter, Place::OffRightFar));
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogTopMenu.aboutButton, Location(Role::DialogButtonTopRight, Place::OffRightFar));
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Location(Role::Screen, Place::OffRightNear));
    UPViewMove *dialogGameOverMove = UPViewMoveMake(self.dialogGameOver, Location(Role::Screen, Place::OffRightNear));
    UPViewMove *dialogGameNoteMove = UPViewMoveMake(self.dialogGameNote, Location(Role::Screen, Place::OffRightNear));

    CFTimeInterval duration = 0.75;
    CFTimeInterval stagger = 0.075;

    start(bloop_out(BandModeUI, @[aboutButtonMove], duration, nil));
    delay(BandModeDelay, stagger, ^{
        start(bloop_out(BandModeUI, @[playButtonMove], duration - stagger, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, (1.5 * stagger), ^{
        start(bloop_out(BandModeUI, @[gameViewMove, dialogGameOverMove, dialogGameNoteMove], duration - (1.5 * stagger),
                        ^(UIViewAnimatingPosition) {
            [self viewUnlock];
            if (completion) {
                completion();
            }
        }));
    });
}

- (void)viewOrderInPlayMenu
{
    [self viewLock];
    [self viewFillUpSpellTileViews];

    [self.dialogPlayMenu updateChoiceLabels];
    
    self.dialogTopMenu.playButton.userInteractionEnabled = NO;
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogPlayMenu.backButton.center = layout.center_for(Role::ChoiceBackCenter, Place::OffTopNear);
    self.dialogPlayMenu.goButton.center = layout.center_for(Role::ChoiceGoButtonCenter, Place::OffBottomFar);
    
    Role choiceItemRoles[3] = { Role::ChoiceItem1Center, Role::ChoiceItem2Center, Role::ChoiceItem3Center };
    for (UPChoice *choice in self.dialogPlayMenu.choices) {
        [choice sizeToFit];
        Location location(choiceItemRoles[choice.tag], Place::OffBottomNear);
        CGPoint center = layout.center_for(location);
        CGSize defaultSize = layout.size_for(location);
        CGSize effectiveSize = choice.bounds.size;
        center.x += ((effectiveSize.width - defaultSize.width) * 0.5);
        center.y += ((effectiveSize.height - defaultSize.height) * 0.5);
        choice.center = center;
    }
    
    NSArray<UPViewMove *> *buttonOutMoves = @[
        UPViewMoveMake(self.dialogTopMenu.extrasButton, Role::DialogButtonTopLeft, Place::OffLeftNear),
        UPViewMoveMake(self.dialogTopMenu.aboutButton, Role::DialogButtonTopRight, Place::OffRightNear),
        UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageVerticallyCentered, Place::OffBottomNear),
        UPViewMoveMake(self.dialogGameNote.noteLabel, Role::DialogGameNote, Place::OffBottomFar),
    ];
    start(bloop_out(BandModeUI, buttonOutMoves, 0.4, nil));
    [UIView animateWithDuration:0.4 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPlayMenu];
    } completion:nil];
    
    
    [self.dialogPlayMenu updateThemeColors];
    self.dialogPlayMenu.hidden = NO;
    self.dialogPlayMenu.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogPlayMenu.alpha = 1.0;
    }];
    
    delay(BandModeDelay, 0.35, ^{
        NSArray<UPViewMove *> *buttonInMoves = @[
            UPViewMoveMake(self.dialogTopMenu.playButton, Role::ChoiceTitleCenter),
            UPViewMoveMake(self.dialogPlayMenu.backButton, Role::ChoiceBackCenter),
            UPViewMoveMake(self.dialogPlayMenu.goButton, Role::ChoiceGoButtonCenter),
            UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice1, Role::ChoiceItem1Center),
            UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice2, Role::ChoiceItem2Center),
            UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice3, Role::ChoiceItem3Center),
        ];
        start(bloop_in(BandModeUI, buttonInMoves, 0.5, ^(UIViewAnimatingPosition) {
            [self viewUnlock];
        }));
    });
}

- (void)viewOrderOutGameEnd
{
    ASSERT(self.lockCount > 0);
    
    // reset game controls
    m_spell_model->reset_game_score();
    [self.gameTimer reset];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonOrderOutGameEnd];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.messagePathView.center = layout.center_for(Role::DialogMessageVerticallyCentered, Place::OffBottomNear);
    self.dialogGameOver.transform = CGAffineTransformIdentity;
    self.dialogGameOver.hidden = YES;
    self.dialogGameNote.noteLabel.center = layout.center_for(Role::DialogGameNote, Place::OffBottomFar);
    self.dialogGameNote.hidden = YES;
}

- (void)viewMakeReadyFromMode:(Mode)mode completion:(void (^)(void))completion
{
    ASSERT(m_spell_model->is_blank_filled());
    ASSERT(self.lockCount > 0);

    // lock play button in highlighted state
    self.dialogTopMenu.playButton.highlightedLocked = YES;
    self.dialogTopMenu.playButton.highlighted = YES;
    
    // reset game controls
    m_spell_model->reset_game_score();
    [self.gameTimer reset];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    
    delay(BandModeDelay, 0.1, ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonReady];
        }];
    });

    [self updateSoundAndTunesSettings];
//    [self playTuneIntro];

    void (^bottomHalf)(void) = ^{
        // change transform of game view
        [UIView animateWithDuration:0.75 animations:^{
            self.gameView.transform = CGAffineTransformIdentity;
        }];
        delay(BandModeDelay, 0.45, ^{
            // bloop in ready message
            self.dialogTopMenu.messagePathView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.dialogTopMenu.messagePathView.alpha = 1;
            }];
            UPViewMove *readyMove = UPViewMoveMake(self.dialogTopMenu.messagePathView, Location(Role::DialogMessageCenteredInWordTray));
            start(bloop_in(BandModeUI, @[readyMove], 0.3,  ^(UIViewAnimatingPosition) {
                delay(BandModeDelay, 1.0, ^{
                    if (completion) {
                        completion();
                    }
                });
            }));
        });
    };
    
    BOOL comingFromPlayMenu = mode == Mode::PlayMenu;
    if (comingFromPlayMenu) {
        self.dialogGameOver.transform = CGAffineTransformIdentity;
        bottomHalf();
    }
    else {
        [self playTuneIntro];

        // move extras and about buttons offscreen
        NSArray<UPViewMove *> *outGameOverMoves = @[
            UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageVerticallyCentered, Place::OffBottomNear),
            UPViewMoveMake(self.dialogGameNote.noteLabel, Role::DialogGameNote, Place::OffBottomFar),
        ];
        start(bloop_out(BandModeUI, outGameOverMoves, 0.2, nil));
        NSArray<UPViewMove *> *outMoves = @[
            UPViewMoveMake(self.dialogTopMenu.extrasButton, Location(Role::DialogButtonTopLeft, Place::OffTopNear)),
            UPViewMoveMake(self.dialogTopMenu.aboutButton, Location(Role::DialogButtonTopRight, Place::OffTopNear)),
        ];
        start(bloop_out(BandModeUI, outMoves, 0.3, ^(UIViewAnimatingPosition) {
            self.dialogGameOver.transform = CGAffineTransformIdentity;
            
            delay(BandModeDelay, 0.35, ^{
                // move play button
                NSArray<UPViewMove *> *playMoves = @[
                    UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter, Place::OffTopNear),
                    UPViewMoveMake(self.playMenuChoice, Role::ChoiceItemTopCenter, Place::OffTopNear),
                ];
                start(slide(BandModeUI, playMoves, 0.3, nil));
                bottomHalf();
            });
        }));
    }
}

- (void)viewSetNoteLabelString
{
    ASSERT(self.mode == Mode::End);
    
    id labelString = nil;
    
    if (!labelString) {
        id noteString = [self gameNoteGameHighScore];
        if (noteString) {
            labelString = noteString;
        }
    }
    if (!labelString) {
        id noteString = [self gameNoteBestWordInGame];
        if (noteString) {
            labelString = noteString;
        }
    }
    if (!labelString) {
        labelString = [self gameNoteRandomWord];
    }

    self.dialogGameNote.noteLabel.attributedString = labelString;

    NSArray *components = [labelString componentsSeparatedByString:@"\n"];
    if (components.count == 1) {
        self.dialogGameNote.noteLabel.string = labelString;
    }
    else if (components.count == 2) {
        SpellLayout &layout = SpellLayout::instance();
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:components[0]];
        [attrString addAttribute:NSFontAttributeName value:layout.game_note_font() range:NSMakeRange(0, attrString.length)];

        NSMutableAttributedString *bottomString = [[NSMutableAttributedString alloc] initWithString:components[1]];
        NSRange bottomRange = NSMakeRange(0, bottomString.length);
        [bottomString addAttribute:NSFontAttributeName value:layout.game_note_word_font() range:bottomRange];
        CGFloat baselineAdjustment = layout.game_note_word_font().baselineAdjustment;
        [bottomString addAttribute:(NSString *)kCTBaselineOffsetAttributeName value:@(baselineAdjustment) range:bottomRange];

        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [attrString appendAttributedString:bottomString];
        UIColor *color = [UIColor themeColorWithCategory:self.dialogGameNote.noteLabel.colorCategory];
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attrString.length)];

        self.dialogGameNote.noteLabel.attributedString = attrString;
    }

}

#pragma mark - Stats note strings

- (NSString *)gameNoteGameHighScore
{
    ASSERT(self.mode == Mode::End);

    NSString *result = nil;

    int score = m_spell_model->game_score();
    if (score == 0) {
        return result;
    }
    
    UPSpellDossier *dossier = [UPSpellDossier instance];
    if (score > dossier.highScore) {
        result = @"NEW HIGH SCORE!";
    }
    else if (score == dossier.highScore) {
        result = @"TIED HIGH SCORE!";
    }
    else if (score + 20 >= dossier.highScore) {
        result = [NSString stringWithFormat:@"CLOSE! ONLY %d LESS THAN YOUR HIGH SCORE (%d)", dossier.highScore - score, dossier.highScore];
    }

    return result;
}

- (NSString *)gameNoteBestWordInGame
{
    ASSERT(self.mode == Mode::End);
    
    std::vector<Word> words = m_spell_model->game_best_word();
    if (words.size() == 0) {
        return nil;
    }

    const Word &word = words[0];
    NSString *wordString = ns_str(word.string());
    return [NSString stringWithFormat:@"BEST WORD IN GAME: %@ +%d", wordString, word.total_score()];
}

- (NSString *)gameNoteRandomWord
{
    ASSERT(self.mode == Mode::End);
    
    Lexicon &lexicon = Lexicon::instance();
    std::u32string random_string = lexicon.random_key(Random::instance());
    return [NSString stringWithFormat:@"RANDOM WORD FROM THE LEXICON: %@", ns_str(random_string)];
}

#pragma mark - Model management

- (void)createNewGameModelIfNeeded
{
    if (self.playMenuChoice && self.playMenuChoice.tag != UPDialogPlayMenuChoiceNewGame) {
        UPSpellDossier *dossier = [UPSpellDossier instance];
        GameKey game_key;
        if (self.playMenuChoice.tag == UPDialogPlayMenuChoiceRetryHighScore) {
            game_key = GameKey(dossier.highGameKey);
        }
        else if (self.playMenuChoice.tag == UPDialogPlayMenuChoiceRetryLastGame) {
            game_key = GameKey(dossier.lastGameKey);
        }
        m_spell_model = std::make_shared<SpellModel>(game_key);
//        LOG(General, "GameKey: %s", game_key.string().c_str());
    }
    else {
        if (m_spell_model && m_spell_model->back_opcode() == SpellModel::Opcode::START) {
            return;
        }
        m_spell_model = std::make_shared<SpellModel>(GameKey::random());
    }
}

#pragma mark - Archiving persistent data and in-progress game

static NSString * const UPSpellInProgressGameFileName = @"up-spell-in-progress-game.dat";

- (void)saveInProgressGameIfNecessary
{
    if (m_spell_model->back_opcode() == Opcode::START || m_spell_model->back_opcode() == Opcode::END) {
        [self removeInProgressGameFileLogErrors:NO];
        return;
    }

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::PAUSE));
    
    UPSpellModel *model = [UPSpellModel spellModelWithInner:m_spell_model];
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:&error];
    if (error) {
        LOG(General, "error writing in-progress game data data: %@", error);
    }
    else {
        NSString *saveFilePath = [[NSFileManager defaultManager] documentsDirectoryPathWithFileName:UPSpellInProgressGameFileName];
        if (saveFilePath) {
            [data writeToFile:saveFilePath atomically:YES];
            LOG(General, "saveInProgressGameIfNecessary: %@", saveFilePath);
        }
        else {
            LOG(General, "error writing in-progress game data: save file unavailable, %@", saveFilePath);
        }
    }
}

- (SpellModelPtr)restoreInProgressGameIfExists
{
    SpellModelPtr result = nullptr;
    NSError *error;
    
    BOOL restored = NO;
    NSString *saveFilePath = [[NSFileManager defaultManager] documentsDirectoryPathWithFileName:UPSpellInProgressGameFileName];
    if (saveFilePath) {
        //LOG(General, "restoreInProgressGameIfExists: %@", saveFilePath);
        NSData *data = [NSData dataWithContentsOfFile:saveFilePath];
        if (data) {
            UPSpellModel *model = [NSKeyedUnarchiver unarchivedObjectOfClass:[UPSpellModel class] fromData:data error:&error];
            if (error) {
                LOG(General, "error reading in-progress game data: %@ : %@", saveFilePath, error);
            }
            else if (model.inner->back_opcode() != Opcode::PAUSE) {
                LOG(General, "in-progress game doesn't end with PAUSE: %@ : %@", saveFilePath, error);
            }
            else {
                restored = YES;
                result = model.inner;
                
                // restore tune and prepare sound engine
                UPSpellSettings *settings = [UPSpellSettings instance];
                NSArray<NSNumber *> *tuneHistory = settings.tuneHistory;
                if (tuneHistory.count) {
                    self.tuneNumber = [[tuneHistory lastObject] integerValue];
                }
                else {
                    self.tuneNumber = 1;
                }
                [self configureTunesForTuneNumber:self.tuneNumber];
                [self updateSoundAndTunesSettings];
            }
        }
    }
    
    [self removeInProgressGameFileLogErrors:restored];
    
    return result;
}

- (void)removeInProgressGameFile
{
    [self removeInProgressGameFileLogErrors:YES];
}

- (void)removeInProgressGameFileLogErrors:(BOOL)logErrors
{
    NSString *saveFilePath = [[NSFileManager defaultManager] documentsDirectoryPathWithFileName:UPSpellInProgressGameFileName];
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:saveFilePath error:&error];
    if (error && logErrors) {
        LOG(General, "error removing in-progress game data file: %@ : %@", saveFilePath, error);
    }
}

#pragma mark - Lifecycle notifications

- (void)configureLifecycleNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        [self removeInProgressGameFileLogErrors:NO];
    }];
    
    [nc addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        [self removeInProgressGameFileLogErrors:NO];
    }];
    
    [nc addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        if (self.mode == Mode::Play) {
            [self setMode:Mode::Pause transitionScenario:UPModeTransitionScenarioWillResignActive];
        }
        [self saveInProgressGameIfNecessary];
    }];
    [nc addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        if (self.mode == Mode::Play) {
            [self setMode:Mode::Pause transitionScenario:UPModeTransitionScenarioDidEnterBackground];
        }
        [self saveInProgressGameIfNecessary];
    }];
}

#pragma mark - Sounds and Tunes

- (void)configureSounds
{
    NSBundle *bundle = [NSBundle mainBundle];
    UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
    [soundPlayer setFilePath:[bundle pathForResource:@"None" ofType:@"aac"] forSoundID:UPSoundIDNone volume:1.0 playerCount:8];
    [soundPlayer setFilePath:[bundle pathForResource:@"Tap" ofType:@"aac"] forSoundID:UPSoundIDTap volume:0.6 playerCount:10];
    [soundPlayer setFilePath:[bundle pathForResource:@"Tub" ofType:@"aac"] forSoundID:UPSoundIDTub volume:0.6 playerCount:8];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-1" ofType:@"aac"] forSoundID:UPSoundIDHappy1 volume:0.8 playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-2" ofType:@"aac"] forSoundID:UPSoundIDHappy2 volume:0.8 playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-3" ofType:@"aac"] forSoundID:UPSoundIDHappy3 volume:0.8 playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-4" ofType:@"aac"] forSoundID:UPSoundIDHappy4 volume:0.8 playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Sad-1" ofType:@"aac"] forSoundID:UPSoundIDSad1 volume:0.8 playerCount:2];
    [soundPlayer setFilePath:[bundle pathForResource:@"Sad-2" ofType:@"aac"] forSoundID:UPSoundIDSad2 volume:0.8 playerCount:2];
    [soundPlayer setFilePath:[bundle pathForResource:@"Whoops" ofType:@"aac"] forSoundID:UPSoundIDWhoops volume:0.8 playerCount:3];
}

- (void)updateSoundAndTunesSettings
{
    UPSpellSettings *settings = [UPSpellSettings instance];
    self.soundEffectsEnabled = settings.soundEffectsEnabled;

    UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
    [soundPlayer setVolumeFromLevel:settings.soundEffectsLevel];
    if (self.soundEffectsEnabled) {
        [[UPSoundPlayer instance] prepare];
    }
    else {
        [[UPSoundPlayer instance] stop];
    }

    self.tunesEnabled = settings.tunesEnabled;
    
    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    [tunePlayer setVolumeFromLevel:settings.tunesLevel];
}

- (void)playSoundIDIfEnabled:(UPSoundID)soundID
{
    if (self.soundEffectsEnabled) {
        UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
        [soundPlayer playSoundID:soundID];
    }
}

- (void)configureTunesForTuneNumber:(NSUInteger)tuneNumber
{
    ASSERT(tuneNumber <= UPTuneCount);
    
    NSBundle *bundle = [NSBundle mainBundle];
    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    
    [tunePlayer clear];
    
    switch (tuneNumber) {
        default:
        case 1: {
            [tunePlayer setFilePath:[bundle pathForResource:@"Variation-19-In" ofType:@"aac"] forTuneID:UPTuneID1 segment:UPTuneSegmentIntro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Variation-19-Tune" ofType:@"aac"] forTuneID:UPTuneID1 segment:UPTuneSegmentMain];
            [tunePlayer setFilePath:[bundle pathForResource:@"Clock-Tock-Out" ofType:@"aac"] forTuneID:UPTuneID1 segment:UPTuneSegmentOutro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Game-Over" ofType:@"aac"] forTuneID:UPTuneID1 segment:UPTuneSegmentOver];
            break;
        }
        case 2: {
            [tunePlayer setFilePath:[bundle pathForResource:@"Waltz-In" ofType:@"aac"] forTuneID:UPTuneID2 segment:UPTuneSegmentIntro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Waltz-Tune" ofType:@"aac"] forTuneID:UPTuneID2 segment:UPTuneSegmentMain];
            [tunePlayer setFilePath:[bundle pathForResource:@"Clock-Tock-Out" ofType:@"aac"] forTuneID:UPTuneID2 segment:UPTuneSegmentOutro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Game-Over" ofType:@"aac"] forTuneID:UPTuneID2 segment:UPTuneSegmentOver];
            break;
        }
        case 3: {
            [tunePlayer setFilePath:[bundle pathForResource:@"Invention-8-In" ofType:@"aac"] forTuneID:UPTuneID3 segment:UPTuneSegmentIntro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Invention-8-Tune" ofType:@"aac"] forTuneID:UPTuneID3 segment:UPTuneSegmentMain];
            [tunePlayer setFilePath:[bundle pathForResource:@"Clock-Tock-Out" ofType:@"aac"] forTuneID:UPTuneID3 segment:UPTuneSegmentOutro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Game-Over" ofType:@"aac"] forTuneID:UPTuneID3 segment:UPTuneSegmentOver];
            break;
        }
        case 4: {
            [tunePlayer setFilePath:[bundle pathForResource:@"Square-In-G" ofType:@"aac"] forTuneID:UPTuneID4 segment:UPTuneSegmentIntro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Bill-Cheatum-Tune" ofType:@"aac"] forTuneID:UPTuneID4 segment:UPTuneSegmentMain];
            [tunePlayer setFilePath:[bundle pathForResource:@"Clock-Tock-Out" ofType:@"aac"] forTuneID:UPTuneID4 segment:UPTuneSegmentOutro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Game-Over" ofType:@"aac"] forTuneID:UPTuneID4 segment:UPTuneSegmentOver];
            break;
        }
        case 5: {
            [tunePlayer setFilePath:[bundle pathForResource:@"Square-In-C" ofType:@"aac"] forTuneID:UPTuneID5 segment:UPTuneSegmentIntro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Forked-Deer-Tune" ofType:@"aac"] forTuneID:UPTuneID5 segment:UPTuneSegmentMain];
            [tunePlayer setFilePath:[bundle pathForResource:@"Clock-Tock-Out" ofType:@"aac"] forTuneID:UPTuneID5 segment:UPTuneSegmentOutro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Game-Over" ofType:@"aac"] forTuneID:UPTuneID5 segment:UPTuneSegmentOver];
            break;
        }
        case 6: {
            [tunePlayer setFilePath:[bundle pathForResource:@"Square-In-E" ofType:@"aac"] forTuneID:UPTuneID6 segment:UPTuneSegmentIntro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Cindy-Tune" ofType:@"aac"] forTuneID:UPTuneID6 segment:UPTuneSegmentMain];
            [tunePlayer setFilePath:[bundle pathForResource:@"Clock-Tock-Out" ofType:@"aac"] forTuneID:UPTuneID6 segment:UPTuneSegmentOutro];
            [tunePlayer setFilePath:[bundle pathForResource:@"Game-Over" ofType:@"aac"] forTuneID:UPTuneID6 segment:UPTuneSegmentOver];
            break;
        }
    }
}

- (NSUInteger)pickNextTune
{
    UPSpellSettings *settings = [UPSpellSettings instance];
    NSMutableArray<NSNumber *> *tuneHistory = [settings.tuneHistory mutableCopy];
    Random &rng = Random::instance();
    NSUInteger tuneNumber = 1;
    while (1) {
        BOOL found = YES;
        NSUInteger r = rng.uint32_in_range(1, 6);
        for (NSNumber *n in tuneHistory) {
            if (n.integerValue == r) {
                found = NO;
                break;
            }
        }
        if (found) {
            tuneNumber = r;
            if (tuneHistory.count >= 4) {
                [tuneHistory removeObjectAtIndex:0];
            }
            [tuneHistory addObject:@(tuneNumber)];
            settings.tuneHistory = tuneHistory;
            break;
        }
    }
    return tuneNumber;
}

- (void)playTuneIntro
{
    self.tuneNumber = [self pickNextTune];
    [self configureTunesForTuneNumber:self.tuneNumber];
    if (self.tunesEnabled) {
        UPTunePlayer *tunePlayer = [UPTunePlayer instance];
        [tunePlayer playTuneID:UPTuneID(self.tuneNumber) segment:UPTuneSegmentIntro properties:{ 0.9, NO, 0, 0 }];
    }
}

- (void)sequenceTuneWithDelay:(CFTimeInterval)delay gameTimeElapsed:(CFTimeInterval)gameTimeElapsed
{
    CFTimeInterval effectiveGameTimeElapsed = UPClampT(CFTimeInterval, gameTimeElapsed, 0, UPGameTimerDefaultDuration);
    
    UPTunePlayer *tunePlayer = [UPTunePlayer instance];

    static constexpr CFTimeInterval UPGameTimerCanonicalDuration = 120;
    
    UPTuneID tuneID = UPTuneID(self.tuneNumber);
    
    if (self.tunesEnabled && UPGameTimerDefaultDuration - effectiveGameTimeElapsed > GameOverOutroDuration) {
        CFTimeInterval tuneBeginTime = delay;
        CFTimeInterval tuneTimeOffset = (UPGameTimerCanonicalDuration - UPGameTimerDefaultDuration) + effectiveGameTimeElapsed;
        [tunePlayer playTuneID:tuneID segment:UPTuneSegmentMain properties:{ 1.0, NO, 0, tuneBeginTime, tuneTimeOffset }];
    }

    if (self.soundEffectsEnabled) {
        UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
        float volume = UPClampT(float, soundPlayer.volume * 1.2, 0, 1);
        if (UPGameTimerDefaultDuration - effectiveGameTimeElapsed > 1) {
            CFTimeInterval outroIntervalFromEnd = UPGameTimerDefaultDuration - GameOverOutroDuration;
            CFTimeInterval outroBeginTime = delay + outroIntervalFromEnd - effectiveGameTimeElapsed;
            CFTimeInterval outroTimeOffset = UPMaxT(CFTimeInterval, 0, effectiveGameTimeElapsed - outroIntervalFromEnd);
            [tunePlayer playTuneID:tuneID segment:UPTuneSegmentOutro properties:{ volume, YES, 0, outroBeginTime, outroTimeOffset }];
        }
        
        CFTimeInterval gameOverBeginTime = delay + (UPGameTimerDefaultDuration - effectiveGameTimeElapsed);
        [tunePlayer playTuneID:tuneID segment:UPTuneSegmentOver properties:{ volume, YES, 0, gameOverBeginTime, 0 }];
    }
}

- (BOOL)shouldPlayTubSound
{
    CFTimeInterval now = CACurrentMediaTime();
    return now - self.tapSoundTimestamp > TapToTubInterval;
}

#pragma mark - Modes

- (void)configureModeTransitionTables
{
    m_default_transition_table = {
        { Mode::None,     Mode::Init,     @selector(modeTransitionFromNoneToInit) },
        { Mode::None,     Mode::Pause,    @selector(modeTransitionFromNoneToPause) },
        { Mode::Init,     Mode::Attract,  @selector(modeTransitionFromInitToAttract) },
        { Mode::Init,     Mode::About,    @selector(modeTransitionFromInitToAbout) },
        { Mode::Init,     Mode::Extras,   @selector(modeTransitionFromInitToExtras) },
        { Mode::Init,     Mode::PlayMenu, @selector(modeTransitionFromInitToPlayMenu) },
        { Mode::Init,     Mode::Ready,    @selector(modeTransitionFromInitToReady) },
        { Mode::About,    Mode::Init,     @selector(modeTransitionFromAboutToInit) },
        { Mode::Extras,   Mode::Init,     @selector(modeTransitionFromExtrasToInit) },
        { Mode::Attract,  Mode::About,    @selector(modeTransitionFromAttractToAbout) },
        { Mode::Attract,  Mode::Extras,   @selector(modeTransitionFromAttractToExtras) },
        { Mode::Attract,  Mode::Ready,    @selector(modeTransitionFromAttractToReady) },
        { Mode::PlayMenu, Mode::Init,     @selector(modeTransitionFromPlayMenuToInit) },
        { Mode::PlayMenu, Mode::Ready,    @selector(modeTransitionFromPlayMenuToReady) },
        { Mode::Ready,    Mode::Play,     @selector(modeTransitionFromReadyToPlay) },
        { Mode::Play,     Mode::Pause,    @selector(modeTransitionFromPlayToPause) },
        { Mode::Play,     Mode::GameOver, @selector(modeTransitionFromPlayToGameOver) },
        { Mode::Pause,    Mode::Play,     @selector(modeTransitionFromPauseToPlay) },
        { Mode::Pause,    Mode::Quit,     @selector(modeTransitionFromPauseToQuit) },
        { Mode::GameOver, Mode::End,      @selector(modeTransitionFromOverToEnd) },
        { Mode::End,      Mode::About,    @selector(modeTransitionFromEndToAbout) },
        { Mode::End,      Mode::Extras,   @selector(modeTransitionFromEndToExtras) },
        { Mode::End,      Mode::PlayMenu, @selector(modeTransitionFromEndToPlayMenu) },
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
    [self createNewGameModelIfNeeded];
    
    SpellLayout &layout = SpellLayout::instance();

    self.dialogTopMenu.transform = CGAffineTransformIdentity;
    self.dialogTopMenu.hidden = NO;
    self.dialogTopMenu.alpha = 1;
    self.dialogTopMenu.messagePathView.frame = layout.frame_for(Role::DialogMessageVerticallyCentered, Place::OffBottomNear);

    self.gameView.transform = layout.menu_game_view_transform();
    [self viewUpdateGameControls];
    [self viewFillUpSpellTileViews];
    [self viewLock];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonInit];
    [self viewUnlock];
}

- (void)modeTransitionFromNoneToPause
{
    ASSERT(m_spell_model->back_opcode() == Opcode::PAUSE);

    [self viewLock];
    
    self.gameView.transform = CGAffineTransformIdentity;
    [self.gameTimer resetTo:m_spell_model->back_state().action().timestamp()];
    [self viewUpdateGameControls];
    [self viewRestoreInProgressGame];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPause];

    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }
        
    // special modal fixups for pause
    self.gameView.pauseControl.highlightedLocked = YES;
    self.gameView.pauseControl.highlighted = YES;
    self.gameView.pauseControl.alpha = [UIColor themeModalActiveAlpha];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse);
    self.dialogPause.hidden = NO;
    self.dialogPause.alpha = 1.0;
    
    self.dialogTopMenu.messagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray, Place::OffBottomNear);

    self.dialogTopMenu.alpha = 1.0;
    self.dialogTopMenu.hidden = YES;
    self.dialogGameOver.alpha = 1.0;
    self.dialogGameOver.hidden = YES;
    self.dialogGameNote.alpha = 1.0;
    self.dialogGameNote.hidden = YES;

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

- (void)modeTransitionFromInitToPlayMenu
{
    [self viewOrderInPlayMenu];
}

- (void)modeTransitionFromInitToReady
{
    ASSERT(m_spell_model->is_blank_filled());
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self createNewGameModelIfNeeded];
    [self viewMakeReadyFromMode:Mode::Init completion:^{
        [self viewBloopOutExistingTileViewsWithCompletion:nil];
        [self setMode:Mode::Play];
    }];
}

- (void)modeTransitionFromAboutToInit
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter);
    UPViewMove *extrasButtonMove = UPViewMoveMake(self.dialogTopMenu.extrasButton, Role::DialogButtonTopLeft);
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Role::Screen);
    
    CFTimeInterval duration = 0.5;
    CFTimeInterval stagger = 0.075;

    start(bloop_in(BandModeUI, @[gameViewMove], duration, nil));
    delay(BandModeDelay, stagger, ^{
        start(bloop_in(BandModeUI, @[playButtonMove], duration - stagger, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, (1.5 * stagger), ^{
        start(bloop_in(BandModeUI, @[extrasButtonMove], duration - (1.5 * stagger), ^(UIViewAnimatingPosition) {
            self.dialogTopMenu.aboutButton.userInteractionEnabled = YES;
            [self viewUnlock];
        }));
    });
}

- (void)modeTransitionFromExtrasToInit
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter);
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogTopMenu.aboutButton, Role::DialogButtonTopRight);
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Role::Screen);
    
    CFTimeInterval duration = 0.5;
    CFTimeInterval stagger = 0.075;
    
    start(bloop_in(BandModeUI, @[gameViewMove], duration, nil));
    delay(BandModeDelay, stagger, ^{
        start(bloop_in(BandModeUI, @[playButtonMove], duration - stagger, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, 1.5 * stagger, ^{
        start(bloop_in(BandModeUI, @[aboutButtonMove], duration - (1.5 * stagger), ^(UIViewAnimatingPosition) {
            self.dialogTopMenu.extrasButton.userInteractionEnabled = YES;
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
        [self createNewGameModelIfNeeded];
        [self viewBloopInBlankTileViewsWithCompletion:^{
            [self viewLock];
            [self viewMakeReadyFromMode:Mode::Attract completion:^{
                [self viewBloopOutExistingTileViewsWithCompletion:nil];
                [self setMode:Mode::Play];
            }];
        }];
    }];
}

- (void)modeTransitionFromPlayMenuToInit
{
    [self viewLock];
    
    for (UPChoice *choice in self.dialogPlayMenu.choices) {
        choice.selected = NO;
    }

    NSArray<UPViewMove *> *buttonOutMoves = @[
        UPViewMoveMake(self.dialogPlayMenu.goButton, Location(Role::ChoiceGoButtonCenter, Place::OffBottomFar)),
        UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice1, Role::ChoiceItem1Center, Place::OffBottomFar),
        UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice2, Role::ChoiceItem2Center, Place::OffBottomFar),
        UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice3, Role::ChoiceItem3Center, Place::OffBottomFar),
    ];
    start(bloop_out(BandModeUI, buttonOutMoves, 0.6, ^(UIViewAnimatingPosition) {
        self.dialogPlayMenu.hidden = YES;
        self.dialogPlayMenu.alpha = 1.0;
    }));

    delay(BandModeDelay, 0.25, ^{
        NSArray<UPViewMove *> *playMoves = @[
            UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter),
        ];
        start(bloop_in(BandModeUI, playMoves, 0.5, ^(UIViewAnimatingPosition) {
            self.dialogTopMenu.playButton.userInteractionEnabled = YES;
        }));
        self.dialogTopMenu.playButton.selected = NO;
        NSArray<UPViewMove *> *buttonInMoves = @[
            UPViewMoveMake(self.dialogTopMenu.extrasButton, Role::DialogButtonTopLeft),
            UPViewMoveMake(self.dialogTopMenu.aboutButton, Role::DialogButtonTopRight),
        ];
        start(bloop_in(BandModeUI, buttonInMoves, 0.5, nil));
    });

    delay(BandModeDelay, 0.1, ^{
        NSArray<UPViewMove *> *slideMoves = @[
            UPViewMoveMake(self.dialogPlayMenu.backButton, Location(Role::ChoiceBackCenter, Place::OffTopNear)),
        ];
        start(slide(BandModeUI, slideMoves, 0.2, nil));
    });
    
    [UIView animateWithDuration:0.25 delay:0.45 options:0 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonInit];
    } completion:^(BOOL finished) {
        [self viewUnlock];
    }];
    [UIView animateWithDuration:0.4 delay:0.3 options:0 animations:^{
        self.dialogPlayMenu.alpha = 0.0;
    } completion:nil];

}

- (void)modeTransitionFromPlayMenuToReady
{
    ASSERT(m_spell_model->is_blank_filled());
    ASSERT(self.lockCount == 0);
    [self viewLock];

    self.dialogPlayMenu.goButton.highlightedLocked = YES;
    self.dialogPlayMenu.goButton.highlighted = YES;

    for (UPChoice *choice in self.dialogPlayMenu.choices) {
        if (choice.selected) {
            self.playMenuChoice = choice;
            break;
        }
    }

    [self updateSoundAndTunesSettings];
    [self playTuneIntro];

    delay(BandModeDelay, 0.1, ^{
        SpellLayout &layout = SpellLayout::instance();
        self.dialogTopMenu.extrasButton.center = layout.center_for(Role::DialogButtonTopLeft, Place::OffTopNear);
        self.dialogTopMenu.aboutButton.center = layout.center_for(Role::DialogButtonTopRight, Place::OffTopNear);
        
        [UIView animateWithDuration:0.4 delay:0.3 options:0 animations:^{
            self.dialogPlayMenu.alpha = 0;
        } completion:^(BOOL finished) {
            self.dialogPlayMenu.alpha = 1;
        }];

        NSArray<UPViewMove *> *buttonOutMoves = @[
            UPViewMoveMake(self.dialogTopMenu.playButton, Location(Role::ChoiceTitleCenter, Place::OffBottomFar)),
            UPViewMoveMake(self.dialogPlayMenu.backButton, Location(Role::ChoiceBackCenter, Place::OffBottomFar)),
            UPViewMoveMake(self.dialogPlayMenu.goButton, Location(Role::ChoiceGoButtonCenter, Place::OffBottomFar)),
            UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice1, Role::ChoiceItem1Center, Place::OffBottomFar),
            UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice2, Role::ChoiceItem2Center, Place::OffBottomFar),
            UPViewVariableSizeMoveMake(self.dialogPlayMenu.choice3, Role::ChoiceItem3Center, Place::OffBottomFar),
        ];
        
        start(bloop_out(BandModeUI, buttonOutMoves, 0.5, ^(UIViewAnimatingPosition) {
            self.dialogTopMenu.playButton.userInteractionEnabled = YES;
            self.dialogTopMenu.playButton.selected = NO;
            self.dialogPlayMenu.goButton.highlightedLocked = NO;
            self.dialogPlayMenu.goButton.highlighted = NO;
        }));
        delay(BandModeDelay, 0.55, ^{
            [self createNewGameModelIfNeeded];
            [self viewFillUpSpellTileViews];
            [self viewMakeReadyFromMode:Mode::PlayMenu completion:^{
                self.playMenuChoice = nil;
                [self viewBloopOutExistingTileViewsWithCompletion:nil];
                [self setMode:Mode::Play];
            }];
        });
    });
}

- (void)modeTransitionFromReadyToPlay
{
    ASSERT(self.lockCount == 1);

    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    [self.gameTimer reset];
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::PLAY));

    [self sequenceTuneWithDelay:GameStartDelay gameTimeElapsed:0];
    delay(BandModeDelay, GameStartDelay, ^{
        [self.gameTimer start];
    });

    UPViewMove *readyMove = UPViewMoveMake(self.dialogTopMenu.messagePathView, Location(Role::DialogMessageCenteredInWordTray, Place::OffBottomNear));
    start(bloop_out(BandModeUI, @[readyMove], 0.3, nil));
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        self.dialogTopMenu.alpha = 0;
    } completion:^(BOOL finished) {
        self.dialogTopMenu.alpha = 1.0;
        self.dialogTopMenu.hidden = YES;
        self.dialogGameOver.alpha = 1.0;
        self.dialogGameOver.hidden = YES;
        self.dialogGameNote.alpha = 1.0;
        self.dialogGameNote.hidden = YES;
        [UIView animateWithDuration:0.35 animations:^{
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPlay];
        } completion:nil];
        delay(BandModeDelay, 0.1, ^{
            [self viewUnlock];
            [self viewFillPlayerTrayWithCompletion:nil];
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
    [[UPSoundPlayer instance] stop];
    [[UPTunePlayer instance] stop];
    [self viewLock];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPause];

    // special modal fixups for pause
    self.gameView.pauseControl.highlightedLocked = YES;
    self.gameView.pauseControl.highlighted = YES;
    self.gameView.pauseControl.alpha = [UIColor themeModalActiveAlpha];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray, Place::OffBottomNear);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse, Place::OffBottomFar);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse, Place::OffBottomFar);
    
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Role::DialogButtonAlternativeResponse),
        UPViewMoveMake(self.dialogPause.resumeButton, Role::DialogButtonDefaultResponse),
    ];
    start(bloop_in(BandModeUI, farMoves, 0.3, ^(UIViewAnimatingPosition) {
        [self viewUnlock];
    }));
    
    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Role::DialogMessageCenteredInWordTray),
    ];
    start(bloop_in(BandModeUI, nearMoves, 0.35, nil));
    
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
    [[UPSoundPlayer instance] stop];
    [[UPTunePlayer instance] stop];
    [self viewLock];

    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPause];
    
    // special modal fixups for pause
    self.gameView.pauseControl.highlightedLocked = YES;
    self.gameView.pauseControl.highlighted = YES;
    self.gameView.pauseControl.alpha = [UIColor themeModalActiveAlpha];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray);
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
    [[UPSoundPlayer instance] prepare];

    [UIView animateWithDuration:0.4 delay:0.3 options:0 animations:^{
        self.dialogPause.alpha = 0.0;
    } completion:nil];

    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Location(Role::DialogMessageCenteredInWordTray, Place::OffBottomNear)),
    ];
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Location(Role::DialogButtonAlternativeResponse, Place::OffBottomFar)),
        UPViewMoveMake(self.dialogPause.resumeButton, Location(Role::DialogButtonDefaultResponse, Place::OffBottomFar)),
    ];

    start(bloop_out(BandModeUI, farMoves, 0.35, nil));

    start(bloop_out(BandModeUI, nearMoves, 0.3, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        
        [self sequenceTuneWithDelay:0.3 gameTimeElapsed:self.gameTimer.elapsedTime];
        delay(BandModeDelay, 0.3, ^{
            [self.gameTimer start];
            start(BandGameAll);
        });
        [UIView animateWithDuration:0.3 animations:^{
            self.gameView.pauseControl.highlightedLocked = NO;
            self.gameView.pauseControl.highlighted = NO;
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPlay];
        } completion:^(BOOL finished) {
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

    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::QUIT));

    [self viewLock];
    cancel(BandGameAll);
    [self.gameTimer cancel];
    [[UPSoundPlayer instance] stop];
    [[UPTunePlayer instance] stop];
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

    [UIView animateWithDuration:0.4 delay:0.3 options:0 animations:^{
        self.dialogPause.alpha = 0.0;
    } completion:nil];
    
    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Location(Role::DialogMessageCenteredInWordTray, Place::OffBottomNear)),
    ];
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Location(Role::DialogButtonAlternativeResponse, Place::OffBottomFar)),
        UPViewMoveMake(self.dialogPause.resumeButton, Location(Role::DialogButtonDefaultResponse, Place::OffBottomFar)),
    ];
    start(bloop_out(BandModeUI, farMoves, 0.35, nil));
    start(bloop_out(BandModeUI, nearMoves, 0.3, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        [self setMode:Mode::End];
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
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::OVER));

    [self cancelActiveTouch];
    [self viewUnhighlightTileViews];
    [self viewBloopTileViewsToPlayerTrayWithDuration:GameOverRespositionBloopDuration completion:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.gameView.wordTrayControl.transform = CGAffineTransformIdentity;
    }];
    [self viewPenaltyFinished];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonGameOver];

    self.gameView.timerLabel.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.gameScoreLabel.alpha = [UIColor themeModalActiveAlpha];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.messagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray, Place::OffBottomNear);
    self.dialogGameOver.center = layout.center_for(Location(Role::Screen));
    self.dialogGameOver.hidden = NO;
    self.dialogGameOver.alpha = 0.0;
    self.dialogGameNote.noteLabel.center = layout.center_for(Role::DialogGameNote, Place::OffBottomNear);
    self.dialogGameNote.center = layout.center_for(Location(Role::Screen));
    self.dialogGameNote.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogGameOver.alpha = 1.0;
    }];

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageCenteredInWordTray),
    ];
    start(bloop_in(BandModeUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        delay(BandModeDelay, 0.75, ^{
            [self setMode:Mode::End];
        });
    }));
}

- (void)modeTransitionFromOverToEnd
{
    ASSERT(self.lockCount == 1);

    TileArray incoming_tiles = m_spell_model->tiles();
    size_t incoming_word_length = m_spell_model->word().length();
    
    [self viewSetNoteLabelString];
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::END));

    UPSpellDossier *dossier = [UPSpellDossier instance];
    [dossier updateWithModel:m_spell_model];
    [dossier save];
    
    delay(BandModeDelay, 1.0, ^{
        SpellLayout &layout = SpellLayout::instance();
        [UIView animateWithDuration:1.0 animations:^{
            self.dialogGameOver.transform = layout.menu_game_view_transform();
            self.gameView.transform = layout.menu_game_view_transform();
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonOverToEnd];
        }];
        self.gameView.timerLabel.alpha = 1.0;
        self.gameView.gameScoreLabel.alpha = 1.0;

        [self viewBloopOutWordScoreLabelWithDuration:GameOverInOutBloopDuration];

        [self viewBloopOutExistingTileViewsWithDuration:GameOverInOutBloopDuration tiles:incoming_tiles wordLength:incoming_word_length
                                             completion:^{
            [self viewBloopInBlankTileViewsWithDuration:GameOverInOutBloopDuration completion:nil];
            self.dialogTopMenu.hidden = NO;
            self.dialogTopMenu.alpha = 1;
            self.dialogTopMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Place::OffTopNear));
            self.dialogTopMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Place::OffTopNear));
            self.dialogTopMenu.aboutButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Place::OffTopNear));
            self.dialogTopMenu.playButton.highlightedLocked = NO;
            self.dialogTopMenu.playButton.highlighted = NO;
            NSArray<UPViewMove *> *buttonMoves = @[
                UPViewMoveMake(self.dialogTopMenu.extrasButton, Location(Role::DialogButtonTopLeft)),
                UPViewMoveMake(self.dialogTopMenu.playButton, Location(Role::DialogButtonTopCenter)),
                UPViewMoveMake(self.dialogTopMenu.aboutButton, Location(Role::DialogButtonTopRight)),
                UPViewMoveMake(self.dialogGameNote.noteLabel, Role::DialogGameNote),
            ];
            start(bloop_in(BandModeUI, buttonMoves, GameOverInOutBloopDuration, ^(UIViewAnimatingPosition) {
                [self viewUnlock];
            }));
        }];
    });
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

- (void)modeTransitionFromEndToPlayMenu
{
    [self createNewGameModelIfNeeded];
    [self viewFillUpSpellTileViews];
    [self viewOrderInPlayMenu];
}

- (void)modeTransitionFromEndToReady
{
    [self createNewGameModelIfNeeded];
    [self viewLock];
    [self viewFillUpSpellTileViews];
    [self viewMakeReadyFromMode:Mode::End completion:^{
        [self viewBloopOutExistingTileViewsWithCompletion:nil];
        [self setMode:Mode::Play];
    }];
}

- (void)modeTransitionFromQuitToEnd
{
    ASSERT(self.lockCount == 1);

    TileArray incoming_tiles = m_spell_model->tiles();
    size_t incoming_word_length = m_spell_model->word().length();
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::END));
    
    [self removeInProgressGameFileLogErrors:NO];
    UPSpellDossier *dossier = [UPSpellDossier instance];
    [dossier updateWithModel:m_spell_model];
    [dossier save];

    delay(BandModeDelay, 0.35, ^{
        [self viewDumpAllTilesFromCurrentPosition:incoming_tiles wordLength:incoming_word_length];
        SpellLayout &layout = SpellLayout::instance();

        [UIView animateWithDuration:1.2 animations:^{
            self.gameView.transform = layout.menu_game_view_transform();
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonQuitToEnd];
        } completion:^(BOOL finished) {
            self.dialogTopMenu.hidden = NO;
            self.dialogTopMenu.alpha = 1;
            self.dialogTopMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Place::OffTopNear));
            self.dialogTopMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Place::OffTopNear));
            self.dialogTopMenu.aboutButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Place::OffTopNear));
            self.dialogTopMenu.playButton.highlightedLocked = NO;
            self.dialogTopMenu.playButton.highlighted = NO;
            delay(BandModeDelay, 0.1, ^{
                NSArray<UPViewMove *> *menuButtonMoves = @[
                    UPViewMoveMake(self.dialogTopMenu.extrasButton, Role::DialogButtonTopLeft),
                    UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter),
                    UPViewMoveMake(self.dialogTopMenu.aboutButton, Role::DialogButtonTopRight),
                ];
                start(bloop_in(BandModeUI, menuButtonMoves, 0.3, nil));

                [self viewBloopInUpSpellTileViewsWithDuration:0.3 completion:^{
                    [self viewUnlock];
                }];
            });
        }];
    });
}

@end
