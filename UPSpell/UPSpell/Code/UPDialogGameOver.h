//
//  UPDialogGameOver.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPControl;

@interface UPDialogGameOver : NSObject

@property (nonatomic, readonly) UPBezierPathView *gameOverMessagePathView;
@property (nonatomic, readonly) UPLabel *gameOverNoteLabel;
@property (nonatomic, readonly) UPButton *gameOverShareButton;

+ (UPDialogGameOver *)instance;

@end
