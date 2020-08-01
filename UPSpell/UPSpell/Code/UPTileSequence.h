//
//  UPTileSequence.h
//  Copyright © 2020 Up Games. All rights reserved.
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
            auto &lexicon = Lexicon::instance();
            std::u32string key = lexicon.random_key(m_random);
            LOG(Lexicon, "w: %s", cpp_str(key).c_str());
            std::shuffle(key.begin(), key.end(), m_random.generator());
            std::copy(key.begin(), key.end(), std::back_inserter(m_letters));
        }
        char32_t c = m_letters.back();
        m_letters.pop_back();
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
};
    
}  // namespace UP
