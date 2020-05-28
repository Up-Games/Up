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
using UP::Tile;
using UP::TilePaths;

@interface UPTileView ()
@property (nonatomic, readwrite) char32_t glyph;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) int multiplier;
@property (nonatomic, readwrite) UITapGestureRecognizer *tap;
@property (nonatomic, readwrite) UIPanGestureRecognizer *pan;
@property (nonatomic, readwrite) UILongPressGestureRecognizer *longPress;
@property (nonatomic) UPTickingAnimator *dehighlightAnimator;

@end

@implementation UPTileView

+ (UPTileView *)viewWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    return [[self alloc] _initWithGlyph:glyph score:score multiplier:multiplier];
}

- (instancetype)_initWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    self = [super initWithFrame:CGRectZero];
    
    self.autoHighlights = NO;
    
    self.glyph = glyph;
    self.score = score;
    self.multiplier = multiplier;
    if (glyph == UP::SentinelGlyph) {
        return self;
    }

    SpellLayout &layout_manager = SpellLayout::instance();
    TilePaths &tile_paths = TilePaths::instance();

    self.canonicalSize = SpellLayout::CanonicalTileSize;

    CGRect fillRect = CGRectMake(0, 0, up_size_width(SpellLayout::CanonicalTileSize), up_size_height(SpellLayout::CanonicalTileSize));
    [self setFillPath:[UIBezierPath bezierPathWithRect:fillRect]];
    [self setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forControlStates:UPControlStateNormal];
    [self setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forControlStates:UPControlStateHighlighted];
    [self setAnimatesFillColor:YES fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    
    [self setStrokePath:layout_manager.tile_stroke_path()];
    [self setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forControlStates:UPControlStateNormal];
    [self setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forControlStates:UPControlStateHighlighted];

    UIBezierPath *contentPath = [UIBezierPath bezierPath];
    [contentPath appendPath:tile_paths.tile_path_for_glyph(self.glyph)];
    [contentPath appendPath:tile_paths.tile_path_for_score(self.score)];
    if (self.multiplier != 1) {
        [contentPath appendPath:tile_paths.tile_path_for_multiplier(self.multiplier)];
    }
    [self setContentPath:contentPath];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:self.tap];
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan)];
    [self addGestureRecognizer:self.pan];
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    [self addGestureRecognizer:self.longPress];
    self.longPress.enabled = NO;

    return self;
}

- (void)dealloc
{
    LOG(Leaks, "dealloc: %@", self);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"UPTileView : %c : %p", (char)self.glyph, self];
}

#pragma mark - Gestures

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.gestureDelegate) {
        self.highlighted = YES;
        return YES;
    }
    return [self.gestureDelegate beginTracking:self touch:touch event:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.gestureDelegate) {
        return YES;
    }
    return [self.gestureDelegate continueTracking:self touch:touch event:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.gestureDelegate) {
        self.highlighted = NO;
        return;
    }
    [self.gestureDelegate endTracking:self touch:touch event:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    if (!self.gestureDelegate) {
        self.highlighted = NO;
        return;
    }
    [self.gestureDelegate cancelTracking:self event:event];
}

- (void)handleTap
{
    [self.gestureDelegate tileViewTapped:self];
}

- (void)handlePan
{
    [self.gestureDelegate tileViewPanned:self];
}

- (void)handleLongPress
{
    [self.gestureDelegate tileViewLongPressed:self];
}

@dynamic tapEnabled;
- (void)setTapEnabled:(BOOL)enabled
{
    self.tap.enabled = enabled;
}

- (BOOL)tapEnabled
{
    return self.tap.enabled;
}

@dynamic panEnabled;
- (void)setPanEnabled:(BOOL)enabled
{
    self.pan.enabled = enabled;
}

- (BOOL)panEnabled
{
    return self.pan.enabled;
}

@dynamic longPressEnabled;
- (void)setLongPressEnabled:(BOOL)enabled
{
    self.longPress.enabled = enabled;
}

- (BOOL)longPressEnabled
{
    return self.longPress.enabled;
}

- (void)controlUpdate
{
    if (self.dehighlightAnimator) {
        return;
    }
    [super controlUpdate];
}

@end
