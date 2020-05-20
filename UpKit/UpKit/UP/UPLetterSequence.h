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
    LetterSequence() : m_game_code(GameCode()) { m_random.seed_value(m_game_code.value()); }
    LetterSequence(const GameCode &game_code) : m_game_code(game_code) { m_random.seed_value(m_game_code.value()); }

    GameCode game_code() const { return m_game_code; }
    
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
    GameCode m_game_code;
    Random m_random;
    std::vector<char32_t> m_letters;
};
    
}  // namespace UP

#endif  // __cplusplus
