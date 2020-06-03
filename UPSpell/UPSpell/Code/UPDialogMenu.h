//
//  UPDialogMenu.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPControl;

@interface UPDialogMenu : UIView

@property (nonatomic, readonly) UPControl *extrasButton;
@property (nonatomic, readonly) UPControl *playButton;
@property (nonatomic, readonly) UPControl *aboutButton;

+ (UPDialogMenu *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
