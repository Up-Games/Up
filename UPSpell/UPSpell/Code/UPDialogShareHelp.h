//
//  UPDialogShareHelp.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;

@interface UPDialogShareHelp : UIView

@property (nonatomic, readonly) UPLabel *titleLabel;
@property (nonatomic, readonly) UIView *helpLabelContainer;
@property (nonatomic, readonly) UPButton *okButton;

+ (UPDialogShareHelp *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
