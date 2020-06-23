//
//  UPCheckbox.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPControl.h>

@interface UPCheckbox : UPControl

@property (nonatomic) NSString *labelString;

+ (UPCheckbox *)checkbox;
+ (UPCheckbox *)checkboxWithTarget:(id)target action:(SEL)action;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
