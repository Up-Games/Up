//
//  UPSpellGameView.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPBezierPathView;
@class UPControl;
@class UPGameTimer;
@class UPGameTimerLabel;
@class UPLabel;
@class UPPulseView;

@interface UPSpellGameView : UIView
@property (nonatomic) UIView *tileContainerView;
@property (nonatomic) UPControl *wordTrayControl;
@property (nonatomic) UPControl *pauseControl;
@property (nonatomic) UPControl *clearControl;
@property (nonatomic) UPGameTimerLabel *timerLabel;
@property (nonatomic) UPLabel *gameScoreLabel;
@property (nonatomic) UPLabel *wordScoreLabel;
@property (nonatomic) UPPulseView *pulseView;
@property (nonatomic, readonly) NSArray<UIView *> *interactiveSubviews;

+ (UPSpellGameView *)instance;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
