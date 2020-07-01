//
//  UPSpellModel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <iomanip>
#import <string>
#import <sstream>

#import <sqlite3.h>

#import <UpKit/UPLexicon.h>
#import <UpKit/UPSqlite.h>
#import <UpKit/UPStringTools.h>
#import <UpKit/UPUtility.h>

#include "UPSpellModel.h"
#include "UPTileView.h"

namespace UP {

// =========================================================================================================================================
# pragma mark - Word

Word::Word(const TileArray &tiles) : m_tiles(tiles)
{
    char32_t chars[TileCount];
    bzero(chars, sizeof(chars));
    size_t count = 0;
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray()) {
            chars[tile.position().index()] = tile.model().glyph();
            m_score += tile.model().score();
            m_total_multiplier *= tile.model().multiplier();
            count++;
        }
    }
    m_total_score = m_score * m_total_multiplier;
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
    m_string = std::u32string(chars, count);
    switch (count) {
        default:
            // no bonus
            break;
        case 5:
            m_total_score += SpellModel::FiveLetterWordBonus;
            break;
        case 6:
            m_total_score += SpellModel::SixLetterWordBonus;
            break;
        case 7:
            m_total_score += SpellModel::SevenLetterWordBonus;
            break;
    }
    Lexicon &lexicon = Lexicon::instance();
    m_in_lexicon = count > 0 ? lexicon.contains(m_string) : false;
}

// =========================================================================================================================================
# pragma mark - Model functions

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

const Tile &SpellModel::find_tile(const TilePosition &pos) const
{
    switch (pos.tray()) {
        case TileTray::None: {
            ASSERT_NOT_REACHED();
            break;
        }
        case TileTray::Player: {
            return m_tiles[pos.index()];
        }
        case TileTray::Word: {
            for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
                const auto &tile = *it;
                if (tile.position() == pos) {
                    TileIndex idx = it - m_tiles.begin();
                    return m_tiles[idx];
                }
            }
            ASSERT_NOT_REACHED();
            static Tile tile;
            return tile;
        }
    }
}

Tile &SpellModel::find_tile(const TilePosition &pos)
{
    switch (pos.tray()) {
        case TileTray::None: {
            ASSERT_NOT_REACHED();
            break;
        }
        case TileTray::Player: {
            return m_tiles[pos.index()];
        }
        case TileTray::Word: {
            for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
                const auto &tile = *it;
                if (tile.position() == pos) {
                    TileIndex idx = it - m_tiles.begin();
                    return m_tiles[idx];
                }
            }
            ASSERT_NOT_REACHED();
            static Tile tile;
            return tile;
        }
    }
}

UPTileView *SpellModel::find_view(const TilePosition &pos)
{
    auto &tile = find_tile(pos);
    ASSERT(tile.has_view());
    return tile.view();
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

TileIndex SpellModel::player_tray_index(const TilePosition &pos)
{
    switch (pos.tray()) {
        case TileTray::None: {
            ASSERT_NOT_REACHED();
            break;
        }
        case TileTray::Player: {
            return pos.index();
        }
        case TileTray::Word: {
            for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
                const auto &tile = *it;
                if (tile.position() == pos) {
                    return it - m_tiles.begin();
                }
            }
            ASSERT_NOT_REACHED();
            return NotATileIndex;
        }
    }
}

NSArray *SpellModel::all_tile_views() const
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : tiles()) {
        if (tile.has_view()) {
            [array addObject:tile.view()];
        }
    }
    return array;
}

NSArray *SpellModel::player_tray_tile_views() const
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : tiles()) {
        if (tile.in_player_tray() && tile.has_view()) {
            [array addObject:tile.view()];
        }
    }
    return array;
}

NSArray *SpellModel::word_tray_tile_views() const
{
    NSMutableArray *array = [NSMutableArray array];
    for (const auto &tile : tiles()) {
        if (tile.in_word_tray() && tile.has_view()) {
            [array addObject:tile.view()];
        }
    }
    return array;
}

const SpellModel::State &SpellModel::back_state() const
{
    if (m_states.size()) {
        return m_states.back();
    }
    static State state;
    return state;
}

bool SpellModel::game_completed() const
{
    if (back_state().action().opcode() != Opcode::END) {
        return false;
    }
    
    for (auto it = states().rbegin(); it != states().rend(); ++it) {
        const State &state = *it;
        switch (state.action().opcode()) {
            case Opcode::START:
            case Opcode::PLAY:
            case Opcode::ADD:
            case Opcode::REMOVE:
            case Opcode::MOVE:
            case Opcode::PICK:
            case Opcode::HOVER:
            case Opcode::NOVER:
            case Opcode::DROP:
            case Opcode::SUBMIT:
            case Opcode::REJECT:
            case Opcode::CLEAR:
            case Opcode::DUMP:
            case Opcode::QUIT:
                return false;
            case Opcode::OVER:
                return true;
            case Opcode::NOP:
            case Opcode::END:
                // keep looking
                break;
        }
    }
    
    return false;
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

void SpellModel::clear_and_blank()
{
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        tile.set_model(TileModel::blank());
        tile.set_position(TilePosition(TileTray::Player, it - m_tiles.begin()));
        tile.clear_view();
    }
}

void SpellModel::update_word()
{
    m_word = Word(tiles());
}

void SpellModel::append_to_word(const TilePosition &player_pos)
{
    ASSERT(player_pos.in_player_tray());
    TilePosition word_pos(TileTray::Word, word().length());
    Tile &tile = m_tiles[player_pos.index()];
    tile.set_position(word_pos);
}

void SpellModel::insert_into_word(const TilePosition &player_pos, const TilePosition &word_pos)
{
    ASSERT(player_pos.in_player_tray());
    ASSERT(word_pos.in_word_tray());
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray() && tile.position().index() >= word_pos.index()) {
            // make room in word
            tile.set_position(tile.position().incremented());
        }
    }
    Tile &tile = m_tiles[player_pos.index()];
    tile.set_position(word_pos);
}

void SpellModel::add_to_word(const TilePosition &player_pos, const TilePosition &word_pos)
{
    ASSERT(player_pos.in_player_tray());
    ASSERT(word_pos.in_word_tray());
    if (word_pos.index() == word().length()) {
        append_to_word(player_pos);
    }
    else {
        insert_into_word(player_pos, word_pos);
    }
}

void SpellModel::remove_from_word(const TilePosition &word_pos)
{
    ASSERT(word_pos.in_word_tray());
    
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        if (tile.in_word_tray()) {
            if (tile.position().index() == word_pos.index()) {
                // put back
                tile.set_position(TilePosition(TileTray::Player, it - m_tiles.begin()));
            }
            else if (tile.position().index() > word_pos.index()) {
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

bool SpellModel::is_blank_filled() const
{
    for (auto &tile : m_tiles) {
        if (tile.model().is_blank<false>()) {
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
    }
    return true;
}

bool SpellModel::not_word_tray_positioned_after(TileIndex tile_idx) const
{
    std::array<bool, TileCount> marks;
    marks.fill(false);
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray()) {
            marks[tile.position().index()] = true;
        }
    }
    for (size_t idx = 0; idx < TileCount; idx++) {
        if (idx >= tile_idx) {
            ASSERT(!marks[idx]);
        }
    }
    return true;
}

bool SpellModel::is_player_tray_filled() const
{
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray()) {
            return false;
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
    if (word_count != word().length()) {
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

// =========================================================================================================================================
# pragma mark - Stringifiers

std::string SpellModel::cpp_str(Opcode opcode) const
{
    switch (opcode) {
        case Opcode::NOP:
            return "NOP";
        case Opcode::START:
            return "START";
        case Opcode::PLAY:
            return "PLAY";
        case Opcode::ADD:
            return "ADD";
        case Opcode::REMOVE:
            return "REMOVE";
        case Opcode::MOVE:
            return "MOVE";
        case Opcode::PICK:
            return "PICK";
        case Opcode::HOVER:
            return "HOVER";
        case Opcode::NOVER:
            return "NOVER";
        case Opcode::DROP:
            return "DROP";
        case Opcode::SUBMIT:
            return "SUBMIT";
        case Opcode::REJECT:
            return "REJECT";
        case Opcode::CLEAR:
            return "CLEAR";
        case Opcode::DUMP:
            return "DUMP";
        case Opcode::OVER:
            return "OVER";
        case Opcode::QUIT:
            return "QUIT";
        case Opcode::END:
            return "END";
    }
    ASSERT_NOT_REACHED();
}

std::string SpellModel::cpp_str(const State &state) const
{
    std::ostringstream sstr;

    sstr << std::fixed << std::setw(7) << std::setprecision(3) << std::setfill('0') << state.action().timestamp();
    sstr << ' ';
    sstr << cpp_str(state.action().opcode());
    const TilePosition &pos1 = state.action().pos1();
    if (pos1 != TilePosition()) {
        sstr << ' ';
        sstr << char_for(pos1.tray());
        sstr << '-';
        sstr << pos1.index();
    }
    const TilePosition &pos2 = state.action().pos2();
    if (pos2 != TilePosition()) {
        sstr << ' ';
        sstr << char_for(pos2.tray());
        sstr << '-';
        sstr << pos2.index();
    }
    if (state.action().opcode() == Opcode::SUBMIT) {
        sstr << ' ';
        sstr << UP::cpp_str(state.incoming_word().string());
        sstr << " (+";
        sstr << (state.incoming_word().score() * state.incoming_word().total_multiplier());
        sstr << ")";
    }
    
    return sstr.str();
}

// =========================================================================================================================================
# pragma mark - Apply

const SpellModel::State &SpellModel::apply(const Action &action)
{
    Word incoming_word = word();
    
    switch (action.opcode()) {
        case Opcode::NOP:
            // move along
            break;
        case Opcode::START:
            apply_start(action);
            break;
        case Opcode::PLAY:
            apply_play(action);
            break;
        case Opcode::ADD:
            apply_add(action);
            break;
        case Opcode::REMOVE:
            apply_remove(action);
            break;
        case Opcode::MOVE:
            apply_move(action);
            break;
        case Opcode::PICK:
            apply_pick(action);
            break;
        case Opcode::HOVER:
            apply_hover(action);
            break;
        case Opcode::NOVER:
            apply_nover(action);
            break;
        case Opcode::DROP:
            apply_drop(action);
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
            apply_over(action);
            break;
        case Opcode::QUIT:
            apply_quit(action);
            break;
        case Opcode::END:
            apply_end(action);
            break;
    }

    const State &state = m_states.emplace_back(action, incoming_word, tiles(), game_score());
    LOG(State, "%s", cpp_str(state).c_str());

    if (action.opcode() == Opcode::END) {
        db_store();
    }
    
    return state;
}

void SpellModel::apply_start(const Action &action)
{
    ASSERT(action.opcode() == Opcode::START);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos1());
    ASSERT(is_sentinel_filled());
    
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        tile = Tile(TileModel::blank(), TilePosition(TileTray::Player, it - m_tiles.begin()));
    }
    
    update_word();
    
    ASSERT(is_blank_filled<true>());
}

void SpellModel::apply_play(const Action &action)
{
    ASSERT(action.opcode() == Opcode::PLAY);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos1());
    ASSERT(is_blank_filled());
    
    clear_and_sentinelize();
    fill_player_tray();
    
    for (auto it = m_tiles.begin(); it != m_tiles.end(); ++it) {
        auto &tile = *it;
        tile = Tile(tile.model(), TilePosition(TileTray::Player, it - m_tiles.begin()));
    }
    
    update_word();
    
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_blank_filled<false>());
}

void SpellModel::apply_add(const Action &action)
{
    ASSERT(action.opcode() == Opcode::ADD);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT_POS(action.pos1());
    ASSERT(m_tiles[action.pos1().index()].in_player_tray());
    ASSERT_POS(action.pos2());
    ASSERT(action.pos2().in_word_tray());
    ASSERT(positions_valid());

#if !ASSERT_DISABLED
    size_t in_word_length = word().length();
#endif

    const TilePosition &player_pos = action.pos1();
    const TilePosition &word_pos = action.pos2();

    add_to_word(player_pos, word_pos);
    update_word();

#if !ASSERT_DISABLED
    size_t out_word_length = word().length();
#endif

    ASSERT(positions_valid());
    ASSERT(in_word_length + 1 == out_word_length);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
}

void SpellModel::apply_remove(const Action &action)
{
    ASSERT(action.opcode() == Opcode::REMOVE);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT(not_word_tray_positioned_after(word().length()));
    ASSERT_POS(action.pos1());
    ASSERT(action.pos1().in_word_tray());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());
    ASSERT(is_sentinel_filled<false>());
    ASSERT(word().length() > 0);
    ASSERT(word().score() > 0);

#if !ASSERT_DISABLED
    size_t in_word_length = word().length();
#endif

    remove_from_word(action.pos1());
    update_word();

#if !ASSERT_DISABLED
    size_t out_word_length = word().length();
#endif

    ASSERT(positions_valid());
    ASSERT(in_word_length - 1 == out_word_length);
    ASSERT(is_word_tray_positioned_up_to(word().length()));
}

void SpellModel::apply_move(const Action &action)
{
    ASSERT(action.opcode() == Opcode::MOVE);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT(not_word_tray_positioned_after(word().length()));
    ASSERT_POS(action.pos1());
    ASSERT_POS(action.pos2());
    ASSERT(action.pos1().in_word_tray());
    ASSERT(action.pos2().in_word_tray());
    ASSERT(action.pos1() != action.pos2());
    ASSERT(positions_valid());
    ASSERT(is_sentinel_filled<false>());
    ASSERT(word().length() > 0);
    ASSERT(word().score() > 0);

#if !ASSERT_DISABLED
    size_t in_word_length = word().length();
#endif

    TilePosition player_pos(TileTray::Player, player_tray_index(action.pos1()));

    remove_from_word(action.pos1());
    insert_into_word(player_pos, action.pos2());

    update_word();

#if !ASSERT_DISABLED
    size_t out_word_length = word().length();
#endif

    ASSERT(positions_valid());
    ASSERT(in_word_length == out_word_length);
    ASSERT(is_word_tray_positioned_up_to(word().length()));
}
 
void SpellModel::apply_pick(const Action &action)
{
    ASSERT(action.opcode() == Opcode::PICK);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT_POS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    // otherwise, a no-op
}

void SpellModel::apply_hover(const Action &action)
{
    ASSERT(action.opcode() == Opcode::HOVER);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT_POS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    // otherwise, a no-op
}

void SpellModel::apply_nover(const Action &action)
{
    ASSERT(action.opcode() == Opcode::NOVER);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    // otherwise, a no-op
}

void SpellModel::apply_drop(const Action &action)
{
}

void SpellModel::apply_submit(const Action &action)
{
    ASSERT(action.opcode() == Opcode::SUBMIT);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT(word().length() > 0);
    ASSERT(word().in_lexicon());
    ASSERT(word().score() > 0);
    ASSERT(positions_valid());

    m_game_score += word().total_score();
    clear_and_sentinelize_word_tray();
    fill_player_tray();
    update_word();

    ASSERT(positions_valid());
    ASSERT(word().length() == 0);
    ASSERT(!word().in_lexicon());
    ASSERT(word().score() == 0);
    ASSERT(is_word_tray_positioned_up_to(word().length()));
}

void SpellModel::apply_reject(const Action &action)
{
    ASSERT(action.opcode() == Opcode::REJECT);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(word().length() > 0);
    ASSERT(word().score() > 0);
    ASSERT(!word().in_lexicon());
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT(positions_valid());
    
    // otherwise, a no-op
}

void SpellModel::apply_clear(const Action &action)
{
    ASSERT(action.opcode() == Opcode::CLEAR);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(word().length() > 0);
    ASSERT(word().score() > 0);
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT(positions_valid());

    clear_word_tray();
    update_word();

    ASSERT(word().length() == 0);
    ASSERT(!word().in_lexicon());
    ASSERT(word().score() == 0);
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT(positions_valid());
}

void SpellModel::apply_dump(const Action &action)
{
    ASSERT(action.opcode() == Opcode::DUMP);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(word().length() == 0);
    ASSERT(!word().in_lexicon());
    ASSERT(word().score() == 0);
    ASSERT(positions_valid());

    clear_and_sentinelize();
    fill_player_tray();

    ASSERT(word().length() == 0);
    ASSERT(!word().in_lexicon());
    ASSERT(word().score() == 0);
    ASSERT(positions_valid());
}

void SpellModel::apply_over(const Action &action)
{
    ASSERT(action.opcode() == Opcode::OVER);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    clear_word_tray();
    update_word();

    ASSERT(word().length() == 0);
    ASSERT(!word().in_lexicon());
    ASSERT(word().score() == 0);
    ASSERT(is_word_tray_positioned_up_to(word().length()));
    ASSERT(positions_valid());
}

void SpellModel::apply_quit(const Action &action)
{
    ASSERT(action.opcode() == Opcode::QUIT);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());
}

void SpellModel::apply_end(const Action &action)
{
    ASSERT(action.opcode() == Opcode::END);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    clear_and_blank();
    m_word = Word();
}

// =========================================================================================================================================
# pragma mark - Stats

std::vector<Word> SpellModel::highest_scoring_word() const
{
    std::vector<Word> result;
    int highest_score = 0;
    for (const auto &state : states()) {
        if (state.action().opcode() != Opcode::SUBMIT) {
            continue;
        }
        const Word &state_word = state.incoming_word();
        if (state_word.total_score() > highest_score) {
            highest_score = state_word.total_score();
            result.clear();
            result.push_back(state_word);
        }
        else if (state_word.total_score() == highest_score) {
            result.push_back(state_word);
        }
    }
    return result;
}

std::vector<Word> SpellModel::highest_scoring_word_with_length(size_t length) const
{
    std::vector<Word> result;
    int highest_score = 0;
    for (const auto &state : states()) {
        if (state.action().opcode() != Opcode::SUBMIT) {
            continue;
        }
        const Word &state_word = state.incoming_word();
        if (state_word.length() != length) {
            continue;
        }
        if (state_word.total_score() > highest_score) {
            highest_score = state_word.total_score();
            result.clear();
            result.push_back(state_word);
        }
        else if (state_word.total_score() == highest_score) {
            result.push_back(state_word);
        }
    }
    return result;
}

// =========================================================================================================================================
# pragma mark - High-level Database

void SpellModel::db_store()
{
    sqlite3 *db = db_handle();
    
    static const char *game_sql =
        "INSERT INTO game (game_key, game_completed) VALUES (?, ?);";
    static const char *tile_initial_sql =
        "INSERT INTO tile(tile_id, \n"
            "tile_glyph_0, tile_multiplier_0, tile_word_pos_0,\n"
            "tile_glyph_1, tile_multiplier_1, tile_word_pos_1,\n"
            "tile_glyph_2, tile_multiplier_2, tile_word_pos_2,\n"
            "tile_glyph_3, tile_multiplier_3, tile_word_pos_3,\n"
            "tile_glyph_4, tile_multiplier_4, tile_word_pos_4,\n"
            "tile_glyph_5, tile_multiplier_5, tile_word_pos_5,\n"
            "tile_glyph_6, tile_multiplier_6, tile_word_pos_6,\n"
            "tile_game_id) \n"
        "VALUES(0,\n"
            "0, 1, -1, \n"
            "0, 1, -1, \n"
            "0, 1, -1, \n"
            "0, 1, -1, \n"
            "0, 1, -1, \n"
            "0, 1, -1, \n"
            "0, 1, -1, \n"
            "?);";
    static const char *tile_state_sql =
        "INSERT INTO tile(\n"
            "tile_glyph_0, tile_multiplier_0, tile_word_pos_0,\n"
            "tile_glyph_1, tile_multiplier_1, tile_word_pos_1,\n"
            "tile_glyph_2, tile_multiplier_2, tile_word_pos_2,\n"
            "tile_glyph_3, tile_multiplier_3, tile_word_pos_3,\n"
            "tile_glyph_4, tile_multiplier_4, tile_word_pos_4,\n"
            "tile_glyph_5, tile_multiplier_5, tile_word_pos_5,\n"
            "tile_glyph_6, tile_multiplier_6, tile_word_pos_6,\n"
            "tile_game_id) \n"
        "VALUES(\n"
            "?, ?, ?, \n"
            "?, ?, ?, \n"
            "?, ?, ?, \n"
            "?, ?, ?, \n"
            "?, ?, ?, \n"
            "?, ?, ?, \n"
            "?, ?, ?, \n"
            "?);";
    static const char *state_sql =
        "INSERT INTO state(state_opcode, state_timestamp,\n"
            "state_incoming_word, state_incoming_word_length, state_incoming_word_score,\n"
            "state_incoming_word_multiplier, state_incoming_word_total_score, state_incoming_word_in_lexicon,\n"
            "state_outgoing_game_score,\n"
            "state_game_id, state_incoming_tile_id, state_outgoing_tile_id) \n"
        "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    static const char *word_sql =
        "INSERT INTO word(word_string, word_length, word_score, word_total_multiplier, word_total_score,\n"
            "word_game_id, word_state_id, word_tile_id) \n"
        "VALUES(?, ?, ?, ?, ?, ?, ?, ?);";

    static sqlite3_stmt *game_stmt;
    static sqlite3_stmt *tile_initial_stmt;
    static sqlite3_stmt *tile_state_stmt;
    static sqlite3_stmt *state_stmt;
    static sqlite3_stmt *word_stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(db, sqlite3_prepare_v2(db, game_sql, (int)strlen(game_sql), &game_stmt, nullptr));
        db_exec(db, sqlite3_prepare_v2(db, tile_initial_sql, (int)strlen(tile_initial_sql), &tile_initial_stmt, nullptr));
        db_exec(db, sqlite3_prepare_v2(db, tile_state_sql, (int)strlen(tile_state_sql), &tile_state_stmt, nullptr));
        db_exec(db, sqlite3_prepare_v2(db, state_sql, (int)strlen(state_sql), &state_stmt, nullptr));
        db_exec(db, sqlite3_prepare_v2(db, word_sql, (int)strlen(word_sql), &word_stmt, nullptr));
    });
    
    if (db == nullptr) {
        return;
    }

    db_begin_transaction(db);
    
    db_exec(db, sqlite3_reset(game_stmt));
    db_exec(db, sqlite3_bind_int(game_stmt, 1, game_key().value()));
    db_exec(db, sqlite3_bind_int(game_stmt, 2, game_completed() ? 1 : 0));
    db_step(db, sqlite3_step(game_stmt));
    set_db_game_id(sqlite3_last_insert_rowid(db));
    LOG(DB, "*** game id: %ld : %s", db_game_id(), game_completed() ? "Y" : "N");
    
    db_exec(db, sqlite3_reset(tile_initial_stmt));
    db_exec(db, sqlite3_bind_int64(tile_initial_stmt, 1, db_game_id()));
    db_step(db, sqlite3_step(tile_initial_stmt));
    uint64_t incoming_tiles_id = sqlite3_last_insert_rowid(db);

    for (const auto &state : states()) {
        db_exec(db, sqlite3_reset(tile_state_stmt));
        int tiles_bind_idx = 1;
        for (const auto &tile : state.outgoing_tiles()) {
            db_exec(db, sqlite3_bind_int(tile_state_stmt, tiles_bind_idx, tile.model().glyph()));
            tiles_bind_idx++;
            db_exec(db, sqlite3_bind_int(tile_state_stmt, tiles_bind_idx, tile.model().multiplier()));
            tiles_bind_idx++;
            db_exec(db, sqlite3_bind_int(tile_state_stmt, tiles_bind_idx, tile.in_word_tray() ? (int)tile.position().index() : -1));
            tiles_bind_idx++;
        }
        db_exec(db, sqlite3_bind_int64(tile_state_stmt, tiles_bind_idx, db_game_id()));
        db_step(db, sqlite3_step(tile_state_stmt));
        uint64_t outgoing_tiles_id = sqlite3_last_insert_rowid(db);

        const Word &incoming_word = state.incoming_word();
        db_exec(db, sqlite3_reset(state_stmt));
        db_exec(db, sqlite3_bind_int(state_stmt, 1, (int)state.action().opcode()));
        db_exec(db, sqlite3_bind_double(state_stmt, 2, state.action().timestamp()));
        db_exec(db, sqlite3_bind_text(state_stmt, 3, UP::cpp_str(incoming_word.string()).c_str(), -1, nullptr));
        db_exec(db, sqlite3_bind_int64(state_stmt, 4, incoming_word.string().length()));
        db_exec(db, sqlite3_bind_int(state_stmt, 5, incoming_word.score()));
        db_exec(db, sqlite3_bind_int(state_stmt, 6, incoming_word.total_multiplier()));
        db_exec(db, sqlite3_bind_int(state_stmt, 7, incoming_word.total_score()));
        db_exec(db, sqlite3_bind_int(state_stmt, 8, incoming_word.in_lexicon() ? 1 : 0));
        db_exec(db, sqlite3_bind_int(state_stmt, 9, state.outgoing_game_score()));
        db_exec(db, sqlite3_bind_int64(state_stmt, 10, db_game_id()));
        db_exec(db, sqlite3_bind_int64(state_stmt, 11, incoming_tiles_id));
        db_exec(db, sqlite3_bind_int64(state_stmt, 12, outgoing_tiles_id));
        db_step(db, sqlite3_step(state_stmt));
        uint64_t state_id = sqlite3_last_insert_rowid(db);

        if (state.action().opcode() == Opcode::SUBMIT) {
            db_exec(db, sqlite3_reset(word_stmt));
            db_exec(db, sqlite3_bind_text(word_stmt, 1, UP::cpp_str(incoming_word.string()).c_str(), -1, nullptr));
            db_exec(db, sqlite3_bind_int64(word_stmt, 2, incoming_word.string().length()));
            db_exec(db, sqlite3_bind_int(word_stmt, 3, incoming_word.score()));
            db_exec(db, sqlite3_bind_int(word_stmt, 4, incoming_word.total_multiplier()));
            db_exec(db, sqlite3_bind_int(word_stmt, 5, incoming_word.total_score()));
            db_exec(db, sqlite3_bind_int64(word_stmt, 6, db_game_id()));
            db_exec(db, sqlite3_bind_int64(word_stmt, 7, state_id));
            db_exec(db, sqlite3_bind_int64(word_stmt, 8, incoming_tiles_id));
            db_step(db, sqlite3_step(word_stmt));
        }

        incoming_tiles_id = outgoing_tiles_id;
    }
    
    db_commit_transaction(db);
}

// =========================================================================================================================================
# pragma mark - Low-level Database

sqlite3 *SpellModel::db_handle()
{
    static sqlite3 *db = nullptr;
    if (db == nullptr) {
        NSArray *possibleURLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        if (possibleURLs.count > 0) {
            NSURL *documentDirectoryURL = [possibleURLs objectAtIndex:0];
            NSURL *dbFileURL = [documentDirectoryURL URLByAppendingPathComponent:@"up-spell.sql"];
            const char *db_filename = [[dbFileURL path] fileSystemRepresentation];
            LOG(DB, "db_filename: %s", db_filename);
            int rc = sqlite3_open(db_filename, &db);
            if (rc == SQLITE_OK) {
                db_create_if_needed(db);
            }
            else {
                LOG(DB, "*** failed to open database: %d", rc);
            }
        }
    }
    return db;
}

void SpellModel::db_create_if_needed(sqlite3 *db)
{
    if (db == nullptr) {
        return;
    }
    
    static const char *sql =
        "PRAGMA foreign_keys = ON;"
        "CREATE TABLE IF NOT EXISTS game (\n"
        "    game_id INTEGER PRIMARY KEY ASC,\n"
        "    game_key INTEGER,\n"
        "    game_completed INTEGER\n"
        ");\n"
        "CREATE TABLE IF NOT EXISTS tile (\n"
        "    tile_id INTEGER PRIMARY KEY ASC,\n"
        "    tile_glyph_0 INTEGER NOT NULL,\n"
        "    tile_multiplier_0 INTEGER NOT NULL,\n"
        "    tile_word_pos_0 INTEGER NOT NULL,\n"
        "    tile_glyph_1 INTEGER NOT NULL,\n"
        "    tile_multiplier_1 INTEGER NOT NULL,\n"
        "    tile_word_pos_1 INTEGER NOT NULL,\n"
        "    tile_glyph_2 INTEGER NOT NULL,\n"
        "    tile_multiplier_2 INTEGER NOT NULL,\n"
        "    tile_word_pos_2 INTEGER NOT NULL,\n"
        "    tile_glyph_3 INTEGER NOT NULL,\n"
        "    tile_multiplier_3 INTEGER NOT NULL,\n"
        "    tile_word_pos_3 INTEGER NOT NULL,\n"
        "    tile_glyph_4 INTEGER NOT NULL,\n"
        "    tile_multiplier_4 INTEGER NOT NULL,\n"
        "    tile_word_pos_4 INTEGER NOT NULL,\n"
        "    tile_glyph_5 INTEGER NOT NULL,\n"
        "    tile_multiplier_5 INTEGER NOT NULL,\n"
        "    tile_word_pos_5 INTEGER NOT NULL,\n"
        "    tile_glyph_6 INTEGER NOT NULL,\n"
        "    tile_multiplier_6 INTEGER NOT NULL,\n"
        "    tile_word_pos_6 INTEGER NOT NULL,\n"
        "    tile_game_id INTEGER,\n"
        "    FOREIGN KEY(tile_game_id) REFERENCES game(game_id) ON DELETE CASCADE,\n"
        "    UNIQUE(tile_game_id, tile_id)\n"
        ");\n"
        "CREATE TABLE IF NOT EXISTS state (\n"
        "    state_id INTEGER PRIMARY KEY ASC,\n"
        "    state_opcode INTEGER NOT NULL,\n"
        "    state_timestamp REAL NOT NULL,\n"
        "    state_incoming_word TEXT NOT NULL,\n"
        "    state_incoming_word_length INTEGER NOT NULL,\n"
        "    state_incoming_word_score INTEGER NOT NULL,\n"
        "    state_incoming_word_multiplier INTEGER NOT NULL,\n"
        "    state_incoming_word_total_score INTEGER NOT NULL,\n"
        "    state_incoming_word_in_lexicon INTEGER NOT NULL,\n"
        "    state_outgoing_game_score INTEGER NOT NULL,\n"
        "    state_game_id INTEGER,\n"
        "    state_incoming_tile_id INTEGER,\n"
        "    state_outgoing_tile_id INTEGER,\n"
        "    FOREIGN KEY(state_game_id) REFERENCES game(game_id) ON DELETE CASCADE,\n"
        "    FOREIGN KEY(state_incoming_tile_id) REFERENCES tile(tile_id) ON DELETE CASCADE,\n"
        "    FOREIGN KEY(state_outgoing_tile_id) REFERENCES tile(tile_id) ON DELETE CASCADE,\n"
        "    UNIQUE(state_game_id, state_id),\n"
        "    UNIQUE(state_game_id, state_incoming_tile_id, state_outgoing_tile_id)\n"
        ");\n"
        "CREATE INDEX IF NOT EXISTS submit_idx ON state(state_opcode) WHERE state.state_opcode = 10;\n"
        "CREATE INDEX IF NOT EXISTS end_idx ON state(state_opcode) WHERE state.state_opcode = 16;\n"
        "CREATE TABLE IF NOT EXISTS word (\n"
        "    word_id INTEGER PRIMARY KEY ASC,\n"
        "    word_string TEXT NOT NULL,\n"
        "    word_length INTEGER NOT NULL,\n"
        "    word_score INTEGER NOT NULL,\n"
        "    word_total_multiplier INTEGER NOT NULL,\n"
        "    word_total_score INTEGER NOT NULL,\n"
        "    word_game_id INTEGER,\n"
        "    word_state_id INTEGER,\n"
        "    word_tile_id INTEGER,\n"
        "    FOREIGN KEY(word_game_id) REFERENCES game(game_id) ON DELETE CASCADE,\n"
        "    FOREIGN KEY(word_state_id) REFERENCES state(state_id) ON DELETE CASCADE,\n"
        "    FOREIGN KEY(word_tile_id) REFERENCES tile(tile_id) ON DELETE CASCADE,\n"
        "    UNIQUE(word_game_id, word_state_id, word_tile_id)\n"
        ");\n"
        "CREATE INDEX IF NOT EXISTS word_string_idx ON word(word_string);\n"
        "CREATE INDEX IF NOT EXISTS word_length_idx ON word(word_length);\n"
        "CREATE INDEX IF NOT EXISTS word_score_idx ON word(word_score);\n"
        "CREATE INDEX IF NOT EXISTS word_total_multiplier_idx ON word(word_total_multiplier);\n"
        "CREATE INDEX IF NOT EXISTS word_total_score_idx ON word(word_total_score);\n"
        "CREATE INDEX IF NOT EXISTS word_string_length_idx ON word(word_string, word_length);\n"
        "CREATE INDEX IF NOT EXISTS word_string_score_idx ON word(word_string, word_score);\n"
        "CREATE INDEX IF NOT EXISTS word_string_total_multiplier_idx ON word(word_string, word_total_multiplier);\n"
        "CREATE INDEX IF NOT EXISTS word_string_total_score_idx ON word(word_string, word_total_score);\n";
    char *errmsg;
    int rc = sqlite3_exec(db, sql, nullptr, nullptr, &errmsg);
    if (rc != SQLITE_OK) {
        LOG(DB, "*** error creating database: %s", errmsg);
    }
}

}  // namespace UP
