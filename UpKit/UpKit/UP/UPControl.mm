//
//  UPControl.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>
#import <vector>

#import "UPAnimator.h"
#import "UPAssertions.h"
#import "UPBezierPathView.h"
#import "UPControl.h"
#import "UIColor+UP.h"
#import "UPMacros.h"
#import "UPMath.h"
#import "UPTicker.h"
#import "UPTickingAnimator.h"
#import "UPTimeSpanning.h"

// =========================================================================================================================================

namespace UP {

class ControlAction {
public:
    ControlAction(id target, SEL action, UPControlEvents events) :
        m_target(target), m_action(action), m_events(events) {}

    id target() const { return m_target; }
    SEL action() const { return m_action; }
    UPControlEvents events() const { return m_events; }

private:
    __weak id m_target = nullptr;
    SEL m_action;
    UPControlEvents m_events = 0;
};

bool operator==(const ControlAction &a, const ControlAction &b) {
    return a.target() == b.target() && a.action() == b.action() && a.events() == b.events();
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
    std::map<NSUInteger, __strong NSAttributedString *> m_texts;
    std::map<UPControlStatePair, CFTimeInterval> m_color_animations;
}
@property (nonatomic, readwrite) UPControlState state;
@property (nonatomic, readwrite) BOOL tracking;
@property (nonatomic, readwrite) BOOL touchInside;
@property (nonatomic, readwrite) UPBezierPathView *fillPathView;
@property (nonatomic, readwrite) UPBezierPathView *strokePathView;
@property (nonatomic, readwrite) UPBezierPathView *contentPathView;
@property (nonatomic) UPControlState previousState;
@property (nonatomic) uint32_t fillColorAnimatorSerialNumber;
@property (nonatomic) uint32_t strokeColorAnimatorSerialNumber;
@property (nonatomic) uint32_t contentPathColorAnimatorSerialNumber;
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
    return UPControlElementContentPath | controlState;
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
    [self setNeedsLayout];
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

# pragma mark - Colors

- (void)setFillColor:(UIColor *)color
{
    [self setFillColor:color forState:UPControlStateNormal];
}

- (void)setFillColor:(UIColor *)color forState:(UPControlState)state
{
    NSUInteger k = up_control_key_fill(state);
    auto it = m_colors.find(k);
    if (it == m_colors.end()) {
        m_colors.emplace(k, color);
    }
    else {
        it->second = color;
    }
    [self setNeedsLayout];
}

- (UIColor *)fillColorForState:(UPControlState)state
{
    const auto &end = m_colors.end();
    const auto &sval = m_colors.find(up_control_key_fill(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_colors.find(up_control_key_fill(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return [UIColor themeColorWithCategory:UPColorCategoryPrimaryFill];
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
    [self setNeedsLayout];
}

- (CFTimeInterval)fillColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_fill(fromState), up_control_key_fill(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

- (void)setStrokeColor:(UIColor *)color
{
    [self setStrokeColor:color forState:UPControlStateNormal];
}

- (void)setStrokeColor:(UIColor *)color forState:(UPControlState)state
{
    NSUInteger k = up_control_key_stroke(state);
    auto it = m_colors.find(k);
    if (it == m_colors.end()) {
        m_colors.emplace(k, color);
    }
    else {
        it->second = color;
    }
    [self setNeedsLayout];
}

- (UIColor *)strokeColorForState:(UPControlState)state
{
    const auto &end = m_colors.end();
    const auto &sval = m_colors.find(up_control_key_stroke(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_colors.find(up_control_key_stroke(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return [UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke];
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
    [self setNeedsLayout];
}

- (CFTimeInterval)strokeColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_stroke(fromState), up_control_key_stroke(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

- (void)setContentColor:(UIColor *)color
{
    [self setContentColor:color forState:UPControlStateNormal];
}

- (void)setContentColor:(UIColor *)color forState:(UPControlState)state
{
    NSUInteger k = up_control_key_content(state);
    auto it = m_colors.find(k);
    if (it == m_colors.end()) {
        m_colors.emplace(k, color);
    }
    else {
        it->second = color;
    }
    [self setNeedsLayout];
}

- (UIColor *)contentColorForState:(UPControlState)state
{
    const auto &end = m_colors.end();
    const auto &sval = m_colors.find(up_control_key_content(state));
    if (sval != end) {
        return sval->second;
    }
    const auto &nval = m_colors.find(up_control_key_content(UPControlStateNormal));
    if (nval != end) {
        return nval->second;
    }
    return [UIColor themeColorWithCategory:UPColorCategoryContent];
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
    [self setNeedsLayout];
}

- (CFTimeInterval)contentColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState
{
    UPControlStatePair k = { up_control_key_content(fromState), up_control_key_content(toState) };
    const auto it = m_color_animations.find(k);
    return it != m_color_animations.end() ? it->second : 0.0;
}

#pragma mark - Hit testing

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([super pointInside:point withEvent:event]) {
        return YES;
    }
    
    if (!CGSizeEqualToSize(self.chargeSize, CGSizeZero)) {
        CGRect chargeRect = CGRectInset(self.bounds, -self.chargeSize.width, -self.chargeSize.height);
        return CGRectContainsPoint(chargeRect, point);
    }
    
    return NO;
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
        [self sendActionsForControlEvents:UPControlEventTouchDown];
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
            [self sendActionsForControlEvents:UPControlEventTouchDragEnter];
        }
        else if (wasTouchInside && !self.touchInside) {
            if (self.autoHighlights) {
                self.highlighted = NO;
            }
            [self sendActionsForControlEvents:UPControlEventTouchDragExit];
        }
        else if (wasTouchInside && self.touchInside) {
            [self sendActionsForControlEvents:UPControlEventTouchDragInside];
        }
        else if (!wasTouchInside && !self.touchInside) {
            [self sendActionsForControlEvents:UPControlEventTouchDragOutside];
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
        [self sendActionsForControlEvents:UPControlEventTouchUpInside];
    }
    else {
        [self sendActionsForControlEvents:UPControlEventTouchUpOutside];
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
    [self cancelAnimations];
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

- (void)addTarget:(id)target action:(SEL)action forEvents:(UPControlEvents)events
{
    UP::ControlAction control_action(target, action, events);
    for (const auto &a : m_actions) {
        if (a == control_action) {
            return;
        }
    }
    m_actions.push_back(control_action);
}

- (void)removeTarget:(id)target action:(SEL)action forEvents:(UPControlEvents)events
{
    UP::ControlAction control_action(target, action, events);
    for (auto it = m_actions.begin(); it != m_actions.end(); ++it) {
        if (control_action == *it) {
            m_actions.erase(it);
            return;
        }
    }
}

- (void)sendActionsForControlEvents:(UPControlEvents)events
{
    for (const auto &a : m_actions) {
        if (a.events() & events) {
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
    [self controlUpdate];
}

#pragma mark - Updating

- (void)cancelAnimations
{
    cancel(@[self]);
    cancel(self.fillColorAnimatorSerialNumber);
    cancel(self.strokeColorAnimatorSerialNumber);
    cancel(self.contentPathColorAnimatorSerialNumber);
    self.fillColorAnimatorSerialNumber = UP::NotASerialNumber;
    self.strokeColorAnimatorSerialNumber = UP::NotASerialNumber;
    self.contentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
}

- (void)controlUpdate
{
    UPControlState state = self.state;
    if (state == self.previousState) {
        return;
    }
    
    if (self.fillPathView) {
        self.fillPathView.path = [self fillPathForState:state];

        cancel(self.fillColorAnimatorSerialNumber);
        self.fillColorAnimatorSerialNumber = UP::NotASerialNumber;

        UIColor *colorForState = [self fillColorForState:state];
        CFTimeInterval duration = [self fillColorAnimationDuration:self.previousState toState:state];
        BOOL colorsDiffer = ![self.fillPathView.fillColor isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.role, @[self], duration, UPControlElementFill, self.previousState, state,
                ^(UIViewAnimatingPosition) {
                    self.fillColorAnimatorSerialNumber = UP::NotASerialNumber;
                }
            );
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

        UIColor *colorForState = [self strokeColorForState:state];
        CFTimeInterval duration = [self strokeColorAnimationDuration:self.previousState toState:state];
        BOOL colorsDiffer = ![self.strokePathView.fillColor isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.role, @[self], duration, UPControlElementStroke, self.previousState, state,
                ^(UIViewAnimatingPosition) {
                    self.strokeColorAnimatorSerialNumber = UP::NotASerialNumber;
                }
            );
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

        UIColor *colorForState = [self contentColorForState:state];
        CFTimeInterval duration = [self contentColorAnimationDuration:self.previousState toState:state];
        BOOL colorsDiffer = ![self.contentPathView.fillColor isEqual:colorForState];
        if (duration > UPTickerInterval && colorsDiffer) {
            UPAnimator *animator = set_color(self.role, @[self], duration, UPControlElementContentPath, self.previousState, state,
                ^(UIViewAnimatingPosition) {
                    self.contentPathColorAnimatorSerialNumber = UP::NotASerialNumber;
                }
            );
            [animator start];
            self.contentPathColorAnimatorSerialNumber = animator.serialNumber;
        }
        else {
            self.contentPathView.fillColor = colorForState;
        }
    }
    
    self.previousState = state;
}

@end
