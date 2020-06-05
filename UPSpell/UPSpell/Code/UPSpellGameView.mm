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

    UIBezierPath *wordTrayMaskPath = [self wordTrayMaskPath];
    self.tileContainerClipView = [UPBezierPathView bezierPathView];
    self.tileContainerClipView.canonicalSize = UP::SpellLayout::CanonicalWordTrayMaskFrame.size;
    self.tileContainerClipView.frame = layout.word_tray_mask_frame();
    self.tileContainerClipView.path = wordTrayMaskPath;
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

    self.scoreLabel = [UPLabel label];
    self.scoreLabel.string = @"0";
    self.scoreLabel.font = layout.game_information_font();
    self.scoreLabel.textColorCategory = UPColorCategoryInformation;
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.frame = layout.frame_for(Role::GameScore);
    [self addSubview:self.scoreLabel];

    return self;
}

- (UIBezierPath *)wordTrayMaskPath
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

@end
