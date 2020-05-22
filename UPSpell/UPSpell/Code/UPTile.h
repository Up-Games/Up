//
//  UPTile.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifdef __cplusplus

#import <UpKit/UPMacros.h>

namespace UP {

class Tile {
public:
    static constexpr char32_t SentinelGlyph = 0;

    static int score_for(char32_t glyph) {
        static constexpr int scores[] = {
            1, /* A */    4, /* B */    3, /* C */    2, /* D */    1, /* E */    3, /* F */    3, /* G */    2, /* H */
            1, /* I */    8, /* J */    4, /* K */    2, /* L */    3, /* M */    1, /* N */    1, /* O */    3, /* P */
            9, /* Q */    1, /* R */    1, /* S */    1, /* T */    1, /* U */    5, /* V */    3, /* W */    8, /* X */
            4, /* Y */    9, /* Z */
        };
        if (glyph < U'A' || glyph > U'Z') {
            return 1;
        }
        char32_t k = glyph - 'A';
        return scores[k];
    }

    Tile() {}
    Tile(char32_t glyph, int multiplier = 1) : m_glyph(glyph), m_multiplier(multiplier) {}

    static Tile sentinel() { return Tile(SentinelGlyph, 0); }

    char32_t glyph() const { return m_glyph; }
    int score() const { return score_for(glyph()); }
    int multiplier() const { return m_multiplier; }

    template <bool B = true> bool is_sentinel() const { return (m_glyph == SentinelGlyph) == B; }

private:
    char32_t m_glyph = 0;
    int m_multiplier = 1;
};

UP_STATIC_INLINE bool operator==(const Tile &a, const Tile &b) {
    return a.glyph() == b.glyph() && a.score() == b.score() && a.multiplier() == b.multiplier();
}

UP_STATIC_INLINE bool operator!=(const Tile &a, const Tile &b) {
    return !(a == b);
}

}  // namespace UP

#endif  // __cplusplus
