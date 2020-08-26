//
//  UPCheckbox.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UIFont+UP.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPTapGestureRecognizer.h>

#import "UPBallot.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

static UIBezierPath *CheckboxSquareFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(16.19, 11.25)];
    [path addCurveToPoint: CGPointMake(18.47, 11.25) controlPoint1: CGPointMake(16.95, 11.25) controlPoint2: CGPointMake(17.71, 11.25)];
    [path addCurveToPoint: CGPointMake(23.84, 11.49) controlPoint1: CGPointMake(20.26, 11.28) controlPoint2: CGPointMake(22.05, 11.19)];
    [path addCurveToPoint: CGPointMake(26.05, 13.11) controlPoint1: CGPointMake(24.46, 11.63) controlPoint2: CGPointMake(25.66, 11.77)];
    [path addCurveToPoint: CGPointMake(26.25, 15.39) controlPoint1: CGPointMake(26.24, 13.76) controlPoint2: CGPointMake(26.24, 14.61)];
    [path addCurveToPoint: CGPointMake(26.25, 27.11) controlPoint1: CGPointMake(26.25, 19.69) controlPoint2: CGPointMake(26.25, 22.81)];
    [path addCurveToPoint: CGPointMake(26.05, 29.39) controlPoint1: CGPointMake(26.23, 27.89) controlPoint2: CGPointMake(26.24, 28.74)];
    [path addCurveToPoint: CGPointMake(25.02, 30.64) controlPoint1: CGPointMake(25.8, 30.21) controlPoint2: CGPointMake(25.39, 30.44)];
    [path addCurveToPoint: CGPointMake(22.6, 31.17) controlPoint1: CGPointMake(24.22, 31.04) controlPoint2: CGPointMake(23.41, 31.09)];
    [path addCurveToPoint: CGPointMake(18.91, 31.25) controlPoint1: CGPointMake(21.37, 31.24) controlPoint2: CGPointMake(20.14, 31.25)];
    [path addCurveToPoint: CGPointMake(16.25, 31.25) controlPoint1: CGPointMake(18.02, 31.25) controlPoint2: CGPointMake(17.14, 31.25)];
    [path addCurveToPoint: CGPointMake(13.59, 31.25) controlPoint1: CGPointMake(15.37, 31.25) controlPoint2: CGPointMake(14.48, 31.25)];
    [path addCurveToPoint: CGPointMake(8.66, 31.01) controlPoint1: CGPointMake(11.95, 31.23) controlPoint2: CGPointMake(10.3, 31.29)];
    [path addCurveToPoint: CGPointMake(6.45, 29.39) controlPoint1: CGPointMake(8.04, 30.87) controlPoint2: CGPointMake(6.84, 30.73)];
    [path addCurveToPoint: CGPointMake(6.25, 27.11) controlPoint1: CGPointMake(6.26, 28.74) controlPoint2: CGPointMake(6.26, 27.89)];
    [path addCurveToPoint: CGPointMake(6.25, 15.39) controlPoint1: CGPointMake(6.25, 22.81) controlPoint2: CGPointMake(6.25, 19.69)];
    [path addCurveToPoint: CGPointMake(6.45, 13.11) controlPoint1: CGPointMake(6.27, 14.61) controlPoint2: CGPointMake(6.26, 13.76)];
    [path addCurveToPoint: CGPointMake(8.66, 11.49) controlPoint1: CGPointMake(6.84, 11.77) controlPoint2: CGPointMake(8.03, 11.63)];
    [path addCurveToPoint: CGPointMake(14.03, 11.25) controlPoint1: CGPointMake(10.45, 11.19) controlPoint2: CGPointMake(12.24, 11.28)];
    [path addCurveToPoint: CGPointMake(16.19, 11.25) controlPoint1: CGPointMake(14.75, 11.25) controlPoint2: CGPointMake(15.47, 11.25)];
    [path closePath];
    [path moveToPoint: CGPointMake(19.35, 7.25)];
    [path addCurveToPoint: CGPointMake(16.16, 7.25) controlPoint1: CGPointMake(18.29, 7.25) controlPoint2: CGPointMake(17.23, 7.25)];
    [path addCurveToPoint: CGPointMake(13.14, 7.25) controlPoint1: CGPointMake(15.16, 7.25) controlPoint2: CGPointMake(14.15, 7.25)];
    [path addCurveToPoint: CGPointMake(5.62, 7.58) controlPoint1: CGPointMake(10.64, 7.29) controlPoint2: CGPointMake(8.12, 7.17)];
    [path addCurveToPoint: CGPointMake(2.52, 9.86) controlPoint1: CGPointMake(4.75, 7.78) controlPoint2: CGPointMake(3.08, 7.98)];
    [path addCurveToPoint: CGPointMake(2.25, 13.05) controlPoint1: CGPointMake(2.26, 10.77) controlPoint2: CGPointMake(2.27, 11.96)];
    [path addCurveToPoint: CGPointMake(2.25, 29.45) controlPoint1: CGPointMake(2.25, 19.07) controlPoint2: CGPointMake(2.25, 23.44)];
    [path addCurveToPoint: CGPointMake(2.52, 32.64) controlPoint1: CGPointMake(2.27, 30.54) controlPoint2: CGPointMake(2.26, 31.73)];
    [path addCurveToPoint: CGPointMake(5.62, 34.92) controlPoint1: CGPointMake(3.08, 34.52) controlPoint2: CGPointMake(4.76, 34.72)];
    [path addCurveToPoint: CGPointMake(12.53, 35.25) controlPoint1: CGPointMake(7.92, 35.3) controlPoint2: CGPointMake(10.23, 35.22)];
    [path addCurveToPoint: CGPointMake(16.25, 35.25) controlPoint1: CGPointMake(13.77, 35.25) controlPoint2: CGPointMake(15.01, 35.25)];
    [path addCurveToPoint: CGPointMake(19.97, 35.25) controlPoint1: CGPointMake(17.49, 35.25) controlPoint2: CGPointMake(18.73, 35.25)];
    [path addCurveToPoint: CGPointMake(25.14, 35.13) controlPoint1: CGPointMake(21.69, 35.25) controlPoint2: CGPointMake(23.42, 35.24)];
    [path addCurveToPoint: CGPointMake(28.53, 34.4) controlPoint1: CGPointMake(26.27, 35.02) controlPoint2: CGPointMake(27.41, 34.95)];
    [path addCurveToPoint: CGPointMake(29.98, 32.64) controlPoint1: CGPointMake(29.05, 34.11) controlPoint2: CGPointMake(29.62, 33.79)];
    [path addCurveToPoint: CGPointMake(30.25, 29.45) controlPoint1: CGPointMake(30.24, 31.73) controlPoint2: CGPointMake(30.23, 30.54)];
    [path addCurveToPoint: CGPointMake(30.25, 13.05) controlPoint1: CGPointMake(30.25, 23.44) controlPoint2: CGPointMake(30.25, 19.07)];
    [path addCurveToPoint: CGPointMake(29.98, 9.86) controlPoint1: CGPointMake(30.23, 11.96) controlPoint2: CGPointMake(30.24, 10.77)];
    [path addCurveToPoint: CGPointMake(26.88, 7.58) controlPoint1: CGPointMake(29.42, 7.98) controlPoint2: CGPointMake(27.74, 7.78)];
    [path addCurveToPoint: CGPointMake(19.35, 7.25) controlPoint1: CGPointMake(24.38, 7.17) controlPoint2: CGPointMake(21.86, 7.29)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxSquareStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(16.19, 10.25)];
    [path addCurveToPoint: CGPointMake(18.69, 10.25) controlPoint1: CGPointMake(17.02, 10.25) controlPoint2: CGPointMake(17.86, 10.25)];
    [path addCurveToPoint: CGPointMake(24.6, 10.51) controlPoint1: CGPointMake(20.66, 10.28) controlPoint2: CGPointMake(22.63, 10.19)];
    [path addCurveToPoint: CGPointMake(27.03, 12.3) controlPoint1: CGPointMake(25.28, 10.67) controlPoint2: CGPointMake(26.6, 10.82)];
    [path addCurveToPoint: CGPointMake(27.25, 14.81) controlPoint1: CGPointMake(27.24, 13.01) controlPoint2: CGPointMake(27.23, 13.95)];
    [path addCurveToPoint: CGPointMake(27.25, 27.69) controlPoint1: CGPointMake(27.25, 19.53) controlPoint2: CGPointMake(27.25, 22.97)];
    [path addCurveToPoint: CGPointMake(27.03, 30.2) controlPoint1: CGPointMake(27.23, 28.55) controlPoint2: CGPointMake(27.24, 29.49)];
    [path addCurveToPoint: CGPointMake(25.9, 31.58) controlPoint1: CGPointMake(26.76, 31.1) controlPoint2: CGPointMake(26.3, 31.36)];
    [path addCurveToPoint: CGPointMake(23.24, 32.16) controlPoint1: CGPointMake(25.02, 32.02) controlPoint2: CGPointMake(24.12, 32.07)];
    [path addCurveToPoint: CGPointMake(19.17, 32.25) controlPoint1: CGPointMake(21.88, 32.24) controlPoint2: CGPointMake(20.53, 32.25)];
    [path addCurveToPoint: CGPointMake(16.25, 32.25) controlPoint1: CGPointMake(18.2, 32.25) controlPoint2: CGPointMake(17.22, 32.25)];
    [path addCurveToPoint: CGPointMake(13.33, 32.25) controlPoint1: CGPointMake(15.28, 32.25) controlPoint2: CGPointMake(14.3, 32.25)];
    [path addCurveToPoint: CGPointMake(7.9, 31.99) controlPoint1: CGPointMake(11.52, 32.23) controlPoint2: CGPointMake(9.7, 32.29)];
    [path addCurveToPoint: CGPointMake(5.47, 30.2) controlPoint1: CGPointMake(7.22, 31.83) controlPoint2: CGPointMake(5.9, 31.68)];
    [path addCurveToPoint: CGPointMake(5.25, 27.69) controlPoint1: CGPointMake(5.26, 29.49) controlPoint2: CGPointMake(5.27, 28.55)];
    [path addCurveToPoint: CGPointMake(5.25, 14.81) controlPoint1: CGPointMake(5.25, 22.97) controlPoint2: CGPointMake(5.25, 19.53)];
    [path addCurveToPoint: CGPointMake(5.47, 12.3) controlPoint1: CGPointMake(5.27, 13.95) controlPoint2: CGPointMake(5.26, 13.01)];
    [path addCurveToPoint: CGPointMake(7.9, 10.51) controlPoint1: CGPointMake(5.9, 10.82) controlPoint2: CGPointMake(7.21, 10.67)];
    [path addCurveToPoint: CGPointMake(13.81, 10.25) controlPoint1: CGPointMake(9.87, 10.19) controlPoint2: CGPointMake(11.84, 10.28)];
    [path addCurveToPoint: CGPointMake(16.19, 10.25) controlPoint1: CGPointMake(14.6, 10.25) controlPoint2: CGPointMake(15.4, 10.25)];
    [path closePath];
    [path moveToPoint: CGPointMake(19.35, 7.25)];
    [path addCurveToPoint: CGPointMake(16.17, 7.25) controlPoint1: CGPointMake(18.29, 7.25) controlPoint2: CGPointMake(17.23, 7.25)];
    [path addCurveToPoint: CGPointMake(13.15, 7.25) controlPoint1: CGPointMake(15.16, 7.25) controlPoint2: CGPointMake(14.15, 7.25)];
    [path addCurveToPoint: CGPointMake(5.62, 7.58) controlPoint1: CGPointMake(10.64, 7.29) controlPoint2: CGPointMake(8.12, 7.17)];
    [path addCurveToPoint: CGPointMake(2.52, 9.86) controlPoint1: CGPointMake(4.75, 7.78) controlPoint2: CGPointMake(3.08, 7.98)];
    [path addCurveToPoint: CGPointMake(2.25, 13.05) controlPoint1: CGPointMake(2.26, 10.77) controlPoint2: CGPointMake(2.27, 11.96)];
    [path addCurveToPoint: CGPointMake(2.25, 29.45) controlPoint1: CGPointMake(2.25, 19.07) controlPoint2: CGPointMake(2.25, 23.44)];
    [path addCurveToPoint: CGPointMake(2.52, 32.64) controlPoint1: CGPointMake(2.27, 30.54) controlPoint2: CGPointMake(2.26, 31.73)];
    [path addCurveToPoint: CGPointMake(5.62, 34.92) controlPoint1: CGPointMake(3.08, 34.52) controlPoint2: CGPointMake(4.76, 34.72)];
    [path addCurveToPoint: CGPointMake(12.53, 35.25) controlPoint1: CGPointMake(7.92, 35.3) controlPoint2: CGPointMake(10.23, 35.22)];
    [path addCurveToPoint: CGPointMake(16.25, 35.25) controlPoint1: CGPointMake(13.77, 35.25) controlPoint2: CGPointMake(15.01, 35.25)];
    [path addCurveToPoint: CGPointMake(19.97, 35.25) controlPoint1: CGPointMake(17.49, 35.25) controlPoint2: CGPointMake(18.73, 35.25)];
    [path addCurveToPoint: CGPointMake(25.14, 35.13) controlPoint1: CGPointMake(21.69, 35.25) controlPoint2: CGPointMake(23.42, 35.24)];
    [path addCurveToPoint: CGPointMake(28.53, 34.4) controlPoint1: CGPointMake(26.27, 35.02) controlPoint2: CGPointMake(27.41, 34.95)];
    [path addCurveToPoint: CGPointMake(29.98, 32.64) controlPoint1: CGPointMake(29.05, 34.11) controlPoint2: CGPointMake(29.62, 33.79)];
    [path addCurveToPoint: CGPointMake(30.25, 29.45) controlPoint1: CGPointMake(30.24, 31.73) controlPoint2: CGPointMake(30.23, 30.54)];
    [path addCurveToPoint: CGPointMake(30.25, 13.05) controlPoint1: CGPointMake(30.25, 23.44) controlPoint2: CGPointMake(30.25, 19.07)];
    [path addCurveToPoint: CGPointMake(29.98, 9.86) controlPoint1: CGPointMake(30.23, 11.96) controlPoint2: CGPointMake(30.24, 10.77)];
    [path addCurveToPoint: CGPointMake(26.88, 7.58) controlPoint1: CGPointMake(29.42, 7.98) controlPoint2: CGPointMake(27.74, 7.78)];
    [path addCurveToPoint: CGPointMake(19.35, 7.25) controlPoint1: CGPointMake(24.37, 7.17) controlPoint2: CGPointMake(21.86, 7.29)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxSquareHighlightedPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(29.75, 13.34)];
    [path addCurveToPoint: CGPointMake(29.48, 10.27) controlPoint1: CGPointMake(29.73, 12.29) controlPoint2: CGPointMake(29.74, 11.14)];
    [path addCurveToPoint: CGPointMake(26.5, 8.07) controlPoint1: CGPointMake(28.95, 8.45) controlPoint2: CGPointMake(27.33, 8.26)];
    [path addCurveToPoint: CGPointMake(19.24, 7.75) controlPoint1: CGPointMake(24.09, 7.67) controlPoint2: CGPointMake(21.66, 7.78)];
    [path addCurveToPoint: CGPointMake(13.26, 7.75) controlPoint1: CGPointMake(17.25, 7.75) controlPoint2: CGPointMake(15.25, 7.75)];
    [path addCurveToPoint: CGPointMake(6, 8.07) controlPoint1: CGPointMake(10.84, 7.78) controlPoint2: CGPointMake(8.41, 7.67)];
    [path addCurveToPoint: CGPointMake(3.02, 10.27) controlPoint1: CGPointMake(5.16, 8.26) controlPoint2: CGPointMake(3.55, 8.45)];
    [path addCurveToPoint: CGPointMake(2.75, 13.34) controlPoint1: CGPointMake(2.76, 11.14) controlPoint2: CGPointMake(2.77, 12.29)];
    [path addCurveToPoint: CGPointMake(2.75, 29.16) controlPoint1: CGPointMake(2.75, 19.14) controlPoint2: CGPointMake(2.75, 23.36)];
    [path addCurveToPoint: CGPointMake(3.02, 32.23) controlPoint1: CGPointMake(2.77, 30.21) controlPoint2: CGPointMake(2.76, 31.36)];
    [path addCurveToPoint: CGPointMake(6, 34.43) controlPoint1: CGPointMake(3.55, 34.05) controlPoint2: CGPointMake(5.17, 34.24)];
    [path addCurveToPoint: CGPointMake(12.66, 34.75) controlPoint1: CGPointMake(8.22, 34.8) controlPoint2: CGPointMake(10.44, 34.72)];
    [path addCurveToPoint: CGPointMake(19.84, 34.75) controlPoint1: CGPointMake(15.06, 34.75) controlPoint2: CGPointMake(17.45, 34.75)];
    [path addCurveToPoint: CGPointMake(24.83, 34.63) controlPoint1: CGPointMake(21.5, 34.75) controlPoint2: CGPointMake(23.16, 34.74)];
    [path addCurveToPoint: CGPointMake(28.09, 33.93) controlPoint1: CGPointMake(25.91, 34.53) controlPoint2: CGPointMake(27.01, 34.46)];
    [path addCurveToPoint: CGPointMake(29.48, 32.23) controlPoint1: CGPointMake(28.59, 33.65) controlPoint2: CGPointMake(29.15, 33.34)];
    [path addCurveToPoint: CGPointMake(29.75, 29.16) controlPoint1: CGPointMake(29.74, 31.36) controlPoint2: CGPointMake(29.73, 30.21)];
    [path addCurveToPoint: CGPointMake(29.75, 13.34) controlPoint1: CGPointMake(29.75, 23.36) controlPoint2: CGPointMake(29.75, 19.14)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxSquareCheckPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(39.7, 3.5)];
    [path addCurveToPoint: CGPointMake(39.35, 3.07) controlPoint1: CGPointMake(39.59, 3.35) controlPoint2: CGPointMake(39.47, 3.2)];
    [path addLineToPoint: CGPointMake(38.71, 2.43)];
    [path addCurveToPoint: CGPointMake(38.07, 1.8) controlPoint1: CGPointMake(38.5, 2.22) controlPoint2: CGPointMake(38.29, 2.01)];
    [path addCurveToPoint: CGPointMake(37.65, 1.45) controlPoint1: CGPointMake(37.94, 1.67) controlPoint2: CGPointMake(37.8, 1.56)];
    [path addCurveToPoint: CGPointMake(36.62, 1.31) controlPoint1: CGPointMake(37.36, 1.25) controlPoint2: CGPointMake(37, 1.2)];
    [path addCurveToPoint: CGPointMake(35.95, 1.6) controlPoint1: CGPointMake(36.41, 1.37) controlPoint2: CGPointMake(36.19, 1.46)];
    [path addCurveToPoint: CGPointMake(34.47, 2.69) controlPoint1: CGPointMake(35.45, 1.89) controlPoint2: CGPointMake(35, 2.25)];
    [path addCurveToPoint: CGPointMake(32.42, 4.56) controlPoint1: CGPointMake(33.83, 3.23) controlPoint2: CGPointMake(33.16, 3.84)];
    [path addCurveToPoint: CGPointMake(29.62, 7.29) controlPoint1: CGPointMake(31.48, 5.46) controlPoint2: CGPointMake(30.54, 6.37)];
    [path addCurveToPoint: CGPointMake(17.71, 19.19) controlPoint1: CGPointMake(25.65, 11.25) controlPoint2: CGPointMake(21.68, 15.22)];
    [path addCurveToPoint: CGPointMake(15.87, 21.05) controlPoint1: CGPointMake(17.09, 19.81) controlPoint2: CGPointMake(16.48, 20.43)];
    [path addLineToPoint: CGPointMake(15.74, 20.59)];
    [path addCurveToPoint: CGPointMake(14.93, 17.54) controlPoint1: CGPointMake(15.47, 19.57) controlPoint2: CGPointMake(15.2, 18.55)];
    [path addLineToPoint: CGPointMake(14.9, 17.45)];
    [path addCurveToPoint: CGPointMake(14.01, 14.6) controlPoint1: CGPointMake(14.65, 16.51) controlPoint2: CGPointMake(14.39, 15.53)];
    [path addCurveToPoint: CGPointMake(13.55, 13.71) controlPoint1: CGPointMake(13.91, 14.35) controlPoint2: CGPointMake(13.77, 14.02)];
    [path addCurveToPoint: CGPointMake(12.99, 13.16) controlPoint1: CGPointMake(13.43, 13.53) controlPoint2: CGPointMake(13.26, 13.32)];
    [path addCurveToPoint: CGPointMake(11.95, 13.01) controlPoint1: CGPointMake(12.7, 12.99) controlPoint2: CGPointMake(12.35, 12.94)];
    [path addCurveToPoint: CGPointMake(11.45, 13.12) controlPoint1: CGPointMake(11.78, 13.04) controlPoint2: CGPointMake(11.61, 13.08)];
    [path addLineToPoint: CGPointMake(9.29, 13.7)];
    [path addCurveToPoint: CGPointMake(8.81, 13.85) controlPoint1: CGPointMake(9.13, 13.74) controlPoint2: CGPointMake(8.96, 13.8)];
    [path addCurveToPoint: CGPointMake(7.98, 14.5) controlPoint1: CGPointMake(8.42, 13.99) controlPoint2: CGPointMake(8.14, 14.21)];
    [path addCurveToPoint: CGPointMake(7.76, 15.26) controlPoint1: CGPointMake(7.82, 14.78) controlPoint2: CGPointMake(7.78, 15.04)];
    [path addCurveToPoint: CGPointMake(7.81, 16.26) controlPoint1: CGPointMake(7.73, 15.64) controlPoint2: CGPointMake(7.77, 15.99)];
    [path addCurveToPoint: CGPointMake(8.49, 19.26) controlPoint1: CGPointMake(7.95, 17.27) controlPoint2: CGPointMake(8.22, 18.25)];
    [path addCurveToPoint: CGPointMake(10.44, 26.52) controlPoint1: CGPointMake(9.13, 21.68) controlPoint2: CGPointMake(9.78, 24.1)];
    [path addCurveToPoint: CGPointMake(10.76, 27.61) controlPoint1: CGPointMake(10.53, 26.89) controlPoint2: CGPointMake(10.65, 27.25)];
    [path addLineToPoint: CGPointMake(10.94, 28.21)];
    [path addCurveToPoint: CGPointMake(11.42, 29.41) controlPoint1: CGPointMake(11.08, 28.66) controlPoint2: CGPointMake(11.24, 29.06)];
    [path addCurveToPoint: CGPointMake(12, 30.19) controlPoint1: CGPointMake(11.55, 29.66) controlPoint2: CGPointMake(11.71, 29.94)];
    [path addCurveToPoint: CGPointMake(12.43, 30.45) controlPoint1: CGPointMake(12.13, 30.31) controlPoint2: CGPointMake(12.27, 30.39)];
    [path addCurveToPoint: CGPointMake(12.91, 30.53) controlPoint1: CGPointMake(12.57, 30.5) controlPoint2: CGPointMake(12.73, 30.53)];
    [path addCurveToPoint: CGPointMake(13.31, 30.49) controlPoint1: CGPointMake(13.03, 30.53) controlPoint2: CGPointMake(13.17, 30.52)];
    [path addCurveToPoint: CGPointMake(13.95, 30.34) controlPoint1: CGPointMake(13.49, 30.45) controlPoint2: CGPointMake(13.68, 30.41)];
    [path addLineToPoint: CGPointMake(14.19, 30.27)];
    [path addCurveToPoint: CGPointMake(14.34, 30.22) controlPoint1: CGPointMake(14.24, 30.26) controlPoint2: CGPointMake(14.29, 30.24)];
    [path addCurveToPoint: CGPointMake(15.49, 29.51) controlPoint1: CGPointMake(14.76, 30.03) controlPoint2: CGPointMake(15.14, 29.77)];
    [path addCurveToPoint: CGPointMake(17.06, 28.18) controlPoint1: CGPointMake(16.09, 29.05) controlPoint2: CGPointMake(16.64, 28.56)];
    [path addLineToPoint: CGPointMake(17.33, 27.93)];
    [path addCurveToPoint: CGPointMake(21.96, 23.44) controlPoint1: CGPointMake(18.85, 26.53) controlPoint2: CGPointMake(20.27, 25.12)];
    [path addCurveToPoint: CGPointMake(33.86, 11.53) controlPoint1: CGPointMake(25.93, 19.47) controlPoint2: CGPointMake(29.89, 15.5)];
    [path addCurveToPoint: CGPointMake(36.59, 8.73) controlPoint1: CGPointMake(34.78, 10.61) controlPoint2: CGPointMake(35.69, 9.67)];
    [path addCurveToPoint: CGPointMake(38.46, 6.68) controlPoint1: CGPointMake(37.31, 7.99) controlPoint2: CGPointMake(37.92, 7.32)];
    [path addCurveToPoint: CGPointMake(39.55, 5.2) controlPoint1: CGPointMake(38.81, 6.25) controlPoint2: CGPointMake(39.22, 5.75)];
    [path addCurveToPoint: CGPointMake(39.84, 4.53) controlPoint1: CGPointMake(39.69, 4.96) controlPoint2: CGPointMake(39.78, 4.74)];
    [path addCurveToPoint: CGPointMake(39.7, 3.5) controlPoint1: CGPointMake(39.95, 4.14) controlPoint2: CGPointMake(39.9, 3.79)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxRoundFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(16.25, 4.75)];
    [path addCurveToPoint: CGPointMake(0.25, 20.75) controlPoint1: CGPointMake(7.41, 4.75) controlPoint2: CGPointMake(0.25, 11.91)];
    [path addCurveToPoint: CGPointMake(16.25, 36.75) controlPoint1: CGPointMake(0.25, 29.59) controlPoint2: CGPointMake(7.41, 36.75)];
    [path addCurveToPoint: CGPointMake(32.25, 20.75) controlPoint1: CGPointMake(25.09, 36.75) controlPoint2: CGPointMake(32.25, 29.59)];
    [path addCurveToPoint: CGPointMake(16.25, 4.75) controlPoint1: CGPointMake(32.25, 11.91) controlPoint2: CGPointMake(25.09, 4.75)];
    [path closePath];
    [path moveToPoint: CGPointMake(16.25, 8.75)];
    [path addCurveToPoint: CGPointMake(28.25, 20.75) controlPoint1: CGPointMake(22.87, 8.75) controlPoint2: CGPointMake(28.25, 14.13)];
    [path addCurveToPoint: CGPointMake(16.25, 32.75) controlPoint1: CGPointMake(28.25, 27.37) controlPoint2: CGPointMake(22.87, 32.75)];
    [path addCurveToPoint: CGPointMake(4.25, 20.75) controlPoint1: CGPointMake(9.63, 32.75) controlPoint2: CGPointMake(4.25, 27.37)];
    [path addCurveToPoint: CGPointMake(16.25, 8.75) controlPoint1: CGPointMake(4.25, 14.13) controlPoint2: CGPointMake(9.63, 8.75)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxRoundStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(16.25, 4.75)];
    [path addCurveToPoint: CGPointMake(0.25, 20.75) controlPoint1: CGPointMake(7.41, 4.75) controlPoint2: CGPointMake(0.25, 11.91)];
    [path addCurveToPoint: CGPointMake(16.25, 36.75) controlPoint1: CGPointMake(0.25, 29.59) controlPoint2: CGPointMake(7.41, 36.75)];
    [path addCurveToPoint: CGPointMake(32.25, 20.75) controlPoint1: CGPointMake(25.09, 36.75) controlPoint2: CGPointMake(32.25, 29.59)];
    [path addCurveToPoint: CGPointMake(16.25, 4.75) controlPoint1: CGPointMake(32.25, 11.91) controlPoint2: CGPointMake(25.09, 4.75)];
    [path closePath];
    [path moveToPoint: CGPointMake(16.25, 7.75)];
    [path addCurveToPoint: CGPointMake(29.25, 20.75) controlPoint1: CGPointMake(23.42, 7.75) controlPoint2: CGPointMake(29.25, 13.58)];
    [path addCurveToPoint: CGPointMake(16.25, 33.75) controlPoint1: CGPointMake(29.25, 27.92) controlPoint2: CGPointMake(23.42, 33.75)];
    [path addCurveToPoint: CGPointMake(3.25, 20.75) controlPoint1: CGPointMake(9.08, 33.75) controlPoint2: CGPointMake(3.25, 27.92)];
    [path addCurveToPoint: CGPointMake(16.25, 7.75) controlPoint1: CGPointMake(3.25, 13.58) controlPoint2: CGPointMake(9.08, 7.75)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxRoundHighlightedPath()
{
    return [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1.75, 6.25, 29, 29)];
}

static UIBezierPath *CheckboxRoundCheckPath()
{
    return [UIBezierPath bezierPathWithOvalInRect: CGRectMake(7.25, 11.75, 18, 18)];
}

@interface UPBallot ()
@property (nonatomic, readwrite) UPBallotType type;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPBallot

+ (UPBallot *)ballotWithType:(UPBallotType)type
{
    return [[UPBallot alloc] initWithType:type target:nil action:nullptr];
}

- (instancetype)initWithType:(UPBallotType)type target:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    self.type = type;
    self.target = target;
    self.action = action;

    SpellLayout &layout = SpellLayout::instance();
    
    self.canonicalSize = SpellLayout::CanonicalBallotSize;
    self.chargeOutsets = layout.ballot_control_charge_outsets();
    [self addGestureRecognizer:[UPTapGestureRecognizer gestureWithTarget:self action:@selector(handleTap:)]];

    switch (self.type) {
        case UPBallotTypeDefault:
        case UPBallotTypeCheckbox: {
            [self setFillPath:CheckboxSquareFillPath()];
            [self setStrokePath:CheckboxSquareStrokePath()];
            [self setAuxiliaryPath:CheckboxSquareHighlightedPath() forState:UPControlStateNormal];
            UIBezierPath *check = CheckboxSquareCheckPath();
            [self setAccentPath:check forState:UPControlStateSelected];
            [self setAccentPath:check forState:(UPControlStateHighlighted | UPControlStateSelected)];
            break;
        }
        case UPBallotTypeRadioButton: {
            [self setFillPath:CheckboxRoundFillPath()];
            [self setStrokePath:CheckboxRoundStrokePath()];
            [self setAuxiliaryPath:CheckboxRoundHighlightedPath() forState:UPControlStateNormal];
            UIBezierPath *check = CheckboxRoundCheckPath();
            [self setAccentPath:check forState:UPControlStateSelected];
            [self setAccentPath:check forState:(UPControlStateHighlighted | UPControlStateSelected)];
            break;
        }
    }

    [self setFillColorCategory:UPColorCategoryControlShapeFill];
    [self setStrokeColorCategory:UPColorCategoryControlShapeStroke];
    [self setAuxiliaryColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [self setAuxiliaryColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [self setAuxiliaryColorCategory:UPColorCategoryHighlightedFill forState:(UPControlStateHighlighted | UPControlStateSelected)];
    [self sendPathViewToBack:self.auxiliaryPathView];
    
    [self setAccentColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [self setAccentColorCategory:UPColorCategoryControlIndicator forState:UPControlStateSelected];
    [self setAccentColorCategory:UPColorCategoryControlIndicator forState:(UPControlStateHighlighted | UPControlStateSelected)];
    
    self.label.font = SpellLayout::instance().ballot_control_font();
    self.label.colorCategory = UPColorCategoryControlText;
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
            
            if (self.type == UPBallotTypeRadioButton && self.selected) {
                return;
            }
            
            [self setSelected:!self.selected];
            [self update];
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
    CGFloat labelOriginY = up_rect_height(bounds) - up_rect_height(labelFrame) + layout.ballot_control_font().baselineAdjustment;
    labelFrame.origin = CGPointMake(layout.ballot_control_label_left_margin(), labelOriginY);
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
