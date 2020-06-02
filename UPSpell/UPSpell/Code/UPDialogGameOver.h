//
//  UPDialogGameOver.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPControl;
@class UPLabel;

@interface UPDialogGameOver : UIView

@property (nonatomic, readonly) UPBezierPathView *titlePathView;
@property (nonatomic, readonly) UPControl *menuButton;
@property (nonatomic, readonly) UPControl *playButton;
@property (nonatomic, readonly) UPLabel *noteLabel;

+ (UPDialogGameOver *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
