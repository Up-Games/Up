//
//  UPTile.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPTile.h"
#import "UPTileView.h"

namespace UP {

UPTileView *Tile::view()
{
    if (!m_view) {
        m_view = [UPTileView viewWithGlyph:glyph() score:score() multiplier:multiplier()];
    }
    return m_view;
}

UPTileView *Tile::ghosted_view()
{
    if (!m_ghosted_view) {
        m_ghosted_view = [UPTileView viewWithGlyph:glyph() score:score() multiplier:multiplier()];
    }
    return m_ghosted_view;
}

}  // namespace UP
