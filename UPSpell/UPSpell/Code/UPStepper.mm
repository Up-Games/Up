//
//  UPStepper.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UIColor+UP.h>
#import <UPKit/UPTapGestureRecognizer.h>

#import "UPSpellLayout.h"
#import "UPStepper.h"

using UP::SpellLayout;

static UIBezierPath *ButtonFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(30, 6.21)];
    [path addCurveToPoint: CGPointMake(29.71, 2.8) controlPoint1: CGPointMake(29.98, 5.05) controlPoint2: CGPointMake(29.99, 3.77)];
    [path addCurveToPoint: CGPointMake(26.39, 0.36) controlPoint1: CGPointMake(29.11, 0.78) controlPoint2: CGPointMake(27.31, 0.57)];
    [path addCurveToPoint: CGPointMake(18.33, 0) controlPoint1: CGPointMake(23.71, -0.08) controlPoint2: CGPointMake(21.02, 0.04)];
    [path addCurveToPoint: CGPointMake(11.67, 0) controlPoint1: CGPointMake(16.11, 0) controlPoint2: CGPointMake(13.89, 0)];
    [path addCurveToPoint: CGPointMake(3.61, 0.36) controlPoint1: CGPointMake(8.99, 0.04) controlPoint2: CGPointMake(6.3, -0.08)];
    [path addCurveToPoint: CGPointMake(0.3, 2.8) controlPoint1: CGPointMake(2.67, 0.57) controlPoint2: CGPointMake(0.89, 0.78)];
    [path addCurveToPoint: CGPointMake(0, 6.21) controlPoint1: CGPointMake(0.01, 3.77) controlPoint2: CGPointMake(0.02, 5.05)];
    [path addCurveToPoint: CGPointMake(0, 23.79) controlPoint1: CGPointMake(-0, 12.66) controlPoint2: CGPointMake(-0, 17.34)];
    [path addCurveToPoint: CGPointMake(0.3, 27.2) controlPoint1: CGPointMake(0.02, 24.95) controlPoint2: CGPointMake(0.01, 26.23)];
    [path addCurveToPoint: CGPointMake(3.61, 29.64) controlPoint1: CGPointMake(0.89, 29.22) controlPoint2: CGPointMake(2.69, 29.43)];
    [path addCurveToPoint: CGPointMake(11.02, 30) controlPoint1: CGPointMake(6.08, 30.05) controlPoint2: CGPointMake(8.55, 29.97)];
    [path addCurveToPoint: CGPointMake(18.98, 30) controlPoint1: CGPointMake(13.67, 30) controlPoint2: CGPointMake(16.33, 30)];
    [path addCurveToPoint: CGPointMake(24.53, 29.87) controlPoint1: CGPointMake(20.83, 30) controlPoint2: CGPointMake(22.68, 29.99)];
    [path addCurveToPoint: CGPointMake(28.15, 29.09) controlPoint1: CGPointMake(25.74, 29.75) controlPoint2: CGPointMake(26.96, 29.68)];
    [path addCurveToPoint: CGPointMake(29.71, 27.2) controlPoint1: CGPointMake(28.71, 28.78) controlPoint2: CGPointMake(29.33, 28.43)];
    [path addCurveToPoint: CGPointMake(30, 23.79) controlPoint1: CGPointMake(29.99, 26.23) controlPoint2: CGPointMake(29.98, 24.95)];
    [path addCurveToPoint: CGPointMake(30, 6.21) controlPoint1: CGPointMake(30, 17.34) controlPoint2: CGPointMake(30, 12.66)];
    [path closePath];
    return path;
}

static UIBezierPath *ButtonStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(18.33, -0)];
    [path addCurveToPoint: CGPointMake(14.96, 0) controlPoint1: CGPointMake(17.2, 0) controlPoint2: CGPointMake(16.08, 0)];
    [path addCurveToPoint: CGPointMake(11.67, -0) controlPoint1: CGPointMake(13.86, 0) controlPoint2: CGPointMake(12.77, 0)];
    [path addCurveToPoint: CGPointMake(3.61, 0.36) controlPoint1: CGPointMake(8.99, 0.04) controlPoint2: CGPointMake(6.29, -0.08)];
    [path addCurveToPoint: CGPointMake(0.29, 2.79) controlPoint1: CGPointMake(2.67, 0.57) controlPoint2: CGPointMake(0.89, 0.78)];
    [path addCurveToPoint: CGPointMake(0, 6.21) controlPoint1: CGPointMake(0.01, 3.77) controlPoint2: CGPointMake(0.02, 5.04)];
    [path addCurveToPoint: CGPointMake(0, 23.79) controlPoint1: CGPointMake(-0, 12.66) controlPoint2: CGPointMake(-0, 17.34)];
    [path addCurveToPoint: CGPointMake(0.29, 27.2) controlPoint1: CGPointMake(0.02, 24.96) controlPoint2: CGPointMake(0.01, 26.23)];
    [path addCurveToPoint: CGPointMake(3.61, 29.64) controlPoint1: CGPointMake(0.89, 29.22) controlPoint2: CGPointMake(2.69, 29.43)];
    [path addCurveToPoint: CGPointMake(11.02, 30) controlPoint1: CGPointMake(6.07, 30.05) controlPoint2: CGPointMake(8.55, 29.97)];
    [path addCurveToPoint: CGPointMake(15, 30) controlPoint1: CGPointMake(12.34, 30) controlPoint2: CGPointMake(13.67, 30)];
    [path addCurveToPoint: CGPointMake(18.98, 30) controlPoint1: CGPointMake(16.33, 30) controlPoint2: CGPointMake(17.66, 30)];
    [path addCurveToPoint: CGPointMake(24.53, 29.87) controlPoint1: CGPointMake(20.83, 30) controlPoint2: CGPointMake(22.68, 29.99)];
    [path addCurveToPoint: CGPointMake(28.15, 29.09) controlPoint1: CGPointMake(25.74, 29.76) controlPoint2: CGPointMake(26.96, 29.68)];
    [path addCurveToPoint: CGPointMake(29.71, 27.21) controlPoint1: CGPointMake(28.71, 28.78) controlPoint2: CGPointMake(29.33, 28.43)];
    [path addCurveToPoint: CGPointMake(30, 23.79) controlPoint1: CGPointMake(29.99, 26.23) controlPoint2: CGPointMake(29.98, 24.95)];
    [path addCurveToPoint: CGPointMake(30, 6.21) controlPoint1: CGPointMake(30, 17.34) controlPoint2: CGPointMake(30, 12.66)];
    [path addCurveToPoint: CGPointMake(29.71, 2.79) controlPoint1: CGPointMake(29.98, 5.04) controlPoint2: CGPointMake(29.99, 3.77)];
    [path addCurveToPoint: CGPointMake(26.39, 0.36) controlPoint1: CGPointMake(29.11, 0.78) controlPoint2: CGPointMake(27.31, 0.57)];
    [path addCurveToPoint: CGPointMake(18.33, -0) controlPoint1: CGPointMake(23.71, -0.08) controlPoint2: CGPointMake(21.01, 0.04)];
    [path closePath];
    [path moveToPoint: CGPointMake(18.31, 2.5)];
    [path addCurveToPoint: CGPointMake(20.11, 2.51) controlPoint1: CGPointMake(18.91, 2.51) controlPoint2: CGPointMake(19.51, 2.51)];
    [path addCurveToPoint: CGPointMake(25.92, 2.81) controlPoint1: CGPointMake(22.13, 2.51) controlPoint2: CGPointMake(24.05, 2.51)];
    [path addLineToPoint: CGPointMake(26.11, 2.85)];
    [path addCurveToPoint: CGPointMake(27.3, 3.49) controlPoint1: CGPointMake(27.18, 3.08) controlPoint2: CGPointMake(27.22, 3.21)];
    [path addCurveToPoint: CGPointMake(27.49, 5.93) controlPoint1: CGPointMake(27.47, 4.05) controlPoint2: CGPointMake(27.48, 5.05)];
    [path addLineToPoint: CGPointMake(27.5, 6.21)];
    [path addCurveToPoint: CGPointMake(27.5, 23.75) controlPoint1: CGPointMake(27.5, 12.66) controlPoint2: CGPointMake(27.5, 17.34)];
    [path addLineToPoint: CGPointMake(27.49, 24.09)];
    [path addCurveToPoint: CGPointMake(27.31, 26.47) controlPoint1: CGPointMake(27.48, 24.96) controlPoint2: CGPointMake(27.47, 25.95)];
    [path addCurveToPoint: CGPointMake(27.21, 26.75) controlPoint1: CGPointMake(27.25, 26.67) controlPoint2: CGPointMake(27.21, 26.75)];
    [path addCurveToPoint: CGPointMake(27, 26.87) controlPoint1: CGPointMake(27.18, 26.77) controlPoint2: CGPointMake(27.08, 26.83)];
    [path addCurveToPoint: CGPointMake(24.58, 27.36) controlPoint1: CGPointMake(26.32, 27.19) controlPoint2: CGPointMake(25.51, 27.27)];
    [path addLineToPoint: CGPointMake(24.33, 27.38)];
    [path addCurveToPoint: CGPointMake(18.98, 27.5) controlPoint1: CGPointMake(22.54, 27.49) controlPoint2: CGPointMake(20.73, 27.5)];
    [path addCurveToPoint: CGPointMake(15, 27.5) controlPoint1: CGPointMake(17.65, 27.5) controlPoint2: CGPointMake(16.33, 27.5)];
    [path addCurveToPoint: CGPointMake(11.04, 27.5) controlPoint1: CGPointMake(13.67, 27.5) controlPoint2: CGPointMake(12.35, 27.5)];
    [path addCurveToPoint: CGPointMake(9.66, 27.49) controlPoint1: CGPointMake(10.58, 27.49) controlPoint2: CGPointMake(10.12, 27.49)];
    [path addCurveToPoint: CGPointMake(4.08, 27.19) controlPoint1: CGPointMake(7.71, 27.48) controlPoint2: CGPointMake(5.87, 27.48)];
    [path addLineToPoint: CGPointMake(3.89, 27.15)];
    [path addCurveToPoint: CGPointMake(2.7, 26.51) controlPoint1: CGPointMake(2.82, 26.92) controlPoint2: CGPointMake(2.78, 26.79)];
    [path addCurveToPoint: CGPointMake(2.51, 24.07) controlPoint1: CGPointMake(2.53, 25.95) controlPoint2: CGPointMake(2.52, 24.95)];
    [path addLineToPoint: CGPointMake(2.5, 23.79)];
    [path addCurveToPoint: CGPointMake(2.5, 6.25) controlPoint1: CGPointMake(2.5, 17.34) controlPoint2: CGPointMake(2.5, 12.66)];
    [path addLineToPoint: CGPointMake(2.51, 5.91)];
    [path addCurveToPoint: CGPointMake(2.69, 3.51) controlPoint1: CGPointMake(2.52, 5.04) controlPoint2: CGPointMake(2.53, 4.05)];
    [path addCurveToPoint: CGPointMake(3.89, 2.85) controlPoint1: CGPointMake(2.78, 3.2) controlPoint2: CGPointMake(2.82, 3.08)];
    [path addLineToPoint: CGPointMake(4.08, 2.81)];
    [path addCurveToPoint: CGPointMake(9.89, 2.51) controlPoint1: CGPointMake(5.95, 2.51) controlPoint2: CGPointMake(7.87, 2.51)];
    [path addCurveToPoint: CGPointMake(11.67, 2.5) controlPoint1: CGPointMake(10.5, 2.51) controlPoint2: CGPointMake(11.1, 2.51)];
    [path addLineToPoint: CGPointMake(14.96, 2.5)];
    [path addLineToPoint: CGPointMake(18.31, 2.5)];
    [path closePath];
    return path;
}

static UIBezierPath *StepperPathUp()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(12.5, 10.5)];
    [path addCurveToPoint: CGPointMake(10.07, 12.93) controlPoint1: CGPointMake(11.69, 11.31) controlPoint2: CGPointMake(10.88, 12.12)];
    [path addCurveToPoint: CGPointMake(6.91, 16.19) controlPoint1: CGPointMake(9, 14) controlPoint2: CGPointMake(7.93, 15.07)];
    [path addCurveToPoint: CGPointMake(6.04, 17.22) controlPoint1: CGPointMake(6.6, 16.52) controlPoint2: CGPointMake(6.31, 16.86)];
    [path addCurveToPoint: CGPointMake(5.59, 17.94) controlPoint1: CGPointMake(5.86, 17.45) controlPoint2: CGPointMake(5.7, 17.69)];
    [path addCurveToPoint: CGPointMake(5.58, 18.58) controlPoint1: CGPointMake(5.48, 18.18) controlPoint2: CGPointMake(5.46, 18.4)];
    [path addCurveToPoint: CGPointMake(5.76, 18.81) controlPoint1: CGPointMake(5.63, 18.66) controlPoint2: CGPointMake(5.69, 18.74)];
    [path addCurveToPoint: CGPointMake(6.22, 19.28) controlPoint1: CGPointMake(5.91, 18.97) controlPoint2: CGPointMake(6.07, 19.12)];
    [path addCurveToPoint: CGPointMake(6.44, 19.49) controlPoint1: CGPointMake(6.29, 19.35) controlPoint2: CGPointMake(6.37, 19.42)];
    [path addCurveToPoint: CGPointMake(6.47, 19.52) controlPoint1: CGPointMake(6.45, 19.5) controlPoint2: CGPointMake(6.46, 19.51)];
    [path addCurveToPoint: CGPointMake(6.69, 19.74) controlPoint1: CGPointMake(6.54, 19.59) controlPoint2: CGPointMake(6.62, 19.67)];
    [path addCurveToPoint: CGPointMake(6.92, 19.92) controlPoint1: CGPointMake(6.76, 19.81) controlPoint2: CGPointMake(6.84, 19.87)];
    [path addCurveToPoint: CGPointMake(7.56, 19.92) controlPoint1: CGPointMake(7.1, 20.04) controlPoint2: CGPointMake(7.32, 20.02)];
    [path addCurveToPoint: CGPointMake(8.28, 19.47) controlPoint1: CGPointMake(7.81, 19.8) controlPoint2: CGPointMake(8.05, 19.64)];
    [path addCurveToPoint: CGPointMake(9.31, 18.59) controlPoint1: CGPointMake(8.64, 19.2) controlPoint2: CGPointMake(8.98, 18.9)];
    [path addCurveToPoint: CGPointMake(12.58, 15.43) controlPoint1: CGPointMake(10.43, 17.57) controlPoint2: CGPointMake(11.5, 16.5)];
    [path addCurveToPoint: CGPointMake(15, 13.01) controlPoint1: CGPointMake(13.39, 14.62) controlPoint2: CGPointMake(14.19, 13.81)];
    [path addCurveToPoint: CGPointMake(17.42, 15.43) controlPoint1: CGPointMake(15.81, 13.81) controlPoint2: CGPointMake(16.61, 14.62)];
    [path addCurveToPoint: CGPointMake(20.69, 18.59) controlPoint1: CGPointMake(18.5, 16.5) controlPoint2: CGPointMake(19.57, 17.57)];
    [path addCurveToPoint: CGPointMake(21.72, 19.47) controlPoint1: CGPointMake(21.02, 18.9) controlPoint2: CGPointMake(21.36, 19.2)];
    [path addCurveToPoint: CGPointMake(22.44, 19.92) controlPoint1: CGPointMake(21.95, 19.64) controlPoint2: CGPointMake(22.19, 19.8)];
    [path addCurveToPoint: CGPointMake(23.08, 19.92) controlPoint1: CGPointMake(22.68, 20.02) controlPoint2: CGPointMake(22.9, 20.04)];
    [path addCurveToPoint: CGPointMake(23.31, 19.74) controlPoint1: CGPointMake(23.16, 19.87) controlPoint2: CGPointMake(23.24, 19.81)];
    [path addCurveToPoint: CGPointMake(23.78, 19.28) controlPoint1: CGPointMake(23.46, 19.59) controlPoint2: CGPointMake(23.62, 19.44)];
    [path addCurveToPoint: CGPointMake(23.99, 19.07) controlPoint1: CGPointMake(23.85, 19.21) controlPoint2: CGPointMake(23.92, 19.14)];
    [path addCurveToPoint: CGPointMake(24.02, 19.04) controlPoint1: CGPointMake(24, 19.05) controlPoint2: CGPointMake(24.01, 19.05)];
    [path addCurveToPoint: CGPointMake(24.24, 18.81) controlPoint1: CGPointMake(24.09, 18.96) controlPoint2: CGPointMake(24.17, 18.88)];
    [path addCurveToPoint: CGPointMake(24.42, 18.58) controlPoint1: CGPointMake(24.31, 18.74) controlPoint2: CGPointMake(24.37, 18.66)];
    [path addCurveToPoint: CGPointMake(24.41, 17.94) controlPoint1: CGPointMake(24.54, 18.4) controlPoint2: CGPointMake(24.52, 18.18)];
    [path addCurveToPoint: CGPointMake(23.97, 17.22) controlPoint1: CGPointMake(24.3, 17.69) controlPoint2: CGPointMake(24.14, 17.45)];
    [path addCurveToPoint: CGPointMake(23.09, 16.19) controlPoint1: CGPointMake(23.69, 16.86) controlPoint2: CGPointMake(23.4, 16.52)];
    [path addCurveToPoint: CGPointMake(19.93, 12.93) controlPoint1: CGPointMake(22.07, 15.07) controlPoint2: CGPointMake(21, 14)];
    [path addCurveToPoint: CGPointMake(17.5, 10.5) controlPoint1: CGPointMake(19.12, 12.12) controlPoint2: CGPointMake(18.31, 11.31)];
    [path addCurveToPoint: CGPointMake(15, 8) controlPoint1: CGPointMake(16.67, 9.67) controlPoint2: CGPointMake(15.84, 8.83)];
    [path addCurveToPoint: CGPointMake(12.5, 10.5) controlPoint1: CGPointMake(14.17, 8.83) controlPoint2: CGPointMake(13.33, 9.67)];
    [path closePath];
    return path;
}

static UIBezierPath *StepperPathDown()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(17.5, 19.5)];
    [path addCurveToPoint: CGPointMake(19.93, 17.07) controlPoint1: CGPointMake(18.31, 18.69) controlPoint2: CGPointMake(19.12, 17.88)];
    [path addCurveToPoint: CGPointMake(23.09, 13.81) controlPoint1: CGPointMake(21, 16) controlPoint2: CGPointMake(22.07, 14.93)];
    [path addCurveToPoint: CGPointMake(23.97, 12.78) controlPoint1: CGPointMake(23.4, 13.48) controlPoint2: CGPointMake(23.69, 13.14)];
    [path addCurveToPoint: CGPointMake(24.41, 12.05) controlPoint1: CGPointMake(24.14, 12.55) controlPoint2: CGPointMake(24.3, 12.31)];
    [path addCurveToPoint: CGPointMake(24.42, 11.42) controlPoint1: CGPointMake(24.52, 11.82) controlPoint2: CGPointMake(24.54, 11.6)];
    [path addCurveToPoint: CGPointMake(24.24, 11.19) controlPoint1: CGPointMake(24.37, 11.34) controlPoint2: CGPointMake(24.31, 11.26)];
    [path addCurveToPoint: CGPointMake(23.78, 10.72) controlPoint1: CGPointMake(24.09, 11.03) controlPoint2: CGPointMake(23.93, 10.88)];
    [path addCurveToPoint: CGPointMake(23.56, 10.51) controlPoint1: CGPointMake(23.71, 10.65) controlPoint2: CGPointMake(23.64, 10.58)];
    [path addCurveToPoint: CGPointMake(23.53, 10.48) controlPoint1: CGPointMake(23.55, 10.5) controlPoint2: CGPointMake(23.54, 10.49)];
    [path addCurveToPoint: CGPointMake(23.31, 10.26) controlPoint1: CGPointMake(23.46, 10.41) controlPoint2: CGPointMake(23.38, 10.33)];
    [path addCurveToPoint: CGPointMake(23.08, 10.08) controlPoint1: CGPointMake(23.24, 10.19) controlPoint2: CGPointMake(23.16, 10.13)];
    [path addCurveToPoint: CGPointMake(22.44, 10.08) controlPoint1: CGPointMake(22.9, 9.96) controlPoint2: CGPointMake(22.68, 9.98)];
    [path addCurveToPoint: CGPointMake(21.72, 10.53) controlPoint1: CGPointMake(22.19, 10.2) controlPoint2: CGPointMake(21.95, 10.36)];
    [path addCurveToPoint: CGPointMake(20.69, 11.41) controlPoint1: CGPointMake(21.36, 10.8) controlPoint2: CGPointMake(21.02, 11.1)];
    [path addCurveToPoint: CGPointMake(17.42, 14.57) controlPoint1: CGPointMake(19.57, 12.43) controlPoint2: CGPointMake(18.5, 13.5)];
    [path addCurveToPoint: CGPointMake(15, 16.99) controlPoint1: CGPointMake(16.61, 15.38) controlPoint2: CGPointMake(15.81, 16.19)];
    [path addCurveToPoint: CGPointMake(12.58, 14.57) controlPoint1: CGPointMake(14.19, 16.19) controlPoint2: CGPointMake(13.39, 15.38)];
    [path addCurveToPoint: CGPointMake(9.31, 11.41) controlPoint1: CGPointMake(11.51, 13.5) controlPoint2: CGPointMake(10.43, 12.43)];
    [path addCurveToPoint: CGPointMake(8.28, 10.53) controlPoint1: CGPointMake(8.98, 11.1) controlPoint2: CGPointMake(8.64, 10.8)];
    [path addCurveToPoint: CGPointMake(7.56, 10.08) controlPoint1: CGPointMake(8.05, 10.36) controlPoint2: CGPointMake(7.81, 10.2)];
    [path addCurveToPoint: CGPointMake(6.92, 10.08) controlPoint1: CGPointMake(7.32, 9.98) controlPoint2: CGPointMake(7.1, 9.96)];
    [path addCurveToPoint: CGPointMake(6.69, 10.26) controlPoint1: CGPointMake(6.84, 10.13) controlPoint2: CGPointMake(6.76, 10.19)];
    [path addCurveToPoint: CGPointMake(6.23, 10.72) controlPoint1: CGPointMake(6.54, 10.41) controlPoint2: CGPointMake(6.38, 10.56)];
    [path addCurveToPoint: CGPointMake(6.01, 10.94) controlPoint1: CGPointMake(6.15, 10.79) controlPoint2: CGPointMake(6.08, 10.86)];
    [path addLineToPoint: CGPointMake(5.98, 10.96)];
    [path addCurveToPoint: CGPointMake(5.76, 11.19) controlPoint1: CGPointMake(5.91, 11.04) controlPoint2: CGPointMake(5.83, 11.12)];
    [path addCurveToPoint: CGPointMake(5.58, 11.42) controlPoint1: CGPointMake(5.69, 11.26) controlPoint2: CGPointMake(5.63, 11.34)];
    [path addCurveToPoint: CGPointMake(5.59, 12.05) controlPoint1: CGPointMake(5.46, 11.6) controlPoint2: CGPointMake(5.48, 11.82)];
    [path addCurveToPoint: CGPointMake(6.04, 12.78) controlPoint1: CGPointMake(5.7, 12.31) controlPoint2: CGPointMake(5.86, 12.55)];
    [path addCurveToPoint: CGPointMake(6.91, 13.81) controlPoint1: CGPointMake(6.31, 13.14) controlPoint2: CGPointMake(6.6, 13.48)];
    [path addCurveToPoint: CGPointMake(10.07, 17.07) controlPoint1: CGPointMake(7.93, 14.93) controlPoint2: CGPointMake(9, 16)];
    [path addCurveToPoint: CGPointMake(12.5, 19.5) controlPoint1: CGPointMake(10.88, 17.88) controlPoint2: CGPointMake(11.69, 18.69)];
    [path addCurveToPoint: CGPointMake(15, 22) controlPoint1: CGPointMake(13.33, 20.33) controlPoint2: CGPointMake(14.17, 21.17)];
    [path addCurveToPoint: CGPointMake(17.5, 19.5) controlPoint1: CGPointMake(15.84, 21.17) controlPoint2: CGPointMake(16.67, 20.33)];
    [path closePath];
    return path;
}

static UIBezierPath *StepperPathLeft()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(10.5, 17.5)];
    [path addCurveToPoint: CGPointMake(12.93, 19.93) controlPoint1: CGPointMake(11.31, 18.31) controlPoint2: CGPointMake(12.12, 19.12)];
    [path addCurveToPoint: CGPointMake(16.19, 23.09) controlPoint1: CGPointMake(14, 21) controlPoint2: CGPointMake(15.07, 22.07)];
    [path addCurveToPoint: CGPointMake(17.22, 23.96) controlPoint1: CGPointMake(16.52, 23.4) controlPoint2: CGPointMake(16.86, 23.69)];
    [path addCurveToPoint: CGPointMake(17.94, 24.41) controlPoint1: CGPointMake(17.45, 24.14) controlPoint2: CGPointMake(17.69, 24.3)];
    [path addCurveToPoint: CGPointMake(18.58, 24.42) controlPoint1: CGPointMake(18.18, 24.52) controlPoint2: CGPointMake(18.4, 24.54)];
    [path addCurveToPoint: CGPointMake(18.81, 24.24) controlPoint1: CGPointMake(18.66, 24.37) controlPoint2: CGPointMake(18.74, 24.31)];
    [path addCurveToPoint: CGPointMake(19.28, 23.78) controlPoint1: CGPointMake(18.97, 24.09) controlPoint2: CGPointMake(19.12, 23.93)];
    [path addCurveToPoint: CGPointMake(19.49, 23.56) controlPoint1: CGPointMake(19.35, 23.71) controlPoint2: CGPointMake(19.42, 23.63)];
    [path addCurveToPoint: CGPointMake(19.52, 23.53) controlPoint1: CGPointMake(19.5, 23.55) controlPoint2: CGPointMake(19.51, 23.54)];
    [path addCurveToPoint: CGPointMake(19.74, 23.31) controlPoint1: CGPointMake(19.59, 23.46) controlPoint2: CGPointMake(19.67, 23.38)];
    [path addCurveToPoint: CGPointMake(19.92, 23.08) controlPoint1: CGPointMake(19.81, 23.24) controlPoint2: CGPointMake(19.87, 23.16)];
    [path addCurveToPoint: CGPointMake(19.92, 22.44) controlPoint1: CGPointMake(20.04, 22.9) controlPoint2: CGPointMake(20.02, 22.68)];
    [path addCurveToPoint: CGPointMake(19.47, 21.72) controlPoint1: CGPointMake(19.8, 22.19) controlPoint2: CGPointMake(19.64, 21.95)];
    [path addCurveToPoint: CGPointMake(18.59, 20.69) controlPoint1: CGPointMake(19.19, 21.36) controlPoint2: CGPointMake(18.9, 21.02)];
    [path addCurveToPoint: CGPointMake(15.43, 17.42) controlPoint1: CGPointMake(17.57, 19.57) controlPoint2: CGPointMake(16.5, 18.5)];
    [path addCurveToPoint: CGPointMake(13.01, 15) controlPoint1: CGPointMake(14.62, 16.61) controlPoint2: CGPointMake(13.81, 15.81)];
    [path addCurveToPoint: CGPointMake(15.43, 12.58) controlPoint1: CGPointMake(13.81, 14.19) controlPoint2: CGPointMake(14.62, 13.39)];
    [path addCurveToPoint: CGPointMake(18.59, 9.31) controlPoint1: CGPointMake(16.5, 11.5) controlPoint2: CGPointMake(17.57, 10.43)];
    [path addCurveToPoint: CGPointMake(19.47, 8.28) controlPoint1: CGPointMake(18.9, 8.98) controlPoint2: CGPointMake(19.19, 8.64)];
    [path addCurveToPoint: CGPointMake(19.92, 7.56) controlPoint1: CGPointMake(19.64, 8.05) controlPoint2: CGPointMake(19.8, 7.81)];
    [path addCurveToPoint: CGPointMake(19.92, 6.92) controlPoint1: CGPointMake(20.02, 7.32) controlPoint2: CGPointMake(20.04, 7.1)];
    [path addCurveToPoint: CGPointMake(19.74, 6.69) controlPoint1: CGPointMake(19.87, 6.84) controlPoint2: CGPointMake(19.81, 6.76)];
    [path addCurveToPoint: CGPointMake(19.28, 6.23) controlPoint1: CGPointMake(19.59, 6.54) controlPoint2: CGPointMake(19.44, 6.38)];
    [path addCurveToPoint: CGPointMake(19.06, 6.01) controlPoint1: CGPointMake(19.21, 6.15) controlPoint2: CGPointMake(19.14, 6.08)];
    [path addCurveToPoint: CGPointMake(19.04, 5.98) controlPoint1: CGPointMake(19.06, 6) controlPoint2: CGPointMake(19.05, 5.99)];
    [path addCurveToPoint: CGPointMake(18.81, 5.76) controlPoint1: CGPointMake(18.96, 5.91) controlPoint2: CGPointMake(18.88, 5.83)];
    [path addCurveToPoint: CGPointMake(18.58, 5.58) controlPoint1: CGPointMake(18.74, 5.69) controlPoint2: CGPointMake(18.66, 5.63)];
    [path addCurveToPoint: CGPointMake(17.94, 5.59) controlPoint1: CGPointMake(18.4, 5.46) controlPoint2: CGPointMake(18.18, 5.48)];
    [path addCurveToPoint: CGPointMake(17.22, 6.04) controlPoint1: CGPointMake(17.69, 5.7) controlPoint2: CGPointMake(17.45, 5.86)];
    [path addCurveToPoint: CGPointMake(16.19, 6.91) controlPoint1: CGPointMake(16.86, 6.31) controlPoint2: CGPointMake(16.52, 6.6)];
    [path addCurveToPoint: CGPointMake(12.93, 10.07) controlPoint1: CGPointMake(15.07, 7.93) controlPoint2: CGPointMake(14, 9)];
    [path addCurveToPoint: CGPointMake(10.5, 12.5) controlPoint1: CGPointMake(12.12, 10.88) controlPoint2: CGPointMake(11.31, 11.69)];
    [path addCurveToPoint: CGPointMake(8, 15) controlPoint1: CGPointMake(9.67, 13.33) controlPoint2: CGPointMake(8.83, 14.17)];
    [path addCurveToPoint: CGPointMake(10.5, 17.5) controlPoint1: CGPointMake(8.83, 15.84) controlPoint2: CGPointMake(9.67, 16.67)];
    [path closePath];
    return path;
}

static UIBezierPath *StepperPathRight()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(19.5, 12.5)];
    [path addCurveToPoint: CGPointMake(17.07, 10.07) controlPoint1: CGPointMake(18.69, 11.69) controlPoint2: CGPointMake(17.88, 10.88)];
    [path addCurveToPoint: CGPointMake(13.81, 6.91) controlPoint1: CGPointMake(16, 9) controlPoint2: CGPointMake(14.93, 7.93)];
    [path addCurveToPoint: CGPointMake(12.78, 6.04) controlPoint1: CGPointMake(13.48, 6.6) controlPoint2: CGPointMake(13.14, 6.31)];
    [path addCurveToPoint: CGPointMake(12.06, 5.59) controlPoint1: CGPointMake(12.55, 5.86) controlPoint2: CGPointMake(12.31, 5.7)];
    [path addCurveToPoint: CGPointMake(11.42, 5.58) controlPoint1: CGPointMake(11.82, 5.48) controlPoint2: CGPointMake(11.6, 5.46)];
    [path addCurveToPoint: CGPointMake(11.19, 5.76) controlPoint1: CGPointMake(11.34, 5.63) controlPoint2: CGPointMake(11.26, 5.69)];
    [path addCurveToPoint: CGPointMake(10.72, 6.22) controlPoint1: CGPointMake(11.03, 5.91) controlPoint2: CGPointMake(10.88, 6.07)];
    [path addCurveToPoint: CGPointMake(10.51, 6.44) controlPoint1: CGPointMake(10.65, 6.29) controlPoint2: CGPointMake(10.58, 6.37)];
    [path addLineToPoint: CGPointMake(10.48, 6.47)];
    [path addCurveToPoint: CGPointMake(10.26, 6.69) controlPoint1: CGPointMake(10.4, 6.54) controlPoint2: CGPointMake(10.33, 6.62)];
    [path addCurveToPoint: CGPointMake(10.08, 6.92) controlPoint1: CGPointMake(10.19, 6.76) controlPoint2: CGPointMake(10.13, 6.84)];
    [path addCurveToPoint: CGPointMake(10.08, 7.56) controlPoint1: CGPointMake(9.96, 7.1) controlPoint2: CGPointMake(9.98, 7.32)];
    [path addCurveToPoint: CGPointMake(10.53, 8.28) controlPoint1: CGPointMake(10.2, 7.81) controlPoint2: CGPointMake(10.36, 8.05)];
    [path addCurveToPoint: CGPointMake(11.41, 9.31) controlPoint1: CGPointMake(10.81, 8.64) controlPoint2: CGPointMake(11.1, 8.98)];
    [path addCurveToPoint: CGPointMake(14.57, 12.58) controlPoint1: CGPointMake(12.43, 10.43) controlPoint2: CGPointMake(13.5, 11.5)];
    [path addCurveToPoint: CGPointMake(16.99, 15) controlPoint1: CGPointMake(15.38, 13.38) controlPoint2: CGPointMake(16.19, 14.19)];
    [path addCurveToPoint: CGPointMake(14.57, 17.42) controlPoint1: CGPointMake(16.19, 15.81) controlPoint2: CGPointMake(15.38, 16.61)];
    [path addCurveToPoint: CGPointMake(11.41, 20.69) controlPoint1: CGPointMake(13.5, 18.5) controlPoint2: CGPointMake(12.43, 19.57)];
    [path addCurveToPoint: CGPointMake(10.53, 21.72) controlPoint1: CGPointMake(11.1, 21.02) controlPoint2: CGPointMake(10.81, 21.36)];
    [path addCurveToPoint: CGPointMake(10.08, 22.44) controlPoint1: CGPointMake(10.36, 21.95) controlPoint2: CGPointMake(10.2, 22.19)];
    [path addCurveToPoint: CGPointMake(10.08, 23.08) controlPoint1: CGPointMake(9.98, 22.68) controlPoint2: CGPointMake(9.96, 22.9)];
    [path addCurveToPoint: CGPointMake(10.26, 23.31) controlPoint1: CGPointMake(10.13, 23.16) controlPoint2: CGPointMake(10.19, 23.24)];
    [path addCurveToPoint: CGPointMake(10.72, 23.77) controlPoint1: CGPointMake(10.41, 23.46) controlPoint2: CGPointMake(10.56, 23.62)];
    [path addCurveToPoint: CGPointMake(10.94, 23.99) controlPoint1: CGPointMake(10.79, 23.85) controlPoint2: CGPointMake(10.86, 23.92)];
    [path addCurveToPoint: CGPointMake(10.96, 24.02) controlPoint1: CGPointMake(10.94, 24) controlPoint2: CGPointMake(10.95, 24.01)];
    [path addCurveToPoint: CGPointMake(11.19, 24.24) controlPoint1: CGPointMake(11.04, 24.09) controlPoint2: CGPointMake(11.12, 24.17)];
    [path addCurveToPoint: CGPointMake(11.42, 24.42) controlPoint1: CGPointMake(11.26, 24.31) controlPoint2: CGPointMake(11.34, 24.37)];
    [path addCurveToPoint: CGPointMake(12.06, 24.41) controlPoint1: CGPointMake(11.6, 24.54) controlPoint2: CGPointMake(11.82, 24.52)];
    [path addCurveToPoint: CGPointMake(12.78, 23.96) controlPoint1: CGPointMake(12.31, 24.3) controlPoint2: CGPointMake(12.55, 24.14)];
    [path addCurveToPoint: CGPointMake(13.81, 23.09) controlPoint1: CGPointMake(13.14, 23.69) controlPoint2: CGPointMake(13.48, 23.4)];
    [path addCurveToPoint: CGPointMake(17.07, 19.93) controlPoint1: CGPointMake(14.93, 22.07) controlPoint2: CGPointMake(16, 21)];
    [path addCurveToPoint: CGPointMake(19.5, 17.5) controlPoint1: CGPointMake(17.88, 19.12) controlPoint2: CGPointMake(18.69, 18.31)];
    [path addCurveToPoint: CGPointMake(22, 15) controlPoint1: CGPointMake(20.33, 16.67) controlPoint2: CGPointMake(21.17, 15.83)];
    [path addCurveToPoint: CGPointMake(19.5, 12.5) controlPoint1: CGPointMake(21.17, 14.16) controlPoint2: CGPointMake(20.33, 13.33)];
    [path closePath];
    return path;
}

@interface UPStepper ()
@property (nonatomic, readwrite) UPStepperDirection direction;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPStepper

+ (UPStepper *)stepperWithDirection:(UPStepperDirection)direction
{
    return [[UPStepper alloc] initWithDirection:direction target:nil action:nullptr];
}

+ (UPStepper *)stepperWithDirection:(UPStepperDirection)direction target:(id)target action:(SEL)action
{
    return [[UPStepper alloc] initWithDirection:direction target:target action:action];
}

- (instancetype)initWithDirection:(UPStepperDirection)direction target:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    self.direction = direction;
    self.target = target;
    self.action = action;
    [self addGestureRecognizer:[UPTapGestureRecognizer gestureWithTarget:self action:@selector(handleTap:)]];
    
    self.canonicalSize = CGSizeMake(30, 30);
    [self setFillPath:ButtonFillPath() forState:UPControlStateNormal];
    [self setFillColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [self setStrokePath:ButtonStrokePath() forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryHighlightedStroke forState:UPControlStateHighlighted];

    UIBezierPath *path = nil;
    switch (self.direction) {
        case UPStepperDirectionDefault:
        case UPStepperDirectionUp:
            path = StepperPathUp();
            break;
        case UPStepperDirectionDown:
            path = StepperPathDown();
            break;
        case UPStepperDirectionLeft:
            path = StepperPathLeft();
            break;
        case UPStepperDirectionRight:
            path = StepperPathRight();
            break;
    }
    [self setContentPath:path forState:UPControlStateNormal];
    
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

@end
