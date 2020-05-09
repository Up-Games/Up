//
//  UPTile.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#if __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#if __cplusplus

#import <UpKit/UPMacros.h>

#import <array>

namespace UP {

class Tile {
public:
    static constexpr char32_t SentinelGlyph = 0;

    Tile() {}
    Tile(char32_t glyph, int score = 0, int multiplier = 1) : m_glyph(glyph), m_score(score), m_multiplier(multiplier) {}

    static Tile sentinel() { return Tile(SentinelGlyph, 0, 0); }

    char32_t glyph() const { return m_glyph; }
    int score() const { return m_score; }
    int multiplier() const { return m_multiplier; }

    bool is_sentinel() const { return m_glyph == SentinelGlyph; }

private:
    char32_t m_glyph = 0;
    int m_score = 0;
    int m_multiplier = 1;
};

UP_STATIC_INLINE bool operator==(const Tile &a, const Tile &b) {
    return a.glyph() == b.glyph() && a.score() == b.score() && a.multiplier() == b.multiplier();
}

UP_STATIC_INLINE bool operator!=(const Tile &a, const Tile &b) {
    return !(a == b);
}

enum { TileCount = 7 };
using TileArray = std::array<Tile, TileCount>;
using MarkedArray = std::array<bool, TileCount>;

}  // namespace UP

#endif  // __cplusplus


#if __OBJC__

@interface UPTile : NSObject
@property (nonatomic, readonly) char32_t glyph;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int multiplier;

+ (UPTile *)tileWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier;

- (instancetype)init NS_UNAVAILABLE;

@end

#endif  // __OBJC__
