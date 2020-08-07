//
//  UPDialogShared.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;
@class UPSharedGameRequest;

@interface UPDialogShared : UIView

@property (nonatomic, readonly) UPLabel *promptLabel;
@property (nonatomic, readonly) UPButton *cancelButton;
@property (nonatomic, readonly) UPButton *goButton;

+ (UPDialogShared *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)updatePromptWithSharedGameRequest:(UPSharedGameRequest *)sharedGameRequest;

@end
