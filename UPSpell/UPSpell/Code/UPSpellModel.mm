//
//  UPSpellModel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <iomanip>
#import <string>
#import <sstream>

#import <UpKit/UPLexicon.h>
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

bool SpellModel::is_game_completed() const
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
            case Opcode::PAUSE:
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
        case Opcode::PAUSE:
            return "PAUSE";
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
        sstr << (state.incoming_word().total_score());
        sstr << ")";
    }
    
    return sstr.str();
}

// =========================================================================================================================================
# pragma mark - Stats

size_t SpellModel::game_tiles_submitted() const
{
    int result = 0;
    for (const Word &word : m_game_submitted_words) {
        result += word.length();
    }
    return result;
}

std::vector<Word> SpellModel::game_best_word() const
{
    std::vector<Word> result;
    int highest_score = 0;
    for (const Word &word : m_game_submitted_words) {
        if (word.total_score() > highest_score) {
            highest_score = word.total_score();
            result.clear();
            result.push_back(word);
        }
        else if (word.total_score() == highest_score) {
            result.push_back(word);
        }
    }
    return result;
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
        case Opcode::PAUSE:
            apply_pause(action);
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

    return m_states.emplace_back(action, incoming_word, tiles(), game_score());
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
    m_game_submitted_words.push_back(word());
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

void SpellModel::apply_pause(const Action &action)
{
    ASSERT(action.opcode() == Opcode::PAUSE);
    ASSERT_NPOS(action.pos1());
    ASSERT_NPOS(action.pos2());
    ASSERT(positions_valid());
    
    // no-op
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

}  // namespace UP

// =========================================================================================================================================

#if __OBJC__

using UP::GameKey;
using UP::SpellModel;
using UP::SpellModelPtr;
using UP::Tile;
using UP::TileArray;
using UP::TileCount;
using UP::TileModel;
using UP::TilePosition;
using UP::TileTray;
using UP::TileIndex;

// =========================================================================================================================================

@interface _UPTilePosition : NSObject <NSSecureCoding>
@property (class, readonly) BOOL supportsSecureCoding;
@property (nonatomic) TileTray tray;
@property (nonatomic) TileIndex index;
@end

@implementation _UPTilePosition

+ (_UPTilePosition *)makeWith:(const TilePosition &)tile_position
{
    _UPTilePosition *obj = [[_UPTilePosition alloc] init];
    obj.tray = tile_position.tray();
    obj.index = tile_position.index();
    return obj;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    self.tray = static_cast<TileTray>([coder decodeInt32ForKey:NSStringFromSelector(@selector(tray))]);
    self.index = static_cast<TileIndex>([coder decodeInt64ForKey:NSStringFromSelector(@selector(index))]);
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt32:static_cast<uint32_t>(self.tray) forKey:NSStringFromSelector(@selector(tray))];
    [coder encodeInt64:self.index forKey:NSStringFromSelector(@selector(index))];
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

UP_STATIC_INLINE TilePosition make_tile_position(_UPTilePosition *tilePosition)
{
    return tilePosition.index == UP::NotATileIndex ? TilePosition() : TilePosition(tilePosition.tray, tilePosition.index);
}

// =========================================================================================================================================

@interface _UPTileModel : NSObject <NSSecureCoding>
@property (class, readonly) BOOL supportsSecureCoding;
@property (nonatomic) char32_t glyph;
@property (nonatomic) int multiplier;
@end

@implementation _UPTileModel

+ (_UPTileModel *)makeWith:(const TileModel &)tile_model
{
    _UPTileModel *obj = [[_UPTileModel alloc] init];
    obj.glyph = tile_model.glyph();
    obj.multiplier = tile_model.multiplier();
    return obj;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];

    self.glyph = static_cast<char32_t>([coder decodeInt32ForKey:NSStringFromSelector(@selector(glyph))]);
    self.multiplier = [coder decodeIntForKey:NSStringFromSelector(@selector(multiplier))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt32:static_cast<char32_t>(self.glyph) forKey:NSStringFromSelector(@selector(glyph))];
    [coder encodeInt:self.multiplier forKey:NSStringFromSelector(@selector(multiplier))];
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

UP_STATIC_INLINE TileModel make_tile_model(_UPTileModel *model)
{
    return TileModel(model.glyph, model.multiplier);
}

// =========================================================================================================================================

@interface _UPTile : NSObject <NSSecureCoding>
@property (class, readonly) BOOL supportsSecureCoding;
@property (nonatomic) _UPTileModel *model;
@property (nonatomic) _UPTilePosition *position;
@end

@implementation _UPTile

+ (_UPTile *)makeWith:(const Tile &)tile
{
    _UPTile *obj = [[_UPTile alloc] init];
    obj.model = [_UPTileModel makeWith:tile.model()];
    obj.position = [_UPTilePosition makeWith:tile.position()];
    return obj;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    self.model = [coder decodeObjectOfClass:[_UPTileModel class] forKey:NSStringFromSelector(@selector(model))];
    self.position = [coder decodeObjectOfClass:[_UPTilePosition class] forKey:NSStringFromSelector(@selector(position))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.model forKey:NSStringFromSelector(@selector(model))];
    [coder encodeObject:self.position forKey:NSStringFromSelector(@selector(position))];
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

UP_STATIC_INLINE Tile make_tile(_UPTile *tile)
{
    return Tile(make_tile_model(tile.model), make_tile_position(tile.position));
}

// =========================================================================================================================================

@interface _UPSpellModelAction : NSObject <NSSecureCoding>
@property (class, readonly) BOOL supportsSecureCoding;
@property (nonatomic) SpellModel::Opcode opcode;
@property (nonatomic) CFTimeInterval timestamp;
@property (nonatomic) _UPTilePosition *position1;
@property (nonatomic) _UPTilePosition *position2;
@end

@implementation _UPSpellModelAction

+ (_UPSpellModelAction *)makeWith:(const SpellModel::Action &)action
{
    _UPSpellModelAction *obj = [[_UPSpellModelAction alloc] init];
    obj.opcode = action.opcode();
    obj.timestamp = action.timestamp();
    obj.position1 = [_UPTilePosition makeWith:action.pos1()];
    obj.position2 = [_UPTilePosition makeWith:action.pos2()];
    return obj;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    self.opcode = static_cast<SpellModel::Opcode>([coder decodeInt32ForKey:NSStringFromSelector(@selector(opcode))]);
    self.timestamp = [coder decodeDoubleForKey:NSStringFromSelector(@selector(timestamp))];
    self.position1 = [coder decodeObjectOfClass:[_UPTilePosition class] forKey:NSStringFromSelector(@selector(position1))];
    self.position2 = [coder decodeObjectOfClass:[_UPTilePosition class] forKey:NSStringFromSelector(@selector(position2))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt32:static_cast<uint32_t>(self.opcode) forKey:NSStringFromSelector(@selector(opcode))];
    [coder encodeDouble:self.timestamp forKey:NSStringFromSelector(@selector(timestamp))];
    [coder encodeObject:self.position1 forKey:NSStringFromSelector(@selector(position1))];
    [coder encodeObject:self.position2 forKey:NSStringFromSelector(@selector(position2))];
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

UP_STATIC_INLINE SpellModel::Action make_action(_UPSpellModelAction *action)
{
    return SpellModel::Action(action.timestamp, action.opcode, make_tile_position(action.position1), make_tile_position(action.position2));
}

// =========================================================================================================================================

@interface _UPSpellModelState : NSObject <NSSecureCoding>
@property (class, readonly) BOOL supportsSecureCoding;
@property (nonatomic) _UPSpellModelAction *action;
@property (nonatomic) NSArray<_UPTile *> *tiles;
@property (nonatomic) int gameScore;
@end

@implementation _UPSpellModelState

+ (_UPSpellModelState *)makeWith:(const SpellModel::State &)state
{
    _UPSpellModelState *obj = [[_UPSpellModelState alloc] init];
    obj.action = [_UPSpellModelAction makeWith:state.action()];
    NSMutableArray<_UPTile *> *tilesArray = [NSMutableArray array];
    for (const auto &tile : state.outgoing_tiles()) {
        [tilesArray addObject:[_UPTile makeWith:tile]];
    }
    obj.tiles = tilesArray;
    obj.gameScore = state.outgoing_game_score();
    return obj;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    self.action = [coder decodeObjectOfClass:[_UPSpellModelAction class] forKey:NSStringFromSelector(@selector(action))];

    NSSet *allowedClasses = [NSSet setWithArray:@[ [_UPTile class], [NSArray class] ]];
    self.tiles = [coder decodeObjectOfClasses:allowedClasses forKey:NSStringFromSelector(@selector(tiles))];

    self.gameScore = [coder decodeIntForKey:NSStringFromSelector(@selector(gameScore))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.action forKey:NSStringFromSelector(@selector(action))];
    [coder encodeObject:self.tiles forKey:NSStringFromSelector(@selector(tiles))];
    [coder encodeInt:self.gameScore forKey:NSStringFromSelector(@selector(gameScore))];
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

UP_STATIC_INLINE TileArray make_tile_array(NSArray<_UPTile *> *tiles)
{
    ASSERT(tiles.count == TileCount);

    TileArray result;
    TileIndex idx = 0;
    for (_UPTile *tile in tiles) {
        result[idx] = make_tile(tile);
        idx++;
    }
    return result;
}

UP_STATIC_INLINE SpellModel::State make_state(_UPSpellModelState *state)
{
    return SpellModel::State(make_action(state.action), UP::Word(), make_tile_array(state.tiles), state.gameScore);
}

// =========================================================================================================================================

static NSString * const UPSpellModelStatesArchiveKey = @"STATES";
static NSString * const UPSpellGameKeyValueArchiveKey = @"GAMEKEY_VALUE";

@interface UPSpellModel ()
{
    SpellModelPtr m_inner;
}
@end

@implementation UPSpellModel

+ (UPSpellModel *)spellModel
{
    return [[self alloc] initWithInner:nullptr];
}

+ (UPSpellModel *)spellModelWithInner:(SpellModelPtr)inner
{
    return [[self alloc] initWithInner:inner];
}

- (instancetype)init
{
    self = [super init];
    m_inner = std::make_shared<SpellModel>(GameKey::random());
    return self;
}

- (instancetype)initWithInner:(SpellModelPtr)inner
{
    self = [self init];
    m_inner = inner;
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    uint32_t game_key_value = [coder decodeInt32ForKey:UPSpellGameKeyValueArchiveKey];
    GameKey game_key = GameKey(game_key_value);
    
    if ([coder containsValueForKey:UPSpellModelStatesArchiveKey]) {
        std::vector<SpellModel::State> states;
        NSSet *allowedClasses = [NSSet setWithArray:@[ [_UPSpellModelState class], [NSArray class] ]];
        NSArray<_UPSpellModelState *> *decodedStates = [coder decodeObjectOfClasses:allowedClasses forKey:UPSpellModelStatesArchiveKey];
        for (_UPSpellModelState *decodedState : decodedStates) {
            states.push_back(make_state(decodedState));
        }
        m_inner = std::make_shared<SpellModel>(game_key, states);
    }
    else {
        m_inner = std::make_shared<SpellModel>(game_key);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    uint32_t game_key_value = m_inner->game_key().value();
    [coder encodeInt32:game_key_value forKey:UPSpellGameKeyValueArchiveKey];

    if (!m_inner->is_game_completed()) {
        NSMutableArray<_UPSpellModelState *> *states = [NSMutableArray array];
        for (const auto &state : m_inner->states()) {
            [states addObject:[_UPSpellModelState makeWith:state]];
        }
        [coder encodeObject:states forKey:UPSpellModelStatesArchiveKey];
    }
}

@dynamic inner;
- (SpellModelPtr)inner
{
    return m_inner;
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

#endif  // __OBJC__

// =========================================================================================================================================
