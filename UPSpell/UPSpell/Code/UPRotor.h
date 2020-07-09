//
//  UPRotor.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

typedef NS_ENUM(NSInteger, UPRotorType) {
    UPRotorTypeDefault,
    UPRotorTypeAlphabet,
    UPRotorTypeNumbers,
};

@interface UPRotor : UPControl

+ (UPRotor *)rotorWithType:(UPRotorType)rotorType;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
