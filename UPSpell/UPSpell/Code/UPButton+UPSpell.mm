//
//  UPButton+UPSpell.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPButton+UPSpell.h"
#import "UPSpellLayoutManager.h"

static UIBezierPath *_RoundControlButtonBackgroundFillPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(84, 42)];
    [path addCurveToPoint: CGPointMake(42, 84) controlPoint1: CGPointMake(84, 65.2) controlPoint2: CGPointMake(65.2, 84)];
    [path addCurveToPoint: CGPointMake(0, 42) controlPoint1: CGPointMake(18.8, 84) controlPoint2: CGPointMake(0, 65.2)];
    [path addCurveToPoint: CGPointMake(42, 0) controlPoint1: CGPointMake(0, 18.8) controlPoint2: CGPointMake(18.8, 0)];
    [path addCurveToPoint: CGPointMake(84, 42) controlPoint1: CGPointMake(65.2, 0) controlPoint2: CGPointMake(84, 18.8)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundControlButtonBackgroundStrokePath(void)
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(42, 0)];
    [path addCurveToPoint: CGPointMake(0, 42) controlPoint1: CGPointMake(18.8, 0) controlPoint2: CGPointMake(0, 18.8)];
    [path addCurveToPoint: CGPointMake(42, 84) controlPoint1: CGPointMake(0, 65.2) controlPoint2: CGPointMake(18.8, 84)];
    [path addCurveToPoint: CGPointMake(84, 42) controlPoint1: CGPointMake(65.2, 84) controlPoint2: CGPointMake(84, 65.2)];
    [path addCurveToPoint: CGPointMake(42, 0) controlPoint1: CGPointMake(84, 18.8) controlPoint2: CGPointMake(65.2, 0)];
    [path closePath];
    [path moveToPoint: CGPointMake(42, 3)];
    [path addCurveToPoint: CGPointMake(81, 42) controlPoint1: CGPointMake(63.5, 3) controlPoint2: CGPointMake(81, 20.5)];
    [path addCurveToPoint: CGPointMake(42, 81) controlPoint1: CGPointMake(81, 63.51) controlPoint2: CGPointMake(63.5, 81)];
    [path addCurveToPoint: CGPointMake(3, 42) controlPoint1: CGPointMake(20.5, 81) controlPoint2: CGPointMake(3, 63.51)];
    [path addCurveToPoint: CGPointMake(42, 3) controlPoint1: CGPointMake(3, 20.5) controlPoint2: CGPointMake(20.5, 3)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundControlButtonPauseFillPath(void)
{
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(14, 37.5, 56, 9) cornerRadius:4.5];
}

@implementation UPButton (UPSpell)

+ (UPButton *)roundControlButtonPause
{
    UPButton *button = [UPButton button];
    button.canonicalSize = UP::SpellLayoutManager::CanonicalRoundControlButtonSize;
    [button setFillPath:_RoundControlButtonBackgroundFillPath() forControlStates:UIControlStateNormal];
    [button setStrokePath:_RoundControlButtonBackgroundStrokePath() forControlStates:UIControlStateNormal];
    [button setContentPath:_RoundControlButtonPauseFillPath() forControlStates:UIControlStateNormal];
    return button;
}

@end
