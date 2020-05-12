//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "ViewController.h"

using UP::GameCode;
using UP::LetterTile;
using UP::LetterTileContext;
using UP::LetterTileTray;

@interface ViewController ()
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

    UP::Random::create_instance();

    GameCode code = GameCode::random();
//    GameCode code = GameCode("WPQ-2701");
    NSLog(@"code: %s", code.string().c_str());
    NSLog(@"code: %d", code.value());

    auto ctx = LetterTileContext();
    ctx.configure(UPLexiconLanguageEnglish, code);

    LetterTileTray tray;
    tray.mark_all();
    tray.sentinelize_marked();
    tray.fill(ctx);
    [self printTiles:tray];
    
    for (int idx = 0; idx < 10; idx++) {
        [self markRandom:tray];
        tray.sentinelize_marked();
        tray.fill(ctx);
        [self printTiles:tray];
    }
    
}


@end
