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
using UP::TimeSpanning::pause_all;
using UP::TimeSpanning::pause;
using UP::TimeSpanning::start_all;
using UP::TimeSpanning::start;

using UP::BandGameAll;
using UP::BandGameDelay;
using UP::BandGameUI;
using UP::BandGameUITile;
using UP::BandModeAll;
using UP::BandModeDelay;
using UP::BandModeUI;

using UP::role_in_player_tray;
using UP::role_in_word;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

@interface UPSpellGameController () <UPGameTimerObserver, UPTileViewGestureDelegate>
@property (nonatomic) UPSpellGameView *gameView;
@property (nonatomic) UPGameTimer *gameTimer;
@property (nonatomic) BOOL showingWordScoreLabel;
@property (nonatomic) UPTileView *pickedView;
@property (nonatomic) TilePosition pickedPosition;
@property (nonatomic) CGPoint panStartPoint;
@property (nonatomic) CGFloat panFurthestDistance;
@property (nonatomic) CGFloat panCurrentDistance;
@property (nonatomic) BOOL panEverMovedUp;
@property (nonatomic) UPDialogGameOver *dialogGameOver;
@property (nonatomic) UPDialogPause *dialogPause;
@property (nonatomic) UPDialogMenu *dialogMenu;
@property (nonatomic) NSInteger userInterfaceLockCount;
@property (nonatomic) SpellModel *model;
@end

@implementation UPSpellGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SpellLayout &layout = SpellLayout::instance();

    self.gameView = [UPSpellGameView instance];
    [self.gameView.wordTrayView addTarget:self action:@selector(wordTrayTapped) forEvents:UPControlEventTouchUpInside];
    [self.gameView.roundGameButtonPause addTarget:self action:@selector(roundButtonPauseTapped:) forEvents:UPControlEventTouchUpInside];
    [self.gameView.roundGameButtonClear addTarget:self action:@selector(roundButtonClearTapped:) forEvents:UPControlEventTouchUpInside];
    [self.view addSubview:self.gameView];

    self.gameTimer = [UPGameTimer defaultGameTimer];
    [self.gameTimer addObserver:self.gameView.timerLabel];
    [self.gameTimer addObserver:self];
    [self.gameTimer notifyObservers];

    self.dialogGameOver = [UPDialogGameOver instance];
    [self.view addSubview:self.dialogGameOver];
    self.dialogGameOver.hidden = YES;
    self.dialogGameOver.frame = layout.screen_bounds();

    self.dialogMenu = [UPDialogMenu instance];
    [self.view addSubview:self.dialogPause];
    [self.dialogPause.quitButton addTarget:self action:@selector(dialogPauseQuitButtonTapped:) forEvents:UPControlEventTouchUpInside];
    [self.dialogPause.resumeButton addTarget:self action:@selector(dialogPauseResumeButtonTapped:) forEvents:UPControlEventTouchUpInside];
    self.dialogPause.hidden = YES;
    self.dialogPause.frame = layout.screen_bounds();

    self.dialogPause = [UPDialogPause instance];
    [self.view addSubview:self.dialogPause];
    [self.dialogPause.quitButton addTarget:self action:@selector(dialogPauseQuitButtonTapped:) forEvents:UPControlEventTouchUpInside];
    [self.dialogPause.resumeButton addTarget:self action:@selector(dialogPauseResumeButtonTapped:) forEvents:UPControlEventTouchUpInside];
    self.dialogPause.hidden = YES;
    self.dialogPause.frame = layout.screen_bounds();

    self.pickedView = nil;
    self.pickedPosition = TilePosition();

    self.mode = UPSpellControllerModeStart;

//    self.mode = UPSpellControllerModeReady;
//    self.mode = UPSpellControllerModePlay;
}

- (void)dealloc
{
    delete self.model;
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
    [self applyActionOver];
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
    [self setMode:UPSpellControllerModeQuit];
}

- (void)dialogPauseResumeButtonTapped:(id)sender
{
    [self setMode:UPSpellControllerModePlay];
}

- (void)roundButtonPauseTapped:(id)sender
{
    [self setMode:UPSpellControllerModePause];
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

- (void)applyActionPlay
{
//    [self applyActionInit];
//    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::PLAY));
//    [self setMode:UPSpellControllerModePlay];
}

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
        cancel(BandGameUITile);
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            Tile &tile = self.model->find_tile(tileView);
            ASSERT(tile.position().in_word_tray());
            [moves addObject:UPViewMoveMake(tileView, role_in_word(tile.position().index(), self.model->word_length()))];
        }
        start(UP::TimeSpanning::slide(BandGameUI, moves, 0.15, nil));
    }
    
    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, role_in_word(word_pos.index(), self.model->word_length()))], 0.3, nil));

    tileView.highlighted = NO;
    [self viewUpdateGameControls];
}

- (void)applyActionRemove:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView);
    ASSERT_POS(self.pickedPosition);

    cancel(BandGameDelay);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REMOVE, tile.position()));

    [self viewSlideWordTrayViewsIntoPlace];

    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, role_for(TileTray::Player, self.model->player_tray_index(tileView)))], 0.3, nil));

    tileView.highlighted = NO;
    [self viewUpdateGameControls];
}

- (void)applyActionMoveTile:(const Tile &)tile toPosition:(const TilePosition &)position
{
    ASSERT(tile.has_view());
    ASSERT(position.in_word_tray());

    cancel(BandGameAll);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::MOVE, tile.position(), position));

    [self viewSlideWordTrayViewsIntoPlace];

    UPTileView *tileView = tile.view();
    tileView.highlighted = NO;
    [self viewUpdateGameControls];
}

- (void)applyActionPick:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView == nil);
    ASSERT_NPOS(self.pickedPosition);

    cancel(BandGameAll);
    [self viewOrderOutWordScoreLabel];

    UPTileView *tileView = tile.view();
    [tileView cancelAnimations];

    self.pickedView = tileView;
    self.pickedPosition = tile.position();

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

    cancel(BandGameDelay);

    TilePosition hover_pos = [self calculateHoverPosition:tile];
    ASSERT_POS(hover_pos);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::HOVER, hover_pos));

    [self viewHover:hover_pos];
}

- (void)applyActionNoverIfNeeded:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView == tile.view());
    ASSERT_POS(self.pickedPosition);

    cancel(BandGameDelay);

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
    ASSERT(self.pickedView == tile.view());
    ASSERT_POS(self.pickedPosition);

    cancel(BandGameDelay);

    UPTileView *tileView = tile.view();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DROP, self.pickedPosition));

    if (self.pickedPosition.in_word_tray()) {
        Location location(role_in_word(self.pickedPosition.index(), self.model->word_length()));
        start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, location)], 0.3, nil));
    }
    else {
        Tile &tile = self.model->find_tile(tileView);
        start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, role_for(TileTray::Player, tile.position().index()))], 0.3, nil));
    }

    tileView.highlighted = NO;

    [self viewUpdateGameControls];
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

    [self viewLockUserInterfaceIncludingPause:NO];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REJECT));

    // assess time penalty and shake word tray side-to-side
    [self viewPenaltyForReject];
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.gameView.wordTrayView];
    [views addObjectsFromArray:[self wordTrayTileViews]];
    start(shake(BandGameUI, views, 0.9, layout.word_tray_shake_offset(), ^(UIViewAnimatingPosition finishedPosition) {
        if (finishedPosition == UIViewAnimatingPositionEnd) {
            delay(BandGameDelay, 0.25, ^{
                [self viewPenaltyFinished];
                delay(BandGameDelay, 0.1, ^{
                    [self applyActionClear];
                    [self viewUnlockUserInterface];
                });
            });
        }
        else {
            [self viewUnlockUserInterface];
        }
    }));
}

- (void)applyActionDump
{
    ASSERT(self.wordTrayTileViews.count == 0);

    cancel(BandGameDelay);
    [self viewOrderOutWordScoreLabel];

    [self viewLockUserInterfaceIncludingPause:NO];

    NSArray *playerTrayTileViews = self.model->player_tray_tile_views();
    ASSERT(playerTrayTileViews.count == TileCount);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [self viewPenaltyForDump];
    [self viewDumpPlayerTray:playerTrayTileViews];
    delay(BandGameDelay, 1.65, ^{
        [self viewFillPlayerTrayWithCompletion:^{
            [self viewUnlockUserInterface];
        }];
        [self viewPenaltyFinished];
    });
}

- (void)applyActionOver
{
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::OVER));
    [self setMode:UPSpellControllerModeGameOver];
}

- (void)applyActionQuit
{
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::QUIT));
    [self setMode:UPSpellControllerModeQuit];
}

#pragma mark - View ops

- (void)viewUpdateGameControls
{
    // word tray
    self.gameView.wordTrayView.active = self.model->word_in_lexicon();
    [self.gameView.wordTrayView setNeedsControlUpdate];
    [self.gameView.wordTrayView controlUpdate];

    // clear button
    if (self.model->word_length()) {
        [self.gameView.roundGameButtonClear setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
    }
    else {
        [self.gameView.roundGameButtonClear setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];
    }
    [self.gameView.roundGameButtonClear setNeedsControlUpdate];
    [self.gameView.roundGameButtonClear controlUpdate];

    self.gameView.gameScoreLabel.string = [NSString stringWithFormat:@"%d", self.model->game_score()];
}

- (void)viewSlideWordTrayViewsIntoPlace
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    cancel(BandGameUITile);
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        Tile &tile = self.model->find_tile(tileView);
        [moves addObject:UPViewMoveMake(tileView, role_in_word(tile.position().index(), self.model->word_length()))];
    }
    start(UP::TimeSpanning::slide(BandGameUI, moves, 0.15, nil));
}

- (void)viewHover:(const TilePosition &)hover_pos
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    size_t word_length = self.pickedPosition.in_word_tray() ? self.model->word_length() : self.model->word_length() + 1;

    if (self.pickedPosition.in_player_tray()) {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            if (idx >= hover_pos.index()) {
                idx++;
            }
            [moves addObject:UPViewMoveMake(tileView, role_in_word(idx, word_length))];
        }
        start(slide(BandGameUI, moves, 0.15, nil));
    }
    else {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            if (idx < self.pickedPosition.index() && hover_pos.index() <= idx) {
                idx++;
            }
            else if (idx > self.pickedPosition.index() && hover_pos.index() >= idx) {
                idx--;
            }
            Location location(role_in_word(idx, word_length));
            [moves addObject:UPViewMoveMake(tileView, location)];
        }
        start(slide(BandGameUI, moves, 0.15, nil));
    }
}

- (void)viewNover
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    size_t word_length = self.pickedPosition.in_word_tray() ? self.model->word_length() - 1 : self.model->word_length();

    if (self.pickedPosition.in_player_tray()) {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            Location location(role_in_word(idx, word_length));
            [moves addObject:UPViewMoveMake(tileView, location)];
        }
        start(slide(BandGameUI, moves, 0.15, nil));
    }
    else {
        NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            if (idx > self.pickedPosition.index()) {
                idx--;
            }
            Location location(role_in_word(idx, word_length));
            [moves addObject:UPViewMoveMake(tileView, location)];
        }
        start(slide(BandGameUI, moves, 0.15, nil));
    }
}

- (void)viewClearWordTray
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    ASSERT(wordTrayTileViews.count > 0);

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
        [tileView clearGestures];
    }

    cancel(BandGameUITile);

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        Tile &tile = self.model->find_tile(tileView);
        ASSERT(tile.position().in_word_tray());
        Location location(role_in_word(tile.position().index(), self.model->word_length()), Spot::OffTopNear);
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
                if (self.showingWordScoreLabel) {
                    UPViewMove *wordScoreOutMove = UPViewMoveMake(self.gameView.wordScoreLabel, Location(role, Spot::OffTopNear));
                    start(bloop_out(BandGameUI, @[wordScoreOutMove], 0.3, ^(UIViewAnimatingPosition) {
                        self.showingWordScoreLabel = NO;
                        self.gameView.wordScoreLabel.hidden = YES;
                    }));
                }
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
            if (self.mode == UPSpellControllerModePlay) {
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
            tileView.band = BandGameUI;
            tileView.gestureDelegate = self;
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
    ASSERT(self.userInterfaceLockCount > 0);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.roundGameButtonClear.highlightedOverride = YES;
    self.gameView.roundGameButtonClear.highlighted = YES;
    self.gameView.wordTrayView.alpha = disabledAlpha;
    self.gameView.tileContainerView.alpha = disabledAlpha;
}

- (void)viewPenaltyForReject
{
    ASSERT(self.userInterfaceLockCount > 0);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.wordTrayView.alpha = disabledAlpha;
    self.gameView.roundGameButtonClear.alpha = disabledAlpha;
    self.gameView.tileContainerView.alpha = disabledAlpha;
}

- (void)viewPenaltyFinished
{
    ASSERT(self.userInterfaceLockCount > 0);
    self.gameView.roundGameButtonClear.highlightedOverride = NO;
    self.gameView.roundGameButtonClear.highlighted = NO;
    self.gameView.roundGameButtonClear.alpha = 1.0;
    self.gameView.wordTrayView.alpha = 1.0;
    self.gameView.tileContainerView.alpha = 1.0;
}

- (void)viewEnterModal
{
    [self viewEnterModal:[UIColor themeModalBackgroundAlpha]];
}

- (void)viewEnterModal:(CGFloat)alpha
{
    self.gameView.timerLabel.alpha = alpha;
    self.gameView.gameScoreLabel.alpha = alpha;
    self.gameView.roundGameButtonPause.alpha = alpha;
    self.gameView.roundGameButtonClear.alpha = alpha;

    self.gameView.wordTrayView.alpha = alpha;
    self.gameView.wordScoreLabel.alpha = alpha;
    self.gameView.tileContainerView.alpha = alpha;

    for (UIView *view in self.gameView.subviews) {
        view.userInteractionEnabled = NO;
    }
}

- (void)viewExitModal
{
    self.gameView.roundGameButtonPause.highlightedOverride = NO;
    self.gameView.roundGameButtonPause.highlighted = NO;
    self.gameView.roundGameButtonPause.alpha = 1.0;
    self.gameView.roundGameButtonClear.alpha = 1.0;
    self.gameView.timerLabel.alpha = 1.0;
    self.gameView.gameScoreLabel.alpha = 1.0;
    self.gameView.wordTrayView.alpha = 1.0;
    self.gameView.wordScoreLabel.alpha = 1.0;
    self.gameView.tileContainerView.alpha = 1.0;

    for (UIView *view in self.gameView.subviews) {
        view.userInteractionEnabled = YES;
    }
}

- (void)viewLockUserInterface
{
    [self viewLockUserInterfaceIncludingPause:YES];
}

- (void)viewLockUserInterfaceIncludingPause:(BOOL)includingPause
{
    self.userInterfaceLockCount++;

    self.dialogMenu.userInteractionEnabled = NO;
    self.dialogPause.userInteractionEnabled = NO;

    UIView *roundButtonPause = self.gameView.roundGameButtonPause;
    for (UIView *view in self.gameView.subviews) {
        if (!includingPause && view == roundButtonPause) {
            continue;
        }
        view.userInteractionEnabled = NO;
    }
}

- (void)viewUnlockUserInterface
{
    ASSERT(self.userInterfaceLockCount > 0);
    self.userInterfaceLockCount = UPMaxT(NSInteger, self.userInterfaceLockCount - 1, 0);
    if (self.userInterfaceLockCount > 0) {
        return;
    }

    self.dialogMenu.userInteractionEnabled = YES;
    self.dialogPause.userInteractionEnabled = YES;

    for (UIView *view in self.gameView.subviews) {
        view.userInteractionEnabled = YES;
    }
}

- (void)modeOpDumpAllTilesFromCurrentPosition
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
            Location location(role_in_player_tray(tile.position()), Spot::OffBottomNear);
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

#pragma mark - Reformed view ops

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

- (void)viewBloopOutTileViewsWithCompletion:(void (^)(void))completion
{
    // move existing tiles offscreen and remove them from view hierarchy
    NSMutableArray<UPViewMove *> *tileMoves = [NSMutableArray array];
    for (const auto &tile : self.model->tiles()) {
        if (tile.has_view()) {
            UPTileView *tileView = tile.view();
            if (tile.in_word_tray()) {
                Role role = role_in_word(tile.position().index(), self.model->word_length());
                [tileMoves addObject:UPViewMoveMake(tileView, role, Spot::OffBottomNear)];
            }
            else {
                [tileMoves addObject:UPViewMoveMake(tileView, role_in_player_tray(tile.position()), Spot::OffBottomNear)];
            }
        }
    }
    start(bloop_out(BandModeUI, tileMoves, 0.3, ^(UIViewAnimatingPosition) {
        [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (completion) {
            completion();
        }
    }));
}

- (void)viewBloopInBlankTileViewsWithCompletion:(void (^)(void))completion
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
    start(bloop_in(BandModeUI, tileInMoves, 0.3, nil));
}

- (void)viewOrderInAboutWithCompletion:(void (^)(void))completion
{
    [self viewLockUserInterface];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffLeftFar));
    UPViewMove *extrasButtonMove = UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft, Spot::OffLeftFar));
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Location(Role::Screen, Spot::OffLeftNear));
    
    CFTimeInterval duration = 0.75;
    
    start(bloop_out(BandModeUI, @[extrasButtonMove], duration, nil));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_out(BandModeUI, @[playButtonMove], duration - 0.1, nil));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_out(BandModeUI, @[gameViewMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.aboutButton.userInteractionEnabled = NO;
            [self viewUnlockUserInterface];
            if (completion) {
                completion();
            }
        }));
    });
}

- (void)viewOrderInExtrasWithCompletion:(void (^)(void))completion
{
    [self viewLockUserInterface];

    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffRightFar));
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight, Spot::OffRightFar));
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Location(Role::Screen, Spot::OffRightNear));

    CFTimeInterval duration = 0.75;

    start(bloop_out(BandModeUI, @[aboutButtonMove], duration, ^(UIViewAnimatingPosition) {
    }));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_out(BandModeUI, @[playButtonMove], duration - 0.1, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_out(BandModeUI, @[gameViewMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.extrasButton.userInteractionEnabled = NO;
            [self viewUnlockUserInterface];
            if (completion) {
                completion();
            }
        }));
    });
}

- (void)viewMakeReadyWithCompletion:(void (^)(void))completion
{
    ASSERT(self.model->is_blank_filled());

    [self viewLockUserInterface];
    
    // lock play button in highlighted state
    self.dialogMenu.playButton.highlightedOverride = YES;
    self.dialogMenu.playButton.highlighted = YES;
    
    // reset game controls
    self.model->reset_game_score();
    [self.gameTimer reset];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    
    delay(BandModeDelay, 0.1, ^{
        [UIView animateWithDuration:0.2 animations:^{
            [self viewEnterModal:[UIColor themeDisabledAlpha]];
        }];
    });
    
    // move extras and about buttons offscreen
    NSArray<UPViewMove *> *outMoves = @[
        UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageCenter, Spot::OffBottomNear),
        UPViewMoveMake(self.dialogGameOver.noteLabel, Role::DialogMessageCenter, Spot::OffBottomFar),
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

#pragma mark - Modes

- (void)setMode:(UPSpellControllerMode)mode
{
    if (_mode == mode) {
        return;
    }
    UPSpellControllerMode prev = _mode;
    
    switch (prev) {
        case UPSpellControllerModeNone: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeStart:
                    [self modeTransitionFromNoneToStart];
                    break;
            }
            break;
        }
        case UPSpellControllerModeStart: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeAttract:
                    [self modeTransitionFromStartToAttract];
                    break;
                case UPSpellControllerModeAbout:
                    [self modeTransitionFromStartToAbout];
                    break;
                case UPSpellControllerModeExtras:
                    [self modeTransitionFromStartToExtras];
                    break;
                case UPSpellControllerModeReady:
                    [self modeTransitionFromStartToReady];
                    break;
            }
            break;
        }
        case UPSpellControllerModeAbout: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeStart:
                    [self modeTransitionFromAboutToStart];
                    break;
            }
            break;
        }
        case UPSpellControllerModeExtras: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeStart:
                    [self modeTransitionFromExtrasToStart];
                    break;
            }
            break;
        }
        case UPSpellControllerModeAttract: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeAbout:
                    [self modeTransitionFromAttractToAbout];
                    break;
                case UPSpellControllerModeExtras:
                    [self modeTransitionFromAttractToExtras];
                    break;
                case UPSpellControllerModeReady:
                    [self modeTransitionFromAttractToReady];
                    break;
            }
            break;
        }
        case UPSpellControllerModeReady: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeQuit:
                case UPSpellControllerModeEnd:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModePlay:
                    [self modeTransitionFromReadyToPlay];
                    break;
            }
            break;
        }
        case UPSpellControllerModePlay: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePlay:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModePause:
                    [self modeTransitionFromPlayToPause];
                    break;
                case UPSpellControllerModeGameOver:
                    [self modeTransitionFromPlayToOver];
                    break;
            }
            break;
        }
        case UPSpellControllerModePause: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModePlay:
                    [self modeTransitionFromPauseToPlay];
                    break;
                case UPSpellControllerModeQuit:
                    [self modeTransitionFromPauseToQuit];
                    break;
            }
            break;
        }
        case UPSpellControllerModeGameOver: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeEnd:
                    [self modeTransitionFromOverToEnd];
                    break;
            }
            break;
        }
        case UPSpellControllerModeEnd: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeAttract:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeReady:
                    [self modeTransitionFromOverToReady];
                    break;
            }
            break;
        }
        case UPSpellControllerModeQuit: {
            switch (mode) {
                case UPSpellControllerModeNone:
                case UPSpellControllerModeStart:
                case UPSpellControllerModeAbout:
                case UPSpellControllerModeExtras:
                case UPSpellControllerModeReady:
                case UPSpellControllerModePlay:
                case UPSpellControllerModePause:
                case UPSpellControllerModeGameOver:
                case UPSpellControllerModeEnd:
                case UPSpellControllerModeQuit:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellControllerModeAttract:
                    [self modeTransitionFromQuitToAttract];
                    break;
            }
            break;
        }
    }

    // Change the mode
    _mode = mode;
}

- (void)modeTransitionFromNoneToStart
{
    [self createNewGameModel];
    
    SpellLayout &layout = SpellLayout::instance();

    self.dialogMenu.transform = CGAffineTransformIdentity;
    self.dialogMenu.hidden = NO;
    self.dialogMenu.alpha = 1.0;
    self.dialogMenu.messagePathView.frame = layout.frame_for(Role::DialogMessageCenter, Spot::OffBottomNear);

    self.gameView.transform = layout.menu_game_view_transform();
    [self viewUpdateGameControls];
    [self viewFillBlankTileViews];
    [self viewEnterModal:[UIColor themeDisabledAlpha]];
}

- (void)modeTransitionFromStartToAttract
{
    ASSERT_NOT_REACHED();
}

- (void)modeTransitionFromStartToAbout
{
    [self viewOrderInAboutWithCompletion:nil];
}

- (void)modeTransitionFromStartToExtras
{
    [self viewOrderInExtrasWithCompletion:nil];
}

- (void)modeTransitionFromStartToReady
{
    ASSERT(self.model->is_blank_filled());
    
    [self viewMakeReadyWithCompletion:^{
        [self viewBloopOutTileViewsWithCompletion:nil];
        self.mode = UPSpellControllerModePlay;
    }];
}

- (void)modeTransitionFromAboutToStart
{
    [self viewLockUserInterface];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Role::DialogButtonTopCenter);
    UPViewMove *extrasButtonMove = UPViewMoveMake(self.dialogMenu.extrasButton, Role::DialogButtonTopLeft);
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Role::Screen);
    
    CFTimeInterval duration = 0.75;
    
    start(bloop_in(BandModeUI, @[extrasButtonMove], duration, ^(UIViewAnimatingPosition) {
    }));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_in(BandModeUI, @[playButtonMove], duration - 0.1, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_in(BandModeUI, @[gameViewMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.aboutButton.userInteractionEnabled = YES;
            [self viewUnlockUserInterface];
        }));
    });
}

- (void)modeTransitionFromExtrasToStart
{
    [self viewLockUserInterface];
    
    UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Role::DialogButtonTopCenter);
    UPViewMove *aboutButtonMove = UPViewMoveMake(self.dialogMenu.aboutButton, Role::DialogButtonTopRight);
    UPViewMove *gameViewMove = UPViewMoveMake(self.gameView, Role::Screen);
    
    CFTimeInterval duration = 0.75;
    
    start(bloop_in(BandModeUI, @[aboutButtonMove], duration, ^(UIViewAnimatingPosition) {
    }));
    delay(BandModeDelay, 0.1, ^{
        start(bloop_in(BandModeUI, @[playButtonMove], duration - 0.1, ^(UIViewAnimatingPosition) {
        }));
    });
    delay(BandModeDelay, 0.2, ^{
        start(bloop_in(BandModeUI, @[gameViewMove], duration - 0.2, ^(UIViewAnimatingPosition) {
            self.dialogMenu.extrasButton.userInteractionEnabled = YES;
            [self viewUnlockUserInterface];
        }));
    });
}

- (void)modeTransitionFromAttractToAbout
{
    [self viewOrderInAboutWithCompletion:^{
        // FIXME: clean up after attract, return game view to start
    }];
}

- (void)modeTransitionFromAttractToExtras
{
    [self viewOrderInExtrasWithCompletion:^{
        // FIXME: clean up after attract, return game view to start
    }];
}

- (void)modeTransitionFromAttractToReady
{
    [self viewBloopOutTileViewsWithCompletion:^{
        [self createNewGameModel];
        [self viewBloopInBlankTileViewsWithCompletion:^{
            [self viewMakeReadyWithCompletion:^{
                [self viewBloopOutTileViewsWithCompletion:nil];
                self.mode = UPSpellControllerModePlay;
            }];
        }];
    }];
}

- (void)modeTransitionFromReadyToPlay
{
    self.model->apply(Action(Opcode::PLAY));
    
    // bloop out ready message
    UPViewMove *readyMove = UPViewMoveMake(self.dialogMenu.messagePathView, Location(Role::DialogMessageHigh, Spot::OffBottomNear));
    start(bloop_out(BandModeUI, @[readyMove], 0.3, nil));
    // animate game view to full alpha and fade out dialog menu
    [UIView animateWithDuration:0.1 delay:0.1 options:0 animations:^{
        [self viewExitModal];
        self.dialogMenu.alpha = 0.0;
    } completion:^(BOOL finished) {
        // animate game view to full alpha and restore alpha of dialog menu
        self.dialogMenu.alpha = 1.0;
        self.dialogMenu.hidden = YES;
        self.dialogGameOver.alpha = 1.0;
        self.dialogGameOver.hidden = YES;
        delay(BandModeDelay, 0.1, ^{
            // create new game model and start game
            [self viewFillPlayerTrayWithCompletion:^{
                delay(BandModeDelay, 0.1, ^{
                    // start game
                    [self.gameTimer start];
                    [self viewUnlockUserInterface];
                });
            }];
        });
    }];
}

- (void)modeTransitionFromPlayToPause
{
    [self.gameTimer stop];
    pause(BandGameAll);
    [self viewLockUserInterface];
    [self viewEnterModal];

    // special modal fixups for pause
    self.gameView.roundGameButtonPause.highlightedOverride = YES;
    self.gameView.roundGameButtonPause.highlighted = YES;
    self.gameView.roundGameButtonPause.alpha = [UIColor themeModalActiveAlpha];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.messagePathView.center = layout.center_for(Role::DialogMessageHigh, Spot::OffBottomNear);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse, Spot::OffBottomFar);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse, Spot::OffBottomFar);

    NSArray<UPViewMove *> *farMoves = @[
        UPViewMoveMake(self.dialogPause.quitButton, Role::DialogButtonAlternativeResponse),
        UPViewMoveMake(self.dialogPause.resumeButton, Role::DialogButtonDefaultResponse),
    ];
    start(bloop_in(BandModeUI, farMoves, 0.3, ^(UIViewAnimatingPosition) {
        [self viewUnlockUserInterface];
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

- (void)modeTransitionFromPauseToPlay
{
    [self viewLockUserInterface];

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

    start(bloop_out(BandModeUI, nearMoves, 0.3, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            [self viewExitModal];
        } completion:^(BOOL finished) {
            [self.gameTimer start];
            start(BandGameDelay);
            start(BandGameUI);
            self.gameView.roundGameButtonPause.highlightedOverride = NO;
            self.gameView.roundGameButtonPause.highlighted = NO;
            [self viewUnlockUserInterface];
        }];
    }));
}

- (void)modeTransitionFromPauseToQuit
{
    [self viewLockUserInterface];

    cancel(BandGameDelay);
    cancel(BandGameUI);
    [self.gameTimer cancel];
    [self viewOrderOutWordScoreLabel];
    [self viewUpdateGameControls];
    
    [self.gameView.roundGameButtonPause setStrokeColorAnimationDuration:0.3 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self.gameView.roundGameButtonPause setStrokeColorAnimationDuration:0.3 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    self.gameView.roundGameButtonPause.highlightedOverride = NO;
    self.gameView.roundGameButtonPause.highlighted = NO;
    self.gameView.roundGameButtonPause.alpha = [UIColor themeModalBackgroundAlpha];
    [self.gameView.roundGameButtonPause setStrokeColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self.gameView.roundGameButtonPause setStrokeColorAnimationDuration:0 fromState:UPControlStateHighlighted toState:UPControlStateNormal];

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
    start(bloop_out(BandModeUI, farMoves, 0.3, nil));
    start(bloop_out(BandModeUI, nearMoves, 0.35, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        delay(BandModeDelay, 0.35, ^{
            [self setMode:UPSpellControllerModeAttract];
        });
    }));
}

- (void)modeTransitionFromPlayToOver
{
    pause(BandGameAll);
    cancel(BandGameAll);
    [self viewLockUserInterface];
    [self viewEnterModal:[UIColor themeModalGameOverAlpha]];
    self.gameView.timerLabel.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.gameScoreLabel.alpha = [UIColor themeModalActiveAlpha];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.messagePathView.center = layout.center_for(Role::DialogMessageHigh, Spot::OffBottomNear);
    self.dialogGameOver.noteLabel.center = layout.center_for(Role::DialogNote, Spot::OffBottomNear);

    self.dialogGameOver.hidden = NO;
    self.dialogGameOver.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogGameOver.alpha = 1.0;
    }];

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogGameOver.messagePathView, Role::DialogMessageHigh),
    ];
    start(bloop_in(BandModeUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        delay(BandModeUI, 1.75, ^{
            [self setMode:UPSpellControllerModeEnd];
        });
    }));
}

- (void)modeTransitionFromOverToEnd
{
    [self viewBloopOutTileViewsWithCompletion:^{
        self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::END));
        [self viewBloopInBlankTileViewsWithCompletion:nil];
    }];
    
    SpellLayout &layout = SpellLayout::instance();
    [UIView animateWithDuration:1.0 animations:^{
        self.dialogGameOver.transform = layout.menu_game_view_transform();
        self.gameView.transform = layout.menu_game_view_transform();
        [self viewEnterModal:[UIColor themeModalBackgroundAlpha]];
    }];
    self.gameView.timerLabel.alpha = [UIColor themeModalActiveAlpha];
    self.gameView.gameScoreLabel.alpha = [UIColor themeModalActiveAlpha];

    delay(BandModeDelay, 0.5, ^{
        self.dialogMenu.hidden = NO;
        self.dialogMenu.alpha = 1;
        self.dialogMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Spot::OffTopNear));
        self.dialogMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
        self.dialogMenu.aboutButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Spot::OffTopNear));
        self.dialogMenu.playButton.highlightedOverride = NO;
        self.dialogMenu.playButton.highlighted = NO;
        NSArray<UPViewMove *> *buttonMoves = @[
            UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft)),
            UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter)),
            UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight)),
            UPViewMoveMake(self.dialogGameOver.noteLabel, Role::DialogNote),
        ];
        start(bloop_in(BandModeUI, buttonMoves, 0.5, ^(UIViewAnimatingPosition) {
            [self viewUnlockUserInterface];
        }));
    });
}

- (void)modeTransitionFromOverToReady
{
    [self createNewGameModel];
    [self viewFillBlankTileViews];
    [self viewMakeReadyWithCompletion:^{
        [self viewBloopOutTileViewsWithCompletion:nil];
        self.mode = UPSpellControllerModePlay;
    }];
}

- (void)modeTransitionFromOverToAttract
{
}

- (void)modeTransitionFromQuitToAttract
{
    [self modeOpDumpAllTilesFromCurrentPosition];

    SpellLayout &layout = SpellLayout::instance();

    [UIView animateWithDuration:1.5 animations:^{
        self.gameView.transform = layout.menu_game_view_transform();
        [self viewEnterModal:[UIColor themeDisabledAlpha]];
    } completion:^(BOOL finished) {
        self.dialogMenu.hidden = NO;
        self.dialogMenu.alpha = 1;
        self.dialogMenu.extrasButton.frame = layout.frame_for(Location(Role::DialogButtonTopLeft, Spot::OffTopNear));
        self.dialogMenu.playButton.frame = layout.frame_for(Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
        self.dialogMenu.aboutButton.frame = layout.frame_for(Location(Role::DialogButtonTopRight, Spot::OffTopNear));
        self.dialogMenu.playButton.highlightedOverride = NO;
        self.dialogMenu.playButton.highlighted = NO;
        delay(BandModeDelay, 0.4, ^{
            NSArray<UPViewMove *> *menuButtonMoves = @[
                UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft)),
                UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter)),
                UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight)),
            ];
            start(bloop_in(BandModeUI, menuButtonMoves, 0.25, nil));
            [self viewFillPlayerTrayWithCompletion:^{
                [self viewUnlockUserInterface];
            }];
        });
    }];
}

@end
