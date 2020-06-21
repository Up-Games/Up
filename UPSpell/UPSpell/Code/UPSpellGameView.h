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
@property (nonatomic) UIView *tileContainerView;
@property (nonatomic) UPControl *wordTrayControl;
@property (nonatomic) UPControl *pauseControl;
@property (nonatomic) UPControl *clearControl;
@property (nonatomic) UPGameTimerLabel *timerLabel;
@property (nonatomic) UPLabel *gameScoreLabel;
@property (nonatomic) UPLabel *wordScoreLabel;

+ (UPSpellGameView *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
