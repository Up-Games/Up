//
//  UPLetterSequence.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#if __cplusplus

#import <algorithm>
#import <iostream>
#import <vector>

#import <UpKit/UPGameCode.h>
#import <UpKit/UPLexicon.h>
#import <UpKit/UPRandom.h>
#import <UpKit/UPStringTools.h>

namespace UP {
    
class LetterSequence {
public:
    static LetterSequence &create_instance() {
        g_instance = new LetterSequence();
        return *g_instance;
    }

    static LetterSequence &instance() {
        return *g_instance;
    }

    LetterSequence(LetterSequence &&) = delete;
    LetterSequence(LetterSequence const &) = delete;
    void operator=(LetterSequence const &) = delete;

    void reset() {
        set_game_code(game_code());
    }

    GameCode game_code() const { return m_game_code; }
    
    void set_game_code(const GameCode &game_code) {
        m_game_code = game_code;
        m_random.seed_value(game_code.value());
        m_letters.clear();
    }
    
    char32_t next() {
        if (m_letters.size() == 0) {
            auto &lexicon = Lexicon::instance();
            std::u32string key = lexicon.random_key(m_random);
            std::cout << "w: " << cpp_str(key) << std::endl;
            std::shuffle(key.begin(), key.end(), m_random.generator());
            std::copy(key.begin(), key.end(), std::back_inserter(m_letters));
        }
        char32_t c = m_letters.back();
        m_letters.pop_back();
        return c;
    }
    
private:
    LetterSequence() : m_game_code(GameCode()) { reset(); }

    UP_STATIC_INLINE LetterSequence *g_instance;

    GameCode m_game_code;
    Random m_random;
    std::vector<char32_t> m_letters;
};
    
}  // namespace UP

#endif  // __cplusplus
