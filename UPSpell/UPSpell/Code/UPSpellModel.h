//
//  UPSpellModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPMacros.h>

#import "UPTileSequence.h"
#import "UPTileModel.h"

@class UPTileView;

#if __cplusplus

#import <array>
#import <string>
#import <vector>

namespace UP {

// =========================================================================================================================================

using TileIndex = size_t;
static constexpr TileIndex NotATileIndex = -1;
static constexpr size_t TileCount = 7;
static constexpr size_t LastTileIndex = TileCount - 1;

template <bool B = true>
bool valid(TileIndex idx) { return (idx < TileCount) == B; }

template <bool B = true>
bool valid_end(TileIndex idx) { return (idx <= TileCount) == B; }

#define ASSERT_IDX(idx) ASSERT_WITH_MESSAGE(UP::valid((idx)), "Invalid TileIndex: %ld", (idx))
#define ASSERT_NIDX(idx) ASSERT_WITH_MESSAGE(UP::valid<false>((idx)), "Expected invalid TileIndex: %ld", (idx))
#define ASSERT_IDX_END(idx) ASSERT_WITH_MESSAGE(UP::valid_end((idx)), "Invalid TileIndex: %ld", (idx))

// =========================================================================================================================================

enum class TileTray { None, Player, Word };

class TilePosition {
public:
    constexpr TilePosition() {}
    TilePosition(TileTray tray, TileIndex index) : m_tray(tray), m_index(index) { ASSERT_IDX(m_index); }
    TileTray tray() const { return m_tray; }
    TileIndex index() const { return m_index; }
    
    TilePosition incremented() const { ASSERT_IDX(m_index + 1); return TilePosition(m_tray, m_index + 1); }
    TilePosition decremented() const { ASSERT_IDX(m_index - 1); return TilePosition(m_tray, m_index - 1); }

    template <bool B = true> bool in_player_tray() const { return (tray() == TileTray::Player) == B; }
    template <bool B = true> bool in_word_tray() const { return (tray() == TileTray::Word) == B; }

    bool valid() const { return tray() != TileTray::None && index() != NotATileIndex; }
    
private:
    TileTray m_tray = TileTray::None;
    TileIndex m_index = NotATileIndex;
};

UP_STATIC_INLINE const char *cstr_for(TileTray tray)
{
    switch (tray) {
        case TileTray::None:
            return "none";
        case TileTray::Player:
            return "player";
        case TileTray::Word:
            return "word";
    }
    ASSERT_NOT_REACHED();
    return "?";
}

UP_STATIC_INLINE bool operator==(const TilePosition &a, const TilePosition &b)
{
    return a.tray() == b.tray() && a.index() == b.index();
}

UP_STATIC_INLINE bool operator!=(const TilePosition &a, const TilePosition &b) { return !(a == b); }

template <bool B = true>
bool valid(TilePosition pos) { return pos.valid() == B; }

#define ASSERT_POS(pos) ASSERT_WITH_MESSAGE(valid(pos), "Invalid TilePosition: %s:%ld", cstr_for(pos.tray()), pos.index())
#define ASSERT_NPOS(pos) ASSERT_WITH_MESSAGE(valid<false>(pos), "Expected invalid TilePosition: %s:%ld", cstr_for(pos.tray()), pos.index())

// =========================================================================================================================================

class Tile {
public:
    constexpr Tile() {}
    Tile(const TileModel &model, const TilePosition &position, UPTileView *view = nullptr) :
        m_model(model), m_position(position), m_view(view) {}

    TileModel model() const { return m_model; }
    void set_model(const TileModel &model) { m_model = model; }
    
    TilePosition position() const { return m_position; }
    void set_position(const TilePosition &position) { m_position = position; }
    
    template <bool B = true> bool in_player_tray() const { return position().in_player_tray<B>(); }
    template <bool B = true> bool in_word_tray() const { return position().in_word_tray<B>(); }

    UPTileView *view() const { return m_view; }
    void set_view(UPTileView *view) { m_view = view; }
    void clear_view() { m_view = nullptr; }
    template <bool B = true> bool has_view() const { return (m_view != nil) == B; }

private:
    TileModel m_model;
    TilePosition m_position;
    __weak UPTileView *m_view = nullptr;
};

using TileArray = std::array<Tile, TileCount>;

// =========================================================================================================================================

class SpellModel {
public:
    enum class Opcode: uint8_t {
        NOP,    // no-op
        INIT,   // create the initial game state
        ADD,    // move a player tray to the word tray
        REMOVE, // remove a tile from the word tray, tightening up the remaining tiles (if any)
        MOVE,   // move a word tray tile to a new word tray position
        PICK,   // drag a tile to pick it up
        HOVER,  // float above a position where a tile could be moved
        NOVER,  // cancel a previous hover, tightening up the remaining tiles (if any)
        DROP,   // drop a picked-up tile, leaving it where it was
        SUBMIT, // accept submission of tiles in the word tray to score points
        REJECT, // reject submission of tiles in the word tray to score points
        CLEAR,  // return the tiles in the word to their positions in the player tray
        DUMP,   // dump player tray tiles and replace them with a new set of tiles
        GAME,   // game over
        QUIT    // quit the game early
    };

    static constexpr int SevenLetterWordBonus = 25;
    static constexpr int SixLetterWordBonus = 10;
    static constexpr int FiveLetterWordBonus = 5;

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
        State(const Action &action, const TileArray &tiles, int game_score) :
            m_action(action), m_tiles(tiles), m_score(game_score) {}

        Action action() const { return m_action; }
        const TileArray &tiles() { return m_tiles; }
        int score() const { return m_score; }

    private:
        Action m_action;
        TileArray m_tiles;
        int m_score = 0;
    };

    SpellModel() { apply_init(Action(Opcode::INIT)); }
    SpellModel(const GameKey &game_code) : m_game_code(game_code), m_tile_sequence(game_code) { apply_init(Action(Opcode::INIT)); }

    const TileArray &tiles() const { return m_tiles; }
    TileArray &tiles() { return m_tiles; }

    const Tile &find_tile(const UPTileView *) const;
    Tile &find_tile(const UPTileView *);

    const Tile &find_tile(const TilePosition &) const;
    Tile &find_tile(const TilePosition &);

    UPTileView *find_view(const TilePosition &pos);

    TileIndex player_tray_index(const UPTileView *);
    TileIndex player_tray_index(const TilePosition &);

    NSArray *all_tile_views() const;
    NSArray *player_tray_tile_views() const;
    NSArray *word_tray_tile_views() const;

    const std::vector<State> &states() const { return m_states; }
    const State &back_state() const;

    const std::u32string &word_string() const { return m_word_string; }
    size_t word_length() const { return m_word_string.length(); }
    int word_score() const { return m_word_score; }
    int word_multiplier() const { return m_word_multiplier; }
    bool word_in_lexicon() const { return m_word_in_lexicon; }

    int game_score() const { return m_game_score; }
    void reset_game_score() { m_game_score = 0; }

    const State &apply(const Action &action);

private:
    std::string tiles_description() const;
    void fill_player_tray();
    void clear_word_tray();
    void clear_and_sentinelize_word_tray();
    void clear_and_sentinelize();
    void update_word();

    void append_to_word(const TilePosition &player_pos);
    void insert_into_word(const TilePosition &player_pos, const TilePosition &word_pos);
    void add_to_word(const TilePosition &player_pos, const TilePosition &word_pos);
    void remove_from_word(const TilePosition &word_pos);

    bool is_sentinel_filled() const;
    template <bool B> bool is_sentinel_filled() const { return is_sentinel_filled() == B; }
    bool is_word_tray_positioned_up_to(TileIndex) const;
    bool not_word_tray_positioned_after(TileIndex) const;
    bool positions_valid() const;

    void apply_init(const Action &action);
    void apply_add(const Action &action);
    void apply_remove(const Action &action);
    void apply_move(const Action &action);
    void apply_pick(const Action &action);
    void apply_hover(const Action &action);
    void apply_nover(const Action &action);
    void apply_drop(const Action &action);
    void apply_submit(const Action &action);
    void apply_reject(const Action &action);
    void apply_clear(const Action &action);
    void apply_dump(const Action &action);
    void apply_game(const Action &action);
    void apply_quit(const Action &action);

    GameKey m_game_code;
    TileSequence m_tile_sequence;
    TileArray m_tiles;
    std::vector<State> m_states;

    std::u32string m_word_string;
    int m_word_score = 0;
    int m_word_multiplier = 0;
    bool m_word_in_lexicon = false;
    
    int m_game_score = 0;
};

// =========================================================================================================================================


}  // namespace UP

#endif  // __cplusplus
