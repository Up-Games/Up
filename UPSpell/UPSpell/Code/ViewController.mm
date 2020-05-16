//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <memory>

#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"
#import "UPSpellLayoutManager.h"
#import "ViewController.h"
#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"

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
@property (nonatomic) NSMutableArray *tileViews;
@property (nonatomic) std::shared_ptr<UP::SpellLayoutManager> layout_manager;
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

//    UP::Random::create_instance();
//    UP::Lexicon::set_language(UPLexiconLanguageEnglish);
//
//    GameCode code = GameCode::random();
////    GameCode code = GameCode("WPQ-2701");
//    NSLog(@"code: %s", code.string().c_str());
//    NSLog(@"code: %d", code.value());
//
//    UP::LetterSequence::create_instance();
//    UP::LetterSequence::instance().set_game_code(code);
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
    
    self.layout_manager = std::make_shared<UP::SpellLayoutManager>();
    self.layout_manager->set_screen_scale([[UIScreen mainScreen] scale]);
    self.layout_manager->set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    self.layout_manager->calculate();
    
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

    UIFont *font = [UIFont gameplayInformationFontOfSize:self.layout_manager->gameplay_information_font_metrics().point_size()];

    NSLog(@"=== font metrics");
    NSLog(@"    name:       %@", font.fontName);
    NSLog(@"    pointSize:  %.5f", font.pointSize);
    NSLog(@"    ascender:   %.5f", font.ascender);
    NSLog(@"    descender:  %.5f", font.descender);
    NSLog(@"    capHeight:  %.5f", font.capHeight);
    NSLog(@"    xHeight:    %.5f", font.xHeight);
    NSLog(@"    lineHeight: %.5f", font.lineHeight);

//    self.timeLabel.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryCanvas];

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

//    self.tileFrameView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tileFrameView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.tileFrameView];
//
//    self.tileViews = [NSMutableArray array];
//    for (int i = 0; i < UP::TileCount; i++) {
//        UIView *tileView = [[UIView alloc] initWithFrame:CGRectZero];
//        tileView.backgroundColor = [UIColor blackColor];
//        [self.view addSubview:tileView];
//        [self.tileViews addObject:tileView];
//    }

//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 90)];
//    label.font = [UIFont letterTileGlyphFontOfSize:86];
//    label.text = @"Q";
//    label.font = [UIFont gameplayInformationFontOfSize:86];
//    label.text = @"1:30";
//    [self.view addSubview:label];
}

- (void)viewDidLayoutSubviews
{
    self.infinityView.frame = self.view.bounds;
    self.canvasView.frame = self.layout_manager->canvas_frame();
    self.layoutView.frame = self.layout_manager->layout_frame();
    self.controlsLayoutView.frame = self.layout_manager->controls_layout_frame();
    self.wordTrayView.frame = self.layout_manager->word_tray_layout_frame();
    self.tilesLayoutView.frame = self.layout_manager->tiles_layout_frame();
    self.roundControlButtonPause.frame = self.layout_manager->controls_button_pause_frame();
    self.roundControlButtonTrash.frame = self.layout_manager->controls_button_trash_frame();
    self.timeLabel.frame = self.layout_manager->game_time_label_frame();
    self.scoreLabel.frame = self.layout_manager->game_score_label_frame();

//    self.tileFrameView.frame = layoutManager.tileFrame;
//    NSLog(@"tile frame: %@", NSStringFromCGRect(layoutManager.tileFrame));
//
//    CGFloat x = CGRectGetMinX(self.tileFrameView.frame);
//    CGFloat y = CGRectGetMinY(self.tileFrameView.frame);
//    CGFloat widthFraction = CGRectGetWidth(UPSpellCanonicalTileLayoutFrame) / UPCanonicalCanvasWidth;
//    CGFloat width = 68; //UPSpellCanonicalTileSize.width * layoutManager.layoutScale * widthFraction;
//    CGFloat height = CGRectGetHeight(self.tileFrameView.frame);
//    CGFloat gap = UPSpellCanonicalTileGap * layoutManager.layoutScale;
//    for (UIView *view in self.tileViews) {
//        CGRect frame = CGRectMake(x, y, width, height);
//        view.frame = frame;
//        x += (width + gap);
//    }
}

@end
