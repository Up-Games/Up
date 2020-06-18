//
//  UPButton.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPControl.h>

@interface UPButton : UPControl

+ (UPButton *)button;
+ (UPButton *)buttonWithTarget:(id)target action:(SEL)action;

- (void)setTarget:(id)target action:(SEL)action;

@end
