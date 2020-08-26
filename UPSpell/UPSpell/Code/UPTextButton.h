//
//  UPTextButton.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPButton.h>

typedef NS_ENUM(NSInteger, UPTextButtonBehavior) {
    UPTextButtonBehaviorDefault,
    UPTextButtonBehaviorPushButton,
    UPTextButtonBehaviorModeButton,
};

@interface UPTextButton : UPButton

@property (nonatomic) UPTextButtonBehavior behavior;

+ (UPTextButton *)textButton;
+ (UPTextButton *)smallTextButton;

@end
