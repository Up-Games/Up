//
//  UPSpellModel.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPMacros.h>

#import "UPSpellGameSummary.h"
#import "UPTileSequence.h"
#import "UPTileModel.h"

@class UPTileView;

#import <array>
#import <limits>
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

template <bool B = true>
bool valid(TileTray tray) { return (tray == TileTray::Player || tray == TileTray::Word) == B; }

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

UP_STATIC_INLINE char char_for(TileTray tray)
{
    switch (tray) {
        case TileTray::None:
            return '?';
        case TileTray::Player:
            return 'P';
        case TileTray::Word:
            return 'W';
    }
    ASSERT_NOT_REACHED();
    return '?';
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

class Word {
public:
    Word() {}
    explicit Word(const TileArray &tiles);

    const TileArray &tiles() const { return m_tiles; }
    TileArray &tiles() { return m_tiles; }
    const std::u32string &key() const { return m_key; }
    const std::u32string &string() const { return m_string; }
    size_t length() const { return m_key.length(); }
    int score() const { return m_score; }
    int total_multiplier() const { return m_total_multiplier; }
    int total_score() const { return m_total_score; }
    template <bool B = true> bool in_lexicon() const { return m_in_lexicon == B; }

private:
    TileArray m_tiles;
    std::u32string m_key;
    std::u32string m_string;
    int m_score = 0;
    int m_total_multiplier = 1;
    int m_total_score = 0;
    bool m_in_lexicon = false;
};

// =========================================================================================================================================

class SpellModel {
public:
    enum class Opcode: uint8_t {
        NOP,    // no-op
        START,  // the start state for every game
        PLAY,   // start playing a game
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
        PAUSE,  // pause
        OVER,   // game over
        QUIT,   // quit the game early
        END,    // the end state after game over or quit
    };

    template <bool B = true> static bool valid_opcode(Opcode opcode) { return (opcode >= Opcode::START && opcode <= Opcode::END) == B; }
    template <bool B = true> static bool valid_timestamp(CFTimeInterval timestamp) { return (timestamp >= 0 && timestamp <= 120) == B; }

    static constexpr int SevenLetterWordBonus = 21;
    static constexpr int SixLetterWordBonus = 12;
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
        State(const Action &action, const Word &incoming_word, const TileArray &outgoing_tiles, int outgoing_game_score) :
            m_action(action),
            m_incoming_word(incoming_word),
            m_outgoing_tiles(outgoing_tiles),
            m_outgoing_game_score(outgoing_game_score) {}

        Action action() const { return m_action; }
        const Word &incoming_word() const { return m_incoming_word; }
        const TileArray &outgoing_tiles() const { return m_outgoing_tiles; }
        TileArray &outgoing_tiles() { return m_outgoing_tiles; }
        int outgoing_game_score() const { return m_outgoing_game_score; }
        
    private:
        Action m_action;
        Word m_incoming_word;
        TileArray m_outgoing_tiles;
        int m_outgoing_game_score = 0;
    };

    static constexpr int NotAChallengeScore = -1;

    SpellModel() { apply_start(Action(Opcode::START)); }

    SpellModel(const GameKey &game_key, int challenge_score = NotAChallengeScore) :
        m_game_key(game_key), m_challenge_score(challenge_score), m_tile_sequence(game_key) {
            apply(Action(Opcode::START));
        }

    SpellModel(const GameKey &game_key, int challenge_score, std::vector<State> &states) :
        m_game_key(game_key), m_challenge_score(challenge_score), m_tile_sequence(game_key) {
        ASSERT(states.size());
        ASSERT(states.front().action().opcode() == Opcode::START);
        for (const auto &state : states) {
            apply(state.action());
        }
    }

    GameKey game_key() const { return m_game_key; }

    template <bool B = true> bool is_challenge() const { return (m_challenge_score > NotAChallengeScore) == B; }
    int challenge_score() const { return m_challenge_score; }
    
    const TileArray &tiles() const { return m_tiles; }
    TileArray &tiles() { return m_tiles; }

    const Tile &find_tile(const UPTileView *) const;
    Tile &find_tile(const UPTileView *);

    const Tile &find_tile(const TilePosition &) const;
    Tile &find_tile(const TilePosition &);

    UPTileView *find_view(const TilePosition &pos);

    TileIndex player_tray_index(const UPTileView *);
    TileIndex player_tray_index(const TilePosition &);

    void move_word_tray_tiles_back_to_player_tray();
    void swap_tiles_at_indices(TileIndex, TileIndex);

    NSArray *all_tile_views() const;
    NSArray *player_tray_tile_views() const;
    NSArray *word_tray_tile_views() const;

    const std::vector<State> &states() const { return m_states; }
    const State &back_state() const;
    bool is_game_completed() const;
    Opcode back_opcode() const { return back_state().action().opcode(); }

    const Word &word() const { return m_word; }

    int game_score() const { return m_game_score; }

    const State &apply(const Action &action);

    bool is_sentinel_filled() const;
    template <bool B> bool is_sentinel_filled() const { return is_sentinel_filled() == B; }
    bool is_blank_filled() const;
    template <bool B> bool is_blank_filled() const { return is_blank_filled() == B; }
    bool is_word_tray_positioned_up_to(TileIndex) const;
    bool not_word_tray_positioned_after(TileIndex) const;
    bool is_player_tray_filled() const;
    bool positions_valid() const;

    std::string cpp_str(Opcode) const;
    std::string cpp_str(const State &) const;

    size_t game_words_submitted() const { return m_game_submitted_words.size(); }
    size_t game_tiles_submitted() const;
    std::vector<Word> game_best_word() const;

private:
    std::string tiles_description() const;
    void fill_player_tray();
    void clear_word_tray();
    void clear_and_sentinelize_word_tray();
    void clear_and_sentinelize();
    void clear_and_blank();
    void update_word();

    void append_to_word(const TilePosition &player_pos);
    void insert_into_word(const TilePosition &player_pos, const TilePosition &word_pos);
    void add_to_word(const TilePosition &player_pos, const TilePosition &word_pos);
    void remove_from_word(const TilePosition &word_pos);

    void apply_start(const Action &action);
    void apply_play(const Action &action);
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
    void apply_pause(const Action &action);
    void apply_over(const Action &action);
    void apply_quit(const Action &action);
    void apply_end(const Action &action);

    GameKey m_game_key;
    TileSequence m_tile_sequence;
    TileArray m_tiles;
    std::vector<State> m_states;
    Word m_word;
    int m_game_score = 0;
    int m_challenge_score = 0;
    std::vector<Word> m_game_submitted_words;
};

using SpellModelPtr = std::shared_ptr<class SpellModel>;

}  // namespace UP

// =========================================================================================================================================

#if __OBJC__
@interface UPSpellModel : NSObject <NSSecureCoding>

@property (class, readonly) BOOL supportsSecureCoding;
@property (nonatomic, readonly) UP::SpellModelPtr inner;

+ (UPSpellModel *)spellModelWithInner:(UP::SpellModelPtr)inner;

@end
#endif  // __OBJC__

// =========================================================================================================================================

