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

static bool accept_tile_array(const TileArray &tiles)
{
    int vowel_count = 0;
    for (const auto &tile : tiles) {
        if (Lexicon::is_vowel(tile.glyph())) {
            vowel_count++;
        }
    }
    return vowel_count >= 1 && vowel_count <= 5;
}

template <class N>
static void fill_into(TileArray &tiles, const N &ngram)
{
    N shuffled_ngram = ngram.shuffled();
    size_t idx = 0;
    for (auto &tile : tiles) {
        if (tile.is_sentinel()) {
            tile = Tile(shuffled_ngram.at(idx));
            idx++;
            if (idx == N::length) {
                break;
            }
        }
    }
}

static void fill_two(TileArray &tiles, Random &random, const Lexicon &lexicon)
{
    int r = random.uint32_between(0, 3);
    switch (r) {
        case 0:
        case 1:
            fill_into(tiles, lexicon.random_bigram());
            break;
        case 2:
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
    }
}

static void fill_three(TileArray &tiles, Random &random, const Lexicon &lexicon)
{
    int r = random.uint32_between(0, 6);
    switch (r) {
        case 0:
        case 1:
            fill_into(tiles, lexicon.random_trigram());
            break;
        case 2:
        case 3:
        case 4:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
        case 5:
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
    }
}

static void fill_four(TileArray &tiles, Random &random, const Lexicon &lexicon)
{
    int r = random.uint32_between(0, 4);
    switch (r) {
        case 0:
            fill_into(tiles, lexicon.random_quadgram());
            break;
        case 1:
            fill_into(tiles, lexicon.random_trigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
        case 2:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_bigram());
            break;
        case 3:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
    }
}

static void fill_five(TileArray &tiles, Random &random, const Lexicon &lexicon)
{
    int r = random.uint32_between(0, 4);
    switch (r) {
        case 0:
            fill_into(tiles, lexicon.random_quadgram());
            fill_into(tiles, lexicon.random_unigram());
            break;
        case 1:
            fill_into(tiles, lexicon.random_trigram());
            fill_into(tiles, lexicon.random_bigram());
            break;
        case 2:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
        case 3:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
    }
}

static void fill_six(TileArray &tiles, Random &random, const Lexicon &lexicon)
{
    int r = random.uint32_between(0, 4);
    switch (r) {
        case 0:
            fill_into(tiles, lexicon.random_quadgram());
            fill_into(tiles, lexicon.random_bigram());
            break;
        case 1:
            fill_into(tiles, lexicon.random_trigram());
            fill_into(tiles, lexicon.random_trigram());
            break;
        case 2:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_bigram());
            break;
        case 3:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
    }
}

static void fill_seven(TileArray &tiles, Random &random, const Lexicon &lexicon)
{
    int r = random.uint32_between(0, 4);
    switch (r) {
        case 0:
            fill_into(tiles, lexicon.random_quadgram());
            fill_into(tiles, lexicon.random_trigram());
            break;
        case 1:
            fill_into(tiles, lexicon.random_trigram());
            fill_into(tiles, lexicon.random_trigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
        case 2:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
        case 3:
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_bigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            fill_into(tiles, lexicon.random_unigram());
            break;
    }
}

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
    Lexicon &lexicon = Game::instance().lexicon();
    Random &random = Random::gameplay_instance();
    size_t count = 0;
    for (const auto &mark : m_marked) {
        if (mark) {
            count++;
        }
    }
    sentinelize_marked(m_tiles, m_marked);

    while (1) {
        switch (count) {
            case 2:
                fill_two(m_tiles, random, lexicon);
                break;
            case 3:
                fill_three(m_tiles, random, lexicon);
                break;
            case 4:
                fill_four(m_tiles, random, lexicon);
                break;
            case 5:
                fill_five(m_tiles, random, lexicon);
                break;
            case 6:
                fill_six(m_tiles, random, lexicon);
                break;
            case 7:
                fill_seven(m_tiles, random, lexicon);
                break;
        }
        if (accept_tile_array(m_tiles)) {
            break;
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

@end
