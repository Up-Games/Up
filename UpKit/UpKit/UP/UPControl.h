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

@property(nonatomic, getter=isActive) BOOL active;

- (void)setNormal;
- (void)setHighlighted;
- (void)setDisabled;
- (void)setSelected;
- (void)setActive;

- (void)updateControl;

@end
