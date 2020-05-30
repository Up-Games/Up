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

const Tile &SpellModel::find_tile(const UPTileView *view) const
{
    for (const auto &tile : m_tiles) {
        if (view == tile.view()) {
            return tile;
        }
    }
    ASSERT_NOT_REACHED();
    static Tile tile;
    return tile;
}

Tile &SpellModel::find_tile(const UPTileView *view)
{
    for (auto &tile : m_tiles) {
        if (view == tile.view()) {
            return tile;
        }
    }
    ASSERT_NOT_REACHED();
    static Tile tile;
    return tile;
}

UPTileView *SpellModel::view_at_position(const TilePosition &pos)
{
    switch (pos.tray()) {
        case TileTray::None: {
            ASSERT_NOT_REACHED();
            break;
        }
        case TileTray::Player: {
            UPTileView *view = m_tiles[pos.index()].view();
            ASSERT(view);
            return view;
        }
        case TileTray::Word: {
            for (auto &tile : m_tiles) {
                if (tile.position() == pos) {
                    UPTileView *view = m_tiles[pos.index()].view();
                    ASSERT(view);
                    return view;
                }
            }
            ASSERT_NOT_REACHED();
            return nullptr;
        }
    }
}
    
TileIndex SpellModel::player_tray_index(const UPTileView *view)
{
    TileIndex idx = 0;
    for (const auto &tile : m_tiles) {
        if (view == tile.view()) {
            return idx;
        }
        idx++;
    }
    ASSERT_NOT_REACHED();
    return NotATileIndex;
}

NSArray *SpellModel::all_views() const
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : tiles()) {
        ASSERT(tile.has_view());
        [array addObject:tile.view()];
    }
    return array;
}

NSArray *SpellModel::player_tray_views() const
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : tiles()) {
        if (tile.in_player_tray()) {
            ASSERT(tile.has_view());
            [array addObject:tile.view()];
        }
    }
    return array;
}

NSArray *SpellModel::word_tray_views() const
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : tiles()) {
        if (tile.in_word_tray()) {
            ASSERT(tile.has_view());
            [array addObject:tile.view()];
        }
    }
    return array;
}

std::string SpellModel::tiles_description() const
{
    std::stringstream stream;
    for (const auto &tile : m_tiles) {
        if (tile.model().is_sentinel()) {
            stream << '_';
        }
        else {
            stream << tile.model().glyph();
        }
    }
    return stream.str();
}

void SpellModel::fill_player_tray()
{
    for (auto &tile : m_tiles) {
        ASSERT(tile.in_player_tray());
        if (tile.model().is_sentinel()) {
            tile.set_model(m_tile_sequence.next());
        }
    }
}

void SpellModel::clear_word_tray()
{
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        ASSERT(tile.model().is_sentinel<false>());
        if (tile.in_word_tray()) {
            tile.set_position(TilePosition(TileTray::Player, it - m_tiles.begin()));
        }
    }
}

void SpellModel::clear_and_sentinelize_word_tray()
{
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        ASSERT(tile.model().is_sentinel<false>());
        if (tile.in_word_tray()) {
            tile.set_model(TileModel::sentinel());
            tile.set_position(TilePosition(TileTray::Player, it - m_tiles.begin()));
            tile.clear_view();
        }
    }
}

void SpellModel::clear_and_sentinelize()
{
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        ASSERT(tile.model().is_sentinel<false>());
        tile.set_model(TileModel::sentinel());
        tile.set_position(TilePosition(TileTray::Player, it - m_tiles.begin()));
        tile.clear_view();
    }
}

void SpellModel::update_word()
{
    char32_t chars[TileCount];
    bzero(chars, sizeof(chars));
    size_t count = 0;
    m_word_score = 0;
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray()) {
            chars[tile.position().index()] = tile.model().glyph();
            m_word_score += tile.model().effective_score();
            count++;
        }
    }
#if !ASSERT_DISABLED
    for (size_t idx = 0; idx < TileCount; idx++) {
        if (idx < count) {
            ASSERT(chars[idx] != SentinelGlyph);
        }
        else {
            ASSERT(chars[idx] == SentinelGlyph);
        }
    }
#endif
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

void SpellModel::append_to_word(const TilePosition &player_pos)
{
    ASSERT(player_pos.in_player_tray());
    TilePosition word_pos(TileTray::Word, word_length());
    Tile &tile = m_tiles[player_pos.index()];
    tile.set_position(word_pos);
}

void SpellModel::insert_into_word(const TilePosition &player_pos, const TilePosition &word_pos)
{
    ASSERT(is_word_tray_positioned_up_to(word_pos.index()));
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray() && tile.position().index() >= word_pos.index()) {
            // make room in word
            tile.set_position(tile.position().incremented());
        }
    }
    Tile &tile = m_tiles[player_pos.index()];
    tile.set_position(word_pos);
}

void SpellModel::remove_from_word(const TilePosition &word_pos)
{
    ASSERT(is_word_tray_positioned_up_to(word_pos.index()));
    
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        if (tile.in_word_tray()) {
            if (tile.position().index() == word_pos.index()) {
                // put back
                tile.set_position(TilePosition(TileTray::Player, it - m_tiles.begin()));
            }
            if (tile.position().index() > word_pos.index()) {
                // close up hole in word
                tile.set_position(tile.position().decremented());
            }
        }
    }
}

bool SpellModel::is_sentinel_filled() const
{
    for (auto &tile : m_tiles) {
        if (tile.model().is_sentinel<false>()) {
            return false;
        }
    }
    return true;
}

bool SpellModel::is_word_tray_positioned_up_to(TileIndex tile_idx) const
{
    std::array<bool, TileCount> marks;
    marks.fill(false);
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray()) {
            marks[tile.position().index()] = true;
        }
    }
    for (size_t idx = 0; idx < TileCount; idx++) {
        if (idx < tile_idx) {
            ASSERT(marks[idx]);
        }
        else {
            ASSERT(!marks[idx]);
        }
    }
    return true;
}

bool SpellModel::positions_valid() const
{
    int word_count = 0;
    std::array<bool, TileCount> marks;
    marks.fill(true);
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray()) {
            word_count++;
        }
        marks[tile.position().index()] = true;
    }
    if (word_count != word_length()) {
        ASSERT(false);
        return false;
    }
    for (auto &mark : marks) {
        ASSERT(mark);
        if (!mark) {
            return false;
        }
    }
    return true;
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
            apply_add(action);
            break;
        case Opcode::REMOVE:
            break;
        case Opcode::PICK:
            break;
        case Opcode::HOVER:
            break;
        case Opcode::DROP:
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

    return m_states.emplace_back(action, tiles(), score());
}

void SpellModel::apply_init(const Action &action)
{
    ASSERT(action.opcode() == Opcode::INIT);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos1());
    ASSERT(is_sentinel_filled());

    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        tile = Tile(tile.model(), TilePosition(TileTray::Player, it - m_tiles.begin()));
    }

    fill_player_tray();
    update_word();

    ASSERT(is_sentinel_filled<false>());
}

void SpellModel::apply_add(const Action &action)
{
    ASSERT(action.opcode() == Opcode::ADD);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT_POS(action.pos1());
    ASSERT(m_tiles[action.pos1().index()].in_player_tray());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

#if !ASSERT_DISABLED
    size_t in_word_length = word_length();
#endif

    append_to_word(action.pos1());
    update_word();

#if !ASSERT_DISABLED
    size_t out_word_length = word_length();
#endif

    ASSERT(positions_valid());
    ASSERT(in_word_length + 1 == out_word_length);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
}

void SpellModel::apply_submit(const Action &action)
{
    ASSERT(action.opcode() == Opcode::SUBMIT);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(word_length() > 0);
    ASSERT(word_in_lexicon());
    ASSERT(word_score() > 0);
    ASSERT(positions_valid());

    m_score += word_score();
    clear_and_sentinelize_word_tray();
    fill_player_tray();
    update_word();

    ASSERT(positions_valid());
    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(is_word_tray_positioned_up_to(word_length()));
}

void SpellModel::apply_reject(const Action &action)
{
    ASSERT(action.opcode() == Opcode::REJECT);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(word_length() > 0);
    ASSERT(word_score() > 0);
    ASSERT(!word_in_lexicon());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(positions_valid());
    
    // otherwise, a no-op
}

void SpellModel::apply_clear(const Action &action)
{
    ASSERT(action.opcode() == Opcode::CLEAR);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(word_length() > 0);
    ASSERT(word_score() > 0);
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(positions_valid());

    clear_word_tray();
    update_word();

    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(positions_valid());
}

void SpellModel::apply_dump(const Action &action)
{
    ASSERT(action.opcode() == Opcode::DUMP);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(positions_valid());

    clear_and_sentinelize();
    fill_player_tray();

    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(positions_valid());
}

}  // namespace UP
