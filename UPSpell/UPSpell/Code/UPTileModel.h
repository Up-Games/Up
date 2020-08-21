//
//  UPTileModel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus

#import <UpKit/UPAssertions.h>
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
    TileModel(char32_t glyph, int multiplier = 1) : m_glyph(glyph), m_multiplier(multiplier) {
        ASSERT(valid_glyph(m_glyph));
        ASSERT(valid_multiplier(m_multiplier));
    }

    static TileModel sentinel() { return TileModel(SentinelGlyph, 0); }
    static TileModel blank() { return TileModel(BlankGlyph, 0); }

    char32_t glyph() const { return m_glyph; }
    int multiplier() const { return m_multiplier; }
    int score() const { return score_for(glyph()); }

    template <bool B = true> bool is_sentinel() const { return (glyph() == SentinelGlyph) == B; }
    template <bool B = true> bool is_blank() const { return (glyph() == BlankGlyph) == B; }

    template <bool B = true> static bool valid_glyph(char32_t glyph) {
        bool b = ((glyph >= U'A' && glyph <= U'Z') || glyph == SentinelGlyph || glyph == BlankGlyph ||
                  glyph == U'À' || glyph == U'Á' || glyph == U'Â' || glyph == U'Ä' || glyph == U'Ã' || glyph == U'Å' || glyph == U'Ā' ||
                  glyph == U'Ç' || glyph == U'Ć' || glyph == U'Č' ||
                  glyph == U'È' || glyph == U'É' || glyph == U'Ê' || glyph == U'Ë' || glyph == U'Ē' || glyph == U'Ė' || glyph == U'Ę' ||
                  glyph == U'Î' || glyph == U'Ï' || glyph == U'Í' || glyph == U'Ī' || glyph == U'Į' || glyph == U'Ì' ||
                  glyph == U'Ł' ||
                  glyph == U'Ô' || glyph == U'Ö' || glyph == U'Ò' || glyph == U'Ó' || glyph == U'Ø' || glyph == U'Ō' || glyph == U'Õ' ||
                  glyph == U'Ś' || glyph == U'Š' ||
                  glyph == U'Û' || glyph == U'Ü' || glyph == U'Ù' || glyph == U'Ú' || glyph == U'Ū' ||
                  glyph == U'Ÿ' ||
                  glyph == U'Ž' || glyph == U'Ź' || glyph == U'Ż');
        return b == B;
    }
    
    template <bool B = true> static bool valid_multiplier(int multiplier) {
        return (multiplier == 0 || multiplier == 1 || multiplier == 2) == B;
    }

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
