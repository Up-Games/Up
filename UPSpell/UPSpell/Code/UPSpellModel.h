//
//  UPSpellModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPMacros.h>

#import "UPSpellGameSummary.h"
#import "UPTileSequence.h"
#import "UPTileModel.h"

@class UPTileView;
struct sqlite3;

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
    Word(const TileArray &tiles, const std::u32string &string, int score, int total_multiplier, int total_score, bool in_lexicon) :
        m_tiles(tiles), m_string(string), m_score(score), m_total_multiplier(total_multiplier),
        m_total_score(total_score), m_in_lexicon(in_lexicon) {}

    const TileArray &tiles() const { return m_tiles; }
    TileArray &tiles() { return m_tiles; }
    const std::u32string &string() const { return m_string; }
    size_t length() const { return m_string.length(); }
    int score() const { return m_score; }
    int total_multiplier() const { return m_total_multiplier; }
    int total_score() const { return m_total_score; }
    bool in_lexicon() const { return m_in_lexicon; }
    
private:
    TileArray m_tiles;
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
        NOP    =  0, // no-op
        START  =  1, // the start state for every game
        PLAY   =  2, // start playing a game
        ADD    =  3, // move a player tray to the word tray
        REMOVE =  4, // remove a tile from the word tray, tightening up the remaining tiles (if any)
        MOVE   =  5, // move a word tray tile to a new word tray position
        PICK   =  6, // drag a tile to pick it up
        HOVER  =  7, // float above a position where a tile could be moved
        NOVER  =  8, // cancel a previous hover, tightening up the remaining tiles (if any)
        DROP   =  9, // drop a picked-up tile, leaving it where it was
        SUBMIT = 10, // accept submission of tiles in the word tray to score points
        REJECT = 11, // reject submission of tiles in the word tray to score points
        CLEAR  = 12, // return the tiles in the word to their positions in the player tray
        DUMP   = 13, // dump player tray tiles and replace them with a new set of tiles
        OVER   = 14, // game over
        QUIT   = 15, // quit the game early
        END    = 16, // the end state after game over or quit
    };

    static constexpr int SevenLetterWordBonus = 12;
    static constexpr int SixLetterWordBonus = 6;
    static constexpr int FiveLetterWordBonus = 3;

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

    SpellModel() { apply_start(Action(Opcode::START)); }
    SpellModel(const GameKey &game_key) : m_game_key(game_key), m_tile_sequence(game_key) { apply(Action(Opcode::START)); }

    GameKey game_key() const { return m_game_key; }
    
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
    bool is_game_completed() const;

    const Word &word() const { return m_word; }

    int game_score() const { return m_game_score; }
    void reset_game_score() { m_game_score = 0; }

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
    
    enum class StatsRank { Unknown, Alone, Tied };
    static constexpr size_t NotALimit = std::numeric_limits<size_t>::max();
    
    std::vector<Word> game_best_word() const;
    int game_words_submitted_count() const;
    int game_tiles_submitted_count() const;
    
    static std::pair<int, StatsRank> game_score_rank(int score);
    static std::pair<int, StatsRank> word_score_rank(int score);
    static std::pair<int, StatsRank> words_spelled_count_rank(int count);

    static std::vector<int> all_time_game_scores(size_t limit = 5);
    static std::vector<int> all_time_word_scores(size_t limit = 5);
    static std::vector<int> all_time_words_submitted_counts(size_t limit = 5);

    static std::vector<SpellGameSummary> best_games(SpellGameSummary::Metric, size_t limit = 25);
    static SpellGameSummary high_score_game();
    static SpellGameSummary last_game();

    static int all_time_games_played_count();
    static double all_time_average_game_score();
    static double all_time_word_score_average();
    static double all_time_word_length_average();
    static double all_time_average_words_submitted_count();
    static int all_time_total_tiles_used_count();

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
    void apply_over(const Action &action);
    void apply_quit(const Action &action);
    void apply_end(const Action &action);

    static sqlite3 *db_handle();

    void db_store();
    void db_drop();
    void set_db_game_id(uint64_t db_game_id) { m_db_game_id = db_game_id; }
    uint64_t db_game_id() const { return m_db_game_id; }

    GameKey m_game_key;
    TileSequence m_tile_sequence;
    TileArray m_tiles;
    std::vector<State> m_states;
    Word m_word;
    int m_game_score = 0;
    uint64_t m_db_game_id = 0;
};

using SpellModelPtr = std::shared_ptr<class SpellModel>;

}  // namespace UP

// =========================================================================================================================================

#if __OBJC__
@interface UPSpellModel : NSObject <NSSecureCoding>

@property (class, readonly) BOOL supportsSecureCoding;
@property (nonatomic, readonly) UP::SpellModelPtr *inner;

@property (nonatomic, readonly) UPGameKey *gameKey;

+ (UPSpellModel *)spellModel;
+ (UPSpellModel *)spellModelWithInner:(UP::SpellModelPtr)inner;

@end
#endif  // __OBJC__

// =========================================================================================================================================

