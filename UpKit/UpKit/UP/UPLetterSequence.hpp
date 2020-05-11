//
//  UPLetterSequence.hpp
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_LETTER_SEQUENCE_HPP
#define UP_LETTER_SEQUENCE_HPP

#if __cplusplus

#import <algorithm>
#import <iostream>
#import <vector>

#import <UpKit/UPLexicon.hpp>
#import <UpKit/UPGameCode.h>
#import <UpKit/UPRandom.hpp>
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
        Random::gameplay_instance().seed_value(game_code.value());
        m_letters.clear();
    }
    
    char32_t next() {
        if (m_letters.size() == 0) {
            fill();
        }
        char32_t c = m_letters.back();
        m_letters.pop_back();
        return c;
    }
    
private:
    void fill() {
        auto &lexicon = Lexicon::instance();
        auto &random = Random::gameplay_instance();
        
        std::u32string word = lexicon.random_word(random);
        std::cout << "w: " << cpp_str(word) << std::endl;
        std::shuffle(word.begin(), word.end(), random.g());
        std::copy(word.begin(), word.end(), std::back_inserter(m_letters));
    }

    GameCode m_game_code;
    std::vector<char32_t> m_letters;
};
    
}  // namespace UP

#endif  // __cplusplus

#endif  // UP_LETTER_SEQUENCE_HPP
