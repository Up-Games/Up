//
//  UPStepper.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPControl.h>

typedef NS_ENUM(NSInteger, UPStepperDirection) {
    UPStepperDirectionDefault,
    UPStepperDirectionUp,
    UPStepperDirectionDown,
    UPStepperDirectionLeft,
    UPStepperDirectionRight,
};

@interface UPStepper : UPControl

@property (nonatomic, readonly) UPStepperDirection direction;

+ (UPStepper *)stepperWithDirection:(UPStepperDirection)direction;
+ (UPStepper *)stepperWithDirection:(UPStepperDirection)direction target:(id)target action:(SEL)action;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
