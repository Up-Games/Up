//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UpKit/UpKit.h>

#import "UPGame.h"
#import "UPTileTray.h"
#import "ViewController.h"

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
    uint32_t marks = UP::Random::gameplay_instance().uint32_in_range(3, 7);
    NSLog(@"mark: %d", marks);
    while ([tray countMarked] < marks) {
        uint32_t m = UP::Random::gameplay_instance().uint32_between(0, 7);
        [tray markAtIndex:m];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UP::Random rng = UP::Random::general_instance();

//    UP::GameCode code1("upm-1000");
    UP::GameCode code1 = UP::GameCode::random();
    NSLog(@"code1: %s", code1.string().c_str());
    NSLog(@"code1: %d", code1.value());
    NSLog(@"code1: %s", UP::GameCode(code1.value()).string().c_str());

//    int seed = CFAbsoluteTimeGetCurrent();
//    NSLog(@"seed: %d", seed);
//    UP::Random::gameplay_instance().seed({seed});
//
//    UPTileTray *tray = [[UPTileTray alloc] init];
//
//    [tray markAll];
//    [tray sentinelizeMarked];
//    [tray fill];
//    [self printTiles:tray];
//
//    for (int idx = 0; idx < 20; idx++) {
//        [self markRandom:tray];
//        [tray sentinelizeMarked];
//        [tray fill];
//        [self printTiles:tray];
//    }
    
}


@end
