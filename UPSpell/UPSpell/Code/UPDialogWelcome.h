//
//  UPDialogWelcome.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPTextButton;
@class UPLabel;
@class UPLogoView;

@interface UPDialogWelcome : UIView

@property (nonatomic, readonly) UPLogoView *logoView;
@property (nonatomic, readonly) UPLabel *wordMarkLabel;
@property (nonatomic, readonly) UPLabel *welcomeTitleLabel;
@property (nonatomic, readonly) UPLabel *welcomeDetailLabel;
@property (nonatomic, readonly) UPTextButton *welcomeOKButton;

+ (UPDialogWelcome *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
