//
//  UPLetterTileTray.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#if __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#ifdef __cplusplus

#import <array>

#import <UpKit/UPLetterTile.h>
#import <UpKit/UPLetterTileSequence.h>

namespace UP {

enum { TileCount = 7 };
using LetterTileArray = std::array<LetterTile, TileCount>;
using MarkedArray = std::array<bool, TileCount>;

class LetterTileTray {
public:
    LetterTileTray() {}
    
    LetterTile tile_at_index(size_t idx) const { return m_tiles.at(idx); }
    void mark_at_index(size_t idx) { m_marked.at(idx) = true; }
    void unmark_at_index(size_t idx) { m_marked.at(idx) = false; }
    void mark_all() { m_marked.fill(true); }
    void unmark_all() { m_marked.fill(false); }
    size_t count_marked() const {
        size_t count = 0;
        for (const auto &mark : m_marked) {
            if (mark) {
                count++;
            }
        }
        return count;
    }
    void sentinelize_marked() {
        size_t idx = 0;
        for (const auto &mark : m_marked) {
            if (mark) {
                m_tiles[idx] = LetterTile::sentinel();
            }
            idx++;
        }
    }
    void fill() {
        auto &seq = LetterTileSequence::instance();
        sentinelize_marked();
        for (auto &tile : m_tiles) {
            if (tile.is_sentinel()) {
                char32_t c = seq.next();
                tile = LetterTile(c);
            }
        }
        unmark_all();
    }

private:
    LetterTileArray m_tiles;
    MarkedArray m_marked;
};

}  // namespace UP

#endif  // __cplusplus