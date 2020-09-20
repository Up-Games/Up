//
//  UPDialogDuelHelp.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;

@interface UPDialogDuelHelp : UIView

@property (nonatomic, readonly) UPLabel *titleLabel;
@property (nonatomic, readonly) UIView *helpLabelContainer;
@property (nonatomic, readonly) UPButton *okButton;

+ (UPDialogDuelHelp *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
