//
//  UPTileModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus

#import <UpKit/UPMacros.h>
#import <UpKit/UPTypes.h>

@class UPTileView;

namespace UP {

static constexpr char32_t SentinelGlyph =  0;
static constexpr char32_t BlankGlyph =    32; // space

class TileModel {
public:
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

    constexpr TileModel() {}
    TileModel(char32_t glyph, int multiplier = 1) : m_glyph(glyph), m_multiplier(multiplier) {}

    static TileModel sentinel() { return TileModel(SentinelGlyph, 0); }
    static TileModel blank() { return TileModel(BlankGlyph, 0); }

    char32_t glyph() const { return m_glyph; }
    int multiplier() const { return m_multiplier; }
    int score() const { return score_for(glyph()); }

    template <bool B = true> bool is_sentinel() const { return (glyph() == SentinelGlyph) == B; }
    template <bool B = true> bool is_blank() const { return (glyph() == BlankGlyph) == B; }

private:
    char32_t m_glyph = 0;
    int m_multiplier = 1;
};

UP_STATIC_INLINE bool operator==(const TileModel &a, const TileModel &b)
{
    return a.glyph() == b.glyph() && a.multiplier() == b.multiplier();
}

UP_STATIC_INLINE bool operator!=(const TileModel &a, const TileModel &b)
{
    return !(a==b);
}

}  // namespace UP

#endif  // __cplusplus
