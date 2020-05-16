//
//  UPTileView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPLabel.h>

#import "UPTileView.h"
#import "UPSpellLayoutManager.h"

using UP::Tile;

@interface UPTileView ()
@property (nonatomic, readwrite) UP::Tile tile;
@property (nonatomic) UPLabel *glyphLabel;
@property (nonatomic) UPLabel *scoreLabel;
@property (nonatomic) UPLabel *multiplierLabel;
@end

@implementation UPTileView

+ (UPTileView *)viewWithTile:(const UP::Tile &)letterTile
{
    return [[self alloc] _initWithTile:letterTile];
}

- (instancetype)_initWithTile:(const UP::Tile &)letterTile
{
    self = [super initWithFrame:CGRectZero];
    self.tile = letterTile;
    return self;
}

@dynamic glyph;
- (char32_t)glyph
{
    return self.tile.glyph();
}

@dynamic score;
- (int)score
{
    return self.tile.score();
}

@dynamic multiplier;
- (int)multiplier
{
    return self.tile.multiplier();
}

@dynamic isSentinel;
- (BOOL)isSentinel
{
    return self.tile.is_sentinel();
}

#pragma mark - Layout

- (void)layoutSubviews
{

}

@end
