//
//  UPSpellGameView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPBezierPathView;
@class UPControl;
@class UPGameTimer;
@class UPGameTimerLabel;
@class UPLabel;

@interface UPSpellGameView : UIView
@property (nonatomic) UPControl *wordTrayView;
@property (nonatomic) UIView *tileContainerView;
@property (nonatomic) UPBezierPathView *tileContainerClipView;
@property (nonatomic) UPControl *roundButtonPause;
@property (nonatomic) UPControl *roundButtonTrash;
@property (nonatomic) UPControl *roundButtonClear;
@property (nonatomic) UPGameTimerLabel *gameTimerLabel;
@property (nonatomic) UPLabel *scoreLabel;

+ (UPSpellGameView *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
