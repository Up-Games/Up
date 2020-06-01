//
//  UPControl+UPSpell.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>

#import "UPControl+UPSpell.h"
#import "UPSpellLayout.h"

static UIBezierPath *_RoundControlButtonFillPath(void)
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

static UIBezierPath *_RoundControlButtonStrokePath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
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

static UIBezierPath *_RoundControlButtonPauseIconPath(void)
{
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(14, 37.5, 56, 9) cornerRadius:4.5];
}

static UIBezierPath *_RoundControlButtonTrashIconPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // can
    [path moveToPoint: CGPointMake(54.62, 62.27)];
    [path addLineToPoint: CGPointMake(54.61, 62.49)];
    [path addCurveToPoint: CGPointMake(51.49, 65.76) controlPoint1: CGPointMake(54.61, 64.29) controlPoint2: CGPointMake(53.21, 65.76)];
    [path addLineToPoint: CGPointMake(32.52, 65.76)];
    [path addCurveToPoint: CGPointMake(29.39, 62.49) controlPoint1: CGPointMake(30.79, 65.76) controlPoint2: CGPointMake(29.39, 64.29)];
    [path addLineToPoint: CGPointMake(29.4, 62.41)];
    [path addLineToPoint: CGPointMake(26.32, 25.81)];
    [path addLineToPoint: CGPointMake(57.68, 25.81)];
    [path addLineToPoint: CGPointMake(54.62, 62.27)];
    [path closePath];
    [path moveToPoint: CGPointMake(35.57, 20.75)];
    [path addCurveToPoint: CGPointMake(39.32, 16.83) controlPoint1: CGPointMake(35.58, 18.59) controlPoint2: CGPointMake(37.26, 16.83)];
    [path addLineToPoint: CGPointMake(44.68, 16.83)];
    [path addCurveToPoint: CGPointMake(48.43, 20.75) controlPoint1: CGPointMake(46.74, 16.83) controlPoint2: CGPointMake(48.42, 18.59)];
    [path addLineToPoint: CGPointMake(48.44, 21.23)];
    [path addLineToPoint: CGPointMake(35.56, 21.23)];
    [path addLineToPoint: CGPointMake(35.57, 20.75)];
    [path closePath];
    [path moveToPoint: CGPointMake(64.25, 21.23)];
    [path addLineToPoint: CGPointMake(64, 21.23)];
    [path addLineToPoint: CGPointMake(51.92, 21.23)];
    [path addLineToPoint: CGPointMake(51.92, 20.75)];
    [path addCurveToPoint: CGPointMake(44.68, 13.18) controlPoint1: CGPointMake(51.91, 16.58) controlPoint2: CGPointMake(48.66, 13.18)];
    [path addLineToPoint: CGPointMake(39.32, 13.18)];
    [path addCurveToPoint: CGPointMake(32.08, 20.75) controlPoint1: CGPointMake(35.34, 13.18) controlPoint2: CGPointMake(32.1, 16.58)];
    [path addLineToPoint: CGPointMake(32.08, 21.23)];
    [path addLineToPoint: CGPointMake(20, 21.23)];
    [path addLineToPoint: CGPointMake(19.75, 21.23)];
    [path addCurveToPoint: CGPointMake(17.5, 23.52) controlPoint1: CGPointMake(18.51, 21.23) controlPoint2: CGPointMake(17.5, 22.26)];
    [path addCurveToPoint: CGPointMake(19.75, 25.81) controlPoint1: CGPointMake(17.5, 24.79) controlPoint2: CGPointMake(18.51, 25.81)];
    [path addLineToPoint: CGPointMake(20, 25.81)];
    [path addLineToPoint: CGPointMake(22.08, 25.81)];
    [path addLineToPoint: CGPointMake(25.17, 62.61)];
    [path addCurveToPoint: CGPointMake(32.52, 70.18) controlPoint1: CGPointMake(25.23, 66.78) controlPoint2: CGPointMake(28.53, 70.18)];
    [path addLineToPoint: CGPointMake(51.49, 70.18)];
    [path addCurveToPoint: CGPointMake(58.83, 62.57) controlPoint1: CGPointMake(55.47, 70.18) controlPoint2: CGPointMake(58.77, 66.78)];
    [path addLineToPoint: CGPointMake(61.92, 25.81)];
    [path addLineToPoint: CGPointMake(64, 25.81)];
    [path addLineToPoint: CGPointMake(64.25, 25.81)];
    [path addCurveToPoint: CGPointMake(66.5, 23.52) controlPoint1: CGPointMake(65.49, 25.81) controlPoint2: CGPointMake(66.5, 24.79)];
    [path addCurveToPoint: CGPointMake(64.25, 21.23) controlPoint1: CGPointMake(66.5, 22.26) controlPoint2: CGPointMake(65.49, 21.23)];
    [path closePath];

    // left line
    [path moveToPoint: CGPointMake(35.01, 60.91)];
    [path addCurveToPoint: CGPointMake(33.51, 59.47) controlPoint1: CGPointMake(34.21, 60.91) controlPoint2: CGPointMake(33.54, 60.28)];
    [path addLineToPoint: CGPointMake(33.5, 59.27)];
    [path addLineToPoint: CGPointMake(32.11, 31.49)];
    [path addCurveToPoint: CGPointMake(33.54, 29.91) controlPoint1: CGPointMake(32.07, 30.66) controlPoint2: CGPointMake(32.71, 29.95)];
    [path addCurveToPoint: CGPointMake(35.11, 31.34) controlPoint1: CGPointMake(34.35, 29.86) controlPoint2: CGPointMake(35.07, 30.51)];
    [path addLineToPoint: CGPointMake(36.51, 59.35)];
    [path addCurveToPoint: CGPointMake(35.07, 60.91) controlPoint1: CGPointMake(36.54, 60.18) controlPoint2: CGPointMake(35.9, 60.88)];
    [path addCurveToPoint: CGPointMake(35.01, 60.91) controlPoint1: CGPointMake(35.05, 60.91) controlPoint2: CGPointMake(35.03, 60.91)];
    [path closePath];

    // center line
    [path moveToPoint: CGPointMake(42, 60.91)];
    [path addCurveToPoint: CGPointMake(40.5, 59.41) controlPoint1: CGPointMake(41.17, 60.91) controlPoint2: CGPointMake(40.5, 60.24)];
    [path addLineToPoint: CGPointMake(40.5, 31.41)];
    [path addCurveToPoint: CGPointMake(42, 29.91) controlPoint1: CGPointMake(40.5, 30.58) controlPoint2: CGPointMake(41.17, 29.91)];
    [path addCurveToPoint: CGPointMake(43.5, 31.41) controlPoint1: CGPointMake(42.83, 29.91) controlPoint2: CGPointMake(43.5, 30.58)];
    [path addLineToPoint: CGPointMake(43.5, 59.41)];
    [path addCurveToPoint: CGPointMake(42, 60.91) controlPoint1: CGPointMake(43.5, 60.24) controlPoint2: CGPointMake(42.83, 60.91)];
    [path closePath];

    // right line
    [path moveToPoint: CGPointMake(49, 60.91)];
    [path addCurveToPoint: CGPointMake(48.94, 60.91) controlPoint1: CGPointMake(48.98, 60.91) controlPoint2: CGPointMake(48.96, 60.91)];
    [path addCurveToPoint: CGPointMake(47.5, 59.35) controlPoint1: CGPointMake(48.11, 60.88) controlPoint2: CGPointMake(47.47, 60.18)];
    [path addLineToPoint: CGPointMake(47.51, 59.14)];
    [path addLineToPoint: CGPointMake(48.9, 31.34)];
    [path addCurveToPoint: CGPointMake(50.47, 29.91) controlPoint1: CGPointMake(48.94, 30.51) controlPoint2: CGPointMake(49.65, 29.86)];
    [path addCurveToPoint: CGPointMake(51.9, 31.49) controlPoint1: CGPointMake(51.3, 29.95) controlPoint2: CGPointMake(51.94, 30.66)];
    [path addLineToPoint: CGPointMake(50.5, 59.47)];
    [path addCurveToPoint: CGPointMake(49, 60.91) controlPoint1: CGPointMake(50.46, 60.28) controlPoint2: CGPointMake(49.8, 60.91)];
    [path closePath];

    return path;
}

static UIBezierPath *_RoundControlButtonDownArrowIconPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(63.76, 39.33)];
    [path addCurveToPoint: CGPointMake(58.83, 39.74) controlPoint1: CGPointMake(62.29, 38.08) controlPoint2: CGPointMake(60.08, 38.26)];
    [path addLineToPoint: CGPointMake(45.5, 55.46)];
    [path addLineToPoint: CGPointMake(45.5, 20.5)];
    [path addCurveToPoint: CGPointMake(42, 17) controlPoint1: CGPointMake(45.5, 18.57) controlPoint2: CGPointMake(43.93, 17)];
    [path addCurveToPoint: CGPointMake(38.5, 20.5) controlPoint1: CGPointMake(40.07, 17) controlPoint2: CGPointMake(38.5, 18.57)];
    [path addLineToPoint: CGPointMake(38.5, 55.46)];
    [path addLineToPoint: CGPointMake(25.17, 39.74)];
    [path addCurveToPoint: CGPointMake(20.24, 39.33) controlPoint1: CGPointMake(23.92, 38.26) controlPoint2: CGPointMake(21.71, 38.08)];
    [path addCurveToPoint: CGPointMake(19.83, 44.26) controlPoint1: CGPointMake(18.76, 40.58) controlPoint2: CGPointMake(18.58, 42.79)];
    [path addLineToPoint: CGPointMake(39.33, 67.26)];
    [path addCurveToPoint: CGPointMake(42, 68.5) controlPoint1: CGPointMake(40, 68.05) controlPoint2: CGPointMake(40.97, 68.5)];
    [path addCurveToPoint: CGPointMake(44.67, 67.26) controlPoint1: CGPointMake(43.03, 68.5) controlPoint2: CGPointMake(44.01, 68.05)];
    [path addLineToPoint: CGPointMake(64.17, 44.26)];
    [path addCurveToPoint: CGPointMake(63.76, 39.33) controlPoint1: CGPointMake(65.42, 42.79) controlPoint2: CGPointMake(65.24, 40.58)];
    [path closePath];
    return path;
}

static UIBezierPath *_WordTrayFillPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(481.88, 177)];
    [path addCurveToPoint: CGPointMake(437.5, 176.99) controlPoint1: CGPointMake(466.87, 177) controlPoint2: CGPointMake(452.04, 177)];
    [path addCurveToPoint: CGPointMake(393.12, 177) controlPoint1: CGPointMake(422.96, 177) controlPoint2: CGPointMake(408.13, 177)];
    [path addCurveToPoint: CGPointMake(217.01, 176.81) controlPoint1: CGPointMake(327.82, 177) controlPoint2: CGPointMake(268.57, 176.93)];
    [path addCurveToPoint: CGPointMake(180.71, 176.68) controlPoint1: CGPointMake(204.92, 176.72) controlPoint2: CGPointMake(192.61, 176.7)];
    [path addCurveToPoint: CGPointMake(31.49, 172.38) controlPoint1: CGPointMake(131.72, 176.58) controlPoint2: CGPointMake(81.07, 176.48)];
    [path addCurveToPoint: CGPointMake(14.65, 169.59) controlPoint1: CGPointMake(25.95, 171.9) controlPoint2: CGPointMake(20.2, 170.73)];
    [path addCurveToPoint: CGPointMake(9.14, 167.44) controlPoint1: CGPointMake(12.9, 169.23) controlPoint2: CGPointMake(11.08, 168.36)];
    [path addLineToPoint: CGPointMake(8.63, 167.2)];
    [path addCurveToPoint: CGPointMake(5.32, 160.23) controlPoint1: CGPointMake(7.72, 166.77) controlPoint2: CGPointMake(5.62, 165.78)];
    [path addCurveToPoint: CGPointMake(5.23, 152.64) controlPoint1: CGPointMake(5.29, 157.7) controlPoint2: CGPointMake(5.26, 155.17)];
    [path addLineToPoint: CGPointMake(5.16, 146.73)];
    [path addLineToPoint: CGPointMake(5.1, 146.75)];
    [path addCurveToPoint: CGPointMake(5.11, 139.84) controlPoint1: CGPointMake(5.1, 144.44) controlPoint2: CGPointMake(5.11, 142.14)];
    [path addCurveToPoint: CGPointMake(5.11, 42.2) controlPoint1: CGPointMake(4.96, 120.19) controlPoint2: CGPointMake(4.96, 61.81)];
    [path addCurveToPoint: CGPointMake(5.1, 35.27) controlPoint1: CGPointMake(5.11, 39.88) controlPoint2: CGPointMake(5.1, 37.57)];
    [path addLineToPoint: CGPointMake(5.16, 35.28)];
    [path addLineToPoint: CGPointMake(5.23, 29.36)];
    [path addCurveToPoint: CGPointMake(5.32, 21.77) controlPoint1: CGPointMake(5.26, 26.83) controlPoint2: CGPointMake(5.29, 24.3)];
    [path addCurveToPoint: CGPointMake(8.63, 14.8) controlPoint1: CGPointMake(5.61, 16.22) controlPoint2: CGPointMake(7.72, 15.23)];
    [path addLineToPoint: CGPointMake(9.14, 14.55)];
    [path addCurveToPoint: CGPointMake(14.55, 12.43) controlPoint1: CGPointMake(11.08, 13.64) controlPoint2: CGPointMake(12.9, 12.77)];
    [path addCurveToPoint: CGPointMake(31.51, 9.62) controlPoint1: CGPointMake(20.2, 11.28) controlPoint2: CGPointMake(25.95, 10.1)];
    [path addCurveToPoint: CGPointMake(180.7, 5.32) controlPoint1: CGPointMake(81.07, 5.52) controlPoint2: CGPointMake(131.72, 5.42)];
    [path addCurveToPoint: CGPointMake(217.03, 5.19) controlPoint1: CGPointMake(192.61, 5.3) controlPoint2: CGPointMake(204.92, 5.28)];
    [path addCurveToPoint: CGPointMake(392.54, 5) controlPoint1: CGPointMake(268.56, 5.06) controlPoint2: CGPointMake(327.62, 5)];
    [path addCurveToPoint: CGPointMake(437.5, 5.01) controlPoint1: CGPointMake(407.75, 5) controlPoint2: CGPointMake(422.78, 5)];
    [path addCurveToPoint: CGPointMake(482.46, 5) controlPoint1: CGPointMake(452.23, 5) controlPoint2: CGPointMake(467.25, 5)];
    [path addCurveToPoint: CGPointMake(657.99, 5.19) controlPoint1: CGPointMake(547.38, 5) controlPoint2: CGPointMake(606.44, 5.06)];
    [path addCurveToPoint: CGPointMake(694.3, 5.32) controlPoint1: CGPointMake(670.08, 5.28) controlPoint2: CGPointMake(682.39, 5.3)];
    [path addCurveToPoint: CGPointMake(843.51, 9.62) controlPoint1: CGPointMake(743.28, 5.42) controlPoint2: CGPointMake(793.93, 5.52)];
    [path addCurveToPoint: CGPointMake(860.36, 12.41) controlPoint1: CGPointMake(849.05, 10.1) controlPoint2: CGPointMake(854.8, 11.28)];
    [path addCurveToPoint: CGPointMake(865.85, 14.55) controlPoint1: CGPointMake(862.09, 12.77) controlPoint2: CGPointMake(863.92, 13.64)];
    [path addLineToPoint: CGPointMake(866.37, 14.8)];
    [path addCurveToPoint: CGPointMake(869.68, 21.77) controlPoint1: CGPointMake(867.28, 15.23) controlPoint2: CGPointMake(869.39, 16.22)];
    [path addCurveToPoint: CGPointMake(869.77, 29.35) controlPoint1: CGPointMake(869.71, 24.3) controlPoint2: CGPointMake(869.74, 26.83)];
    [path addLineToPoint: CGPointMake(869.83, 35.28)];
    [path addLineToPoint: CGPointMake(869.9, 35.27)];
    [path addCurveToPoint: CGPointMake(869.89, 42.16) controlPoint1: CGPointMake(869.9, 37.56) controlPoint2: CGPointMake(869.89, 39.86)];
    [path addCurveToPoint: CGPointMake(869.89, 139.79) controlPoint1: CGPointMake(870.04, 61.81) controlPoint2: CGPointMake(870.04, 120.19)];
    [path addCurveToPoint: CGPointMake(869.9, 146.75) controlPoint1: CGPointMake(869.89, 142.12) controlPoint2: CGPointMake(869.9, 144.44)];
    [path addLineToPoint: CGPointMake(869.83, 146.74)];
    [path addLineToPoint: CGPointMake(869.77, 152.65)];
    [path addCurveToPoint: CGPointMake(869.68, 160.23) controlPoint1: CGPointMake(869.74, 155.18) controlPoint2: CGPointMake(869.71, 157.7)];
    [path addCurveToPoint: CGPointMake(866.37, 167.2) controlPoint1: CGPointMake(869.38, 165.78) controlPoint2: CGPointMake(867.28, 166.77)];
    [path addLineToPoint: CGPointMake(865.85, 167.45)];
    [path addCurveToPoint: CGPointMake(860.45, 169.57) controlPoint1: CGPointMake(863.92, 168.36) controlPoint2: CGPointMake(862.1, 169.23)];
    [path addLineToPoint: CGPointMake(860.35, 169.59)];
    [path addCurveToPoint: CGPointMake(843.49, 172.38) controlPoint1: CGPointMake(854.79, 170.73) controlPoint2: CGPointMake(849.05, 171.9)];
    [path addCurveToPoint: CGPointMake(694.29, 176.68) controlPoint1: CGPointMake(793.93, 176.48) controlPoint2: CGPointMake(743.28, 176.58)];
    [path addCurveToPoint: CGPointMake(657.97, 176.81) controlPoint1: CGPointMake(682.39, 176.7) controlPoint2: CGPointMake(670.08, 176.72)];
    [path addCurveToPoint: CGPointMake(481.88, 177) controlPoint1: CGPointMake(606.43, 176.93) controlPoint2: CGPointMake(547.18, 177)];
    [path closePath];
    return path;
}

static UIBezierPath *_WordTrayStrokePath(void)
{
   UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(482.26, 0)];
    [path addCurveToPoint: CGPointMake(437.5, 0.01) controlPoint1: CGPointMake(467.11, 0) controlPoint2: CGPointMake(452.16, 0)];
    [path addCurveToPoint: CGPointMake(392.74, 0) controlPoint1: CGPointMake(422.84, 0) controlPoint2: CGPointMake(407.88, 0)];
    [path addCurveToPoint: CGPointMake(217, 0.19) controlPoint1: CGPointMake(334.39, 0) controlPoint2: CGPointMake(273.4, 0.05)];
    [path addCurveToPoint: CGPointMake(31.08, 4.64) controlPoint1: CGPointMake(155.02, 0.61) controlPoint2: CGPointMake(92.93, -0.48)];
    [path addCurveToPoint: CGPointMake(13.55, 7.53) controlPoint1: CGPointMake(25.2, 5.14) controlPoint2: CGPointMake(19.36, 6.34)];
    [path addCurveToPoint: CGPointMake(6.49, 10.28) controlPoint1: CGPointMake(11.13, 8.03) controlPoint2: CGPointMake(8.79, 9.19)];
    [path addCurveToPoint: CGPointMake(0.33, 21.61) controlPoint1: CGPointMake(2.13, 12.34) controlPoint2: CGPointMake(0.57, 16.58)];
    [path addCurveToPoint: CGPointMake(0.23, 29.3) controlPoint1: CGPointMake(0.29, 24.17) controlPoint2: CGPointMake(0.26, 26.74)];
    [path addLineToPoint: CGPointMake(0.08, 29.27)];
    [path addCurveToPoint: CGPointMake(0.11, 42.16) controlPoint1: CGPointMake(0.1, 33.57) controlPoint2: CGPointMake(0.11, 37.87)];
    [path addCurveToPoint: CGPointMake(0.11, 139.84) controlPoint1: CGPointMake(-0.04, 61.71) controlPoint2: CGPointMake(-0.04, 120.29)];
    [path addCurveToPoint: CGPointMake(0.08, 152.73) controlPoint1: CGPointMake(0.11, 144.13) controlPoint2: CGPointMake(0.1, 148.43)];
    [path addLineToPoint: CGPointMake(0.23, 152.7)];
    [path addCurveToPoint: CGPointMake(0.33, 160.39) controlPoint1: CGPointMake(0.26, 155.27) controlPoint2: CGPointMake(0.29, 157.83)];
    [path addCurveToPoint: CGPointMake(6.49, 171.72) controlPoint1: CGPointMake(0.57, 165.42) controlPoint2: CGPointMake(2.13, 169.66)];
    [path addCurveToPoint: CGPointMake(13.55, 174.47) controlPoint1: CGPointMake(8.79, 172.81) controlPoint2: CGPointMake(11.13, 173.97)];
    [path addCurveToPoint: CGPointMake(31.08, 177.36) controlPoint1: CGPointMake(19.36, 175.66) controlPoint2: CGPointMake(25.2, 176.86)];
    [path addCurveToPoint: CGPointMake(217, 181.81) controlPoint1: CGPointMake(92.93, 182.48) controlPoint2: CGPointMake(155.02, 181.39)];
    [path addCurveToPoint: CGPointMake(392.64, 182) controlPoint1: CGPointMake(273.36, 181.95) controlPoint2: CGPointMake(334.32, 182)];
    [path addCurveToPoint: CGPointMake(437.5, 181.99) controlPoint1: CGPointMake(407.82, 182) controlPoint2: CGPointMake(422.81, 182)];
    [path addCurveToPoint: CGPointMake(482.36, 182) controlPoint1: CGPointMake(452.19, 182) controlPoint2: CGPointMake(467.19, 182)];
    [path addCurveToPoint: CGPointMake(658, 181.81) controlPoint1: CGPointMake(540.68, 182) controlPoint2: CGPointMake(601.63, 181.95)];
    [path addCurveToPoint: CGPointMake(843.92, 177.36) controlPoint1: CGPointMake(719.98, 181.39) controlPoint2: CGPointMake(782.07, 182.48)];
    [path addCurveToPoint: CGPointMake(861.45, 174.47) controlPoint1: CGPointMake(849.8, 176.86) controlPoint2: CGPointMake(855.64, 175.66)];
    [path addCurveToPoint: CGPointMake(868.51, 171.72) controlPoint1: CGPointMake(863.87, 173.97) controlPoint2: CGPointMake(866.21, 172.81)];
    [path addCurveToPoint: CGPointMake(874.67, 160.39) controlPoint1: CGPointMake(872.87, 169.66) controlPoint2: CGPointMake(874.43, 165.42)];
    [path addCurveToPoint: CGPointMake(874.77, 152.7) controlPoint1: CGPointMake(874.71, 157.83) controlPoint2: CGPointMake(874.74, 155.27)];
    [path addLineToPoint: CGPointMake(874.92, 152.73)];
    [path addCurveToPoint: CGPointMake(874.89, 139.83) controlPoint1: CGPointMake(874.9, 148.43) controlPoint2: CGPointMake(874.89, 144.13)];
    [path addCurveToPoint: CGPointMake(874.89, 42.17) controlPoint1: CGPointMake(875.04, 120.28) controlPoint2: CGPointMake(875.04, 61.72)];
    [path addCurveToPoint: CGPointMake(874.92, 29.27) controlPoint1: CGPointMake(874.89, 37.87) controlPoint2: CGPointMake(874.9, 33.57)];
    [path addLineToPoint: CGPointMake(874.77, 29.3)];
    [path addCurveToPoint: CGPointMake(874.67, 21.61) controlPoint1: CGPointMake(874.74, 26.74) controlPoint2: CGPointMake(874.71, 24.17)];
    [path addCurveToPoint: CGPointMake(868.51, 10.28) controlPoint1: CGPointMake(874.43, 16.58) controlPoint2: CGPointMake(872.87, 12.34)];
    [path addCurveToPoint: CGPointMake(861.45, 7.53) controlPoint1: CGPointMake(866.21, 9.19) controlPoint2: CGPointMake(863.87, 8.03)];
    [path addCurveToPoint: CGPointMake(843.92, 4.64) controlPoint1: CGPointMake(855.64, 6.34) controlPoint2: CGPointMake(849.8, 5.14)];
    [path addCurveToPoint: CGPointMake(658, 0.19) controlPoint1: CGPointMake(782.07, -0.48) controlPoint2: CGPointMake(719.98, 0.61)];
    [path addCurveToPoint: CGPointMake(482.26, 0) controlPoint1: CGPointMake(601.61, 0.05) controlPoint2: CGPointMake(540.61, 0)];
    [path closePath];
    [path moveToPoint: CGPointMake(482.26, 10)];
    [path addCurveToPoint: CGPointMake(657.94, 10.19) controlPoint1: CGPointMake(547.27, 10) controlPoint2: CGPointMake(606.39, 10.06)];
    [path addCurveToPoint: CGPointMake(694.29, 10.32) controlPoint1: CGPointMake(670.06, 10.28) controlPoint2: CGPointMake(682.38, 10.3)];
    [path addCurveToPoint: CGPointMake(843.07, 14.6) controlPoint1: CGPointMake(743.17, 10.42) controlPoint2: CGPointMake(793.72, 10.52)];
    [path addCurveToPoint: CGPointMake(859.36, 17.31) controlPoint1: CGPointMake(848.33, 15.05) controlPoint2: CGPointMake(853.69, 16.15)];
    [path addLineToPoint: CGPointMake(859.44, 17.33)];
    [path addCurveToPoint: CGPointMake(863.71, 19.07) controlPoint1: CGPointMake(860.5, 17.55) controlPoint2: CGPointMake(862.13, 18.32)];
    [path addLineToPoint: CGPointMake(864.19, 19.3)];
    [path addCurveToPoint: CGPointMake(864.68, 21.94) controlPoint1: CGPointMake(864.3, 19.53) controlPoint2: CGPointMake(864.58, 20.28)];
    [path addCurveToPoint: CGPointMake(864.77, 29.41) controlPoint1: CGPointMake(864.71, 24.43) controlPoint2: CGPointMake(864.74, 26.92)];
    [path addLineToPoint: CGPointMake(864.89, 40.21)];
    [path addCurveToPoint: CGPointMake(864.89, 42.16) controlPoint1: CGPointMake(864.89, 40.86) controlPoint2: CGPointMake(864.89, 41.51)];
    [path addLineToPoint: CGPointMake(864.89, 42.2)];
    [path addLineToPoint: CGPointMake(864.89, 42.24)];
    [path addCurveToPoint: CGPointMake(864.89, 139.76) controlPoint1: CGPointMake(865.04, 61.84) controlPoint2: CGPointMake(865.04, 120.16)];
    [path addLineToPoint: CGPointMake(864.89, 139.8)];
    [path addLineToPoint: CGPointMake(864.89, 139.84)];
    [path addCurveToPoint: CGPointMake(864.89, 141.79) controlPoint1: CGPointMake(864.89, 140.49) controlPoint2: CGPointMake(864.89, 141.14)];
    [path addLineToPoint: CGPointMake(864.77, 152.59)];
    [path addCurveToPoint: CGPointMake(864.68, 160.06) controlPoint1: CGPointMake(864.74, 155.08) controlPoint2: CGPointMake(864.71, 157.57)];
    [path addCurveToPoint: CGPointMake(864.19, 162.7) controlPoint1: CGPointMake(864.58, 161.72) controlPoint2: CGPointMake(864.3, 162.46)];
    [path addLineToPoint: CGPointMake(863.71, 162.93)];
    [path addCurveToPoint: CGPointMake(859.44, 164.67) controlPoint1: CGPointMake(862.13, 163.68) controlPoint2: CGPointMake(860.5, 164.45)];
    [path addLineToPoint: CGPointMake(859.36, 164.69)];
    [path addCurveToPoint: CGPointMake(843.1, 167.4) controlPoint1: CGPointMake(853.69, 165.85) controlPoint2: CGPointMake(848.33, 166.94)];
    [path addCurveToPoint: CGPointMake(694.29, 171.68) controlPoint1: CGPointMake(793.72, 171.48) controlPoint2: CGPointMake(743.17, 171.58)];
    [path addCurveToPoint: CGPointMake(657.98, 171.81) controlPoint1: CGPointMake(682.38, 171.7) controlPoint2: CGPointMake(670.06, 171.72)];
    [path addCurveToPoint: CGPointMake(482.36, 172) controlPoint1: CGPointMake(606.38, 171.94) controlPoint2: CGPointMake(547.29, 172)];
    [path addCurveToPoint: CGPointMake(437.5, 171.99) controlPoint1: CGPointMake(467.19, 172) controlPoint2: CGPointMake(452.19, 172)];
    [path addCurveToPoint: CGPointMake(392.64, 172) controlPoint1: CGPointMake(422.8, 172) controlPoint2: CGPointMake(407.81, 172)];
    [path addCurveToPoint: CGPointMake(217.06, 171.81) controlPoint1: CGPointMake(327.71, 172) controlPoint2: CGPointMake(268.62, 171.94)];
    [path addCurveToPoint: CGPointMake(180.71, 171.68) controlPoint1: CGPointMake(204.94, 171.72) controlPoint2: CGPointMake(192.62, 171.7)];
    [path addCurveToPoint: CGPointMake(31.93, 167.4) controlPoint1: CGPointMake(131.83, 171.58) controlPoint2: CGPointMake(81.28, 171.48)];
    [path addCurveToPoint: CGPointMake(15.64, 164.69) controlPoint1: CGPointMake(26.67, 166.94) controlPoint2: CGPointMake(21.31, 165.85)];
    [path addLineToPoint: CGPointMake(15.55, 164.67)];
    [path addCurveToPoint: CGPointMake(11.29, 162.93) controlPoint1: CGPointMake(14.5, 164.45) controlPoint2: CGPointMake(12.87, 163.68)];
    [path addLineToPoint: CGPointMake(10.81, 162.7)];
    [path addCurveToPoint: CGPointMake(10.32, 160.06) controlPoint1: CGPointMake(10.7, 162.47) controlPoint2: CGPointMake(10.42, 161.72)];
    [path addCurveToPoint: CGPointMake(10.23, 152.59) controlPoint1: CGPointMake(10.29, 157.57) controlPoint2: CGPointMake(10.26, 155.08)];
    [path addLineToPoint: CGPointMake(10.11, 141.78)];
    [path addCurveToPoint: CGPointMake(10.11, 139.85) controlPoint1: CGPointMake(10.11, 141.14) controlPoint2: CGPointMake(10.11, 140.49)];
    [path addLineToPoint: CGPointMake(10.11, 139.8)];
    [path addLineToPoint: CGPointMake(10.11, 139.76)];
    [path addCurveToPoint: CGPointMake(10.11, 42.24) controlPoint1: CGPointMake(9.96, 120.17) controlPoint2: CGPointMake(9.96, 61.84)];
    [path addLineToPoint: CGPointMake(10.11, 42.2)];
    [path addLineToPoint: CGPointMake(10.11, 42.16)];
    [path addCurveToPoint: CGPointMake(10.11, 40.22) controlPoint1: CGPointMake(10.11, 41.51) controlPoint2: CGPointMake(10.11, 40.86)];
    [path addLineToPoint: CGPointMake(10.23, 29.41)];
    [path addCurveToPoint: CGPointMake(10.32, 21.94) controlPoint1: CGPointMake(10.26, 26.92) controlPoint2: CGPointMake(10.29, 24.43)];
    [path addCurveToPoint: CGPointMake(10.81, 19.3) controlPoint1: CGPointMake(10.42, 20.28) controlPoint2: CGPointMake(10.7, 19.54)];
    [path addLineToPoint: CGPointMake(11.29, 19.07)];
    [path addCurveToPoint: CGPointMake(15.55, 17.33) controlPoint1: CGPointMake(12.87, 18.32) controlPoint2: CGPointMake(14.5, 17.55)];
    [path addLineToPoint: CGPointMake(15.64, 17.31)];
    [path addCurveToPoint: CGPointMake(31.9, 14.6) controlPoint1: CGPointMake(21.31, 16.15) controlPoint2: CGPointMake(26.67, 15.05)];
    [path addCurveToPoint: CGPointMake(180.71, 10.32) controlPoint1: CGPointMake(81.28, 10.52) controlPoint2: CGPointMake(131.83, 10.42)];
    [path addCurveToPoint: CGPointMake(217.02, 10.19) controlPoint1: CGPointMake(192.62, 10.3) controlPoint2: CGPointMake(204.94, 10.28)];
    [path addCurveToPoint: CGPointMake(392.74, 10) controlPoint1: CGPointMake(268.62, 10.06) controlPoint2: CGPointMake(327.74, 10)];
    [path addCurveToPoint: CGPointMake(437.5, 10.01) controlPoint1: CGPointMake(407.88, 10) controlPoint2: CGPointMake(422.84, 10)];
    [path addCurveToPoint: CGPointMake(482.26, 10) controlPoint1: CGPointMake(452.16, 10) controlPoint2: CGPointMake(467.11, 10)];
    [path closePath];
    return path;
}

static UIBezierPath *_TextButtonFillPath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(186.15, 6.99)];
    [path addCurveToPoint: CGPointMake(165.38, 0.89) controlPoint1: CGPointMake(182.43, 1.96) controlPoint2: CGPointMake(171.16, 1.42)];
    [path addCurveToPoint: CGPointMake(114.84, 0) controlPoint1: CGPointMake(148.55, -0.21) controlPoint2: CGPointMake(131.69, 0.09)];
    [path addCurveToPoint: CGPointMake(73.16, 0) controlPoint1: CGPointMake(100.95, 0.01) controlPoint2: CGPointMake(87.05, 0.01)];
    [path addCurveToPoint: CGPointMake(22.63, 0.89) controlPoint1: CGPointMake(56.31, 0.09) controlPoint2: CGPointMake(39.45, -0.21)];
    [path addCurveToPoint: CGPointMake(1.84, 6.99) controlPoint1: CGPointMake(16.76, 1.43) controlPoint2: CGPointMake(5.59, 1.96)];
    [path addCurveToPoint: CGPointMake(0.01, 15.53) controlPoint1: CGPointMake(0.08, 9.42) controlPoint2: CGPointMake(0.14, 12.61)];
    [path addCurveToPoint: CGPointMake(0.01, 59.47) controlPoint1: CGPointMake(-0, 31.65) controlPoint2: CGPointMake(-0, 43.35)];
    [path addCurveToPoint: CGPointMake(1.84, 68.01) controlPoint1: CGPointMake(0.13, 62.39) controlPoint2: CGPointMake(0.08, 65.58)];
    [path addCurveToPoint: CGPointMake(22.62, 74.11) controlPoint1: CGPointMake(5.57, 73.05) controlPoint2: CGPointMake(16.84, 73.58)];
    [path addCurveToPoint: CGPointMake(69.03, 74.99) controlPoint1: CGPointMake(38.07, 75.13) controlPoint2: CGPointMake(53.56, 74.93)];
    [path addCurveToPoint: CGPointMake(118.97, 74.99) controlPoint1: CGPointMake(85.68, 75) controlPoint2: CGPointMake(102.32, 75)];
    [path addCurveToPoint: CGPointMake(153.71, 74.68) controlPoint1: CGPointMake(130.55, 74.99) controlPoint2: CGPointMake(142.13, 74.98)];
    [path addCurveToPoint: CGPointMake(176.42, 72.73) controlPoint1: CGPointMake(161.3, 74.39) controlPoint2: CGPointMake(168.94, 74.21)];
    [path addCurveToPoint: CGPointMake(186.15, 68.01) controlPoint1: CGPointMake(179.91, 71.96) controlPoint2: CGPointMake(183.8, 71.08)];
    [path addCurveToPoint: CGPointMake(187.99, 59.47) controlPoint1: CGPointMake(187.92, 65.58) controlPoint2: CGPointMake(187.86, 62.39)];
    [path addCurveToPoint: CGPointMake(187.98, 15.53) controlPoint1: CGPointMake(188, 43.35) controlPoint2: CGPointMake(188, 31.65)];
    [path addCurveToPoint: CGPointMake(186.15, 6.99) controlPoint1: CGPointMake(187.87, 12.61) controlPoint2: CGPointMake(187.92, 9.42)];
    [path closePath];
    return path;
}

static UIBezierPath *_TextButtonStrokePath(void)
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(114.84, 0)];
    [path addCurveToPoint: CGPointMake(93.96, 0) controlPoint1: CGPointMake(107.89, 0) controlPoint2: CGPointMake(100.92, 0)];
    [path addCurveToPoint: CGPointMake(73.16, 0) controlPoint1: CGPointMake(87.03, 0) controlPoint2: CGPointMake(80.09, 0)];
    [path addCurveToPoint: CGPointMake(22.63, 0.89) controlPoint1: CGPointMake(56.31, 0.09) controlPoint2: CGPointMake(39.45, -0.21)];
    [path addCurveToPoint: CGPointMake(1.85, 6.99) controlPoint1: CGPointMake(16.76, 1.43) controlPoint2: CGPointMake(5.59, 1.96)];
    [path addCurveToPoint: CGPointMake(0.02, 15.53) controlPoint1: CGPointMake(0.08, 9.42) controlPoint2: CGPointMake(0.14, 12.61)];
    [path addCurveToPoint: CGPointMake(0.02, 59.47) controlPoint1: CGPointMake(-0.01, 31.65) controlPoint2: CGPointMake(-0.01, 43.35)];
    [path addCurveToPoint: CGPointMake(1.85, 68.01) controlPoint1: CGPointMake(0.13, 62.39) controlPoint2: CGPointMake(0.08, 65.58)];
    [path addCurveToPoint: CGPointMake(22.63, 74.11) controlPoint1: CGPointMake(5.57, 73.05) controlPoint2: CGPointMake(16.85, 73.58)];
    [path addCurveToPoint: CGPointMake(69.03, 74.99) controlPoint1: CGPointMake(38.07, 75.13) controlPoint2: CGPointMake(53.57, 74.92)];
    [path addCurveToPoint: CGPointMake(93.97, 75) controlPoint1: CGPointMake(77.35, 75) controlPoint2: CGPointMake(85.66, 75)];
    [path addCurveToPoint: CGPointMake(118.97, 74.99) controlPoint1: CGPointMake(102.3, 75) controlPoint2: CGPointMake(110.63, 75)];
    [path addCurveToPoint: CGPointMake(153.71, 74.68) controlPoint1: CGPointMake(130.55, 74.99) controlPoint2: CGPointMake(142.13, 74.98)];
    [path addCurveToPoint: CGPointMake(176.43, 72.73) controlPoint1: CGPointMake(161.3, 74.39) controlPoint2: CGPointMake(168.94, 74.21)];
    [path addCurveToPoint: CGPointMake(186.16, 68.01) controlPoint1: CGPointMake(179.91, 71.96) controlPoint2: CGPointMake(183.8, 71.08)];
    [path addCurveToPoint: CGPointMake(187.99, 59.47) controlPoint1: CGPointMake(187.92, 65.58) controlPoint2: CGPointMake(187.86, 62.39)];
    [path addCurveToPoint: CGPointMake(187.99, 15.53) controlPoint1: CGPointMake(188, 43.35) controlPoint2: CGPointMake(188, 31.65)];
    [path addCurveToPoint: CGPointMake(186.16, 6.99) controlPoint1: CGPointMake(187.87, 12.61) controlPoint2: CGPointMake(187.92, 9.42)];
    [path addCurveToPoint: CGPointMake(165.38, 0.89) controlPoint1: CGPointMake(182.43, 1.96) controlPoint2: CGPointMake(171.16, 1.42)];
    [path addCurveToPoint: CGPointMake(114.84, 0) controlPoint1: CGPointMake(148.56, -0.21) controlPoint2: CGPointMake(131.69, 0.09)];
    [path closePath];
    [path moveToPoint: CGPointMake(114.83, 7)];
    [path addCurveToPoint: CGPointMake(126.01, 7.02) controlPoint1: CGPointMake(118.56, 7.02) controlPoint2: CGPointMake(122.28, 7.02)];
    [path addCurveToPoint: CGPointMake(164.83, 7.87) controlPoint1: CGPointMake(138.78, 7.03) controlPoint2: CGPointMake(151.98, 7.03)];
    [path addCurveToPoint: CGPointMake(166.34, 8) controlPoint1: CGPointMake(165.3, 7.91) controlPoint2: CGPointMake(165.81, 7.95)];
    [path addCurveToPoint: CGPointMake(175.78, 9.25) controlPoint1: CGPointMake(169.17, 8.24) controlPoint2: CGPointMake(172.69, 8.54)];
    [path addCurveToPoint: CGPointMake(180.51, 11.13) controlPoint1: CGPointMake(179.39, 10.08) controlPoint2: CGPointMake(180.39, 11)];
    [path addCurveToPoint: CGPointMake(180.96, 14.99) controlPoint1: CGPointMake(180.84, 11.69) controlPoint2: CGPointMake(180.92, 13.75)];
    [path addLineToPoint: CGPointMake(180.99, 15.66)];
    [path addCurveToPoint: CGPointMake(180.99, 59.32) controlPoint1: CGPointMake(181, 31.56) controlPoint2: CGPointMake(181, 43.43)];
    [path addCurveToPoint: CGPointMake(180.96, 60.05) controlPoint1: CGPointMake(180.98, 59.56) controlPoint2: CGPointMake(180.97, 59.81)];
    [path addCurveToPoint: CGPointMake(180.53, 63.84) controlPoint1: CGPointMake(180.92, 61.19) controlPoint2: CGPointMake(180.84, 63.27)];
    [path addCurveToPoint: CGPointMake(174.99, 65.88) controlPoint1: CGPointMake(179.65, 64.84) controlPoint2: CGPointMake(177.2, 65.39)];
    [path addCurveToPoint: CGPointMake(155.2, 67.62) controlPoint1: CGPointMake(168.65, 67.12) controlPoint2: CGPointMake(162.12, 67.36)];
    [path addLineToPoint: CGPointMake(153.49, 67.68)];
    [path addCurveToPoint: CGPointMake(118.96, 67.99) controlPoint1: CGPointMake(141.83, 67.98) controlPoint2: CGPointMake(130.21, 67.99)];
    [path addCurveToPoint: CGPointMake(93.97, 68) controlPoint1: CGPointMake(110.63, 68) controlPoint2: CGPointMake(102.3, 68)];
    [path addCurveToPoint: CGPointMake(69.07, 67.99) controlPoint1: CGPointMake(85.66, 68) controlPoint2: CGPointMake(77.35, 68)];
    [path addCurveToPoint: CGPointMake(60.5, 67.97) controlPoint1: CGPointMake(66.21, 67.98) controlPoint2: CGPointMake(63.36, 67.98)];
    [path addCurveToPoint: CGPointMake(23.18, 67.13) controlPoint1: CGPointMake(48.22, 67.96) controlPoint2: CGPointMake(35.53, 67.95)];
    [path addCurveToPoint: CGPointMake(21.66, 67) controlPoint1: CGPointMake(22.7, 67.09) controlPoint2: CGPointMake(22.2, 67.05)];
    [path addCurveToPoint: CGPointMake(12.22, 65.75) controlPoint1: CGPointMake(18.83, 66.76) controlPoint2: CGPointMake(15.31, 66.46)];
    [path addCurveToPoint: CGPointMake(7.49, 63.87) controlPoint1: CGPointMake(8.61, 64.92) controlPoint2: CGPointMake(7.62, 64)];
    [path addCurveToPoint: CGPointMake(7.04, 60.01) controlPoint1: CGPointMake(7.16, 63.31) controlPoint2: CGPointMake(7.08, 61.25)];
    [path addLineToPoint: CGPointMake(7.02, 59.34)];
    [path addCurveToPoint: CGPointMake(7.02, 15.68) controlPoint1: CGPointMake(7, 43.45) controlPoint2: CGPointMake(7, 31.59)];
    [path addCurveToPoint: CGPointMake(7.04, 14.95) controlPoint1: CGPointMake(7.02, 15.44) controlPoint2: CGPointMake(7.03, 15.19)];
    [path addCurveToPoint: CGPointMake(7.48, 11.15) controlPoint1: CGPointMake(7.08, 13.81) controlPoint2: CGPointMake(7.16, 11.7)];
    [path addCurveToPoint: CGPointMake(12.15, 9.27) controlPoint1: CGPointMake(7.63, 10.99) controlPoint2: CGPointMake(8.63, 10.08)];
    [path addCurveToPoint: CGPointMake(21.66, 8) controlPoint1: CGPointMake(15.24, 8.55) controlPoint2: CGPointMake(18.8, 8.25)];
    [path addCurveToPoint: CGPointMake(23.17, 7.87) controlPoint1: CGPointMake(22.19, 7.96) controlPoint2: CGPointMake(22.7, 7.91)];
    [path addCurveToPoint: CGPointMake(62, 7.02) controlPoint1: CGPointMake(36.02, 7.03) controlPoint2: CGPointMake(49.23, 7.03)];
    [path addCurveToPoint: CGPointMake(73.15, 7) controlPoint1: CGPointMake(65.73, 7.02) controlPoint2: CGPointMake(69.46, 7.02)];
    [path addCurveToPoint: CGPointMake(93.96, 7) controlPoint1: CGPointMake(80.09, 7) controlPoint2: CGPointMake(87.03, 7)];
    [path addCurveToPoint: CGPointMake(114.83, 7) controlPoint1: CGPointMake(100.92, 7) controlPoint2: CGPointMake(107.87, 7)];
    [path closePath];
    return path;
}

static UIBezierPath *_TextContentPathAbout(void)
{
    // A
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(50.41, 40.27)];
    [path addLineToPoint: CGPointMake(50.03, 30.15)];
    [path addLineToPoint: CGPointMake(45.83, 40.27)];
    [path addLineToPoint: CGPointMake(50.41, 40.27)];
    [path closePath];
    [path moveToPoint: CGPointMake(46.96, 22.25)];
    [path addLineToPoint: CGPointMake(56.25, 22.25)];
    [path addLineToPoint: CGPointMake(58.35, 51.7)];
    [path addLineToPoint: CGPointMake(50.37, 51.7)];
    [path addLineToPoint: CGPointMake(50.28, 46.37)];
    [path addLineToPoint: CGPointMake(43.64, 46.37)];
    [path addLineToPoint: CGPointMake(41.46, 51.7)];
    [path addLineToPoint: CGPointMake(33.48, 51.7)];
    [path addLineToPoint: CGPointMake(46.96, 22.25)];
    [path closePath];

    // B
    [path moveToPoint: CGPointMake(71.95, 27.97)];
    [path addLineToPoint: CGPointMake(70.73, 34.35)];
    [path addLineToPoint: CGPointMake(71.95, 34.35)];
    [path addCurveToPoint: CGPointMake(75.77, 30.4) controlPoint1: CGPointMake(74.26, 34.35) controlPoint2: CGPointMake(75.77, 32.5)];
    [path addCurveToPoint: CGPointMake(73.21, 27.97) controlPoint1: CGPointMake(75.77, 28.85) controlPoint2: CGPointMake(74.85, 27.97)];
    [path addLineToPoint: CGPointMake(71.95, 27.97)];
    [path closePath];
    [path moveToPoint: CGPointMake(69.81, 39.35)];
    [path addLineToPoint: CGPointMake(68.51, 46.11)];
    [path addLineToPoint: CGPointMake(69.77, 46.11)];
    [path addCurveToPoint: CGPointMake(73.76, 41.83) controlPoint1: CGPointMake(72.12, 46.11) controlPoint2: CGPointMake(73.76, 44.31)];
    [path addCurveToPoint: CGPointMake(70.98, 39.35) controlPoint1: CGPointMake(73.76, 40.19) controlPoint2: CGPointMake(72.75, 39.35)];
    [path addLineToPoint: CGPointMake(69.81, 39.35)];
    [path closePath];
    [path moveToPoint: CGPointMake(69.43, 51.7)];
    [path addLineToPoint: CGPointMake(60.06, 51.7)];
    [path addLineToPoint: CGPointMake(65.73, 22.29)];
    [path addLineToPoint: CGPointMake(74.22, 22.29)];
    [path addCurveToPoint: CGPointMake(83.08, 29.14) controlPoint1: CGPointMake(80.27, 22.29) controlPoint2: CGPointMake(83.08, 25.03)];
    [path addCurveToPoint: CGPointMake(77.92, 36.66) controlPoint1: CGPointMake(83.08, 32.38) controlPoint2: CGPointMake(81.32, 35.19)];
    [path addCurveToPoint: CGPointMake(81.23, 42.42) controlPoint1: CGPointMake(80.1, 37.84) controlPoint2: CGPointMake(81.23, 39.85)];
    [path addCurveToPoint: CGPointMake(69.43, 51.7) controlPoint1: CGPointMake(81.23, 48.05) controlPoint2: CGPointMake(76.82, 51.7)];
    [path closePath];

    // O
    [path moveToPoint: CGPointMake(98.87, 37.21)];
    [path addCurveToPoint: CGPointMake(99.46, 32.33) controlPoint1: CGPointMake(99.34, 34.64) controlPoint2: CGPointMake(99.46, 33.26)];
    [path addCurveToPoint: CGPointMake(96.81, 28.47) controlPoint1: CGPointMake(99.46, 29.73) controlPoint2: CGPointMake(98.37, 28.47)];
    [path addCurveToPoint: CGPointMake(91.82, 36.79) controlPoint1: CGPointMake(94.72, 28.47) controlPoint2: CGPointMake(92.87, 31.24)];
    [path addCurveToPoint: CGPointMake(91.23, 41.66) controlPoint1: CGPointMake(91.35, 39.35) controlPoint2: CGPointMake(91.23, 40.78)];
    [path addCurveToPoint: CGPointMake(93.87, 45.52) controlPoint1: CGPointMake(91.23, 44.26) controlPoint2: CGPointMake(92.32, 45.52)];
    [path addCurveToPoint: CGPointMake(98.87, 37.21) controlPoint1: CGPointMake(95.98, 45.52) controlPoint2: CGPointMake(97.82, 42.75)];
    [path closePath];
    [path moveToPoint: CGPointMake(83.67, 41.24)];
    [path addCurveToPoint: CGPointMake(97.15, 21.71) controlPoint1: CGPointMake(83.67, 30.07) controlPoint2: CGPointMake(89.21, 21.71)];
    [path addCurveToPoint: CGPointMake(107.02, 32.75) controlPoint1: CGPointMake(103.54, 21.71) controlPoint2: CGPointMake(107.02, 26.2)];
    [path addCurveToPoint: CGPointMake(93.54, 52.29) controlPoint1: CGPointMake(107.02, 43.93) controlPoint2: CGPointMake(101.44, 52.29)];
    [path addCurveToPoint: CGPointMake(83.67, 41.24) controlPoint1: CGPointMake(87.15, 52.29) controlPoint2: CGPointMake(83.67, 47.79)];
    [path closePath];

    // U
    [path moveToPoint: CGPointMake(111.93, 22.3)];
    [path addLineToPoint: CGPointMake(119.66, 22.3)];
    [path addLineToPoint: CGPointMake(116.09, 41.32)];
    [path addCurveToPoint: CGPointMake(115.92, 43.05) controlPoint1: CGPointMake(115.97, 41.96) controlPoint2: CGPointMake(115.92, 42.5)];
    [path addCurveToPoint: CGPointMake(118.19, 45.48) controlPoint1: CGPointMake(115.92, 44.64) controlPoint2: CGPointMake(116.72, 45.48)];
    [path addCurveToPoint: CGPointMake(121.51, 41.79) controlPoint1: CGPointMake(119.83, 45.48) controlPoint2: CGPointMake(121.01, 44.31)];
    [path addLineToPoint: CGPointMake(125.17, 22.3)];
    [path addLineToPoint: CGPointMake(132.73, 22.3)];
    [path addLineToPoint: CGPointMake(129.03, 41.83)];
    [path addCurveToPoint: CGPointMake(117.31, 52.25) controlPoint1: CGPointMake(127.69, 48.8) controlPoint2: CGPointMake(123.78, 52.25)];
    [path addCurveToPoint: CGPointMake(108.19, 43.55) controlPoint1: CGPointMake(111.39, 52.25) controlPoint2: CGPointMake(108.19, 49.05)];
    [path addCurveToPoint: CGPointMake(108.57, 40.02) controlPoint1: CGPointMake(108.19, 42.46) controlPoint2: CGPointMake(108.36, 41.28)];
    [path addLineToPoint: CGPointMake(111.93, 22.3)];
    [path closePath];

    // T
    [path moveToPoint: CGPointMake(147.51, 29.02)];
    [path addLineToPoint: CGPointMake(143.14, 51.7)];
    [path addLineToPoint: CGPointMake(135.37, 51.7)];
    [path addLineToPoint: CGPointMake(139.74, 29.02)];
    [path addLineToPoint: CGPointMake(133.56, 29.02)];
    [path addLineToPoint: CGPointMake(134.91, 22.3)];
    [path addLineToPoint: CGPointMake(154.95, 22.3)];
    [path addLineToPoint: CGPointMake(153.6, 29.02)];
    [path addLineToPoint: CGPointMake(147.51, 29.02)];
    [path closePath];
    
    return path;
}

static UIBezierPath *_TextContentPathExtras(void)
{
    // E
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(33.56, 22.3)];
    [path addLineToPoint: CGPointMake(49.61, 22.3)];
    [path addLineToPoint: CGPointMake(48.35, 28.85)];
    [path addLineToPoint: CGPointMake(39.91, 28.85)];
    [path addLineToPoint: CGPointMake(38.94, 33.8)];
    [path addLineToPoint: CGPointMake(46.17, 33.8)];
    [path addLineToPoint: CGPointMake(44.95, 39.94)];
    [path addLineToPoint: CGPointMake(37.76, 39.94)];
    [path addLineToPoint: CGPointMake(36.76, 45.15)];
    [path addLineToPoint: CGPointMake(45.7, 45.15)];
    [path addLineToPoint: CGPointMake(43.69, 51.7)];
    [path addLineToPoint: CGPointMake(27.89, 51.7)];
    [path addLineToPoint: CGPointMake(33.56, 22.3)];
    [path closePath];

    // X
    [path moveToPoint: CGPointMake(58.89, 42.46)];
    [path addLineToPoint: CGPointMake(53.76, 51.7)];
    [path addLineToPoint: CGPointMake(45.45, 51.7)];
    [path addLineToPoint: CGPointMake(45.45, 51.57)];
    [path addLineToPoint: CGPointMake(55.07, 36.45)];
    [path addLineToPoint: CGPointMake(51.33, 22.29)];
    [path addLineToPoint: CGPointMake(59.56, 22.29)];
    [path addLineToPoint: CGPointMake(61.2, 30.91)];
    [path addLineToPoint: CGPointMake(65.91, 22.29)];
    [path addLineToPoint: CGPointMake(74.18, 22.29)];
    [path addLineToPoint: CGPointMake(74.18, 22.38)];
    [path addLineToPoint: CGPointMake(64.98, 37)];
    [path addLineToPoint: CGPointMake(68.89, 51.7)];
    [path addLineToPoint: CGPointMake(60.65, 51.7)];
    [path addLineToPoint: CGPointMake(58.89, 42.46)];
    [path closePath];

    // T
    [path moveToPoint: CGPointMake(87.95, 29.02)];
    [path addLineToPoint: CGPointMake(83.59, 51.7)];
    [path addLineToPoint: CGPointMake(75.81, 51.7)];
    [path addLineToPoint: CGPointMake(80.18, 29.02)];
    [path addLineToPoint: CGPointMake(74.01, 29.02)];
    [path addLineToPoint: CGPointMake(75.35, 22.3)];
    [path addLineToPoint: CGPointMake(95.39, 22.3)];
    [path addLineToPoint: CGPointMake(94.05, 29.02)];
    [path addLineToPoint: CGPointMake(87.95, 29.02)];
    [path closePath];

    // R
    [path moveToPoint: CGPointMake(104.12, 28.22)];
    [path addLineToPoint: CGPointMake(102.57, 36.24)];
    [path addLineToPoint: CGPointMake(103.37, 36.24)];
    [path addCurveToPoint: CGPointMake(107.61, 31.03) controlPoint1: CGPointMake(106.06, 36.24) controlPoint2: CGPointMake(107.61, 33.76)];
    [path addCurveToPoint: CGPointMake(104.84, 28.22) controlPoint1: CGPointMake(107.61, 29.18) controlPoint2: CGPointMake(106.77, 28.22)];
    [path addLineToPoint: CGPointMake(104.12, 28.22)];
    [path closePath];
    [path moveToPoint: CGPointMake(102.15, 41.11)];
    [path addLineToPoint: CGPointMake(101.69, 41.11)];
    [path addLineToPoint: CGPointMake(99.67, 51.7)];
    [path addLineToPoint: CGPointMake(91.94, 51.7)];
    [path addLineToPoint: CGPointMake(97.61, 22.3)];
    [path addLineToPoint: CGPointMake(105.76, 22.3)];
    [path addCurveToPoint: CGPointMake(115.3, 30.4) controlPoint1: CGPointMake(112.02, 22.3) controlPoint2: CGPointMake(115.3, 25.24)];
    [path addCurveToPoint: CGPointMake(109.37, 39.73) controlPoint1: CGPointMake(115.3, 34.77) controlPoint2: CGPointMake(112.78, 38.01)];
    [path addLineToPoint: CGPointMake(113.28, 51.7)];
    [path addLineToPoint: CGPointMake(105.17, 51.7)];
    [path addLineToPoint: CGPointMake(102.15, 41.11)];
    [path closePath];

    // A
    [path moveToPoint: CGPointMake(129.74, 40.27)];
    [path addLineToPoint: CGPointMake(129.36, 30.15)];
    [path addLineToPoint: CGPointMake(125.16, 40.27)];
    [path addLineToPoint: CGPointMake(129.74, 40.27)];
    [path closePath];
    [path moveToPoint: CGPointMake(126.3, 22.25)];
    [path addLineToPoint: CGPointMake(135.58, 22.25)];
    [path addLineToPoint: CGPointMake(137.68, 51.7)];
    [path addLineToPoint: CGPointMake(129.7, 51.7)];
    [path addLineToPoint: CGPointMake(129.62, 46.37)];
    [path addLineToPoint: CGPointMake(122.98, 46.37)];
    [path addLineToPoint: CGPointMake(120.8, 51.7)];
    [path addLineToPoint: CGPointMake(112.81, 51.7)];
    [path addLineToPoint: CGPointMake(126.3, 22.25)];
    [path closePath];

    // S
    [path moveToPoint: CGPointMake(159.56, 24.1)];
    [path addLineToPoint: CGPointMake(158.89, 31.29)];
    [path addLineToPoint: CGPointMake(158.77, 31.29)];
    [path addCurveToPoint: CGPointMake(152.34, 28.22) controlPoint1: CGPointMake(156.75, 29.52) controlPoint2: CGPointMake(154.36, 28.22)];
    [path addCurveToPoint: CGPointMake(150.28, 29.9) controlPoint1: CGPointMake(151.12, 28.22) controlPoint2: CGPointMake(150.28, 28.85)];
    [path addCurveToPoint: CGPointMake(152.89, 33.85) controlPoint1: CGPointMake(150.28, 30.86) controlPoint2: CGPointMake(150.95, 31.91)];
    [path addCurveToPoint: CGPointMake(157.42, 42.79) controlPoint1: CGPointMake(156.2, 36.96) controlPoint2: CGPointMake(157.42, 39.64)];
    [path addCurveToPoint: CGPointMake(147.63, 52.25) controlPoint1: CGPointMake(157.42, 48.59) controlPoint2: CGPointMake(153.68, 52.25)];
    [path addCurveToPoint: CGPointMake(139.65, 49.64) controlPoint1: CGPointMake(144.36, 52.25) controlPoint2: CGPointMake(141.42, 51.11)];
    [path addLineToPoint: CGPointMake(139.91, 41.79)];
    [path addLineToPoint: CGPointMake(140.03, 41.75)];
    [path addCurveToPoint: CGPointMake(147.3, 45.78) controlPoint1: CGPointMake(142.43, 44.27) controlPoint2: CGPointMake(145.2, 45.78)];
    [path addCurveToPoint: CGPointMake(149.61, 43.85) controlPoint1: CGPointMake(148.77, 45.78) controlPoint2: CGPointMake(149.61, 44.98)];
    [path addCurveToPoint: CGPointMake(147.26, 39.9) controlPoint1: CGPointMake(149.61, 42.67) controlPoint2: CGPointMake(148.89, 41.49)];
    [path addCurveToPoint: CGPointMake(142.51, 30.78) controlPoint1: CGPointMake(143.64, 36.45) controlPoint2: CGPointMake(142.51, 33.93)];
    [path addCurveToPoint: CGPointMake(152.09, 21.75) controlPoint1: CGPointMake(142.51, 25.53) controlPoint2: CGPointMake(146.25, 21.75)];
    [path addCurveToPoint: CGPointMake(159.56, 24.1) controlPoint1: CGPointMake(155.03, 21.75) controlPoint2: CGPointMake(157.72, 22.67)];
    [path closePath];

    return path;
}

static UIBezierPath *_TextContentPathMenu(void)
{
    // M
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(60.66, 36.49)];
    [path addLineToPoint: CGPointMake(67, 22.29)];
    [path addLineToPoint: CGPointMake(77.42, 22.29)];
    [path addLineToPoint: CGPointMake(72.46, 51.7)];
    [path addLineToPoint: CGPointMake(65.07, 51.7)];
    [path addLineToPoint: CGPointMake(68.47, 32.04)];
    [path addLineToPoint: CGPointMake(58.85, 51.83)];
    [path addLineToPoint: CGPointMake(56.54, 51.83)];
    [path addLineToPoint: CGPointMake(54.56, 32.08)];
    [path addLineToPoint: CGPointMake(50.45, 51.7)];
    [path addLineToPoint: CGPointMake(43.35, 51.7)];
    [path addLineToPoint: CGPointMake(49.65, 22.29)];
    [path addLineToPoint: CGPointMake(59.77, 22.29)];
    [path addLineToPoint: CGPointMake(60.66, 36.49)];
    [path closePath];

    // E
    [path moveToPoint: CGPointMake(80.98, 22.3)];
    [path addLineToPoint: CGPointMake(97.03, 22.3)];
    [path addLineToPoint: CGPointMake(95.77, 28.85)];
    [path addLineToPoint: CGPointMake(87.32, 28.85)];
    [path addLineToPoint: CGPointMake(86.36, 33.8)];
    [path addLineToPoint: CGPointMake(93.58, 33.8)];
    [path addLineToPoint: CGPointMake(92.37, 39.94)];
    [path addLineToPoint: CGPointMake(85.18, 39.94)];
    [path addLineToPoint: CGPointMake(84.17, 45.15)];
    [path addLineToPoint: CGPointMake(93.12, 45.15)];
    [path addLineToPoint: CGPointMake(91.11, 51.7)];
    [path addLineToPoint: CGPointMake(75.31, 51.7)];
    [path addLineToPoint: CGPointMake(80.98, 22.3)];
    [path closePath];

    // N
    [path moveToPoint: CGPointMake(99.92, 22.3)];
    [path addLineToPoint: CGPointMake(107.02, 22.3)];
    [path addLineToPoint: CGPointMake(111.31, 36.45)];
    [path addLineToPoint: CGPointMake(113.95, 22.3)];
    [path addLineToPoint: CGPointMake(121.01, 22.3)];
    [path addLineToPoint: CGPointMake(115.38, 51.74)];
    [path addLineToPoint: CGPointMake(109.29, 51.74)];
    [path addLineToPoint: CGPointMake(104.33, 35.61)];
    [path addLineToPoint: CGPointMake(101.35, 51.7)];
    [path addLineToPoint: CGPointMake(94.25, 51.7)];
    [path addLineToPoint: CGPointMake(99.92, 22.3)];
    [path closePath];

    // U
    [path moveToPoint: CGPointMake(124.07, 22.3)];
    [path addLineToPoint: CGPointMake(131.8, 22.3)];
    [path addLineToPoint: CGPointMake(128.23, 41.32)];
    [path addCurveToPoint: CGPointMake(128.06, 43.05) controlPoint1: CGPointMake(128.1, 41.96) controlPoint2: CGPointMake(128.06, 42.5)];
    [path addCurveToPoint: CGPointMake(130.33, 45.48) controlPoint1: CGPointMake(128.06, 44.64) controlPoint2: CGPointMake(128.86, 45.48)];
    [path addCurveToPoint: CGPointMake(133.65, 41.79) controlPoint1: CGPointMake(131.97, 45.48) controlPoint2: CGPointMake(133.15, 44.31)];
    [path addLineToPoint: CGPointMake(137.3, 22.3)];
    [path addLineToPoint: CGPointMake(144.87, 22.3)];
    [path addLineToPoint: CGPointMake(141.17, 41.83)];
    [path addCurveToPoint: CGPointMake(129.45, 52.25) controlPoint1: CGPointMake(139.82, 48.8) controlPoint2: CGPointMake(135.92, 52.25)];
    [path addCurveToPoint: CGPointMake(120.33, 43.55) controlPoint1: CGPointMake(123.53, 52.25) controlPoint2: CGPointMake(120.33, 49.05)];
    [path addCurveToPoint: CGPointMake(120.71, 40.02) controlPoint1: CGPointMake(120.33, 42.46) controlPoint2: CGPointMake(120.5, 41.28)];
    [path addLineToPoint: CGPointMake(124.07, 22.3)];
    [path closePath];

    return path;
}

static UIBezierPath *_TextContentPathPlay(void)
{
    // P
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(63.3, 28.47)];
    [path addLineToPoint: CGPointMake(61.66, 36.83)];
    [path addLineToPoint: CGPointMake(62.59, 36.83)];
    [path addCurveToPoint: CGPointMake(66.79, 31.07) controlPoint1: CGPointMake(65.02, 36.83) controlPoint2: CGPointMake(66.79, 34.39)];
    [path addCurveToPoint: CGPointMake(64.14, 28.47) controlPoint1: CGPointMake(66.79, 29.48) controlPoint2: CGPointMake(65.99, 28.47)];
    [path addLineToPoint: CGPointMake(63.3, 28.47)];
    [path closePath];
    [path moveToPoint: CGPointMake(60.61, 42.79)];
    [path addLineToPoint: CGPointMake(58.89, 51.7)];
    [path addLineToPoint: CGPointMake(51.12, 51.7)];
    [path addLineToPoint: CGPointMake(56.79, 22.3)];
    [path addLineToPoint: CGPointMake(64.98, 22.3)];
    [path addCurveToPoint: CGPointMake(74.43, 30.82) controlPoint1: CGPointMake(71.49, 22.3) controlPoint2: CGPointMake(74.43, 25.91)];
    [path addCurveToPoint: CGPointMake(62.04, 42.79) controlPoint1: CGPointMake(74.43, 37.8) controlPoint2: CGPointMake(69.73, 42.79)];
    [path addLineToPoint: CGPointMake(60.61, 42.79)];
    [path closePath];

    // L
    [path moveToPoint: CGPointMake(88.21, 51.7)];
    [path addLineToPoint: CGPointMake(72.71, 51.7)];
    [path addLineToPoint: CGPointMake(78.38, 22.3)];
    [path addLineToPoint: CGPointMake(86.11, 22.3)];
    [path addLineToPoint: CGPointMake(81.78, 44.98)];
    [path addLineToPoint: CGPointMake(89.51, 44.98)];
    [path addLineToPoint: CGPointMake(88.21, 51.7)];
    [path closePath];

    // A
    [path moveToPoint: CGPointMake(106.27, 40.27)];
    [path addLineToPoint: CGPointMake(105.89, 30.15)];
    [path addLineToPoint: CGPointMake(101.69, 40.27)];
    [path addLineToPoint: CGPointMake(106.27, 40.27)];
    [path closePath];
    [path moveToPoint: CGPointMake(102.82, 22.25)];
    [path addLineToPoint: CGPointMake(112.11, 22.25)];
    [path addLineToPoint: CGPointMake(114.21, 51.7)];
    [path addLineToPoint: CGPointMake(106.22, 51.7)];
    [path addLineToPoint: CGPointMake(106.14, 46.37)];
    [path addLineToPoint: CGPointMake(99.5, 46.37)];
    [path addLineToPoint: CGPointMake(97.32, 51.7)];
    [path addLineToPoint: CGPointMake(89.34, 51.7)];
    [path addLineToPoint: CGPointMake(102.82, 22.25)];
    [path closePath];

    // Y
    [path moveToPoint: CGPointMake(128.06, 40.82)];
    [path addLineToPoint: CGPointMake(125.96, 51.7)];
    [path addLineToPoint: CGPointMake(118.23, 51.7)];
    [path addLineToPoint: CGPointMake(120.34, 40.82)];
    [path addLineToPoint: CGPointMake(116.26, 22.3)];
    [path addLineToPoint: CGPointMake(124.24, 22.3)];
    [path addLineToPoint: CGPointMake(125.67, 33.01)];
    [path addLineToPoint: CGPointMake(131.09, 22.3)];
    [path addLineToPoint: CGPointMake(139.2, 22.3)];
    [path addLineToPoint: CGPointMake(139.2, 22.38)];
    [path addLineToPoint: CGPointMake(128.06, 40.82)];
    [path closePath];
    
    return path;
}

static UIBezierPath *_TextContentPathQuit(void)
{
    // Q
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(69.83, 37.21)];
    [path addCurveToPoint: CGPointMake(70.42, 32.33) controlPoint1: CGPointMake(70.29, 34.64) controlPoint2: CGPointMake(70.42, 33.26)];
    [path addCurveToPoint: CGPointMake(67.77, 28.47) controlPoint1: CGPointMake(70.42, 29.73) controlPoint2: CGPointMake(69.33, 28.47)];
    [path addCurveToPoint: CGPointMake(62.77, 36.79) controlPoint1: CGPointMake(65.67, 28.47) controlPoint2: CGPointMake(63.82, 31.24)];
    [path addCurveToPoint: CGPointMake(62.19, 41.66) controlPoint1: CGPointMake(62.31, 39.35) controlPoint2: CGPointMake(62.19, 40.78)];
    [path addCurveToPoint: CGPointMake(64.83, 45.52) controlPoint1: CGPointMake(62.19, 44.26) controlPoint2: CGPointMake(63.28, 45.52)];
    [path addCurveToPoint: CGPointMake(69.83, 37.21) controlPoint1: CGPointMake(66.93, 45.52) controlPoint2: CGPointMake(68.78, 42.75)];
    [path closePath];
    [path moveToPoint: CGPointMake(68.53, 56.83)];
    [path addCurveToPoint: CGPointMake(61.18, 51.57) controlPoint1: CGPointMake(65.42, 56.83) controlPoint2: CGPointMake(62.77, 55.98)];
    [path addCurveToPoint: CGPointMake(54.62, 41.24) controlPoint1: CGPointMake(56.94, 50.27) controlPoint2: CGPointMake(54.62, 46.49)];
    [path addCurveToPoint: CGPointMake(68.11, 21.71) controlPoint1: CGPointMake(54.62, 30.07) controlPoint2: CGPointMake(60.17, 21.71)];
    [path addCurveToPoint: CGPointMake(77.98, 32.75) controlPoint1: CGPointMake(74.49, 21.71) controlPoint2: CGPointMake(77.98, 26.2)];
    [path addCurveToPoint: CGPointMake(69.29, 50.65) controlPoint1: CGPointMake(77.98, 41.32) controlPoint2: CGPointMake(74.58, 48.13)];
    [path addCurveToPoint: CGPointMake(71.64, 51.83) controlPoint1: CGPointMake(69.87, 51.49) controlPoint2: CGPointMake(70.63, 51.83)];
    [path addCurveToPoint: CGPointMake(74.41, 50.99) controlPoint1: CGPointMake(72.52, 51.83) controlPoint2: CGPointMake(73.53, 51.45)];
    [path addLineToPoint: CGPointMake(74.49, 51.11)];
    [path addLineToPoint: CGPointMake(72.18, 56.03)];
    [path addCurveToPoint: CGPointMake(68.53, 56.83) controlPoint1: CGPointMake(71.18, 56.49) controlPoint2: CGPointMake(69.92, 56.83)];
    [path closePath];

    // U
    [path moveToPoint: CGPointMake(82.89, 22.3)];
    [path addLineToPoint: CGPointMake(90.62, 22.3)];
    [path addLineToPoint: CGPointMake(87.05, 41.32)];
    [path addCurveToPoint: CGPointMake(86.88, 43.05) controlPoint1: CGPointMake(86.92, 41.96) controlPoint2: CGPointMake(86.88, 42.5)];
    [path addCurveToPoint: CGPointMake(89.15, 45.48) controlPoint1: CGPointMake(86.88, 44.64) controlPoint2: CGPointMake(87.68, 45.48)];
    [path addCurveToPoint: CGPointMake(92.47, 41.79) controlPoint1: CGPointMake(90.79, 45.48) controlPoint2: CGPointMake(91.96, 44.31)];
    [path addLineToPoint: CGPointMake(96.12, 22.3)];
    [path addLineToPoint: CGPointMake(103.69, 22.3)];
    [path addLineToPoint: CGPointMake(99.99, 41.83)];
    [path addCurveToPoint: CGPointMake(88.27, 52.25) controlPoint1: CGPointMake(98.64, 48.8) controlPoint2: CGPointMake(94.74, 52.25)];
    [path addCurveToPoint: CGPointMake(79.15, 43.55) controlPoint1: CGPointMake(82.35, 52.25) controlPoint2: CGPointMake(79.15, 49.05)];
    [path addCurveToPoint: CGPointMake(79.53, 40.02) controlPoint1: CGPointMake(79.15, 42.46) controlPoint2: CGPointMake(79.32, 41.28)];
    [path addLineToPoint: CGPointMake(82.89, 22.3)];
    [path closePath];

    // I
    [path moveToPoint: CGPointMake(106.87, 22.3)];
    [path addLineToPoint: CGPointMake(114.64, 22.3)];
    [path addLineToPoint: CGPointMake(108.97, 51.7)];
    [path addLineToPoint: CGPointMake(101.24, 51.7)];
    [path addLineToPoint: CGPointMake(106.87, 22.3)];
    [path closePath];

    // T
    [path moveToPoint: CGPointMake(129.6, 29.02)];
    [path addLineToPoint: CGPointMake(125.23, 51.7)];
    [path addLineToPoint: CGPointMake(117.46, 51.7)];
    [path addLineToPoint: CGPointMake(121.83, 29.02)];
    [path addLineToPoint: CGPointMake(115.65, 29.02)];
    [path addLineToPoint: CGPointMake(117, 22.3)];
    [path addLineToPoint: CGPointMake(137.03, 22.3)];
    [path addLineToPoint: CGPointMake(135.69, 29.02)];
    [path addLineToPoint: CGPointMake(129.6, 29.02)];
    [path closePath];

    return path;
}

static UIBezierPath *_TextContentPathResume(void)
{
    // R
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(37.83, 28.22)];
    [path addLineToPoint: CGPointMake(36.27, 36.24)];
    [path addLineToPoint: CGPointMake(37.07, 36.24)];
    [path addCurveToPoint: CGPointMake(41.31, 31.03) controlPoint1: CGPointMake(39.76, 36.24) controlPoint2: CGPointMake(41.31, 33.76)];
    [path addCurveToPoint: CGPointMake(38.54, 28.22) controlPoint1: CGPointMake(41.31, 29.18) controlPoint2: CGPointMake(40.47, 28.22)];
    [path addLineToPoint: CGPointMake(37.83, 28.22)];
    [path closePath];
    [path moveToPoint: CGPointMake(35.85, 41.11)];
    [path addLineToPoint: CGPointMake(35.39, 41.11)];
    [path addLineToPoint: CGPointMake(33.37, 51.7)];
    [path addLineToPoint: CGPointMake(25.64, 51.7)];
    [path addLineToPoint: CGPointMake(31.32, 22.3)];
    [path addLineToPoint: CGPointMake(39.47, 22.3)];
    [path addCurveToPoint: CGPointMake(49, 30.4) controlPoint1: CGPointMake(45.72, 22.3) controlPoint2: CGPointMake(49, 25.24)];
    [path addCurveToPoint: CGPointMake(43.08, 39.73) controlPoint1: CGPointMake(49, 34.77) controlPoint2: CGPointMake(46.48, 38.01)];
    [path addLineToPoint: CGPointMake(46.98, 51.7)];
    [path addLineToPoint: CGPointMake(38.88, 51.7)];
    [path addLineToPoint: CGPointMake(35.85, 41.11)];
    [path closePath];

    // E
    [path moveToPoint: CGPointMake(53.83, 22.3)];
    [path addLineToPoint: CGPointMake(69.87, 22.3)];
    [path addLineToPoint: CGPointMake(68.61, 28.85)];
    [path addLineToPoint: CGPointMake(60.17, 28.85)];
    [path addLineToPoint: CGPointMake(59.2, 33.8)];
    [path addLineToPoint: CGPointMake(66.43, 33.8)];
    [path addLineToPoint: CGPointMake(65.21, 39.94)];
    [path addLineToPoint: CGPointMake(58.03, 39.94)];
    [path addLineToPoint: CGPointMake(57.02, 45.15)];
    [path addLineToPoint: CGPointMake(65.97, 45.15)];
    [path addLineToPoint: CGPointMake(63.95, 51.7)];
    [path addLineToPoint: CGPointMake(48.16, 51.7)];
    [path addLineToPoint: CGPointMake(53.83, 22.3)];
    [path closePath];

    // S
    [path moveToPoint: CGPointMake(87.64, 24.1)];
    [path addLineToPoint: CGPointMake(86.97, 31.29)];
    [path addLineToPoint: CGPointMake(86.84, 31.29)];
    [path addCurveToPoint: CGPointMake(80.41, 28.22) controlPoint1: CGPointMake(84.83, 29.52) controlPoint2: CGPointMake(82.43, 28.22)];
    [path addCurveToPoint: CGPointMake(78.36, 29.9) controlPoint1: CGPointMake(79.2, 28.22) controlPoint2: CGPointMake(78.36, 28.85)];
    [path addCurveToPoint: CGPointMake(80.96, 33.85) controlPoint1: CGPointMake(78.36, 30.86) controlPoint2: CGPointMake(79.03, 31.91)];
    [path addCurveToPoint: CGPointMake(85.5, 42.79) controlPoint1: CGPointMake(84.28, 36.96) controlPoint2: CGPointMake(85.5, 39.64)];
    [path addCurveToPoint: CGPointMake(75.71, 52.25) controlPoint1: CGPointMake(85.5, 48.59) controlPoint2: CGPointMake(81.76, 52.25)];
    [path addCurveToPoint: CGPointMake(67.73, 49.64) controlPoint1: CGPointMake(72.43, 52.25) controlPoint2: CGPointMake(69.49, 51.11)];
    [path addLineToPoint: CGPointMake(67.98, 41.79)];
    [path addLineToPoint: CGPointMake(68.11, 41.75)];
    [path addCurveToPoint: CGPointMake(75.37, 45.78) controlPoint1: CGPointMake(70.5, 44.27) controlPoint2: CGPointMake(73.27, 45.78)];
    [path addCurveToPoint: CGPointMake(77.68, 43.85) controlPoint1: CGPointMake(76.84, 45.78) controlPoint2: CGPointMake(77.68, 44.98)];
    [path addCurveToPoint: CGPointMake(75.33, 39.9) controlPoint1: CGPointMake(77.68, 42.67) controlPoint2: CGPointMake(76.97, 41.49)];
    [path addCurveToPoint: CGPointMake(70.58, 30.78) controlPoint1: CGPointMake(71.72, 36.45) controlPoint2: CGPointMake(70.58, 33.93)];
    [path addCurveToPoint: CGPointMake(80.16, 21.75) controlPoint1: CGPointMake(70.58, 25.53) controlPoint2: CGPointMake(74.32, 21.75)];
    [path addCurveToPoint: CGPointMake(87.64, 24.1) controlPoint1: CGPointMake(83.1, 21.75) controlPoint2: CGPointMake(85.79, 22.67)];
    [path closePath];

    // U
    [path moveToPoint: CGPointMake(91.46, 22.3)];
    [path addLineToPoint: CGPointMake(99.19, 22.3)];
    [path addLineToPoint: CGPointMake(95.62, 41.32)];
    [path addCurveToPoint: CGPointMake(95.45, 43.05) controlPoint1: CGPointMake(95.49, 41.96) controlPoint2: CGPointMake(95.45, 42.5)];
    [path addCurveToPoint: CGPointMake(97.72, 45.48) controlPoint1: CGPointMake(95.45, 44.64) controlPoint2: CGPointMake(96.25, 45.48)];
    [path addCurveToPoint: CGPointMake(101.04, 41.79) controlPoint1: CGPointMake(99.36, 45.48) controlPoint2: CGPointMake(100.53, 44.31)];
    [path addLineToPoint: CGPointMake(104.69, 22.3)];
    [path addLineToPoint: CGPointMake(112.25, 22.3)];
    [path addLineToPoint: CGPointMake(108.56, 41.83)];
    [path addCurveToPoint: CGPointMake(96.84, 52.25) controlPoint1: CGPointMake(107.21, 48.8) controlPoint2: CGPointMake(103.31, 52.25)];
    [path addCurveToPoint: CGPointMake(87.72, 43.55) controlPoint1: CGPointMake(90.91, 52.25) controlPoint2: CGPointMake(87.72, 49.05)];
    [path addCurveToPoint: CGPointMake(88.1, 40.02) controlPoint1: CGPointMake(87.72, 42.46) controlPoint2: CGPointMake(87.89, 41.28)];
    [path addLineToPoint: CGPointMake(91.46, 22.3)];
    [path closePath];

    // M
    [path moveToPoint: CGPointMake(126.7, 36.49)];
    [path addLineToPoint: CGPointMake(133.04, 22.29)];
    [path addLineToPoint: CGPointMake(143.46, 22.29)];
    [path addLineToPoint: CGPointMake(138.5, 51.7)];
    [path addLineToPoint: CGPointMake(131.11, 51.7)];
    [path addLineToPoint: CGPointMake(134.51, 32.04)];
    [path addLineToPoint: CGPointMake(124.89, 51.83)];
    [path addLineToPoint: CGPointMake(122.58, 51.83)];
    [path addLineToPoint: CGPointMake(120.61, 32.08)];
    [path addLineToPoint: CGPointMake(116.49, 51.7)];
    [path addLineToPoint: CGPointMake(109.39, 51.7)];
    [path addLineToPoint: CGPointMake(115.69, 22.29)];
    [path addLineToPoint: CGPointMake(125.82, 22.29)];
    [path addLineToPoint: CGPointMake(126.7, 36.49)];
    [path closePath];

    // E
    [path moveToPoint: CGPointMake(147.03, 22.3)];
    [path addLineToPoint: CGPointMake(163.07, 22.3)];
    [path addLineToPoint: CGPointMake(161.81, 28.85)];
    [path addLineToPoint: CGPointMake(153.37, 28.85)];
    [path addLineToPoint: CGPointMake(152.4, 33.8)];
    [path addLineToPoint: CGPointMake(159.63, 33.8)];
    [path addLineToPoint: CGPointMake(158.41, 39.94)];
    [path addLineToPoint: CGPointMake(151.23, 39.94)];
    [path addLineToPoint: CGPointMake(150.22, 45.15)];
    [path addLineToPoint: CGPointMake(159.17, 45.15)];
    [path addLineToPoint: CGPointMake(157.15, 51.7)];
    [path addLineToPoint: CGPointMake(141.35, 51.7)];
    [path addLineToPoint: CGPointMake(147.03, 22.3)];
    [path closePath];

    return path;
}

@implementation UPControl (UPSpell)

+ (UPControl *)roundButtonPause
{
    UPControl *control = [UPControl control];
    control.canonicalSize = UP::SpellLayout::CanonicalRoundButtonSize;
    [control setFillPath:_RoundControlButtonFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setStrokePath:_RoundControlButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    [control setContentPath:_RoundControlButtonPauseIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundButtonTrash
{
    UPControl *control = [UPControl control];
    control.canonicalSize = UP::SpellLayout::CanonicalRoundButtonSize;
    [control setFillPath:_RoundControlButtonFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setStrokePath:_RoundControlButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    [control setContentPath:_RoundControlButtonTrashIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundButtonClear
{
    UPControl *control = [UPControl control];
    control.canonicalSize = UP::SpellLayout::CanonicalRoundButtonSize;
    [control setFillPath:_RoundControlButtonFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setStrokePath:_RoundControlButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    [control setContentPath:_RoundControlButtonDownArrowIconPath() forState:UPControlStateNormal];
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
    [control setContentPath:_TextContentPathAbout() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonExtras
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:_TextContentPathExtras() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonMenu
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:_TextContentPathMenu() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonPlay
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:_TextContentPathPlay() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonQuit
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:_TextContentPathQuit() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)textButtonResume
{
    UPControl *control = [UPControl _textButton];
    [control setContentPath:_TextContentPathResume() forState:UPControlStateNormal];
    return control;
}

@end
