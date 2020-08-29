//
//  UPDialogPlayingHelp.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;

@interface UPDialogPlayingHelp : UIView

@property (nonatomic, readonly) UPLabel *helpLabel;

+ (UPDialogPlayingHelp *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
