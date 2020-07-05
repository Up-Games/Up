//
//  UPCheckbox.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPControl.h>

typedef NS_ENUM(NSInteger, UPCheckboxShape) {
    UPCheckboxShapeDefault,
    UPCheckboxShapeSquare,
    UPCheckboxShapeRound,
};

@interface UPCheckbox : UPControl

@property (nonatomic, readonly) UPCheckboxShape shape;

+ (UPCheckbox *)checkboxWithShape:(UPCheckboxShape)shape;
+ (UPCheckbox *)checkboxWithShape:(UPCheckboxShape)shape target:(id)target action:(SEL)action;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
