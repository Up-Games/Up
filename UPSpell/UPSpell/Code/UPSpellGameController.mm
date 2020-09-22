//
//  UPSpellGameController.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <limits>
#import <memory>
#import <vector>

#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UIFont+UPSpell.h"
#import "UPActivityViewController.h"
#import "UPControl+UPSpell.h"
#import "UPChoice.h"
#import "UPDialogGameOver.h"
#import "UPDialogTopMenu.h"
#import "UPDialogPause.h"
#import "UPDialogGameLink.h"
#import "UPDialogGameLinkHelp.h"
#import "UPDialogShareHelp.h"
#import "UPDialogDuelHelp.h"
#import "UPSceneDelegate.h"
#import "UPSoundPlayer.h"
#import "UPSpellGameController.h"
#import "UPSpellGameSummary.h"
#import "UPSpellGameView.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPSpellDossier.h"
#import "UPSpellSettings.h"
#import "UPTextButton.h"
#import "UPTileModel.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "UPTunePlayer.h"
#import "UPGameLink.h"
#import "UPPulseView.h"
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
using UP::char_with_leading_apostrophe;
using UP::char_with_trailing_apostrophe;

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
using UP::role_for_score;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;
using Mode = UP::Mode;
using ModeTransitionTable = UP::ModeTransitionTable;

typedef NS_ENUM(NSInteger, UPSpellGameAlphaStateReason) {
    UPSpellGameAlphaStateReasonDefault,
    UPSpellGameAlphaStateReasonInit,
    UPSpellGameAlphaStateReasonGameLink,
    UPSpellGameAlphaStateReasonGameLinkHelp,
    UPSpellGameAlphaStateReasonShareHelp,
    UPSpellGameAlphaStateReasonDuelHelp,
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
    UPSpellGameAlphaStateReasonShareHelpToEnd,
    UPSpellGameAlphaStateReasonOrderOutGameEnd,
};

@interface UPSpellGameController () <UPGameTimerObserver, UIGestureRecognizerDelegate>
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
@property (nonatomic) UPDialogPause *dialogPause;
@property (nonatomic) UPDialogGameLink *dialogGameLink;
@property (nonatomic) UPDialogGameLinkHelp *dialogGameLinkHelp;
@property (nonatomic) UPDialogShareHelp *dialogShareHelp;
@property (nonatomic) UPDialogDuelHelp *dialogDuelHelp;
@property (nonatomic) UPDialogTopMenu *dialogTopMenu;
@property (nonatomic) BOOL dialogTopMenuUserInteractionEnabled;
@property (nonatomic) NSInteger lockCount;
@property (nonatomic) int endGameScore;
@property (nonatomic) UPGameLink *gameLink;
@property (nonatomic) BOOL gameLinkSender;
@property (nonatomic) Mode duelHelpReturnMode;

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
@property (nonatomic) CFTimeInterval activeTouchStartTimestamp;
@property (nonatomic) CFTimeInterval activeTouchPreviousTimestamp;

@property (nonatomic) NSInteger tuneNumber;
@property (nonatomic) CFTimeInterval tapSoundTimestamp;
@property (nonatomic) CFTimeInterval tubSoundTimestamp;
@property (nonatomic) BOOL soundEffectsEnabled;
@property (nonatomic) BOOL tunesEnabled;

@end

static constexpr CFTimeInterval GameStartDelay = 0.64;
static constexpr CFTimeInterval DefaultBloopDuration = 0.2;
static constexpr CFTimeInterval DefaultTileSlideDuration = 0.05;
static constexpr CFTimeInterval GameOverInOutBloopDuration = 0.5;
static constexpr CFTimeInterval GameOverRespositionBloopDuration = 0.5;
static constexpr CFTimeInterval GameOverOutroDuration = 5;
static constexpr CFTimeInterval TapToTubInterval = 0.05;
static constexpr CFTimeInterval TubToTubInterval = 0.05;

static UPSpellGameController *_Instance;

@implementation UPSpellGameController

+ (UPSpellGameController *)instance
{
    return _Instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _Instance = self;
    
    SpellLayout &layout = SpellLayout::instance();
    UPSpellNavigationController *navigationController = [UPSpellNavigationController instance];
    
    self.gameView = [UPSpellGameView instance];
    [self.view addSubview:self.gameView];

    self.gameTimer = [UPGameTimer defaultGameTimer];
    [self.gameTimer addObserver:self.gameView.timerLabel];
    [self.gameTimer addObserver:self];
    [self.gameTimer notifyObservers];
    
    self.dialogGameOver = [UPDialogGameOver instance];
    [self.view addSubview:self.dialogGameOver.messagePathView];
    [self.view addSubview:self.dialogGameOver.noteLabel];
    [self.view addSubview:self.dialogGameOver.shareButton];
    [self.dialogGameOver.shareButton setTarget:self action:@selector(gameOverShareButtonTapped)];
    [self setGameOverViewsHidden:YES];
    
    self.dialogTopMenu = [UPDialogTopMenu instance];
    [self.view addSubview:self.dialogTopMenu.extrasButton];
    [self.view addSubview:self.dialogTopMenu.playButton];
    [self.view addSubview:self.dialogTopMenu.duelButton];
    [self.view addSubview:self.dialogTopMenu.readyMessagePathView];
    [self.dialogTopMenu.playButton setTarget:navigationController action:@selector(dialogMenuPlayButtonTapped)];
    [self.dialogTopMenu.extrasButton setTarget:navigationController action:@selector(dialogMenuExtrasButtonTapped)];
    [self.dialogTopMenu.duelButton setTarget:self action:@selector(dialogMenuDuelButtonPressed)];
    self.dialogTopMenu.extrasButton.gestureRecognizerDelegate = self;
    self.dialogTopMenu.playButton.gestureRecognizerDelegate = self;
    self.dialogTopMenu.duelButton.gestureRecognizerDelegate = self;
    self.dialogTopMenu.extrasButton.userInteractionEnabled = NO;
    self.dialogTopMenu.duelButton.userInteractionEnabled = NO;

    self.dialogPause = [UPDialogPause instance];
    [self.view addSubview:self.dialogPause];
    [self.dialogPause.quitButton setTarget:self action:@selector(dialogPauseQuitButtonTapped:)];
    [self.dialogPause.resumeButton setTarget:self action:@selector(dialogPauseResumeButtonTapped:)];
    self.dialogPause.hidden = YES;
    self.dialogPause.frame = layout.screen_bounds();
    
    self.dialogGameLink = [UPDialogGameLink instance];
    [self.view addSubview:self.dialogGameLink];
    [self.dialogGameLink.cancelButton setTarget:self action:@selector(dialogGameLinkCancelButtonTapped:)];
    [self.dialogGameLink.confirmButton setTarget:self action:@selector(dialogGameLinkGoButtonTapped:)];
    [self.dialogGameLink.helpButton setTarget:self action:@selector(dialogGameLinkHelpButtonTapped:)];
    self.dialogGameLink.hidden = YES;
    self.dialogGameLink.frame = layout.screen_bounds();
    
    self.dialogShareHelp = [UPDialogShareHelp instance];
    [self.view addSubview:self.dialogShareHelp];
    [self.dialogShareHelp.okButton setTarget:self action:@selector(dialogShareHelpOKButtonTapped:)];
    self.dialogShareHelp.hidden = YES;
    self.dialogShareHelp.frame = layout.screen_bounds();

    self.dialogDuelHelp = [UPDialogDuelHelp instance];
    [self.view addSubview:self.dialogDuelHelp];
    [self.dialogDuelHelp.okButton setTarget:self action:@selector(dialogDuelHelpOKButtonTapped:)];
    self.dialogDuelHelp.hidden = YES;
    self.dialogDuelHelp.frame = layout.screen_bounds();

    self.dialogGameLinkHelp = [UPDialogGameLinkHelp instance];
    [self.view addSubview:self.dialogGameLinkHelp];
    [self.dialogGameLinkHelp.okButton setTarget:self action:@selector(dialogGameLinkHelpOKButtonTapped:)];
    self.dialogGameLinkHelp.hidden = YES;
    self.dialogGameLinkHelp.frame = layout.screen_bounds();
    
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
    
    self.duelHelpReturnMode = Mode::Init;
    
    UPSceneDelegate *sceneDelegate = [UPSceneDelegate instance];
    if (sceneDelegate.challenge) {
        self.gameLink = sceneDelegate.challenge;
        sceneDelegate.challenge = nil;
        [self setMode:Mode::GameLink];
    }
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return self.mode == Mode::Ready || self.mode == Mode::Play ? UIRectEdgeAll : UIRectEdgeNone;
}

- (void)dialogMenuDuelButtonPressed
{
    self.duelHelpReturnMode = self.mode;
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    if (settings.showDuelHelp) {
        [self setMode:Mode::DuelHelp];
    }
    else {
        [self presentDuelShareSheet];
    }
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.gameView updateThemeColors];
    [self.dialogTopMenu updateThemeColors];
    [self.dialogGameOver updateThemeColors];
    [self.dialogGameOver updateThemeColors];
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

#pragma mark - Top menu

- (void)setDialogTopMenuUserInteractionEnabled:(BOOL)enabled
{
    _dialogTopMenuUserInteractionEnabled = enabled;
    self.dialogTopMenu.extrasButton.userInteractionEnabled = enabled;
    self.dialogTopMenu.playButton.userInteractionEnabled = enabled;
    self.dialogTopMenu.duelButton.userInteractionEnabled = enabled;
}

#pragma mark - Game over views

- (void)setGameOverViewsHidden:(BOOL)hidden
{
    self.dialogGameOver.messagePathView.hidden = hidden;
    self.dialogGameOver.noteLabel.hidden = hidden;
    self.dialogGameOver.shareButton.hidden = hidden;
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
    if (up_is_fuzzy_equal(gameTimer.remainingTime, 5.0) ||
        up_is_fuzzy_equal(gameTimer.remainingTime, 4.0) ||
        up_is_fuzzy_equal(gameTimer.remainingTime, 3.0) ||
        up_is_fuzzy_equal(gameTimer.remainingTime, 2.0) ||
        up_is_fuzzy_equal(gameTimer.remainingTime, 1.0)) {
        self.gameView.pulseView.alpha = [UIColor themePulseAlpha];
        [UIView animateWithDuration:0.5 animations:^{
            self.gameView.pulseView.alpha = 0;
        } completion:nil];
    }
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
    TileArray word_tray_tiles;
    for (const auto &tile : m_spell_model->tiles()) {
        if (tile.in_word_tray()) {
            word_tray_tiles[tile.position().index()] = tile;
        }
    }
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : word_tray_tiles) {
        if (tile.model().is_sentinel()) {
            continue;
        }
        ASSERT(tile.has_view());
        [array addObject:tile.view()];
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
}

- (void)touchEndedInTileView:(UPTileView *)tileView
{
    ASSERT(self.pickedTileView == tileView);
    SpellLayout &layout = SpellLayout::instance();
    CGPoint v = self.activeTouchVelocity;
    BOOL pannedFar = self.activeTouchFurthestPanDistance >= 25;
    CGFloat movingDownVelocity = UPMaxT(CGFloat, v.y, 0.0);
    CGPoint projectedDownCenter = CGPointMake(tileView.center.x, tileView.center.y + (movingDownVelocity * 0.15));
    BOOL projectedTileInsideWordTray = CGRectContainsPoint(layout.word_tray_layout_frame(), projectedDownCenter);
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval elapsed = now - self.activeTouchStartTimestamp;
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
        m_spell_model->word().length() > 1) {
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
    else if (!m_spell_model || m_spell_model->word().length() < 2) {
        // Don't penalize. In the case it's a stray tap, let the player off the hook.
    }
    else {
        [self applyActionReject];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *view = gestureRecognizer.view;
    if (view == self.dialogTopMenu.extrasButton || view == self.dialogTopMenu.playButton || view == self.dialogTopMenu.duelButton) {
        switch (self.mode) {
            case UP::Mode::None:
            case UP::Mode::Extras:
            case UP::Mode::ShareHelp:
            case UP::Mode::DuelHelp:
            case UP::Mode::GameLink:
            case UP::Mode::GameLinkHelp:
            case UP::Mode::Ready:
            case UP::Mode::Play:
            case UP::Mode::Pause:
            case UP::Mode::GameOver:
            case UP::Mode::Quit:
                return NO;
            case UP::Mode::Init:
            case UP::Mode::End: {
                return self.dialogTopMenuUserInteractionEnabled;
            }
        }
    }
    return YES;
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

- (void)dialogGameLinkCancelButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::GameLink);
    self.gameLink = nil;
    self.gameLinkSender = NO;
    [self setMode:Mode::Init];
}

- (void)dialogGameLinkGoButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::GameLink);
    [self setMode:Mode::Ready];
}

- (void)dialogGameLinkHelpButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::GameLink);
    [self setMode:Mode::GameLinkHelp];
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

- (void)gameOverShareButtonTapped
{
    ASSERT(self.mode == Mode::End);
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    if (settings.showShareHelp) {
        [self setMode:Mode::ShareHelp];
    }
    else {
        [self presentShareSheet];
    }
}

- (void)dialogShareHelpOKButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::ShareHelp);
    [self setMode:Mode::End];
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.showShareHelp = NO;
}

- (void)dialogDuelHelpOKButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::DuelHelp);
    [self setMode:self.duelHelpReturnMode];
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.showDuelHelp = NO;
}

- (void)dialogGameLinkHelpOKButtonTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    ASSERT(self.mode == Mode::GameLinkHelp);
    [self setMode:Mode::GameLink];
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
    if (m_spell_model && (self.mode == Mode::Play || self.mode == Mode::Pause)) {
        Opcode back = m_spell_model->back_opcode();
        BOOL active = m_spell_model->word().in_lexicon() && back != Opcode::HOVER && back != Opcode::NOVER;
        self.gameView.wordTrayControl.active = active;
        if (active) {
            [self viewUpdateWordTrayTileDecorations];
        }
        else {
            [self viewUndecorateAllTiles];
        }
    }
    else {
        self.gameView.wordTrayControl.active = NO;
        [self viewUndecorateAllTiles];
    }
    [self.gameView.wordTrayControl setNeedsUpdate];
    
    // clear button
    if (m_spell_model && m_spell_model->word().length()) {
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
    }
    else {
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];
    }
    [self.gameView.clearControl setNeedsUpdate];
    
    // score
    int score = 0;
    if (m_spell_model && m_spell_model->back_opcode() != Opcode::QUIT) {
        score = m_spell_model->game_score();
    }
    self.gameView.gameScoreLabel.string = [NSString stringWithFormat:@"%d", score];
}

- (void)viewUpdateWordTrayTileDecorations
{
    if (!m_spell_model) {
        return;
    }
    
    const Word &word = m_spell_model->word();
    if (word.in_lexicon<false>() || word.length() < 2 || word.key() == word.string()) {
        [self viewUndecorateAllTiles];
        return;
    }

    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    ASSERT(wordTrayTileViews.count);

    std::u32string string = word.string();
    
    // handle insertion of apostrophe if necessary
    if (string.find_first_of(U'’') != std::u32string::npos) {
        std::u32string::size_type idx = std::u32string::npos;
        if ((idx = string.find(U"N’T")) != std::u32string::npos) {
            string[idx + 2] = char_with_leading_apostrophe(U'T');
        }
        else if ((idx = string.find(U"G’DAY")) != std::u32string::npos) {
            string[idx] = char_with_trailing_apostrophe(U'G');
        }
        else if ((idx = string.find(U"’LL")) != std::u32string::npos) {
            string[idx + 1] = char_with_leading_apostrophe(U'L');
        }
        else if ((idx = string.find(U"’D")) != std::u32string::npos) {
            string[idx + 1] = char_with_leading_apostrophe(U'D');
        }
        else if ((idx = string.find(U"’S")) != std::u32string::npos) {
            string[idx + 1] = char_with_leading_apostrophe(U'S');
        }
        else if ((idx = string.find(U"’RE")) != std::u32string::npos) {
            string[idx + 1] = char_with_leading_apostrophe(U'R');
        }
        else if ((idx = string.find(U"’VE")) != std::u32string::npos) {
            string[idx + 1] = char_with_leading_apostrophe(U'V');
        }
        else if ((idx = string.find(U"’T")) != std::u32string::npos) {
            string[idx + 1] = char_with_leading_apostrophe(U'T');
        }
        else if ((idx = string.find(U"A’")) != std::u32string::npos) {
            string[idx] = char_with_trailing_apostrophe(U'A');
        }
        else if ((idx = string.find(U"E’")) != std::u32string::npos) {
            string[idx] = char_with_trailing_apostrophe(U'E');
        }
        else if ((idx = string.find(U"I’M")) != std::u32string::npos) {
            string[idx] = char_with_trailing_apostrophe(U'I');
        }
        else if ((idx = string.find(U"O’")) != std::u32string::npos) {
            string[idx] = char_with_trailing_apostrophe(U'O');
        }
        else if ((idx = string.find(U"S’")) != std::u32string::npos) {
            string[idx] = char_with_trailing_apostrophe(U'S');
        }
        else if ((idx = string.find(U"Y’")) != std::u32string::npos) {
            string[idx] = char_with_trailing_apostrophe(U'Y');
        }
    }
    
    TileIndex idx = 0;
    for (UPTileView *tileView in wordTrayTileViews) {
        if (string[idx] == U'’') {
            idx++;
        }
        tileView.glyph = string[idx];
        [tileView updateTile];
        idx++;
    }
}

- (void)viewUndecorateAllTiles
{
    if (!m_spell_model) {
        return;
    }
    
    for (auto &tile : m_spell_model->tiles()) {
        if (tile.has_view()) {
            UPTileView *tileView = tile.view();
            if (tileView.glyph != tile.model().glyph() || tileView.hasLeadingApostrophe || tileView.hasTrailingApostrophe) {
                tileView.glyph = tile.model().glyph();
                tileView.hasLeadingApostrophe = NO;
                tileView.hasTrailingApostrophe = NO;
                [tileView updateTile];
            }
        }
    }
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
        Location location(role_in_word(tile.position().index(), m_spell_model->word().length()), Spot::OffTopNear);
        tileView.submitLocation = location;
        [moves addObject:UPViewMoveMake(tileView, location)];
    }
    start(bloop_out(BandGameUI, moves, 0.3, nil));
    
    [self viewUpdateWordScoreLabel];
    
    Role role = (m_spell_model->word().length() >= 5 || m_spell_model->word().total_multiplier() > 1) ? Role::WordScoreBonus : Role::WordScore;
    
    SpellLayout &layout = SpellLayout::instance();
    self.gameView.wordScoreLabel.frame = layout.frame_for(role, Spot::OffBottomFar);
    self.gameView.wordScoreLabel.hidden = NO;
    
    UPViewMove *wordScoreInMove = UPViewMoveMake(self.gameView.wordScoreLabel, Location(role, Spot::Default));
    
    delay(BandGameDelay, 0.25, ^{
        self.showingWordScoreLabel = YES;
        start(bloop_in(BandWordScore, @[wordScoreInMove], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandGameDelay, 1.5, ^{
                [self viewBloopOutWordScoreLabelWithDuration:DefaultBloopDuration];
            });
        }));
    });
}

- (void)viewShowHelpPromptInWordScoreLabel
{
    UIColor *wordScoreColor = [UIColor themeColorWithCategory:self.gameView.wordScoreLabel.colorCategory];
    
    SpellLayout &layout = SpellLayout::instance();
    NSString *string = @"TAP LETTERS TO SPELL A WORD,\nTHEN TAP THE WORD TO SCORE POINTS.";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, string.length);
    [attrString addAttribute:NSFontAttributeName value:layout.help_prompt_font() range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:wordScoreColor range:range];

    self.gameView.wordScoreLabel.frame = layout.frame_for(Role::WordScore, Spot::OffBottomFar);
    self.gameView.wordScoreLabel.hidden = NO;
    self.gameView.wordScoreLabel.attributedString = attrString;
    self.gameView.wordScoreLabel.alpha = 1;

    UPViewMove *wordScoreInMove = UPViewMoveMake(self.gameView.wordScoreLabel, Location(Role::WordScore, Spot::Default));
    
    self.showingWordScoreLabel = YES;
    start(bloop_in(BandWordScore, @[wordScoreInMove], 0.3, ^(UIViewAnimatingPosition) {
    }));
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
        NSMutableString *bonusString = [NSMutableString string];
        if (has_multiplier_bonus && has_length_bonus) {
            [bonusString appendString:lengthBonusString];
            [bonusString appendFormat:@" & %d× WORD", word_multiplier];
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
    self.gameView.wordScoreLabel.alpha = 1;
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

- (void)viewFadeOutWordScoreLabelIfNeeded
{
    if (self.showingWordScoreLabel) {
        [UIView animateWithDuration:0.25 animations:^{
            self.gameView.wordScoreLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.gameView.wordScoreLabel.alpha = 1;
            self.gameView.wordScoreLabel.hidden = YES;
            self.showingWordScoreLabel = NO;
        }];
    }
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

- (void)viewFillPlayerTrayImmediate
{
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    SpellLayout &layout = SpellLayout::instance();
    TileIndex idx = 0;
    for (auto &tile : m_spell_model->tiles()) {
        if (tile.has_view<false>()) {
            const TileModel &model = tile.model();
            UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
            tile.set_view(tileView);
            tileView.band = UP::BandGameUIColor;
            tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
            [self.gameView.tileContainerView addSubview:tileView];
        }
        idx++;
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
        case UPSpellGameAlphaStateReasonInit: {
            CGFloat alpha = [UIColor themeDisabledAlpha];
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            for (UIView *view in @[ self.dialogTopMenu.extrasButton, self.dialogTopMenu.playButton, self.dialogTopMenu.duelButton ]) {
                view.alpha = 1;
            }
            for (UIView *view in @[ self.dialogGameOver.noteLabel, self.dialogGameOver.messagePathView, self.dialogGameOver.shareButton ]) {
                view.alpha = 1;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonReady: {
            CGFloat alpha = [UIColor themeDisabledAlpha];
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonOrderOutGameEnd:
        case UPSpellGameAlphaStateReasonQuitToEnd: {
            CGFloat alpha = [UIColor themeDisabledAlpha];
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            for (UIView *view in @[ self.dialogTopMenu.extrasButton, self.dialogTopMenu.playButton, self.dialogTopMenu.duelButton ]) {
                view.alpha = 1;
            }
            for (UIView *view in @[ self.dialogGameOver.noteLabel, self.dialogGameOver.messagePathView, self.dialogGameOver.shareButton ]) {
                view.alpha = 1;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonRestoredPause: {
            CGFloat alpha = [UIColor themeModalBackgroundAlpha];
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonPause: {
            CGFloat alpha = [UIColor themeModalBackgroundAlpha];
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            break;
        }
        case UPSpellGameAlphaStateReasonDuelHelp: {
            CGFloat alpha = 0.03;
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            for (UIView *view in @[ self.dialogTopMenu.extrasButton, self.dialogTopMenu.playButton, self.dialogTopMenu.duelButton ]) {
                view.alpha = alpha;
            }
            for (UIView *view in @[ self.dialogGameOver.noteLabel, self.dialogGameOver.messagePathView ]) {
                view.alpha = 0;
            }
            self.dialogGameOver.shareButton.alpha = [UIColor themeDisabledAlpha];
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonShareHelp: {
            CGFloat alpha = 0.03;
            for (UIView *view in self.gameView.interactiveSubviews) {
                if (view == self.gameView.timerLabel && self.gameView.timerLabel.alpha == 0) {
                    continue;
                }
                view.alpha = alpha;
            }
            for (UIView *view in @[ self.dialogTopMenu.extrasButton, self.dialogTopMenu.playButton, self.dialogTopMenu.duelButton ]) {
                view.alpha = alpha;
            }
            for (UIView *view in @[ self.dialogGameOver.noteLabel, self.dialogGameOver.messagePathView ]) {
                view.alpha = 0;
            }
            self.dialogGameOver.shareButton.alpha = [UIColor themeDisabledAlpha];
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonGameLink: {
            CGFloat alpha = 0.03;
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            for (UIView *view in @[ self.dialogTopMenu.extrasButton, self.dialogTopMenu.playButton, self.dialogTopMenu.duelButton ]) {
                view.alpha = alpha;
            }
            self.dialogGameLink.alpha = 1;
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonGameLinkHelp: {
            self.dialogGameLink.alpha = 0;
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonPrePlay: {
            for (UIView *view in self.gameView.interactiveSubviews) {
                if (view == self.gameView.tileContainerView) {
                    continue;
                }
                view.alpha = 1;
            }
            self.gameView.tileContainerView.alpha = [UIColor themeDisabledAlpha];
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonDefault:
        case UPSpellGameAlphaStateReasonPlay: {
            if (m_alpha_reason_stack.size()) {
                if (m_alpha_reason_stack.back() == UPSpellGameAlphaStateReasonReject) {
                    for (UIView *view in self.gameView.interactiveSubviews) {
                        if (view == self.gameView.wordTrayControl ||
                            view == self.gameView.clearControl ||
                            view == self.gameView.tileContainerView) {
                            view.alpha = [UIColor themeDisabledAlpha];
                        }
                        else {
                            view.alpha = 1;
                        }
                    }
                }
                else if (m_alpha_reason_stack.back() == UPSpellGameAlphaStateReasonDump) {
                    for (UIView *view in self.gameView.interactiveSubviews) {
                        if (view == self.gameView.wordTrayControl ||
                            view == self.gameView.tileContainerView) {
                            view.alpha = [UIColor themeDisabledAlpha];
                        }
                        else {
                            view.alpha = 1;
                        }
                    }
                }
            }
            else {
                CGFloat alpha = 1;
                for (UIView *view in self.gameView.interactiveSubviews) {
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
            for (UIView *view in self.gameView.interactiveSubviews) {
                view.alpha = alpha;
            }
            m_alpha_reason_stack.clear();
            break;
        }
        case UPSpellGameAlphaStateReasonShareHelpToEnd:
        case UPSpellGameAlphaStateReasonOverToEnd: {
            CGFloat alpha = [UIColor themeModalBackgroundAlpha];
            UIView *timerLabel = self.gameView.timerLabel;
            UIView *gameScoreLabel = self.gameView.gameScoreLabel;
            for (UIView *view in self.gameView.interactiveSubviews) {
                if (view == gameScoreLabel) {
                    view.alpha = 1;
                }
                else if (view == timerLabel) {
                    view.alpha = 0;
                }
                else {
                    view.alpha = alpha;
                }
            }
            for (UIView *view in @[ self.dialogTopMenu.extrasButton, self.dialogTopMenu.playButton, self.dialogTopMenu.duelButton ]) {
                view.alpha = 1;
            }
            for (UIView *view in @[ self.dialogGameOver.noteLabel, self.dialogGameOver.messagePathView, self.dialogGameOver.shareButton ]) {
                view.alpha = 1;
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
    
    self.dialogTopMenuUserInteractionEnabled = NO;
    
    UIView *roundButtonPause = self.gameView.pauseControl;
    for (UIView *view in self.gameView.interactiveSubviews) {
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
    if (self.lockCount == 0) {
        return;
    }
    
    self.lockCount = UPMaxT(NSInteger, self.lockCount - 1, 0);
    if (self.lockCount > 0) {
        return;
    }
    
    self.dialogTopMenuUserInteractionEnabled = YES;
    
    for (UIView *view in self.gameView.interactiveSubviews) {
        view.userInteractionEnabled = YES;
    }
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        tileView.userInteractionEnabled = YES;
    }
}

- (void)viewEnsureUnlocked
{
    if (self.lockCount > 0) {
        [self viewUnlock];
        self.lockCount = 0;
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
    if ([self viewIsUpSpellFilled]) {
        return;
    }
    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SpellLayout &layout = SpellLayout::instance();
    for (TileIndex idx = 0; idx < TileCount; idx++) {
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
        tileView.band = BandGameUI;
        tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
        [self.gameView.tileContainerView addSubview:tileView];
    }
}

- (void)viewRestoreInProgressGame
{
    ASSERT(m_spell_model);
    
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
    TileArray tileArray = m_spell_model ? m_spell_model->tiles() : TileArray();
    size_t wordLength = m_spell_model ? m_spell_model->word().length() : 0;
    [self viewBloopOutExistingTileViewsWithDuration:duration tiles:tileArray wordLength:wordLength completion:completion];
}

- (void)viewBloopOutExistingTileViewsWithDuration:(CFTimeInterval)duration
                                            tiles:(const TileArray &)tiles
                                       wordLength:(size_t)wordLength
                                       completion:(void (^)(void))completion
{
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    if ([self viewIsUpSpellFilled]) {
        TileIndex idx = 0;
        for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
            TilePosition tile_position(TileTray::Player, idx);
            [moves addObject:UPViewMoveMake(tileView, role_in_player_tray(tile_position), Spot::OffBottomNear)];
            idx++;
        }
    }
    else {
        NSMutableSet *submittedTileViews = [NSMutableSet setWithArray:self.gameView.tileContainerView.subviews];
        for (const auto &tile : tiles) {
            if (tile.has_view()) {
                UPTileView *tileView = tile.view();
                if (tile.in_word_tray()) {
                    Role role = role_in_word(tile.position().index(), wordLength);
                    [moves addObject:UPViewMoveMake(tileView, role, Spot::OffBottomNear)];
                }
                else {
                    [moves addObject:UPViewMoveMake(tileView, role_in_player_tray(tile.position()), Spot::OffBottomNear)];
                }
                [submittedTileViews removeObject:tileView];
            }
        }
        for (UPTileView *tileView in submittedTileViews) {
            if (tileView.submitLocation.role() != Role::None) {
                [moves addObject:UPViewMoveMake(tileView, tileView.submitLocation)];
            }
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
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray<UPViewMove *> *tileInMoves = [NSMutableArray array];
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        TileModel model;
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tileView.band = BandModeUI;
        Role role = role_in_player_tray(TilePosition(TileTray::Player, idx));
        tileView.frame = layout.frame_for(Location(role, Spot::OffBottomNear));
        [self.gameView.tileContainerView addSubview:tileView];
        [tileInMoves addObject:UPViewMoveMake(tileView, Location(role, Spot::Default))];
    }
    start(bloop_in(BandModeUI, tileInMoves, duration, ^(UIViewAnimatingPosition) {
        if (completion) {
            completion();
        }
    }));
}

- (void)viewBloopInUpSpellTileViewsWithDuration:(CFTimeInterval)duration completion:(void (^)(void))completion
{
    [self viewFillUpSpellTileViews];
    
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray<UPViewMove *> *tileInMoves = [NSMutableArray array];
    TileIndex idx = 0;
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        Role role = role_in_player_tray(TilePosition(TileTray::Player, idx));
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
                location = Location(role_in_word(tile.position().index(), wordLength), Spot::OffBottomNear);
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

- (void)viewOrderInExtrasWithCompletion:(void (^)(void))completion
{
    cancel_all();
    
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogTopMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffRightFar));
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogTopMenu.duelButton, Location(Role::DialogButtonTopRight, Spot::OffRightFar));
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Location(Role::Screen, Spot::OffRightFar));
    UPViewMove *dialogGameOverMesageMove = UPViewMoveMake(self.dialogGameOver.messagePathView, Location(Role::DialogMessageCenteredInWordTray, Spot::OffRightFar));
    UPViewMove *dialogGameOverNoteLabelMove = UPViewMoveMake(self.dialogGameOver.noteLabel, Location(Role::DialogGameNote, Spot::OffRightFar));
    UPViewMove *dialogGameOverShareButtonMove = UPViewMoveMake(self.dialogGameOver.shareButton, Location(Role::GameShareButton, Spot::OffRightFar));

    CFTimeInterval duration = 0.75;
    CFTimeInterval stagger = 0.075;
    
    start(bloop_out(BandModeUI, @[aboutButtonMove], duration, nil));
    delay(BandModeDelay, stagger, ^{
        start(bloop_out(BandModeUI, @[playButtonMove], duration - stagger, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, (1.5 * stagger), ^{
        NSArray<UPViewMove *> *moves = @[gameViewMove, dialogGameOverMesageMove, dialogGameOverNoteLabelMove, dialogGameOverShareButtonMove];
        start(bloop_out(BandModeUI, moves, duration - (1.5 * stagger),
                        ^(UIViewAnimatingPosition) {
            
            [self viewUnlock];
            [self setGameOverViewsHidden:YES];
            self.dialogTopMenuUserInteractionEnabled = NO;
            if (completion) {
                completion();
            }
        }));
    });
}

- (void)viewOrderInGameLinkFromMode:(Mode)mode
{
    ASSERT(self.gameLink);
    
    [self viewLock];
    
    // Clobber existing game
    [self.gameTimer reset];
    [self clearGameModel];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    [self viewFillUpSpellTileViews];
    
    SpellLayout &layout = SpellLayout::instance();
    
    // Handle coming from Pause
    if (mode == Mode::Pause) {
        self.gameView.transform = layout.menu_game_view_transform();
        self.dialogPause.messagePathView.frame = layout.frame_for(Role::DialogMessageCenteredInWordTray, Spot::OffBottomFar);
        self.dialogPause.quitButton.frame = layout.frame_for(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar);
        self.dialogPause.resumeButton.frame = layout.frame_for(Role::DialogButtonDefaultResponse, Spot::OffBottomFar);
        self.dialogPause.alpha = 0;
        self.dialogPause.hidden = YES;
        self.gameView.pauseControl.highlightedLocked = NO;
        self.gameView.pauseControl.highlighted = NO;
    }
    
    // Fix up top menu
    self.dialogTopMenu.extrasButton.frame = layout.frame_for(Role::DialogButtonTopLeft);
    self.dialogTopMenu.playButton.frame = layout.frame_for(Role::DialogButtonTopCenter);
    self.dialogTopMenu.duelButton.frame = layout.frame_for(Role::DialogButtonTopRight);
    self.dialogTopMenu.playButton.highlightedLocked = NO;
    self.dialogTopMenu.playButton.highlighted = NO;
    self.dialogTopMenu.duelButton.highlightedLocked = NO;
    self.dialogTopMenu.duelButton.highlighted = NO;
    self.dialogTopMenuUserInteractionEnabled = NO;
    
    // Show the logo interstitial
    [self.dialogGameLink updateThemeColors];
    [self.dialogGameLink updateWithGameLink:self.gameLink];
    self.dialogGameLink.hidden = NO;
    self.dialogGameLink.alpha = 1;
    
    Role cancelRole = self.gameLink.valid ? Role::DialogButtonAlternativeResponse : Role::DialogButtonCenterResponse;
    if (!self.gameLink.valid) {
        self.gameLink = nil;
    }

    if (self.gameLinkSender) {
        self.dialogGameLink.logoView.frame = layout.frame_for(Role::HeroLogo, Spot::OffBottomFar);
        self.dialogGameLink.wordMarkLabel.frame = layout.frame_for(Role::HeroWordMark, Spot::OffBottomFar);
    }
    else {
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonGameLink];
        self.dialogGameLink.logoView.frame = layout.frame_for(Role::HeroLogo);
        self.dialogGameLink.wordMarkLabel.frame = layout.frame_for(Role::HeroWordMark);
    }
    
    self.dialogGameLink.titlePromptLabel.frame = layout.frame_for(Role::GameLinkTitle, Spot::OffBottomFar);
    self.dialogGameLink.detailPromptLabel.frame = layout.frame_for(Role::GameLinkDetail, Spot::OffBottomFar);
    self.dialogGameLink.confirmButton.frame = layout.frame_for(Role::DialogButtonDefaultResponse, Spot::OffBottomNear);
    self.dialogGameLink.cancelButton.frame = layout.frame_for(cancelRole, Spot::OffBottomNear);
    self.dialogGameLink.helpButton.frame = layout.frame_for(Role::DialogHelpButton, Spot::OffBottomNear);

    void (^bottomHalf)(void) = ^{
        // Move the challenge dialog in
        NSArray<UPViewMove *> *commonShareMoves = @[
            UPViewMoveMake(self.dialogGameLink.titlePromptLabel, Location(Role::GameLinkTitle)),
            UPViewMoveMake(self.dialogGameLink.detailPromptLabel, Location(Role::GameLinkDetail)),
            UPViewMoveMake(self.dialogGameLink.confirmButton, Location(Role::DialogButtonDefaultResponse)),
            UPViewMoveMake(self.dialogGameLink.cancelButton, cancelRole)
        ];
        UPViewMove *helpButtonMove = UPViewMoveMake(self.dialogGameLink.helpButton, Location(Role::DialogHelpButton));
        NSMutableArray<UPViewMove *> *shareMoves = [NSMutableArray array];
        [shareMoves addObjectsFromArray:commonShareMoves];
        if (!self.gameLinkSender) {
            [shareMoves addObject:helpButtonMove];
        }
        start(bloop_in(BandModeUI, shareMoves, 0.4,  ^(UIViewAnimatingPosition) {
            [self viewUnlock];
        }));
    };
    
    if (!self.gameLinkSender) {
        delay(BandModeDelay, 1.1, ^{
            // Move the logo interstitial out
            NSArray<UPViewMove *> *logoMoves = @[
                UPViewMoveMake(self.dialogGameLink.logoView, Location(Role::HeroLogo, Spot::OffBottomFar)),
                UPViewMoveMake(self.dialogGameLink.wordMarkLabel, Location(Role::HeroWordMark, Spot::OffBottomFar)),
            ];
            start(bloop_out(BandModeUI, logoMoves, 0.4,  ^(UIViewAnimatingPosition) {
                bottomHalf();
            }));
        });
    }
    else {
//        delay(BandModeDelay, 0.25, ^{
            [UIView animateWithDuration:0.4 animations:^{
                [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonGameLink];
            }];
            bottomHalf();
//        });
    }
}

- (void)viewOrderOutGameEnd
{
    ASSERT(self.lockCount > 0);
    
    // reset game controls
    [self clearGameModel];
    [self.gameTimer reset];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonOrderOutGameEnd];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.messagePathView.center = layout.center_for(Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);
    self.dialogGameOver.messagePathView.transform = CGAffineTransformIdentity;
    self.dialogGameOver.noteLabel.center = layout.center_for(Role::DialogGameNote, Spot::OffBottomFar);
    self.dialogGameOver.shareButton.center = layout.center_for(Role::GameShareButton, Spot::OffBottomFar);
    [self setGameOverViewsHidden:YES];
    self.gameView.gameScoreLabel.transform = CGAffineTransformIdentity;
    self.gameView.gameScoreLabel.frame = layout.frame_for(Role::GameScore);
    self.dialogShareHelp.titleLabel.center = layout.center_for(Role::DialogHelpTitle, Spot::OffBottomFar);
    self.dialogShareHelp.helpLabelContainer.center = layout.center_for(Role::DialogHelpText, Spot::OffBottomFar);
    self.dialogShareHelp.okButton.center = layout.center_for(Role::DialogHelpOKButton, Spot::OffBottomNear);
    self.dialogGameLinkHelp.titleLabel.center = layout.center_for(Role::DialogHelpTitle, Spot::OffBottomFar);
    self.dialogGameLinkHelp.helpLabelContainer.center = layout.center_for(Role::DialogHelpText, Spot::OffBottomFar);
    self.dialogGameLinkHelp.okButton.center = layout.center_for(Role::DialogHelpOKButton, Spot::OffBottomNear);
}

- (void)viewOrderInDialogShareHelp
{
    [self viewLock];
    
    [self.dialogShareHelp updateThemeColors];
    
    self.dialogGameOver.shareButton.highlightedLocked = YES;
    self.dialogGameOver.shareButton.highlighted = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonShareHelp];
    } completion:nil];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogShareHelp.titleLabel.center = layout.center_for(Role::DialogHelpTitle, Spot::OffBottomFar);
    self.dialogShareHelp.helpLabelContainer.center = layout.center_for(Role::DialogHelpText, Spot::OffBottomFar);
    self.dialogShareHelp.okButton.center = layout.center_for(Role::DialogHelpOKButton, Spot::OffBottomFar);
    self.dialogShareHelp.hidden = NO;
    self.dialogShareHelp.alpha = 1;
    
    self.dialogTopMenuUserInteractionEnabled = NO;
    
    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogShareHelp.titleLabel, Location(Role::DialogHelpTitle)),
        UPViewMoveMake(self.dialogShareHelp.helpLabelContainer, Location(Role::DialogHelpText)),
        UPViewMoveMake(self.dialogShareHelp.okButton, Location(Role::DialogHelpOKButton)),
    ];
    start(bloop_in(BandModeUI, moves, 0.4,  ^(UIViewAnimatingPosition) {
        [self viewEnsureUnlocked];
    }));
}

- (void)viewOrderInDialogDuelHelp
{
    [self viewLock];
    
    [self.dialogDuelHelp updateThemeColors];
    
    self.dialogTopMenu.duelButton.highlightedLocked = YES;
    self.dialogTopMenu.duelButton.highlighted = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonDuelHelp];
    } completion:nil];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogDuelHelp.titleLabel.center = layout.center_for(Role::DialogDuelHelpTitle, Spot::OffBottomFar);
    self.dialogDuelHelp.helpLabelContainer.center = layout.center_for(Role::DialogDuelHelpText, Spot::OffBottomFar);
    self.dialogDuelHelp.okButton.center = layout.center_for(Role::DialogDuelHelpOKButton, Spot::OffBottomFar);
    self.dialogDuelHelp.hidden = NO;
    self.dialogDuelHelp.alpha = 1;
    
    self.dialogTopMenuUserInteractionEnabled = NO;

    [UIView animateWithDuration:0.2 animations:^{
        self.dialogGameOver.messagePathView.alpha = 0;
        self.dialogGameOver.noteLabel.alpha = 0;
        self.dialogGameOver.shareButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.dialogGameOver.messagePathView.frame = layout.frame_for(Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);
        self.dialogGameOver.noteLabel.frame = layout.frame_for(Role::DialogGameNote, Spot::OffBottomFar);
        self.dialogGameOver.shareButton.frame = layout.frame_for(Role::GameShareButton, Spot::OffBottomFar);
        self.dialogGameOver.shareButton.highlightedLocked = NO;
        self.dialogGameOver.shareButton.highlighted = NO;
    }];

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogDuelHelp.titleLabel, Role::DialogDuelHelpTitle),
        UPViewMoveMake(self.dialogDuelHelp.helpLabelContainer, Role::DialogDuelHelpText),
        UPViewMoveMake(self.dialogDuelHelp.okButton, Role::DialogDuelHelpOKButton),
    ];
    start(bloop_in(BandModeUI, moves, 0.4,  ^(UIViewAnimatingPosition) {
        [self.gameTimer reset];
        [self viewUpdateGameControls];
        [self viewFillUpSpellTileViews];
        
        self.dialogGameOver.messagePathView.alpha = 1;
        self.dialogGameOver.noteLabel.alpha = 1;
        self.dialogGameOver.shareButton.alpha = 1;
        self.dialogGameOver.shareButton.highlightedLocked = NO;
        self.dialogGameOver.shareButton.highlighted = NO;
        [self setGameOverViewsHidden:YES];
        
        self.gameView.gameScoreLabel.transform = CGAffineTransformIdentity;
        self.gameView.gameScoreLabel.frame = layout.frame_for(Role::GameScore);
        
        self.gameLinkSender = NO;

        [self viewEnsureUnlocked];
    }));
}

- (void)viewOrderOutDialogShareHelpWithCompletion:(void (^)(void))completion
{
    [self viewLock];
    
    self.dialogTopMenuUserInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonShareHelpToEnd];
    } completion:nil];
    
    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogShareHelp.titleLabel, Location(Role::DialogHelpTitle, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogShareHelp.helpLabelContainer, Location(Role::DialogHelpText, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogShareHelp.okButton, Location(Role::DialogHelpOKButton, Spot::OffBottomFar)),
    ];
    start(bloop_out(BandModeUI, moves, 0.4,  ^(UIViewAnimatingPosition) {
        self.dialogShareHelp.hidden = YES;
        self.dialogShareHelp.alpha = 1;
        [self viewEnsureUnlocked];
        if (completion) {
            completion();
        }
    }));
}

- (void)viewOrderOutDialogDuelHelpWithCompletion:(void (^)(void))completion
{
    [self viewLock];
    
    self.dialogTopMenuUserInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonInit];
    } completion:nil];
    
    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogDuelHelp.titleLabel, Location(Role::DialogDuelHelpTitle, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogDuelHelp.helpLabelContainer, Location(Role::DialogDuelHelpText, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogDuelHelp.okButton, Location(Role::DialogDuelHelpOKButton, Spot::OffBottomFar)),
    ];
    start(bloop_out(BandModeUI, moves, 0.4,  ^(UIViewAnimatingPosition) {
        self.dialogDuelHelp.hidden = YES;
        self.dialogDuelHelp.alpha = 1;
        [self viewEnsureUnlocked];
        if (completion) {
            completion();
        }
    }));
}

- (void)viewOrderInDialogGameLinkHelp
{
    [self viewLock];
    
    [self.dialogGameLinkHelp updateWithGameLink:self.gameLink];
    [self.dialogGameLinkHelp updateThemeColors];
    
    self.dialogGameLink.helpButton.highlightedLocked = YES;
    self.dialogGameLink.helpButton.highlighted = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonGameLinkHelp];
    } completion:nil];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameLinkHelp.titleLabel.center = layout.center_for(Role::DialogHelpTitle, Spot::OffBottomFar);
    self.dialogGameLinkHelp.helpLabelContainer.center = layout.center_for(Role::DialogHelpText, Spot::OffBottomFar);
    self.dialogGameLinkHelp.okButton.center = layout.center_for(Role::DialogHelpOKButton, Spot::OffBottomFar);
    self.dialogGameLinkHelp.hidden = NO;
    self.dialogGameLinkHelp.alpha = 1;
    
    self.dialogTopMenuUserInteractionEnabled = NO;
    
    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogGameLinkHelp.titleLabel, Location(Role::DialogHelpTitle)),
        UPViewMoveMake(self.dialogGameLinkHelp.helpLabelContainer, Location(Role::DialogHelpText)),
        UPViewMoveMake(self.dialogGameLinkHelp.okButton, Location(Role::DialogHelpOKButton)),
    ];
    start(bloop_in(BandModeUI, moves, 0.4,  ^(UIViewAnimatingPosition) {
        [self viewEnsureUnlocked];
    }));
}

- (void)viewOrderOutDialogGameLinkHelpWithCompletion:(void (^)(void))completion
{
    [self viewLock];
    
    self.dialogTopMenuUserInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonGameLink];
    } completion:nil];
    
    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogGameLinkHelp.titleLabel, Location(Role::DialogHelpTitle, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogGameLinkHelp.helpLabelContainer, Location(Role::DialogHelpText, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogGameLinkHelp.okButton, Location(Role::DialogHelpOKButton, Spot::OffBottomFar)),
    ];
    start(bloop_out(BandModeUI, moves, 0.4,  ^(UIViewAnimatingPosition) {
        self.dialogGameLinkHelp.hidden = YES;
        self.dialogGameLinkHelp.alpha = 1;
        self.dialogGameLink.helpButton.highlightedLocked = NO;
        self.dialogGameLink.helpButton.highlighted = NO;
        [self viewEnsureUnlocked];
        if (completion) {
            completion();
        }
    }));
}

- (void)viewImmediateTransitionToInit
{
    ASSERT(self.lockCount > 0);
    
    cancel_all();
    
    [self removeInProgressGameFileLogErrors:NO];

    [[UPSoundPlayer instance] stop];
    [[UPTunePlayer instance] fade];

    [self.gameTimer reset];
    m_spell_model = std::make_shared<SpellModel>();
    [self viewUpdateGameControls];
    [self viewFillUpSpellTileViews];
    
    SpellLayout &layout = SpellLayout::instance();
    self.gameView.transform = CGAffineTransformIdentity;
    self.gameView.frame = layout.frame_for(Role::Screen);
    self.gameView.transform = layout.menu_game_view_transform();
    
    self.dialogTopMenu.readyMessagePathView.frame = layout.frame_for(Location(Role::DialogMessageVerticallyCentered, Spot::OffBottomNear));
    self.dialogTopMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft));
    self.dialogTopMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter));
    self.dialogTopMenu.duelButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight));
    self.dialogTopMenu.playButton.highlightedLocked = NO;
    self.dialogTopMenu.playButton.highlighted = NO;
    self.dialogTopMenu.playButton.selected = NO;
    self.dialogTopMenu.duelButton.highlightedLocked = NO;
    self.dialogTopMenu.duelButton.highlighted = NO;
    self.dialogTopMenuUserInteractionEnabled = YES;
    
    self.dialogGameOver.messagePathView.frame = layout.frame_for(Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);
    self.dialogGameOver.noteLabel.frame = layout.frame_for(Role::DialogGameNote, Spot::OffBottomFar);
    self.dialogGameOver.shareButton.frame = layout.frame_for(Role::GameShareButton, Spot::OffBottomFar);
    self.dialogGameOver.shareButton.highlightedLocked = NO;
    self.dialogGameOver.shareButton.highlighted = NO;
    [self setGameOverViewsHidden:YES];

    self.dialogGameLink.logoView.frame = layout.frame_for(Role::HeroLogo, Spot::OffBottomNear);
    self.dialogGameLink.wordMarkLabel.frame = layout.frame_for(Role::HeroWordMark, Spot::OffBottomNear);
    self.dialogGameLink.titlePromptLabel.frame = layout.frame_for(Role::GameLinkTitle, Spot::OffBottomFar);
    self.dialogGameLink.detailPromptLabel.frame = layout.frame_for(Role::GameLinkDetail, Spot::OffBottomNear);
    self.dialogGameLink.confirmButton.frame = layout.frame_for(Role::DialogButtonDefaultResponse, Spot::OffBottomNear);
    self.dialogGameLink.cancelButton.frame = layout.frame_for(Role::DialogButtonAlternativeResponse, Spot::OffBottomNear);
    self.dialogGameLink.helpButton.frame = layout.frame_for(Role::DialogHelpButton, Spot::OffBottomNear);
    self.dialogGameLink.helpButton.highlightedLocked = NO;
    self.dialogGameLink.helpButton.highlighted = NO;

    self.dialogShareHelp.titleLabel.frame = layout.frame_for(Role::DialogHelpTitle, Spot::OffBottomFar);
    self.dialogShareHelp.helpLabelContainer.frame = layout.frame_for(Role::DialogHelpText, Spot::OffBottomFar);
    self.dialogShareHelp.okButton.frame = layout.frame_for(Role::DialogHelpOKButton, Spot::OffBottomNear);

    self.dialogDuelHelp.titleLabel.frame = layout.frame_for(Role::DialogHelpTitle, Spot::OffBottomFar);
    self.dialogDuelHelp.helpLabelContainer.frame = layout.frame_for(Role::DialogHelpText, Spot::OffBottomFar);
    self.dialogDuelHelp.okButton.frame = layout.frame_for(Role::DialogHelpOKButton, Spot::OffBottomNear);

    self.dialogGameLinkHelp.titleLabel.frame = layout.frame_for(Role::DialogHelpTitle, Spot::OffBottomFar);
    self.dialogGameLinkHelp.helpLabelContainer.frame = layout.frame_for(Role::DialogHelpText, Spot::OffBottomFar);
    self.dialogGameLinkHelp.okButton.frame = layout.frame_for(Role::DialogHelpOKButton, Spot::OffBottomNear);
    
    self.dialogGameLink.alpha = 1;
    self.dialogGameLink.hidden = YES;
    self.dialogShareHelp.alpha = 1;
    self.dialogShareHelp.hidden = YES;
    self.dialogDuelHelp.alpha = 1;
    self.dialogDuelHelp.hidden = YES;
    self.dialogGameLinkHelp.alpha = 1;
    self.dialogGameLinkHelp.hidden = YES;

    self.gameView.gameScoreLabel.transform = CGAffineTransformIdentity;
    self.gameView.gameScoreLabel.frame = layout.frame_for(Role::GameScore);
    self.gameView.gameScoreLabel.alpha = 1;
    self.gameView.timerLabel.alpha = 1;
    self.gameView.pulseView.alpha = 0;
    
    self.gameLinkSender = NO;
    
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonInit];
    
    [self clearGameModel];
}

- (void)viewMakeReadyFromMode:(Mode)mode completion:(void (^)(void))completion
{
    ASSERT(!m_spell_model);
    ASSERT(self.lockCount > 0);

    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    // lock play button in highlighted state
    self.dialogTopMenu.playButton.highlightedLocked = YES;
    self.dialogTopMenu.playButton.highlighted = YES;
    
    [self viewOrderOutWordScoreLabel];
    
    CFTimeInterval alphaDelay = mode == Mode::End ? 0.35 : 0.1;
    delay(BandModeDelay, alphaDelay, ^{
        [UIView animateWithDuration:0.25 animations:^{
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonReady];
        }];
    });
    
    void (^bottomHalf)(void) = ^{
        // change transform of game view
        [UIView animateWithDuration:0.75 animations:^{
            self.gameView.transform = CGAffineTransformIdentity;
        }];
        delay(BandModeDelay, 0.45, ^{
            if (self.mode != Mode::Ready) {
                [self viewLock];
                [self viewImmediateTransitionToInit];
                [self viewUnlock];
                return;
            }
            // bloop in ready message
            self.dialogTopMenu.readyMessagePathView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.dialogTopMenu.readyMessagePathView.alpha = 1;
            }];
            UPViewMove *readyMove = UPViewMoveMake(self.dialogTopMenu.readyMessagePathView, Location(Role::DialogMessageCenteredInWordTray));
            start(bloop_in(BandModeUI, @[readyMove], 0.3,  ^(UIViewAnimatingPosition) {
                if (self.mode != Mode::Ready) {
                    [self viewLock];
                    [self viewImmediateTransitionToInit];
                    [self viewUnlock];
                    return;
                }
            }));
        });
        delay(BandModeDelay, 1.75, ^{
            if (self.mode == Mode::Ready) {
                completion();
            }
            else {
                [self viewLock];
                [self viewImmediateTransitionToInit];
                [self viewUnlock];
            }
        });
    };
    
    BOOL comingFromGameLink = mode == Mode::GameLink;
    if (comingFromGameLink) {
        self.dialogGameOver.messagePathView.transform = CGAffineTransformIdentity;
        bottomHalf();
    }
    else {
        [self updateSoundAndTunesSettings];
        [self playTuneIntro];
        
        // move extras and about buttons offscreen
        
        NSMutableArray<UPViewMove *> *outGameOverMoves = [NSMutableArray arrayWithArray:@[
            UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageVerticallyCentered, Spot::OffBottomNear),
            UPViewMoveMake(self.dialogGameOver.noteLabel, Role::DialogGameNote, Spot::OffBottomFar),
            UPViewMoveMake(self.dialogGameOver.shareButton, Role::GameShareButton, Spot::OffBottomFar),
        ]];
        BOOL gameScoreLabelNeedsMove = mode == Mode::End && !CGAffineTransformIsIdentity(self.gameView.gameScoreLabel.transform);
        if (gameScoreLabelNeedsMove) {
            Role role = role_for_score(self.endGameScore);
            [outGameOverMoves addObject:UPViewMoveMake(self.gameView.gameScoreLabel, role, Spot::OffBottomFar)];
        }
        
        start(bloop_out(BandModeUI, outGameOverMoves, 0.3, ^(UIViewAnimatingPosition) {
            [self.gameTimer reset];
            [self clearGameModel];
            [self viewUpdateGameControls];
            if (mode == Mode::End) {
                SpellLayout &layout = SpellLayout::instance();
                if (gameScoreLabelNeedsMove) {
                    self.gameView.gameScoreLabel.transform = CGAffineTransformIdentity;
                    self.gameView.gameScoreLabel.frame = layout.frame_for(Role::GameScore);
                    self.gameView.gameScoreLabel.alpha = 0;
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.gameView.timerLabel.alpha = [UIColor themeDisabledAlpha];
                    self.gameView.gameScoreLabel.alpha = [UIColor themeDisabledAlpha];
                } completion:nil];
            }
        }));
        
        NSArray<UPViewMove *> *outMoves = @[
            UPViewMoveMake(self.dialogTopMenu.extrasButton, Location(Role::DialogButtonTopLeft, Spot::OffTopNear)),
            UPViewMoveMake(self.dialogTopMenu.duelButton, Location(Role::DialogButtonTopRight, Spot::OffTopNear)),
        ];
        start(bloop_out(BandModeUI, outMoves, 0.3, ^(UIViewAnimatingPosition) {
            self.dialogGameOver.messagePathView.transform = CGAffineTransformIdentity;
            
            delay(BandModeDelay, 0.35, ^{
                // move play button
                NSArray<UPViewMove *> *playMoves = @[
                    UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter, Spot::OffTopNear),
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
    
    NSMutableString *labelString = [NSMutableString string];

    if (labelString.length == 0) {
        NSString *string = [self gameNoteGameDuel];
        if (string) {
            [labelString appendString:string];
        }
    }

    if (labelString.length == 0) {
        NSString *string = [self gameNoteGameChallenge];
        if (string) {
            [labelString appendString:string];
        }
    }
    
    if (labelString.length == 0) {
        NSString *string = [self gameNoteGameHighScore];
        if (string) {
            [labelString appendString:string];
        }
    }
    
    if (labelString.length == 0) {
        NSString *string = [self gameNoteBestWordInGame];
        if (string) {
            [labelString appendString:string];
        }
    }
    
    if (labelString.length == 0) {
        [labelString appendString:[self gameNoteRandomWord]];
    }
    
    NSArray *components = [labelString componentsSeparatedByString:@"\n"];
    if (components.count == 1) {
        self.dialogGameOver.noteLabel.string = labelString;
    }
    else if (components.count == 2) {
        SpellLayout &layout = SpellLayout::instance();
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:components[0]];
        [attrString addAttribute:NSFontAttributeName value:layout.game_note_font() range:NSMakeRange(0, attrString.length)];
        
        NSMutableAttributedString *bottomString = [[NSMutableAttributedString alloc] initWithString:components[1]];
        NSRange bottomRange = NSMakeRange(0, bottomString.length);
        [bottomString addAttribute:NSFontAttributeName value:layout.game_note_font() range:bottomRange];
        CGFloat baselineAdjustment = SpellLayout::CanonicalGameNoteFontBaselineAdjustment * layout.layout_scale();
        [bottomString addAttribute:(NSString *)kCTBaselineOffsetAttributeName value:@(baselineAdjustment) range:bottomRange];
        
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [attrString appendAttributedString:bottomString];
        UIColor *color = [UIColor themeColorWithCategory:self.dialogGameOver.noteLabel.colorCategory];
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attrString.length)];
        
        self.dialogGameOver.noteLabel.attributedString = attrString;
    }
    
}

#pragma mark - Game note strings

- (NSString *)gameNoteGameDuel
{
    ASSERT(self.mode == Mode::End);
    ASSERT(m_spell_model);
    
    NSString *result = nil;
    
    if (m_spell_model->is_duel<false>()) {
        return result;
    }
    
    int score = m_spell_model->game_score();
    
    NSString *highScoreNote = nil;
    UPSpellDossier *dossier = [UPSpellDossier instance];
    if (score > dossier.highScore) {
        highScoreNote = @"NEW HIGH SCORE!";
    }
    else if (score == dossier.highScore) {
        highScoreNote = @"TIED HIGH SCORE!";
    }
    
    if (highScoreNote) {
        result = [NSString stringWithFormat:@"DID YOU WIN? SHARE YOUR SCORE!\n%@", highScoreNote];
    }
    else {
        std::vector<Word> words = m_spell_model->game_best_word();
        if (words.size() > 0) {
            const Word &word = words[0];
            NSString *wordString = ns_str(word.string());
            result = [NSString stringWithFormat:@"DID YOU WIN? SHARE YOUR SCORE!\nBEST WORD: %@ +%d", wordString, word.total_score()];
        }
        else {
            result = @"DID YOU WIN?\nSHARE YOUR SCORE!";
        }
    }
    
    return result;
}

- (NSString *)gameNoteGameChallenge
{
    ASSERT(self.mode == Mode::End);
    ASSERT(m_spell_model);
    
    NSString *result = nil;
    
    if (m_spell_model->is_challenge<false>()) {
        return result;
    }
    
    int score = m_spell_model->game_score();

    NSString *highScoreNote = @"";
    UPSpellDossier *dossier = [UPSpellDossier instance];
    if (score > dossier.highScore) {
        highScoreNote = @"NEW HIGH SCORE! ";
    }
    else if (score == dossier.highScore) {
        highScoreNote = @"TIED HIGH SCORE! ";
    }

    if (score < m_spell_model->challenge_score()) {
        result = [NSString stringWithFormat:@"%@CHALLENGE LOST!\nSCORE TO BEAT WAS %d.", highScoreNote, m_spell_model->challenge_score()];
    }
    else if (score == m_spell_model->challenge_score()) {
        result = [NSString stringWithFormat:@"%@CHALLENGE TIED!\nSCORE TO BEAT WAS %d.", highScoreNote, m_spell_model->challenge_score()];
    }
    else {
        result = [NSString stringWithFormat:@"CHALLENGE WON! SHARE YOUR SCORE!\nSCORE TO BEAT WAS %d.", m_spell_model->challenge_score()];
    }
    
    return result;
}

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
    else if (score + 10 >= dossier.highScore || score >= dossier.highScore * 0.95) {
        result = [NSString stringWithFormat:@"CLOSE TO HIGH SCORE: %d", dossier.highScore];
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
    return [NSString stringWithFormat:@"BEST WORD: %@ +%d", wordString, word.total_score()];
}

- (NSString *)gameNoteRandomWord
{
    ASSERT(self.mode == Mode::End);
    
    Lexicon &lexicon = Lexicon::instance();
    std::u32string random_string = lexicon.random_key(Random::instance());
    return [NSString stringWithFormat:@"RANDOM WORD: %@", ns_str(random_string)];
}

#pragma mark - Model management

- (void)createGameModelIfNeeded
{
    if (m_spell_model) {
        return;
    }
    
    if (self.gameLink) {
        if (self.gameLink.type == UPGameLinkTypeChallenge) {
            m_spell_model = std::make_shared<SpellModel>(GameKey(self.gameLink.gameKey.value), self.gameLink.score);
        }
        else {
            m_spell_model = std::make_shared<SpellModel>(GameKey(self.gameLink.gameKey.value));
            m_spell_model->set_duel();
        }
        self.gameLink = nil;
        self.gameLinkSender = NO;
    }
    else {
        m_spell_model = std::make_shared<SpellModel>(GameKey::random());
    }
}

- (void)clearGameModel
{
    m_spell_model = nullptr;
}

#pragma mark - Archiving persistent data and in-progress game

static NSString * const UPSpellInProgressGameFileName = @"up-spell-in-progress-game.dat";

- (void)saveInProgressGameIfNecessary
{
    if (!m_spell_model) {
        return;
    }
    
    if (m_spell_model->states().size() == 0 ||
        m_spell_model->back_opcode() == Opcode::START ||
        m_spell_model->back_opcode() == Opcode::QUIT ||
        m_spell_model->back_opcode() == Opcode::OVER ||
        m_spell_model->back_opcode() == Opcode::END ||
        self.gameTimer.remainingTime == 0 ||
        self.gameTimer.remainingTime == UPGameTimerDefaultDuration) {
        LOG(SaveRestore, "not saving game");
        [self removeInProgressGameFileLogErrors:NO];
        return;
    }
    
    if (m_spell_model->back_opcode() != Opcode::PAUSE) {
        m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::PAUSE));
    }
    
    UPSpellModel *model = [UPSpellModel spellModelWithInner:m_spell_model];
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:&error];
    if (error) {
        LOG(SaveRestore, "error writing in-progress game: %@", error);
    }
    else {
        NSString *saveFilePath = [[NSFileManager defaultManager] documentsDirectoryPathWithFileName:UPSpellInProgressGameFileName];
        if (saveFilePath) {
            [data writeToFile:saveFilePath atomically:YES];
            LOG(SaveRestore, "saveInProgressGameIfNecessary: %@", saveFilePath);
        }
        else {
            LOG(SaveRestore, "error writing in-progress game: save file unavailable, %@", saveFilePath);
        }
    }
}

- (SpellModelPtr)restoreInProgressGameIfExists
{
    SpellModelPtr result = nullptr;
    NSError *error;
    
    NSString *saveFilePath = [[NSFileManager defaultManager] documentsDirectoryPathWithFileName:UPSpellInProgressGameFileName];
    if (saveFilePath) {
        LOG(SaveRestore, "restoreInProgressGameIfExists: %@", saveFilePath);
        NSData *data = [NSData dataWithContentsOfFile:saveFilePath];
        
        // Remove file before trying to read it.
        // That way, if there's some unexpected (and therefore unhandled) error that could possibly cause a crash,
        // the program won't crash again on relaunch.
        [self removeInProgressGameFileLogErrors:NO];

        if (data) {
            UPSpellModel *model = [NSKeyedUnarchiver unarchivedObjectOfClass:[UPSpellModel class] fromData:data error:&error];
            if (!model || error) {
                LOG(SaveRestore, "error reading in-progress game data: %@ : %@ : %@", saveFilePath, model, error);
            }
            else if (model.inner->back_opcode() != Opcode::PAUSE) {
                LOG(SaveRestore, "in-progress game doesn't end with PAUSE: %@ : %@", saveFilePath, error);
            }
            else {
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
        LOG(SaveRestore, "error removing in-progress game data file: %@ : %@", saveFilePath, error);
    }
}

#pragma mark - Duel

- (void)presentDuelShareSheet
{
    self.dialogTopMenu.duelButton.highlightedLocked = YES;
    self.dialogTopMenu.duelButton.highlighted = YES;

    SpellLayout &layout = SpellLayout::instance();

    [UIView animateWithDuration:0.35 animations:^{
        self.dialogGameOver.messagePathView.alpha = 0;
        self.dialogGameOver.noteLabel.alpha = 0;
        self.dialogGameOver.shareButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.dialogGameOver.messagePathView.frame = layout.frame_for(Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);
        self.dialogGameOver.noteLabel.frame = layout.frame_for(Role::DialogGameNote, Spot::OffBottomFar);
        self.dialogGameOver.shareButton.frame = layout.frame_for(Role::GameShareButton, Spot::OffBottomFar);
        self.dialogGameOver.shareButton.highlightedLocked = NO;
        self.dialogGameOver.shareButton.highlighted = NO;
    }];

    UPGameKey *duelGameKey = [UPGameKey randomGameKey];
    UPActivityViewController *activityViewController = [[UPActivityViewController alloc] initWithShareType:UPShareTypeDuel gameKey:duelGameKey];
    __weak UPActivityViewController *weakActivityViewController = activityViewController;
    activityViewController.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (completed) {
            self.gameLinkSender = YES;
            self.gameLink = [UPGameLink duelGameLinkWithGameKey:duelGameKey];
        }
        else {
            self.gameLinkSender = NO;
            self.gameLink = nil;
        }
        [self duelShareSheetDismissed];
        weakActivityViewController.completionWithItemsHandler = nil;
    };
    [self presentViewController:activityViewController animated:YES completion:^{
        [self viewLock];
        
        [self.gameTimer reset];
        [self viewUpdateGameControls];
        [self viewFillUpSpellTileViews];
        
        self.dialogGameOver.messagePathView.alpha = 1;
        self.dialogGameOver.noteLabel.alpha = 1;
        self.dialogGameOver.shareButton.alpha = 1;
        self.dialogGameOver.shareButton.highlightedLocked = NO;
        self.dialogGameOver.shareButton.highlighted = NO;
        [self setGameOverViewsHidden:YES];
        
        self.gameView.gameScoreLabel.transform = CGAffineTransformIdentity;
        self.gameView.gameScoreLabel.frame = layout.frame_for(Role::GameScore);

        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonInit];

        [self viewEnsureUnlocked];
    }];
}

- (void)duelShareSheetDismissed
{
    self.dialogTopMenu.duelButton.highlightedLocked = NO;
    self.dialogTopMenu.duelButton.highlighted = NO;
}

#pragma mark - Share

- (void)presentShareSheet
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    UPShareType shareType = UPShareTypeLastGameScore;
    UPGameKey *duelGameKey = nil;
    if (dossier.lastGameWasChallenge) {
        shareType = UPShareTypeChallengeReply;
    }
    else if (dossier.lastGameWasDuel) {
        shareType = UPShareTypeDuelReply;
        duelGameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
    }
    UPActivityViewController *activityViewController = [[UPActivityViewController alloc] initWithShareType:shareType gameKey:duelGameKey];
    __weak UPActivityViewController *weakActivityViewController = activityViewController;
    activityViewController.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        [self shareSheetDismissed];
        weakActivityViewController.completionWithItemsHandler = nil;
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)shareSheetDismissed
{
    self.dialogGameOver.shareButton.highlightedLocked = NO;
    self.dialogGameOver.shareButton.highlighted = NO;
    self.dialogGameOver.shareButton.alpha = 1;

    self.dialogTopMenu.duelButton.highlightedLocked = NO;
    self.dialogTopMenu.duelButton.highlighted = NO;
}

#pragma mark - Challenges

- (void)setGameLink:(UPGameLink *)gameLink
{
    BOOL requestValid = gameLink != nil;
    BOOL modeValid = self.mode == Mode::Init || self.mode == Mode::Pause || self.mode == Mode::GameLink || self.mode == Mode::End;
    
    if (requestValid && modeValid) {
        _gameLink = gameLink;
        [self setMode:Mode::GameLink];
    }
    else {
        _gameLink = nil;
    }
}

#pragma mark - Sounds and Tunes

- (void)configureSounds
{
    NSBundle *bundle = [NSBundle mainBundle];
    UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
    [soundPlayer setFilePath:[bundle pathForResource:@"None" ofType:@"aac"] forSoundID:UPSoundIDNone volume:1.0f playerCount:8];
    [soundPlayer setFilePath:[bundle pathForResource:@"Tap" ofType:@"aac"] forSoundID:UPSoundIDTap volume:0.3f playerCount:10];
    [soundPlayer setFilePath:[bundle pathForResource:@"Tub" ofType:@"aac"] forSoundID:UPSoundIDTub volume:0.4f playerCount:12];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-1" ofType:@"aac"] forSoundID:UPSoundIDHappy1 volume:1.0f playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-2" ofType:@"aac"] forSoundID:UPSoundIDHappy2 volume:1.0f playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-3" ofType:@"aac"] forSoundID:UPSoundIDHappy3 volume:0.95f playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Happy-4" ofType:@"aac"] forSoundID:UPSoundIDHappy4 volume:0.85f playerCount:3];
    [soundPlayer setFilePath:[bundle pathForResource:@"Sad-1" ofType:@"aac"] forSoundID:UPSoundIDSad1 volume:0.7f playerCount:2];
    [soundPlayer setFilePath:[bundle pathForResource:@"Sad-2" ofType:@"aac"] forSoundID:UPSoundIDSad2 volume:0.65f playerCount:2];
    [soundPlayer setFilePath:[bundle pathForResource:@"Whoops" ofType:@"aac"] forSoundID:UPSoundIDWhoops volume:0.75f playerCount:3];
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
    if ([self tunesShouldPlay] && self.tunesEnabled) {
        UPTunePlayer *tunePlayer = [UPTunePlayer instance];
        [tunePlayer playTuneID:UPTuneID(self.tuneNumber) segment:UPTuneSegmentIntro properties:{ 1.0, NO, 0, 0, 0 }];
    }
}

- (void)sequenceTuneWithDelay:(CFTimeInterval)delay gameTimeElapsed:(CFTimeInterval)gameTimeElapsed
{
    CFTimeInterval effectiveGameTimeElapsed = UPClampT(CFTimeInterval, gameTimeElapsed, 0, UPGameTimerDefaultDuration);

    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    
    static constexpr CFTimeInterval UPGameTimerCanonicalDuration = 120;
    
    UPTuneID tuneID = UPTuneID(self.tuneNumber);
    
    if ([self tunesShouldPlay] && self.tunesEnabled && UPGameTimerDefaultDuration - effectiveGameTimeElapsed > GameOverOutroDuration) {
        CFTimeInterval tuneBeginTime = delay;
        CFTimeInterval tuneTimeOffset = (UPGameTimerCanonicalDuration - UPGameTimerDefaultDuration) + effectiveGameTimeElapsed;
        [tunePlayer playTuneID:tuneID segment:UPTuneSegmentMain properties:{ 1.0, NO, 0, tuneBeginTime, tuneTimeOffset }];
    }
    
    if (self.soundEffectsEnabled) {
        UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
        float volume = soundPlayer.volume;
        float adjustedVolume = UPClampT(float, volume * 1.6f, 0, 1);
        if (UPGameTimerDefaultDuration - effectiveGameTimeElapsed > 1) {
            CFTimeInterval outroIntervalFromEnd = UPGameTimerDefaultDuration - GameOverOutroDuration;
            CFTimeInterval timeBeforeOutroBegins = UPClampT(CFTimeInterval, outroIntervalFromEnd - effectiveGameTimeElapsed, 0, outroIntervalFromEnd);
            CFTimeInterval outroBeginTime = delay + timeBeforeOutroBegins;
            CFTimeInterval outroTimeOffset = UPMaxT(CFTimeInterval, 0, effectiveGameTimeElapsed - outroIntervalFromEnd);
            [tunePlayer playTuneID:tuneID segment:UPTuneSegmentOutro properties:{ adjustedVolume, YES, 0, outroBeginTime, outroTimeOffset }];
        }
        
        CFTimeInterval gameOverBeginTime = delay + (UPGameTimerDefaultDuration - effectiveGameTimeElapsed);
        [tunePlayer playTuneID:tuneID segment:UPTuneSegmentOver properties:{ volume, YES, 0, gameOverBeginTime, 0 }];
    }
}

- (BOOL)shouldPlayTubSound
{
    CFTimeInterval now = CACurrentMediaTime();
    BOOL result = now - self.tapSoundTimestamp > TapToTubInterval && now - self.tubSoundTimestamp > TubToTubInterval;
    self.tubSoundTimestamp = now;
    return result;
}

- (BOOL)tunesShouldPlay
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL result = ![audioSession isOtherAudioPlaying] && ![audioSession secondaryAudioShouldBeSilencedHint];
    LOG(General, "tunesShouldPlay: %@", result ? @"Y" : @"N");
    return result;
}

#pragma mark - Lifecycle notifications

- (void)configureLifecycleNotifications
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        [self removeInProgressGameFileLogErrors:NO];
        [self viewEnsureUnlocked];
    }];
    
    [nc addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        [self removeInProgressGameFileLogErrors:NO];
    }];
    
    [nc addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        if (self.mode == Mode::Ready) {
            [self setMode:Mode::Init transitionScenario:UPModeTransitionScenarioWillResignActive];
        }
        if (self.mode == Mode::Play) {
            if (self.gameTimer.isRunning) {
                [self setMode:Mode::Pause transitionScenario:UPModeTransitionScenarioWillResignActive];
            }
            else {
                [self setMode:Mode::Init transitionScenario:UPModeTransitionScenarioWillResignActive];
            }
        }
        [self saveInProgressGameIfNecessary];
    }];
    [nc addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification *note) {
        switch (self.mode) {
            case UP::Mode::None:
            case UP::Mode::Init:
            case UP::Mode::Extras:
            case UP::Mode::Pause:
                break;
            case UP::Mode::Play:
                [self setMode:Mode::Pause transitionScenario:UPModeTransitionScenarioDidEnterBackground];
                break;
            case UP::Mode::Ready:
            case UP::Mode::ShareHelp:
            case UP::Mode::DuelHelp:
            case UP::Mode::GameLink:
            case UP::Mode::GameLinkHelp:
            case UP::Mode::GameOver:
            case UP::Mode::Quit:
            case UP::Mode::End:
                [self setMode:Mode::Init transitionScenario:UPModeTransitionScenarioDidEnterBackground];
                break;
        }
    }];
}

#pragma mark - Modes

- (void)configureModeTransitionTables
{
    m_default_transition_table = {
        { Mode::None,          Mode::Init,          @selector(modeTransitionFromNoneToInit) },
        { Mode::None,          Mode::Pause,         @selector(modeTransitionFromNoneToPause) },
        { Mode::Init,          Mode::Extras,        @selector(modeTransitionFromInitToExtras) },
        { Mode::Init,          Mode::GameLink,      @selector(modeTransitionFromInitToGameLink) },
        { Mode::Init,          Mode::Ready,         @selector(modeTransitionFromInitToReady) },
        { Mode::Init,          Mode::DuelHelp,      @selector(modeTransitionFromInitToDuelHelp) },
        { Mode::DuelHelp,      Mode::Init,          @selector(modeTransitionFromDuelHelpToInit) },
        { Mode::Extras,        Mode::Init,          @selector(modeTransitionFromExtrasToInit) },
        { Mode::GameLink,      Mode::Init,          @selector(modeTransitionFromGameLinkToInit) },
        { Mode::GameLink,      Mode::GameLinkHelp,  @selector(modeTransitionFromGameLinkToGameLinkHelp) },
        { Mode::GameLinkHelp,  Mode::GameLink,      @selector(modeTransitionFromGameLinkHelpToGameLink) },
        { Mode::GameLink,      Mode::Ready,         @selector(modeTransitionFromChallengeToReady) },
        { Mode::Ready,         Mode::Play,          @selector(modeTransitionFromReadyToPlay) },
        { Mode::Play,          Mode::Pause,         @selector(modeTransitionFromPlayToPause) },
        { Mode::Play,          Mode::GameOver,      @selector(modeTransitionFromPlayToGameOver) },
        { Mode::Pause,         Mode::GameLink,      @selector(modeTransitionFromPauseToChallenge) },
        { Mode::Pause,         Mode::Play,          @selector(modeTransitionFromPauseToPlay) },
        { Mode::Pause,         Mode::Quit,          @selector(modeTransitionFromPauseToQuit) },
        { Mode::GameOver,      Mode::End,           @selector(modeTransitionFromOverToEnd) },
        { Mode::End,           Mode::GameLink,      @selector(modeTransitionFromEndToGameLink) },
        { Mode::End,           Mode::DuelHelp,      @selector(modeTransitionFromEndToDuelHelp) },
        { Mode::End,           Mode::Extras,        @selector(modeTransitionFromEndToExtras) },
        { Mode::End,           Mode::Ready,         @selector(modeTransitionFromEndToReady) },
        { Mode::End,           Mode::ShareHelp,     @selector(modeTransitionFromEndToShareHelp) },
        { Mode::ShareHelp,     Mode::End,           @selector(modeTransitionFromShareHelpToEnd) },
        { Mode::DuelHelp,      Mode::End,           @selector(modeTransitionFromDuelHelpToEnd) },
        { Mode::Quit,          Mode::End,           @selector(modeTransitionFromQuitToEnd) },
    };
    
    m_did_become_active_transition_table = {
        { Mode::Play,     Mode::Pause,  @selector(modeTransitionImmediateFromPlayToPause) },
    };
    
    m_will_enter_foreground_transition_table = {
        { Mode::Extras,   Mode::Init,   @selector(modeTransitionImmediateFromExtrasToInit) },
    };
    
    m_will_resign_active_transition_table = {
        { Mode::Ready,    Mode::Init,   @selector(modeTransitionImmediateFromReadyToInit) },
        { Mode::Play,     Mode::Init,   @selector(modeTransitionImmediateFromPlayToInit) },
        { Mode::Play,     Mode::Pause,  @selector(modeTransitionImmediateFromPlayToPause) },
    };
    
    m_did_enter_background_transition_table = {
        { Mode::Play,          Mode::Pause, @selector(modeTransitionImmediateFromPlayToPause) },
        { Mode::GameLink,      Mode::Init,  @selector(modeTransitionImmediateFromGameLinkToInit) },
        { Mode::GameLinkHelp,  Mode::Init,  @selector(modeTransitionImmediateFromGameLinkHelpToInit) },
        { Mode::GameOver,      Mode::Init,  @selector(modeTransitionImmediateFromGameOverToInit) },
        { Mode::Quit,          Mode::Init,  @selector(modeTransitionImmediateFromQuitToInit) },
        { Mode::ShareHelp,     Mode::Init,  @selector(modeTransitionImmediateFromShareHelpToInit) },
        { Mode::DuelHelp,      Mode::Init,  @selector(modeTransitionImmediateFromDuelHelpToInit) },
        { Mode::End,           Mode::Init,  @selector(modeTransitionImmediateFromEndToInit) },
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
    SpellLayout &layout = SpellLayout::instance();
    
    self.dialogTopMenu.readyMessagePathView.frame = layout.frame_for(Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);
    
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
    self.dialogPause.alpha = 1;
    
    self.dialogTopMenu.extrasButton.center = layout.center_for(Role::DialogButtonTopLeft, Spot::OffTopNear);
    self.dialogTopMenu.playButton.center = layout.center_for(Role::DialogButtonTopCenter, Spot::OffTopNear);
    self.dialogTopMenu.duelButton.center = layout.center_for(Role::DialogButtonTopRight, Spot::OffTopNear);
    self.dialogTopMenu.readyMessagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray, Spot::OffBottomNear);

    [self viewUnlock];
}

- (void)modeTransitionFromInitToExtras
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewOrderInExtrasWithCompletion:^{
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromInitToGameLink
{
    ASSERT(self.gameLink);
    [self viewOrderInGameLinkFromMode:Mode::Init];
}

- (void)modeTransitionFromEndToGameLink
{
    ASSERT(self.gameLink);
    [self viewOrderInGameLinkFromMode:Mode::End];
}

- (void)modeTransitionFromInitToReady
{
    ASSERT(!m_spell_model);
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewMakeReadyFromMode:Mode::Init completion:^{
        [self viewBloopOutExistingTileViewsWithCompletion:nil];
        [self createGameModelIfNeeded];
        [self setMode:Mode::Play];
    }];
}

- (void)modeTransitionFromExtrasToInit
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter);
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogTopMenu.duelButton, Role::DialogButtonTopRight);
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
            [self viewUnlock];
        }));
    });
}

- (void)modeTransitionFromGameLinkToGameLinkHelp
{
    [self viewLock];
    [self viewOrderInDialogGameLinkHelp];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionFromGameLinkHelpToGameLink
{
    [self viewLock];
    [self viewOrderOutDialogGameLinkHelpWithCompletion:nil];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromGameLinkToInit
{
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromGameLinkHelpToInit
{
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromExtrasToInit
{
    ASSERT(self.lockCount == 0);
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewUnlock];
}

- (void)modeTransitionFromGameLinkToInit
{
    [self viewLock];
    
    [self clearGameModel];

    // This is tricky. If the gameLink wasn't valid, the confirmButton will be hidden.
    Role cancelRole = self.dialogGameLink.confirmButton.hidden ? Role::DialogButtonCenterResponse : Role::DialogButtonAlternativeResponse;
    
    NSArray<UPViewMove *> *buttonOutMoves = @[
        UPViewMoveMake(self.dialogGameLink.titlePromptLabel, Location(Role::GameLinkTitle, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogGameLink.detailPromptLabel, Location(Role::GameLinkDetail, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogGameLink.cancelButton, Location(cancelRole, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogGameLink.confirmButton, Location(Role::DialogButtonDefaultResponse, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogGameLink.helpButton, Location(Role::GameShareButton, Spot::OffBottomFar)),
    ];
    start(bloop_out(BandModeUI, buttonOutMoves, 0.5, nil));
    
    [UIView animateWithDuration:0.4 delay:0.3 options:0 animations:^{
        self.dialogGameLink.alpha = 0;
    } completion:^(BOOL finished) {
        self.dialogGameLink.hidden = YES;
        self.dialogGameLink.alpha = 1;
    }];
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonInit];
    } completion:^(BOOL finished) {
        [self viewUnlock];
    }];
}

- (void)modeTransitionFromChallengeToReady
{
    ASSERT(!m_spell_model);
    ASSERT(self.lockCount == 0);
    [self viewLock];
    
    self.dialogGameLink.confirmButton.highlightedLocked = YES;
    self.dialogGameLink.confirmButton.highlighted = YES;
    
    [self updateSoundAndTunesSettings];
    [self playTuneIntro];
    
    delay(BandModeDelay, 0.1, ^{
        [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonReady];
        } completion:nil];
        
        NSArray<UPViewMove *> *buttonOutMoves = @[
            UPViewMoveMake(self.dialogTopMenu.extrasButton, Location(Role::DialogButtonTopLeft, Spot::OffTopNear)),
            UPViewMoveMake(self.dialogTopMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffTopNear)),
            UPViewMoveMake(self.dialogTopMenu.duelButton, Location(Role::DialogButtonTopRight, Spot::OffTopNear)),
            UPViewMoveMake(self.dialogGameLink.titlePromptLabel, Location(Role::GameLinkTitle, Spot::OffBottomFar)),
            UPViewMoveMake(self.dialogGameLink.detailPromptLabel, Location(Role::GameLinkDetail, Spot::OffBottomFar)),
            UPViewMoveMake(self.dialogGameLink.cancelButton, Location(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar)),
            UPViewMoveMake(self.dialogGameLink.confirmButton, Location(Role::DialogButtonDefaultResponse, Spot::OffBottomFar)),
            UPViewMoveMake(self.dialogGameLink.helpButton, Location(Role::GameShareButton, Spot::OffBottomFar)),
        ];
        start(bloop_out(BandModeUI, buttonOutMoves, 0.5, ^(UIViewAnimatingPosition) {
            self.dialogGameLink.confirmButton.highlightedLocked = NO;
            self.dialogGameLink.confirmButton.highlighted = NO;
            self.dialogGameLink.hidden = YES;
            self.dialogGameLink.alpha = 1;
        }));
        
        delay(BandModeDelay, 0.55, ^{
            [self viewFillUpSpellTileViews];
            [self viewMakeReadyFromMode:Mode::GameLink completion:^{
                [self viewBloopOutExistingTileViewsWithCompletion:nil];
                [self createGameModelIfNeeded];
                [self setMode:Mode::Play];
            }];
        });
    });
}

- (void)modeTransitionFromReadyToPlay
{
    ASSERT(self.lockCount);
    
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }
    
    [self.gameTimer reset];
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::PLAY));
    
    [self sequenceTuneWithDelay:GameStartDelay gameTimeElapsed:0];
    delay(BandModeDelay, GameStartDelay, ^{
        [self.gameTimer start];
    });
    
    UPViewMove *readyMove = UPViewMoveMake(self.dialogTopMenu.readyMessagePathView, Location(Role::DialogMessageCenteredInWordTray, Spot::OffBottomNear));
    start(bloop_out(BandModeUI, @[readyMove], 0.3, nil));
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        self.dialogTopMenu.readyMessagePathView.alpha = 0;
    } completion:^(BOOL finished) {
        self.dialogTopMenu.readyMessagePathView.alpha = 1;
    }];
    delay(BandModeDelay, 0.3, ^{
        [UIView animateWithDuration:0.35 animations:^{
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPlay];
        } completion:nil];
    });
    delay(BandModeDelay, 0.4, ^{
        [self viewEnsureUnlocked];
        [self viewFillPlayerTrayWithCompletion:nil];
        
        UPSpellDossier *dossier = [UPSpellDossier instance];
        if (dossier.totalGamesPlayed == 0 || dossier.highScore == 0) {
            [self viewShowHelpPromptInWordScoreLabel];
        }
    });
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
    [[UPTunePlayer instance] fade];
    [self viewLock];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPause];
    
    // special modal fixups for pause
    self.gameView.pauseControl.highlightedLocked = YES;
    self.gameView.pauseControl.highlighted = YES;
    self.gameView.pauseControl.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.pulseView.alpha = 0;

    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray, Spot::OffBottomFar);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse, Spot::OffBottomFar);
    
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Role::DialogButtonAlternativeResponse),
        UPViewMoveMake(self.dialogPause.resumeButton, Role::DialogButtonDefaultResponse),
    ];
    start(bloop_in(BandModeUI, farMoves, 0.3, nil));
    
    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Role::DialogMessageCenteredInWordTray),
    ];
    start(bloop_in(BandModeUI, nearMoves, 0.35, ^(UIViewAnimatingPosition) {
        [self viewUnlock];
    }));
    
    self.dialogPause.hidden = NO;
    self.dialogPause.alpha = 0;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogPause.alpha = 1;
    }];
}

- (void)modeTransitionImmediateFromReadyToInit
{
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromPlayToInit
{
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromPlayToPause
{
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }

    [self.gameTimer stop];
    pause(BandGameAll);
    [[UPSoundPlayer instance] stop];
    [[UPTunePlayer instance] fade];
    [self viewLock];
    
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonPause];
    
    // special modal fixups for pause
    self.gameView.pauseControl.highlightedLocked = YES;
    self.gameView.pauseControl.highlighted = YES;
    self.gameView.pauseControl.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.pulseView.alpha = 0;

    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageCenteredInWordTray);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse);
    self.dialogPause.hidden = NO;
    self.dialogPause.alpha = 1;
    
    [self viewEnsureUnlocked];
}

- (void)modeTransitionFromPauseToPlay
{
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    }
    
    [self viewLock];
    [[UPSoundPlayer instance] prepare];
    
    [UIView animateWithDuration:0.4 delay:0.3 options:0 animations:^{
        self.dialogPause.alpha = 0;
    } completion:nil];
    
    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Location(Role::DialogMessageCenteredInWordTray, Spot::OffBottomFar)),
    ];
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Location(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogPause.resumeButton, Location(Role::DialogButtonDefaultResponse, Spot::OffBottomFar)),
    ];
    
    start(bloop_out(BandModeUI, farMoves, 0.35, nil));
    
    start(bloop_out(BandModeUI, nearMoves, 0.3, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1;
        
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

- (void)modeTransitionFromPauseToChallenge
{
    [self viewOrderInGameLinkFromMode:Mode::Pause];
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
    [self cancelActiveTouch];
    [[UPSoundPlayer instance] stop];
    [[UPTunePlayer instance] stop];
    
    [self.gameTimer resetTo:0];
    [self viewUpdateGameControls];
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
        self.dialogPause.alpha = 0;
    } completion:nil];
    
    NSArray<UPViewMove *> *nearMoves = @[
        UPViewMoveMake(self.dialogPause.messagePathView, Location(Role::DialogMessageCenteredInWordTray, Spot::OffBottomNear)),
    ];
    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Location(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar)),
        UPViewMoveMake(self.dialogPause.resumeButton, Location(Role::DialogButtonDefaultResponse, Spot::OffBottomFar)),
    ];
    start(bloop_out(BandModeUI, farMoves, 0.35, nil));
    start(bloop_out(BandModeUI, nearMoves, 0.3, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1;
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
    m_spell_model->move_word_tray_tiles_back_to_player_tray();
    m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::OVER));
    
    [self cancelActiveTouch];
    [self viewUnhighlightTileViews];
    [self viewBloopTileViewsToPlayerTrayWithDuration:GameOverRespositionBloopDuration completion:nil];
    [self viewFadeOutWordScoreLabelIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.gameView.wordTrayControl.transform = CGAffineTransformIdentity;
        for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
            tileView.transform = CGAffineTransformIdentity;
        }
    }];
    [self viewPenaltyFinished];
    [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonGameOver];
    
    self.gameView.timerLabel.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.gameScoreLabel.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.pulseView.alpha = 0;

    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.messagePathView.transform = CGAffineTransformIdentity;
    self.dialogGameOver.messagePathView.frame = layout.frame_for(Role::DialogMessageCenteredInWordTray, Spot::OffBottomNear);
    self.dialogGameOver.messagePathView.alpha = 0;
    self.dialogGameOver.noteLabel.frame = layout.frame_for(Role::DialogGameNote, Spot::OffBottomFar);
    self.dialogGameOver.shareButton.frame = layout.frame_for(Role::GameShareButton, Spot::OffBottomFar);
    [self setGameOverViewsHidden:NO];
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogGameOver.messagePathView.alpha = 1;
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
    
    BOOL wasChallenge = m_spell_model->is_challenge();
    BOOL wasDuel = m_spell_model->is_duel();
    [self removeInProgressGameFileLogErrors:NO];
    
    UPSpellDossier *dossier = [UPSpellDossier instance];
    [dossier updateWithModel:m_spell_model];
    [dossier save];
    self.endGameScore = self->m_spell_model->game_score();
    [self clearGameModel];

    delay(BandModeDelay, 1.0, ^{
        SpellLayout &layout = SpellLayout::instance();
        [UIView animateWithDuration:1.0 animations:^{
            // a hack to get the game score label into the right place
            static constexpr CGFloat Scale = 1.5;
            self.gameView.transform = layout.menu_game_view_transform();
            CGAffineTransform transform = CGAffineTransformMakeScale(Scale, Scale);
            self.gameView.gameScoreLabel.transform = transform;
            CGFloat width = layout.width_for_score(self.endGameScore) * Scale;
            CGPoint canvasCenter = up_rect_center(layout.canvas_frame());
            CGPoint labelCenter = self.gameView.gameScoreLabel.center;
            CGRect labelFrame = self.gameView.gameScoreLabel.frame;
            CGFloat labelX = canvasCenter.x - (up_rect_width(labelFrame) * 0.5) + (width * 0.5);
            self.gameView.gameScoreLabel.center = CGPointMake(labelX, labelCenter.y);
            
            self.dialogGameOver.messagePathView.transform = layout.menu_game_view_transform();
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonOverToEnd];
        }];
        
        [self viewBloopOutWordScoreLabelWithDuration:GameOverInOutBloopDuration];
        
        [self viewBloopOutExistingTileViewsWithDuration:GameOverInOutBloopDuration tiles:incoming_tiles wordLength:incoming_word_length
                                             completion:^{
            [self viewBloopInBlankTileViewsWithDuration:GameOverInOutBloopDuration completion:nil];
            self.dialogTopMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Spot::OffTopNear));
            self.dialogTopMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
            self.dialogTopMenu.duelButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Spot::OffTopNear));
            self.dialogTopMenu.playButton.highlightedLocked = NO;
            self.dialogTopMenu.playButton.highlighted = NO;

            Role gameNoteRole = wasChallenge || wasDuel ? Role::DialogTwoLineGameNote : Role::DialogGameNote;
            self.dialogGameOver.noteLabel.frame = layout.frame_for(Location(gameNoteRole, Spot::OffBottomNear));
            self.dialogGameOver.shareButton.frame = layout.frame_for(Location(Role::GameShareButton, Spot::OffBottomNear));
            NSArray<UPViewMove *> *buttonMoves = @[
                UPViewMoveMake(self.dialogTopMenu.extrasButton, Location(Role::DialogButtonTopLeft)),
                UPViewMoveMake(self.dialogTopMenu.playButton, Location(Role::DialogButtonTopCenter)),
                UPViewMoveMake(self.dialogTopMenu.duelButton, Location(Role::DialogButtonTopRight)),
                UPViewMoveMake(self.dialogGameOver.noteLabel, gameNoteRole),
                UPViewMoveMake(self.dialogGameOver.shareButton, Role::GameShareButton),
            ];
            start(bloop_in(BandModeUI, buttonMoves, GameOverInOutBloopDuration, ^(UIViewAnimatingPosition) {
                [self viewUnlock];
            }));
        }];
    });
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
    ASSERT(!m_spell_model);
    [self viewLock];
    [self viewFillUpSpellTileViews];
    [self viewMakeReadyFromMode:Mode::End completion:^{
        [self viewBloopOutExistingTileViewsWithCompletion:nil];
        [self createGameModelIfNeeded];
        [self setMode:Mode::Play];
    }];
}

- (void)modeTransitionFromEndToShareHelp
{
    [self viewOrderInDialogShareHelp];
}

- (void)modeTransitionFromShareHelpToEnd
{
    [self viewOrderOutDialogShareHelpWithCompletion:^{
        [self presentShareSheet];
    }];
}

- (void)modeTransitionFromInitToDuelHelp
{
    [self viewOrderInDialogDuelHelp];
}

- (void)modeTransitionFromEndToDuelHelp
{
    [self viewOrderInDialogDuelHelp];
}

- (void)modeTransitionFromDuelHelpToInit
{
    [self viewOrderOutDialogDuelHelpWithCompletion:^{
        [self presentDuelShareSheet];
    }];
}

- (void)modeTransitionFromDuelHelpToEnd
{
    [self viewOrderOutDialogDuelHelpWithCompletion:^{
        [self presentDuelShareSheet];
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
    [self clearGameModel];
    
    delay(BandModeDelay, 0.35, ^{
        [self viewDumpAllTilesFromCurrentPosition:incoming_tiles wordLength:incoming_word_length];
        SpellLayout &layout = SpellLayout::instance();
        
        [UIView animateWithDuration:1.2 animations:^{
            self.gameView.transform = layout.menu_game_view_transform();
            [self viewSetGameAlphaWithReason:UPSpellGameAlphaStateReasonQuitToEnd];
        } completion:^(BOOL finished) {
            self.dialogTopMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Spot::OffTopNear));
            self.dialogTopMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
            self.dialogTopMenu.duelButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Spot::OffTopNear));
            self.dialogTopMenu.playButton.highlightedLocked = NO;
            self.dialogTopMenu.playButton.highlighted = NO;
            delay(BandModeDelay, 0.1, ^{
                [self.gameTimer reset];
                [self viewUpdateGameControls];
                NSArray<UPViewMove *> *menuButtonMoves = @[
                    UPViewMoveMake(self.dialogTopMenu.extrasButton, Role::DialogButtonTopLeft),
                    UPViewMoveMake(self.dialogTopMenu.playButton, Role::DialogButtonTopCenter),
                    UPViewMoveMake(self.dialogTopMenu.duelButton, Role::DialogButtonTopRight),
                ];
                start(bloop_in(BandModeUI, menuButtonMoves, 0.3, nil));
                
                [self viewBloopInUpSpellTileViewsWithDuration:0.3 completion:^{
                    [self viewUnlock];
                }];
            });
        }];
    });
}

- (void)modeTransitionImmediateFromGameOverToInit
{
    [self viewLock];
    
    if (m_spell_model->back_opcode() != Opcode::END) {
        m_spell_model->apply(Action(0, Opcode::END));
    }
    [self removeInProgressGameFileLogErrors:NO];
    UPSpellDossier *dossier = [UPSpellDossier instance];
    [dossier updateWithModel:m_spell_model];
    [dossier save];
    
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromQuitToInit
{
    [self viewLock];
    
    if (m_spell_model->back_opcode() != Opcode::END) {
        m_spell_model->apply(Action(self.gameTimer.remainingTime, Opcode::END));
    }
    [self removeInProgressGameFileLogErrors:NO];
    UPSpellDossier *dossier = [UPSpellDossier instance];
    [dossier updateWithModel:m_spell_model];
    [dossier save];
    
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromShareHelpToInit
{
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromDuelHelpToInit
{
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

- (void)modeTransitionImmediateFromEndToInit
{
    [self viewLock];
    [self viewImmediateTransitionToInit];
    [self viewEnsureUnlocked];
}

@end
