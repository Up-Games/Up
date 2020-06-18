//
//  UPSpellGameView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPBezierPathView;
@class UPButton;
@class UPGameTimer;
@class UPGameTimerLabel;
@class UPLabel;

@interface UPSpellGameView : UIView
@property (nonatomic) UPButton *wordTrayView;
@property (nonatomic) UIView *tileContainerView;
@property (nonatomic) UPButton *roundGameButtonPause;
@property (nonatomic) UPButton *roundGameButtonClear;
@property (nonatomic) UPGameTimerLabel *timerLabel;
@property (nonatomic) UPLabel *gameScoreLabel;
@property (nonatomic) UPLabel *wordScoreLabel;

+ (UPSpellGameView *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
