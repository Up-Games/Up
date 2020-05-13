//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "ViewController.h"
#import "UIFont+UPSpell.h"

using UP::GameCode;
using UP::LetterTile;
using UP::LetterTileSequence;
using UP::LetterTileTray;

@interface ViewController ()
@property (nonatomic) UIView *canvasView;
@property (nonatomic) UIView *layoutView;
@property (nonatomic) UIView *tile1;
@end

@implementation ViewController

- (void)printTiles:(const LetterTileTray &)tray
{
    NSMutableString *string = [NSMutableString string];
    for (size_t idx = 0; idx < UP::TileCount; idx++) {
        LetterTile tile = tray.tile_at_index(idx);
        NSString *s = UP::ns_str(tile.glyph());
        [string appendString:s];
        [string appendString:@" "];
    }
    NSLog(@"tray: %@", string);
}

- (void)markRandom:(LetterTileTray &)tray
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
//    UP::LetterTileSequence::create_instance();
//    UP::LetterTileSequence::instance().set_game_code(code);
//
//    LetterTileTray tray;
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
    
    self.canvasView = [[UIView alloc] initWithFrame:CGRectZero];
    self.canvasView.backgroundColor = [UIColor testColor1];
    [self.view addSubview:self.canvasView];

    self.layoutView = [[UIView alloc] initWithFrame:CGRectZero];
    self.layoutView.backgroundColor = [UIColor testColor2];
    [self.view addSubview:self.layoutView];

//    self.tile1 = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tile1.backgroundColor = [UIColor testColor2];
//    [self.view addSubview:self.tile1];

//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 90)];
//    label.font = [UIFont letterTileGlyphFontOfSize:86];
//    label.text = @"Q";
//    label.font = [UIFont gameplayInformationFontOfSize:86];
//    label.text = @"1:30";
//    [self.view addSubview:label];
}

- (void)viewDidLayoutSubviews
{
    UPLayoutManager *layoutManager = [UPLayoutManager instance];
    self.canvasView.frame = layoutManager.canvasFrame;
    self.layoutView.frame = layoutManager.layoutFrame;
}

@end
