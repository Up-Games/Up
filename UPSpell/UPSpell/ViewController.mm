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

- (void)viewDidLoad
{
    [super viewDidLoad];

    int seed = CFAbsoluteTimeGetCurrent();
    NSLog(@"seed: %d", seed);
    UP::Random::gameplay_instance().seed({seed});

    UPTileTray *tray = [[UPTileTray alloc] init];
    
    for (int i = 0; i < 20; i++) {
        [tray markAll];
        [tray sentinelizeMarked];
        [tray fill];

        NSMutableString *string = [NSMutableString string];
        for (size_t idx = 0; idx < UP::TileCount; idx++) {
            UPTile *tile = [tray tileAtIndex:idx];
            NSString *s = UP::ns_str(tile.glyph);
            [string appendString:s];
            [string appendString:@" "];
        }
        NSLog(@"tray [%2d]: %@", i, string);
    }
}


@end

#if 0
std::vector<char32_t> Lexicon::initial_letters() const
{
    std::vector<char32_t> result;
    switch (random_int_less_than(10)) {
        default:
        case 0: {
            random_bigram().add_to(result);
            random_bigram().add_to(result);
            random_bigram().add_to(result);
            result.push_back(random_letter());
            break;
        }
        case 1: {
            random_trigram().add_to(result);
            random_bigram().add_to(result);
            random_bigram().add_to(result);
            break;
        }
    }
    return result;
}
- (NSArray *)initialLetters
{
    NSMutableArray *result = [NSMutableArray array];
    std::vector v = inner->initial_letters();
    for (const auto c : v) {
        [result addObject:@(uint32_t(c))];
    }
    return result;
}

#endif
