//
//  UPTileView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UIColor+UP.h>
#import <UPKit/UPBezierPathView.h>
#import <UPKit/UPStringTools.h>

#import "UIFont+UPSpell.h"
#import "UPTileControl.h"
#import "UPSpellLayoutManager.h"

using UP::ns_str;
using UP::SpellLayoutManager;
using UP::Tile;

@interface UPTileControl ()
@property (nonatomic, readwrite) UP::Tile tile;
@property (nonatomic) UIView *fillView;
@property (nonatomic) UPBezierPathView *strokeView;
@property (nonatomic) UPBezierPathView *glyphView;
@property (nonatomic) UPBezierPathView *scoreView;
@property (nonatomic) UPBezierPathView *multiplierView;
@end

@implementation UPTileControl

+ (UPTileControl *)viewWithTile:(const UP::Tile &)tile
{
    return [[self alloc] _initWithTile:tile];
}

- (instancetype)_initWithTile:(const UP::Tile &)tile
{
    self = [super initWithFrame:CGRectZero];
    self.tile = tile;

    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();

    self.fillView = [[UIView alloc] initWithFrame:CGRectZero];
    self.fillView.userInteractionEnabled = NO;
    [self addSubview:self.fillView];

    self.strokeView = [UPBezierPathView bezierPathView];
    self.strokeView.userInteractionEnabled = NO;
    self.strokeView.canonicalSize = SpellLayoutManager::CanonicalTileSize;
    self.strokeView.path = layout_manager.tile_stroke_path();
    self.strokeView.opaque = NO;
    self.strokeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.strokeView];

    self.glyphView = [UPBezierPathView bezierPathView];
    self.glyphView.userInteractionEnabled = NO;
    self.glyphView.canonicalSize = SpellLayoutManager::CanonicalTileSize;
    self.glyphView.path = layout_manager.tile_path_for_glyph(tile.glyph());
    [self addSubview:self.glyphView];

    self.scoreView = [UPBezierPathView bezierPathView];
    self.scoreView.userInteractionEnabled = NO;
    self.scoreView.canonicalSize = SpellLayoutManager::CanonicalTileSize;
    self.scoreView.path = layout_manager.tile_path_for_score(tile.score());
    [self addSubview:self.scoreView];

    if (tile.multiplier() != 1) {
        self.multiplierView = [UPBezierPathView bezierPathView];
        self.multiplierView.userInteractionEnabled = NO;
        self.multiplierView.canonicalSize = SpellLayoutManager::CanonicalTileSize;
        self.multiplierView.path = layout_manager.tile_path_for_multiplier(tile.multiplier());
        [self addSubview:self.multiplierView];
    }

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

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.fillView.frame = bounds;
    self.strokeView.frame = bounds;
    self.glyphView.frame = bounds;
    self.scoreView.frame = bounds;
    self.multiplierView.frame = bounds;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.fillView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryPrimaryFill];
    self.strokeView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke];
    self.glyphView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryContent];
    self.scoreView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryContent];
    self.multiplierView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryContent];
}

@end
