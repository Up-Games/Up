//
//  UPControl.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPBezierPathView;

typedef NS_OPTIONS(NSUInteger, UPControlState) {
    UPControlStateNormal =      0x00000000,
    UPControlStateHighlighted = 0x00000001,
    UPControlStateDisabled =    0x00000002,
    UPControlStateSelected =    0x00000004,
    UPControlStateActive =      0x00010000,
    UPControlStateApplication = 0x00FF0000,
    UPControlStateReserved =    0xFF000000,
    UPControlStateInvalid =     0x01000000,
};

typedef NS_OPTIONS(NSUInteger, UPControlElement) {
    // Values chosen to be in the UPControlStateApplication range, so
    // there's the option to bitwise-OR them together with UPControlStates.
    UPControlElementFill =    0x00100000,
    UPControlElementStroke =  0x00200000,
    UPControlElementContent = 0x00400000,
};

@interface UPControl : UIView

@property (nonatomic, readonly) UPControlState state;

@property (nonatomic, getter=isEnabled) BOOL enabled;          // default is YES. if NO, ignores touch events and subclasses may draw differently
@property (nonatomic, getter=isSelected) BOOL selected;        // default is NO may be used by some subclasses or by application
@property (nonatomic, getter=isHighlighted) BOOL highlighted;  // default is NO. this gets set/cleared automatically when touch enters/exits
@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic) BOOL autoHighlights;
@property (nonatomic) BOOL highlightedOverride;

@property (nonatomic) CGSize canonicalSize;

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

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic, readonly) UPBezierPathView *fillPathView;
@property (nonatomic, readonly) UPBezierPathView *strokePathView;
@property (nonatomic, readonly) UPBezierPathView *contentPathView;

- (void)setFillPath:(UIBezierPath *)path;
- (void)setFillPath:(UIBezierPath *)path forControlStates:(UPControlState)states;
- (void)setFillColor:(UIColor *)color;
- (void)setFillColor:(UIColor *)color forControlStates:(UPControlState)states;
- (UIColor *)fillColorForControlStates:(UPControlState)states;
- (void)setAnimatesFillColor:(BOOL)animates fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (BOOL)animatesFillColorFromState:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setStrokePath:(UIBezierPath *)path;
- (void)setStrokePath:(UIBezierPath *)path forControlStates:(UPControlState)states;
- (void)setStrokeColor:(UIColor *)color;
- (void)setStrokeColor:(UIColor *)color forControlStates:(UPControlState)states;
- (UIColor *)strokeColorForControlStates:(UPControlState)states;
- (void)setAnimatesStrokeColor:(BOOL)animates fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (BOOL)animatesStrokeColorFromState:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setContentPath:(UIBezierPath *)path;
- (void)setContentPath:(UIBezierPath *)path forControlStates:(UPControlState)states;
- (void)setContentColor:(UIColor *)color;
- (void)setContentColor:(UIColor *)color forControlStates:(UPControlState)states;
- (UIColor *)contentColorForControlStates:(UPControlState)states;
- (void)setAnimatesContentColor:(BOOL)animates fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (BOOL)animatesContentColorFromState:(UPControlState)fromState toState:(UPControlState)toState;

- (void)controlUpdate;

@end
