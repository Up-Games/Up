//
//  UPSpellBot.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <array>
#import <map>
#import <vector>

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLexicon.h>
#import <UpKit/UPRandom.h>
#import <UpKit/UPGameTimer.h>
#import <UpKit/UPGameTimerLabel.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPTimeSpanning.h>
#import <UpKit/UPStringTools.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellBot.h"
#import "UPSpellGameController.h"
#import "UPSpellGameView.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPTileView.h"
#import "UPViewMove+UPSpell.h"

using UP::BandAboutPlaying;
using UP::BandAboutPlayingDelay;
using UP::BandAboutPlayingUI;
using UP::Lexicon;
using UP::Random;
using UP::SpellLayout;
using UP::SpellModel;
using UP::Tile;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;
using UP::TilePosition;
using UP::TileTray;
using UP::Word;
using UP::cpp_str;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;
using UP::TimeSpanning::slide;
using UP::TimeSpanning::ease;
using UP::TimeSpanning::shake;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

@interface UPSpellBot ()
@property (nonatomic) BOOL running;
@property (nonatomic) std::u32string pickedWord;
@property (nonatomic) size_t wordIndex;
@end

@implementation UPSpellBot

- (void)start
{
    self.running = YES;
}

- (void)stop
{
    self.running = NO;
}

- (void)takeTurn:(std::shared_ptr<SpellModel>)model
{
    if (!self.running) {
        return;
    }

    self.pickedWord = model->best_possible_word_for_tiles();

    if (!self.running) {
        return;
    }

    if (self.pickedWord.length()) {
        self.wordIndex = 0;
        [self pickNextTile:model];
    }
    else {
        [[UPSpellGameController instance] botDump];
    }
}

- (void)pickNextTile:(std::shared_ptr<SpellModel>)model
{
    if (!self.running) {
        return;
    }
    
    UPSpellGameController *controller = [UPSpellGameController instance];
    const std::u32string &key = self.pickedWord;
    
    char32_t c = key[self.wordIndex];
    size_t idx = 0;
    for (const Tile &tile : model->tiles()) {
        if (tile.model().glyph() == c && tile.in_player_tray()) {
            [controller botPickTile:tile];
            break;
        }
        idx++;
    }
    self.wordIndex++;
    if (self.wordIndex == self.pickedWord.length()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.running) {
                [controller botSubmitWord];
            }
        });
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.running) {
                [self pickNextTile:model];
            }
        });
    }
}

@end
