//
//  UPDialogPause.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;

@interface UPDialogPause : UIView

@property (nonatomic, readonly) UPBezierPathView *messagePathView;
@property (nonatomic, readonly) UPButton *quitButton;
@property (nonatomic, readonly) UPButton *resumeButton;

+ (UPDialogPause *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
