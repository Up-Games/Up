//
//  UPLetterSequence.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_LETTER_SEQUENCE_H
#define UP_LETTER_SEQUENCE_H

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
    LetterSequence() : m_game_code(GameCode()) { reset(); }
    LetterSequence(const GameCode &game_code) : m_game_code(game_code) { reset(); }
    
    GameCode game_code() const { return m_game_code; }
    
    void reset() {
        set_game_code(game_code());
    }
    
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
            std::shuffle(key.begin(), key.end(), *m_random.generator());
            std::copy(key.begin(), key.end(), std::back_inserter(m_letters));
        }
        char32_t c = m_letters.back();
        m_letters.pop_back();
        return c;
    }
    
private:
    GameCode m_game_code;
    Random m_random;
    std::vector<char32_t> m_letters;
};
    
}  // namespace UP

#endif  // __cplusplus

#endif  // UP_LETTER_SEQUENCE_H
