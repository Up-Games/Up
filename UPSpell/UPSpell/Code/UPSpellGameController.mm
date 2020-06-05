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
#import "UPSpellModel.h"
#import "UPSpellLayout.h"
#import "UPTileModel.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "UPSpellGameController.h"
#import "UPViewMove+UPSpell.h"

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

using UP::role_for;
using UP::role_in_word;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

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
@property (nonatomic) UPDialogMenu *dialogMenu;
@property (nonatomic) UPDialogPause *dialogPause;
@property (nonatomic) NSInteger userInterfaceLockCount;
@property (nonatomic) SpellModel *model;
@end

@implementation UPSpellGameController

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);
    //LOG_CHANNEL_ON(Gestures);
    //LOG_CHANNEL_ON(Layout);
    //LOG_CHANNEL_ON(Leaks);
    //LOG_CHANNEL_ON(Mode);

    [super viewDidLoad];

    UP::TimeSpanning::init();
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
    [self.gameTimer addObserver:self.gameView.timerLabel];
    [self.gameTimer addObserver:self];
    [self.gameTimer notifyObservers];

    self.dialogGameOver = [UPDialogGameOver instance];
    [self.view addSubview:self.dialogGameOver];
//    [self.dialogPause.quitButton addTarget:self action:@selector(dialogPauseQuitButtonTapped:) forEvents:UPControlEventTouchUpInside];
//    [self.dialogPause.resumeButton addTarget:self action:@selector(dialogPauseResumeButtonTapped:) forEvents:UPControlEventTouchUpInside];
    self.dialogGameOver.hidden = YES;
    self.dialogGameOver.frame = layout.screen_bounds();

    self.dialogMenu = [UPDialogMenu instance];
    [self.view addSubview:self.dialogMenu];
    [self.dialogMenu.playButton addTarget:self action:@selector(dialogMenuPlayButtonTapped:) forEvents:UPControlEventTouchUpInside];
//    [self.dialogPause.resumeButton addTarget:self action:@selector(dialogPauseResumeButtonTapped:) forEvents:UPControlEventTouchUpInside];
    self.dialogMenu.hidden = YES;
    self.dialogMenu.frame = layout.screen_bounds();

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

    delay(BandGameDelay, 0.2, ^{
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

- (void)dialogMenuPlayButtonTapped:(id)sender
{
    [self setMode:UPSpellGameModeCountdown animated:YES];
}

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
            Location location(role_in_word(tile.position().index(), self.model->word_length()));
            [moves addObject:UPViewMoveMake(tileView, location)];
        }
        start(UP::TimeSpanning::slide(BandGameUI, moves, 0.15, nil));
    }
    
    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    Location location(role_in_word(word_pos.index(), self.model->word_length()), Spot::Default);
    start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, location)], 0.3, nil));

    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionRemove:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView);
    ASSERT_POS(self.pickedPosition);

    cancel(BandGameDelay);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REMOVE, tile.position()));

    [self viewOpSlideWordTrayViewsIntoPlace];

    UPTileView *tileView = tile.view();
    [self.gameView.tileContainerView bringSubviewToFront:tileView];
    Location location(role_for(TileTray::Player, self.model->player_tray_index(tileView)));
    start(bloop_in(BandGameUI, @[UPViewMoveMake(tileView, location)], 0.3, nil));

    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionMoveTile:(const Tile &)tile toPosition:(const TilePosition &)position
{
    ASSERT(tile.has_view());
    ASSERT(position.in_word_tray());

    cancel(BandGameAll);

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

    cancel(BandGameAll);

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

    [self viewOpHover:hover_pos];
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

    [self viewOpNover];
    [self viewOpUpdateGameControls];
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
        start(UP::TimeSpanning::bloop_in(BandGameUI, @[UPViewMoveMake(tileView, location)], 0.3, nil));
    }
    else {
        Tile &tile = self.model->find_tile(tileView);
        Location location(role_for(TileTray::Player, tile.position().index()));
        start(UP::TimeSpanning::bloop_in(BandGameUI, @[UPViewMoveMake(tileView, location)], 0.3, nil));
    }

    tileView.highlighted = NO;

    [self viewOpUpdateGameControls];
}

- (void)applyActionClear
{
    cancel(BandGameDelay);
    cancel(BandGameUI);

    [self viewOpClearWordTray];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::CLEAR));
    [self viewOpUpdateGameControls];
}

- (void)applyActionSubmit
{
    cancel(BandGameDelay);

    [self viewOpSubmitWord];
    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::SUBMIT));
    delay(BandGameDelay, 0.25, ^{
        [self viewOpFillPlayerTray];
        [self viewOpUpdateGameControls];
    });
}

- (void)applyActionReject
{
    cancel(BandGameDelay);

    [self viewOpLockUserInterfaceIncludingPause:NO];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REJECT));

    // assess time penalty and shake word tray side-to-side
    [self viewOpPenaltyForReject:self.model->all_tile_views()];
    SpellLayout &layout = SpellLayout::instance();
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.gameView.wordTrayView];
    [views addObjectsFromArray:[self wordTrayTileViews]];
    start(shake(BandGameUI, views, 0.9, layout.word_tray_shake_offset(), ^(UIViewAnimatingPosition finishedPosition) {
        if (finishedPosition == UIViewAnimatingPositionEnd) {
            delay(BandGameDelay, 0.25, ^{
                [self viewOpPenaltyFinished];
                delay(BandGameDelay, 0.1, ^{
                    [self applyActionClear];
                    [self viewOpUnlockUserInterface];
                });
            });
        }
        else {
            [self viewOpUnlockUserInterface];
        }
    }));
}

- (void)applyActionDump
{
    ASSERT(self.wordTrayTileViews.count == 0);

    cancel(BandGameDelay);

    [self viewOpLockUserInterfaceIncludingPause:NO];

    NSArray *playerTrayTileViews = self.model->player_tray_tile_views();
    ASSERT(playerTrayTileViews.count == TileCount);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [self viewOpPenaltyForDump];
    [self viewOpDumpPlayerTray:playerTrayTileViews];
    delay(BandGameDelay, 1.65, ^{
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

- (void)viewOpSlideWordTrayViewsIntoPlace
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    cancel(BandGameUITile);
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        Tile &tile = self.model->find_tile(tileView);
        Location location(role_in_word(tile.position().index(), self.model->word_length()));
        [moves addObject:UPViewMoveMake(tileView, location)];
    }
    start(UP::TimeSpanning::slide(BandGameUI, moves, 0.15, nil));
}

- (void)viewOpHover:(const TilePosition &)hover_pos
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

- (void)viewOpNover
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

- (void)viewOpClearWordTray
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    ASSERT(wordTrayTileViews.count > 0);

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in wordTrayTileViews) {
        TileIndex idx = self.model->player_tray_index(tileView);
        [moves addObject:UPViewMoveMake(tileView, Location(role_for(TileTray::Player, idx)))];
    }
    start(UP::TimeSpanning::bloop_in(BandGameUI, moves, 0.3, nil));
}

- (void)viewOpSubmitWord
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
    start(UP::TimeSpanning::bloop_out(BandGameUI, moves, 0.3, nil));
}

- (void)viewOpDumpPlayerTray:(NSArray *)playerTrayTileViews
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
        Location location(role_for(TilePosition(TileTray::Player, idx)), Spot::OffBottomNear);
        UPAnimator *animator = slide(BandGameUI, @[UPViewMoveMake(tileView, location)], 1.1, ^(UIViewAnimatingPosition) {
            [tileView removeFromSuperview];
        });
        delay(BandGameDelay, count * baseDelay, ^{
            if (self.mode == UPSpellGameModePlay) {
                start(animator);
            }
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

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        if (tile.has_view<false>()) {
            const TileModel &model = tile.model();
            UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
            tile.set_view(tileView);
            tileView.band = BandGameUI;
            tileView.gestureDelegate = self;
            Role role = role_for(TilePosition(TileTray::Player, idx));
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

    if (postFillOp) {
        postFillOp();
    }
}

- (void)viewOpPenaltyForDump
{
    ASSERT(self.userInterfaceLockCount > 0);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.roundButtonTrash.highlightedOverride = YES;
    self.gameView.roundButtonTrash.highlighted = YES;
    self.gameView.wordTrayView.alpha = disabledAlpha;
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyForReject:(NSArray *)tileViews
{
    ASSERT(self.userInterfaceLockCount > 0);
    const CGFloat disabledAlpha = [UIColor themeDisabledAlpha];
    self.gameView.wordTrayView.alpha = disabledAlpha;
    self.gameView.roundButtonClear.alpha = disabledAlpha;
    for (UPTileView *tileView in tileViews) {
        tileView.alpha = disabledAlpha;
    }
}

- (void)viewOpPenaltyFinished
{
    ASSERT(self.userInterfaceLockCount > 0);
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
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        tileView.alpha = 1.0;
    }
}

- (void)viewOpEnterModal:(UPSpellGameMode)mode
{
    CGFloat alpha = [UIColor themeModalBackgroundAlpha];
    switch (mode) {
        case UPSpellGameModeStart:
        case UPSpellGameModeOffscreenLeft:
        case UPSpellGameModeOffscreenRight:
        case UPSpellGameModeMenu:
        case UPSpellGameModeCountdown:
        case UPSpellGameModePlay:
        case UPSpellGameModePause:
        case UPSpellGameModeOver:
            // no-op
            break;
        case UPSpellGameModeOverInterstitial:
            alpha = [UIColor themeModalInterstitialAlpha];
            break;
    }
    if (mode == UPSpellGameModePause) {
        self.gameView.roundButtonPause.highlightedOverride = YES;
        self.gameView.roundButtonPause.highlighted = YES;
        self.gameView.roundButtonPause.alpha = [UIColor themeModalActiveAlpha];
        self.gameView.timerLabel.alpha = alpha;
        self.gameView.scoreLabel.alpha = alpha;
    }
    else if (mode == UPSpellGameModeOverInterstitial || mode == UPSpellGameModeOver) {
        self.gameView.roundButtonPause.alpha = alpha;
    }
    else {
        self.gameView.timerLabel.alpha = alpha;
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

    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
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
    self.gameView.timerLabel.alpha = 1.0;
    self.gameView.scoreLabel.alpha = 1.0;

    self.gameView.wordTrayView.userInteractionEnabled = YES;
    self.gameView.roundButtonTrash.userInteractionEnabled = YES;
    self.gameView.roundButtonClear.userInteractionEnabled = YES;
    self.gameView.roundButtonPause.userInteractionEnabled = YES;

    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        tileView.alpha = 1.0;
        tileView.userInteractionEnabled = YES;
    }
}

- (void)viewOpLockUserInterface
{
    [self viewOpLockUserInterfaceIncludingPause:YES];
}

- (void)viewOpLockUserInterfaceIncludingPause:(BOOL)includingPause
{
    self.userInterfaceLockCount++;

    self.dialogGameOver.menuButton.userInteractionEnabled = NO;
    self.dialogGameOver.playButton.userInteractionEnabled = NO;

    self.dialogMenu.extrasButton.userInteractionEnabled = NO;
    self.dialogMenu.playButton.userInteractionEnabled = NO;
    self.dialogMenu.aboutButton.userInteractionEnabled = NO;

    self.dialogPause.resumeButton.userInteractionEnabled = NO;
    self.dialogPause.quitButton.userInteractionEnabled = NO;

    UIView *roundButtonPause = self.gameView.roundButtonPause;
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

- (void)viewOpUnlockUserInterface
{
    ASSERT(self.userInterfaceLockCount > 0);
    self.userInterfaceLockCount = UPMaxT(NSInteger, self.userInterfaceLockCount - 1, 0);
    if (self.userInterfaceLockCount > 0) {
        return;
    }

    self.dialogGameOver.menuButton.userInteractionEnabled = YES;
    self.dialogGameOver.playButton.userInteractionEnabled = YES;

    self.dialogMenu.extrasButton.userInteractionEnabled = YES;
    self.dialogMenu.playButton.userInteractionEnabled = YES;
    self.dialogMenu.aboutButton.userInteractionEnabled = YES;

    self.dialogPause.resumeButton.userInteractionEnabled = YES;
    self.dialogPause.quitButton.userInteractionEnabled = YES;

    for (UIView *view in self.gameView.subviews) {
        view.userInteractionEnabled = YES;
    }
    for (UPTileView *tileView in self.gameView.tileContainerView.subviews) {
        tileView.userInteractionEnabled = YES;
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
                case UPSpellGameModePause:
                case UPSpellGameModeOverInterstitial:
                case UPSpellGameModeOver:
                    ASSERT_NOT_REACHED();
                    break;
                case UPSpellGameModePlay:
                    [self modeTransitionFromCountdownToPlay:animated];
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
    SpellLayout &layout = SpellLayout::instance();

    self.dialogMenu.transform = CGAffineTransformIdentity;
    self.dialogMenu.hidden = NO;
    self.dialogMenu.alpha = 1.0;
    self.dialogMenu.titlePathView.frame = layout.frame_for(Role::DialogMessageCenter, Spot::OffBottomNear);

    self.gameView.transform = layout.menu_game_view_transform();
    self.gameView.alpha = [UIColor themeDisabledAlpha];
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
    [self viewOpLockUserInterface];
    
    self.dialogMenu.playButton.highlightedOverride = YES;
    self.dialogMenu.playButton.highlighted = YES;

    NSArray<UPViewMove *> *extrasAndAboutMoves = @[
        UPViewMoveMake(self.dialogMenu.extrasButton, Location(Role::DialogButtonTopLeft, Spot::OffTopNear)),
        UPViewMoveMake(self.dialogMenu.aboutButton, Location(Role::DialogButtonTopRight, Spot::OffTopNear)),
    ];
    start(bloop_out(BandModeUI, extrasAndAboutMoves, 0.3, ^(UIViewAnimatingPosition) {
        delay(BandModeDelay, 0.4, ^{
            [self.gameTimer reset];
            UPViewMove *playButtonMove = UPViewMoveMake(self.dialogMenu.playButton, Location(Role::DialogButtonTopCenter, Spot::OffTopNear));
            UPViewMove *readyMove = UPViewMoveMake(self.dialogMenu.titlePathView, Location(Role::DialogMessageCenter));
            start(slide(BandModeUI, @[playButtonMove], 0.3, nil));
            delay(BandModeDelay, 0.6, ^{
                start(bloop_in(BandModeUI, @[readyMove], 0.3, nil));
            });
            [UIView animateWithDuration:0.9 animations:^{
                self.gameView.transform = CGAffineTransformIdentity;
                [self viewOpEnterModal:UPSpellGameModeCountdown];
            } completion:^(BOOL finished) {
                [self viewOpUnlockUserInterface];
                [self setMode:UPSpellGameModePlay animated:YES];
            }];
        });
    }));
}

- (void)modeTransitionFromCountdownToPause:(BOOL)animated
{
}

- (void)modeTransitionFromPauseToCountdown:(BOOL)animated
{
}

- (void)modeTransitionFromCountdownToPlay:(BOOL)animated
{
    delay(BandModeDelay, 1.5, ^{
        UPViewMove *readyMove = UPViewMoveMake(self.dialogMenu.titlePathView, Location(Role::DialogMessageCenter, Spot::OffBottomNear));
        start(bloop_out(BandModeUI, @[readyMove], 0.3, nil));
        [UIView animateWithDuration:0.1 delay:0.2 options:0 animations:^{
            [self viewOpExitModal];
        } completion:^(BOOL finished) {
            self.gameView.alpha = 1.0;
            self.dialogMenu.alpha = 1.0;
            self.dialogMenu.hidden = YES;
            delay(BandModeDelay, 0.1, ^{
                [self.gameTimer start];
            });
        }];
    });
}

- (void)modeTransitionFromPlayToPause:(BOOL)animated
{
    [self.gameTimer stop];
    pause(BandGameAll);
    [self viewOpLockUserInterface];
    [self viewOpEnterModal:UPSpellGameModePause];
    
    SpellLayout &layout = SpellLayout::instance();
    self.dialogPause.titlePathView.center = layout.center_for(Role::DialogMessageHigh, Spot::OffBottomNear);
    self.dialogPause.quitButton.center = layout.center_for(Role::DialogButtonAlternativeResponse, Spot::OffBottomNear);
    self.dialogPause.resumeButton.center = layout.center_for(Role::DialogButtonDefaultResponse, Spot::OffBottomNear);

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogPause.titlePathView, Role::DialogMessageHigh),
        UPViewMoveMake(self.dialogPause.quitButton, Role::DialogButtonAlternativeResponse),
        UPViewMoveMake(self.dialogPause.resumeButton, Role::DialogButtonDefaultResponse),
    ];
    start(bloop_in(BandModeUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        [self viewOpUnlockUserInterface];
    }));

    self.dialogPause.hidden = NO;
    self.dialogPause.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogPause.alpha = 1.0;
    }];
}

- (void)modeTransitionFromPauseToPlay:(BOOL)animated
{
    [self viewOpLockUserInterface];

    [UIView animateWithDuration:0.15 delay:0.15 options:0 animations:^{
        self.dialogPause.alpha = 0.0;
    } completion:nil];

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogPause.titlePathView, Location(Role::DialogMessageHigh, Spot::OffBottomNear)),
        UPViewMoveMake(self.dialogPause.quitButton, Location(Role::DialogButtonAlternativeResponse, Spot::OffBottomNear)),
        UPViewMoveMake(self.dialogPause.resumeButton, Location(Role::DialogButtonDefaultResponse, Spot::OffBottomNear)),
    ];
    start(bloop_out(BandModeUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        self.dialogPause.hidden = YES;
        self.dialogPause.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            [self viewOpExitModal];
        } completion:^(BOOL finished) {
            [self.gameTimer start];
            start(BandGameDelay);
            start(BandGameUI);
            self.gameView.roundButtonPause.highlightedOverride = NO;
            self.gameView.roundButtonPause.highlighted = NO;
            [self viewOpUnlockUserInterface];
        }];
    }));
}

- (void)modeTransitionFromPauseToMenu:(BOOL)animated
{
}

- (void)modeTransitionFromPlayToOverInterstitial:(BOOL)animated
{
    pause(BandGameAll);
    cancel(BandGameAll);
    [self viewOpLockUserInterfaceIncludingPause:YES];
    [self viewOpEnterModal:UPSpellGameModeOverInterstitial];

    SpellLayout &layout = SpellLayout::instance();
    self.dialogGameOver.titlePathView.center = layout.center_for(Role::DialogMessageCenter, Spot::OffBottomNear);
    self.dialogGameOver.menuButton.center = layout.center_for(Role::DialogButtonTopLeft, Spot::OffTopNear);
    self.dialogGameOver.playButton.center = layout.center_for(Role::DialogButtonTopRight, Spot::OffTopNear);
    self.dialogGameOver.noteLabel.center = layout.center_for(Role::DialogNote, Spot::OffBottomNear);

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.dialogGameOver.titlePathView, Role::DialogMessageCenter),
    ];
    start(bloop_in(BandModeUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        delay(BandModeUI, 1.75, ^{
            [self setMode:UPSpellGameModeOver animated:YES];
        });
    }));
    
    self.dialogGameOver.hidden = NO;
    self.dialogGameOver.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.dialogGameOver.alpha = 1.0;
    }];
}

- (void)modeTransitionFromOverInterstitialToOver:(BOOL)animated
{
    [self viewOpUnlockUserInterface];

    NSArray<UPViewMove *> *buttonMoves = @[
        UPViewMoveMake(self.dialogGameOver.menuButton, Role::DialogButtonTopLeft),
        UPViewMoveMake(self.dialogGameOver.playButton, Role::DialogButtonTopRight),
        UPViewMoveMake(self.dialogGameOver.noteLabel, Role::DialogNote),
    ];

    start(slide(BandModeUI, buttonMoves, 0.75, nil));
    start(slide(BandModeUI, @[UPViewMoveMake(self.gameView.scoreLabel, UP::role_for_score(self.model->score()))], 0.75, nil));
    start(fade(BandModeUI, @[self.gameView.timerLabel], 0.3, nil));
    [UIView animateWithDuration:0.75 animations:^{
        [self viewOpEnterModal:UPSpellGameModeOver];
    }];
}

- (void)modeTransitionFromOverToCountdown:(BOOL)animated
{
}

- (void)modeTransitionFromOverToMenu:(BOOL)animated
{
}

@end
