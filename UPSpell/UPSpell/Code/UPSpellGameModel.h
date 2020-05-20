//
//  UPSpellGameModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPGameCode.h>
#import <UpKit/UPLetterSequence.h>
#import <UpKit/UPMacros.h>
#import <UpKit/UPTile.h>

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
        WORD,   // submit the tiles in the word tray as a spelled word
        OVER,   // return the tiles in the word to their positions in the player tray
        DUMP,   // dump player tray tiles and replace them with a new set of tiles
        QUIT    // quit the game
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

    class Action {
    public:
        Action() {}
        explicit Action(Opcode opcode, Position pos1 = Position::XX, Position pos2 = Position::XX, CFTimeInterval timestamp = 0) :
            m_opcode(opcode), m_pos1(pos1), m_pos2(pos2), m_timestamp(timestamp) {}

        Opcode opcode() const { return m_opcode; }
        Position pos1() const { return m_pos1; }
        Position pos2() const { return m_pos2; }
        CFTimeInterval timestamp() const { return m_timestamp; }

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
        State(const Action &action, const TileTray &player_tray, const TileTray &word_tray) :
            m_action(action), m_player_tray(player_tray), m_word_tray(word_tray) {}

        Action action() const { return m_action; }
        const TileTray &player_tray() { return m_player_tray; }
        const TileTray &word_tray() { return m_word_tray; }

    private:
        Action m_action;
        TileTray m_player_tray;
        TileTray m_word_tray;
    };

    SpellGameModel() { create_initial_state(); }
    SpellGameModel(const GameCode &game_code) : m_game_code(game_code), m_letter_sequence(game_code) { create_initial_state(); }

    const State &next_state(const Action &action);

    const TileTray &player_tray() const { return m_player_tray; }
    const TileTray &word_tray() const { return m_word_tray; }
    const std::vector<State> &states() const { return m_states; }

private:
    void create_initial_state();

    static inline size_t index(Position pos) { return static_cast<size_t>(pos); }

    void player_mark_at(size_t idx) { m_player_marked.at(idx) = true; }
    void player_unmark_at(size_t idx) { m_player_marked.at(idx) = false; }
    void player_mark_all() { m_player_marked.fill(true); }
    void player_unmark_all() { m_player_marked.fill(false); }
    size_t player_count_marked() const;
    void player_sentinelize_marked();
    void player_fill();

    const std::u32string &word_string() const { return m_word_string; }
    size_t word_length() const { return m_word_string.length(); }
    int word_score() const { return m_word_score; }
    bool word_in_lexicon() const { return m_word_in_lexicon; }
    void word_insert_at(const Tile &tile, Position pos);
    void word_remove_at(const Tile &tile, Position pos);
    void word_push_back(const Tile &tile) { m_word_tray[word_length()] = tile; }
    void word_clear() { m_word_tray.fill(Tile::sentinel()); }
    void word_update();

    GameCode m_game_code;
    std::vector<State> m_states;

    LetterSequence m_letter_sequence;
    TileTray m_player_tray;
    MarkedArray m_player_marked;

    TileTray m_word_tray;
    std::u32string m_word_string;
    int m_word_score = 0;
    bool m_word_in_lexicon = false;
};

}  // namespace UP

#endif  // __cplusplus
