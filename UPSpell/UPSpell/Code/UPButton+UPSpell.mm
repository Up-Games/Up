//
//  UPButton+UPSpell.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import "UPButton+UPSpell.h"
#import "UPSpellLayoutManager.h"

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

static UIBezierPath *_RoundControlButtonPauseIconPath(void)
{
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(14, 37.5, 56, 9) cornerRadius:4.5];
}

static UIBezierPath *_RoundControlButtonTrashIconPath(void)
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
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

static UIBezierPath *_WordTrayFillPath(void)
{
    UIBezierPath* path = [UIBezierPath bezierPath];
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
   UIBezierPath* path = [UIBezierPath bezierPath];
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

@implementation UPButton (UPSpell)

+ (UPButton *)roundControlButtonPause
{
    UPButton *button = [UPButton button];
    button.canonicalSize = UP::SpellLayoutManager::CanonicalRoundControlButtonSize;
    [button setFillPath:_RoundControlButtonFillPath() forControlStates:UIControlStateNormal];
    [button setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forControlStates:UIControlStateNormal];
    [button setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forControlStates:UIControlStateHighlighted];
    [button setStrokePath:_RoundControlButtonStrokePath() forControlStates:UIControlStateNormal];
    [button setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forControlStates:UIControlStateNormal];
    [button setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forControlStates:UIControlStateHighlighted];
    [button setContentPath:_RoundControlButtonPauseIconPath() forControlStates:UIControlStateNormal];
    return button;
}

+ (UPButton *)roundControlButtonTrash
{
    UPButton *button = [UPButton button];
    button.canonicalSize = UP::SpellLayoutManager::CanonicalRoundControlButtonSize;
    [button setFillPath:_RoundControlButtonFillPath() forControlStates:UIControlStateNormal];
    [button setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forControlStates:UIControlStateNormal];
    [button setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forControlStates:UIControlStateHighlighted];
    [button setStrokePath:_RoundControlButtonStrokePath() forControlStates:UIControlStateNormal];
    [button setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forControlStates:UIControlStateNormal];
    [button setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forControlStates:UIControlStateHighlighted];
    [button setContentPath:_RoundControlButtonTrashIconPath() forControlStates:UIControlStateNormal];
    return button;
}

+ (UPButton *)wordTray
{
    UPButton *button = [UPButton button];
    button.canonicalSize = UP::SpellLayoutManager::CanonicalWordTrayFrame.size;
    [button setFillPath:_WordTrayFillPath() forControlStates:UIControlStateNormal];
    [button setFillColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryInactiveFill] forControlStates:UIControlStateNormal];
    [button setFillColor:[UIColor themeColorWithCategory:UPColorCategorySecondaryActiveFill] forControlStates:UPControlStateActive];
    [button setStrokePath:_WordTrayStrokePath() forControlStates:UIControlStateNormal];
    [button setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryInactiveStroke] forControlStates:UIControlStateNormal];
    [button setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryActiveStroke] forControlStates:UPControlStateActive];
    return button;
}

@end
