//
//  UPSpellGameModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

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
        TAP,    // tap a tile, moving it from the player tray to the word tray
        PICK,   // long press or swipe a tile to pick it up
        DROP,   // drop a picked-up tile, leaving it where it was
        MOVE,   // move a picked-up tile to a new position
        SUBMIT, // tap the word tray to submit a word
        CLEAR,  // tap the clear button to return all tiles to their positions in the player tray
        DUMP,   // tap the dump button to get a new set of tiles
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

    class TileTray {
    public:
        TileTray() {}
        
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

    void add_action(CFTimeInterval timestamp, Opcode opcode, Position pos1, Position pos2) {
        m_actions.emplace_back(timestamp, opcode, pos1, pos2);
    }

    const std::vector<Action> &actions() const { return m_actions; }

private:
    std::vector<Action> m_actions;
};

}  // namespace UP

#endif  // __cplusplus
