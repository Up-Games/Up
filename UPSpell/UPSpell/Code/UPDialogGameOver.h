//
//  UPDialogGameOver.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPControl;

@interface UPDialogGameOver : UIView

@property (nonatomic, readonly) UPBezierPathView *messagePathView;

+ (UPDialogGameOver *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
