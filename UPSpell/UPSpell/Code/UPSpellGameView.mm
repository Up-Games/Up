//
//  UPSpellGameView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPContainerView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGameTimer.h>
#import <UpKit/UPGameTimerLabel.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPBand.h>

#import "UPControl+UPSpell.h"
#import "UPSpellGameView.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;
using UP::BandGameUI;
using UP::role_for;
using UP::role_in_word;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

@interface UPSpellGameView ()
@property (nonatomic) UPBezierPathView *tileContainerClipView;
@property (nonatomic) UIView *wordScoreContainerView;
@property (nonatomic) UPBezierPathView *wordScoreContainerClipView;
@end

@implementation UPSpellGameView

+ (UPSpellGameView *)instance
{
    static dispatch_once_t onceToken;
    static UPSpellGameView *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPSpellGameView alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.screen_bounds()];

    self.wordTrayView = [UPControl wordTray];
    self.wordTrayView.band = BandGameUI;
    self.wordTrayView.frame = layout.word_tray_layout_frame();
    [self addSubview:self.wordTrayView];
    self.tileContainerView = [[UPContainerView alloc] initWithFrame:CGRectZero];
    self.tileContainerView.frame = layout.screen_bounds();
    [self addSubview:self.tileContainerView];

    self.tileContainerClipView = [UPBezierPathView bezierPathView];
    self.tileContainerClipView.canonicalSize = UP::SpellLayout::CanonicalWordTrayTileMaskFrame.size;
    self.tileContainerClipView.frame = layout.word_tray_mask_frame();
    self.tileContainerClipView.path = [self wordTrayTileMaskPath];
    self.tileContainerClipView.fillColor = [UIColor blackColor];
    self.tileContainerView.layer.mask = self.tileContainerClipView.shapeLayer;

    self.roundButtonPause = [UPControl roundButtonPause];
    self.roundButtonPause.band = BandGameUI;
    self.roundButtonPause.frame = layout.frame_for(Role::GameButtonLeft);
    self.roundButtonPause.chargeSize = layout.game_controls_button_charge_size();
    [self addSubview:self.roundButtonPause];

    self.roundButtonTrash = [UPControl roundButtonTrash];
    self.roundButtonTrash.band = BandGameUI;
    self.roundButtonTrash.frame = layout.frame_for(Role::GameButtonRight);
    self.roundButtonTrash.chargeSize = layout.game_controls_button_charge_size();
    [self addSubview:self.roundButtonTrash];

    self.roundButtonClear = [UPControl roundButtonClear];
    self.roundButtonClear.band = BandGameUI;
    self.roundButtonClear.frame = layout.frame_for(Role::GameButtonRight);
    self.roundButtonClear.chargeSize = layout.game_controls_button_charge_size();
    [self addSubview:self.roundButtonClear];

    self.timerLabel = [UPGameTimerLabel label];
    self.timerLabel.font = layout.game_information_font();
    self.timerLabel.superscriptFont = layout.game_information_superscript_font();
    self.timerLabel.superscriptBaselineAdjustment = layout.game_information_superscript_font_metrics().baseline_adjustment();
    self.timerLabel.superscriptKerning = layout.game_information_superscript_font_metrics().kerning();
    
    self.timerLabel.textColorCategory = UPColorCategoryInformation;
    self.timerLabel.textAlignment = NSTextAlignmentRight;
    self.timerLabel.frame = layout.frame_for(Role::GameTimer);
    [self addSubview:self.timerLabel];

    self.gameScoreLabel = [UPLabel label];
    self.gameScoreLabel.string = @"0";
    self.gameScoreLabel.font = layout.game_information_font();
    self.gameScoreLabel.textColorCategory = UPColorCategoryInformation;
    self.gameScoreLabel.textAlignment = NSTextAlignmentRight;
    self.gameScoreLabel.frame = layout.frame_for(Role::GameScore);
    [self addSubview:self.gameScoreLabel];

    self.wordScoreContainerView = [[UPContainerView alloc] initWithFrame:CGRectZero];
    self.wordScoreContainerView.frame = layout.screen_bounds();
    [self addSubview:self.wordScoreContainerView];
    
    self.wordScoreContainerClipView = [UPBezierPathView bezierPathView];
    self.wordScoreContainerClipView.canonicalSize = UP::SpellLayout::CanonicalWordTrayFrame.size;
    self.wordScoreContainerClipView.frame = layout.word_tray_layout_frame();
    self.wordScoreContainerClipView.path = [self wordScoreMaskPath];
    self.wordScoreContainerClipView.fillColor = [UIColor blackColor];
    self.wordScoreContainerView.layer.mask = self.wordScoreContainerClipView.shapeLayer;

    self.wordScoreLabel = [UPLabel label];
    self.wordScoreLabel.string = @"+0";
    self.wordScoreLabel.textColorCategory = UPColorCategoryInformation;
    self.wordScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.wordScoreLabel.frame = layout.frame_for(Role::WordScore);
    [self.wordScoreContainerView addSubview:self.wordScoreLabel];
    self.wordScoreLabel.hidden = YES;
    
    return self;
}

- (UIBezierPath *)wordTrayTileMaskPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(874.89, 42.17)];
    [path addCurveToPoint: CGPointMake(874.92, 29.27) controlPoint1: CGPointMake(874.89, 37.87) controlPoint2: CGPointMake(874.9, 33.57)];
    [path addLineToPoint:CGPointMake(874.77, 29.3)];
    [path addCurveToPoint: CGPointMake(874.67, 21.61) controlPoint1: CGPointMake(874.74, 26.73) controlPoint2: CGPointMake(874.71, 24.17)];
    [path addCurveToPoint: CGPointMake(868.51, 10.28) controlPoint1: CGPointMake(874.43, 16.58) controlPoint2: CGPointMake(872.87, 12.34)];
    [path addCurveToPoint: CGPointMake(861.45, 7.53) controlPoint1: CGPointMake(866.21, 9.19) controlPoint2: CGPointMake(863.87, 8.03)];
    [path addCurveToPoint: CGPointMake(843.92, 4.64) controlPoint1: CGPointMake(855.64, 6.34) controlPoint2: CGPointMake(849.8, 5.14)];
    [path addCurveToPoint: CGPointMake(658, 0.19) controlPoint1: CGPointMake(782.07, -0.48) controlPoint2: CGPointMake(719.98, 0.61)];
    [path addCurveToPoint: CGPointMake(437.5, 0.01) controlPoint1: CGPointMake(586.97, 0.02) controlPoint2: CGPointMake(508.65, -0.02)];
    [path addCurveToPoint: CGPointMake(217, 0.19) controlPoint1: CGPointMake(366.35, -0.02) controlPoint2: CGPointMake(288.03, 0.02)];
    [path addCurveToPoint: CGPointMake(31.08, 4.64) controlPoint1: CGPointMake(155.02, 0.61) controlPoint2: CGPointMake(92.93, -0.48)];
    [path addCurveToPoint: CGPointMake(13.55, 7.53) controlPoint1: CGPointMake(25.2, 5.14) controlPoint2: CGPointMake(19.36, 6.34)];
    [path addCurveToPoint: CGPointMake(6.49, 10.28) controlPoint1: CGPointMake(11.13, 8.03) controlPoint2: CGPointMake(8.79, 9.19)];
    [path addCurveToPoint: CGPointMake(0.33, 21.61) controlPoint1: CGPointMake(2.13, 12.34) controlPoint2: CGPointMake(0.57, 16.58)];
    [path addCurveToPoint: CGPointMake(0.23, 29.3) controlPoint1: CGPointMake(0.29, 24.17) controlPoint2: CGPointMake(0.26, 26.73)];
    [path addLineToPoint:CGPointMake(0.08, 29.27)];
    [path addCurveToPoint: CGPointMake(0.11, 42.16) controlPoint1: CGPointMake(0.1, 33.57) controlPoint2: CGPointMake(0.11, 37.87)];
    [path addCurveToPoint: CGPointMake(0.07, 132) controlPoint1: CGPointMake(-0.02, 59.55) controlPoint2: CGPointMake(-0.03, 107.78)];
    [path addLineToPoint:CGPointMake(-0, 132)];
    [path addLineToPoint:CGPointMake(-0, 420)];
    [path addLineToPoint:CGPointMake(875, 420)];
    [path addLineToPoint:CGPointMake(875, 132)];
    [path addLineToPoint:CGPointMake(874.93, 132)];
    [path addCurveToPoint: CGPointMake(874.89, 42.17) controlPoint1: CGPointMake(875.04, 107.78) controlPoint2: CGPointMake(875.02, 59.55)];
    [path closePath];
    return path;
}

- (UIBezierPath *)wordScoreMaskPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(864.39, 40.21)];
    [path addLineToPoint: CGPointMake(864.27, 29.41)];
    [path addCurveToPoint: CGPointMake(864.18, 21.94) controlPoint1: CGPointMake(864.24, 26.92) controlPoint2: CGPointMake(864.21, 24.43)];
    [path addCurveToPoint: CGPointMake(863.69, 19.3) controlPoint1: CGPointMake(864.08, 20.28) controlPoint2: CGPointMake(863.8, 19.54)];
    [path addLineToPoint: CGPointMake(863.21, 19.07)];
    [path addCurveToPoint: CGPointMake(858.94, 17.33) controlPoint1: CGPointMake(861.63, 18.32) controlPoint2: CGPointMake(860, 17.55)];
    [path addLineToPoint: CGPointMake(858.86, 17.31)];
    [path addCurveToPoint: CGPointMake(842.57, 14.6) controlPoint1: CGPointMake(853.19, 16.15) controlPoint2: CGPointMake(847.83, 15.06)];
    [path addCurveToPoint: CGPointMake(693.79, 10.32) controlPoint1: CGPointMake(793.22, 10.52) controlPoint2: CGPointMake(742.67, 10.42)];
    [path addCurveToPoint: CGPointMake(657.44, 10.19) controlPoint1: CGPointMake(681.88, 10.3) controlPoint2: CGPointMake(669.56, 10.28)];
    [path addCurveToPoint: CGPointMake(481.91, 10) controlPoint1: CGPointMake(605.94, 10.06) controlPoint2: CGPointMake(546.87, 10)];
    [path addCurveToPoint: CGPointMake(437, 10.01) controlPoint1: CGPointMake(466.72, 10) controlPoint2: CGPointMake(451.71, 10)];
    [path addCurveToPoint: CGPointMake(392.09, 10) controlPoint1: CGPointMake(422.29, 10) controlPoint2: CGPointMake(407.28, 10)];
    [path addCurveToPoint: CGPointMake(216.52, 10.19) controlPoint1: CGPointMake(327.13, 10) controlPoint2: CGPointMake(268.06, 10.06)];
    [path addCurveToPoint: CGPointMake(180.21, 10.32) controlPoint1: CGPointMake(204.44, 10.28) controlPoint2: CGPointMake(192.12, 10.3)];
    [path addCurveToPoint: CGPointMake(31.4, 14.61) controlPoint1: CGPointMake(131.33, 10.42) controlPoint2: CGPointMake(80.78, 10.52)];
    [path addCurveToPoint: CGPointMake(15.14, 17.31) controlPoint1: CGPointMake(26.17, 15.06) controlPoint2: CGPointMake(20.81, 16.15)];
    [path addLineToPoint: CGPointMake(15.05, 17.33)];
    [path addCurveToPoint: CGPointMake(10.79, 19.07) controlPoint1: CGPointMake(14, 17.55) controlPoint2: CGPointMake(12.37, 18.32)];
    [path addLineToPoint: CGPointMake(10.31, 19.3)];
    [path addCurveToPoint: CGPointMake(9.82, 21.94) controlPoint1: CGPointMake(10.2, 19.54) controlPoint2: CGPointMake(9.92, 20.28)];
    [path addCurveToPoint: CGPointMake(9.73, 29.41) controlPoint1: CGPointMake(9.79, 24.43) controlPoint2: CGPointMake(9.76, 26.92)];
    [path addLineToPoint: CGPointMake(9.61, 40.16)];
    [path addCurveToPoint: CGPointMake(9.61, 42.16) controlPoint1: CGPointMake(9.61, 40.83) controlPoint2: CGPointMake(9.61, 41.49)];
    [path addLineToPoint: CGPointMake(9.61, 42.2)];
    [path addLineToPoint: CGPointMake(9.61, 42.24)];
    [path addCurveToPoint: CGPointMake(9.61, 139.76) controlPoint1: CGPointMake(9.46, 61.84) controlPoint2: CGPointMake(9.46, 120.17)];
    [path addLineToPoint: CGPointMake(9.61, 139.8)];
    [path addLineToPoint: CGPointMake(9.61, 139.85)];
    [path addCurveToPoint: CGPointMake(9.61, 141.84) controlPoint1: CGPointMake(9.61, 140.51) controlPoint2: CGPointMake(9.61, 141.18)];
    [path addLineToPoint: CGPointMake(9.73, 152.59)];
    [path addCurveToPoint: CGPointMake(9.82, 160.06) controlPoint1: CGPointMake(9.76, 155.08) controlPoint2: CGPointMake(9.79, 157.57)];
    [path addCurveToPoint: CGPointMake(10.31, 162.7) controlPoint1: CGPointMake(9.92, 161.72) controlPoint2: CGPointMake(10.2, 162.47)];
    [path addLineToPoint: CGPointMake(10.79, 162.93)];
    [path addCurveToPoint: CGPointMake(15.05, 164.67) controlPoint1: CGPointMake(12.37, 163.68) controlPoint2: CGPointMake(14, 164.45)];
    [path addLineToPoint: CGPointMake(15.14, 164.69)];
    [path addCurveToPoint: CGPointMake(31.43, 167.4) controlPoint1: CGPointMake(20.81, 165.85) controlPoint2: CGPointMake(26.17, 166.95)];
    [path addCurveToPoint: CGPointMake(180.21, 171.68) controlPoint1: CGPointMake(80.78, 171.48) controlPoint2: CGPointMake(131.33, 171.58)];
    [path addCurveToPoint: CGPointMake(216.56, 171.81) controlPoint1: CGPointMake(192.12, 171.7) controlPoint2: CGPointMake(204.44, 171.73)];
    [path addCurveToPoint: CGPointMake(392.14, 172) controlPoint1: CGPointMake(268.12, 171.94) controlPoint2: CGPointMake(327.21, 172)];
    [path addCurveToPoint: CGPointMake(437, 171.99) controlPoint1: CGPointMake(407.31, 172) controlPoint2: CGPointMake(422.3, 172)];
    [path addCurveToPoint: CGPointMake(481.86, 172) controlPoint1: CGPointMake(451.69, 172) controlPoint2: CGPointMake(466.69, 172)];
    [path addCurveToPoint: CGPointMake(657.48, 171.81) controlPoint1: CGPointMake(546.79, 172) controlPoint2: CGPointMake(605.88, 171.94)];
    [path addCurveToPoint: CGPointMake(693.79, 171.68) controlPoint1: CGPointMake(669.56, 171.73) controlPoint2: CGPointMake(681.88, 171.7)];
    [path addCurveToPoint: CGPointMake(842.6, 167.4) controlPoint1: CGPointMake(742.67, 171.58) controlPoint2: CGPointMake(793.22, 171.48)];
    [path addCurveToPoint: CGPointMake(858.86, 164.69) controlPoint1: CGPointMake(847.83, 166.95) controlPoint2: CGPointMake(853.19, 165.85)];
    [path addLineToPoint: CGPointMake(858.94, 164.67)];
    [path addCurveToPoint: CGPointMake(863.21, 162.93) controlPoint1: CGPointMake(860, 164.45) controlPoint2: CGPointMake(861.63, 163.68)];
    [path addLineToPoint: CGPointMake(863.69, 162.7)];
    [path addCurveToPoint: CGPointMake(864.18, 160.06) controlPoint1: CGPointMake(863.8, 162.47) controlPoint2: CGPointMake(864.08, 161.72)];
    [path addCurveToPoint: CGPointMake(864.27, 152.59) controlPoint1: CGPointMake(864.21, 157.57) controlPoint2: CGPointMake(864.24, 155.08)];
    [path addLineToPoint: CGPointMake(864.39, 141.79)];
    [path addCurveToPoint: CGPointMake(864.39, 139.84) controlPoint1: CGPointMake(864.39, 141.14) controlPoint2: CGPointMake(864.39, 140.49)];
    [path addLineToPoint: CGPointMake(864.39, 139.8)];
    [path addLineToPoint: CGPointMake(864.39, 139.76)];
    [path addCurveToPoint: CGPointMake(864.39, 42.24) controlPoint1: CGPointMake(864.54, 120.16) controlPoint2: CGPointMake(864.54, 61.84)];
    [path addLineToPoint: CGPointMake(864.39, 42.2)];
    [path addLineToPoint: CGPointMake(864.39, 42.16)];
    [path addCurveToPoint: CGPointMake(864.39, 40.21) controlPoint1: CGPointMake(864.39, 41.51) controlPoint2: CGPointMake(864.39, 40.86)];
    [path closePath];
    return path;
}

@end
