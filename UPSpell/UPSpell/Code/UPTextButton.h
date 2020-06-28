//
//  UPTextButton.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPButton.h>

@interface UPTextButton : UPButton

@property (nonatomic) NSString *labelString;

+ (UPTextButton *)textButton;
+ (UPTextButton *)textButtonWithTarget:(id)target action:(SEL)action;

@end
