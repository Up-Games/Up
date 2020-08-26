//
//  UPDialogGameNote.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPLabel;

@interface UPDialogGameNote : UIView

@property (nonatomic, readonly) UPLabel *noteLabel;
@property (nonatomic, readonly) UPButton *shareButton;

+ (UPDialogGameNote *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
