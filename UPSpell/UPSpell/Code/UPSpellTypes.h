//
//  UPSpellTypes.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPMacros.h>

#if __cplusplus

namespace UP {

static constexpr char32_t SentinelGlyph = 0;

using TileIndex = size_t;
static constexpr TileIndex NotATileIndex = -1;
static constexpr size_t TileCount = 7;
static constexpr size_t LastTileIndex = TileCount - 1;

template <bool B = true>
bool valid(TileIndex idx) { return (idx < TileCount) == B; }

template <bool B = true>
bool valid_end(TileIndex idx) { return (idx <= TileCount) == B; }

#define ASSERT_IDX(idx) ASSERT_WITH_MESSAGE(valid(idx), "Invalid TileIndex: %ld", (idx))
#define ASSERT_NIDX(idx) ASSERT_WITH_MESSAGE(valid<false>(idx), "Expected invalid TileIndex: %ld", (idx))
#define ASSERT_IDX_END(idx) ASSERT_WITH_MESSAGE(valid_end(idx), "Invalid TileIndex: %ld", (idx))

enum class TileTray { None, Player, Word };

class TilePosition {
public:
    constexpr TilePosition() {}
    TilePosition(TileTray tray, TileIndex index) : m_tray(tray), m_index(index) { /*ASSERT_IDX(m_index);*/ }
    TileTray tray() const { return m_tray; }
    TileIndex index() const { return m_index; }
    
    bool valid() const { return tray() != TileTray::None && index() != NotATileIndex; }
    
private:
    TileTray m_tray = TileTray::None;
    TileIndex m_index = NotATileIndex;
};

UP_STATIC_INLINE const char *cstr_for(TileTray tray)
{
    switch (tray) {
        case TileTray::None:
            return "none";
        case TileTray::Player:
            return "player";
        case TileTray::Word:
            return "word";
    }
    ASSERT_NOT_REACHED();
    return "?";
}

UP_STATIC_INLINE bool operator==(const TilePosition &a, const TilePosition &b)
{
    return a.tray() == b.tray() && a.index() == b.index();
}

UP_STATIC_INLINE bool operator!=(const TilePosition &a, const TilePosition &b) { return !(a == b); }

template <bool B = true>
bool valid(TilePosition pos) { return pos.valid() == B; }

#define ASSERT_POS(pos) ASSERT_WITH_MESSAGE(valid(pos), "Invalid TilePosition: %s:%ld", cstr_for(pos.tray()), pos.index())
#define ASSERT_NPOS(pos) ASSERT_WITH_MESSAGE(valid<false>(pos), "Expected invalid TilePosition: %s:%ld", cstr_for(pos.tray()), pos.index())

}  // namespace UP

#endif  // __cplusplus
