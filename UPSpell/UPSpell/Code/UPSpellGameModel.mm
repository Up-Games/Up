//
//  UPSpellGameModel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPLexicon.h>
#import <UpKit/UPUtility.h>

#include "UPSpellGameModel.h"

namespace UP {

void SpellGameModel::create_initial_state()
{
    player_mark_all();
    player_fill();
    word_clear();
    word_update();
    m_states.emplace_back(Action(Opcode::INIT), player_tray(), word_tray());
}

const SpellGameModel::State &SpellGameModel::apply(const Action &action)
{
    return m_states.back();
}

size_t SpellGameModel::player_count_marked() const
{
    size_t count = 0;
    for (const auto &mark : m_player_marked) {
        if (mark) {
            count++;
        }
    }
    return count;
}

void SpellGameModel::player_sentinelize_marked()
{
    size_t idx = 0;
    for (const auto &mark : m_player_marked) {
        if (mark) {
            m_player_tray[idx] = Tile::sentinel();
        }
        idx++;
    }
}

void SpellGameModel::player_fill()
{
    player_sentinelize_marked();
    for (auto &tile : m_player_tray) {
        if (tile.is_sentinel()) {
            char32_t c = m_letter_sequence.next();
            tile = Tile(c);
        }
    }
    player_unmark_all();
}

void SpellGameModel::word_insert_at(const Tile &tile, Position pos)
{
    if (pos == Position::W7 || index(pos) >= word_length()) {
        word_push_back(tile);
    }
    else {
        UP::shift_right(m_word_tray.begin() + index(pos), m_word_tray.end() - 1, 1);
        m_word_tray[index(pos)] = tile;
    }
}

void SpellGameModel::word_remove_at(const Tile &tile, Position pos)
{
    if (pos == Position::W7 || index(pos) >= word_length()) {
        m_word_tray[index(pos)] = Tile::sentinel();
    }
    else {
        UP::shift_left(m_word_tray.begin() + index(pos), m_word_tray.end() - 1, 1);
        m_word_tray[index(Position::W7)] = Tile::sentinel();
    }
}

void SpellGameModel::word_update()
{
    char32_t chars[TileCount];
    size_t count = 0;
    m_word_score = 0;
    for (const auto &tile : word_tray()) {
        if (tile.is_sentinel()) {
            break;
        }
        chars[count] = tile.glyph();
        m_word_score += tile.score();
        count++;
    }
    m_word_string = std::u32string(chars, count);
    Lexicon &lexicon = Lexicon::instance();
    m_word_in_lexicon = count > 0 ? lexicon.contains(m_word_string) : false;
}

}  // namespace UP
