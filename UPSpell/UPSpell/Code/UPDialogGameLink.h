//
//  UPDialogGameLink.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;
@class UPGameLink;

@interface UPDialogGameLink : UIView

@property (nonatomic, readonly) UPLogoView *logoView;
@property (nonatomic, readonly) UPLabel *wordMarkLabel;
@property (nonatomic, readonly) UPLabel *titlePromptLabel;
@property (nonatomic, readonly) UPLabel *detailPromptLabel;
@property (nonatomic, readonly) UPButton *cancelButton;
@property (nonatomic, readonly) UPButton *confirmButton;
@property (nonatomic, readonly) UPButton *helpButton;

+ (UPDialogGameLink *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)updateWithGameLink:(UPGameLink *)gameLink;

@end
