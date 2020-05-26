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

}  // namespace UP

#endif  // __cplusplus
