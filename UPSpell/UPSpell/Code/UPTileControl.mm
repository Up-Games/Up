//
//  UPTileControl.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UIColor+UP.h>
#import <UPKit/UPBezierPathView.h>
#import <UPKit/UPStringTools.h>

#import "UIFont+UPSpell.h"
#import "UPTileControl.h"
#import "UPSpellLayoutManager.h"
#import "UPTilePaths.h"

using UP::SpellLayoutManager;
using UP::Tile;
using UP::TilePaths;

@interface UPTileControl ()
@property (nonatomic, readwrite) UP::Tile tile;
@end

@implementation UPTileControl

+ (UPTileControl *)controlWithTile:(const UP::Tile &)tile
{
    return [[self alloc] _initWithTile:tile];
}

- (instancetype)_initWithTile:(const UP::Tile &)tile
{
    self = [super initWithFrame:CGRectZero];
    self.tile = tile;
    self.canonicalSize = SpellLayoutManager::CanonicalTileSize;

    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    TilePaths &tile_paths = TilePaths::instance();

    [self setFillPath:[UIBezierPath bezierPathWithRect:SpellLayoutManager::CanonicalTileFrame]];
    [self setStrokePath:layout_manager.tile_stroke_path()];

    UIBezierPath *contentPath = tile_paths.tile_path_for_glyph(tile.glyph());
    [contentPath appendPath:tile_paths.tile_path_for_score(tile.score())];
    if (tile.multiplier() != 1) {
        [contentPath appendPath:tile_paths.tile_path_for_multiplier(tile.multiplier())];
    }
    [self setContentPath:contentPath];

    [self updateThemeColors];
    [[NSNotificationCenter defaultCenter] addObserverForName:UPThemeColorsChangedNotification object:nil queue:[NSOperationQueue mainQueue]
        usingBlock:^(NSNotification * _Nonnull note) {
            [self updateThemeColors];
        }
    ];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forControlStates:UIControlStateNormal];
    [self setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forControlStates:UIControlStateHighlighted];
    [self setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forControlStates:UIControlStateNormal];
    [self setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forControlStates:UIControlStateHighlighted];
    [self setContentColor:[UIColor themeColorWithCategory:UPColorCategoryContent] forControlStates:UIControlStateNormal];
}

@end
