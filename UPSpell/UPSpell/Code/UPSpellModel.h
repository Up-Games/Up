//
//  UPSpellModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameCode.h>
#import <UpKit/UPMacros.h>

#import "UPSpellTypes.h"
#import "UPTileSequence.h"
#import "UPTile.h"

#if __cplusplus

#import <vector>
#import <array>

namespace UP {

using TileArray = std::array<Tile, TileCount>;
using MarkedArray = std::array<bool, TileCount>;

class SpellModel {
public:
    enum class Opcode: uint8_t {
        NOP,    // no-op
        INIT,   // create the initial game state
        ADD,    // moving it from the player tray to the end of the word tray, usually by tapping it
        PICK,   // drag a tile to pick it up
        DROP,   // drop a picked-up tile, leaving it where it was
        REMOVE, // remove a tile from a word tray position, tightening up the remaining tiles (if any)
        HOVER,  // float above a position where a tile could be moved
        PUT,    // put a picked-up tile down in a new position
        SWAP,   // swap positions of a picked-up tile and another tile
        SUBMIT, // accept submission of tiles in the word tray to score points
        REJECT, // reject submission of tiles in the word tray to score points
        CLEAR,  // return the tiles in the word to their positions in the player tray
        DUMP,   // dump player tray tiles and replace them with a new set of tiles
        OVER,   // game over
        QUIT    // quit the game early
    };

    static constexpr int SevenLetterWordBonus = 50;
    static constexpr int SixLetterWordBonus = 20;
    static constexpr int FiveLetterWordBonus = 10;

    class Action {
    public:
        Action() {}
        explicit Action(Opcode opcode, TilePosition pos1 = TilePosition(), TilePosition pos2 = TilePosition()) :
            m_timestamp(0), m_opcode(opcode), m_pos1(pos1), m_pos2(pos2) {}
        Action(CFTimeInterval timestamp, Opcode opcode, TilePosition pos1 = TilePosition(), TilePosition pos2 = TilePosition()) :
            m_timestamp(timestamp), m_opcode(opcode), m_pos1(pos1), m_pos2(pos2) {}

        CFTimeInterval timestamp() const { return m_timestamp; }
        Opcode opcode() const { return m_opcode; }
        TilePosition pos1() const { return m_pos1; }
        TilePosition pos2() const { return m_pos2; }

    private:
        Opcode m_opcode = Opcode::NOP;
        TilePosition m_pos1 = TilePosition();
        TilePosition m_pos2 = TilePosition();
        CFTimeInterval m_timestamp = 0;
    };

    class State {
    public:
        State() {}
        State(const Action &action, const TileArray &player_tray, const TileArray &word_tray, int game_score) :
            m_action(action), m_player_tray(player_tray), m_word_tray(word_tray), m_game_score(game_score) {}

        Action action() const { return m_action; }
        const TileArray &player_tray() { return m_player_tray; }
        const TileArray &word_tray() { return m_word_tray; }
        int game_score() const { return m_game_score; }

    private:
        Action m_action;
        TileArray m_player_tray;
        TileArray m_word_tray;
        int m_game_score = 0;
    };

    SpellModel() { apply_init(Action(Opcode::INIT)); }
    SpellModel(const GameCode &game_code) : m_game_code(game_code), m_tile_sequence(game_code) { apply_init(Action(Opcode::INIT)); }

    const TileArray &player_tray() const { return m_player_tray; }
    TileArray &player_tray() { return m_player_tray; }
    const MarkedArray &player_marked() const { return m_player_marked; }
    const TileArray &word_tray() const { return m_word_tray; }
    TileArray &word_tray() { return m_word_tray; }
    const std::vector<State> &states() const { return m_states; }

    TileIndex player_tray_index(const UPTileView *) const;
    TileIndex word_tray_index(const UPTileView *) const;

    const std::u32string &word_string() const { return m_word_string; }
    size_t word_length() const { return m_word_string.length(); }
    int word_score() const { return m_word_score; }
    bool word_in_lexicon() const { return m_word_in_lexicon; }

    int game_score() const { return m_game_score; }

    const State &apply(const Action &action);

private:
    void player_mark_at(TileIndex idx) { ASSERT_IDX(idx); m_player_marked[idx] = true; }
    void player_unmark_at(TileIndex idx) { ASSERT_IDX(idx); m_player_marked[idx] = false; }
    void player_mark_all() { m_player_marked.fill(true); }
    void player_unmark_all() { m_player_marked.fill(false); }
    size_t player_count_marked() const;
    void player_sentinelize_marked();
    void player_fill();
    void player_clear_tiles();

    void word_insert_at(const Tile &, TileIndex);
    void word_remove_at(const Tile &, TileIndex);
    void word_push_back(const Tile &tile) { ASSERT_IDX(word_length()); m_word_tray[word_length()] = tile; }
    void word_clear() { m_word_tray.fill(Tile::sentinel()); }
    void word_update();
    void word_submit();

    void apply_init(const Action &action);
    void apply_tap(const Action &action);
    void apply_submit(const Action &action);
    void apply_reject(const Action &action);
    void apply_clear(const Action &action);
    void apply_dump(const Action &action);

    GameCode m_game_code;
    std::vector<State> m_states;

    TileSequence m_tile_sequence;
    TileArray m_player_tray;
    MarkedArray m_player_marked;

    TileArray m_word_tray;
    std::u32string m_word_string;
    int m_word_score = 0;
    bool m_word_in_lexicon = false;
    
    int m_game_score = 0;
};

std::string tile_tray_description(const TileArray &);
std::string marked_array_description(const MarkedArray &);

template <bool B = true>
bool is_sentinel_filled(const TileArray &tile_tray)
{
    for (const auto &tile : tile_tray) {
        if (tile.is_sentinel<!B>()) {
            return false;
        }
    }
    return true;
}

template <bool B = true>
bool is_marked(const MarkedArray &marked_array, const TileIndex idx)
{
    ASSERT_IDX(idx);
    return marked_array[idx] == B;
}

template <bool B = true>
size_t count_marked(const MarkedArray &marked_array)
{
    size_t count = 0;
    for (const auto &mark : marked_array) {
        if (mark == B) {
            count++;
        }
    }
    return count;
}

size_t count_non_sentinel(const TileArray &tile_tray);
bool is_non_sentinel_filled_up_to(const TileArray &tile_tray, const TileIndex idx);

}  // namespace UP

#endif  // __cplusplus
