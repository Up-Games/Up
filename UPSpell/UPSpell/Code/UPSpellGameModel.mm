//
//  UPSpellGameModel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <UpKit/UPLexicon.h>

#include "UPSpellGameModel.h"

namespace UP {

size_t SpellGameModel::PlayerTray::count_marked() const {
    size_t count = 0;
    for (const auto &mark : m_marked) {
        if (mark) {
            count++;
        }
    }
    return count;
}
void SpellGameModel::PlayerTray::sentinelize_marked() {
    size_t idx = 0;
    for (const auto &mark : m_marked) {
        if (mark) {
            m_tiles[idx] = Tile::sentinel();
        }
        idx++;
    }
}
void SpellGameModel::PlayerTray::fill() {
    sentinelize_marked();
    for (auto &tile : m_tiles) {
        if (tile.is_sentinel()) {
//            char32_t c = m_letter_sequence.next();
//            tile = Tile(c);
        }
    }
    unmark_all();
}

SpellGameModel::Word::Word(const TileArray &tiles, size_t count)
{
    char32_t chars[count];
    for (size_t i = 0; i < count; i++) {
        const auto &tile = tiles[i];
        chars[i] = tile.glyph();
        m_score += tile.score();
    }
    m_string = std::u32string(chars, count);
}

bool SpellGameModel::WordTray::check_lexicon() const
{
    Lexicon &lexicon = Lexicon::instance();
    return lexicon.contains(word().string());
}

void SpellGameModel::WordTray::clear()
{
    m_tiles.fill(Tile::sentinel());
    m_count = 0;
}

void SpellGameModel::create_initial_state()
{
    
}

}  // namespace UP
