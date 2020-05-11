//
//  UPTileTray.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPLexicon.h>
#import <UpKit/UPRandom.hpp>

#import "UPGame.h"
#import "UPTileTray.h"

using UP::Game;
using UP::Lexicon;
using UP::Random;
using UP::Tile;
using UP::TileArray;
using UP::MarkedArray;

static void sentinelize_marked(TileArray &tiles, const MarkedArray &marked)
{
    size_t idx = 0;
    for (const auto &mark : marked) {
        if (mark) {
            tiles[idx] = Tile::sentinel();
        }
        idx++;
    }
}

@interface UPTileTray ()
{
    TileArray m_tiles;
    MarkedArray m_marked;
}
@end

@implementation UPTileTray

- (UPTile *)tileAtIndex:(size_t)index
{
    const auto tile = m_tiles[index];
    return [UPTile tileWithGlyph:tile.glyph() score:tile.score() multiplier:tile.multiplier()];
}

- (void)fill
{
    auto &game = Game::instance();
    sentinelize_marked(m_tiles, m_marked);
    for (auto &tile : m_tiles) {
        if (tile.is_sentinel()) {
            char32_t c = game.letter_sequence().next();
            tile = Tile(c);
        }
    }
    m_marked.fill(false);
}

- (void)markAtIndex:(size_t)index
{
    m_marked.at(index) = true;
}

- (void)unmarkAtIndex:(size_t)index
{
    m_marked.at(index) = false;
}

- (void)markAll
{
    m_marked.fill(true);
}

- (void)unmarkAll
{
    m_marked.fill(false);
}

- (void)sentinelizeMarked
{
    size_t idx = 0;
    for (const auto &mark : m_marked) {
        if (mark) {
            m_tiles[idx] = UP::Tile::sentinel();
        }
        idx++;
    }
}

- (size_t)countMarked
{
    size_t count = 0;
    for (const auto &mark : m_marked) {
        if (mark) {
            count++;
        }
    }
    return count;
}

@end
