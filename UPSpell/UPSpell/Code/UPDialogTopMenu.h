//
//  UPDialogTopMenu.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UpKit.h>

@class UPBezierPathView;
@class UPTextButton;

@interface UPDialogTopMenu : NSObject

@property (nonatomic, readonly) UPBezierPathView *readyMessagePathView;
@property (nonatomic, readonly) UPTextButton *extrasButton;
@property (nonatomic, readonly) UPTextButton *playButton;
@property (nonatomic, readonly) UPTextButton *inviteButton;

+ (UPDialogTopMenu *)instance;

@end
