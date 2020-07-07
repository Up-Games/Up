//
//  UPSpellGameSummary.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameKey.h>

namespace UP {

class SpellGameSummary {
public:
    enum class Metric {
        GameScore,
        WordsSpelled,
        AverageWordScore,
        AverageWordLength,
        GameKey
    };
    
    SpellGameSummary() {}
    SpellGameSummary(uint64_t game_id, int game_score, int words_submitted_count,
                     double word_score_average, double word_length_average, GameKey game_key) :
    m_game_id(game_id), m_game_score(game_score), m_words_submitted_count(words_submitted_count),
    m_word_score_average(word_score_average), m_word_length_average(word_length_average), m_game_key(game_key) {}
    
    uint64_t game_id() const { return m_game_id; }
    int game_score() const { return m_game_score; }
    int words_submitted_count() const { return m_words_submitted_count; }
    double word_score_average() const { return m_word_score_average; }
    double word_length_average() const { return m_word_length_average; }
    GameKey game_key() const { return m_game_key; }

    template <bool B = true> bool is_empty() const { return (game_id() == 0) == B; }

private:
    uint64_t m_game_id = 0;
    int m_game_score = 0;
    int m_words_submitted_count = 0;
    double m_word_score_average = 0;
    double m_word_length_average = 0;
    GameKey m_game_key;
};

}  // namespace UP
