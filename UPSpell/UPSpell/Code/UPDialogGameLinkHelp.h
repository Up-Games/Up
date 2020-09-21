//
//  UPDialogGameLinkHelp.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPGameLink;
@class UPLabel;

@interface UPDialogGameLinkHelp : UIView

@property (nonatomic, readonly) UPLabel *titleLabel;
@property (nonatomic, readonly) UIView *helpLabelContainer;
@property (nonatomic, readonly) UPButton *okButton;

+ (UPDialogGameLinkHelp *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)updateWithGameLink:(UPGameLink *)gameLink;

@end
