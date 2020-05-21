//
//  UPSpellGameModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameCode.h>
#import <UpKit/UPLetterSequence.h>
#import <UpKit/UPMacros.h>

#import "UPTile.h"

#if __cplusplus

#import <vector>
#import <array>

namespace UP {

class SpellGameModel {
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

    enum class Position: size_t {
        P1 = 0,
        P2 = 1,
        P3 = 2,
        P4 = 3,
        P5 = 4,
        P6 = 5,
        P7 = 6,
        W1 = 0,
        W2 = 1,
        W3 = 2,
        W4 = 3,
        W5 = 4,
        W6 = 5,
        W7 = 6,
        XX = 0
    };
    static size_t index(Position pos) { return static_cast<size_t>(pos); }
    
    class Action {
    public:
        Action() {}
        explicit Action(Opcode opcode, Position pos1 = Position::XX, Position pos2 = Position::XX) :
            m_timestamp(0), m_opcode(opcode), m_pos1(pos1), m_pos2(pos2) {}
        Action(CFTimeInterval timestamp, Opcode opcode, Position pos1 = Position::XX, Position pos2 = Position::XX) :
            m_timestamp(timestamp), m_opcode(opcode), m_pos1(pos1), m_pos2(pos2) {}

        CFTimeInterval timestamp() const { return m_timestamp; }
        Opcode opcode() const { return m_opcode; }
        Position pos1() const { return m_pos1; }
        Position pos2() const { return m_pos2; }

    private:
        Opcode m_opcode = Opcode::NOP;
        Position m_pos1 = Position::XX;
        Position m_pos2 = Position::XX;
        CFTimeInterval m_timestamp = 0;
    };

    enum { TileCount = 7 };
    using TileTray = std::array<Tile, TileCount>;
    using MarkedArray = std::array<bool, TileCount>;

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

    SpellGameModel() { apply_init(Action(Opcode::INIT)); }
    SpellGameModel(const GameCode &game_code) : m_game_code(game_code), m_letter_sequence(game_code) { apply_init(Action(Opcode::INIT)); }

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
    void player_mark_at(Position pos) { m_player_marked.at(index(pos)) = true; }
    void player_unmark_at(size_t idx) { m_player_marked.at(idx) = false; }
    void player_mark_all() { m_player_marked.fill(true); }
    void player_unmark_all() { m_player_marked.fill(false); }
    size_t player_count_marked() const;
    void player_sentinelize_marked();
    void player_fill();

    void word_insert_at(const Tile &tile, Position pos);
    void word_remove_at(const Tile &tile, Position pos);
    void word_push_back(const Tile &tile) { m_word_tray[word_length()] = tile; }
    void word_clear() { m_word_tray.fill(Tile::sentinel()); }
    void word_update();
    void word_submit();

    void apply_init(const Action &action);
    void apply_tap(const Action &action);
    void apply_submit(const Action &action);
    void apply_reject(const Action &action);
    void apply_clear(const Action &action);

    GameCode m_game_code;
    std::vector<State> m_states;

    LetterSequence m_letter_sequence;
    TileTray m_player_tray;
    MarkedArray m_player_marked;

    TileTray m_word_tray;
    std::u32string m_word_string;
    int m_word_score = 0;
    bool m_word_in_lexicon = false;
    
    int m_game_score = 0;
};

std::string tile_tray_description(const SpellGameModel::TileTray &);
std::string marked_array_description(const SpellGameModel::MarkedArray &);

UP_STATIC_INLINE size_t index(SpellGameModel::Position pos) { return static_cast<size_t>(pos); }
UP_STATIC_INLINE bool is_valid_tray_index(size_t idx) { return idx < SpellGameModel::TileCount; }
UP_STATIC_INLINE bool is_valid_tray_index_for_one_after_end(size_t idx) { return idx <= SpellGameModel::TileCount; }

UP_STATIC_INLINE SpellGameModel::Position player_tray_position(size_t idx) {
    ASSERT(is_valid_tray_index(idx));
    using Position = SpellGameModel::Position;
    switch (idx) {
        case 0:
            return Position::P1;
        case 1:
            return Position::P2;
        case 2:
            return Position::P3;
        case 3:
            return Position::P4;
        case 4:
            return Position::P5;
        case 5:
            return Position::P6;
        case 6:
            return Position::P7;
    }
    ASSERT_NOT_REACHED();
    return Position::XX;
}

UP_STATIC_INLINE SpellGameModel::Position word_tray_position(size_t idx) {
    ASSERT(is_valid_tray_index(idx));
    using Position = SpellGameModel::Position;
    switch (idx) {
        case 0:
            return Position::W1;
        case 1:
            return Position::W2;
        case 2:
            return Position::W3;
        case 3:
            return Position::W4;
        case 4:
            return Position::W5;
        case 5:
            return Position::W6;
        case 6:
            return Position::W7;
    }
    ASSERT_NOT_REACHED();
    return Position::XX;
}


UP_STATIC_INLINE bool position_in_player_tray(const SpellGameModel::Position pos)
{
    return pos >= SpellGameModel::Position::P1 && pos <= SpellGameModel::Position::P7;
}

UP_STATIC_INLINE bool position_in_word_tray(const SpellGameModel::Position pos)
{
    return pos >= SpellGameModel::Position::W1 && pos <= SpellGameModel::Position::W7;
}

template <bool B = true>
bool is_sentinel_filled(const SpellGameModel::TileTray &tile_tray)
{
    for (const auto &tile : tile_tray) {
        if (tile.is_sentinel<!B>()) {
            return false;
        }
    }
    return true;
}

template <bool B = true>
bool is_marked(const SpellGameModel::MarkedArray &marked_array, const SpellGameModel::Position pos)
{
    return marked_array[index(pos)] == B;
}

template <bool B = true>
size_t count_marked(const SpellGameModel::MarkedArray &marked_array)
{
    size_t count = 0;
    for (const auto &mark : marked_array) {
        if (mark == B) {
            count++;
        }
    }
    return count;
}

size_t count_non_sentinel(const SpellGameModel::TileTray &tile_tray);
bool is_non_sentinel_filled_up_to(const SpellGameModel::TileTray &tile_tray, const size_t idx);

}  // namespace UP

#endif  // __cplusplus
