//
//  UPControl.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPControl.h"
#import "UIColor+UP.h"
#import "UPBezierPathView.h"
#import "UPMacros.h"

@interface UPControl ()
@property (nonatomic) UIControlState additionalState;
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

@implementation UPControl

+ (UPControl *)control
{
    return [[UPControl alloc] initWithFrame:CGRectZero];
}

#pragma mark - State

- (UIControlState)state
{
    return super.state | self.additionalState;
}

- (void)setNormal
{
    [super setEnabled:YES];
    [super setSelected:NO];
    [super setHighlighted:NO];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setHighlighted
{
    [super setEnabled:YES];
    [super setSelected:NO];
    [super setHighlighted:YES];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setDisabled
{
    [super setEnabled:NO];
    [super setSelected:NO];
    [super setHighlighted:NO];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setSelected
{
    [super setEnabled:YES];
    [super setSelected:YES];
    [super setHighlighted:NO];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setActive
{
    [super setEnabled:YES];
    [super setSelected:NO];
    [super setHighlighted:NO];
    [self setActive:YES];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self _controlStateChanged];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self _controlStateChanged];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self _controlStateChanged];
}

- (void)setActive:(BOOL)active
{
    if (active) {
        self.additionalState |= UPControlStateActive;
    }
    else {
        self.additionalState &= ~UPControlStateActive;
    }
    [self _controlStateChanged];
}

- (void)_controlStateChanged
{
    [self setNeedsLayout];
    [self updateControl];
}

#pragma mark - Paths

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
        self.contentPathView.userInteractionEnabled = NO;
        self.contentPathView.canonicalSize = self.canonicalSize;
        [self addSubview:self.contentPathView];
        [self _reorderPathViews];
    }
}

- (void)_createFillPathViewIfNeeded
{
    if (!self.fillPathView) {
        self.fillPathView = [UPBezierPathView bezierPathView];
        self.fillPathView.userInteractionEnabled = NO;
        self.fillPathView.canonicalSize = self.canonicalSize;
        [self addSubview:self.fillPathView];
        [self _reorderPathViews];
    }
}

- (void)_createStrokePathViewIfNeeded
{
    if (!self.strokePathView) {
        self.strokePathView = [UPBezierPathView bezierPathView];
        self.strokePathView.userInteractionEnabled = NO;
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

# pragma mark - Colors

- (void)_createColorsForStatesIfNeeded
{
    if (!self.colorsForStates) {
        self.colorsForStates = [NSMutableDictionary dictionary];
    }
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

#pragma mark - Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"begin tracking");
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"continue tracking");
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"end tracking");
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    NSLog(@"cancel tracking");

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
        self.strokePathView.fillColor = color ? color : [UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke];
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
