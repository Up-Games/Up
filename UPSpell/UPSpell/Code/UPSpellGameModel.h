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
        TAP,    // tap a tile, moving it from the player tray to the word tray
        PICK,   // long press or swipe a tile to pick it up
        DROP,   // drop a picked-up tile, leaving it where it was
        MOVE,   // move a picked-up tile to a new position and make space for it if needed
        SWAP,   // swap positions of a picked-up tile and another tile
        WORD,   // submit the tiles in the word tray as a spelled word
        OVER,   // return the tiles in the word to their positions in the player tray
        DUMP,   // dump player tray tiles and replace them with a new set of tiles
        QUIT    // quit the game
    };

    enum class Position: uint8_t {
        T1, T2, T3, T4, T5, T6, T7,
        W1, W2, W3, W4, W5, W6, W7,
        XX
    };

    class Action {
    public:
        Action() {}
        Action(CFTimeInterval timestamp, Opcode opcode, Position pos1, Position pos2) :
            m_timestamp(timestamp), m_opcode(opcode), m_pos1(pos1), m_pos2(pos2) {}

        CFTimeInterval timestamp() const { return m_timestamp; }
        Opcode opcode() const { return m_opcode; }
        Position pos1() const { return m_pos1; }
        Position pos2() const { return m_pos2; }

    private:
        CFTimeInterval m_timestamp = 0;
        Opcode m_opcode = Opcode::NOP;
        Position m_pos1 = Position::XX;
        Position m_pos2 = Position::XX;
    };

    enum { TileCount = 7 };
    using TileArray = std::array<Tile, TileCount>;
    using MarkedArray = std::array<bool, TileCount>;

    class PlayerTray {
    public:
        PlayerTray() {}
        
        constexpr Tile &operator[](size_t idx) { return m_tiles[idx]; }
        constexpr const Tile &operator[](size_t idx) const { return m_tiles[idx]; }
        void mark_at(size_t idx) { m_marked.at(idx) = true; }
        void unmark_at(size_t idx) { m_marked.at(idx) = false; }
        void mark_all() { m_marked.fill(true); }
        void unmark_all() { m_marked.fill(false); }
        size_t count_marked() const;
        void sentinelize_marked();
        void fill();

    private:
        TileArray m_tiles;
        MarkedArray m_marked;
    };

    class Word {
    public:
        Word() {}
        Word(const TileArray &tiles, size_t count);
        
        const std::u32string &string() const { return m_string; }
        int score() const { return m_score; }
    private:
        std::u32string m_string;
        int m_score = 0;
    };

    class WordTray {
    public:
        WordTray() { clear(); }

        const TileArray &tiles() const { return m_tiles; }
        size_t count() const { return m_count; }
        const Word &word() const { return m_word; }
        constexpr const Tile &operator[](size_t idx) const { return m_tiles[idx]; }
        void push_back(const Tile &tile) { m_tiles[m_count] = tile; m_count++; }
        void exchange(size_t idx_a, size_t idx_b) { Tile &tmp = m_tiles[idx_a]; m_tiles[idx_a] = m_tiles[idx_b]; m_tiles[idx_b] = tmp; }
        bool check() { update_word(); return check_lexicon(); }
        void clear();

    private:
        void update_word() { m_word = Word(tiles(), count()); }
        bool check_lexicon() const;

        TileArray m_tiles;
        size_t m_count = 0;
        Word m_word;
    };

    class State {
    public:
        State() {}
        State(const State &state, const Action &action) {}

        Action action() const { return m_action; }
        const PlayerTray &player_tray() { return m_player_tray; }
        const WordTray &word_tray() { return m_word_tray; }

    private:
        Action m_action;
        PlayerTray m_player_tray;
        WordTray m_word_tray;
    };

    SpellGameModel() { create_initial_state(); }
    SpellGameModel(const GameCode &game_code) : m_game_code(game_code), m_letter_sequence(game_code) { create_initial_state(); }

    const State &next_state(const Action &action) {
        m_states.emplace_back(State(m_states.back(), action));
        return m_states.back();
    }

    const std::vector<State> &states() const { return m_states; }

private:
    void create_initial_state();

    GameCode m_game_code;
    LetterSequence m_letter_sequence;
    std::vector<State> m_states;
};

}  // namespace UP

#endif  // __cplusplus
