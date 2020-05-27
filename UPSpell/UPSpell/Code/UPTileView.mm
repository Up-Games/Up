//
//  UPTileView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPAssertions.h>
#import <UPKit/UIColor+UP.h>
#import <UPKit/UPBezierPathView.h>
#import <UPKit/UPStringTools.h>

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
@property (nonatomic) UIView *fillView;
@property (nonatomic) UPBezierPathView *strokeView;
@property (nonatomic) UPBezierPathView *glyphView;
@property (nonatomic) UPBezierPathView *scoreView;
@property (nonatomic) UPBezierPathView *multiplierView;
@property (nonatomic, readwrite) UITapGestureRecognizer *tap;
@property (nonatomic, readwrite) UIPanGestureRecognizer *pan;
@property (nonatomic, readwrite) UILongPressGestureRecognizer *longPress;
@property (nonatomic) CGFloat shadowOpacity;
@end

@implementation UPTileView

+ (UPTileView *)viewWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    return [[self alloc] _initWithGlyph:glyph score:score multiplier:multiplier];
}

- (instancetype)_initWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    self = [super initWithFrame:CGRectZero];
    self.glyph = glyph;
    self.score = score;
    self.multiplier = multiplier;
    if (glyph == UP::SentinelGlyph) {
        return self;
    }

    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0;
    self.layer.shadowRadius = 6;

    SpellLayout &layout_manager = SpellLayout::instance();
    TilePaths &tile_paths = TilePaths::instance();

    self.fillView = [[UIView alloc] initWithFrame:CGRectZero];
    self.fillView.userInteractionEnabled = NO;
    [self addSubview:self.fillView];

    self.strokeView = [UPBezierPathView bezierPathView];
    self.strokeView.userInteractionEnabled = NO;
    self.strokeView.canonicalSize = SpellLayout::CanonicalTileSize;
    self.strokeView.path = layout_manager.tile_stroke_path();
    self.strokeView.opaque = NO;
    self.strokeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.strokeView];

    self.glyphView = [UPBezierPathView bezierPathView];
    self.glyphView.userInteractionEnabled = NO;
    self.glyphView.canonicalSize = SpellLayout::CanonicalTileSize;
    self.glyphView.path = tile_paths.tile_path_for_glyph(self.glyph);
    [self addSubview:self.glyphView];

    self.scoreView = [UPBezierPathView bezierPathView];
    self.scoreView.userInteractionEnabled = NO;
    self.scoreView.canonicalSize = SpellLayout::CanonicalTileSize;
    self.scoreView.path = tile_paths.tile_path_for_score(self.score);
    [self addSubview:self.scoreView];

    if (self.multiplier != 1) {
        self.multiplierView = [UPBezierPathView bezierPathView];
        self.multiplierView.userInteractionEnabled = NO;
        self.multiplierView.canonicalSize = SpellLayout::CanonicalTileSize;
        self.multiplierView.path = tile_paths.tile_path_for_multiplier(self.multiplier);
        self.multiplierView.opaque = NO;
        [self addSubview:self.multiplierView];
    }

    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:self.tap];
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan)];
    [self addGestureRecognizer:self.pan];
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    [self addGestureRecognizer:self.longPress];

    [self updateThemeColors];
    
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

@dynamic shadowOpacity;
- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

#pragma mark - Gestures

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.highlighted = NO;
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

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.fillView.frame = bounds;
    self.strokeView.frame = bounds;
    self.glyphView.frame = bounds;
    self.scoreView.frame = bounds;
    self.multiplierView.frame = bounds;
    [self updateControl];
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
