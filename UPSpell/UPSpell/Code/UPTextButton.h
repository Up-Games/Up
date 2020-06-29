//
//  UPTextButton.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPButton.h>

@interface UPTextButton : UPButton

+ (UPTextButton *)textButton;
+ (UPTextButton *)textButtonWithLabelString:(NSString *)labelString;
+ (UPTextButton *)textButtonWithTarget:(id)target action:(SEL)action;

@end
