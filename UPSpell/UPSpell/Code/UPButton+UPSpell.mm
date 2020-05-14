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

static UIBezierPath *_RoundControlButtonPauseFillPath(void)
{
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(14, 37.5, 56, 9) cornerRadius:4.5];
}

@implementation UPButton (UPSpell)

+ (UPButton *)roundControlButtonPause
{
    UPButton *button = [UPButton button];
    button.canonicalSize = UP::SpellLayoutManager::CanonicalRoundControlButtonSize;
    [button setBackgroundFillPath:_RoundControlButtonBackgroundFillPath() forControlStates:UIControlStateNormal];
    [button setFillPath:_RoundControlButtonPauseFillPath() forControlStates:UIControlStateNormal];
    return button;
}

@end
