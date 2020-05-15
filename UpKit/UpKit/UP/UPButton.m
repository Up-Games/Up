//
//  UPButton.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UIColor+UP.h"
#import "UPBezierPathView.h"
#import "UPButton.h"
#import "UPMacros.h"

@interface UPButton ()
@property (nonatomic) NSMutableDictionary<NSNumber *, UIBezierPath *> *pathsForStates;
@property (nonatomic) NSMutableDictionary<NSNumber *, UIColor *> *colorsForStates;
@property (nonatomic) UPBezierPathView *contentPathView;
@property (nonatomic) UPBezierPathView *fillPathView;
@property (nonatomic) UPBezierPathView *strokePathView;
@end

UP_STATIC_INLINE NSNumber * _ContentKey(UIControlState controlState)
{
    return @(controlState);
}

UP_STATIC_INLINE NSNumber * _FillKey(UIControlState controlState)
{
    return @(UPControlStateFlag1 | controlState);
}

UP_STATIC_INLINE NSNumber * _StrokeKey(UIControlState controlState)
{
    return @(UPControlStateFlag2 | controlState);
}

@implementation UPButton

+ (UPButton *)button
{
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)_createPathsForStatesIfNeeded
{
    if (!self.pathsForStates) {
        self.pathsForStates = [NSMutableDictionary dictionary];
    }
}

- (void)_createColorsForStatesIfNeeded
{
    if (!self.colorsForStates) {
        self.colorsForStates = [NSMutableDictionary dictionary];
    }
}

- (void)_reorderPathViews
{
    if (self.fillPathView) {
        [self bringSubviewToFront:self.fillPathView];
    }
    if (self.strokePathView) {
        [self bringSubviewToFront:self.strokePathView];
    }
    if (self.contentPathView) {
        [self bringSubviewToFront:self.contentPathView];
    }
}

- (void)_createContentPathViewIfNeeded
{
    if (!self.contentPathView) {
        self.contentPathView = [UPBezierPathView bezierPathView];
        self.contentPathView.canonicalSize = self.canonicalSize;
        [self addSubview:self.contentPathView];
        [self _reorderPathViews];
    }
}

- (void)_createFillPathViewIfNeeded
{
    if (!self.fillPathView) {
        self.fillPathView = [UPBezierPathView bezierPathView];
        self.fillPathView.canonicalSize = self.canonicalSize;
        [self addSubview:self.fillPathView];
        [self _reorderPathViews];
    }
}

- (void)_createStrokePathViewIfNeeded
{
    if (!self.strokePathView) {
        self.strokePathView = [UPBezierPathView bezierPathView];
        self.strokePathView.canonicalSize = self.canonicalSize;
        [self addSubview:self.strokePathView];
        [self _reorderPathViews];
    }
}

- (void)setContentPath:(UIBezierPath *)path
{
    [self setContentPath:path forControlStates:UIControlStateNormal];
}

- (void)setContentPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createContentPathViewIfNeeded];
    NSNumber *key = _ContentKey(controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

- (void)setContentColor:(UIColor *)color
{
    [self setContentColor:color forControlStates:UIControlStateNormal];
}

- (void)setContentColor:(UIColor *)color forControlStates:(UIControlState)controlStates
{
    [self _createColorsForStatesIfNeeded];
    NSNumber *key = _ContentKey(controlStates);
    self.colorsForStates[key] = color;
    [self setNeedsLayout];
}

- (void)setFillPath:(UIBezierPath *)path
{
    [self setFillPath:path forControlStates:UIControlStateNormal];
}

- (void)setFillPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createFillPathViewIfNeeded];
    NSNumber *key = _FillKey(controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

- (void)setFillColor:(UIColor *)color
{
    [self setFillColor:color forControlStates:UIControlStateNormal];
}

- (void)setFillColor:(UIColor *)color forControlStates:(UIControlState)controlStates
{
    [self _createColorsForStatesIfNeeded];
    NSNumber *key = _FillKey(controlStates);
    self.colorsForStates[key] = color;
    [self setNeedsLayout];
}

- (void)setStrokePath:(UIBezierPath *)path
{
    [self setStrokePath:path forControlStates:UIControlStateNormal];
}

- (void)setStrokePath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createStrokePathViewIfNeeded];
    NSNumber *key = _StrokeKey(controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

- (void)setStrokeColor:(UIColor *)color
{
    [self setStrokeColor:color forControlStates:UIControlStateNormal];
}

- (void)setStrokeColor:(UIColor *)color forControlStates:(UIControlState)controlStates
{
    [self _createColorsForStatesIfNeeded];
    NSNumber *key = _StrokeKey(controlStates);
    self.colorsForStates[key] = color;
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.fillPathView.frame = bounds;
    self.strokePathView.frame = bounds;
    self.contentPathView.frame = bounds;
    [self updateControl];
}

#pragma mark - Updating

- (void)updateControl
{
    UIControlState state = self.state;

    if (self.fillPathView) {
        NSNumber *key = _FillKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_FillKey(UIControlStateNormal)];
        self.fillPathView.path = path;
        UIColor *color = self.colorsForStates[key] ?: self.colorsForStates[_FillKey(UIControlStateNormal)];
        self.fillPathView.fillColor = color ? color : [UIColor themeColorWithCategory:UPColorCategoryPrimaryFill];
    }
    if (self.strokePathView) {
        NSNumber *key = _StrokeKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_StrokeKey(UIControlStateNormal)];
        self.strokePathView.path = path;
        UIColor *color = self.colorsForStates[key] ?: self.colorsForStates[_StrokeKey(UIControlStateNormal)];
        self.strokePathView.fillColor = color ? color : [UIColor themeColorWithCategory:UPColorCategoryContent];
    }
    if (self.contentPathView) {
        NSNumber *key = _ContentKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_ContentKey(UIControlStateNormal)];
        self.contentPathView.path = path;
        UIColor *color = self.colorsForStates[key] ?: self.colorsForStates[_ContentKey(UIControlStateNormal)];
        self.contentPathView.fillColor = color ? color : [UIColor themeColorWithCategory:UPColorCategoryContent];
    }
}

@end
