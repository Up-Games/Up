//
//  UPSpellModel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <iomanip>
#import <string>
#import <sstream>

#import <sqlite3.h>

#import <UpKit/UPLexicon.h>
#import <UpKit/UPStringTools.h>
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
    char32_t chars[TileCount];
    bzero(chars, sizeof(chars));
    size_t count = 0;
    m_word_score = 0;
    m_word_multiplier = 1;
    m_word_total_score = 0;
    for (auto &tile : m_tiles) {
        if (tile.in_word_tray()) {
            chars[tile.position().index()] = tile.model().glyph();
            m_word_score += tile.model().score();
            m_word_multiplier *= tile.model().multiplier();
            count++;
        }
    }
    m_word_total_score = m_word_score * m_word_multiplier;
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
            m_word_total_score += FiveLetterWordBonus;
            break;
        case 6:
            m_word_total_score += SixLetterWordBonus;
            break;
        case 7:
            m_word_total_score += SevenLetterWordBonus;
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
    if (word_pos.index() == word_length()) {
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
        sstr << UP::cpp_str(state.incoming_word_string());
        sstr << " (+";
        sstr << (state.incoming_word_score() * state.incoming_word_multiplier());
        sstr << ")";
    }
    
    return sstr.str();
}

const SpellModel::State &SpellModel::apply(const Action &action)
{
    SpellModel::db_handle();

    std::u32string incoming_word_string = word_string();
    int incoming_word_score = word_score();
    int incoming_word_multiplier = word_multiplier();
    int incoming_word_total_score = word_total_score();
    bool incoming_word_in_lexicon = word_in_lexicon();
    
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

    const State &state = m_states.emplace_back(action, incoming_word_string, incoming_word_score, incoming_word_multiplier,
                                               incoming_word_total_score, incoming_word_in_lexicon,
                                               tiles(), game_score());
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
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT_POS(action.pos1());
    ASSERT(m_tiles[action.pos1().index()].in_player_tray());
    ASSERT_POS(action.pos2());
    ASSERT(action.pos2().in_word_tray());
    ASSERT(positions_valid());

#if !ASSERT_DISABLED
    size_t in_word_length = word_length();
#endif

    const TilePosition &player_pos = action.pos1();
    const TilePosition &word_pos = action.pos2();

    add_to_word(player_pos, word_pos);
    update_word();

#if !ASSERT_DISABLED
    size_t out_word_length = word_length();
#endif

    ASSERT(positions_valid());
    ASSERT(in_word_length + 1 == out_word_length);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
}

void SpellModel::apply_remove(const Action &action)
{
    ASSERT(action.opcode() == Opcode::REMOVE);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(not_word_tray_positioned_after(word_length()));
    ASSERT_POS(action.pos1());
    ASSERT(action.pos1().in_word_tray());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());
    ASSERT(is_sentinel_filled<false>());
    ASSERT(word_length() > 0);
    ASSERT(word_score() > 0);

#if !ASSERT_DISABLED
    size_t in_word_length = word_length();
#endif

    remove_from_word(action.pos1());
    update_word();

#if !ASSERT_DISABLED
    size_t out_word_length = word_length();
#endif

    ASSERT(positions_valid());
    ASSERT(in_word_length - 1 == out_word_length);
    ASSERT(is_word_tray_positioned_up_to(word_length()));
}

void SpellModel::apply_move(const Action &action)
{
    ASSERT(action.opcode() == Opcode::MOVE);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(not_word_tray_positioned_after(word_length()));
    ASSERT_POS(action.pos1());
    ASSERT_POS(action.pos2());
    ASSERT(action.pos1().in_word_tray());
    ASSERT(action.pos2().in_word_tray());
    ASSERT(action.pos1() != action.pos2());
    ASSERT(positions_valid());
    ASSERT(is_sentinel_filled<false>());
    ASSERT(word_length() > 0);
    ASSERT(word_score() > 0);

#if !ASSERT_DISABLED
    size_t in_word_length = word_length();
#endif

    TilePosition player_pos(TileTray::Player, player_tray_index(action.pos1()));

    remove_from_word(action.pos1());
    insert_into_word(player_pos, action.pos2());

    update_word();

#if !ASSERT_DISABLED
    size_t out_word_length = word_length();
#endif

    ASSERT(positions_valid());
    ASSERT(in_word_length == out_word_length);
    ASSERT(is_word_tray_positioned_up_to(word_length()));
}
 
void SpellModel::apply_pick(const Action &action)
{
    ASSERT(action.opcode() == Opcode::PICK);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT_POS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    // otherwise, a no-op
}

void SpellModel::apply_hover(const Action &action)
{
    ASSERT(action.opcode() == Opcode::HOVER);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT_POS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    // otherwise, a no-op
}

void SpellModel::apply_nover(const Action &action)
{
    ASSERT(action.opcode() == Opcode::NOVER);
    ASSERT(is_sentinel_filled<false>());
    ASSERT(is_word_tray_positioned_up_to(word_length()));
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
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(word_length() > 0);
    ASSERT(word_in_lexicon());
    ASSERT(word_score() > 0);
    ASSERT(positions_valid());

    m_game_score += word_total_score();
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

void SpellModel::apply_over(const Action &action)
{
    ASSERT(action.opcode() == Opcode::OVER);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    clear_word_tray();
    update_word();

    ASSERT(word_length() == 0);
    ASSERT(!word_in_lexicon());
    ASSERT(word_score() == 0);
    ASSERT(is_word_tray_positioned_up_to(word_length()));
    ASSERT(positions_valid());
}

void SpellModel::apply_quit(const Action &action)
{
    ASSERT(action.opcode() == Opcode::QUIT);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());
    
    m_word_in_lexicon = false;
}

void SpellModel::apply_end(const Action &action)
{
    ASSERT(action.opcode() == Opcode::END);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());

    clear_and_blank();
    m_word_score = 0;
    m_word_multiplier = 1;
    m_word_total_score = 0;
    m_word_string = U"";
    m_word_in_lexicon = false;
}

// =========================================================================================================================================

#define db_exec(S) ({ \
    int rc = S; \
    if (rc != SQLITE_OK) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_close(db_handle()); \
        return; \
    } \
})

#define db_step(S) ({ \
    int rc = S; \
    if (rc != SQLITE_DONE) { \
        LOG(DB, "*** database error: %d: %s:%d", rc, __FILE__, __LINE__); \
        db_rollback_transaction(db_handle()); \
        db_close(db_handle()); \
        return; \
    } \
})


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
        "CREATE TABLE IF NOT EXISTS game (\n"
        "    game_id INTEGER PRIMARY KEY ASC,\n"
        "    game_key INTEGER\n"
        ");\n"
        "CREATE TABLE IF NOT EXISTS state (\n"
        "    state_id INTEGER PRIMARY KEY ASC,\n"
        "    state_game_id INTEGER,\n"
        "    state_opcode INTEGER NOT NULL,\n"
        "    state_timestamp REAL NOT NULL,\n"
        "    state_incoming_word TEXT NOT NULL,\n"
        "    state_incoming_word_length INTEGER NOT NULL,\n"
        "    state_incoming_word_score INTEGER NOT NULL,\n"
        "    state_incoming_word_multiplier INTEGER NOT NULL,\n"
        "    state_incoming_word_total_score INTEGER NOT NULL,\n"
        "    state_incoming_word_in_lexicon INTEGER NOT NULL,\n"
        "    state_outgoing_game_score INTEGER NOT NULL,\n"
        "    state_outgoing_tile_0_glyph INTEGER NOT NULL,\n"
        "    state_outgoing_tile_0_word_pos INTEGER NOT NULL,\n"
        "    state_outgoing_tile_1_glyph INTEGER NOT NULL,\n"
        "    state_outgoing_tile_1_word_pos INTEGER NOT NULL,\n"
        "    state_outgoing_tile_2_glyph INTEGER NOT NULL,\n"
        "    state_outgoing_tile_2_word_pos INTEGER NOT NULL,\n"
        "    state_outgoing_tile_3_glyph INTEGER NOT NULL,\n"
        "    state_outgoing_tile_3_word_pos INTEGER NOT NULL,\n"
        "    state_outgoing_tile_4_glyph INTEGER NOT NULL,\n"
        "    state_outgoing_tile_4_word_pos INTEGER NOT NULL,\n"
        "    state_outgoing_tile_5_glyph INTEGER NOT NULL,\n"
        "    state_outgoing_tile_5_word_pos INTEGER NOT NULL,\n"
        "    state_outgoing_tile_6_glyph INTEGER NOT NULL,\n"
        "    state_outgoing_tile_6_word_pos INTEGER NOT NULL,\n"
        "    FOREIGN KEY(state_game_id) REFERENCES game(game_id) ON DELETE CASCADE\n"
        ");\n"
        "CREATE INDEX IF NOT EXISTS submit ON state (state_opcode) WHERE state.state_opcode = 10;\n"
        "CREATE INDEX IF NOT EXISTS end ON state (state_opcode) WHERE state.state_opcode = 16;\n";

    char *errmsg;
    int rc = sqlite3_exec(db, sql, nullptr, nullptr, &errmsg);
    if (rc != SQLITE_OK) {
        LOG(DB, "*** error creating database: %s", errmsg);
    }
}

void SpellModel::db_close(sqlite3 *db)
{
    if (db == nullptr) {
        return;
    }

    int rc = sqlite3_close(db);
    if (rc != SQLITE_OK) {
        LOG(DB, "*** error closing database: %d", rc);
    }
    
    db = nullptr;
}

void SpellModel::db_store()
{
    sqlite3 *db = db_handle();

    static const char *game_sql =
        "INSERT INTO game (game_key) VALUES (?);";
    static const char *state_sql =
        "INSERT INTO state(state_game_id, state_opcode, state_timestamp, "
        "state_incoming_word, state_incoming_word_length, state_incoming_word_score, "
        "state_incoming_word_multiplier, state_incoming_word_total_score, state_incoming_word_in_lexicon, "
        "state_outgoing_game_score, "
        "state_outgoing_tile_0_glyph, state_outgoing_tile_0_word_pos, "
        "state_outgoing_tile_1_glyph, state_outgoing_tile_1_word_pos, "
        "state_outgoing_tile_2_glyph, state_outgoing_tile_2_word_pos, "
        "state_outgoing_tile_3_glyph, state_outgoing_tile_3_word_pos, "
        "state_outgoing_tile_4_glyph, state_outgoing_tile_4_word_pos, "
        "state_outgoing_tile_5_glyph, state_outgoing_tile_5_word_pos, "
        "state_outgoing_tile_6_glyph, state_outgoing_tile_6_word_pos)\n"
        "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
    static sqlite3_stmt *game_stmt;
    static sqlite3_stmt *state_stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(sqlite3_prepare_v2(db, game_sql, (int)strlen(game_sql), &game_stmt, nullptr));
        db_exec(sqlite3_prepare_v2(db, state_sql, (int)strlen(state_sql), &state_stmt, nullptr));
    });

    if (db == nullptr) {
        return;
    }

    db_begin_transaction(db);
    
    db_exec(sqlite3_reset(game_stmt));
    db_exec(sqlite3_bind_int(game_stmt, 1, game_key().value()));
    db_step(sqlite3_step(game_stmt));
    set_db_game_id(sqlite3_last_insert_rowid(db));
    LOG(DB, "*** game id: %ld", db_game_id());

    for (const auto &state : states()) {
        const TileArray &outgoing_tiles = state.outgoing_tiles();
        db_exec(sqlite3_reset(state_stmt));
        db_exec(sqlite3_bind_int64(state_stmt, 1, db_game_id()));
        db_exec(sqlite3_bind_int(state_stmt, 2, (int)state.action().opcode()));
        db_exec(sqlite3_bind_double(state_stmt, 3, state.action().timestamp()));
        db_exec(sqlite3_bind_text(state_stmt, 4, UP::cpp_str(state.incoming_word_string()).c_str(), -1, nullptr));
        db_exec(sqlite3_bind_int64(state_stmt, 5, state.incoming_word_string().length()));
        db_exec(sqlite3_bind_int(state_stmt, 6, state.incoming_word_score()));
        db_exec(sqlite3_bind_int(state_stmt, 7, state.incoming_word_multiplier()));
        db_exec(sqlite3_bind_int(state_stmt, 8, state.incoming_word_total_score()));
        db_exec(sqlite3_bind_int(state_stmt, 9, state.incoming_word_in_lexicon() ? 1 : 0));
        db_exec(sqlite3_bind_int(state_stmt, 10, state.outgoing_game_score()));
        int bind_index = 11;
        for (const Tile &tile : outgoing_tiles) {
            db_exec(sqlite3_bind_int(state_stmt, bind_index, tile.model().glyph()));
            bind_index++;
            db_exec(sqlite3_bind_int(state_stmt, bind_index, tile.in_word_tray() ? (int)tile.position().index() : -1));
            bind_index++;
        }
        db_step(sqlite3_step(state_stmt));
    }
    
    db_commit_transaction(db);
}

void SpellModel::db_begin_transaction(sqlite3 *db)
{
    static const char *sql = "BEGIN TRANSACTION;";
    static sqlite3_stmt *stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(sqlite3_prepare_v2(db, sql, (int)strlen(sql), &stmt, nullptr));
    });

    if (db == nullptr) {
        return;
    }
    db_exec(sqlite3_reset(stmt));
    db_step(sqlite3_step(stmt));
}

void SpellModel::db_commit_transaction(sqlite3 *db)
{
    static const char *sql = "COMMIT TRANSACTION;";
    static sqlite3_stmt *stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(sqlite3_prepare_v2(db, sql, (int)strlen(sql), &stmt, nullptr));
    });
    
    if (db == nullptr) {
        return;
    }
    db_exec(sqlite3_reset(stmt));
    db_step(sqlite3_step(stmt));
}

void SpellModel::db_rollback_transaction(sqlite3 *db)
{
    static const char *sql = "ROLLBACK TRANSACTION;";
    static sqlite3_stmt *stmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (db == nullptr) {
            return;
        }
        db_exec(sqlite3_prepare_v2(db, sql, (int)strlen(sql), &stmt, nullptr));
    });
    
    if (db == nullptr) {
        return;
    }
    db_exec(sqlite3_reset(stmt));
    db_step(sqlite3_step(stmt));
}


}  // namespace UP
