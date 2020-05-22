//
//  UPSpellModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameCode.h>
#import <UpKit/UPMacros.h>

#import "UPTileSequence.h"
#import "UPTile.h"

#if __cplusplus

#import <vector>
#import <array>

namespace UP {

using TileIndex = size_t;
static constexpr TileIndex NotATileIndex = -1;
static constexpr size_t TileCount = 7;
static constexpr size_t LastTileIndex = TileCount - 1;
using TileTray = std::array<Tile, TileCount>;
using MarkedArray = std::array<bool, TileCount>;

template <bool B = true>
bool valid(TileIndex idx) { return (idx < TileCount) == B; }

template <bool B = true>
bool valid_end(TileIndex idx) { return (idx <= TileCount) == B; }

#define ASSERT_IDX(idx) ASSERT_WITH_MESSAGE(valid(idx), "Invalid TileIndex: %ld", (idx))
#define ASSERT_NIDX(idx) ASSERT_WITH_MESSAGE(valid<false>(idx), "Expected invalid TileIndex: %ld", (idx))
#define ASSERT_IDX_END(idx) ASSERT_WITH_MESSAGE(valid_end(idx), "Invalid TileIndex: %ld", (idx))

class SpellModel {
public:
    enum class Opcode: uint8_t {
        NOP,    // no-op
        INIT,   // create the initial game state
        TAP,    // tap a tile, moving it from the player tray to the end of the word tray
        PICK,   // long press or swipe a tile to pick it up
        DROP,   // drop a picked-up tile, leaving it where it was
        HOVER,  // float above a position where a tile could be moved
        MOVE,   // move a picked-up tile to a new position and make space for it if needed
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
        explicit Action(Opcode opcode, TileIndex idx1 = NotATileIndex, TileIndex idx2 = NotATileIndex) :
            m_timestamp(0), m_opcode(opcode), m_idx1(idx1), m_idx2(idx2) {}
        Action(CFTimeInterval timestamp, Opcode opcode, TileIndex idx1 = NotATileIndex, TileIndex idx2 = NotATileIndex) :
            m_timestamp(timestamp), m_opcode(opcode), m_idx1(idx1), m_idx2(idx2) {}

        CFTimeInterval timestamp() const { return m_timestamp; }
        Opcode opcode() const { return m_opcode; }
        TileIndex idx1() const { return m_idx1; }
        TileIndex idx2() const { return m_idx2; }

    private:
        Opcode m_opcode = Opcode::NOP;
        TileIndex m_idx1 = NotATileIndex;
        TileIndex m_idx2 = NotATileIndex;
        CFTimeInterval m_timestamp = 0;
    };

    class State {
    public:
        State() {}
        State(const Action &action, const TileTray &player_tray, const TileTray &word_tray, int game_score) :
            m_action(action), m_player_tray(player_tray), m_word_tray(word_tray), m_game_score(game_score) {}

        Action action() const { return m_action; }
        const TileTray &player_tray() { return m_player_tray; }
        const TileTray &word_tray() { return m_word_tray; }
        int game_score() const { return m_game_score; }

    private:
        Action m_action;
        TileTray m_player_tray;
        TileTray m_word_tray;
        int m_game_score = 0;
    };

    SpellModel() { apply_init(Action(Opcode::INIT)); }
    SpellModel(const GameCode &game_code) : m_game_code(game_code), m_tile_sequence(game_code) { apply_init(Action(Opcode::INIT)); }

    const TileTray &player_tray() const { return m_player_tray; }
    const MarkedArray &player_marked() const { return m_player_marked; }
    const TileTray &word_tray() const { return m_word_tray; }
    const std::vector<State> &states() const { return m_states; }

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
    TileTray m_player_tray;
    MarkedArray m_player_marked;

    TileTray m_word_tray;
    std::u32string m_word_string;
    int m_word_score = 0;
    bool m_word_in_lexicon = false;
    
    int m_game_score = 0;
};

std::string tile_tray_description(const TileTray &);
std::string marked_array_description(const MarkedArray &);

template <bool B = true>
bool is_sentinel_filled(const TileTray &tile_tray)
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

size_t count_non_sentinel(const TileTray &tile_tray);
bool is_non_sentinel_filled_up_to(const TileTray &tile_tray, const TileIndex idx);

}  // namespace UP

#endif  // __cplusplus