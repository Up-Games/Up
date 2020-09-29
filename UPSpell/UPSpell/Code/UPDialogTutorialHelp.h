//
//  UPDialogTutorialHelp.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPTextButton;
@class UPLabel;
@class UPLogoView;

@interface UPDialogTutorialHelp : UIView

@property (nonatomic, readonly) UPLogoView *logoView;
@property (nonatomic, readonly) UPLabel *wordMarkLabel;
@property (nonatomic, readonly) UPLabel *welcomeLabel;
@property (nonatomic, readonly) UPLabel *tutorialPromptLabel;
@property (nonatomic, readonly) UIView *graduationLabelContainer;
@property (nonatomic, readonly) UPTextButton *tutorialStartButton;
@property (nonatomic, readonly) UPTextButton *tutorialDoneButton;
@property (nonatomic, readonly) UPTextButton *graduationOKButton;

+ (UPDialogTutorialHelp *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
