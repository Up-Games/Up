//
//  UPDialogGameOver.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPControl;

@interface UPDialogGameOver : NSObject

@property (nonatomic, readonly) UPBezierPathView *messagePathView;
@property (nonatomic, readonly) UPLabel *noteLabel;
@property (nonatomic, readonly) UPButton *shareButton;

+ (UPDialogGameOver *)instance;

@end
