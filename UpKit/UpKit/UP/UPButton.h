//
//  UPButton.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPControl.h>

@interface UPButton : UPControl

@property (nonatomic, weak, readonly) id target;
@property (nonatomic, readonly) SEL action;

+ (UPButton *)button;
+ (UPButton *)buttonWithTarget:(id)target action:(SEL)action;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithTarget:(id)target action:(SEL)action;

- (void)setTarget:(id)target action:(SEL)action;

@end
