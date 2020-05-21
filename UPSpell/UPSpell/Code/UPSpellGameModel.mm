//
//  UPSpellGameModel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <UpKit/UPLexicon.h>
#import <UpKit/UPUtility.h>

#include "UPSpellGameModel.h"

namespace UP {

bool is_non_sentinel_filled_up_to(const SpellGameModel::TileTray &tile_tray, const size_t idx)
{
    ASSERT(is_valid_tray_index(idx));
    
    const auto begin = tile_tray.begin();
    const auto end = tile_tray.end();
    
    for (auto it = begin; it != begin + idx; ++it) {
        if (it->is_sentinel()) {
            return false;
        }
    }
    for (auto it = begin + idx; it != end; ++it) {
        if (it->is_sentinel<false>()) {
            return false;
        }
    }
    
    return true;
}

size_t count_non_sentinel(const SpellGameModel::TileTray &tile_tray)
{
    size_t count = 0;
    for (const auto &tile : tile_tray) {
        if (tile.is_sentinel<false>()) {
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

const SpellGameModel::State &SpellGameModel::apply(const Action &action)
{
    switch (action.opcode()) {
        case Opcode::NOP:
            // move along
            break;
        case Opcode::INIT:
            apply_init(action);
            break;
        case Opcode::TAP:
            apply_tap(action);
            break;
        case Opcode::PICK:
            break;
        case Opcode::DROP:
            break;
        case Opcode::HOVER:
            break;
        case Opcode::MOVE:
            break;
        case Opcode::SWAP:
            break;
        case Opcode::WORD:
            break;
        case Opcode::OVER:
            break;
        case Opcode::DUMP:
            break;
        case Opcode::QUIT:
            break;
    }

    return m_states.emplace_back(action, player_tray(), word_tray());
}

void SpellGameModel::apply_init(const Action &action)
{
    ASSERT(action.opcode() == Opcode::INIT);
    ASSERT(is_sentinel_filled(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));

    player_mark_all();
    player_fill();
    word_update();

    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));
}

void SpellGameModel::apply_tap(const Action &action)
{
    ASSERT(action.opcode() == Opcode::TAP);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_non_sentinel_filled_up_to(word_tray(), word_length()));
    ASSERT(position_in_player_tray(action.pos1()));
    ASSERT(is_marked<false>(player_marked(), action.pos1()));
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);

    size_t in_word_length = word_length();
    const size_t idx = index(action.pos1());

    const Tile &tile = m_player_tray[idx];
    player_mark_at(action.pos1());
    word_push_back(tile);
    word_update();

    size_t out_word_length = word_length();

    ASSERT(in_word_length + 1 == out_word_length);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_non_sentinel_filled_up_to(word_tray(), word_length()));
    ASSERT(is_marked(player_marked(), action.pos1()));
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
}


}  // namespace UP
