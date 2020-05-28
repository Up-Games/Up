//
//  UPControl.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>
#import <set>
#import <vector>

#import "UPAnimator.h"
#import "UPAssertions.h"
#import "UPBezierPathView.h"
#import "UPControl.h"
#import "UIColor+UP.h"
#import "UPMacros.h"
#import "UPTickingAnimator.h"
#import "UPTimeSpanning.h"

// =========================================================================================================================================

namespace UP {

class ControlAction {
public:
    ControlAction(id target, SEL action, UIControlEvents control_events) :
        m_target(target), m_action(action), m_control_events(control_events) {}

    id target() const { return m_target; }
    SEL action() const { return m_action; }
    UIControlEvents control_events() const { return m_control_events; }

private:
    __weak id m_target = nullptr;
    SEL m_action;
    UIControlEvents m_control_events = 0;
};

bool operator==(const ControlAction &a, const ControlAction &b) {
    return a.target() == b.target() && a.action() == b.action() && a.control_events() == b.control_events();
}

bool operator!=(const ControlAction &a, const ControlAction &b) {
    return !(a==b);
}

}  // namespace UP

// =========================================================================================================================================

using UP::ControlAction;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::set_color;

using UPControlStatePair = std::pair<UPControlState, UPControlState>;

@interface UPControl ()
{
    std::vector<ControlAction> m_actions;
    std::map<NSUInteger, __strong UIBezierPath *> m_paths;
    std::map<NSUInteger, __strong UIColor *> m_colors;
    std::set<UPControlStatePair> m_color_animations;
}
@property (nonatomic, readwrite) UPControlState state;
@property (nonatomic, readwrite) BOOL tracking;
@property (nonatomic, readwrite) BOOL touchInside;
@property (nonatomic, readwrite) UPBezierPathView *contentPathView;
@property (nonatomic, readwrite) UPBezierPathView *fillPathView;
@property (nonatomic, readwrite) UPBezierPathView *strokePathView;
@property (nonatomic) NSMutableDictionary<NSNumber *, UIBezierPath *> *pathsForStates;
@property (nonatomic) UPControlState previousState;
@property (nonatomic) UPAnimator *fillColorAnimator;
@property (nonatomic) UPAnimator *strokeColorAnimator;
@property (nonatomic) UPAnimator *contentColorAnimator;
@end

UP_STATIC_INLINE NSNumber * _FillKey(UPControlState controlState)
{
    return @(UPControlElementFill | controlState);
}

UP_STATIC_INLINE NSNumber * _StrokeKey(UPControlState controlState)
{
    return @(UPControlElementStroke | controlState);
}

UP_STATIC_INLINE NSNumber * _ContentKey(UPControlState controlState)
{
    return @(UPControlElementContent | controlState);
}

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
    return self;
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
    [self _controlStateChanged];
}

- (BOOL)isSelected
{
    return self.state & UPControlStateSelected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (self.highlightedOverride && !highlighted) {
        return;
    }
    if (highlighted) {
        self.state |= UPControlStateHighlighted;
    }
    else {
        self.state &= ~UPControlStateHighlighted;
    }
    [self _controlStateChanged];
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
    [self _controlStateChanged];
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
    [self _controlStateChanged];
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
    [self _controlStateChanged];
}

- (void)setHighlighted
{
    [self setDisabled:NO];
    [self setSelected:NO];
    [self setHighlighted:YES];
    [self setActive:NO];
    [self _controlStateChanged];
}

- (void)setDisabled
{
    [self setDisabled:YES];
    [self setSelected:NO];
    [self setHighlighted:NO];
    [self setActive:NO];
    [self _controlStateChanged];
}

- (void)setSelected
{
    [self setDisabled:NO];
    [self setSelected:YES];
    [self setHighlighted:NO];
    [self setActive:NO];
    [self _controlStateChanged];
}

- (void)setActive
{
    [self setDisabled:NO];
    [self setSelected:NO];
    [self setHighlighted:NO];
    [self setActive:YES];
    [self _controlStateChanged];
}

- (void)_controlStateChanged
{
    [self controlUpdate];
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
    [self setContentPath:path forControlStates:UPControlStateNormal];
}

- (void)setContentPath:(UIBezierPath *)path forControlStates:(UPControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createContentPathViewIfNeeded];
    NSNumber *key = _ContentKey(controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

- (void)setFillPath:(UIBezierPath *)path
{
    [self setFillPath:path forControlStates:UPControlStateNormal];
}

- (void)setFillPath:(UIBezierPath *)path forControlStates:(UPControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createFillPathViewIfNeeded];
    NSNumber *key = _FillKey(controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

- (void)setStrokePath:(UIBezierPath *)path
{
    [self setStrokePath:path forControlStates:UPControlStateNormal];
}

- (void)setStrokePath:(UIBezierPath *)path forControlStates:(UPControlState)controlStates
{
    [self _createPathsForStatesIfNeeded];
    [self _createStrokePathViewIfNeeded];
    NSNumber *key = _StrokeKey(controlStates);
    self.pathsForStates[key] = path;
    [self setNeedsLayout];
}

# pragma mark - Colors

- (void)setFillColor:(UIColor *)color
{
    [self setFillColor:color forControlStates:UPControlStateNormal];
}

- (void)setFillColor:(UIColor *)color forControlStates:(UPControlState)controlStates
{
    NSUInteger k = up_control_key_fill(controlStates);
    auto it = m_colors.find(k);
    if (it == m_colors.end()) {
        m_colors.emplace(k, color);
    }
    else {
        it->second = color;
    }
    [self setNeedsLayout];
}

- (UIColor *)fillColorForControlStates:(UPControlState)controlStates
{
    const auto &end = m_colors.end();
    const auto &sval = m_colors.find(up_control_key_fill(controlStates));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_colors.find(up_control_key_fill(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return [UIColor themeColorWithCategory:UPColorCategoryPrimaryFill];
}

- (void)setAnimatesFillColor:(BOOL)animates fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_fill(fromState), up_control_key_fill(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (animates) {
            m_color_animations.emplace(k);
        }
    }
    else if (!animates) {
        m_color_animations.erase(it);
    }
    [self setNeedsLayout];
}

- (BOOL)animatesFillColorFromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_fill(fromState), up_control_key_fill(toState) };
    return m_color_animations.find(k) != m_color_animations.end();
}

- (void)setStrokeColor:(UIColor *)color
{
    [self setStrokeColor:color forControlStates:UPControlStateNormal];
}

- (void)setStrokeColor:(UIColor *)color forControlStates:(UPControlState)controlStates
{
    NSUInteger k = up_control_key_stroke(controlStates);
    auto it = m_colors.find(k);
    if (it == m_colors.end()) {
        m_colors.emplace(k, color);
    }
    else {
        it->second = color;
    }
    [self setNeedsLayout];
}

- (UIColor *)strokeColorForControlStates:(UPControlState)controlStates
{
    const auto &end = m_colors.end();
    const auto &sval = m_colors.find(up_control_key_stroke(controlStates));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_colors.find(up_control_key_stroke(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return [UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke];
}

- (void)setAnimatesStrokeColor:(BOOL)animates fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_stroke(fromState), up_control_key_stroke(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (animates) {
            m_color_animations.emplace(k);
        }
    }
    else if (!animates) {
        m_color_animations.erase(it);
    }
    [self setNeedsLayout];
}

- (BOOL)animatesStrokeColorFromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_stroke(fromState), up_control_key_stroke(toState) };
    return m_color_animations.find(k) != m_color_animations.end();
}

- (void)setContentColor:(UIColor *)color
{
    [self setContentColor:color forControlStates:UPControlStateNormal];
}

- (void)setContentColor:(UIColor *)color forControlStates:(UPControlState)controlStates
{
    NSUInteger k = up_control_key_content(controlStates);
    auto it = m_colors.find(k);
    if (it == m_colors.end()) {
        m_colors.emplace(k, color);
    }
    else {
        it->second = color;
    }
    [self setNeedsLayout];
}

- (UIColor *)contentColorForControlStates:(UPControlState)controlStates
{
    const auto &end = m_colors.end();
    const auto &sval = m_colors.find(up_control_key_content(controlStates));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_colors.find(up_control_key_content(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return [UIColor themeColorWithCategory:UPColorCategoryContent];
}

- (void)setAnimatesContentColor:(BOOL)animates fromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_content(fromState), up_control_key_content(toState) };
    auto it = m_color_animations.find(k);
    if (it == m_color_animations.end()) {
        if (animates) {
            m_color_animations.emplace(k);
        }
    }
    else if (!animates) {
        m_color_animations.erase(it);
    }
    [self setNeedsLayout];
}

- (BOOL)animatesContentColorFromState:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_content(fromState), up_control_key_content(toState) };
    return m_color_animations.find(k) != m_color_animations.end();
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isEnabled) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.tracking = [self beginTrackingWithTouch:touch withEvent:event];
    if (self.tracking) {
        self.touchInside = [self pointInside:[touch locationInView:self] withEvent:event];
        if (self.autoHighlights) {
            self.highlighted = YES;
        }
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isEnabled) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.tracking = [self continueTrackingWithTouch:touch withEvent:event];
    if (self.tracking) {
        BOOL wasTouchInside = self.touchInside;
        self.touchInside = [self pointInside:[touch locationInView:self] withEvent:event];
        if (!wasTouchInside && self.touchInside) {
            if (self.autoHighlights) {
                self.highlighted = YES;
            }
            [self sendActionsForControlEvents:UIControlEventTouchDragEnter];
        }
        else if (wasTouchInside && !self.touchInside) {
            if (self.autoHighlights) {
                self.highlighted = NO;
            }
            [self sendActionsForControlEvents:UIControlEventTouchDragExit];
        }
        else if (wasTouchInside && self.touchInside) {
            [self sendActionsForControlEvents:UIControlEventTouchDragInside];
        }
        else if (!wasTouchInside && !self.touchInside) {
            [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
        }
    }
    else {
        if (self.autoHighlights) {
            self.highlighted = NO;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.tracking = NO;
    if (self.autoHighlights) {
        self.highlighted = NO;
    }
    
    UITouch *touch = [touches anyObject];
    [self endTrackingWithTouch:touch withEvent:event];

    if (self.touchInside) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
    self.touchInside = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.tracking = NO;
    if (self.autoHighlights) {
        self.highlighted = NO;
    }
    [self cancelTrackingWithEvent:event];
}

#pragma mark - Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
}

#pragma mark - Target/Action

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UP::ControlAction control_action(target, action, controlEvents);
    for (const auto &a : m_actions) {
        if (a == control_action) {
            return;
        }
    }
    m_actions.push_back(control_action);
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UP::ControlAction control_action(target, action, controlEvents);
    for (auto it = m_actions.begin(); it != m_actions.end(); ++it) {
        if (control_action == *it) {
            m_actions.erase(it);
            return;
        }
    }
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    for (const auto &a : m_actions) {
        if (a.control_events() & controlEvents) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [a.target() performSelector:a.action() withObject:a.target()];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - Lifecycle

- (void)removeFromSuperview
{
    cancel(self.fillColorAnimator);
    cancel(self.strokeColorAnimator);
    cancel(self.contentColorAnimator);
    self.fillColorAnimator = nil;
    self.strokeColorAnimator = nil;
    self.contentColorAnimator = nil;
    [super removeFromSuperview];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    self.fillPathView.frame = bounds;
    self.strokePathView.frame = bounds;
    self.contentPathView.frame = bounds;
    [self controlUpdate];
}

#pragma mark - Updating

- (void)controlUpdate
{
    UPControlState state = self.state;
    if (state == self.previousState) {
        return;
    }
    
    if (self.fillPathView) {
        NSNumber *key = _FillKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_FillKey(UPControlStateNormal)];
        self.fillPathView.path = path;
        
        cancel(self.fillColorAnimator);
        self.fillColorAnimator = nil;

        BOOL animates = [self animatesFillColorFromState:self.previousState toState:state] &&
            ![[self fillColorForControlStates:self.previousState] isEqual:[self fillColorForControlStates:state]];

        if (animates) {
            self.fillColorAnimator = set_color(@[self], 0.3, UPControlElementFill, self.previousState, state,
                ^(UIViewAnimatingPosition) {
                    self.fillColorAnimator = nil;
                }
            );
            [self.fillColorAnimator start];
        }
        else {
            self.fillPathView.fillColor = [self fillColorForControlStates:state];
        }
    }
    if (self.strokePathView) {
        NSNumber *key = _StrokeKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_StrokeKey(UPControlStateNormal)];
        self.strokePathView.path = path;

        cancel(self.strokeColorAnimator);
        self.strokeColorAnimator = nil;

        BOOL animates = [self animatesFillColorFromState:self.previousState toState:state] &&
            ![[self strokeColorForControlStates:self.previousState] isEqual:[self strokeColorForControlStates:state]];

        if (animates) {
            self.strokeColorAnimator = set_color(@[self], 0.3, UPControlElementStroke, self.previousState, state,
                ^(UIViewAnimatingPosition) {
                    self.strokeColorAnimator = nil;
                }
            );
            [self.strokeColorAnimator start];
        }
        else {
            self.strokePathView.fillColor = [self strokeColorForControlStates:state];
        }
    }
    if (self.contentPathView) {
        NSNumber *key = _ContentKey(state);
        UIBezierPath *path = self.pathsForStates[key] ?: self.pathsForStates[_ContentKey(UPControlStateNormal)];
        self.contentPathView.path = path;

        cancel(self.contentColorAnimator);
        self.contentColorAnimator = nil;

        BOOL animates = [self animatesFillColorFromState:self.previousState toState:state] &&
            ![[self contentColorForControlStates:self.previousState] isEqual:[self contentColorForControlStates:state]];

        if (animates) {
            self.contentColorAnimator = set_color(@[self], 0.3, UPControlElementContent, self.previousState, state,
                ^(UIViewAnimatingPosition) {
                    self.strokeColorAnimator = nil;
                }
            );
            [self.strokeColorAnimator start];
        }
        else {
            self.contentPathView.fillColor = [self contentColorForControlStates:state];;
        }
    }
    
    self.previousState = state;
}

@end
