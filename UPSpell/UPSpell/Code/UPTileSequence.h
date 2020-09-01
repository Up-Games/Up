//
//  UPTileSequence.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <algorithm>
#import <iostream>
#import <vector>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPLexicon.h>
#import <UpKit/UPRandom.h>
#import <UpKit/UPStringTools.h>

#import "UPTileModel.h"

namespace UP {
    
class TileSequence {
public:
    explicit TileSequence(const GameKey &game_key = GameKey()) : m_game_key(game_key) {
        m_random.seed_value(m_game_key.value());
        m_multiplier_countdown = m_random.uint32_in_range(1, MultiplierStart);
    }

    GameKey game_key() const { return m_game_key; }
    
    TileModel next() {
        if (m_letters.size() == 0) {
            auto &lexicon = Lexicon::fixed_instance();
            std::u32string key = lexicon.random_key(m_random);
            LOG(Lexicon, "w: %s", cpp_str(key).c_str());
            std::shuffle(key.begin(), key.end(), m_random.generator());
            std::copy(key.begin(), key.end(), std::back_inserter(m_letters));
        }
        char32_t c = m_letters.back();
        if (Lexicon::is_vowel(c)) {
            m_consonant_run = 0;
        }
        else {
            m_consonant_run++;
        }
        if (m_consonant_run >= 5) {
            m_consonant_run = 0;
            // Nothing stops a game like having no vowels, so if there's a long consonant run,
            // insert a random vowel. Frequencies taken from:
            // https://en.wikipedia.org/wiki/Letter_frequency
            static constexpr float Freq_U = 0.0736f;
            static constexpr float Freq_O = 0.2003f;
            static constexpr float Freq_I = 0.2014f;
            static constexpr float Freq_A = 0.2268f;
            float f = m_random.unit();
            if (f <= Freq_U) {
                c = 'U';
            }
            else if (f <= Freq_U + Freq_O) {
                c = 'O';
            }
            else if (f <= Freq_U + Freq_O + Freq_I) {
                c = 'I';
            }
            else if (f <= Freq_U + Freq_O + Freq_I + Freq_A) {
                c = 'A';
            }
            else {
                c = 'E';
            }
            LOG(Lexicon, "consonant run stopped: %c", c);
        }
        else {
            m_letters.pop_back();
        }
        int m = 1;
        m_multiplier_countdown--;
        if (m_multiplier_countdown == 0) {
            m_multiplier_countdown = MultiplierSpan;
            m = 2;
        }
        return TileModel(c, m);
    }
    
private:
    static constexpr int MultiplierStart = 10;
    static constexpr int MultiplierSpan = 25;

    GameKey m_game_key;
    Random m_random;
    std::vector<char32_t> m_letters;
    int m_multiplier_countdown = 0;
    int m_consonant_run = 0;
};
    
}  // namespace UP
