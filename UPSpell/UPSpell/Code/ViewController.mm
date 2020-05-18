//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <memory>

#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSceneDelegate.h"
#import "UPSpellLayoutManager.h"
#import "UPTileControl.h"
#import "UPTilePaths.h"
#import "ViewController.h"

using UP::GameCode;
using UP::Tile;
using UP::LetterSequence;
using UP::TileTray;

@interface ViewController ()
@property (nonatomic) UIView *infinityView;
@property (nonatomic) UIView *canvasView;
@property (nonatomic) UIView *layoutView;
@property (nonatomic) UIView *controlsLayoutView;
@property (nonatomic) UPControl *wordTrayView;
@property (nonatomic) UIView *tilesLayoutView;
@property (nonatomic) UIView *tileFrameView;
@property (nonatomic) UPControl *roundControlButtonPause;
@property (nonatomic) UPControl *roundControlButtonTrash;
@property (nonatomic) UPLabel *timeLabel;
@property (nonatomic) UPLabel *scoreLabel;
@property (nonatomic) NSMutableArray *tileControls;
@end

@implementation ViewController

- (void)printTiles:(const TileTray &)tray
{
    NSMutableString *string = [NSMutableString string];
    for (size_t idx = 0; idx < UP::TileCount; idx++) {
        Tile tile = tray.tile_at_index(idx);
        NSString *s = UP::ns_str(tile.glyph());
        [string appendString:s];
        [string appendString:@" "];
    }
    NSLog(@"tray: %@", string);
}

- (void)markRandom:(TileTray &)tray
{
    uint32_t marks = UP::Random::instance().uint32_in_range(3, 7);
    //NSLog(@"mark: %d", marks);
    while (tray.count_marked() < marks) {
        uint32_t m = UP::Random::instance().uint32_between(0, 7);
        tray.mark_at_index(m);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UP::Random::create_instance();
    UP::Lexicon::set_language(UPLexiconLanguageEnglish);

    GameCode code = GameCode::random();
////    GameCode code = GameCode("WPQ-2701");
    NSLog(@"code: %s", code.string().c_str());
    NSLog(@"code: %d", code.value());
//
    UP::LetterSequence &letter_sequence = UP::LetterSequence::create_instance();
    letter_sequence.set_game_code(code);
//
//    TileTray tray;
//    tray.mark_all();
//    tray.sentinelize_marked();
//    tray.fill();
//    [self printTiles:tray];
//
//    for (int idx = 0; idx < 10; idx++) {
//        [self markRandom:tray];
//        tray.sentinelize_marked();
//        tray.fill();
//        [self printTiles:tray];
//    }
    
    [UIColor setThemeStyle:UPColorStyleLight];
//    [UIColor setThemeHue:0];
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::create_instance();
    UP::TilePaths::create_instance();
    
    layout_manager.set_screen_scale([[UIScreen mainScreen] scale]);
    layout_manager.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout_manager.calculate();
    
    self.infinityView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infinityView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryCanvas];
    [self.view addSubview:self.infinityView];
    
    self.canvasView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.canvasView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryCanvas];
//    self.canvasView.backgroundColor = [UIColor testColor4];
    [self.view addSubview:self.canvasView];

    self.layoutView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.layoutView.backgroundColor = [UIColor testColor2];
    [self.view addSubview:self.layoutView];

    self.controlsLayoutView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.controlsLayoutView.backgroundColor = [UIColor testColor1];
    [self.view addSubview:self.controlsLayoutView];

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

    NSLog(@"=== font metrics");
    NSLog(@"    name:       %@", font.fontName);
    NSLog(@"    pointSize:  %.5f", font.pointSize);
    NSLog(@"    ascender:   %.5f", font.ascender);
    NSLog(@"    descender:  %.5f", font.descender);
    NSLog(@"    capHeight:  %.5f", font.capHeight);
    NSLog(@"    xHeight:    %.5f", font.xHeight);
    NSLog(@"    lineHeight: %.5f", font.lineHeight);

    self.timeLabel = [UPLabel label];
    self.timeLabel.string = @"0:17";
    self.timeLabel.font = font;
    self.timeLabel.textColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.timeLabel];

    self.scoreLabel = [UPLabel label];
    self.scoreLabel.string = @"114";
    self.scoreLabel.font = font;
    self.scoreLabel.textColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.scoreLabel];

    self.tileControls = [NSMutableArray array];
    for (int i = 0; i < UP::TileCount; i++) {
        char32_t glyph = letter_sequence.next();
        UP::Tile tile = Tile(glyph);
        UPTileControl *tileControl = [UPTileControl controlWithTile:tile];
        tileControl.index = i;
        [self.view addSubview:tileControl];
        [self.tileControls addObject:tileControl];
    }
}

- (void)viewDidLayoutSubviews
{
    UP::SpellLayoutManager &layout_manager = UP::SpellLayoutManager::instance();
    
    self.infinityView.frame = self.view.bounds;
    self.canvasView.frame = layout_manager.canvas_frame();
    self.layoutView.frame = layout_manager.layout_frame();
    self.controlsLayoutView.frame = layout_manager.controls_layout_frame();
    self.wordTrayView.frame = layout_manager.word_tray_layout_frame();
    self.tilesLayoutView.frame = layout_manager.tiles_layout_frame();
    self.roundControlButtonPause.frame = layout_manager.controls_button_pause_frame();
    self.roundControlButtonTrash.frame = layout_manager.controls_button_trash_frame();
    self.timeLabel.frame = layout_manager.game_time_label_frame();
    self.scoreLabel.frame = layout_manager.game_score_label_frame();

    const std::array<CGRect, UP::TileCount> tile_frames = layout_manager.tile_frames();
    for (UPTileControl *tileControl in self.tileControls) {
        tileControl.frame = tile_frames.at(tileControl.index);
    }
}

@end
