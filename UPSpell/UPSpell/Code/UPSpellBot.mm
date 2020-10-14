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

- (instancetype)init
{
    self = [super init];
    
    SpellLayout &layout = SpellLayout::instance();
    
    CGRect botSpotFrame = up_rect_scaled(CGRectMake(0, 0, 92, 92), layout.layout_scale());
    self.botSpot = [[UIView alloc] initWithFrame:botSpotFrame];
    
    return self;
}

- (void)start
{
    self.running = YES;
}

- (void)stop
{
    self.running = NO;
}

static std::u32string best_word(std::shared_ptr<SpellModel> model)
{
    std::u32string picked_word;
    int picked_score = 0;
    Lexicon &lexicon = Lexicon::instance();
    for (const std::u32string_view &key : lexicon.keys()) {
        std::u32string try_key = std::u32string(key);
        TileArray word_tiles = model->tiles();
        size_t found = 0;
        int score = 0;
        int multiplier = 1;
        bool found_letter = false;
        for (size_t idx = 0; idx < try_key.length(); idx++) {
            char32_t c = key[idx];
            for (Tile &tile : word_tiles) {
                if (tile.model().glyph() == c && tile.in_player_tray()) {
                    tile.set_position(TilePosition(TileTray::Word, found));
                    found_letter = true;
                    found++;
                    score += tile.model().score();
                    multiplier *= tile.model().multiplier();
                    break;
                }
            }
            if (!found_letter) {
                break;
            }
        }
        if (found > 0 && found == key.length()) {
            int total_score = score * multiplier;
            if (total_score > picked_score) {
                picked_word = std::u32string(key);
                picked_score = total_score;
            }
        }
    }
    
    return picked_word;
}

- (void)takeTurn:(std::shared_ptr<SpellModel>)model
{
    self.pickedWord = best_word(model);
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
    UPSpellGameController *controller = [UPSpellGameController instance];
    SpellLayout &layout = SpellLayout::instance();
    const std::u32string &key = self.pickedWord;
    
    char32_t c = key[self.wordIndex];
    size_t idx = 0;
    for (const Tile &tile : model->tiles()) {
        if (tile.model().glyph() == c && tile.in_player_tray()) {
            self.botSpot.center = layout.center_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
            [controller botPickTile:tile];
            break;
        }
        idx++;
    }
    self.wordIndex++;
    if (self.wordIndex == self.pickedWord.length()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [controller botSubmitWord];
        });
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.075 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pickNextTile:model];
        });
    }
}

@end
