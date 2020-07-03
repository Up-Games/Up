//
//  UPControl.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UIColor+UP.h>
#import <UPKit/UPBand.h>
#import <UPKit/UPGeometry.h>

@class UPBezierPathView;
@class UPGestureRecognizer;
@class UPLabel;

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
    UPControlElementLabel =     0x02000000,
};

@interface UPControl : UIView

@property (nonatomic, readonly) UPControlState state;
@property (nonatomic, getter=isEnabled) BOOL enabled;          // default is YES. if NO, ignores touch events and subclasses may draw differently
@property (nonatomic, getter=isSelected) BOOL selected;        // default is NO may be used by some subclasses or by application
@property (nonatomic, getter=isHighlighted) BOOL highlighted;  // default is NO. this gets set/cleared automatically when touch enters/exits
@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic) BOOL autoHighlights;
@property (nonatomic) BOOL autoSelects;
@property (nonatomic) BOOL highlightedLocked;

@property (nonatomic) CGSize canonicalSize;
@property (nonatomic) UPOutsets chargeOutsets;
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

@property (nonatomic, readonly) UPBezierPathView *fillPathView;
@property (nonatomic, readonly) UPBezierPathView *strokePathView;
@property (nonatomic, readonly) UPBezierPathView *contentPathView;
@property (nonatomic, readonly) UPBezierPathView *auxiliaryPathView;
@property (nonatomic, readonly) UPBezierPathView *accentPathView;
@property (nonatomic, readonly) UPLabel *label;

- (void)bringPathViewToFront:(UPBezierPathView *)view;
- (void)sendPathViewToBack:(UPBezierPathView *)view;

- (void)setFillPath:(UIBezierPath *)path;
- (void)setFillPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)fillPathForState:(UPControlState)state;
- (void)setFillColorCategory:(UPColorCategory)colorCategory;
- (void)setFillColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
- (UPColorCategory)fillColorCategoryForState:(UPControlState)state;
- (UIColor *)fillColorForState:(UPControlState)state;
- (void)setFillColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)fillColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setStrokePath:(UIBezierPath *)path;
- (void)setStrokePath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)strokePathForState:(UPControlState)state;
- (void)setStrokeColorCategory:(UPColorCategory)colorCategory;
- (void)setStrokeColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
- (UPColorCategory)strokeColorCategoryForState:(UPControlState)state;
- (UIColor *)strokeColorForState:(UPControlState)state;
- (void)setStrokeColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)strokeColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setContentPath:(UIBezierPath *)path;
- (void)setContentPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)contentPathForState:(UPControlState)state;
- (void)setContentColorCategory:(UPColorCategory)colorCategory;
- (void)setContentColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
- (UPColorCategory)contentColorCategoryForState:(UPControlState)state;
- (UIColor *)contentColorForState:(UPControlState)state;
- (void)setContentColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)contentColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setAuxiliaryPath:(UIBezierPath *)path;
- (void)setAuxiliaryPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)auxiliaryPathForState:(UPControlState)state;
- (void)setAuxiliaryColorCategory:(UPColorCategory)colorCategory;
- (void)setAuxiliaryColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
- (UPColorCategory)auxiliaryColorCategoryForState:(UPControlState)state;
- (UIColor *)auxiliaryColorForState:(UPControlState)state;
- (void)setAuxiliaryColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)auxiliaryColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setAccentPath:(UIBezierPath *)path;
- (void)setAccentPath:(UIBezierPath *)path forState:(UPControlState)state;
- (UIBezierPath *)accentPathForState:(UPControlState)state;
- (void)setAccentColorCategory:(UPColorCategory)colorCategory;
- (void)setAccentColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
- (UPColorCategory)accentColorCategoryForState:(UPControlState)state;
- (UIColor *)accentColorForState:(UPControlState)state;
- (void)setAccentColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)accentColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setLabelString:(NSString *)string;
- (void)setLabelString:(NSString *)string forState:(UPControlState)state;
- (NSString *)labelStringForState:(UPControlState)state;
- (void)setLabelColorCategory:(UPColorCategory)colorCategory;
- (void)setLabelColorCategory:(UPColorCategory)colorCategory forState:(UPControlState)state;
- (UPColorCategory)labelColorCategoryForState:(UPControlState)state;
- (UIColor *)labelColorForState:(UPControlState)state;
- (void)setLabelColorAnimationDuration:(CFTimeInterval)duration fromState:(UPControlState)fromState toState:(UPControlState)toState;
- (CFTimeInterval)labelColorAnimationDuration:(UPControlState)fromState toState:(UPControlState)toState;

- (void)setNeedsUpdate;
- (void)update;
- (void)invalidate;
- (void)freeze;

- (void)cancelAnimations;

@end
