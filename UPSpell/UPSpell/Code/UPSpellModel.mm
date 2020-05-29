//
//  UPSpellModel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>
#import <sstream>

#import <UpKit/UPLexicon.h>
#import <UpKit/UPUtility.h>

#include "UPSpellModel.h"
#include "UPTileView.h"

namespace UP {

std::string tile_tray_description(const TileArray &tile_tray)
{
    std::stringstream stream;
    for (const auto &tile : tile_tray) {
        if (tile.is_sentinel()) {
            stream << '_';
        }
        else {
            stream << tile.glyph();
        }
    }
    return stream.str();
}

std::string marked_array_description(const MarkedArray &marked_array)
{
    std::stringstream stream;
    for (const auto &mark : marked_array) {
        if (mark) {
            stream << 'X';
        }
        else {
            stream << '_';
        }
    }
    return stream.str();
}

bool is_non_sentinel_filled_up_to(const TileArray &tile_tray, const TileIndex idx)
{
    ASSERT_WITH_MESSAGE(valid_end(idx), "idx: %ld", idx);
    
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

size_t count_non_sentinel(const TileArray &tile_tray)
{
    size_t count = 0;
    for (const auto &tile : tile_tray) {
        if (tile.is_sentinel<false>()) {
            count++;
        }
    }
    return count;
}

void SpellModel::player_sentinelize_marked()
{
    TileIndex idx = 0;
    for (const auto &mark : m_player_marked) {
        if (mark) {
            m_player_tray[idx] = Tile::sentinel();
        }
        idx++;
    }
}

void SpellModel::player_fill()
{
    player_sentinelize_marked();
    for (auto &tile : m_player_tray) {
        if (tile.is_sentinel()) {
            tile = m_tile_sequence.next();
        }
    }
    player_unmark_all();
}

void SpellModel::word_insert_at(const Tile &tile, TileIndex idx)
{
    ASSERT_IDX(idx);
    if (idx >= LastTileIndex) {
        word_push_back(tile);
    }
    else {
        UP::shift_right(m_word_tray.begin() + idx, m_word_tray.end() - 1, 1);
        m_word_tray[idx] = tile;
    }
}

void SpellModel::word_remove_at(const Tile &tile, TileIndex idx)
{
    ASSERT_IDX(idx);
    if (idx >= LastTileIndex) {
        m_word_tray[idx] = Tile::sentinel();
    }
    else {
        UP::shift_left(m_word_tray.begin() + idx, m_word_tray.end() - 1, 1);
        m_word_tray[LastTileIndex] = Tile::sentinel();
    }
}

void SpellModel::word_update()
{
    char32_t chars[TileCount];
    size_t count = 0;
    m_word_score = 0;
    for (const auto &tile : word_tray()) {
        if (tile.is_sentinel()) {
            break;
        }
        chars[count] = tile.glyph();
        m_word_score += (tile.score() * tile.multiplier());
        count++;
    }
    m_word_string = std::u32string(chars, count);
    switch (count) {
        default:
            // no bonus
            break;
        case 5:
            m_word_score += FiveLetterWordBonus;
            break;
        case 6:
            m_word_score += SixLetterWordBonus;
            break;
        case 7:
            m_word_score += SevenLetterWordBonus;
            break;
    }
    Lexicon &lexicon = Lexicon::instance();
    m_word_in_lexicon = count > 0 ? lexicon.contains(m_word_string) : false;
}

const SpellModel::State &SpellModel::apply(const Action &action)
{
    switch (action.opcode()) {
        case Opcode::NOP:
            // move along
            break;
        case Opcode::INIT:
            apply_init(action);
            break;
        case Opcode::ADD:
            apply_tap(action);
            break;
        case Opcode::PICK:
            break;
        case Opcode::DROP:
            break;
        case Opcode::REMOVE:
            break;
        case Opcode::HOVER:
            break;
        case Opcode::PUT:
            break;
        case Opcode::SWAP:
            break;
        case Opcode::SUBMIT:
            apply_submit(action);
            break;
        case Opcode::REJECT:
            apply_reject(action);
            break;
        case Opcode::CLEAR:
            apply_clear(action);
            break;
        case Opcode::DUMP:
            apply_dump(action);
            break;
        case Opcode::OVER:
            break;
        case Opcode::QUIT:
            break;
    }

    return m_states.emplace_back(action, player_tray(), word_tray(), game_score());
}

void SpellModel::apply_init(const Action &action)
{
    ASSERT(action.opcode() == Opcode::INIT);
    ASSERT(action.idx1() == NotATileIndex);
    ASSERT(action.idx2() == NotATileIndex);
    ASSERT(is_sentinel_filled(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));

    player_mark_all();
    player_fill();
    word_update();

    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));
}

void SpellModel::apply_tap(const Action &action)
{
    ASSERT(action.opcode() == Opcode::ADD);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_non_sentinel_filled_up_to(word_tray(), word_length()));
    ASSERT_IDX(action.idx1());
    ASSERT_NIDX(action.idx2());
    ASSERT_WITH_MESSAGE(is_marked<false>(player_marked(), action.idx1()), "idx: %ld ; marked: %s",
        action.idx1(), marked_array_description(player_marked()).c_str());
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);

    size_t in_word_length = word_length();
    const TileIndex idx = action.idx1();

    const Tile &tile = m_player_tray[idx];
    player_mark_at(action.idx1());
    word_push_back(tile);
    word_update();

    size_t out_word_length = word_length();

    ASSERT(in_word_length + 1 == out_word_length);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_non_sentinel_filled_up_to(word_tray(), word_length()));
    ASSERT(is_marked(player_marked(), action.idx1()));
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
}

void SpellModel::apply_submit(const Action &action)
{
    ASSERT(action.opcode() == Opcode::SUBMIT);
    ASSERT_NIDX(action.idx1());
    ASSERT_NIDX(action.idx2());
    ASSERT(is_non_sentinel_filled_up_to(word_tray(), word_length()));
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
    ASSERT(word_length() > 0);
    ASSERT(word_in_lexicon());
    ASSERT(word_score() > 0);

    m_game_score += word_score();
    word_clear();
    player_fill();
    word_update();

    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(count_marked(player_marked()) == 0);
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));
}

void SpellModel::apply_reject(const Action &action)
{
    ASSERT(action.opcode() == Opcode::REJECT);
    ASSERT_NIDX(action.idx1());
    ASSERT_NIDX(action.idx2());
    ASSERT(is_non_sentinel_filled_up_to(word_tray(), word_length()));
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
    ASSERT(!word_in_lexicon());
    
    // otherwise, a no-op
}

void SpellModel::apply_clear(const Action &action)
{
    ASSERT(action.opcode() == Opcode::CLEAR);
    ASSERT_NIDX(action.idx1());
    ASSERT_NIDX(action.idx2());
    ASSERT(is_non_sentinel_filled_up_to(word_tray(), word_length()));
    ASSERT(word_length() > 0);
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);

    player_unmark_all();
    word_clear();
    word_update();

    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(count_marked(player_marked()) == 0);
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));
}

void SpellModel::apply_dump(const Action &action)
{
    ASSERT(action.opcode() == Opcode::DUMP);
    ASSERT_NIDX(action.idx1());
    ASSERT_NIDX(action.idx2());
    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(count_marked(player_marked()) == 0);
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));

    player_mark_all();
    player_fill();

    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(count_marked(player_marked()) == 0);
    ASSERT(count_marked<false>(player_marked()) + word_length() == TileCount);
    ASSERT(is_sentinel_filled<false>(player_tray()));
    ASSERT(is_sentinel_filled(word_tray()));
}

}  // namespace UP
