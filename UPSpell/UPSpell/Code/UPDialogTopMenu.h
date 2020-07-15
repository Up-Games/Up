//
//  UPDialogTopMenu.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UpKit.h>

@class UPBezierPathView;
@class UPTextButton;

@interface UPDialogTopMenu : UPContainerView

@property (nonatomic, readonly) UPBezierPathView *messagePathView;
@property (nonatomic, readonly) UPTextButton *extrasButton;
@property (nonatomic, readonly) UPTextButton *playButton;
@property (nonatomic, readonly) UPTextButton *aboutButton;

+ (UPDialogTopMenu *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
