//
//  UPTileView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPAssertions.h>
#import <UPKit/UIColor+UP.h>
#import <UPKit/UPBezierPathView.h>
#import <UPKit/UPStringTools.h>
#import <UPKit/UPTickingAnimator.h>
#import <UPKit/UPUnitFunction.h>

#import "UIFont+UPSpell.h"
#import "UPSpellLayout.h"
#import "UPTileView.h"
#import "UPTilePaths.h"

using UP::ns_str;
using UP::SpellLayout;
using UP::TileModel;
using UP::TilePaths;

@interface UPTileView () <UIGestureRecognizerDelegate>
@property (nonatomic, readwrite) char32_t glyph;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int multiplier;
@end

static uint32_t _InstanceCount;

@implementation UPTileView

+ (UPTileView *)viewWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    return [[self alloc] _initWithGlyph:glyph score:score multiplier:multiplier];
}

- (instancetype)_initWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    self = [super initWithFrame:CGRectZero];
    
    _InstanceCount++;
    LOG(Leaks, "alloc:   %@ (%d)", self, _InstanceCount);
    
    self.glyph = glyph;
    self.score = score;
    self.multiplier = multiplier;
    if (glyph == UP::SentinelGlyph) {
        return self;
    }

    SpellLayout &layout = SpellLayout::instance();
    TilePaths &tile_paths = TilePaths::instance();

    self.canonicalSize = SpellLayout::CanonicalTileSize;

    CGRect fillRect = CGRectMake(0, 0, up_size_width(SpellLayout::CanonicalTileSize), up_size_height(SpellLayout::CanonicalTileSize));
    [self setFillPath:[UIBezierPath bezierPathWithRect:fillRect]];
    [self setFillColorCategory:UPColorCategoryPrimaryFill forState:UPControlStateNormal];
    [self setFillColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [self setFillColorAnimationDuration:0.15 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    
    [self setStrokePath:layout.tile_stroke_path()];
    [self setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryHighlightedStroke forState:UPControlStateHighlighted];
    [self setStrokeColorAnimationDuration:0.15 fromState:UPControlStateHighlighted toState:UPControlStateNormal];

    if (glyph != UP::BlankGlyph) {
        UIBezierPath *contentPath = [UIBezierPath bezierPath];
        [contentPath appendPath:tile_paths.tile_path_for_glyph(self.glyph)];
        if (self.score > 0) {
            [contentPath appendPath:tile_paths.tile_path_for_score(self.score)];
        }
        if (self.multiplier != 1) {
            [contentPath appendPath:tile_paths.tile_path_for_multiplier(self.multiplier)];
        }
        [self setContentPath:contentPath];
    }
    
    return self;
}

- (void)dealloc
{
    _InstanceCount--;
    LOG(Leaks, "dealloc: %@ (%d)", self, _InstanceCount);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"UPTileView : %c : %p", (char)self.glyph, self];
}

@end
