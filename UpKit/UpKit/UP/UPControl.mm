//
//  UPControl.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>

#import "UPAnimator.h"
#import "UPAssertions.h"
#import "UPBezierPathView.h"
#import "UPControl.h"
#import "UIColor+UP.h"
#import "UPGestureRecognizer.h"
#import "UPLabel.h"
#import "UPMacros.h"
#import "UPMath.h"
#import "UPNeedsUpdater.h"
#import "UPTicker.h"
#import "UPTickingAnimator.h"
#import "UPTimeSpanning.h"

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::set_color;

using UPControlStatePair = std::pair<UPControlState, UPControlState>;

@interface UPControl () <UPNeedsUpdatable>
{
    std::map<NSUInteger, __strong UIBezierPath *> m_paths;
    std::map<NSUInteger, __strong NSString *> m_label_strings;
    std::map<NSUInteger, UPColorCategory> m_color_categories;
    std::map<UPControlStatePair, CFTimeInterval> m_color_animations;
}
@property (nonatomic, readwrite) UPControlState state;
@property (nonatomic) UPControlState previousState;
@property (nonatomic, readwrite) UPBezierPathView *fillPathView;
@property (nonatomic, readwrite) UPBezierPathView *strokePathView;
@property (nonatomic, readwrite) UPBezierPathView *contentPathView;
@property (nonatomic, readwrite) UPBezierPathView *auxiliaryPathView;
@property (nonatomic, readwrite) UPBezierPathView *accentPathView;
@property (nonatomic, readwrite) UPLabel *label;
@property (nonatomic) uint32_t fillColorAnimatorSerialNumber;
@property (nonatomic) uint32_t strokeColorAnimatorSerialNumber;
@property (nonatomic) uint32_t contentPathColorAnimatorSerialNumber;
@property (nonatomic) uint32_t auxiliaryPathColorAnimatorSerialNumber;
@property (nonatomic) uint32_t accentPathColorAnimatorSerialNumber;
@property (nonatomic) uint32_t labelColorAnimatorSerialNumber;
@property (nonatomic) BOOL frozen;
@end

UP_STATIC_INLINE NSUInteger up_control_key_fill(UPControlState controlState)
{
    return UPControlElementFill | controlState;
}

UP_STATIC_INLINE NSUInteger up_control_key_stroke(UPControlState controlState)
{
    return UPControlElementStroke | controlState;
}

UP_STATIC_INLINE NSUInteger up_control_key_content(UPControlState controlState)
{
    return UPControlElementContent | controlState;
}

UP_STATIC_INLINE NSUInteger up_control_key_auxiliary(UPControlState controlState)
{
    return UPControlElementAuxiliary | controlState;
}

UP_STATIC_INLINE NSUInteger up_control_key_accent(UPControlState controlState)
{
    return UPControlElementAccent | controlState;
}

UP_STATIC_INLINE NSUInteger up_control_key_label(UPControlState controlState)
{
    return UPControlElementLabel | controlState;
}

@implementation UPControl

#pragma mark - Initialization

+ (UPControl *)control
{
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.multipleTouchEnabled = NO;
    self.autoHighlights = YES;
    self.previousState = UPControlStateInvalid;
    self.state = UPControlStateNormal;
    self.chargeOutsets = UPOutsetsZero;
    return self;
}

#pragma mark - Canonical Size

- (void)setCanonicalSize:(CGSize)canonicalSize
{
    _canonicalSize = canonicalSize;
    self.fillPathView.canonicalSize = canonicalSize;
    self.strokePathView.canonicalSize = canonicalSize;
    self.contentPathView.canonicalSize = canonicalSize;
    self.auxiliaryPathView.canonicalSize = canonicalSize;
    self.accentPathView.canonicalSize = canonicalSize;
    [self setNeedsLayout];
}

#pragma mark - State

@dynamic enabled, selected, highlighted, active;

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        self.state |= UPControlStateSelected;
    }
    else {
        self.state &= ~UPControlStateSelected;
    }
    [self setNeedsUpdate];
}

- (BOOL)isSelected
{
    return self.state & UPControlStateSelected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (self.highlightedLocked && !highlighted) {
        return;
    }
    if (highlighted) {
        self.state |= UPControlStateHighlighted;
    }
    else {
        self.state &= ~UPControlStateHighlighted;
    }
    [self setNeedsUpdate];
}

- (BOOL)isHighlighted
{
    return self.state & UPControlStateHighlighted;
}

- (void)setDisabled:(BOOL)disabled
{
    if (disabled) {
        self.state |= UPControlStateDisabled;
    }
    else {
        self.state &= ~UPControlStateDisabled;
    }
    [self setNeedsUpdate];
}

- (void)setEnabled:(BOOL)enabled
{
    [self setDisabled:!enabled];
}

- (BOOL)isEnabled
{
    return (self.state & UPControlStateDisabled) == 0;
}

- (void)setActive:(BOOL)active
{
    if (active) {
        self.state |= UPControlStateActive;
    }
    else {
        self.state &= ~UPControlStateActive;
    }
    [self setNeedsUpdate];
}

- (BOOL)isActive
{
    return self.state & UPControlStateActive;
}

- (void)setNormal
{
    [self setDisabled:NO];
    [self setSelected:NO];
    [self setHighlighted:NO];
    [self setActive:NO];
    [self setNeedsUpdate];
}

- (void)setHighlighted
{
    [self setDisabled:NO];
    [self setSelected:NO];
    [self setHighlighted:YES];
    [self setActive:NO];
    [self setNeedsUpdate];
}

- (void)setDisabled
{
    [self setDisabled:YES];
    [self setSelected:NO];
    [self setHighlighted:NO];
    [self setActive:NO];
    [self setNeedsUpdate];
}

- (void)setSelected
{
    [self setDisabled:NO];
    [self setSelected:YES];
    [self setHighlighted:NO];
    [self setActive:NO];
    [self setNeedsUpdate];
}

- (void)setActive
{
    [self setDisabled:NO];
    [self setSelected:NO];
    [self setHighlighted:NO];
    [self setActive:YES];
    [self setNeedsUpdate];
}

#pragma mark - View reordering

- (void)bringPathViewToFront:(UPBezierPathView *)view
{
    [self bringSubviewToFront:view];
}

- (void)sendPathViewToBack:(UPBezierPathView *)view
{
    [self sendSubviewToBack:view];
}

#pragma mark - Subview creation

- (void)_createFillPathViewIfNeeded
{
    if (!_fillPathView) {
        _fillPathView = [UPBezierPathView bezierPathView];
        _fillPathView.userInteractionEnabled = NO;
        _fillPathView.canonicalSize = self.canonicalSize;
        [self addSubview:_fillPathView];
    }
}

- (void)_createStrokePathViewIfNeeded
{
    if (!_strokePathView) {
        _strokePathView = [UPBezierPathView bezierPathView];
        _strokePathView.userInteractionEnabled = NO;
        _strokePathView.canonicalSize = self.canonicalSize;
        [self addSubview:_strokePathView];
    }
}

- (void)_createContentPathViewIfNeeded
{
    if (!_contentPathView) {
        _contentPathView = [UPBezierPathView bezierPathView];
        _contentPathView.userInteractionEnabled = NO;
        _contentPathView.canonicalSize = self.canonicalSize;
        [self addSubview:_contentPathView];
    }
}

- (void)_createAuxiliaryPathViewIfNeeded
{
    if (!_auxiliaryPathView) {
        _auxiliaryPathView = [UPBezierPathView bezierPathView];
        _auxiliaryPathView.userInteractionEnabled = NO;
        _auxiliaryPathView.canonicalSize = self.canonicalSize;
        [self addSubview:_auxiliaryPathView];
    }
}

- (void)_createAccentPathViewIfNeeded
{
    if (!_accentPathView) {
        _accentPathView = [UPBezierPathView bezierPathView];
        _accentPathView.userInteractionEnabled = NO;
        _accentPathView.canonicalSize = self.canonicalSize;
        [self addSubview:_accentPathView];
    }
}

- (void)_createLabelIfNeeded
{
    if (!_label) {
        _label = [UPLabel label];
        _label.userInteractionEnabled = NO;
        _label.backgroundColorCategory = UPColorCategoryClear;
        [self addSubview:_label];
    }
}

#pragma mark - Subview accessors

- (UPBezierPathView *)fillPathView
{
    [self _createFillPathViewIfNeeded];
    return _fillPathView;
}

- (UPBezierPathView *)strokePathView
{
    [self _createStrokePathViewIfNeeded];
    return _strokePathView;
}

- (UPBezierPathView *)contentPathView
{
    [self _createContentPathViewIfNeeded];
    return _contentPathView;
}

- (UPBezierPathView *)auxiliaryPathView
{
    [self _createAuxiliaryPathViewIfNeeded];
    return _auxiliaryPathView;
}

- (UPBezierPathView *)accentPathView
{
    [self _createAccentPathViewIfNeeded];
    return _accentPathView;
}

- (UPLabel *)label
{
    [self _createLabelIfNeeded];
    return _label;
}

#pragma mark - Paths

- (void)setFillPath:(UIBezierPath *)path
{
    [self setFillPath:path forState:UPControlStateNormal];
}

- (void)setFillPath:(UIBezierPath *)path forState:(UPControlState)state
{
    [self _createFillPathViewIfNeeded];
    NSUInteger k = up_control_key_fill(state);
    auto it = m_paths.find(k);
    if (it == m_paths.end()) {
        m_paths.emplace(k, path);
    }
    else {
        it->second = path;
    }
    [self invalidate];
    [self setNeedsUpdate];
}

- (UIBezierPath *)fillPathForState:(UPControlState)state
{
    const auto &end = m_paths.end();
    const auto &sval = m_paths.find(up_control_key_fill(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_paths.find(up_control_key_fill(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return nil;
}

- (void)setStrokePath:(UIBezierPath *)path
{
    [self setStrokePath:path forState:UPControlStateNormal];
}

- (void)setStrokePath:(UIBezierPath *)path forState:(UPControlState)state
{
    [self _createStrokePathViewIfNeeded];
    NSUInteger k = up_control_key_stroke(state);
    auto it = m_paths.find(k);
    if (it == m_paths.end()) {
        m_paths.emplace(k, path);
    }
    else {
        it->second = path;
    }
    [self invalidate];
    [self setNeedsUpdate];
}

- (UIBezierPath *)strokePathForState:(UPControlState)state
{
    const auto &end = m_paths.end();
    const auto &sval = m_paths.find(up_control_key_stroke(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_paths.find(up_control_key_stroke(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return nil;
}

- (void)setContentPath:(UIBezierPath *)path
{
    [self setContentPath:path forState:UPControlStateNormal];
}

- (void)setContentPath:(UIBezierPath *)path forState:(UPControlState)state
{
    [self _createContentPathViewIfNeeded];
    NSUInteger k = up_control_key_content(state);
    auto it = m_paths.find(k);
    if (it == m_paths.end()) {
        m_paths.emplace(k, path);
    }
    else {
        it->second = path;
    }
    [self invalidate];
    [self setNeedsUpdate];
}

- (UIBezierPath *)contentPathForState:(UPControlState)state
{
    const auto &end = m_paths.end();
    const auto &sval = m_paths.find(up_control_key_content(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_paths.find(up_control_key_content(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return nil;
}

- (void)setAuxiliaryPath:(UIBezierPath *)path
{
    [self setAuxiliaryPath:path forState:UPControlStateNormal];
}

- (void)setAuxiliaryPath:(UIBezierPath *)path forState:(UPControlState)state
{
    [self _createAuxiliaryPathViewIfNeeded];
    NSUInteger k = up_control_key_auxiliary(state);
    auto it = m_paths.find(k);
    if (it == m_paths.end()) {
        m_paths.emplace(k, path);
    }
    else {
        it->second = path;
    }
    [self invalidate];
    [self setNeedsUpdate];
}

- (UIBezierPath *)auxiliaryPathForState:(UPControlState)state
{
    const auto &end = m_paths.end();
    const auto &sval = m_paths.find(up_control_key_auxiliary(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_paths.find(up_control_key_auxiliary(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return nil;
}

- (void)setAccentPath:(UIBezierPath *)path
{
    [self setAccentPath:path forState:UPControlStateNormal];
}

- (void)setAccentPath:(UIBezierPath *)path forState:(UPControlState)state
{
    [self _createAccentPathViewIfNeeded];
    NSUInteger k = up_control_key_accent(state);
    auto it = m_paths.find(k);
    if (it == m_paths.end()) {
        m_paths.emplace(k, path);
    }
    else {
        it->second = path;
    }
    [self invalidate];
    [self setNeedsUpdate];
}

- (UIBezierPath *)accentPathForState:(UPControlState)state
{
    const auto &end = m_paths.end();
    const auto &sval = m_paths.find(up_control_key_accent(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_paths.find(up_control_key_accent(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return nil;
}

- (void)setLabelString:(NSString *)string
{
    [self setLabelString:string forState:UPControlStateNormal];
}

- (void)setLabelString:(NSString *)string forState:(UPControlState)state
{
    [self _createLabelIfNeeded];
    NSUInteger k = up_control_key_label(state);
    auto it = m_label_strings.find(k);
    if (it == m_label_strings.end()) {
        m_label_strings.emplace(k, string);
    }
    else {
        it->second = string;
    }
    [self invalidate];
    [self setNeedsUpdate];
}

- (NSString *)labelStringForState:(UPControlState)state
{
    const auto &end = m_label_strings.end();
    const auto &sval = m_label_strings.find(up_control_key_label(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_label_strings.find(up_control_key_label(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return nil;
}

# pragma mark - Colors

- (void)setFillColorCategory:(UPColorCategory)colorCategory
{
    [self setFillColorCategory:colorCategory forState:UPControlStateNormal];
}

- (void)setFillColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state
{
    NSUInteger k = up_control_key_fill(state);
    auto it = m_color_categories.find(k);
    if (it == m_color_categories.end()) {
        m_color_categories.emplace(k, colorCategory);
    }
    else {
        it->second = colorCategory;
    }
    [self setNeedsUpdate];
}

- (UPColorCategory)fillColorCategoryForState:(UPControlState)state
{
    const auto &end = m_color_categories.end();
    const auto &sval = m_color_categories.find(up_control_key_fill(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_color_categories.find(up_control_key_fill(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return UPColorCategoryPrimaryFill;
}

- (UIColor *)fillColorForState:(UPControlState)state
{
    return [UIColor themeColorWithCategory:[self fillColorCategoryForState:state]];
}

- (void)setFillColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_fill(fromState), up_control_key_fill(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (duration >= UPTickerInterval) {
            m_color_animations.emplace(k, duration);
        }
    }
    else if (up_is_fuzzy_zero(duration)) {
        m_color_animations.erase(it);
    }
    [self setNeedsUpdate];
}

- (CFTimeInterval)fillColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_fill(fromState), up_control_key_fill(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

- (void)setStrokeColorCategory:(UPColorCategory)colorCategory
{
    [self setStrokeColorCategory:colorCategory forState:UPControlStateNormal];
}

- (void)setStrokeColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state
{
    NSUInteger k = up_control_key_stroke(state);
    auto it = m_color_categories.find(k);
    if (it == m_color_categories.end()) {
        m_color_categories.emplace(k, colorCategory);
    }
    else {
        it->second = colorCategory;
    }
    [self setNeedsUpdate];
}

- (UPColorCategory)strokeColorCategoryForState:(UPControlState)state
{
    const auto &end = m_color_categories.end();
    const auto &sval = m_color_categories.find(up_control_key_stroke(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_color_categories.find(up_control_key_stroke(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return UPColorCategoryPrimaryStroke;
}

- (UIColor *)strokeColorForState:(UPControlState)state
{
    return [UIColor themeColorWithCategory:[self strokeColorCategoryForState:state]];
}

- (void)setStrokeColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_stroke(fromState), up_control_key_stroke(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (duration >= UPTickerInterval) {
            m_color_animations.emplace(k, duration);
        }
    }
    else if (up_is_fuzzy_zero(duration)) {
        m_color_animations.erase(it);
    }
    [self setNeedsUpdate];
}

- (CFTimeInterval)strokeColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_stroke(fromState), up_control_key_stroke(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

- (void)setContentColorCategory:(UPColorCategory)colorCategory
{
    [self setContentColorCategory:colorCategory forState:UPControlStateNormal];
}

- (void)setContentColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state
{
    NSUInteger k = up_control_key_content(state);
    auto it = m_color_categories.find(k);
    if (it == m_color_categories.end()) {
        m_color_categories.emplace(k, colorCategory);
    }
    else {
        it->second = colorCategory;
    }
    [self setNeedsUpdate];
}

- (UPColorCategory)contentColorCategoryForState:(UPControlState)state
{
    const auto &end = m_color_categories.end();
    const auto &sval = m_color_categories.find(up_control_key_content(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_color_categories.find(up_control_key_content(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return UPColorCategoryContent;
}

- (UIColor *)contentColorForState:(UPControlState)state
{
    return [UIColor themeColorWithCategory:[self contentColorCategoryForState:state]];
}

- (void)setContentColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_content(fromState), up_control_key_content(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (duration >= UPTickerInterval) {
            m_color_animations.emplace(k, duration);
        }
    }
    else if (up_is_fuzzy_zero(duration)) {
        m_color_animations.erase(it);
    }
    [self setNeedsUpdate];
}

- (CFTimeInterval)contentColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_content(fromState), up_control_key_content(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

- (void)setAuxiliaryColorCategory:(UPColorCategory)colorCategory
{
    [self setAuxiliaryColorCategory:colorCategory forState:UPControlStateNormal];
}

- (void)setAuxiliaryColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
{
    NSUInteger k = up_control_key_auxiliary(state);
    auto it = m_color_categories.find(k);
    if (it == m_color_categories.end()) {
        m_color_categories.emplace(k, colorCategory);
    }
    else {
        it->second = colorCategory;
    }
    [self setNeedsUpdate];
}

- (UPColorCategory)auxiliaryColorCategoryForState:(UPControlState)state
{
    const auto &end = m_color_categories.end();
    const auto &sval = m_color_categories.find(up_control_key_auxiliary(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_color_categories.find(up_control_key_auxiliary(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return UPColorCategoryPrimaryFill;
}

- (UIColor *)auxiliaryColorForState:(UPControlState)state
{
    return [UIColor themeColorWithCategory:[self auxiliaryColorCategoryForState:state]];
}

- (void)setAuxiliaryColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_auxiliary(fromState), up_control_key_auxiliary(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (duration >= UPTickerInterval) {
            m_color_animations.emplace(k, duration);
        }
    }
    else if (up_is_fuzzy_zero(duration)) {
        m_color_animations.erase(it);
    }
    [self setNeedsUpdate];
}

- (CFTimeInterval)auxiliaryColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_auxiliary(fromState), up_control_key_auxiliary(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

- (void)setAccentColorCategory:(UPColorCategory)colorCategory;
{
    [self setAccentColorCategory:colorCategory forState:UPControlStateNormal];
}

- (void)setAccentColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
{
    NSUInteger k = up_control_key_accent(state);
    auto it = m_color_categories.find(k);
    if (it == m_color_categories.end()) {
        m_color_categories.emplace(k, colorCategory);
    }
    else {
        it->second = colorCategory;
    }
    [self setNeedsUpdate];
}

- (UPColorCategory)accentColorCategoryForState:(UPControlState)state;
{
    const auto &end = m_color_categories.end();
    const auto &sval = m_color_categories.find(up_control_key_accent(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_color_categories.find(up_control_key_accent(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return UPColorCategoryPrimaryFill;
}

- (UIColor *)accentColorForState:(UPControlState)state
{
    return [UIColor themeColorWithCategory:[self accentColorCategoryForState:state]];
}

- (void)setAccentColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_accent(fromState), up_control_key_accent(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (duration >= UPTickerInterval) {
            m_color_animations.emplace(k, duration);
        }
    }
    else if (up_is_fuzzy_zero(duration)) {
        m_color_animations.erase(it);
    }
    [self setNeedsUpdate];
}

- (CFTimeInterval)accentColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_accent(fromState), up_control_key_accent(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

- (void)setLabelColorCategory:(UPColorCategory)colorCategory
{
    [self setLabelColorCategory:colorCategory forState:UPControlStateNormal];
}

- (void)setLabelColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state
{
    NSUInteger k = up_control_key_label(state);
    auto it = m_color_categories.find(k);
    if (it == m_color_categories.end()) {
        m_color_categories.emplace(k, colorCategory);
    }
    else {
        it->second = colorCategory;
    }
    [self setNeedsUpdate];
}

- (UPColorCategory)labelColorCategoryForState:(UPControlState)state
{
    const auto &end = m_color_categories.end();
    const auto &sval = m_color_categories.find(up_control_key_label(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_color_categories.find(up_control_key_label(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return UPColorCategoryControlText;
}

- (UIColor *)labelColorForState:(UPControlState)state
{
    return [UIColor themeColorWithCategory:[self labelColorCategoryForState:state]];
}

- (void)setLabelColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_label(fromState), up_control_key_label(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (duration >= UPTickerInterval) {
            m_color_animations.emplace(k, duration);
        }
    }
    else if (up_is_fuzzy_zero(duration)) {
        m_color_animations.erase(it);
    }
    [self setNeedsUpdate];
}

- (CFTimeInterval)labelColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_label(fromState), up_control_key_label(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

#pragma mark - Hit testing

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect chargeRect = UPOutsetRect(self.bounds, self.chargeOutsets);
    return CGRectContainsPoint(chargeRect, point);
}

#pragma mark - Lifecycle

- (void)removeFromSuperview
{
    [self cancelAnimations];
    [super removeFromSuperview];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.fillPathView.frame = bounds;
    self.strokePathView.frame = bounds;
    self.contentPathView.frame = bounds;
    self.auxiliaryPathView.frame = bounds;
    self.accentPathView.frame = bounds;
    self.label.frame = bounds;
    [self setNeedsUpdate];
}

#pragma mark - Updating

- (void)updateThemeColors
{
    [self cancelColorAnimations];
    [self invalidate];
    [self update];
}

- (void)cancelAnimations
{
    cancel(@[self]);
    [self cancelColorAnimations];
}

- (void)cancelColorAnimations
{
    cancel(self.fillColorAnimatorSerialNumber);
    cancel(self.strokeColorAnimatorSerialNumber);
    cancel(self.contentPathColorAnimatorSerialNumber);
    cancel(self.auxiliaryPathColorAnimatorSerialNumber);
    cancel(self.accentPathColorAnimatorSerialNumber);
    cancel(self.labelColorAnimatorSerialNumber);
    self.fillColorAnimatorSerialNumber = UP::NotASerialNumber;
    self.strokeColorAnimatorSerialNumber = UP::NotASerialNumber;
    self.contentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
    self.auxiliaryPathColorAnimatorSerialNumber = UP::NotASerialNumber;
    self.accentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
    self.labelColorAnimatorSerialNumber = UP::NotASerialNumber;
}

- (void)invalidate
{
    self.previousState |= UPControlStateInvalid;
}

- (void)freeze
{
    self.frozen = YES;
}

- (void)setNeedsUpdate
{
    if (self.frozen) {
        return;
    }
    [[UPNeedsUpdater instance] setNeedsUpdate:self order:UPNeedsUpdaterOrderFirst];
}

- (void)update
{
    if (self.frozen) {
        return;
    }
    
    UPControlState state = self.state;
    if (state == self.previousState) {
        return;
    }
    
    UPControlState effectivePreviousState = (self.previousState & ~UPControlStateInvalid);
    UPControlState effectiveState = (self.state & ~UPControlStateInvalid);

    if (self.fillPathView) {
        self.fillPathView.path = [self fillPathForState:state];
        
        cancel(self.fillColorAnimatorSerialNumber);
        self.fillColorAnimatorSerialNumber = UP::NotASerialNumber;
        
        CFTimeInterval duration = [self fillColorAnimationDuration:effectivePreviousState toState:effectiveState];
        UIColor *colorForPreviousState = [self fillColorForState:effectivePreviousState];
        UIColor *colorForState = [self fillColorForState:effectiveState];
        BOOL colorsDiffer = ![colorForPreviousState isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.band, @[self], duration, UPControlElementFill, effectivePreviousState, effectiveState,
                                             ^(UIViewAnimatingPosition) {
                self.fillColorAnimatorSerialNumber = UP::NotASerialNumber;
            });
            [animator start];
            self.fillColorAnimatorSerialNumber = animator.serialNumber;
        }
        else {
            self.fillPathView.fillColor = colorForState;
        }
    }
    if (self.strokePathView) {
        self.strokePathView.path = [self strokePathForState:state];
        
        cancel(self.strokeColorAnimatorSerialNumber);
        self.strokeColorAnimatorSerialNumber = UP::NotASerialNumber;
        
        CFTimeInterval duration = [self strokeColorAnimationDuration:effectivePreviousState toState:effectiveState];
        UIColor *colorForPreviousState = [self strokeColorForState:effectivePreviousState];
        UIColor *colorForState = [self strokeColorForState:effectiveState];
        BOOL colorsDiffer = ![colorForPreviousState isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.band, @[self], duration, UPControlElementStroke, effectivePreviousState, effectiveState,
                                             ^(UIViewAnimatingPosition) {
                self.strokeColorAnimatorSerialNumber = UP::NotASerialNumber;
            });
            [animator start];
            self.strokeColorAnimatorSerialNumber = animator.serialNumber;
        }
        else {
            self.strokePathView.fillColor = colorForState;
        }
    }
    if (self.contentPathView) {
        self.contentPathView.path = [self contentPathForState:state];
        
        cancel(self.contentPathColorAnimatorSerialNumber);
        self.contentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
        
        CFTimeInterval duration = [self contentColorAnimationDuration:effectivePreviousState toState:effectiveState];
        UIColor *colorForPreviousState = [self contentColorForState:effectivePreviousState];
        UIColor *colorForState = [self contentColorForState:effectiveState];
        BOOL colorsDiffer = ![colorForPreviousState isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.band, @[self], duration, UPControlElementContent, effectivePreviousState, effectiveState,
                                             ^(UIViewAnimatingPosition) {
                self.contentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
            });
            [animator start];
            self.contentPathColorAnimatorSerialNumber = animator.serialNumber;
        }
        else {
            self.contentPathView.fillColor = colorForState;
        }
    }
    if (self.auxiliaryPathView) {
        self.auxiliaryPathView.path = [self auxiliaryPathForState:state];
        
        cancel(self.auxiliaryPathColorAnimatorSerialNumber);
        self.auxiliaryPathColorAnimatorSerialNumber = UP::NotASerialNumber;
        
        CFTimeInterval duration = [self auxiliaryColorAnimationDuration:effectivePreviousState toState:effectiveState];
        UIColor *colorForPreviousState = [self auxiliaryColorForState:effectivePreviousState];
        UIColor *colorForState = [self auxiliaryColorForState:effectiveState];
        BOOL colorsDiffer = ![colorForPreviousState isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.band, @[self], duration, UPControlElementAuxiliary, effectivePreviousState, effectiveState,
                                             ^(UIViewAnimatingPosition) {
                self.auxiliaryPathColorAnimatorSerialNumber = UP::NotASerialNumber;
            });
            [animator start];
            self.auxiliaryPathColorAnimatorSerialNumber = animator.serialNumber;
        }
        else {
            self.auxiliaryPathView.fillColor = colorForState;
        }
    }
    if (self.accentPathView) {
        self.accentPathView.path = [self accentPathForState:state];
        
        cancel(self.accentPathColorAnimatorSerialNumber);
        self.accentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
        
        CFTimeInterval duration = [self accentColorAnimationDuration:effectivePreviousState toState:effectiveState];
        UIColor *colorForPreviousState = [self accentColorForState:effectivePreviousState];
        UIColor *colorForState = [self accentColorForState:effectiveState];
        BOOL colorsDiffer = ![colorForPreviousState isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.band, @[self], duration, UPControlElementAccent, effectivePreviousState, effectiveState,
                                             ^(UIViewAnimatingPosition) {
                self.accentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
            });
            [animator start];
            self.accentPathColorAnimatorSerialNumber = animator.serialNumber;
        }
        else {
            self.accentPathView.fillColor = colorForState;
        }
    }
    if (self.label) {
        self.label.string = [self labelStringForState:state];
        
        cancel(self.labelColorAnimatorSerialNumber);
        self.labelColorAnimatorSerialNumber = UP::NotASerialNumber;
        
        CFTimeInterval duration = [self labelColorAnimationDuration:effectivePreviousState toState:effectiveState];
        UIColor *colorForPreviousState = [self labelColorForState:effectivePreviousState];
        UIColor *colorForState = [self labelColorForState:effectiveState];
        BOOL colorsDiffer = ![colorForPreviousState isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            self.label.textColorCategory = [self labelColorCategoryForState:effectivePreviousState];
            UPAnimator *animator = set_color(self.band, @[self], duration, UPControlElementLabel, effectivePreviousState, effectiveState,
                                             ^(UIViewAnimatingPosition) {
                self.accentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
            });
            [animator start];
            self.accentPathColorAnimatorSerialNumber = animator.serialNumber;
        }
        else {
            self.label.textColorCategory = [self labelColorCategoryForState:effectiveState];
        }
    }

    self.previousState = state;
}

@end
