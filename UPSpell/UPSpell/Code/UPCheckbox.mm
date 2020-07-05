//
//  UPCheckbox.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UIFont+UP.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPTapGestureRecognizer.h>

#import "UPCheckbox.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

static UIBezierPath *CheckboxFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(17.59, 7)];
    [path addCurveToPoint: CGPointMake(14.48, 7) controlPoint1: CGPointMake(16.56, 7) controlPoint2: CGPointMake(15.52, 7)];
    [path addCurveToPoint: CGPointMake(11.38, 7) controlPoint1: CGPointMake(13.45, 7) controlPoint2: CGPointMake(12.42, 7)];
    [path addCurveToPoint: CGPointMake(3.86, 7.33) controlPoint1: CGPointMake(8.88, 7.04) controlPoint2: CGPointMake(6.36, 6.92)];
    [path addCurveToPoint: CGPointMake(0.76, 9.61) controlPoint1: CGPointMake(2.98, 7.53) controlPoint2: CGPointMake(1.32, 7.73)];
    [path addCurveToPoint: CGPointMake(0.49, 12.8) controlPoint1: CGPointMake(0.5, 10.52) controlPoint2: CGPointMake(0.51, 11.71)];
    [path addCurveToPoint: CGPointMake(0.49, 29.2) controlPoint1: CGPointMake(0.49, 18.81) controlPoint2: CGPointMake(0.49, 23.19)];
    [path addCurveToPoint: CGPointMake(0.76, 32.39) controlPoint1: CGPointMake(0.51, 30.29) controlPoint2: CGPointMake(0.5, 31.48)];
    [path addCurveToPoint: CGPointMake(3.86, 34.67) controlPoint1: CGPointMake(1.32, 34.27) controlPoint2: CGPointMake(3, 34.47)];
    [path addCurveToPoint: CGPointMake(10.77, 35) controlPoint1: CGPointMake(6.16, 35.05) controlPoint2: CGPointMake(8.47, 34.97)];
    [path addCurveToPoint: CGPointMake(14.49, 35) controlPoint1: CGPointMake(12.01, 35) controlPoint2: CGPointMake(13.25, 35)];
    [path addCurveToPoint: CGPointMake(18.21, 35) controlPoint1: CGPointMake(15.73, 35) controlPoint2: CGPointMake(16.97, 35)];
    [path addCurveToPoint: CGPointMake(23.38, 34.88) controlPoint1: CGPointMake(19.93, 35) controlPoint2: CGPointMake(21.66, 34.99)];
    [path addCurveToPoint: CGPointMake(26.76, 34.15) controlPoint1: CGPointMake(24.51, 34.77) controlPoint2: CGPointMake(25.65, 34.7)];
    [path addCurveToPoint: CGPointMake(28.21, 32.39) controlPoint1: CGPointMake(27.28, 33.86) controlPoint2: CGPointMake(27.86, 33.54)];
    [path addCurveToPoint: CGPointMake(28.49, 29.2) controlPoint1: CGPointMake(28.48, 31.48) controlPoint2: CGPointMake(28.47, 30.29)];
    [path addCurveToPoint: CGPointMake(28.49, 12.8) controlPoint1: CGPointMake(28.49, 23.19) controlPoint2: CGPointMake(28.49, 18.81)];
    [path addCurveToPoint: CGPointMake(28.21, 9.61) controlPoint1: CGPointMake(28.47, 11.71) controlPoint2: CGPointMake(28.48, 10.52)];
    [path addCurveToPoint: CGPointMake(25.12, 7.33) controlPoint1: CGPointMake(27.66, 7.73) controlPoint2: CGPointMake(25.98, 7.53)];
    [path addCurveToPoint: CGPointMake(17.59, 7) controlPoint1: CGPointMake(22.61, 6.92) controlPoint2: CGPointMake(20.1, 7.04)];
    [path closePath];
    [path moveToPoint: CGPointMake(17.57, 11)];
    [path addCurveToPoint: CGPointMake(19.25, 11.01) controlPoint1: CGPointMake(18.13, 11.01) controlPoint2: CGPointMake(18.69, 11.01)];
    [path addCurveToPoint: CGPointMake(24.38, 11.26) controlPoint1: CGPointMake(21.06, 11.01) controlPoint2: CGPointMake(22.77, 11.01)];
    [path addLineToPoint: CGPointMake(24.44, 11.28)];
    [path addCurveToPoint: CGPointMake(24.48, 12.56) controlPoint1: CGPointMake(24.47, 11.69) controlPoint2: CGPointMake(24.48, 12.2)];
    [path addLineToPoint: CGPointMake(24.49, 12.83)];
    [path addCurveToPoint: CGPointMake(24.49, 29.17) controlPoint1: CGPointMake(24.49, 18.82) controlPoint2: CGPointMake(24.49, 23.18)];
    [path addLineToPoint: CGPointMake(24.48, 29.46)];
    [path addCurveToPoint: CGPointMake(24.45, 30.73) controlPoint1: CGPointMake(24.48, 29.82) controlPoint2: CGPointMake(24.47, 30.34)];
    [path addCurveToPoint: CGPointMake(23.27, 30.87) controlPoint1: CGPointMake(24.12, 30.79) controlPoint2: CGPointMake(23.73, 30.83)];
    [path addLineToPoint: CGPointMake(23.07, 30.89)];
    [path addCurveToPoint: CGPointMake(18.2, 31) controlPoint1: CGPointMake(21.46, 30.99) controlPoint2: CGPointMake(19.8, 31)];
    [path addCurveToPoint: CGPointMake(14.49, 31) controlPoint1: CGPointMake(16.96, 31) controlPoint2: CGPointMake(15.72, 31)];
    [path addCurveToPoint: CGPointMake(10.82, 31) controlPoint1: CGPointMake(13.25, 31) controlPoint2: CGPointMake(12.01, 31)];
    [path addCurveToPoint: CGPointMake(9.51, 30.99) controlPoint1: CGPointMake(10.38, 30.99) controlPoint2: CGPointMake(9.95, 30.99)];
    [path addCurveToPoint: CGPointMake(4.61, 30.74) controlPoint1: CGPointMake(7.78, 30.99) controlPoint2: CGPointMake(6.14, 30.98)];
    [path addLineToPoint: CGPointMake(4.53, 30.72)];
    [path addCurveToPoint: CGPointMake(4.5, 29.44) controlPoint1: CGPointMake(4.51, 30.31) controlPoint2: CGPointMake(4.5, 29.8)];
    [path addLineToPoint: CGPointMake(4.49, 29.17)];
    [path addCurveToPoint: CGPointMake(4.49, 12.83) controlPoint1: CGPointMake(4.49, 23.18) controlPoint2: CGPointMake(4.49, 18.82)];
    [path addLineToPoint: CGPointMake(4.5, 12.54)];
    [path addCurveToPoint: CGPointMake(4.53, 11.28) controlPoint1: CGPointMake(4.5, 12.19) controlPoint2: CGPointMake(4.51, 11.68)];
    [path addLineToPoint: CGPointMake(4.6, 11.26)];
    [path addCurveToPoint: CGPointMake(9.73, 11.01) controlPoint1: CGPointMake(6.21, 11.01) controlPoint2: CGPointMake(7.92, 11.01)];
    [path addCurveToPoint: CGPointMake(11.41, 11) controlPoint1: CGPointMake(10.29, 11.01) controlPoint2: CGPointMake(10.85, 11.01)];
    [path addLineToPoint: CGPointMake(14.48, 11)];
    [path addLineToPoint: CGPointMake(17.57, 11)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(17.1, 6.52)];
    [path addCurveToPoint: CGPointMake(14, 6.53) controlPoint1: CGPointMake(16.07, 6.52) controlPoint2: CGPointMake(15.04, 6.53)];
    [path addCurveToPoint: CGPointMake(10.9, 6.52) controlPoint1: CGPointMake(12.97, 6.53) controlPoint2: CGPointMake(11.93, 6.52)];
    [path addCurveToPoint: CGPointMake(3.37, 6.86) controlPoint1: CGPointMake(8.39, 6.56) controlPoint2: CGPointMake(5.88, 6.45)];
    [path addCurveToPoint: CGPointMake(0.28, 9.13) controlPoint1: CGPointMake(2.5, 7.06) controlPoint2: CGPointMake(0.83, 7.25)];
    [path addCurveToPoint: CGPointMake(0, 12.32) controlPoint1: CGPointMake(0.01, 10.04) controlPoint2: CGPointMake(0.02, 11.23)];
    [path addCurveToPoint: CGPointMake(0, 28.73) controlPoint1: CGPointMake(-0, 18.34) controlPoint2: CGPointMake(-0, 22.71)];
    [path addCurveToPoint: CGPointMake(0.28, 31.92) controlPoint1: CGPointMake(0.02, 29.82) controlPoint2: CGPointMake(0.01, 31.01)];
    [path addCurveToPoint: CGPointMake(3.37, 34.19) controlPoint1: CGPointMake(0.83, 33.79) controlPoint2: CGPointMake(2.51, 33.99)];
    [path addCurveToPoint: CGPointMake(10.28, 34.52) controlPoint1: CGPointMake(5.67, 34.57) controlPoint2: CGPointMake(7.98, 34.5)];
    [path addCurveToPoint: CGPointMake(14, 34.52) controlPoint1: CGPointMake(11.52, 34.52) controlPoint2: CGPointMake(12.76, 34.52)];
    [path addCurveToPoint: CGPointMake(17.72, 34.52) controlPoint1: CGPointMake(15.24, 34.52) controlPoint2: CGPointMake(16.48, 34.52)];
    [path addCurveToPoint: CGPointMake(22.89, 34.4) controlPoint1: CGPointMake(19.44, 34.52) controlPoint2: CGPointMake(21.17, 34.52)];
    [path addCurveToPoint: CGPointMake(26.28, 33.68) controlPoint1: CGPointMake(24.02, 34.3) controlPoint2: CGPointMake(25.16, 34.23)];
    [path addCurveToPoint: CGPointMake(27.73, 31.92) controlPoint1: CGPointMake(26.8, 33.39) controlPoint2: CGPointMake(27.38, 33.06)];
    [path addCurveToPoint: CGPointMake(28, 28.73) controlPoint1: CGPointMake(27.99, 31.01) controlPoint2: CGPointMake(27.98, 29.82)];
    [path addCurveToPoint: CGPointMake(28, 12.32) controlPoint1: CGPointMake(28, 22.71) controlPoint2: CGPointMake(28, 18.34)];
    [path addCurveToPoint: CGPointMake(27.73, 9.13) controlPoint1: CGPointMake(27.98, 11.23) controlPoint2: CGPointMake(27.99, 10.04)];
    [path addCurveToPoint: CGPointMake(24.63, 6.86) controlPoint1: CGPointMake(27.17, 7.25) controlPoint2: CGPointMake(25.49, 7.05)];
    [path addCurveToPoint: CGPointMake(17.1, 6.52) controlPoint1: CGPointMake(22.13, 6.45) controlPoint2: CGPointMake(19.61, 6.56)];
    [path closePath];
    [path moveToPoint: CGPointMake(10.89, 9.02)];
    [path addLineToPoint: CGPointMake(14, 9.03)];
    [path addLineToPoint: CGPointMake(17.09, 9.02)];
    [path addCurveToPoint: CGPointMake(18.77, 9.03) controlPoint1: CGPointMake(17.65, 9.03) controlPoint2: CGPointMake(18.21, 9.03)];
    [path addCurveToPoint: CGPointMake(24.17, 9.31) controlPoint1: CGPointMake(20.65, 9.03) controlPoint2: CGPointMake(22.43, 9.04)];
    [path addLineToPoint: CGPointMake(24.34, 9.35)];
    [path addCurveToPoint: CGPointMake(25.32, 9.83) controlPoint1: CGPointMake(25.24, 9.54) controlPoint2: CGPointMake(25.26, 9.63)];
    [path addCurveToPoint: CGPointMake(25.49, 12.06) controlPoint1: CGPointMake(25.47, 10.33) controlPoint2: CGPointMake(25.48, 11.25)];
    [path addLineToPoint: CGPointMake(25.5, 12.32)];
    [path addCurveToPoint: CGPointMake(25.5, 28.68) controlPoint1: CGPointMake(25.5, 18.34) controlPoint2: CGPointMake(25.5, 22.71)];
    [path addLineToPoint: CGPointMake(25.49, 29)];
    [path addCurveToPoint: CGPointMake(25.33, 31.18) controlPoint1: CGPointMake(25.48, 29.8) controlPoint2: CGPointMake(25.47, 30.72)];
    [path addCurveToPoint: CGPointMake(25.26, 31.38) controlPoint1: CGPointMake(25.3, 31.28) controlPoint2: CGPointMake(25.28, 31.34)];
    [path addCurveToPoint: CGPointMake(25.12, 31.46) controlPoint1: CGPointMake(25.23, 31.4) controlPoint2: CGPointMake(25.17, 31.43)];
    [path addCurveToPoint: CGPointMake(22.92, 31.89) controlPoint1: CGPointMake(24.52, 31.74) controlPoint2: CGPointMake(23.78, 31.81)];
    [path addLineToPoint: CGPointMake(22.7, 31.91)];
    [path addCurveToPoint: CGPointMake(17.72, 32.02) controlPoint1: CGPointMake(21.04, 32.02) controlPoint2: CGPointMake(19.35, 32.02)];
    [path addCurveToPoint: CGPointMake(14, 32.02) controlPoint1: CGPointMake(16.48, 32.02) controlPoint2: CGPointMake(15.24, 32.02)];
    [path addCurveToPoint: CGPointMake(10.31, 32.02) controlPoint1: CGPointMake(12.76, 32.02) controlPoint2: CGPointMake(11.52, 32.02)];
    [path addCurveToPoint: CGPointMake(9.02, 32.01) controlPoint1: CGPointMake(9.88, 32.02) controlPoint2: CGPointMake(9.45, 32.02)];
    [path addCurveToPoint: CGPointMake(3.84, 31.74) controlPoint1: CGPointMake(7.21, 32.01) controlPoint2: CGPointMake(5.5, 32)];
    [path addLineToPoint: CGPointMake(3.66, 31.7)];
    [path addCurveToPoint: CGPointMake(2.68, 31.22) controlPoint1: CGPointMake(2.76, 31.5) controlPoint2: CGPointMake(2.74, 31.42)];
    [path addCurveToPoint: CGPointMake(2.51, 28.98) controlPoint1: CGPointMake(2.53, 30.71) controlPoint2: CGPointMake(2.52, 29.79)];
    [path addLineToPoint: CGPointMake(2.5, 28.73)];
    [path addCurveToPoint: CGPointMake(2.5, 12.36) controlPoint1: CGPointMake(2.5, 22.71) controlPoint2: CGPointMake(2.5, 18.34)];
    [path addLineToPoint: CGPointMake(2.51, 12.04)];
    [path addCurveToPoint: CGPointMake(2.67, 9.84) controlPoint1: CGPointMake(2.52, 11.24) controlPoint2: CGPointMake(2.53, 10.33)];
    [path addCurveToPoint: CGPointMake(3.66, 9.35) controlPoint1: CGPointMake(2.74, 9.62) controlPoint2: CGPointMake(2.76, 9.54)];
    [path addLineToPoint: CGPointMake(3.84, 9.31)];
    [path addCurveToPoint: CGPointMake(9.24, 9.03) controlPoint1: CGPointMake(5.57, 9.04) controlPoint2: CGPointMake(7.35, 9.03)];
    [path addCurveToPoint: CGPointMake(10.89, 9.02) controlPoint1: CGPointMake(9.8, 9.03) controlPoint2: CGPointMake(10.37, 9.03)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxHighlightedPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(27.25, 12.76)];
    [path addCurveToPoint: CGPointMake(26.99, 9.74) controlPoint1: CGPointMake(27.23, 11.73) controlPoint2: CGPointMake(27.24, 10.6)];
    [path addCurveToPoint: CGPointMake(24.06, 7.59) controlPoint1: CGPointMake(26.47, 7.97) controlPoint2: CGPointMake(24.88, 7.78)];
    [path addCurveToPoint: CGPointMake(16.94, 7.27) controlPoint1: CGPointMake(21.69, 7.2) controlPoint2: CGPointMake(19.31, 7.31)];
    [path addCurveToPoint: CGPointMake(11.06, 7.27) controlPoint1: CGPointMake(14.98, 7.28) controlPoint2: CGPointMake(13.02, 7.28)];
    [path addCurveToPoint: CGPointMake(3.94, 7.59) controlPoint1: CGPointMake(8.69, 7.31) controlPoint2: CGPointMake(6.31, 7.2)];
    [path addCurveToPoint: CGPointMake(1.01, 9.74) controlPoint1: CGPointMake(3.11, 7.78) controlPoint2: CGPointMake(1.54, 7.97)];
    [path addCurveToPoint: CGPointMake(0.75, 12.76) controlPoint1: CGPointMake(0.76, 10.6) controlPoint2: CGPointMake(0.77, 11.73)];
    [path addCurveToPoint: CGPointMake(0.75, 28.29) controlPoint1: CGPointMake(0.75, 18.46) controlPoint2: CGPointMake(0.75, 22.59)];
    [path addCurveToPoint: CGPointMake(1.01, 31.3) controlPoint1: CGPointMake(0.77, 29.32) controlPoint2: CGPointMake(0.76, 30.44)];
    [path addCurveToPoint: CGPointMake(3.94, 33.46) controlPoint1: CGPointMake(1.53, 33.08) controlPoint2: CGPointMake(3.12, 33.27)];
    [path addCurveToPoint: CGPointMake(10.48, 33.77) controlPoint1: CGPointMake(6.12, 33.82) controlPoint2: CGPointMake(8.3, 33.75)];
    [path addCurveToPoint: CGPointMake(17.52, 33.77) controlPoint1: CGPointMake(12.83, 33.77) controlPoint2: CGPointMake(15.17, 33.77)];
    [path addCurveToPoint: CGPointMake(22.42, 33.66) controlPoint1: CGPointMake(19.15, 33.77) controlPoint2: CGPointMake(20.78, 33.77)];
    [path addCurveToPoint: CGPointMake(25.62, 32.97) controlPoint1: CGPointMake(23.49, 33.56) controlPoint2: CGPointMake(24.56, 33.49)];
    [path addCurveToPoint: CGPointMake(26.99, 31.31) controlPoint1: CGPointMake(26.11, 32.7) controlPoint2: CGPointMake(26.66, 32.39)];
    [path addCurveToPoint: CGPointMake(27.25, 28.29) controlPoint1: CGPointMake(27.24, 30.45) controlPoint2: CGPointMake(27.23, 29.32)];
    [path addCurveToPoint: CGPointMake(27.25, 12.76) controlPoint1: CGPointMake(27.25, 22.59) controlPoint2: CGPointMake(27.25, 18.46)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxCheckPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(38.8, 2.72)];
    [path addCurveToPoint: CGPointMake(38.45, 2.3) controlPoint1: CGPointMake(38.69, 2.57) controlPoint2: CGPointMake(38.58, 2.43)];
    [path addLineToPoint: CGPointMake(37.81, 1.66)];
    [path addCurveToPoint: CGPointMake(37.18, 1.03) controlPoint1: CGPointMake(37.6, 1.45) controlPoint2: CGPointMake(37.39, 1.24)];
    [path addCurveToPoint: CGPointMake(36.75, 0.68) controlPoint1: CGPointMake(37.05, 0.9) controlPoint2: CGPointMake(36.9, 0.78)];
    [path addCurveToPoint: CGPointMake(35.72, 0.53) controlPoint1: CGPointMake(36.46, 0.47) controlPoint2: CGPointMake(36.11, 0.42)];
    [path addCurveToPoint: CGPointMake(35.05, 0.83) controlPoint1: CGPointMake(35.51, 0.59) controlPoint2: CGPointMake(35.3, 0.69)];
    [path addCurveToPoint: CGPointMake(33.57, 1.92) controlPoint1: CGPointMake(34.55, 1.12) controlPoint2: CGPointMake(34.1, 1.48)];
    [path addCurveToPoint: CGPointMake(31.52, 3.78) controlPoint1: CGPointMake(32.93, 2.45) controlPoint2: CGPointMake(32.26, 3.06)];
    [path addCurveToPoint: CGPointMake(28.72, 6.52) controlPoint1: CGPointMake(30.58, 4.69) controlPoint2: CGPointMake(29.64, 5.6)];
    [path addCurveToPoint: CGPointMake(16.81, 18.42) controlPoint1: CGPointMake(24.75, 10.48) controlPoint2: CGPointMake(20.78, 14.45)];
    [path addCurveToPoint: CGPointMake(14.97, 20.27) controlPoint1: CGPointMake(16.2, 19.03) controlPoint2: CGPointMake(15.58, 19.65)];
    [path addLineToPoint: CGPointMake(14.84, 19.81)];
    [path addCurveToPoint: CGPointMake(14.03, 16.76) controlPoint1: CGPointMake(14.57, 18.8) controlPoint2: CGPointMake(14.3, 17.78)];
    [path addLineToPoint: CGPointMake(14.01, 16.68)];
    [path addCurveToPoint: CGPointMake(13.11, 13.83) controlPoint1: CGPointMake(13.75, 15.74) controlPoint2: CGPointMake(13.49, 14.76)];
    [path addCurveToPoint: CGPointMake(12.66, 12.94) controlPoint1: CGPointMake(13.01, 13.57) controlPoint2: CGPointMake(12.87, 13.25)];
    [path addCurveToPoint: CGPointMake(12.09, 12.38) controlPoint1: CGPointMake(12.53, 12.75) controlPoint2: CGPointMake(12.37, 12.54)];
    [path addCurveToPoint: CGPointMake(11.05, 12.24) controlPoint1: CGPointMake(11.8, 12.22) controlPoint2: CGPointMake(11.45, 12.17)];
    [path addCurveToPoint: CGPointMake(10.55, 12.35) controlPoint1: CGPointMake(10.88, 12.27) controlPoint2: CGPointMake(10.71, 12.31)];
    [path addLineToPoint: CGPointMake(8.4, 12.93)];
    [path addCurveToPoint: CGPointMake(7.91, 13.08) controlPoint1: CGPointMake(8.23, 12.97) controlPoint2: CGPointMake(8.07, 13.02)];
    [path addCurveToPoint: CGPointMake(7.08, 13.72) controlPoint1: CGPointMake(7.52, 13.22) controlPoint2: CGPointMake(7.24, 13.44)];
    [path addCurveToPoint: CGPointMake(6.86, 14.49) controlPoint1: CGPointMake(6.92, 14) controlPoint2: CGPointMake(6.88, 14.27)];
    [path addCurveToPoint: CGPointMake(6.91, 15.49) controlPoint1: CGPointMake(6.83, 14.87) controlPoint2: CGPointMake(6.87, 15.22)];
    [path addCurveToPoint: CGPointMake(7.59, 18.49) controlPoint1: CGPointMake(7.06, 16.49) controlPoint2: CGPointMake(7.32, 17.47)];
    [path addCurveToPoint: CGPointMake(9.54, 25.75) controlPoint1: CGPointMake(8.23, 20.91) controlPoint2: CGPointMake(8.88, 23.33)];
    [path addCurveToPoint: CGPointMake(9.86, 26.84) controlPoint1: CGPointMake(9.64, 26.11) controlPoint2: CGPointMake(9.75, 26.48)];
    [path addLineToPoint: CGPointMake(10.04, 27.44)];
    [path addCurveToPoint: CGPointMake(10.53, 28.64) controlPoint1: CGPointMake(10.19, 27.89) controlPoint2: CGPointMake(10.34, 28.28)];
    [path addCurveToPoint: CGPointMake(11.1, 29.42) controlPoint1: CGPointMake(10.66, 28.88) controlPoint2: CGPointMake(10.82, 29.17)];
    [path addCurveToPoint: CGPointMake(11.53, 29.68) controlPoint1: CGPointMake(11.23, 29.53) controlPoint2: CGPointMake(11.37, 29.62)];
    [path addCurveToPoint: CGPointMake(12.01, 29.76) controlPoint1: CGPointMake(11.68, 29.73) controlPoint2: CGPointMake(11.84, 29.76)];
    [path addCurveToPoint: CGPointMake(12.41, 29.72) controlPoint1: CGPointMake(12.14, 29.76) controlPoint2: CGPointMake(12.27, 29.74)];
    [path addCurveToPoint: CGPointMake(13.05, 29.57) controlPoint1: CGPointMake(12.59, 29.68) controlPoint2: CGPointMake(12.78, 29.64)];
    [path addLineToPoint: CGPointMake(13.29, 29.5)];
    [path addCurveToPoint: CGPointMake(13.44, 29.45) controlPoint1: CGPointMake(13.34, 29.48) controlPoint2: CGPointMake(13.39, 29.47)];
    [path addCurveToPoint: CGPointMake(14.59, 28.73) controlPoint1: CGPointMake(13.86, 29.26) controlPoint2: CGPointMake(14.24, 28.99)];
    [path addCurveToPoint: CGPointMake(16.16, 27.41) controlPoint1: CGPointMake(15.19, 28.28) controlPoint2: CGPointMake(15.75, 27.79)];
    [path addLineToPoint: CGPointMake(16.43, 27.16)];
    [path addCurveToPoint: CGPointMake(21.06, 22.66) controlPoint1: CGPointMake(17.96, 25.75) controlPoint2: CGPointMake(19.37, 24.35)];
    [path addCurveToPoint: CGPointMake(32.96, 10.76) controlPoint1: CGPointMake(25.03, 18.7) controlPoint2: CGPointMake(29, 14.73)];
    [path addCurveToPoint: CGPointMake(35.69, 7.96) controlPoint1: CGPointMake(33.88, 9.83) controlPoint2: CGPointMake(34.79, 8.9)];
    [path addCurveToPoint: CGPointMake(37.56, 5.91) controlPoint1: CGPointMake(36.41, 7.22) controlPoint2: CGPointMake(37.02, 6.55)];
    [path addCurveToPoint: CGPointMake(38.65, 4.42) controlPoint1: CGPointMake(37.92, 5.48) controlPoint2: CGPointMake(38.33, 4.98)];
    [path addCurveToPoint: CGPointMake(38.94, 3.75) controlPoint1: CGPointMake(38.79, 4.19) controlPoint2: CGPointMake(38.88, 3.97)];
    [path addCurveToPoint: CGPointMake(38.8, 2.72) controlPoint1: CGPointMake(39.05, 3.37) controlPoint2: CGPointMake(39, 3.01)];
    [path closePath];
    return path;
}

@interface UPCheckbox ()
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPCheckbox

+ (UPCheckbox *)checkbox
{
    return [[UPCheckbox alloc] initWithTarget:nil action:nullptr];
}

+ (UPCheckbox *)checkboxWithTarget:(id)target action:(SEL)action
{
    return [[UPCheckbox alloc] initWithTarget:target action:action];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    self.target = target;
    self.action = action;

    SpellLayout &layout = SpellLayout::instance();
    
    self.canonicalSize = SpellLayout::CanonicalCheckboxSize;
    self.chargeOutsets = layout.checkbox_control_charge_outsets();
    [self addGestureRecognizer:[UPTapGestureRecognizer gestureWithTarget:self action:@selector(handleTap:)]];

    [self setFillPath:CheckboxFillPath()];
    [self setFillColorCategory:UPColorCategoryControlShapeFill];

    [self setStrokePath:CheckboxStrokePath()];
    [self setStrokeColorCategory:UPColorCategoryControlShapeStroke];

    [self setAuxiliaryPath:CheckboxHighlightedPath() forState:UPControlStateNormal];
    [self setAuxiliaryColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [self setAuxiliaryColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [self setAuxiliaryColorCategory:UPColorCategoryHighlightedFill forState:(UPControlStateHighlighted | UPControlStateSelected)];
    [self sendPathViewToBack:self.auxiliaryPathView];
    
    [self setAccentColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [self setAccentColorCategory:UPColorCategoryControlIndicator forState:UPControlStateSelected];
    [self setAccentColorCategory:UPColorCategoryControlIndicator forState:(UPControlStateHighlighted | UPControlStateSelected)];
    [self setAccentPath:CheckboxCheckPath() forState:UPControlStateSelected];
    [self setAccentPath:CheckboxCheckPath() forState:(UPControlStateHighlighted | UPControlStateSelected)];
    
    self.label.font = SpellLayout::instance().checkbox_control_font();
    self.label.textColorCategory = UPColorCategoryControlText;
    self.label.backgroundColorCategory = UPColorCategoryClear;
    [self.label addGestureRecognizer:[UPTapGestureRecognizer gestureWithTarget:self action:@selector(handleTap:)]];

    [self updateThemeColors];
    
    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)handleTap:(UPTapGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible: {
            break;
        }
        case UIGestureRecognizerStateBegan: {
            self.highlighted = gesture.touchInside;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.highlighted = gesture.touchInside;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.highlighted = NO;
            [self setSelected:!self.selected];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([self.target respondsToSelector:self.action]) {
                if ([NSStringFromSelector(self.action) hasSuffix:@":"]) {
                    [self.target performSelector:self.action withObject:self];
                }
                else {
                    [self.target performSelector:self.action];
                }
            }
            else if (self.target || self.action) {
                LOG(General, "Target does not respond to selector: %@ : %@", self.target, NSStringFromSelector(self.action));
            }
#pragma clang diagnostic pop
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.highlighted = NO;
            break;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    SpellLayout &layout = SpellLayout::instance();

    CGRect bounds = self.bounds;
    
    [self.label sizeToFit];
    
    CGRect labelFrame = self.label.frame;
    CGFloat labelOriginY = up_rect_height(bounds) - up_rect_height(labelFrame) + layout.checkbox_control_font().baselineAdjustment;
    labelFrame.origin = CGPointMake(layout.checkbox_control_label_left_margin(), labelOriginY);
    self.label.frame = labelFrame;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([super pointInside:point withEvent:event]) {
        return YES;
    }
    CGPoint labelPoint = [self.label convertPoint:point fromView:self];
    return [self.label pointInside:labelPoint withEvent:event];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.label updateThemeColors];
}

@end
