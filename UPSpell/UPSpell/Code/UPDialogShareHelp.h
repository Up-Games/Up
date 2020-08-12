//
//  UPDialogShareHelp.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;

@interface UPDialogShareHelp : UIView

@property (nonatomic, readonly) UPLabel *titleLabel;
@property (nonatomic, readonly) UPLabel *helpLabel;
@property (nonatomic, readonly) UPButton *okButton;

+ (UPDialogShareHelp *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
