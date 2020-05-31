//
//  ViewController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <limits>
#import <memory>

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSceneDelegate.h"
#import "UPSpellModel.h"
#import "UPSpellLayout.h"
#import "UPTileModel.h"
#import "UPTileView.h"
#import "UPTilePaths.h"
#import "ViewController.h"

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
@property (nonatomic) UPTileView *pickedView;
@property (nonatomic) TilePosition pickedPosition;
@property (nonatomic) CGPoint panStartPoint;
@property (nonatomic) CGFloat panFurthestDistance;
@property (nonatomic) CGFloat panCurrentDistance;
@property (nonatomic) BOOL panEverMovedUp;
@property (nonatomic) SpellModel *model;
@end

@implementation ViewController

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);
    //LOG_CHANNEL_ON(Gestures);
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
    [UIColor setThemeHue:190];
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
    self.wordTrayView.frame = layout_manager.word_tray_layout_frame();
    [self.wordTrayView addTarget:self action:@selector(wordTrayTapped) forEvents:UIControlEventTouchUpInside];
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
    [self.roundControlButtonPause addTarget:self action:@selector(roundControlButtonPauseTapped:) forEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonPause];

    self.roundControlButtonTrash = [UPControl roundControlButtonTrash];
    self.roundControlButtonTrash.frame = layout_manager.game_controls_right_button_frame();
    self.roundControlButtonTrash.chargeSize = layout_manager.game_controls_button_charge_size();
    [self.roundControlButtonTrash addTarget:self action:@selector(roundControlButtonTrashTapped:) forEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.roundControlButtonTrash];

    self.roundControlButtonClear = [UPControl roundControlButtonClear];
    self.roundControlButtonClear.frame = layout_manager.game_controls_right_button_frame();
    self.roundControlButtonClear.chargeSize = layout_manager.game_controls_button_charge_size();
    [self.roundControlButtonClear addTarget:self action:@selector(roundControlButtonClearTapped:) forEvents:UIControlEventTouchUpInside];
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

    self.roundControlButtonClear.alpha = 0;
    [self viewOpUpdateGameControls];

    self.pickedView = nil;
    self.pickedPosition = TilePosition();

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
            SpellLayout &layout_manager = SpellLayout::instance();
            CGPoint t = [pan translationInView:tileView];
            CGPoint newCenter = CGPointMake(self.panStartPoint.x + t.x, self.panStartPoint.y + t.y);
            newCenter = up_point_with_exponential_barrier(newCenter, layout_manager.tile_drag_barrier_frame());
            self.panFurthestDistance = UPMaxT(CGFloat, self.panFurthestDistance, up_point_distance(CGPointZero, t));
            self.panCurrentDistance = up_point_distance(self.panStartPoint, newCenter);
            self.panEverMovedUp = self.panEverMovedUp || [pan velocityInView:tileView].y < 0;
            tileView.center = newCenter;
            BOOL tileInsideWordTray = CGRectContainsPoint(layout_manager.word_tray_layout_frame(), newCenter);
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
            SpellLayout &layout_manager = SpellLayout::instance();
            CGPoint v = [pan velocityInView:tileView];
            BOOL pannedFar = self.panFurthestDistance >= 25;
            BOOL putBack = self.panCurrentDistance < 10;
            BOOL movingUp = v.y < -50;
            CGFloat movingDownVelocity = UPMaxT(CGFloat, v.y, 0.0);
            BOOL tileInsideWordTray = CGRectContainsPoint(layout_manager.word_tray_layout_frame(), tileView.center);
            CGPoint projectedDownCenter = CGPointMake(tileView.center.x, tileView.center.y + (movingDownVelocity * 0.15));
            BOOL projectedTileInsideWordTray = CGRectContainsPoint(layout_manager.word_tray_layout_frame(), projectedDownCenter);
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
    
    SpellLayout &layout_manager = SpellLayout::instance();
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(word_length);
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

    cancel(DelayLabel);

    NSArray *wordTrayTileViews = [self wordTrayTileViews];

    BOOL needSlide = YES;
    TilePosition word_pos = TilePosition(TileTray::Word, self.model->word_length());
    const State &state = self.model->back_state();
    if (state.action().opcode() == SpellModel::Opcode::HOVER) {
        word_pos = state.action().pos1();
        needSlide = NO;
    }

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::ADD, tile.position(), word_pos));

    SpellLayout &layout_manager = SpellLayout::instance();
    if (needSlide) {
        start(slide(AnimationLabel, wordTrayTileViews, 0.15, layout_manager.word_tray_tile_offset(), nil));
    }
    
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(self.model->word_length());
    CGPoint word_tray_center = word_tray_tile_centers[word_pos.index()];
    UPTileView *tileView = tile.view();
    [self.tileContainerView bringSubviewToFront:tileView];
    start(bloop(@[tileView], 0.4, word_tray_center, nil));

    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionRemove:(const Tile &)tile
{
    ASSERT(tile.has_view());
    ASSERT(self.pickedView);
    ASSERT_POS(self.pickedPosition);

    cancel(DelayLabel);

    UPTileView *tileView = tile.view();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REMOVE, tile.position()));

    [self viewOpSlideWordTrayViewsIntoPlace];

    SpellLayout &layout_manager = SpellLayout::instance();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();
    CGPoint center = player_tray_tile_centers[self.model->player_tray_index(tileView)];
    [self.tileContainerView bringSubviewToFront:tileView];
    start(bloop(@[tileView], 0.4, center, nil));

    tileView.highlighted = NO;
    [self viewOpUpdateGameControls];
}

- (void)applyActionMoveTile:(const Tile &)tile toPosition:(const TilePosition &)position
{
    ASSERT(tile.has_view());
    ASSERT(position.in_word_tray());

    cancel(DelayLabel);
    cancel(AnimationLabel);

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

    cancel(DelayLabel);

    UPTileView *tileView = tile.view();
    self.pickedView = tileView;
    self.pickedPosition = tile.position();
    [self viewOpApplyTranslationToFrame:@[self.pickedView]];

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::PICK, tile.position()));

    [self.tileContainerView bringSubviewToFront:tileView];
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

    cancel(DelayLabel);

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

    cancel(DelayLabel);

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

    cancel(DelayLabel);

    UPTileView *tileView = tile.view();

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DROP, self.pickedPosition));

    if (self.pickedPosition.in_word_tray()) {
        SpellLayout &layout_manager = SpellLayout::instance();
        const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(self.model->word_length());
        CGPoint tile_center = word_tray_tile_centers[self.pickedPosition.index()];
        start(bloop(@[tileView], 0.4, tile_center, nil));
    }
    else {
        SpellLayout &layout_manager = SpellLayout::instance();
        const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();
        CGPoint tile_center = player_tray_tile_centers[self.model->player_tray_index(tileView)];
        start(bloop(@[tileView], 0.4, tile_center, nil));
    }

    tileView.highlighted = NO;

    [self viewOpUpdateGameControls];
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

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::REJECT));

    // assess time penalty and shake word tray side-to-side
    [self viewOpPenaltyForReject:self.model->all_views()];
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

    NSArray *playerTrayTileViews = self.model->player_tray_views();
    ASSERT(playerTrayTileViews.count == TileCount);

    self.model->apply(Action(self.gameTimer.elapsedTime, Opcode::DUMP));

    [self viewOpPenaltyForDump:playerTrayTileViews];
    [self viewOpDumpPlayerTray:playerTrayTileViews];
    delay(1.65, ^{
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
    
    self.scoreLabel.string = [NSString stringWithFormat:@"%d", self.model->score()];
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

    SpellLayout &layout_manager = SpellLayout::instance();
    size_t word_length = self.model->word_length();
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(word_length);

    for (UPTileView *tileView in wordTrayTileViews) {
        const Tile &tile = self.model->find_tile(tileView);
        TileIndex idx = tile.position().index();
        CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
        start(slide_to(@[tileView], 0.2, word_tray_tile_center, nil));
    }
}

- (void)viewOpHover:(const TilePosition &)hover_pos
{
    NSArray *wordTrayTileViews = [self wordTrayTileViewsExceptPickedView];
    if (wordTrayTileViews.count == 0) {
        return;
    }

    [self viewOpApplyTranslationToFrame:wordTrayTileViews];

    SpellLayout &layout_manager = SpellLayout::instance();
    size_t word_length = self.pickedPosition.in_word_tray() ? self.model->word_length() : self.model->word_length() + 1;
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(word_length);

    if (self.pickedPosition.in_player_tray()) {
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
            if (idx >= hover_pos.index()) {
                word_tray_tile_center = word_tray_tile_centers[idx + 1];
            }
            start(slide_to(@[tileView], 0.2, word_tray_tile_center, nil));
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
            start(slide_to(@[tileView], 0.2, word_tray_tile_center, nil));
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

    SpellLayout &layout_manager = SpellLayout::instance();
    size_t word_length = self.pickedPosition.in_word_tray() ? self.model->word_length() - 1 : self.model->word_length();
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers(word_length);

    if (self.pickedPosition.in_player_tray()) {
        for (UPTileView *tileView in wordTrayTileViews) {
            ASSERT(tileView != self.pickedView);
            const Tile &tile = self.model->find_tile(tileView);
            TileIndex idx = tile.position().index();
            CGPoint word_tray_tile_center = word_tray_tile_centers[idx];
            start(slide_to(@[tileView], 0.2, word_tray_tile_center, nil));
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
            start(slide_to(@[tileView], 0.2, word_tray_tile_center, nil));
        }
    }
}

- (void)viewOpClearWordTray
{
    NSArray *wordTrayTileViews = [self wordTrayTileViews];
    ASSERT(wordTrayTileViews.count > 0);

    SpellLayout &layout_manager = SpellLayout::instance();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();
    
    for (UPTileView *tileView in wordTrayTileViews) {
        TileIndex idx = self.model->player_tray_index(tileView);
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
    [self viewOpFillPlayerTrayWithPostFillOp:nil completion:nil];
}

- (void)viewOpFillPlayerTrayWithPostFillOp:(void (^)(void))postFillOp completion:(void (^)(void))completion
{
    SpellLayout &layout_manager = SpellLayout::instance();
    const auto &prefill_tile_frames = layout_manager.prefill_tile_frames();
    const auto &player_tray_tile_centers = layout_manager.player_tray_tile_centers();

    TileIndex idx = 0;
    for (auto &tile : self.model->tiles()) {
        if (tile.has_view<false>()) {
            UPTileView *tileView = [UPTileView viewWithGlyph:tile.model().glyph() score:tile.model().score() multiplier:tile.model().multiplier()];
            tile.set_view(tileView);
            tileView.gestureDelegate = self;
            tileView.frame = prefill_tile_frames[idx];
            [self.tileContainerView addSubview:tileView];
            start(bloop(@[tileView], 0.3, player_tray_tile_centers[idx], nil));
        }
        idx++;
    }

    if (postFillOp) {
        postFillOp();
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
    NSArray *playerTrayTileViews = self.model->all_views();
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
