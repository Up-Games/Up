//
//  UPTextSettingsButton.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPTextButton.h"

@interface UPTextSettingsButton : UPTextButton

+ (UPTextSettingsButton *)textSettingsButton;
+ (UPTextSettingsButton *)textSettingsButtonWithLabelString:(NSString *)labelString;
+ (UPTextSettingsButton *)textSettingsButtonWithTarget:(id)target action:(SEL)action;

@end
