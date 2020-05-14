//
//  UPButton.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPBezierPathView.h"
#import "UPButton.h"
#import "UIColor+UP.h"

@interface UPButton ()
@property (nonatomic) NSMutableDictionary<NSNumber *, UIBezierPath *> *pathsForStates;
@property (nonatomic) UPBezierPathView *fillPathView;
@property (nonatomic) UPBezierPathView *strokePathView;
@property (nonatomic) UPBezierPathView *backgroundFillPathView;
@property (nonatomic) UPBezierPathView *backgroundStrokePathView;
@end

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

- (void)_createFillPathViewIfNeeded
{
    if (!self.fillPathView) {
        self.fillPathView = [UPBezierPathView bezierPathView];
        self.fillPathView.canonicalSize = self.canonicalSize;
        [self addSubview:self.fillPathView];
    }
}

- (void)setFillPath:(UIBezierPath *)path
{
    [self setFillPath:path forControlStates:UIControlStateNormal];
}

- (void)setFillPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createFillPathViewIfNeeded];
    NSNumber *key = @(controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

- (void)setStrokePath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates
{

}

- (void)_createBackgroundFillPathViewIfNeeded
{
    if (!self.backgroundFillPathView) {
        self.backgroundFillPathView = [UPBezierPathView bezierPathView];
        self.backgroundFillPathView.canonicalSize = self.canonicalSize;
        [self addSubview:self.backgroundFillPathView];
        [self sendSubviewToBack:self.backgroundFillPathView];
    }
}

- (void)setBackgroundFillPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createBackgroundFillPathViewIfNeeded];
    NSNumber *key = @(UPControlStateFlag2 | controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

- (void)setBackgroundStrokePath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates
{

}

- (void)setBackgroundPath:(UIBezierPath *)backgroundPath forControlStates:(UIControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.fillPathView.frame = bounds;
    self.strokePathView.frame = bounds;
    self.backgroundFillPathView.frame = bounds;
    self.backgroundStrokePathView.frame = bounds;
    [self updateControl];
}

#pragma mark - Updating

- (void)updateControl
{
    UIControlState state = self.state;

    if (self.fillPathView) {
        UIControlState key = state;
        UIControlState normalKey = UIControlStateNormal;
        UIBezierPath *path = self.pathsForStates[@(key)] ?: self.pathsForStates[@(normalKey)];
        self.fillPathView.path = path;
        self.fillPathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryContent];
    }
    if (self.backgroundFillPathView) {
        UIControlState key = UPControlStateFlag2 | state;
        UIControlState normalKey = UPControlStateFlag2 | UIControlStateNormal;
        UIBezierPath *path = self.pathsForStates[@(key)] ?: self.pathsForStates[@(normalKey)];
        self.backgroundFillPathView.path = path;
        self.backgroundFillPathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryPrimaryFill];
    }
}

@end
