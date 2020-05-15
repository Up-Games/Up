//
//  UPControl.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UPControlState) {
    // Bits in this range:
    // UIControlStateApplication = 0x00FF0000
    UPControlStateActive =         0x00010000,
    UPControlStateFlag1 =          0x00100000,
    UPControlStateFlag2 =          0x00200000,
    UPControlStateFlag3 =          0x00400000,
    UPControlStateFlag4 =          0x00800000,
};

@interface UPControl : UIControl

@property (nonatomic) CGSize canonicalSize;
@property(nonatomic, getter=isActive) BOOL active;

- (void)setNormal;
- (void)setHighlighted;
- (void)setDisabled;
- (void)setSelected;
- (void)setActive;

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
