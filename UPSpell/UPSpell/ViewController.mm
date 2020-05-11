//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UPGame.h"
#import "UPTileTray.h"
#import "ViewController.h"

using UP::Game;
using UP::GameCode;

@interface ViewController ()
@end

@implementation ViewController

- (void)printTiles:(UPTileTray *)tray
{
    NSMutableString *string = [NSMutableString string];
    for (size_t idx = 0; idx < UP::TileCount; idx++) {
        UPTile *tile = [tray tileAtIndex:idx];
        NSString *s = UP::ns_str(tile.glyph);
        [string appendString:s];
        [string appendString:@" "];
    }
    NSLog(@"tray: %@", string);
}

- (void)markRandom:(UPTileTray *)tray
{
    uint32_t marks = UP::Random::general_instance().uint32_in_range(3, 7);
    //NSLog(@"mark: %d", marks);
    while ([tray countMarked] < marks) {
        uint32_t m = UP::Random::general_instance().uint32_between(0, 7);
        [tray markAtIndex:m];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UP::Random rng = UP::Random::general_instance();

    GameCode code = GameCode::random();
//    GameCode code = GameCode("WPQ-2701");
    NSLog(@"code: %s", code.string().c_str());
    NSLog(@"code: %d", code.value());

    Game game = Game::instance();
    game.configure(UPLexiconLanguageEnglish, code);

    UPTileTray *tray = [[UPTileTray alloc] init];

    [tray markAll];
    [tray sentinelizeMarked];
    [tray fill];
    [self printTiles:tray];

    for (int idx = 0; idx < 200; idx++) {
        [self markRandom:tray];
        [tray sentinelizeMarked];
        [tray fill];
        [self printTiles:tray];
    }
    
}


@end
