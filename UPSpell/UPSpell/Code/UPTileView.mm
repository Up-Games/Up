//
//  UPTileView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UIColor+UP.h>
#import <UPKit/UPLabel.h>
#import <UPKit/UPStringTools.h>

#import "UIFont+UPSpell.h"
#import "UPTileView.h"
#import "UPSpellLayoutManager.h"

using UP::ns_str;
using UP::SpellLayoutManager;
using UP::Tile;

// =========================================================================================================================================

@interface UPLabel (UPTileView)
+ (UPLabel *)glyphLabel;
+ (UPLabel *)scoreLabel;
+ (UPLabel *)multiplierLabel;
@end

@implementation UPLabel (UPTileView)

+ (UPLabel *)glyphLabel
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    UPLabel *label = [UPLabel label];
    label.font = [UIFont tileGlyphFontOfSize:layout_manager.tile_glyph_font_metrics().point_size()];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UPLabel *)scoreLabel
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    UPLabel *label = [UPLabel label];
    label.font = [UIFont tileGlyphFontOfSize:layout_manager.tile_score_font_metrics().point_size()];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

+ (UPLabel *)multiplierLabel
{
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();
    UPLabel *label = [UPLabel label];
    label.font = [UIFont tileGlyphFontOfSize:layout_manager.tile_multiplier_font_metrics().point_size()];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

@end

// =========================================================================================================================================

@interface UPTileView ()
@property (nonatomic, readwrite) UP::Tile tile;
@property (nonatomic) UIView *fillView;
@property (nonatomic) UPLabel *glyphLabel;
@property (nonatomic) UPLabel *scoreLabel;
@property (nonatomic) UPLabel *multiplierLabel;
@end

@implementation UPTileView

+ (UPTileView *)viewWithTile:(const UP::Tile &)tile
{
    return [[self alloc] _initWithTile:tile];
}

- (instancetype)_initWithTile:(const UP::Tile &)tile
{
    self = [super initWithFrame:CGRectZero];
    self.tile = tile;

    self.fillView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.fillView];

    self.glyphLabel = [UPLabel glyphLabel];
    self.glyphLabel.string = ns_str(self.tile.glyph());
    [self addSubview:self.glyphLabel];

    self.scoreLabel = [UPLabel scoreLabel];
    self.scoreLabel.string = [NSString stringWithFormat:@"%d", self.tile.score()];
    [self addSubview:self.scoreLabel];

    if (tile.multiplier() != 1) {
        self.multiplierLabel = [UPLabel multiplierLabel];
        self.multiplierLabel.string = [NSString stringWithFormat:@"%dX", self.tile.multiplier()];
        [self addSubview:self.multiplierLabel];
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
    SpellLayoutManager &layout_manager = SpellLayoutManager::instance();

    CGRect bounds = self.bounds;
    CGFloat strokeWidth = layout_manager.tile_stroke_width();
    self.fillView.frame = CGRectInset(bounds, strokeWidth, strokeWidth);
    self.glyphLabel.frame = layout_manager.tile_glyph_frame();
    self.scoreLabel.frame = layout_manager.tile_score_frame();
    self.multiplierLabel.frame = layout_manager.tile_multipler_frame();
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.fillView.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryPrimaryFill];
    self.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke];
}

@end
