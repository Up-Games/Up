//
//  UPControl.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UPKit/UPQuadView.h>

typedef NS_ENUM(NSUInteger, UPControlState) {
    // Bits in this range:
    // UIControlStateApplication = 0x00FF0000
    UPControlStateActive =         0x00010000,
    UPControlStateFlag1 =          0x00100000,
    UPControlStateFlag2 =          0x00200000,
    UPControlStateFlag3 =          0x00400000,
    UPControlStateFlag4 =          0x00800000,
};

@interface UPControl : UPQuadView

@property (nonatomic, readonly) UIControlState state;

@property (nonatomic, getter=isEnabled) BOOL enabled;          // default is YES. if NO, ignores touch events and subclasses may draw differently
@property (nonatomic, getter=isSelected) BOOL selected;        // default is NO may be used by some subclasses or by application
@property (nonatomic, getter=isHighlighted) BOOL highlighted;  // default is NO. this gets set/cleared automatically when touch enters/exits
@property (nonatomic, getter=isActive) BOOL active;
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

- (void)updateControl;

- (void)setContentPath:(UIBezierPath *)path;
- (void)setContentPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;
- (void)setContentColor:(UIColor *)color;
- (void)setContentColor:(UIColor *)color forControlStates:(UIControlState)controlStates;

- (void)setFillPath:(UIBezierPath *)path;
- (void)setFillPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;
- (void)setFillColor:(UIColor *)color;
- (void)setFillColor:(UIColor *)color forControlStates:(UIControlState)controlStates;

- (void)setStrokePath:(UIBezierPath *)path;
- (void)setStrokePath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;
- (void)setStrokeColor:(UIColor *)color;
- (void)setStrokeColor:(UIColor *)color forControlStates:(UIControlState)controlStates;

@end
