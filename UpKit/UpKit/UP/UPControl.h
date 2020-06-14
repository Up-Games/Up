//
//  UPControl.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPBand.h>

@class UPBezierPathView;

typedef NS_OPTIONS(NSUInteger, UPControlEvents) {
    UPControlEventTouchDown               = 1 <<  0,      // on all touch downs
    UPControlEventTouchDownRepeat         = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    UPControlEventTouchDragInside         = 1 <<  2,
    UPControlEventTouchDragOutside        = 1 <<  3,
    UPControlEventTouchDragEnter          = 1 <<  4,
    UPControlEventTouchDragExit           = 1 <<  5,
    UPControlEventTouchUpInside           = 1 <<  6,
    UPControlEventTouchUpOutside          = 1 <<  7,
    UPControlEventTouchCancel             = 1 <<  8,

    UPControlEventValueChanged            = 1 << 12,     // sliders, etc.
    UPControlEventPrimaryActionTriggered  = 1 << 13,     // semantic action: for buttons, etc.

    UPControlEventAllTouchEvents                                    = 0x00000FFF,  // for touch events
    UPControlEventApplicationReserved     = 0x0F000000,  // range available for application use
    UPControlEventSystemReserved          = 0xF0000000,  // range reserved for internal framework use
    UPControlEventAllEvents               = 0xFFFFFFFF
};

typedef NS_OPTIONS(NSUInteger, UPControlState) {
    UPControlStateNormal =      0x00000000,
    UPControlStateHighlighted = 0x00000001,
    UPControlStateDisabled =    0x00000002,
    UPControlStateSelected =    0x00000004,
    UPControlStateActive =      0x00010000,
    UPControlStateReserved =    0xFFFF0000,
    UPControlStateInvalid =     0x01000000,
};

typedef NS_OPTIONS(NSUInteger, UPControlElement) {
    // Values chosen to be in the UPControlStateReserved range, so
    // they can be bitwise-OR'ed together with UPControlState values.
    UPControlElementFill =      0x00100000,
    UPControlElementStroke =    0x00200000,
    UPControlElementContent =   0x00400000,
    UPControlElementAuxiliary = 0x00800000,
    UPControlElementAccent =    0x01000000,
};

@interface UPControl : UIView

@property (nonatomic, readonly) UPControlState state;

@property (nonatomic, getter=isEnabled) BOOL enabled;          // default is YES. if NO, ignores touch events and subclasses may draw differently
@property (nonatomic, getter=isSelected) BOOL selected;        // default is NO may be used by some subclasses or by application
@property (nonatomic, getter=isHighlighted) BOOL highlighted;  // default is NO. this gets set/cleared automatically when touch enters/exits
@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic) BOOL autoHighlights;
@property (nonatomic) BOOL autoSelects;
@property (nonatomic) BOOL autoDeselects;
@property (nonatomic) BOOL highlightedLocked;

@property (nonatomic) CGSize canonicalSize;
@property (nonatomic) CGSize chargeSize;

@property (nonatomic) UP::Band band;

+ (UPControl *)control;

- (void)setHighlighted:(BOOL)highlighted;
- (void)setDisabled:(BOOL)disabled;
- (void)setSelected:(BOOL)selected;
- (void)setActive:(BOOL)active;

- (void)setNormal;
- (void)setHighlighted;
- (void)setDisabled;
- (void)setSelected;
- (void)setActive;

@property (nonatomic, readonly, getter=isTracking) BOOL tracking;
@property (nonatomic, readonly, getter=isTouchInside) BOOL touchInside;
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;

- (void)addTarget:(id)target action:(SEL)action forEvents:(UPControlEvents)events;
- (void)removeTarget:(id)target action:(SEL)action forEvents:(UPControlEvents)events;

@property (nonatomic, readonly) UPBezierPathView *fillPathView;
@property (nonatomic, readonly) UPBezierPathView *strokePathView;
@property (nonatomic, readonly) UPBezierPathView *contentPathView;
@property (nonatomic, readonly) UPBezierPathView *auxiliaryPathView;
@property (nonatomic, readonly) UPBezierPathView *accentPathView;

- (void)bringPathViewToFront:(UPBezierPathView *)view;
- (void)sendPathViewToFront:(UPBezierPathView *)view;

- (void)setFillPath:(UIBezierPath *)path;
- (void)setFillPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)fillPathForState:(UPControlState)state;
- (void)setFillColor:(UIColor *)color;
- (void)setFillColor:(UIColor *)color forState:(UPControlState)state;
- (UIColor *)fillColorForState:(UPControlState)state;
- (void)setFillColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)fillColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setStrokePath:(UIBezierPath *)path;
- (void)setStrokePath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)strokePathForState:(UPControlState)state;
- (void)setStrokeColor:(UIColor *)color;
- (void)setStrokeColor:(UIColor *)color forState:(UPControlState)state;
- (UIColor *)strokeColorForState:(UPControlState)state;
- (void)setStrokeColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)strokeColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setContentPath:(UIBezierPath *)path;
- (void)setContentPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)contentPathForState:(UPControlState)state;
- (void)setContentColor:(UIColor *)color;
- (void)setContentColor:(UIColor *)color forState:(UPControlState)state;
- (UIColor *)contentColorForState:(UPControlState)state;
- (void)setContentColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)contentColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setAuxiliaryPath:(UIBezierPath *)path;
- (void)setAuxiliaryPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)auxiliaryPathForState:(UPControlState)state;
- (void)setAuxiliaryColor:(UIColor *)color;
- (void)setAuxiliaryColor:(UIColor *)color forState:(UPControlState)state;
- (UIColor *)auxiliaryColorForState:(UPControlState)state;
- (void)setAuxiliaryColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)auxiliaryColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setAccentPath:(UIBezierPath *)path;
- (void)setAccentPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)accentPathForState:(UPControlState)state;
- (void)setAccentColor:(UIColor *)color;
- (void)setAccentColor:(UIColor *)color forState:(UPControlState)state;
- (UIColor *)accentColorForState:(UPControlState)state;
- (void)setAccentColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)accentColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setNeedsControlUpdate;
- (void)controlUpdate;

- (void)cancelAnimations;

@end
