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
#import "UPTileControl.h"
#import "UPTilePaths.h"
#import "ViewController.h"

using UP::GameCode;
using UP::Tile;
using UP::LetterSequence;
using UP::SpellGameModel;
using Action = UP::SpellGameModel::Action;
using Opcode = UP::SpellGameModel::Opcode;
using Position = UP::SpellGameModel::Position;

@interface ViewController () <UPGameTimerObserver>
@property (nonatomic) UIView *infinityView;
@property (nonatomic) UPControl *wordTrayView;
@property (nonatomic) UIView *tilesLayoutView;
@property (nonatomic) UIView *tileFrameView;
@property (nonatomic) UPControl *roundControlButtonPause;
@property (nonatomic) UPControl *roundControlButtonTrash;
@property (nonatomic) UPGameTimer *gameTimer;
@property (nonatomic) UPGameTimerLabel *gameTimerLabel;
@property (nonatomic) UPLabel *scoreLabel;
@property (nonatomic) NSMutableArray *tileControls;
@property (nonatomic) UIFont *gameplayInformationFont;
@property (nonatomic) UIFont *gameplayInformationSuperscriptFont;
@property (nonatomic) std::shared_ptr<SpellGameModel> model;
@end

@implementation ViewController

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);

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
    
    layout_manager.set_screen_scale([[UIScreen mainScreen] scale]);
    layout_manager.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout_manager.calculate();
    
    self.infinityView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infinityView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];
    [self.view addSubview:self.infinityView];
    
    self.tilesLayoutView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tilesLayoutView.backgroundColor = [UIColor testColor3];
    [self.view addSubview:self.tilesLayoutView];

    self.roundControlButtonPause = [UPControl roundControlButtonPause];
    [self.view addSubview:self.roundControlButtonPause];

    self.roundControlButtonTrash = [UPControl roundControlButtonTrash];
    [self.view addSubview:self.roundControlButtonTrash];

    self.wordTrayView = [UPControl wordTray];
//    self.wordTrayView.backgroundColor = [UIColor testColor3];
    [self.view addSubview:self.wordTrayView];

    UIFont *font = [UIFont gameplayInformationFontOfSize:layout_manager.gameplay_information_font_metrics().point_size()];
    UIFont *superscriptFont = [UIFont gameplayInformationFontOfSize:layout_manager.gameplay_information_superscript_font_metrics().point_size()];
//    NSArray *features = CFBridgingRelease(CTFontCopyFeatures((__bridge CTFontRef)(font)));
//    NSLog(@"features: %@", features);

    self.gameplayInformationFont = font;
    self.gameplayInformationSuperscriptFont = superscriptFont;

    NSLog(@"=== font metrics");
    NSLog(@"    name:       %@", font.fontName);
    NSLog(@"    pointSize:  %.5f", font.pointSize);
    NSLog(@"    ascender:   %.5f", font.ascender);
    NSLog(@"    descender:  %.5f", font.descender);
    NSLog(@"    capHeight:  %.5f", font.capHeight);
    NSLog(@"    xHeight:    %.5f", font.xHeight);
    NSLog(@"    lineHeight: %.5f", font.lineHeight);

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

    self.tileControls = [NSMutableArray array];
    size_t idx = 0;

    for (const auto &tile : self.model->player_tray()) {
        UPTileControl *tileControl = [UPTileControl controlWithTile:tile];
        [tileControl addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
        tileControl.position = SpellGameModel::Position(idx);
        [self.view addSubview:tileControl];
        [self.tileControls addObject:tileControl];
        idx++;
    }

    const std::array<CGRect, SpellGameModel::TileCount> tile_frames = layout_manager.player_tray_tile_frames();
    for (UPTileControl *tileControl in self.tileControls) {
        tileControl.frame = tile_frames.at(SpellGameModel::index(tileControl.position));
    }
    
//    model.apply(Action(Opcode::TAP, Position::P2));
}

- (void)viewDidLayoutSubviews
{
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    
    self.infinityView.frame = self.view.bounds;
    self.wordTrayView.frame = layout_manager.word_tray_layout_frame();
    self.tilesLayoutView.frame = layout_manager.player_tray_layout_frame();
    self.roundControlButtonPause.frame = layout_manager.controls_button_pause_frame();
    self.roundControlButtonTrash.frame = layout_manager.controls_button_trash_frame();
    self.gameTimerLabel.frame = layout_manager.game_time_label_frame();
    self.scoreLabel.frame = layout_manager.game_score_label_frame();
}

- (void)tileTapped:(id)sender
{
    UPTileControl *tileControl = sender;
    [self tapAction:tileControl];
}

#pragma mark - Actions

- (void)tapAction:(UPTileControl *)tileControl
{
    const Position pos = tileControl.position;
    const size_t idx = self.model->word_length();

    self.model->apply(Action(Opcode::TAP, pos));

    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    const auto &word_tray_tile_centers = layout_manager.word_tray_tile_centers();
    CGPoint word_tray_center = word_tray_tile_centers.at(idx);
    [tileControl bloopWithDuration:0.3 toPosition:word_tray_center completion:nil];
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
