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
@property (nonatomic) UPBezierPathView *contentPathView;
@property (nonatomic) UPBezierPathView *fillPathView;
@property (nonatomic) UPBezierPathView *strokePathView;
@end

UP_STATIC_INLINE NSNumber * _ContentPathKey(UIControlState controlState)
{
    return @(controlState);
}

UP_STATIC_INLINE NSNumber * _FillPathKey(UIControlState controlState)
{
    return @(UPControlStateFlag1 | controlState);
}

UP_STATIC_INLINE NSNumber * _StrokePathKey(UIControlState controlState)
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
    NSNumber *key = _ContentPathKey(controlStates);
    self.pathsForStates[key] = path;
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
    NSNumber *key = _FillPathKey(controlStates);
    self.pathsForStates[key] = path;
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
    NSNumber *key = _StrokePathKey(controlStates);
    self.pathsForStates[key] = path;
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
        NSNumber *key = _FillPathKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_FillPathKey(UIControlStateNormal)];
        self.fillPathView.path = path;
        self.fillPathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryPrimaryFill];
    }
    if (self.strokePathView) {
        NSNumber *key = _StrokePathKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_StrokePathKey(UIControlStateNormal)];
        self.strokePathView.path = path;
        self.strokePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke];
    }
    if (self.contentPathView) {
        NSNumber *key = _ContentPathKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_ContentPathKey(UIControlStateNormal)];
        self.contentPathView.path = path;
        self.contentPathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryContent];
    }
}

@end
