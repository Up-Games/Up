//
//  UPControl+UPSpell.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>

#import "UPControl+UPSpell.h"
#import "UPSpellLayout.h"
#import "UPTextPaths.h"

static UIBezierPath *_RoundButtonFillPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(84, 42)];
    [path addCurveToPoint:CGPointMake(42, 84) controlPoint1:CGPointMake(84, 65.2) controlPoint2:CGPointMake(65.2, 84)];
    [path addCurveToPoint:CGPointMake(0, 42) controlPoint1:CGPointMake(18.8, 84) controlPoint2:CGPointMake(0, 65.2)];
    [path addCurveToPoint:CGPointMake(42, 0) controlPoint1:CGPointMake(0, 18.8) controlPoint2:CGPointMake(18.8, 0)];
    [path addCurveToPoint:CGPointMake(84, 42) controlPoint1:CGPointMake(65.2, 0) controlPoint2:CGPointMake(84, 18.8)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundButtonStrokePath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(42, 0)];
    [path addCurveToPoint:CGPointMake(0, 42) controlPoint1:CGPointMake(18.8, 0) controlPoint2:CGPointMake(0, 18.8)];
    [path addCurveToPoint:CGPointMake(42, 84) controlPoint1:CGPointMake(0, 65.2) controlPoint2:CGPointMake(18.8, 84)];
    [path addCurveToPoint:CGPointMake(84, 42) controlPoint1:CGPointMake(65.2, 84) controlPoint2:CGPointMake(84, 65.2)];
    [path addCurveToPoint:CGPointMake(42, 0) controlPoint1:CGPointMake(84, 18.8) controlPoint2:CGPointMake(65.2, 0)];
    [path closePath];
    [path moveToPoint:CGPointMake(42, 3)];
    [path addCurveToPoint:CGPointMake(81, 42) controlPoint1:CGPointMake(63.5, 3) controlPoint2:CGPointMake(81, 20.5)];
    [path addCurveToPoint:CGPointMake(42, 81) controlPoint1:CGPointMake(81, 63.51) controlPoint2:CGPointMake(63.5, 81)];
    [path addCurveToPoint:CGPointMake(3, 42) controlPoint1:CGPointMake(20.5, 81) controlPoint2:CGPointMake(3, 63.51)];
    [path addCurveToPoint:CGPointMake(42, 3) controlPoint1:CGPointMake(3, 20.5) controlPoint2:CGPointMake(20.5, 3)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundButtonMinusSignIconPath(void)
{
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(14, 37.5, 56, 9) cornerRadius:4.5];
}

static UIBezierPath *_RoundButtonTrashIconPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // can
    [path moveToPoint:CGPointMake(54.62, 62.27)];
    [path addLineToPoint:CGPointMake(54.61, 62.49)];
    [path addCurveToPoint:CGPointMake(51.49, 65.76) controlPoint1:CGPointMake(54.61, 64.29) controlPoint2:CGPointMake(53.21, 65.76)];
    [path addLineToPoint:CGPointMake(32.52, 65.76)];
    [path addCurveToPoint:CGPointMake(29.39, 62.49) controlPoint1:CGPointMake(30.79, 65.76) controlPoint2:CGPointMake(29.39, 64.29)];
    [path addLineToPoint:CGPointMake(29.4, 62.41)];
    [path addLineToPoint:CGPointMake(26.32, 25.81)];
    [path addLineToPoint:CGPointMake(57.68, 25.81)];
    [path addLineToPoint:CGPointMake(54.62, 62.27)];
    [path closePath];
    [path moveToPoint:CGPointMake(35.57, 20.75)];
    [path addCurveToPoint:CGPointMake(39.32, 16.83) controlPoint1:CGPointMake(35.58, 18.59) controlPoint2:CGPointMake(37.26, 16.83)];
    [path addLineToPoint:CGPointMake(44.68, 16.83)];
    [path addCurveToPoint:CGPointMake(48.43, 20.75) controlPoint1:CGPointMake(46.74, 16.83) controlPoint2:CGPointMake(48.42, 18.59)];
    [path addLineToPoint:CGPointMake(48.44, 21.23)];
    [path addLineToPoint:CGPointMake(35.56, 21.23)];
    [path addLineToPoint:CGPointMake(35.57, 20.75)];
    [path closePath];
    [path moveToPoint:CGPointMake(64.25, 21.23)];
    [path addLineToPoint:CGPointMake(64, 21.23)];
    [path addLineToPoint:CGPointMake(51.92, 21.23)];
    [path addLineToPoint:CGPointMake(51.92, 20.75)];
    [path addCurveToPoint:CGPointMake(44.68, 13.18) controlPoint1:CGPointMake(51.91, 16.58) controlPoint2:CGPointMake(48.66, 13.18)];
    [path addLineToPoint:CGPointMake(39.32, 13.18)];
    [path addCurveToPoint:CGPointMake(32.08, 20.75) controlPoint1:CGPointMake(35.34, 13.18) controlPoint2:CGPointMake(32.1, 16.58)];
    [path addLineToPoint:CGPointMake(32.08, 21.23)];
    [path addLineToPoint:CGPointMake(20, 21.23)];
    [path addLineToPoint:CGPointMake(19.75, 21.23)];
    [path addCurveToPoint:CGPointMake(17.5, 23.52) controlPoint1:CGPointMake(18.51, 21.23) controlPoint2:CGPointMake(17.5, 22.26)];
    [path addCurveToPoint:CGPointMake(19.75, 25.81) controlPoint1:CGPointMake(17.5, 24.79) controlPoint2:CGPointMake(18.51, 25.81)];
    [path addLineToPoint:CGPointMake(20, 25.81)];
    [path addLineToPoint:CGPointMake(22.08, 25.81)];
    [path addLineToPoint:CGPointMake(25.17, 62.61)];
    [path addCurveToPoint:CGPointMake(32.52, 70.18) controlPoint1:CGPointMake(25.23, 66.78) controlPoint2:CGPointMake(28.53, 70.18)];
    [path addLineToPoint:CGPointMake(51.49, 70.18)];
    [path addCurveToPoint:CGPointMake(58.83, 62.57) controlPoint1:CGPointMake(55.47, 70.18) controlPoint2:CGPointMake(58.77, 66.78)];
    [path addLineToPoint:CGPointMake(61.92, 25.81)];
    [path addLineToPoint:CGPointMake(64, 25.81)];
    [path addLineToPoint:CGPointMake(64.25, 25.81)];
    [path addCurveToPoint:CGPointMake(66.5, 23.52) controlPoint1:CGPointMake(65.49, 25.81) controlPoint2:CGPointMake(66.5, 24.79)];
    [path addCurveToPoint:CGPointMake(64.25, 21.23) controlPoint1:CGPointMake(66.5, 22.26) controlPoint2:CGPointMake(65.49, 21.23)];
    [path closePath];

    // left line
    [path moveToPoint:CGPointMake(35.01, 60.91)];
    [path addCurveToPoint:CGPointMake(33.51, 59.47) controlPoint1:CGPointMake(34.21, 60.91) controlPoint2:CGPointMake(33.54, 60.28)];
    [path addLineToPoint:CGPointMake(33.5, 59.27)];
    [path addLineToPoint:CGPointMake(32.11, 31.49)];
    [path addCurveToPoint:CGPointMake(33.54, 29.91) controlPoint1:CGPointMake(32.07, 30.66) controlPoint2:CGPointMake(32.71, 29.95)];
    [path addCurveToPoint:CGPointMake(35.11, 31.34) controlPoint1:CGPointMake(34.35, 29.86) controlPoint2:CGPointMake(35.07, 30.51)];
    [path addLineToPoint:CGPointMake(36.51, 59.35)];
    [path addCurveToPoint:CGPointMake(35.07, 60.91) controlPoint1:CGPointMake(36.54, 60.18) controlPoint2:CGPointMake(35.9, 60.88)];
    [path addCurveToPoint:CGPointMake(35.01, 60.91) controlPoint1:CGPointMake(35.05, 60.91) controlPoint2:CGPointMake(35.03, 60.91)];
    [path closePath];

    // center line
    [path moveToPoint:CGPointMake(42, 60.91)];
    [path addCurveToPoint:CGPointMake(40.5, 59.41) controlPoint1:CGPointMake(41.17, 60.91) controlPoint2:CGPointMake(40.5, 60.24)];
    [path addLineToPoint:CGPointMake(40.5, 31.41)];
    [path addCurveToPoint:CGPointMake(42, 29.91) controlPoint1:CGPointMake(40.5, 30.58) controlPoint2:CGPointMake(41.17, 29.91)];
    [path addCurveToPoint:CGPointMake(43.5, 31.41) controlPoint1:CGPointMake(42.83, 29.91) controlPoint2:CGPointMake(43.5, 30.58)];
    [path addLineToPoint:CGPointMake(43.5, 59.41)];
    [path addCurveToPoint:CGPointMake(42, 60.91) controlPoint1:CGPointMake(43.5, 60.24) controlPoint2:CGPointMake(42.83, 60.91)];
    [path closePath];

    // right line
    [path moveToPoint:CGPointMake(49, 60.91)];
    [path addCurveToPoint:CGPointMake(48.94, 60.91) controlPoint1:CGPointMake(48.98, 60.91) controlPoint2:CGPointMake(48.96, 60.91)];
    [path addCurveToPoint:CGPointMake(47.5, 59.35) controlPoint1:CGPointMake(48.11, 60.88) controlPoint2:CGPointMake(47.47, 60.18)];
    [path addLineToPoint:CGPointMake(47.51, 59.14)];
    [path addLineToPoint:CGPointMake(48.9, 31.34)];
    [path addCurveToPoint:CGPointMake(50.47, 29.91) controlPoint1:CGPointMake(48.94, 30.51) controlPoint2:CGPointMake(49.65, 29.86)];
    [path addCurveToPoint:CGPointMake(51.9, 31.49) controlPoint1:CGPointMake(51.3, 29.95) controlPoint2:CGPointMake(51.94, 30.66)];
    [path addLineToPoint:CGPointMake(50.5, 59.47)];
    [path addCurveToPoint:CGPointMake(49, 60.91) controlPoint1:CGPointMake(50.46, 60.28) controlPoint2:CGPointMake(49.8, 60.91)];
    [path closePath];

    return path;
}

static UIBezierPath *_RoundButtonDownArrowIconPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(63.76, 39.33)];
    [path addCurveToPoint:CGPointMake(58.83, 39.74) controlPoint1:CGPointMake(62.29, 38.08) controlPoint2:CGPointMake(60.08, 38.26)];
    [path addLineToPoint:CGPointMake(45.5, 55.46)];
    [path addLineToPoint:CGPointMake(45.5, 20.5)];
    [path addCurveToPoint:CGPointMake(42, 17) controlPoint1:CGPointMake(45.5, 18.57) controlPoint2:CGPointMake(43.93, 17)];
    [path addCurveToPoint:CGPointMake(38.5, 20.5) controlPoint1:CGPointMake(40.07, 17) controlPoint2:CGPointMake(38.5, 18.57)];
    [path addLineToPoint:CGPointMake(38.5, 55.46)];
    [path addLineToPoint:CGPointMake(25.17, 39.74)];
    [path addCurveToPoint:CGPointMake(20.24, 39.33) controlPoint1:CGPointMake(23.92, 38.26) controlPoint2:CGPointMake(21.71, 38.08)];
    [path addCurveToPoint:CGPointMake(19.83, 44.26) controlPoint1:CGPointMake(18.76, 40.58) controlPoint2:CGPointMake(18.58, 42.79)];
    [path addLineToPoint:CGPointMake(39.33, 67.26)];
    [path addCurveToPoint:CGPointMake(42, 68.5) controlPoint1:CGPointMake(40, 68.05) controlPoint2:CGPointMake(40.97, 68.5)];
    [path addCurveToPoint:CGPointMake(44.67, 67.26) controlPoint1:CGPointMake(43.03, 68.5) controlPoint2:CGPointMake(44.01, 68.05)];
    [path addLineToPoint:CGPointMake(64.17, 44.26)];
    [path addCurveToPoint:CGPointMake(63.76, 39.33) controlPoint1:CGPointMake(65.42, 42.79) controlPoint2:CGPointMake(65.24, 40.58)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundButtonLeftArrowIconPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(44.67, 63.76)];
    [path addCurveToPoint:CGPointMake(44.26, 58.83) controlPoint1:CGPointMake(45.92, 62.29) controlPoint2:CGPointMake(45.74, 60.08)];
    [path addLineToPoint:CGPointMake(28.54, 45.5)];
    [path addLineToPoint:CGPointMake(63.5, 45.5)];
    [path addCurveToPoint:CGPointMake(67, 42) controlPoint1:CGPointMake(65.43, 45.5) controlPoint2:CGPointMake(67, 43.93)];
    [path addCurveToPoint:CGPointMake(63.5, 38.5) controlPoint1:CGPointMake(67, 40.07) controlPoint2:CGPointMake(65.43, 38.5)];
    [path addLineToPoint:CGPointMake(28.54, 38.5)];
    [path addLineToPoint:CGPointMake(44.26, 25.17)];
    [path addCurveToPoint:CGPointMake(44.67, 20.24) controlPoint1:CGPointMake(45.74, 23.92) controlPoint2:CGPointMake(45.92, 21.71)];
    [path addCurveToPoint:CGPointMake(39.74, 19.83) controlPoint1:CGPointMake(43.42, 18.76) controlPoint2:CGPointMake(41.21, 18.58)];
    [path addLineToPoint:CGPointMake(16.74, 39.33)];
    [path addCurveToPoint:CGPointMake(15.5, 42) controlPoint1:CGPointMake(15.95, 40) controlPoint2:CGPointMake(15.5, 40.97)];
    [path addCurveToPoint:CGPointMake(16.74, 44.67) controlPoint1:CGPointMake(15.5, 43.03) controlPoint2:CGPointMake(15.95, 44.01)];
    [path addLineToPoint:CGPointMake(39.74, 64.17)];
    [path addCurveToPoint:CGPointMake(44.67, 63.76) controlPoint1:CGPointMake(41.21, 65.42) controlPoint2:CGPointMake(43.42, 65.24)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundButtonRightArrowIconPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(39.33, 20.24)];
    [path addCurveToPoint:CGPointMake(39.74, 25.17) controlPoint1:CGPointMake(38.08, 21.71) controlPoint2:CGPointMake(38.26, 23.92)];
    [path addLineToPoint:CGPointMake(55.46, 38.5)];
    [path addLineToPoint:CGPointMake(20.5, 38.5)];
    [path addCurveToPoint:CGPointMake(17, 42) controlPoint1:CGPointMake(18.57, 38.5) controlPoint2:CGPointMake(17, 40.07)];
    [path addCurveToPoint:CGPointMake(20.5, 45.5) controlPoint1:CGPointMake(17, 43.93) controlPoint2:CGPointMake(18.57, 45.5)];
    [path addLineToPoint:CGPointMake(55.46, 45.5)];
    [path addLineToPoint:CGPointMake(39.74, 58.83)];
    [path addCurveToPoint:CGPointMake(39.33, 63.76) controlPoint1:CGPointMake(38.26, 60.08) controlPoint2:CGPointMake(38.08, 62.29)];
    [path addCurveToPoint:CGPointMake(44.26, 64.17) controlPoint1:CGPointMake(40.58, 65.24) controlPoint2:CGPointMake(42.79, 65.42)];
    [path addLineToPoint:CGPointMake(67.26, 44.67)];
    [path addCurveToPoint:CGPointMake(68.5, 42) controlPoint1:CGPointMake(68.05, 44) controlPoint2:CGPointMake(68.5, 43.03)];
    [path addCurveToPoint:CGPointMake(67.26, 39.33) controlPoint1:CGPointMake(68.5, 40.97) controlPoint2:CGPointMake(68.05, 39.99)];
    [path addLineToPoint:CGPointMake(44.26, 19.83)];
    [path addCurveToPoint:CGPointMake(39.33, 20.24) controlPoint1:CGPointMake(42.79, 18.58) controlPoint2:CGPointMake(40.58, 18.76)];
    [path closePath];
    return path;
}

static UIBezierPath *_WordTrayFillPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(481.88, 177)];
    [path addCurveToPoint:CGPointMake(437.5, 176.99) controlPoint1:CGPointMake(466.87, 177) controlPoint2:CGPointMake(452.04, 177)];
    [path addCurveToPoint:CGPointMake(393.12, 177) controlPoint1:CGPointMake(422.96, 177) controlPoint2:CGPointMake(408.13, 177)];
    [path addCurveToPoint:CGPointMake(217.01, 176.81) controlPoint1:CGPointMake(327.82, 177) controlPoint2:CGPointMake(268.57, 176.93)];
    [path addCurveToPoint:CGPointMake(180.71, 176.68) controlPoint1:CGPointMake(204.92, 176.72) controlPoint2:CGPointMake(192.61, 176.7)];
    [path addCurveToPoint:CGPointMake(31.49, 172.38) controlPoint1:CGPointMake(131.72, 176.58) controlPoint2:CGPointMake(81.07, 176.48)];
    [path addCurveToPoint:CGPointMake(14.65, 169.59) controlPoint1:CGPointMake(25.95, 171.9) controlPoint2:CGPointMake(20.2, 170.73)];
    [path addCurveToPoint:CGPointMake(9.14, 167.44) controlPoint1:CGPointMake(12.9, 169.23) controlPoint2:CGPointMake(11.08, 168.36)];
    [path addLineToPoint:CGPointMake(8.63, 167.2)];
    [path addCurveToPoint:CGPointMake(5.32, 160.23) controlPoint1:CGPointMake(7.72, 166.77) controlPoint2:CGPointMake(5.62, 165.78)];
    [path addCurveToPoint:CGPointMake(5.23, 152.64) controlPoint1:CGPointMake(5.29, 157.7) controlPoint2:CGPointMake(5.26, 155.17)];
    [path addLineToPoint:CGPointMake(5.16, 146.73)];
    [path addLineToPoint:CGPointMake(5.1, 146.75)];
    [path addCurveToPoint:CGPointMake(5.11, 139.84) controlPoint1:CGPointMake(5.1, 144.44) controlPoint2:CGPointMake(5.11, 142.14)];
    [path addCurveToPoint:CGPointMake(5.11, 42.2) controlPoint1:CGPointMake(4.96, 120.19) controlPoint2:CGPointMake(4.96, 61.81)];
    [path addCurveToPoint:CGPointMake(5.1, 35.27) controlPoint1:CGPointMake(5.11, 39.88) controlPoint2:CGPointMake(5.1, 37.57)];
    [path addLineToPoint:CGPointMake(5.16, 35.28)];
    [path addLineToPoint:CGPointMake(5.23, 29.36)];
    [path addCurveToPoint:CGPointMake(5.32, 21.77) controlPoint1:CGPointMake(5.26, 26.83) controlPoint2:CGPointMake(5.29, 24.3)];
    [path addCurveToPoint:CGPointMake(8.63, 14.8) controlPoint1:CGPointMake(5.61, 16.22) controlPoint2:CGPointMake(7.72, 15.23)];
    [path addLineToPoint:CGPointMake(9.14, 14.55)];
    [path addCurveToPoint:CGPointMake(14.55, 12.43) controlPoint1:CGPointMake(11.08, 13.64) controlPoint2:CGPointMake(12.9, 12.77)];
    [path addCurveToPoint:CGPointMake(31.51, 9.62) controlPoint1:CGPointMake(20.2, 11.28) controlPoint2:CGPointMake(25.95, 10.1)];
    [path addCurveToPoint:CGPointMake(180.7, 5.32) controlPoint1:CGPointMake(81.07, 5.52) controlPoint2:CGPointMake(131.72, 5.42)];
    [path addCurveToPoint:CGPointMake(217.03, 5.19) controlPoint1:CGPointMake(192.61, 5.3) controlPoint2:CGPointMake(204.92, 5.28)];
    [path addCurveToPoint:CGPointMake(392.54, 5) controlPoint1:CGPointMake(268.56, 5.06) controlPoint2:CGPointMake(327.62, 5)];
    [path addCurveToPoint:CGPointMake(437.5, 5.01) controlPoint1:CGPointMake(407.75, 5) controlPoint2:CGPointMake(422.78, 5)];
    [path addCurveToPoint:CGPointMake(482.46, 5) controlPoint1:CGPointMake(452.23, 5) controlPoint2:CGPointMake(467.25, 5)];
    [path addCurveToPoint:CGPointMake(657.99, 5.19) controlPoint1:CGPointMake(547.38, 5) controlPoint2:CGPointMake(606.44, 5.06)];
    [path addCurveToPoint:CGPointMake(694.3, 5.32) controlPoint1:CGPointMake(670.08, 5.28) controlPoint2:CGPointMake(682.39, 5.3)];
    [path addCurveToPoint:CGPointMake(843.51, 9.62) controlPoint1:CGPointMake(743.28, 5.42) controlPoint2:CGPointMake(793.93, 5.52)];
    [path addCurveToPoint:CGPointMake(860.36, 12.41) controlPoint1:CGPointMake(849.05, 10.1) controlPoint2:CGPointMake(854.8, 11.28)];
    [path addCurveToPoint:CGPointMake(865.85, 14.55) controlPoint1:CGPointMake(862.09, 12.77) controlPoint2:CGPointMake(863.92, 13.64)];
    [path addLineToPoint:CGPointMake(866.37, 14.8)];
    [path addCurveToPoint:CGPointMake(869.68, 21.77) controlPoint1:CGPointMake(867.28, 15.23) controlPoint2:CGPointMake(869.39, 16.22)];
    [path addCurveToPoint:CGPointMake(869.77, 29.35) controlPoint1:CGPointMake(869.71, 24.3) controlPoint2:CGPointMake(869.74, 26.83)];
    [path addLineToPoint:CGPointMake(869.83, 35.28)];
    [path addLineToPoint:CGPointMake(869.9, 35.27)];
    [path addCurveToPoint:CGPointMake(869.89, 42.16) controlPoint1:CGPointMake(869.9, 37.56) controlPoint2:CGPointMake(869.89, 39.86)];
    [path addCurveToPoint:CGPointMake(869.89, 139.79) controlPoint1:CGPointMake(870.04, 61.81) controlPoint2:CGPointMake(870.04, 120.19)];
    [path addCurveToPoint:CGPointMake(869.9, 146.75) controlPoint1:CGPointMake(869.89, 142.12) controlPoint2:CGPointMake(869.9, 144.44)];
    [path addLineToPoint:CGPointMake(869.83, 146.74)];
    [path addLineToPoint:CGPointMake(869.77, 152.65)];
    [path addCurveToPoint:CGPointMake(869.68, 160.23) controlPoint1:CGPointMake(869.74, 155.18) controlPoint2:CGPointMake(869.71, 157.7)];
    [path addCurveToPoint:CGPointMake(866.37, 167.2) controlPoint1:CGPointMake(869.38, 165.78) controlPoint2:CGPointMake(867.28, 166.77)];
    [path addLineToPoint:CGPointMake(865.85, 167.45)];
    [path addCurveToPoint:CGPointMake(860.45, 169.57) controlPoint1:CGPointMake(863.92, 168.36) controlPoint2:CGPointMake(862.1, 169.23)];
    [path addLineToPoint:CGPointMake(860.35, 169.59)];
    [path addCurveToPoint:CGPointMake(843.49, 172.38) controlPoint1:CGPointMake(854.79, 170.73) controlPoint2:CGPointMake(849.05, 171.9)];
    [path addCurveToPoint:CGPointMake(694.29, 176.68) controlPoint1:CGPointMake(793.93, 176.48) controlPoint2:CGPointMake(743.28, 176.58)];
    [path addCurveToPoint:CGPointMake(657.97, 176.81) controlPoint1:CGPointMake(682.39, 176.7) controlPoint2:CGPointMake(670.08, 176.72)];
    [path addCurveToPoint:CGPointMake(481.88, 177) controlPoint1:CGPointMake(606.43, 176.93) controlPoint2:CGPointMake(547.18, 177)];
    [path closePath];
    return path;
}

static UIBezierPath *_WordTrayStrokePath(void)
{
   UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(482.26, 0)];
    [path addCurveToPoint:CGPointMake(437.5, 0.01) controlPoint1:CGPointMake(467.11, 0) controlPoint2:CGPointMake(452.16, 0)];
    [path addCurveToPoint:CGPointMake(392.74, 0) controlPoint1:CGPointMake(422.84, 0) controlPoint2:CGPointMake(407.88, 0)];
    [path addCurveToPoint:CGPointMake(217, 0.19) controlPoint1:CGPointMake(334.39, 0) controlPoint2:CGPointMake(273.4, 0.05)];
    [path addCurveToPoint:CGPointMake(31.08, 4.64) controlPoint1:CGPointMake(155.02, 0.61) controlPoint2:CGPointMake(92.93, -0.48)];
    [path addCurveToPoint:CGPointMake(13.55, 7.53) controlPoint1:CGPointMake(25.2, 5.14) controlPoint2:CGPointMake(19.36, 6.34)];
    [path addCurveToPoint:CGPointMake(6.49, 10.28) controlPoint1:CGPointMake(11.13, 8.03) controlPoint2:CGPointMake(8.79, 9.19)];
    [path addCurveToPoint:CGPointMake(0.33, 21.61) controlPoint1:CGPointMake(2.13, 12.34) controlPoint2:CGPointMake(0.57, 16.58)];
    [path addCurveToPoint:CGPointMake(0.23, 29.3) controlPoint1:CGPointMake(0.29, 24.17) controlPoint2:CGPointMake(0.26, 26.74)];
    [path addLineToPoint:CGPointMake(0.08, 29.27)];
    [path addCurveToPoint:CGPointMake(0.11, 42.16) controlPoint1:CGPointMake(0.1, 33.57) controlPoint2:CGPointMake(0.11, 37.87)];
    [path addCurveToPoint:CGPointMake(0.11, 139.84) controlPoint1:CGPointMake(-0.04, 61.71) controlPoint2:CGPointMake(-0.04, 120.29)];
    [path addCurveToPoint:CGPointMake(0.08, 152.73) controlPoint1:CGPointMake(0.11, 144.13) controlPoint2:CGPointMake(0.1, 148.43)];
    [path addLineToPoint:CGPointMake(0.23, 152.7)];
    [path addCurveToPoint:CGPointMake(0.33, 160.39) controlPoint1:CGPointMake(0.26, 155.27) controlPoint2:CGPointMake(0.29, 157.83)];
    [path addCurveToPoint:CGPointMake(6.49, 171.72) controlPoint1:CGPointMake(0.57, 165.42) controlPoint2:CGPointMake(2.13, 169.66)];
    [path addCurveToPoint:CGPointMake(13.55, 174.47) controlPoint1:CGPointMake(8.79, 172.81) controlPoint2:CGPointMake(11.13, 173.97)];
    [path addCurveToPoint:CGPointMake(31.08, 177.36) controlPoint1:CGPointMake(19.36, 175.66) controlPoint2:CGPointMake(25.2, 176.86)];
    [path addCurveToPoint:CGPointMake(217, 181.81) controlPoint1:CGPointMake(92.93, 182.48) controlPoint2:CGPointMake(155.02, 181.39)];
    [path addCurveToPoint:CGPointMake(392.64, 182) controlPoint1:CGPointMake(273.36, 181.95) controlPoint2:CGPointMake(334.32, 182)];
    [path addCurveToPoint:CGPointMake(437.5, 181.99) controlPoint1:CGPointMake(407.82, 182) controlPoint2:CGPointMake(422.81, 182)];
    [path addCurveToPoint:CGPointMake(482.36, 182) controlPoint1:CGPointMake(452.19, 182) controlPoint2:CGPointMake(467.19, 182)];
    [path addCurveToPoint:CGPointMake(658, 181.81) controlPoint1:CGPointMake(540.68, 182) controlPoint2:CGPointMake(601.63, 181.95)];
    [path addCurveToPoint:CGPointMake(843.92, 177.36) controlPoint1:CGPointMake(719.98, 181.39) controlPoint2:CGPointMake(782.07, 182.48)];
    [path addCurveToPoint:CGPointMake(861.45, 174.47) controlPoint1:CGPointMake(849.8, 176.86) controlPoint2:CGPointMake(855.64, 175.66)];
    [path addCurveToPoint:CGPointMake(868.51, 171.72) controlPoint1:CGPointMake(863.87, 173.97) controlPoint2:CGPointMake(866.21, 172.81)];
    [path addCurveToPoint:CGPointMake(874.67, 160.39) controlPoint1:CGPointMake(872.87, 169.66) controlPoint2:CGPointMake(874.43, 165.42)];
    [path addCurveToPoint:CGPointMake(874.77, 152.7) controlPoint1:CGPointMake(874.71, 157.83) controlPoint2:CGPointMake(874.74, 155.27)];
    [path addLineToPoint:CGPointMake(874.92, 152.73)];
    [path addCurveToPoint:CGPointMake(874.89, 139.83) controlPoint1:CGPointMake(874.9, 148.43) controlPoint2:CGPointMake(874.89, 144.13)];
    [path addCurveToPoint:CGPointMake(874.89, 42.17) controlPoint1:CGPointMake(875.04, 120.28) controlPoint2:CGPointMake(875.04, 61.72)];
    [path addCurveToPoint:CGPointMake(874.92, 29.27) controlPoint1:CGPointMake(874.89, 37.87) controlPoint2:CGPointMake(874.9, 33.57)];
    [path addLineToPoint:CGPointMake(874.77, 29.3)];
    [path addCurveToPoint:CGPointMake(874.67, 21.61) controlPoint1:CGPointMake(874.74, 26.74) controlPoint2:CGPointMake(874.71, 24.17)];
    [path addCurveToPoint:CGPointMake(868.51, 10.28) controlPoint1:CGPointMake(874.43, 16.58) controlPoint2:CGPointMake(872.87, 12.34)];
    [path addCurveToPoint:CGPointMake(861.45, 7.53) controlPoint1:CGPointMake(866.21, 9.19) controlPoint2:CGPointMake(863.87, 8.03)];
    [path addCurveToPoint:CGPointMake(843.92, 4.64) controlPoint1:CGPointMake(855.64, 6.34) controlPoint2:CGPointMake(849.8, 5.14)];
    [path addCurveToPoint:CGPointMake(658, 0.19) controlPoint1:CGPointMake(782.07, -0.48) controlPoint2:CGPointMake(719.98, 0.61)];
    [path addCurveToPoint:CGPointMake(482.26, 0) controlPoint1:CGPointMake(601.61, 0.05) controlPoint2:CGPointMake(540.61, 0)];
    [path closePath];
    [path moveToPoint:CGPointMake(482.26, 10)];
    [path addCurveToPoint:CGPointMake(657.94, 10.19) controlPoint1:CGPointMake(547.27, 10) controlPoint2:CGPointMake(606.39, 10.06)];
    [path addCurveToPoint:CGPointMake(694.29, 10.32) controlPoint1:CGPointMake(670.06, 10.28) controlPoint2:CGPointMake(682.38, 10.3)];
    [path addCurveToPoint:CGPointMake(843.07, 14.6) controlPoint1:CGPointMake(743.17, 10.42) controlPoint2:CGPointMake(793.72, 10.52)];
    [path addCurveToPoint:CGPointMake(859.36, 17.31) controlPoint1:CGPointMake(848.33, 15.05) controlPoint2:CGPointMake(853.69, 16.15)];
    [path addLineToPoint:CGPointMake(859.44, 17.33)];
    [path addCurveToPoint:CGPointMake(863.71, 19.07) controlPoint1:CGPointMake(860.5, 17.55) controlPoint2:CGPointMake(862.13, 18.32)];
    [path addLineToPoint:CGPointMake(864.19, 19.3)];
    [path addCurveToPoint:CGPointMake(864.68, 21.94) controlPoint1:CGPointMake(864.3, 19.53) controlPoint2:CGPointMake(864.58, 20.28)];
    [path addCurveToPoint:CGPointMake(864.77, 29.41) controlPoint1:CGPointMake(864.71, 24.43) controlPoint2:CGPointMake(864.74, 26.92)];
    [path addLineToPoint:CGPointMake(864.89, 40.21)];
    [path addCurveToPoint:CGPointMake(864.89, 42.16) controlPoint1:CGPointMake(864.89, 40.86) controlPoint2:CGPointMake(864.89, 41.51)];
    [path addLineToPoint:CGPointMake(864.89, 42.2)];
    [path addLineToPoint:CGPointMake(864.89, 42.24)];
    [path addCurveToPoint:CGPointMake(864.89, 139.76) controlPoint1:CGPointMake(865.04, 61.84) controlPoint2:CGPointMake(865.04, 120.16)];
    [path addLineToPoint:CGPointMake(864.89, 139.8)];
    [path addLineToPoint:CGPointMake(864.89, 139.84)];
    [path addCurveToPoint:CGPointMake(864.89, 141.79) controlPoint1:CGPointMake(864.89, 140.49) controlPoint2:CGPointMake(864.89, 141.14)];
    [path addLineToPoint:CGPointMake(864.77, 152.59)];
    [path addCurveToPoint:CGPointMake(864.68, 160.06) controlPoint1:CGPointMake(864.74, 155.08) controlPoint2:CGPointMake(864.71, 157.57)];
    [path addCurveToPoint:CGPointMake(864.19, 162.7) controlPoint1:CGPointMake(864.58, 161.72) controlPoint2:CGPointMake(864.3, 162.46)];
    [path addLineToPoint:CGPointMake(863.71, 162.93)];
    [path addCurveToPoint:CGPointMake(859.44, 164.67) controlPoint1:CGPointMake(862.13, 163.68) controlPoint2:CGPointMake(860.5, 164.45)];
    [path addLineToPoint:CGPointMake(859.36, 164.69)];
    [path addCurveToPoint:CGPointMake(843.1, 167.4) controlPoint1:CGPointMake(853.69, 165.85) controlPoint2:CGPointMake(848.33, 166.94)];
    [path addCurveToPoint:CGPointMake(694.29, 171.68) controlPoint1:CGPointMake(793.72, 171.48) controlPoint2:CGPointMake(743.17, 171.58)];
    [path addCurveToPoint:CGPointMake(657.98, 171.81) controlPoint1:CGPointMake(682.38, 171.7) controlPoint2:CGPointMake(670.06, 171.72)];
    [path addCurveToPoint:CGPointMake(482.36, 172) controlPoint1:CGPointMake(606.38, 171.94) controlPoint2:CGPointMake(547.29, 172)];
    [path addCurveToPoint:CGPointMake(437.5, 171.99) controlPoint1:CGPointMake(467.19, 172) controlPoint2:CGPointMake(452.19, 172)];
    [path addCurveToPoint:CGPointMake(392.64, 172) controlPoint1:CGPointMake(422.8, 172) controlPoint2:CGPointMake(407.81, 172)];
    [path addCurveToPoint:CGPointMake(217.06, 171.81) controlPoint1:CGPointMake(327.71, 172) controlPoint2:CGPointMake(268.62, 171.94)];
    [path addCurveToPoint:CGPointMake(180.71, 171.68) controlPoint1:CGPointMake(204.94, 171.72) controlPoint2:CGPointMake(192.62, 171.7)];
    [path addCurveToPoint:CGPointMake(31.93, 167.4) controlPoint1:CGPointMake(131.83, 171.58) controlPoint2:CGPointMake(81.28, 171.48)];
    [path addCurveToPoint:CGPointMake(15.64, 164.69) controlPoint1:CGPointMake(26.67, 166.94) controlPoint2:CGPointMake(21.31, 165.85)];
    [path addLineToPoint:CGPointMake(15.55, 164.67)];
    [path addCurveToPoint:CGPointMake(11.29, 162.93) controlPoint1:CGPointMake(14.5, 164.45) controlPoint2:CGPointMake(12.87, 163.68)];
    [path addLineToPoint:CGPointMake(10.81, 162.7)];
    [path addCurveToPoint:CGPointMake(10.32, 160.06) controlPoint1:CGPointMake(10.7, 162.47) controlPoint2:CGPointMake(10.42, 161.72)];
    [path addCurveToPoint:CGPointMake(10.23, 152.59) controlPoint1:CGPointMake(10.29, 157.57) controlPoint2:CGPointMake(10.26, 155.08)];
    [path addLineToPoint:CGPointMake(10.11, 141.78)];
    [path addCurveToPoint:CGPointMake(10.11, 139.85) controlPoint1:CGPointMake(10.11, 141.14) controlPoint2:CGPointMake(10.11, 140.49)];
    [path addLineToPoint:CGPointMake(10.11, 139.8)];
    [path addLineToPoint:CGPointMake(10.11, 139.76)];
    [path addCurveToPoint:CGPointMake(10.11, 42.24) controlPoint1:CGPointMake(9.96, 120.17) controlPoint2:CGPointMake(9.96, 61.84)];
    [path addLineToPoint:CGPointMake(10.11, 42.2)];
    [path addLineToPoint:CGPointMake(10.11, 42.16)];
    [path addCurveToPoint:CGPointMake(10.11, 40.22) controlPoint1:CGPointMake(10.11, 41.51) controlPoint2:CGPointMake(10.11, 40.86)];
    [path addLineToPoint:CGPointMake(10.23, 29.41)];
    [path addCurveToPoint:CGPointMake(10.32, 21.94) controlPoint1:CGPointMake(10.26, 26.92) controlPoint2:CGPointMake(10.29, 24.43)];
    [path addCurveToPoint:CGPointMake(10.81, 19.3) controlPoint1:CGPointMake(10.42, 20.28) controlPoint2:CGPointMake(10.7, 19.54)];
    [path addLineToPoint:CGPointMake(11.29, 19.07)];
    [path addCurveToPoint:CGPointMake(15.55, 17.33) controlPoint1:CGPointMake(12.87, 18.32) controlPoint2:CGPointMake(14.5, 17.55)];
    [path addLineToPoint:CGPointMake(15.64, 17.31)];
    [path addCurveToPoint:CGPointMake(31.9, 14.6) controlPoint1:CGPointMake(21.31, 16.15) controlPoint2:CGPointMake(26.67, 15.05)];
    [path addCurveToPoint:CGPointMake(180.71, 10.32) controlPoint1:CGPointMake(81.28, 10.52) controlPoint2:CGPointMake(131.83, 10.42)];
    [path addCurveToPoint:CGPointMake(217.02, 10.19) controlPoint1:CGPointMake(192.62, 10.3) controlPoint2:CGPointMake(204.94, 10.28)];
    [path addCurveToPoint:CGPointMake(392.74, 10) controlPoint1:CGPointMake(268.62, 10.06) controlPoint2:CGPointMake(327.74, 10)];
    [path addCurveToPoint:CGPointMake(437.5, 10.01) controlPoint1:CGPointMake(407.88, 10) controlPoint2:CGPointMake(422.84, 10)];
    [path addCurveToPoint:CGPointMake(482.26, 10) controlPoint1:CGPointMake(452.16, 10) controlPoint2:CGPointMake(467.11, 10)];
    [path closePath];
    return path;
}

static UIBezierPath *_TextButtonFillPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(186.15, 6.99)];
    [path addCurveToPoint:CGPointMake(165.38, 0.89) controlPoint1:CGPointMake(182.43, 1.96) controlPoint2:CGPointMake(171.16, 1.42)];
    [path addCurveToPoint:CGPointMake(114.84, 0) controlPoint1:CGPointMake(148.55, -0.21) controlPoint2:CGPointMake(131.69, 0.09)];
    [path addCurveToPoint:CGPointMake(73.16, 0) controlPoint1:CGPointMake(100.95, 0.01) controlPoint2:CGPointMake(87.05, 0.01)];
    [path addCurveToPoint:CGPointMake(22.63, 0.89) controlPoint1:CGPointMake(56.31, 0.09) controlPoint2:CGPointMake(39.45, -0.21)];
    [path addCurveToPoint:CGPointMake(1.84, 6.99) controlPoint1:CGPointMake(16.76, 1.43) controlPoint2:CGPointMake(5.59, 1.96)];
    [path addCurveToPoint:CGPointMake(0.01, 15.53) controlPoint1:CGPointMake(0.08, 9.42) controlPoint2:CGPointMake(0.14, 12.61)];
    [path addCurveToPoint:CGPointMake(0.01, 59.47) controlPoint1:CGPointMake(-0, 31.65) controlPoint2:CGPointMake(-0, 43.35)];
    [path addCurveToPoint:CGPointMake(1.84, 68.01) controlPoint1:CGPointMake(0.13, 62.39) controlPoint2:CGPointMake(0.08, 65.58)];
    [path addCurveToPoint:CGPointMake(22.62, 74.11) controlPoint1:CGPointMake(5.57, 73.05) controlPoint2:CGPointMake(16.84, 73.58)];
    [path addCurveToPoint:CGPointMake(69.03, 74.99) controlPoint1:CGPointMake(38.07, 75.13) controlPoint2:CGPointMake(53.56, 74.93)];
    [path addCurveToPoint:CGPointMake(118.97, 74.99) controlPoint1:CGPointMake(85.68, 75) controlPoint2:CGPointMake(102.32, 75)];
    [path addCurveToPoint:CGPointMake(153.71, 74.68) controlPoint1:CGPointMake(130.55, 74.99) controlPoint2:CGPointMake(142.13, 74.98)];
    [path addCurveToPoint:CGPointMake(176.42, 72.73) controlPoint1:CGPointMake(161.3, 74.39) controlPoint2:CGPointMake(168.94, 74.21)];
    [path addCurveToPoint:CGPointMake(186.15, 68.01) controlPoint1:CGPointMake(179.91, 71.96) controlPoint2:CGPointMake(183.8, 71.08)];
    [path addCurveToPoint:CGPointMake(187.99, 59.47) controlPoint1:CGPointMake(187.92, 65.58) controlPoint2:CGPointMake(187.86, 62.39)];
    [path addCurveToPoint:CGPointMake(187.98, 15.53) controlPoint1:CGPointMake(188, 43.35) controlPoint2:CGPointMake(188, 31.65)];
    [path addCurveToPoint:CGPointMake(186.15, 6.99) controlPoint1:CGPointMake(187.87, 12.61) controlPoint2:CGPointMake(187.92, 9.42)];
    [path closePath];
    return path;
}

static UIBezierPath *_TextButtonStrokePath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(114.84, 0)];
    [path addCurveToPoint:CGPointMake(93.96, 0) controlPoint1:CGPointMake(107.89, 0) controlPoint2:CGPointMake(100.92, 0)];
    [path addCurveToPoint:CGPointMake(73.16, 0) controlPoint1:CGPointMake(87.03, 0) controlPoint2:CGPointMake(80.09, 0)];
    [path addCurveToPoint:CGPointMake(22.63, 0.89) controlPoint1:CGPointMake(56.31, 0.09) controlPoint2:CGPointMake(39.45, -0.21)];
    [path addCurveToPoint:CGPointMake(1.85, 6.99) controlPoint1:CGPointMake(16.76, 1.43) controlPoint2:CGPointMake(5.59, 1.96)];
    [path addCurveToPoint:CGPointMake(0.02, 15.53) controlPoint1:CGPointMake(0.08, 9.42) controlPoint2:CGPointMake(0.14, 12.61)];
    [path addCurveToPoint:CGPointMake(0.02, 59.47) controlPoint1:CGPointMake(-0.01, 31.65) controlPoint2:CGPointMake(-0.01, 43.35)];
    [path addCurveToPoint:CGPointMake(1.85, 68.01) controlPoint1:CGPointMake(0.13, 62.39) controlPoint2:CGPointMake(0.08, 65.58)];
    [path addCurveToPoint:CGPointMake(22.63, 74.11) controlPoint1:CGPointMake(5.57, 73.05) controlPoint2:CGPointMake(16.85, 73.58)];
    [path addCurveToPoint:CGPointMake(69.03, 74.99) controlPoint1:CGPointMake(38.07, 75.13) controlPoint2:CGPointMake(53.57, 74.92)];
    [path addCurveToPoint:CGPointMake(93.97, 75) controlPoint1:CGPointMake(77.35, 75) controlPoint2:CGPointMake(85.66, 75)];
    [path addCurveToPoint:CGPointMake(118.97, 74.99) controlPoint1:CGPointMake(102.3, 75) controlPoint2:CGPointMake(110.63, 75)];
    [path addCurveToPoint:CGPointMake(153.71, 74.68) controlPoint1:CGPointMake(130.55, 74.99) controlPoint2:CGPointMake(142.13, 74.98)];
    [path addCurveToPoint:CGPointMake(176.43, 72.73) controlPoint1:CGPointMake(161.3, 74.39) controlPoint2:CGPointMake(168.94, 74.21)];
    [path addCurveToPoint:CGPointMake(186.16, 68.01) controlPoint1:CGPointMake(179.91, 71.96) controlPoint2:CGPointMake(183.8, 71.08)];
    [path addCurveToPoint:CGPointMake(187.99, 59.47) controlPoint1:CGPointMake(187.92, 65.58) controlPoint2:CGPointMake(187.86, 62.39)];
    [path addCurveToPoint:CGPointMake(187.99, 15.53) controlPoint1:CGPointMake(188, 43.35) controlPoint2:CGPointMake(188, 31.65)];
    [path addCurveToPoint:CGPointMake(186.16, 6.99) controlPoint1:CGPointMake(187.87, 12.61) controlPoint2:CGPointMake(187.92, 9.42)];
    [path addCurveToPoint:CGPointMake(165.38, 0.89) controlPoint1:CGPointMake(182.43, 1.96) controlPoint2:CGPointMake(171.16, 1.42)];
    [path addCurveToPoint:CGPointMake(114.84, 0) controlPoint1:CGPointMake(148.56, -0.21) controlPoint2:CGPointMake(131.69, 0.09)];
    [path closePath];
    [path moveToPoint:CGPointMake(114.83, 7)];
    [path addCurveToPoint:CGPointMake(126.01, 7.02) controlPoint1:CGPointMake(118.56, 7.02) controlPoint2:CGPointMake(122.28, 7.02)];
    [path addCurveToPoint:CGPointMake(164.83, 7.87) controlPoint1:CGPointMake(138.78, 7.03) controlPoint2:CGPointMake(151.98, 7.03)];
    [path addCurveToPoint:CGPointMake(166.34, 8) controlPoint1:CGPointMake(165.3, 7.91) controlPoint2:CGPointMake(165.81, 7.95)];
    [path addCurveToPoint:CGPointMake(175.78, 9.25) controlPoint1:CGPointMake(169.17, 8.24) controlPoint2:CGPointMake(172.69, 8.54)];
    [path addCurveToPoint:CGPointMake(180.51, 11.13) controlPoint1:CGPointMake(179.39, 10.08) controlPoint2:CGPointMake(180.39, 11)];
    [path addCurveToPoint:CGPointMake(180.96, 14.99) controlPoint1:CGPointMake(180.84, 11.69) controlPoint2:CGPointMake(180.92, 13.75)];
    [path addLineToPoint:CGPointMake(180.99, 15.66)];
    [path addCurveToPoint:CGPointMake(180.99, 59.32) controlPoint1:CGPointMake(181, 31.56) controlPoint2:CGPointMake(181, 43.43)];
    [path addCurveToPoint:CGPointMake(180.96, 60.05) controlPoint1:CGPointMake(180.98, 59.56) controlPoint2:CGPointMake(180.97, 59.81)];
    [path addCurveToPoint:CGPointMake(180.53, 63.84) controlPoint1:CGPointMake(180.92, 61.19) controlPoint2:CGPointMake(180.84, 63.27)];
    [path addCurveToPoint:CGPointMake(174.99, 65.88) controlPoint1:CGPointMake(179.65, 64.84) controlPoint2:CGPointMake(177.2, 65.39)];
    [path addCurveToPoint:CGPointMake(155.2, 67.62) controlPoint1:CGPointMake(168.65, 67.12) controlPoint2:CGPointMake(162.12, 67.36)];
    [path addLineToPoint:CGPointMake(153.49, 67.68)];
    [path addCurveToPoint:CGPointMake(118.96, 67.99) controlPoint1:CGPointMake(141.83, 67.98) controlPoint2:CGPointMake(130.21, 67.99)];
    [path addCurveToPoint:CGPointMake(93.97, 68) controlPoint1:CGPointMake(110.63, 68) controlPoint2:CGPointMake(102.3, 68)];
    [path addCurveToPoint:CGPointMake(69.07, 67.99) controlPoint1:CGPointMake(85.66, 68) controlPoint2:CGPointMake(77.35, 68)];
    [path addCurveToPoint:CGPointMake(60.5, 67.97) controlPoint1:CGPointMake(66.21, 67.98) controlPoint2:CGPointMake(63.36, 67.98)];
    [path addCurveToPoint:CGPointMake(23.18, 67.13) controlPoint1:CGPointMake(48.22, 67.96) controlPoint2:CGPointMake(35.53, 67.95)];
    [path addCurveToPoint:CGPointMake(21.66, 67) controlPoint1:CGPointMake(22.7, 67.09) controlPoint2:CGPointMake(22.2, 67.05)];
    [path addCurveToPoint:CGPointMake(12.22, 65.75) controlPoint1:CGPointMake(18.83, 66.76) controlPoint2:CGPointMake(15.31, 66.46)];
    [path addCurveToPoint:CGPointMake(7.49, 63.87) controlPoint1:CGPointMake(8.61, 64.92) controlPoint2:CGPointMake(7.62, 64)];
    [path addCurveToPoint:CGPointMake(7.04, 60.01) controlPoint1:CGPointMake(7.16, 63.31) controlPoint2:CGPointMake(7.08, 61.25)];
    [path addLineToPoint:CGPointMake(7.02, 59.34)];
    [path addCurveToPoint:CGPointMake(7.02, 15.68) controlPoint1:CGPointMake(7, 43.45) controlPoint2:CGPointMake(7, 31.59)];
    [path addCurveToPoint:CGPointMake(7.04, 14.95) controlPoint1:CGPointMake(7.02, 15.44) controlPoint2:CGPointMake(7.03, 15.19)];
    [path addCurveToPoint:CGPointMake(7.48, 11.15) controlPoint1:CGPointMake(7.08, 13.81) controlPoint2:CGPointMake(7.16, 11.7)];
    [path addCurveToPoint:CGPointMake(12.15, 9.27) controlPoint1:CGPointMake(7.63, 10.99) controlPoint2:CGPointMake(8.63, 10.08)];
    [path addCurveToPoint:CGPointMake(21.66, 8) controlPoint1:CGPointMake(15.24, 8.55) controlPoint2:CGPointMake(18.8, 8.25)];
    [path addCurveToPoint:CGPointMake(23.17, 7.87) controlPoint1:CGPointMake(22.19, 7.96) controlPoint2:CGPointMake(22.7, 7.91)];
    [path addCurveToPoint:CGPointMake(62, 7.02) controlPoint1:CGPointMake(36.02, 7.03) controlPoint2:CGPointMake(49.23, 7.03)];
    [path addCurveToPoint:CGPointMake(73.15, 7) controlPoint1:CGPointMake(65.73, 7.02) controlPoint2:CGPointMake(69.46, 7.02)];
    [path addCurveToPoint:CGPointMake(93.96, 7) controlPoint1:CGPointMake(80.09, 7) controlPoint2:CGPointMake(87.03, 7)];
    [path addCurveToPoint:CGPointMake(114.83, 7) controlPoint1:CGPointMake(100.92, 7) controlPoint2:CGPointMake(107.87, 7)];
    [path closePath];
    return path;
}

@implementation UPControl (UPSpell)

+ (UPControl *)roundButton
{
    UPControl *control = [UPControl control];
    control.canonicalSize = UP::SpellLayout::CanonicalRoundButtonSize;
    [control setFillPath:_RoundButtonFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setStrokePath:_RoundButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    return control;
}

+ (UPControl *)roundButtonMinusSign
{
    UPControl *control = [UPControl roundButton];
    [control setContentPath:_RoundButtonMinusSignIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundButtonTrash
{
    UPControl *control = [UPControl roundButton];
    [control setContentPath:_RoundButtonTrashIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundButtonDownArrow
{
    UPControl *control = [UPControl roundButton];
    [control setContentPath:_RoundButtonDownArrowIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundButtonLeftArrow
{
    UPControl *control = [UPControl roundButton];
    [control setContentPath:_RoundButtonLeftArrowIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundButtonRightArrow
{
    UPControl *control = [UPControl roundButton];
    [control setContentPath:_RoundButtonRightArrowIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)wordTray
{
    UPControl *control = [UPControl control];
    control.canonicalSize = UP::SpellLayout::CanonicalWordTrayFrame.size;
    [control setFillPath:_WordTrayFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryInactiveFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryActiveFill] forState:UPControlStateActive];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryHighlightedFill] forState:(UPControlStateHighlighted | UPControlStateActive)];
    [control setFillColorAnimationDuration:0.5 fromState:(UPControlStateHighlighted | UPControlStateActive) toState:UPControlStateActive];
    [control setStrokePath:_WordTrayStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryInactiveStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryActiveStroke] forState:UPControlStateActive];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryHighlightedStroke] forState:(UPControlStateHighlighted | UPControlStateActive)];
    [control setStrokeColorAnimationDuration:YES fromState:(UPControlStateHighlighted | UPControlStateActive) toState:UPControlStateActive];
    return control;
}

+ (UPControl *)_textButton
{
    UPControl *control = [UPControl control];
    control.canonicalSize = UP::SpellLayout::CanonicalTextButtonSize;
    [control setFillPath:_TextButtonFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setStrokePath:_TextButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    return control;
}

+ (UPControl *)textButtonAbout
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:UP::TextPathContentAbout() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonExtras
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:UP::TextPathContentExtras() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonMenu
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:UP::TextPathContentMenu() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonPlay
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:UP::TextPathContentPlay() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonQuit
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:UP::TextPathContentQuit() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonResume
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:UP::TextPathContentResume() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonStats
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:UP::TextPathContentStats() forState:UPControlStateNormal];
    return control;
}

@end
