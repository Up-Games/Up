//
//  UPDialogPause.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPControl;
@class UPLabel;

@interface UPDialogPause : UIView

@property (nonatomic, readonly) UPBezierPathView *titlePathView;
@property (nonatomic, readonly) UPControl *quitButton;
@property (nonatomic, readonly) UPControl *resumeButton;

+ (UPDialogPause *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
