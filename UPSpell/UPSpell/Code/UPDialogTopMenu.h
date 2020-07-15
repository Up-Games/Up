//
//  UPDialogTopMenu.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UpKit.h>

@class UPBezierPathView;
@class UPButton;

@interface UPDialogTopMenu : UPContainerView

@property (nonatomic, readonly) UPBezierPathView *messagePathView;
@property (nonatomic, readonly) UPButton *extrasButton;
@property (nonatomic, readonly) UPButton *playButton;
@property (nonatomic, readonly) UPButton *aboutButton;

+ (UPDialogTopMenu *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
