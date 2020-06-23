//
//  UPControl+UPSpell.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPGeometry.h>

#import "UPControl+UPSpell.h"
#import "UPSpellLayout.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

namespace UP {

UIBezierPath *RoundGameButtonFillPath()
{
    CGRect rect = up_rect_make(SpellLayout::CanonicalRoundGameButtonSize);
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

UIBezierPath *RoundGameButtonStrokePath()
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

UIBezierPath *RoundBackButtonFillPath()
{
    CGRect rect = up_rect_make(SpellLayout::CanonicalRoundBackButtonSize);
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

UIBezierPath *RoundBackButtonStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(32, 0)];
    [path addCurveToPoint: CGPointMake(-0, 32) controlPoint1: CGPointMake(14.33, 0) controlPoint2: CGPointMake(-0, 14.33)];
    [path addCurveToPoint: CGPointMake(32, 64) controlPoint1: CGPointMake(-0, 49.67) controlPoint2: CGPointMake(14.33, 64)];
    [path addCurveToPoint: CGPointMake(64, 32) controlPoint1: CGPointMake(49.67, 64) controlPoint2: CGPointMake(64, 49.67)];
    [path addCurveToPoint: CGPointMake(32, 0) controlPoint1: CGPointMake(64, 14.33) controlPoint2: CGPointMake(49.67, 0)];
    [path closePath];
    [path moveToPoint: CGPointMake(32, 3)];
    [path addCurveToPoint: CGPointMake(61, 32) controlPoint1: CGPointMake(47.99, 3) controlPoint2: CGPointMake(61, 16.01)];
    [path addCurveToPoint: CGPointMake(32, 61) controlPoint1: CGPointMake(61, 47.99) controlPoint2: CGPointMake(47.99, 61)];
    [path addCurveToPoint: CGPointMake(3, 32) controlPoint1: CGPointMake(16.01, 61) controlPoint2: CGPointMake(3, 47.99)];
    [path addCurveToPoint: CGPointMake(32, 3) controlPoint1: CGPointMake(3, 16.01) controlPoint2: CGPointMake(16.01, 3)];
    [path closePath];
    return path;
}

UIBezierPath *RoundGameButtonMinusSignIconPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(70, 42.76)];
    [path addCurveToPoint: CGPointMake(70, 41.99) controlPoint1: CGPointMake(70, 42.5) controlPoint2: CGPointMake(70, 42.25)];
    [path addCurveToPoint: CGPointMake(69.99, 40.48) controlPoint1: CGPointMake(70, 41.49) controlPoint2: CGPointMake(70, 40.98)];
    [path addCurveToPoint: CGPointMake(69.92, 39.65) controlPoint1: CGPointMake(69.99, 40.2) controlPoint2: CGPointMake(69.96, 39.92)];
    [path addCurveToPoint: CGPointMake(69.24, 38.65) controlPoint1: CGPointMake(69.86, 39.24) controlPoint2: CGPointMake(69.63, 38.9)];
    [path addCurveToPoint: CGPointMake(68.34, 38.26) controlPoint1: CGPointMake(68.96, 38.48) controlPoint2: CGPointMake(68.66, 38.36)];
    [path addCurveToPoint: CGPointMake(65.68, 37.81) controlPoint1: CGPointMake(67.48, 38.01) controlPoint2: CGPointMake(66.58, 37.9)];
    [path addCurveToPoint: CGPointMake(61.54, 37.59) controlPoint1: CGPointMake(64.31, 37.68) controlPoint2: CGPointMake(62.93, 37.61)];
    [path addCurveToPoint: CGPointMake(55.65, 37.51) controlPoint1: CGPointMake(59.58, 37.55) controlPoint2: CGPointMake(57.61, 37.51)];
    [path addCurveToPoint: CGPointMake(30.27, 37.5) controlPoint1: CGPointMake(47.19, 37.5) controlPoint2: CGPointMake(38.73, 37.5)];
    [path addCurveToPoint: CGPointMake(20.02, 37.69) controlPoint1: CGPointMake(26.85, 37.51) controlPoint2: CGPointMake(23.43, 37.5)];
    [path addCurveToPoint: CGPointMake(16.98, 37.98) controlPoint1: CGPointMake(19, 37.74) controlPoint2: CGPointMake(17.98, 37.82)];
    [path addCurveToPoint: CGPointMake(15.11, 38.47) controlPoint1: CGPointMake(16.33, 38.08) controlPoint2: CGPointMake(15.7, 38.2)];
    [path addCurveToPoint: CGPointMake(14.08, 39.59) controlPoint1: CGPointMake(14.57, 38.7) controlPoint2: CGPointMake(14.19, 39.06)];
    [path addCurveToPoint: CGPointMake(14.01, 40.32) controlPoint1: CGPointMake(14.04, 39.84) controlPoint2: CGPointMake(14.01, 40.08)];
    [path addCurveToPoint: CGPointMake(14, 42) controlPoint1: CGPointMake(14, 40.88) controlPoint2: CGPointMake(14, 41.44)];
    [path addCurveToPoint: CGPointMake(14, 42.77) controlPoint1: CGPointMake(14, 42.25) controlPoint2: CGPointMake(14, 42.51)];
    [path addLineToPoint: CGPointMake(14, 42.87)];
    [path addCurveToPoint: CGPointMake(14.01, 43.68) controlPoint1: CGPointMake(14, 43.14) controlPoint2: CGPointMake(14, 43.41)];
    [path addCurveToPoint: CGPointMake(14.08, 44.4) controlPoint1: CGPointMake(14.01, 43.92) controlPoint2: CGPointMake(14.04, 44.16)];
    [path addCurveToPoint: CGPointMake(15.11, 45.54) controlPoint1: CGPointMake(14.19, 44.94) controlPoint2: CGPointMake(14.57, 45.3)];
    [path addCurveToPoint: CGPointMake(16.98, 46.02) controlPoint1: CGPointMake(15.7, 45.8) controlPoint2: CGPointMake(16.33, 45.92)];
    [path addCurveToPoint: CGPointMake(20.02, 46.32) controlPoint1: CGPointMake(17.98, 46.18) controlPoint2: CGPointMake(19, 46.26)];
    [path addCurveToPoint: CGPointMake(30.27, 46.5) controlPoint1: CGPointMake(23.43, 46.5) controlPoint2: CGPointMake(26.85, 46.49)];
    [path addCurveToPoint: CGPointMake(55.65, 46.49) controlPoint1: CGPointMake(38.73, 46.5) controlPoint2: CGPointMake(47.19, 46.5)];
    [path addCurveToPoint: CGPointMake(61.54, 46.41) controlPoint1: CGPointMake(57.61, 46.49) controlPoint2: CGPointMake(59.58, 46.45)];
    [path addCurveToPoint: CGPointMake(65.68, 46.19) controlPoint1: CGPointMake(62.93, 46.39) controlPoint2: CGPointMake(64.31, 46.32)];
    [path addCurveToPoint: CGPointMake(68.34, 45.74) controlPoint1: CGPointMake(66.58, 46.1) controlPoint2: CGPointMake(67.48, 45.99)];
    [path addCurveToPoint: CGPointMake(69.24, 45.34) controlPoint1: CGPointMake(68.66, 45.64) controlPoint2: CGPointMake(68.96, 45.52)];
    [path addCurveToPoint: CGPointMake(69.92, 44.35) controlPoint1: CGPointMake(69.63, 45.1) controlPoint2: CGPointMake(69.86, 44.76)];
    [path addCurveToPoint: CGPointMake(69.99, 43.52) controlPoint1: CGPointMake(69.96, 44.07) controlPoint2: CGPointMake(69.99, 43.8)];
    [path addCurveToPoint: CGPointMake(70, 42.76) controlPoint1: CGPointMake(70, 43.27) controlPoint2: CGPointMake(70, 43.01)];
    [path addLineToPoint: CGPointMake(70, 42.76)];
    [path closePath];
    return path;
}

UIBezierPath *RoundGameButtonTrashIconPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(26.47, 26.42)];
    [path addLineToPoint: CGPointMake(26.67, 26.42)];
    [path addCurveToPoint: CGPointMake(30.06, 26.45) controlPoint1: CGPointMake(27.8, 26.44) controlPoint2: CGPointMake(28.93, 26.45)];
    [path addCurveToPoint: CGPointMake(52.26, 26.45) controlPoint1: CGPointMake(37.46, 26.46) controlPoint2: CGPointMake(44.86, 26.46)];
    [path addCurveToPoint: CGPointMake(57.53, 26.42) controlPoint1: CGPointMake(54.21, 26.45) controlPoint2: CGPointMake(55.94, 26.44)];
    [path addLineToPoint: CGPointMake(54.49, 62.58)];
    [path addLineToPoint: CGPointMake(54.48, 62.81)];
    [path addCurveToPoint: CGPointMake(51.49, 65.95) controlPoint1: CGPointMake(54.48, 64.54) controlPoint2: CGPointMake(53.14, 65.95)];
    [path addLineToPoint: CGPointMake(32.52, 65.95)];
    [path addCurveToPoint: CGPointMake(29.52, 62.81) controlPoint1: CGPointMake(30.86, 65.95) controlPoint2: CGPointMake(29.52, 64.54)];
    [path addLineToPoint: CGPointMake(29.52, 62.72)];
    [path addLineToPoint: CGPointMake(26.47, 26.42)];
    [path closePath];
    [path moveToPoint: CGPointMake(35.69, 21.21)];
    [path addLineToPoint: CGPointMake(35.69, 21.07)];
    [path addCurveToPoint: CGPointMake(39.32, 17.28) controlPoint1: CGPointMake(35.7, 18.98) controlPoint2: CGPointMake(37.33, 17.28)];
    [path addLineToPoint: CGPointMake(44.68, 17.28)];
    [path addCurveToPoint: CGPointMake(48.31, 21.07) controlPoint1: CGPointMake(46.67, 17.28) controlPoint2: CGPointMake(48.3, 18.98)];
    [path addLineToPoint: CGPointMake(48.31, 21.21)];
    [path addCurveToPoint: CGPointMake(35.69, 21.21) controlPoint1: CGPointMake(44.11, 21.21) controlPoint2: CGPointMake(39.9, 21.21)];
    [path closePath];
    [path moveToPoint: CGPointMake(66.62, 23.4)];
    [path addCurveToPoint: CGPointMake(66.62, 23.35) controlPoint1: CGPointMake(66.62, 23.38) controlPoint2: CGPointMake(66.62, 23.36)];
    [path addLineToPoint: CGPointMake(66.62, 22.9)];
    [path addCurveToPoint: CGPointMake(66.55, 22.46) controlPoint1: CGPointMake(66.62, 22.75) controlPoint2: CGPointMake(66.59, 22.61)];
    [path addCurveToPoint: CGPointMake(65.56, 21.75) controlPoint1: CGPointMake(66.45, 22.14) controlPoint2: CGPointMake(66.13, 21.9)];
    [path addCurveToPoint: CGPointMake(63.91, 21.47) controlPoint1: CGPointMake(65.03, 21.6) controlPoint2: CGPointMake(64.45, 21.53)];
    [path addCurveToPoint: CGPointMake(61.24, 21.31) controlPoint1: CGPointMake(62.94, 21.38) controlPoint2: CGPointMake(61.97, 21.33)];
    [path addCurveToPoint: CGPointMake(52.47, 21.21) controlPoint1: CGPointMake(58.32, 21.21) controlPoint2: CGPointMake(55.35, 21.21)];
    [path addLineToPoint: CGPointMake(52.04, 21.21)];
    [path addLineToPoint: CGPointMake(52.04, 21.07)];
    [path addCurveToPoint: CGPointMake(44.68, 13.38) controlPoint1: CGPointMake(52.03, 16.83) controlPoint2: CGPointMake(48.73, 13.38)];
    [path addLineToPoint: CGPointMake(39.32, 13.38)];
    [path addCurveToPoint: CGPointMake(31.96, 21.07) controlPoint1: CGPointMake(35.27, 13.38) controlPoint2: CGPointMake(31.97, 16.83)];
    [path addLineToPoint: CGPointMake(31.96, 21.21)];
    [path addLineToPoint: CGPointMake(30.06, 21.21)];
    [path addCurveToPoint: CGPointMake(24.9, 21.25) controlPoint1: CGPointMake(28.39, 21.21) controlPoint2: CGPointMake(26.73, 21.23)];
    [path addCurveToPoint: CGPointMake(21.27, 21.38) controlPoint1: CGPointMake(23.55, 21.27) controlPoint2: CGPointMake(22.36, 21.31)];
    [path addCurveToPoint: CGPointMake(18.93, 21.63) controlPoint1: CGPointMake(20.55, 21.42) controlPoint2: CGPointMake(19.73, 21.48)];
    [path addCurveToPoint: CGPointMake(18.12, 21.86) controlPoint1: CGPointMake(18.61, 21.69) controlPoint2: CGPointMake(18.34, 21.77)];
    [path addCurveToPoint: CGPointMake(17.45, 22.5) controlPoint1: CGPointMake(17.74, 22.01) controlPoint2: CGPointMake(17.51, 22.22)];
    [path addCurveToPoint: CGPointMake(17.38, 22.98) controlPoint1: CGPointMake(17.41, 22.66) controlPoint2: CGPointMake(17.38, 22.83)];
    [path addCurveToPoint: CGPointMake(17.38, 23.41) controlPoint1: CGPointMake(17.38, 23.13) controlPoint2: CGPointMake(17.38, 23.27)];
    [path addCurveToPoint: CGPointMake(17.38, 23.83) controlPoint1: CGPointMake(17.38, 23.55) controlPoint2: CGPointMake(17.37, 23.69)];
    [path addCurveToPoint: CGPointMake(17.38, 24.68) controlPoint1: CGPointMake(17.37, 24.12) controlPoint2: CGPointMake(17.38, 24.4)];
    [path addCurveToPoint: CGPointMake(17.45, 25.17) controlPoint1: CGPointMake(17.38, 24.83) controlPoint2: CGPointMake(17.41, 25)];
    [path addCurveToPoint: CGPointMake(18.12, 25.81) controlPoint1: CGPointMake(17.51, 25.44) controlPoint2: CGPointMake(17.74, 25.65)];
    [path addCurveToPoint: CGPointMake(18.93, 26.03) controlPoint1: CGPointMake(18.34, 25.9) controlPoint2: CGPointMake(18.61, 25.97)];
    [path addCurveToPoint: CGPointMake(21.27, 26.28) controlPoint1: CGPointMake(19.73, 26.18) controlPoint2: CGPointMake(20.56, 26.24)];
    [path addCurveToPoint: CGPointMake(21.78, 26.31) controlPoint1: CGPointMake(21.44, 26.29) controlPoint2: CGPointMake(21.61, 26.3)];
    [path addLineToPoint: CGPointMake(21.97, 26.32)];
    [path addLineToPoint: CGPointMake(25.05, 62.93)];
    [path addCurveToPoint: CGPointMake(32.52, 70.63) controlPoint1: CGPointMake(25.11, 67.17) controlPoint2: CGPointMake(28.46, 70.63)];
    [path addLineToPoint: CGPointMake(51.49, 70.63)];
    [path addCurveToPoint: CGPointMake(58.96, 62.9) controlPoint1: CGPointMake(55.54, 70.63) controlPoint2: CGPointMake(58.89, 67.16)];
    [path addLineToPoint: CGPointMake(62.03, 26.32)];
    [path addCurveToPoint: CGPointMake(63.91, 26.19) controlPoint1: CGPointMake(62.59, 26.29) controlPoint2: CGPointMake(63.25, 26.26)];
    [path addCurveToPoint: CGPointMake(65.56, 25.92) controlPoint1: CGPointMake(64.45, 26.14) controlPoint2: CGPointMake(65.03, 26.07)];
    [path addCurveToPoint: CGPointMake(66.55, 25.2) controlPoint1: CGPointMake(66.13, 25.76) controlPoint2: CGPointMake(66.45, 25.53)];
    [path addCurveToPoint: CGPointMake(66.62, 24.77) controlPoint1: CGPointMake(66.59, 25.06) controlPoint2: CGPointMake(66.62, 24.91)];
    [path addCurveToPoint: CGPointMake(66.63, 23.83) controlPoint1: CGPointMake(66.62, 24.46) controlPoint2: CGPointMake(66.63, 24.14)];
    [path addLineToPoint: CGPointMake(66.62, 23.4)];
    [path closePath];
    

    [path moveToPoint: CGPointMake(32.24, 38.27)];
    [path addCurveToPoint: CGPointMake(32.97, 52.3) controlPoint1: CGPointMake(32.48, 42.95) controlPoint2: CGPointMake(32.72, 47.62)];
    [path addLineToPoint: CGPointMake(32.98, 52.47)];
    [path addCurveToPoint: CGPointMake(33.33, 57.97) controlPoint1: CGPointMake(33.08, 54.28) controlPoint2: CGPointMake(33.17, 56.14)];
    [path addCurveToPoint: CGPointMake(33.52, 59.65) controlPoint1: CGPointMake(33.37, 58.43) controlPoint2: CGPointMake(33.43, 59.05)];
    [path addCurveToPoint: CGPointMake(33.74, 60.7) controlPoint1: CGPointMake(33.57, 60) controlPoint2: CGPointMake(33.63, 60.36)];
    [path addCurveToPoint: CGPointMake(34.23, 61.33) controlPoint1: CGPointMake(33.86, 61.06) controlPoint2: CGPointMake(34.02, 61.27)];
    [path addCurveToPoint: CGPointMake(34.48, 61.36) controlPoint1: CGPointMake(34.31, 61.35) controlPoint2: CGPointMake(34.4, 61.36)];
    [path addCurveToPoint: CGPointMake(34.51, 61.36) controlPoint1: CGPointMake(34.49, 61.36) controlPoint2: CGPointMake(34.5, 61.36)];
    [path addLineToPoint: CGPointMake(35.07, 61.33)];
    [path addCurveToPoint: CGPointMake(35.63, 61.3) controlPoint1: CGPointMake(35.26, 61.33) controlPoint2: CGPointMake(35.45, 61.31)];
    [path addCurveToPoint: CGPointMake(35.91, 61.24) controlPoint1: CGPointMake(35.72, 61.3) controlPoint2: CGPointMake(35.81, 61.27)];
    [path addCurveToPoint: CGPointMake(36.33, 60.56) controlPoint1: CGPointMake(36.11, 61.16) controlPoint2: CGPointMake(36.25, 60.94)];
    [path addCurveToPoint: CGPointMake(36.44, 59.5) controlPoint1: CGPointMake(36.41, 60.22) controlPoint2: CGPointMake(36.43, 59.85)];
    [path addCurveToPoint: CGPointMake(36.45, 57.81) controlPoint1: CGPointMake(36.47, 58.88) controlPoint2: CGPointMake(36.46, 58.27)];
    [path addCurveToPoint: CGPointMake(36.23, 52.38) controlPoint1: CGPointMake(36.42, 56) controlPoint2: CGPointMake(36.32, 54.16)];
    [path addLineToPoint: CGPointMake(36.22, 52.13)];
    [path addCurveToPoint: CGPointMake(35.48, 38.1) controlPoint1: CGPointMake(35.97, 47.45) controlPoint2: CGPointMake(35.73, 42.78)];
    [path addCurveToPoint: CGPointMake(35.28, 34.84) controlPoint1: CGPointMake(35.42, 37.01) controlPoint2: CGPointMake(35.35, 35.93)];
    [path addCurveToPoint: CGPointMake(35.09, 32.55) controlPoint1: CGPointMake(35.23, 34) controlPoint2: CGPointMake(35.16, 33.25)];
    [path addCurveToPoint: CGPointMake(34.86, 31.08) controlPoint1: CGPointMake(35.04, 32.1) controlPoint2: CGPointMake(34.97, 31.57)];
    [path addCurveToPoint: CGPointMake(34.69, 30.56) controlPoint1: CGPointMake(34.81, 30.87) controlPoint2: CGPointMake(34.76, 30.7)];
    [path addCurveToPoint: CGPointMake(34.25, 30.13) controlPoint1: CGPointMake(34.58, 30.31) controlPoint2: CGPointMake(34.43, 30.17)];
    [path addCurveToPoint: CGPointMake(33.94, 30.1) controlPoint1: CGPointMake(34.15, 30.11) controlPoint2: CGPointMake(34.04, 30.1)];
    [path addCurveToPoint: CGPointMake(33.44, 30.13) controlPoint1: CGPointMake(33.78, 30.11) controlPoint2: CGPointMake(33.61, 30.12)];
    [path addLineToPoint: CGPointMake(32.93, 30.16)];
    [path addCurveToPoint: CGPointMake(32.63, 30.22) controlPoint1: CGPointMake(32.83, 30.17) controlPoint2: CGPointMake(32.73, 30.19)];
    [path addCurveToPoint: CGPointMake(32.23, 30.69) controlPoint1: CGPointMake(32.45, 30.27) controlPoint2: CGPointMake(32.32, 30.43)];
    [path addCurveToPoint: CGPointMake(32.12, 31.22) controlPoint1: CGPointMake(32.18, 30.84) controlPoint2: CGPointMake(32.15, 31.02)];
    [path addCurveToPoint: CGPointMake(32.05, 32.71) controlPoint1: CGPointMake(32.07, 31.68) controlPoint2: CGPointMake(32.05, 32.15)];
    [path addCurveToPoint: CGPointMake(32.09, 35.02) controlPoint1: CGPointMake(32.04, 33.39) controlPoint2: CGPointMake(32.06, 34.12)];
    [path addCurveToPoint: CGPointMake(32.24, 38.27) controlPoint1: CGPointMake(32.14, 36.1) controlPoint2: CGPointMake(32.18, 37.19)];
    [path closePath];
    

    [path moveToPoint: CGPointMake(40.58, 59.6)];
    [path addCurveToPoint: CGPointMake(40.75, 60.65) controlPoint1: CGPointMake(40.61, 59.94) controlPoint2: CGPointMake(40.66, 60.31)];
    [path addCurveToPoint: CGPointMake(41.21, 61.3) controlPoint1: CGPointMake(40.85, 61.02) controlPoint2: CGPointMake(41, 61.24)];
    [path addCurveToPoint: CGPointMake(41.49, 61.35) controlPoint1: CGPointMake(41.3, 61.34) controlPoint2: CGPointMake(41.39, 61.35)];
    [path addCurveToPoint: CGPointMake(41.95, 61.36) controlPoint1: CGPointMake(41.64, 61.36) controlPoint2: CGPointMake(41.8, 61.36)];
    [path addLineToPoint: CGPointMake(42.05, 61.36)];
    [path addLineToPoint: CGPointMake(42.61, 61.35)];
    [path addCurveToPoint: CGPointMake(42.89, 61.3) controlPoint1: CGPointMake(42.7, 61.35) controlPoint2: CGPointMake(42.79, 61.34)];
    [path addCurveToPoint: CGPointMake(43.35, 60.65) controlPoint1: CGPointMake(43.1, 61.24) controlPoint2: CGPointMake(43.25, 61.02)];
    [path addCurveToPoint: CGPointMake(43.51, 59.6) controlPoint1: CGPointMake(43.44, 60.3) controlPoint2: CGPointMake(43.48, 59.92)];
    [path addCurveToPoint: CGPointMake(43.61, 57.91) controlPoint1: CGPointMake(43.57, 58.99) controlPoint2: CGPointMake(43.6, 58.37)];
    [path addCurveToPoint: CGPointMake(43.67, 52.4) controlPoint1: CGPointMake(43.67, 56.07) controlPoint2: CGPointMake(43.67, 54.21)];
    [path addLineToPoint: CGPointMake(43.67, 52.22)];
    [path addCurveToPoint: CGPointMake(43.67, 38.18) controlPoint1: CGPointMake(43.67, 47.54) controlPoint2: CGPointMake(43.67, 42.86)];
    [path addCurveToPoint: CGPointMake(43.64, 34.91) controlPoint1: CGPointMake(43.67, 37.09) controlPoint2: CGPointMake(43.66, 36)];
    [path addCurveToPoint: CGPointMake(43.57, 32.61) controlPoint1: CGPointMake(43.63, 34.06) controlPoint2: CGPointMake(43.61, 33.31)];
    [path addCurveToPoint: CGPointMake(43.42, 31.13) controlPoint1: CGPointMake(43.54, 32.05) controlPoint2: CGPointMake(43.5, 31.59)];
    [path addCurveToPoint: CGPointMake(43.28, 30.61) controlPoint1: CGPointMake(43.38, 30.92) controlPoint2: CGPointMake(43.33, 30.75)];
    [path addCurveToPoint: CGPointMake(42.86, 30.16) controlPoint1: CGPointMake(43.18, 30.35) controlPoint2: CGPointMake(43.04, 30.2)];
    [path addCurveToPoint: CGPointMake(42.56, 30.11) controlPoint1: CGPointMake(42.76, 30.13) controlPoint2: CGPointMake(42.66, 30.11)];
    [path addLineToPoint: CGPointMake(42.3, 30.11)];
    [path addCurveToPoint: CGPointMake(42.05, 30.11) controlPoint1: CGPointMake(42.22, 30.11) controlPoint2: CGPointMake(42.13, 30.11)];
    [path addCurveToPoint: CGPointMake(41.54, 30.11) controlPoint1: CGPointMake(41.88, 30.11) controlPoint2: CGPointMake(41.71, 30.11)];
    [path addCurveToPoint: CGPointMake(41.23, 30.16) controlPoint1: CGPointMake(41.44, 30.11) controlPoint2: CGPointMake(41.34, 30.13)];
    [path addCurveToPoint: CGPointMake(40.81, 30.61) controlPoint1: CGPointMake(41.05, 30.2) controlPoint2: CGPointMake(40.91, 30.35)];
    [path addCurveToPoint: CGPointMake(40.68, 31.13) controlPoint1: CGPointMake(40.76, 30.75) controlPoint2: CGPointMake(40.72, 30.92)];
    [path addCurveToPoint: CGPointMake(40.53, 32.61) controlPoint1: CGPointMake(40.59, 31.63) controlPoint2: CGPointMake(40.55, 32.16)];
    [path addCurveToPoint: CGPointMake(40.45, 34.91) controlPoint1: CGPointMake(40.49, 33.29) controlPoint2: CGPointMake(40.46, 34.02)];
    [path addCurveToPoint: CGPointMake(40.43, 38.18) controlPoint1: CGPointMake(40.44, 36) controlPoint2: CGPointMake(40.43, 37.09)];
    [path addCurveToPoint: CGPointMake(40.42, 52.22) controlPoint1: CGPointMake(40.42, 42.86) controlPoint2: CGPointMake(40.42, 47.54)];
    [path addLineToPoint: CGPointMake(40.42, 52.4)];
    [path addCurveToPoint: CGPointMake(40.48, 57.91) controlPoint1: CGPointMake(40.42, 54.21) controlPoint2: CGPointMake(40.43, 56.07)];
    [path addCurveToPoint: CGPointMake(40.58, 59.6) controlPoint1: CGPointMake(40.5, 58.57) controlPoint2: CGPointMake(40.54, 59.11)];
    [path closePath];
    

    [path moveToPoint: CGPointMake(47.67, 60.56)];
    [path addCurveToPoint: CGPointMake(48.09, 61.24) controlPoint1: CGPointMake(47.75, 60.94) controlPoint2: CGPointMake(47.89, 61.16)];
    [path addCurveToPoint: CGPointMake(48.37, 61.3) controlPoint1: CGPointMake(48.19, 61.27) controlPoint2: CGPointMake(48.28, 61.3)];
    [path addCurveToPoint: CGPointMake(48.93, 61.33) controlPoint1: CGPointMake(48.55, 61.31) controlPoint2: CGPointMake(48.74, 61.33)];
    [path addLineToPoint: CGPointMake(49.49, 61.36)];
    [path addCurveToPoint: CGPointMake(49.52, 61.36) controlPoint1: CGPointMake(49.5, 61.36) controlPoint2: CGPointMake(49.51, 61.36)];
    [path addCurveToPoint: CGPointMake(49.77, 61.33) controlPoint1: CGPointMake(49.6, 61.36) controlPoint2: CGPointMake(49.69, 61.35)];
    [path addCurveToPoint: CGPointMake(50.26, 60.7) controlPoint1: CGPointMake(49.98, 61.27) controlPoint2: CGPointMake(50.14, 61.06)];
    [path addCurveToPoint: CGPointMake(50.48, 59.65) controlPoint1: CGPointMake(50.37, 60.36) controlPoint2: CGPointMake(50.43, 60)];
    [path addCurveToPoint: CGPointMake(50.67, 57.97) controlPoint1: CGPointMake(50.56, 59.16) controlPoint2: CGPointMake(50.61, 58.63)];
    [path addCurveToPoint: CGPointMake(51.02, 52.47) controlPoint1: CGPointMake(50.83, 56.14) controlPoint2: CGPointMake(50.92, 54.28)];
    [path addLineToPoint: CGPointMake(51.03, 52.3)];
    [path addCurveToPoint: CGPointMake(51.76, 38.27) controlPoint1: CGPointMake(51.28, 47.62) controlPoint2: CGPointMake(51.52, 42.95)];
    [path addCurveToPoint: CGPointMake(51.91, 35.01) controlPoint1: CGPointMake(51.82, 37.18) controlPoint2: CGPointMake(51.86, 36.1)];
    [path addCurveToPoint: CGPointMake(51.95, 32.71) controlPoint1: CGPointMake(51.94, 34.16) controlPoint2: CGPointMake(51.96, 33.41)];
    [path addCurveToPoint: CGPointMake(51.88, 31.22) controlPoint1: CGPointMake(51.95, 32.15) controlPoint2: CGPointMake(51.93, 31.68)];
    [path addCurveToPoint: CGPointMake(51.77, 30.69) controlPoint1: CGPointMake(51.85, 31.02) controlPoint2: CGPointMake(51.82, 30.84)];
    [path addLineToPoint: CGPointMake(51.77, 30.69)];
    [path addCurveToPoint: CGPointMake(51.38, 30.22) controlPoint1: CGPointMake(51.68, 30.43) controlPoint2: CGPointMake(51.55, 30.27)];
    [path addCurveToPoint: CGPointMake(51.07, 30.16) controlPoint1: CGPointMake(51.28, 30.19) controlPoint2: CGPointMake(51.17, 30.17)];
    [path addLineToPoint: CGPointMake(50.56, 30.13)];
    [path addCurveToPoint: CGPointMake(50.06, 30.1) controlPoint1: CGPointMake(50.39, 30.12) controlPoint2: CGPointMake(50.22, 30.11)];
    [path addCurveToPoint: CGPointMake(49.75, 30.13) controlPoint1: CGPointMake(49.96, 30.1) controlPoint2: CGPointMake(49.86, 30.11)];
    [path addCurveToPoint: CGPointMake(49.31, 30.56) controlPoint1: CGPointMake(49.57, 30.17) controlPoint2: CGPointMake(49.42, 30.31)];
    [path addCurveToPoint: CGPointMake(49.14, 31.08) controlPoint1: CGPointMake(49.25, 30.71) controlPoint2: CGPointMake(49.19, 30.88)];
    [path addCurveToPoint: CGPointMake(48.91, 32.55) controlPoint1: CGPointMake(49.03, 31.57) controlPoint2: CGPointMake(48.96, 32.1)];
    [path addCurveToPoint: CGPointMake(48.72, 34.84) controlPoint1: CGPointMake(48.84, 33.25) controlPoint2: CGPointMake(48.77, 34)];
    [path addCurveToPoint: CGPointMake(48.52, 38.1) controlPoint1: CGPointMake(48.65, 35.93) controlPoint2: CGPointMake(48.58, 37.01)];
    [path addCurveToPoint: CGPointMake(47.79, 52.13) controlPoint1: CGPointMake(48.27, 42.78) controlPoint2: CGPointMake(48.03, 47.45)];
    [path addLineToPoint: CGPointMake(47.78, 52.22)];
    [path addCurveToPoint: CGPointMake(47.55, 57.81) controlPoint1: CGPointMake(47.69, 54.05) controlPoint2: CGPointMake(47.59, 55.94)];
    [path addCurveToPoint: CGPointMake(47.56, 59.5) controlPoint1: CGPointMake(47.54, 58.27) controlPoint2: CGPointMake(47.53, 58.89)];
    [path addCurveToPoint: CGPointMake(47.67, 60.56) controlPoint1: CGPointMake(47.57, 59.84) controlPoint2: CGPointMake(47.59, 60.21)];
    [path closePath];

    return path;
}

UIBezierPath *RoundGameButtonDownArrowIconPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(40.62, 13.01)];
    [path addCurveToPoint: CGPointMake(39.98, 13.08) controlPoint1: CGPointMake(40.41, 13.01) controlPoint2: CGPointMake(40.19, 13.04)];
    [path addCurveToPoint: CGPointMake(39.2, 13.76) controlPoint1: CGPointMake(39.66, 13.14) controlPoint2: CGPointMake(39.39, 13.37)];
    [path addCurveToPoint: CGPointMake(38.9, 14.66) controlPoint1: CGPointMake(39.07, 14.04) controlPoint2: CGPointMake(38.97, 14.34)];
    [path addCurveToPoint: CGPointMake(38.55, 17.32) controlPoint1: CGPointMake(38.7, 15.52) controlPoint2: CGPointMake(38.61, 16.42)];
    [path addCurveToPoint: CGPointMake(38.37, 21.46) controlPoint1: CGPointMake(38.44, 18.69) controlPoint2: CGPointMake(38.39, 20.07)];
    [path addCurveToPoint: CGPointMake(38.31, 27.35) controlPoint1: CGPointMake(38.34, 23.42) controlPoint2: CGPointMake(38.31, 25.38)];
    [path addCurveToPoint: CGPointMake(38.31, 52.73) controlPoint1: CGPointMake(38.3, 35.81) controlPoint2: CGPointMake(38.3, 44.27)];
    [path addCurveToPoint: CGPointMake(38.32, 57.45) controlPoint1: CGPointMake(38.31, 54.3) controlPoint2: CGPointMake(38.31, 55.87)];
    [path addCurveToPoint: CGPointMake(28.54, 45.79) controlPoint1: CGPointMake(35.06, 53.56) controlPoint2: CGPointMake(31.8, 49.67)];
    [path addCurveToPoint: CGPointMake(25.92, 42.76) controlPoint1: CGPointMake(27.68, 44.77) controlPoint2: CGPointMake(26.8, 43.77)];
    [path addCurveToPoint: CGPointMake(23.98, 40.72) controlPoint1: CGPointMake(25.3, 42.06) controlPoint2: CGPointMake(24.66, 41.37)];
    [path addCurveToPoint: CGPointMake(22.55, 39.57) controlPoint1: CGPointMake(23.54, 40.3) controlPoint2: CGPointMake(23.08, 39.89)];
    [path addCurveToPoint: CGPointMake(21.93, 39.3) controlPoint1: CGPointMake(22.36, 39.45) controlPoint2: CGPointMake(22.15, 39.35)];
    [path addCurveToPoint: CGPointMake(21.04, 39.44) controlPoint1: CGPointMake(21.61, 39.22) controlPoint2: CGPointMake(21.31, 39.27)];
    [path addCurveToPoint: CGPointMake(20.51, 39.82) controlPoint1: CGPointMake(20.85, 39.56) controlPoint2: CGPointMake(20.68, 39.68)];
    [path addCurveToPoint: CGPointMake(20.06, 40.19) controlPoint1: CGPointMake(20.36, 39.94) controlPoint2: CGPointMake(20.21, 40.07)];
    [path addCurveToPoint: CGPointMake(20.05, 40.2) controlPoint1: CGPointMake(20.06, 40.2) controlPoint2: CGPointMake(20.06, 40.2)];
    [path addCurveToPoint: CGPointMake(19.6, 40.58) controlPoint1: CGPointMake(19.9, 40.32) controlPoint2: CGPointMake(19.75, 40.45)];
    [path addCurveToPoint: CGPointMake(18.7, 41.34) controlPoint1: CGPointMake(19.3, 40.83) controlPoint2: CGPointMake(19, 41.08)];
    [path addCurveToPoint: CGPointMake(18.24, 41.79) controlPoint1: CGPointMake(18.54, 41.48) controlPoint2: CGPointMake(18.38, 41.63)];
    [path addCurveToPoint: CGPointMake(17.94, 42.64) controlPoint1: CGPointMake(18.02, 42.03) controlPoint2: CGPointMake(17.92, 42.32)];
    [path addCurveToPoint: CGPointMake(18.1, 43.31) controlPoint1: CGPointMake(17.96, 42.87) controlPoint2: CGPointMake(18.02, 43.09)];
    [path addCurveToPoint: CGPointMake(18.99, 44.91) controlPoint1: CGPointMake(18.32, 43.88) controlPoint2: CGPointMake(18.65, 44.4)];
    [path addCurveToPoint: CGPointMake(20.66, 47.18) controlPoint1: CGPointMake(19.51, 45.69) controlPoint2: CGPointMake(20.07, 46.44)];
    [path addCurveToPoint: CGPointMake(23.19, 50.28) controlPoint1: CGPointMake(21.49, 48.22) controlPoint2: CGPointMake(22.33, 49.26)];
    [path addCurveToPoint: CGPointMake(34.25, 63.48) controlPoint1: CGPointMake(26.87, 54.68) controlPoint2: CGPointMake(30.56, 59.08)];
    [path addCurveToPoint: CGPointMake(38.55, 68.4) controlPoint1: CGPointMake(35.65, 65.14) controlPoint2: CGPointMake(37.06, 66.81)];
    [path addCurveToPoint: CGPointMake(38.57, 68.44) controlPoint1: CGPointMake(38.56, 68.41) controlPoint2: CGPointMake(38.56, 68.43)];
    [path addCurveToPoint: CGPointMake(38.69, 68.55) controlPoint1: CGPointMake(38.61, 68.48) controlPoint2: CGPointMake(38.65, 68.51)];
    [path addCurveToPoint: CGPointMake(38.83, 68.71) controlPoint1: CGPointMake(38.74, 68.6) controlPoint2: CGPointMake(38.78, 68.66)];
    [path addCurveToPoint: CGPointMake(40.33, 70.15) controlPoint1: CGPointMake(39.31, 69.22) controlPoint2: CGPointMake(39.8, 69.71)];
    [path addCurveToPoint: CGPointMake(41.44, 70.88) controlPoint1: CGPointMake(40.67, 70.43) controlPoint2: CGPointMake(41.03, 70.7)];
    [path addCurveToPoint: CGPointMake(41.96, 71) controlPoint1: CGPointMake(41.61, 70.95) controlPoint2: CGPointMake(41.79, 70.99)];
    [path addCurveToPoint: CGPointMake(42, 71) controlPoint1: CGPointMake(41.97, 71) controlPoint2: CGPointMake(41.99, 71)];
    [path addCurveToPoint: CGPointMake(42.04, 71) controlPoint1: CGPointMake(42.01, 71) controlPoint2: CGPointMake(42.02, 71)];
    [path addCurveToPoint: CGPointMake(42.56, 70.88) controlPoint1: CGPointMake(42.21, 70.99) controlPoint2: CGPointMake(42.39, 70.95)];
    [path addCurveToPoint: CGPointMake(43.67, 70.15) controlPoint1: CGPointMake(42.97, 70.7) controlPoint2: CGPointMake(43.33, 70.43)];
    [path addCurveToPoint: CGPointMake(45.17, 68.71) controlPoint1: CGPointMake(44.2, 69.71) controlPoint2: CGPointMake(44.69, 69.22)];
    [path addCurveToPoint: CGPointMake(45.31, 68.55) controlPoint1: CGPointMake(45.22, 68.66) controlPoint2: CGPointMake(45.26, 68.6)];
    [path addCurveToPoint: CGPointMake(45.42, 68.44) controlPoint1: CGPointMake(45.35, 68.51) controlPoint2: CGPointMake(45.39, 68.48)];
    [path addCurveToPoint: CGPointMake(45.45, 68.4) controlPoint1: CGPointMake(45.44, 68.43) controlPoint2: CGPointMake(45.44, 68.41)];
    [path addCurveToPoint: CGPointMake(49.75, 63.48) controlPoint1: CGPointMake(46.94, 66.81) controlPoint2: CGPointMake(48.35, 65.14)];
    [path addCurveToPoint: CGPointMake(60.81, 50.28) controlPoint1: CGPointMake(53.44, 59.08) controlPoint2: CGPointMake(57.13, 54.68)];
    [path addCurveToPoint: CGPointMake(63.34, 47.18) controlPoint1: CGPointMake(61.67, 49.26) controlPoint2: CGPointMake(62.5, 48.22)];
    [path addCurveToPoint: CGPointMake(65.01, 44.91) controlPoint1: CGPointMake(63.93, 46.44) controlPoint2: CGPointMake(64.49, 45.69)];
    [path addCurveToPoint: CGPointMake(65.9, 43.31) controlPoint1: CGPointMake(65.35, 44.4) controlPoint2: CGPointMake(65.67, 43.88)];
    [path addCurveToPoint: CGPointMake(66.06, 42.64) controlPoint1: CGPointMake(65.98, 43.09) controlPoint2: CGPointMake(66.04, 42.87)];
    [path addCurveToPoint: CGPointMake(65.76, 41.79) controlPoint1: CGPointMake(66.08, 42.32) controlPoint2: CGPointMake(65.98, 42.03)];
    [path addCurveToPoint: CGPointMake(65.3, 41.34) controlPoint1: CGPointMake(65.62, 41.63) controlPoint2: CGPointMake(65.46, 41.48)];
    [path addCurveToPoint: CGPointMake(64.4, 40.58) controlPoint1: CGPointMake(65, 41.08) controlPoint2: CGPointMake(64.7, 40.83)];
    [path addCurveToPoint: CGPointMake(63.95, 40.2) controlPoint1: CGPointMake(64.25, 40.45) controlPoint2: CGPointMake(64.1, 40.32)];
    [path addCurveToPoint: CGPointMake(63.94, 40.19) controlPoint1: CGPointMake(63.94, 40.2) controlPoint2: CGPointMake(63.94, 40.2)];
    [path addCurveToPoint: CGPointMake(63.49, 39.82) controlPoint1: CGPointMake(63.79, 40.07) controlPoint2: CGPointMake(63.64, 39.94)];
    [path addCurveToPoint: CGPointMake(62.96, 39.44) controlPoint1: CGPointMake(63.32, 39.68) controlPoint2: CGPointMake(63.14, 39.56)];
    [path addCurveToPoint: CGPointMake(62.07, 39.3) controlPoint1: CGPointMake(62.69, 39.27) controlPoint2: CGPointMake(62.39, 39.22)];
    [path addCurveToPoint: CGPointMake(61.44, 39.57) controlPoint1: CGPointMake(61.85, 39.35) controlPoint2: CGPointMake(61.64, 39.45)];
    [path addCurveToPoint: CGPointMake(60.02, 40.72) controlPoint1: CGPointMake(60.92, 39.89) controlPoint2: CGPointMake(60.46, 40.3)];
    [path addCurveToPoint: CGPointMake(58.08, 42.76) controlPoint1: CGPointMake(59.34, 41.37) controlPoint2: CGPointMake(58.7, 42.06)];
    [path addCurveToPoint: CGPointMake(55.46, 45.79) controlPoint1: CGPointMake(57.2, 43.77) controlPoint2: CGPointMake(56.32, 44.77)];
    [path addCurveToPoint: CGPointMake(45.28, 57.91) controlPoint1: CGPointMake(52.06, 49.83) controlPoint2: CGPointMake(48.67, 53.87)];
    [path addCurveToPoint: CGPointMake(45.3, 52.73) controlPoint1: CGPointMake(45.3, 56.19) controlPoint2: CGPointMake(45.3, 54.46)];
    [path addCurveToPoint: CGPointMake(45.3, 27.35) controlPoint1: CGPointMake(45.31, 44.27) controlPoint2: CGPointMake(45.3, 35.81)];
    [path addCurveToPoint: CGPointMake(45.24, 21.46) controlPoint1: CGPointMake(45.29, 25.38) controlPoint2: CGPointMake(45.27, 23.42)];
    [path addCurveToPoint: CGPointMake(45.06, 17.32) controlPoint1: CGPointMake(45.22, 20.07) controlPoint2: CGPointMake(45.17, 18.69)];
    [path addCurveToPoint: CGPointMake(44.71, 14.66) controlPoint1: CGPointMake(44.99, 16.42) controlPoint2: CGPointMake(44.91, 15.52)];
    [path addCurveToPoint: CGPointMake(44.41, 13.76) controlPoint1: CGPointMake(44.64, 14.34) controlPoint2: CGPointMake(44.54, 14.04)];
    [path addCurveToPoint: CGPointMake(43.63, 13.08) controlPoint1: CGPointMake(44.21, 13.37) controlPoint2: CGPointMake(43.95, 13.14)];
    [path addCurveToPoint: CGPointMake(42.99, 13.01) controlPoint1: CGPointMake(43.42, 13.04) controlPoint2: CGPointMake(43.2, 13.01)];
    [path addCurveToPoint: CGPointMake(42.4, 13) controlPoint1: CGPointMake(42.79, 13.01) controlPoint2: CGPointMake(42.59, 13)];
    [path addLineToPoint: CGPointMake(42.39, 13)];
    [path addCurveToPoint: CGPointMake(41.8, 13) controlPoint1: CGPointMake(42.19, 13) controlPoint2: CGPointMake(42, 13)];
    [path addCurveToPoint: CGPointMake(40.62, 13.01) controlPoint1: CGPointMake(41.41, 13) controlPoint2: CGPointMake(41.01, 13)];
    [path closePath];
    return path;
}

UIBezierPath *RoundBackButtonLeftArrowIconPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(9.54, 32.62)];
    [path addCurveToPoint: CGPointMake(10.17, 33.59) controlPoint1: CGPointMake(9.7, 33) controlPoint2: CGPointMake(9.94, 33.31)];
    [path addCurveToPoint: CGPointMake(11.3, 34.77) controlPoint1: CGPointMake(10.55, 34.05) controlPoint2: CGPointMake(10.98, 34.47)];
    [path addLineToPoint: CGPointMake(11.44, 34.9)];
    [path addCurveToPoint: CGPointMake(11.55, 35) controlPoint1: CGPointMake(11.47, 34.93) controlPoint2: CGPointMake(11.5, 34.96)];
    [path addCurveToPoint: CGPointMake(15.32, 38.29) controlPoint1: CGPointMake(12.74, 36.11) controlPoint2: CGPointMake(13.96, 37.14)];
    [path addCurveToPoint: CGPointMake(25.37, 46.72) controlPoint1: CGPointMake(18.67, 41.1) controlPoint2: CGPointMake(22.02, 43.91)];
    [path addCurveToPoint: CGPointMake(27.74, 48.65) controlPoint1: CGPointMake(26.15, 47.37) controlPoint2: CGPointMake(26.95, 48.01)];
    [path addCurveToPoint: CGPointMake(29.5, 49.95) controlPoint1: CGPointMake(28.38, 49.16) controlPoint2: CGPointMake(28.95, 49.58)];
    [path addCurveToPoint: CGPointMake(30.82, 50.67) controlPoint1: CGPointMake(29.88, 50.2) controlPoint2: CGPointMake(30.32, 50.48)];
    [path addCurveToPoint: CGPointMake(31.48, 50.83) controlPoint1: CGPointMake(31.05, 50.76) controlPoint2: CGPointMake(31.26, 50.81)];
    [path addCurveToPoint: CGPointMake(32.5, 50.47) controlPoint1: CGPointMake(31.86, 50.86) controlPoint2: CGPointMake(32.21, 50.73)];
    [path addCurveToPoint: CGPointMake(32.88, 50.08) controlPoint1: CGPointMake(32.63, 50.35) controlPoint2: CGPointMake(32.76, 50.22)];
    [path addCurveToPoint: CGPointMake(33.47, 49.39) controlPoint1: CGPointMake(33.08, 49.85) controlPoint2: CGPointMake(33.27, 49.62)];
    [path addLineToPoint: CGPointMake(33.69, 49.12)];
    [path addLineToPoint: CGPointMake(33.88, 49.03)];
    [path addLineToPoint: CGPointMake(33.88, 48.9)];
    [path addLineToPoint: CGPointMake(34.05, 48.69)];
    [path addCurveToPoint: CGPointMake(34.37, 48.24) controlPoint1: CGPointMake(34.17, 48.55) controlPoint2: CGPointMake(34.28, 48.39)];
    [path addCurveToPoint: CGPointMake(34.55, 47.17) controlPoint1: CGPointMake(34.58, 47.91) controlPoint2: CGPointMake(34.64, 47.54)];
    [path addCurveToPoint: CGPointMake(34.28, 46.56) controlPoint1: CGPointMake(34.49, 46.97) controlPoint2: CGPointMake(34.41, 46.77)];
    [path addCurveToPoint: CGPointMake(33.33, 45.38) controlPoint1: CGPointMake(34, 46.09) controlPoint2: CGPointMake(33.64, 45.71)];
    [path addCurveToPoint: CGPointMake(31.75, 43.87) controlPoint1: CGPointMake(32.88, 44.91) controlPoint2: CGPointMake(32.36, 44.41)];
    [path addCurveToPoint: CGPointMake(29.44, 41.87) controlPoint1: CGPointMake(30.98, 43.2) controlPoint2: CGPointMake(30.22, 42.53)];
    [path addCurveToPoint: CGPointMake(21.26, 35.01) controlPoint1: CGPointMake(26.71, 39.58) controlPoint2: CGPointMake(23.99, 37.3)];
    [path addCurveToPoint: CGPointMake(23.68, 35.02) controlPoint1: CGPointMake(22.07, 35.01) controlPoint2: CGPointMake(22.88, 35.02)];
    [path addLineToPoint: CGPointMake(23.82, 35.02)];
    [path addCurveToPoint: CGPointMake(43.16, 35.01) controlPoint1: CGPointMake(30.27, 35.02) controlPoint2: CGPointMake(36.72, 35.02)];
    [path addCurveToPoint: CGPointMake(47.66, 34.97) controlPoint1: CGPointMake(44.66, 35.01) controlPoint2: CGPointMake(46.16, 34.99)];
    [path addCurveToPoint: CGPointMake(50.85, 34.83) controlPoint1: CGPointMake(48.84, 34.95) controlPoint2: CGPointMake(49.88, 34.9)];
    [path addCurveToPoint: CGPointMake(52.94, 34.55) controlPoint1: CGPointMake(51.63, 34.77) controlPoint2: CGPointMake(52.29, 34.7)];
    [path addCurveToPoint: CGPointMake(53.74, 34.28) controlPoint1: CGPointMake(53.25, 34.48) controlPoint2: CGPointMake(53.51, 34.39)];
    [path addCurveToPoint: CGPointMake(54.53, 33.34) controlPoint1: CGPointMake(54.29, 34.01) controlPoint2: CGPointMake(54.47, 33.62)];
    [path addCurveToPoint: CGPointMake(54.59, 32.76) controlPoint1: CGPointMake(54.56, 33.15) controlPoint2: CGPointMake(54.59, 32.95)];
    [path addLineToPoint: CGPointMake(54.6, 31.85)];
    [path addCurveToPoint: CGPointMake(54.59, 30.94) controlPoint1: CGPointMake(54.6, 31.55) controlPoint2: CGPointMake(54.59, 31.25)];
    [path addLineToPoint: CGPointMake(54.59, 30.94)];
    [path addCurveToPoint: CGPointMake(54.53, 30.36) controlPoint1: CGPointMake(54.59, 30.75) controlPoint2: CGPointMake(54.56, 30.55)];
    [path addCurveToPoint: CGPointMake(53.74, 29.42) controlPoint1: CGPointMake(54.47, 30.08) controlPoint2: CGPointMake(54.29, 29.69)];
    [path addCurveToPoint: CGPointMake(52.94, 29.15) controlPoint1: CGPointMake(53.51, 29.31) controlPoint2: CGPointMake(53.25, 29.22)];
    [path addCurveToPoint: CGPointMake(50.85, 28.87) controlPoint1: CGPointMake(52.29, 29) controlPoint2: CGPointMake(51.63, 28.93)];
    [path addCurveToPoint: CGPointMake(47.66, 28.74) controlPoint1: CGPointMake(49.88, 28.8) controlPoint2: CGPointMake(48.84, 28.75)];
    [path addCurveToPoint: CGPointMake(43.16, 28.69) controlPoint1: CGPointMake(46.16, 28.71) controlPoint2: CGPointMake(44.66, 28.69)];
    [path addCurveToPoint: CGPointMake(30.6, 28.68) controlPoint1: CGPointMake(38.98, 28.69) controlPoint2: CGPointMake(34.79, 28.68)];
    [path addCurveToPoint: CGPointMake(21.62, 28.69) controlPoint1: CGPointMake(27.6, 28.68) controlPoint2: CGPointMake(24.61, 28.68)];
    [path addCurveToPoint: CGPointMake(29.44, 22.12) controlPoint1: CGPointMake(24.23, 26.5) controlPoint2: CGPointMake(26.83, 24.32)];
    [path addCurveToPoint: CGPointMake(31.75, 20.12) controlPoint1: CGPointMake(30.22, 21.47) controlPoint2: CGPointMake(30.98, 20.8)];
    [path addCurveToPoint: CGPointMake(33.33, 18.62) controlPoint1: CGPointMake(32.36, 19.59) controlPoint2: CGPointMake(32.88, 19.09)];
    [path addCurveToPoint: CGPointMake(34.28, 17.44) controlPoint1: CGPointMake(33.64, 18.29) controlPoint2: CGPointMake(34, 17.91)];
    [path addCurveToPoint: CGPointMake(34.55, 16.83) controlPoint1: CGPointMake(34.41, 17.23) controlPoint2: CGPointMake(34.49, 17.03)];
    [path addCurveToPoint: CGPointMake(34.37, 15.76) controlPoint1: CGPointMake(34.64, 16.46) controlPoint2: CGPointMake(34.58, 16.09)];
    [path addCurveToPoint: CGPointMake(34.05, 15.31) controlPoint1: CGPointMake(34.28, 15.61) controlPoint2: CGPointMake(34.17, 15.45)];
    [path addLineToPoint: CGPointMake(33.47, 14.61)];
    [path addCurveToPoint: CGPointMake(32.88, 13.92) controlPoint1: CGPointMake(33.27, 14.38) controlPoint2: CGPointMake(33.08, 14.15)];
    [path addCurveToPoint: CGPointMake(32.5, 13.52) controlPoint1: CGPointMake(32.76, 13.78) controlPoint2: CGPointMake(32.63, 13.65)];
    [path addCurveToPoint: CGPointMake(31.58, 13.17) controlPoint1: CGPointMake(32.24, 13.29) controlPoint2: CGPointMake(31.92, 13.17)];
    [path addCurveToPoint: CGPointMake(31.48, 13.17) controlPoint1: CGPointMake(31.55, 13.17) controlPoint2: CGPointMake(31.51, 13.17)];
    [path addCurveToPoint: CGPointMake(30.82, 13.33) controlPoint1: CGPointMake(31.27, 13.18) controlPoint2: CGPointMake(31.05, 13.24)];
    [path addCurveToPoint: CGPointMake(29.51, 14.05) controlPoint1: CGPointMake(30.32, 13.52) controlPoint2: CGPointMake(29.88, 13.8)];
    [path addCurveToPoint: CGPointMake(27.74, 15.35) controlPoint1: CGPointMake(28.95, 14.42) controlPoint2: CGPointMake(28.38, 14.84)];
    [path addCurveToPoint: CGPointMake(25.37, 17.28) controlPoint1: CGPointMake(26.95, 15.99) controlPoint2: CGPointMake(26.15, 16.63)];
    [path addCurveToPoint: CGPointMake(15.32, 25.71) controlPoint1: CGPointMake(22.02, 20.09) controlPoint2: CGPointMake(18.67, 22.9)];
    [path addCurveToPoint: CGPointMake(11.62, 28.95) controlPoint1: CGPointMake(13.96, 26.86) controlPoint2: CGPointMake(12.73, 27.89)];
    [path addLineToPoint: CGPointMake(11.53, 29.01)];
    [path addCurveToPoint: CGPointMake(11.39, 29.14) controlPoint1: CGPointMake(11.5, 29.04) controlPoint2: CGPointMake(11.47, 29.06)];
    [path addLineToPoint: CGPointMake(11.3, 29.22)];
    [path addCurveToPoint: CGPointMake(10.17, 30.41) controlPoint1: CGPointMake(10.98, 29.53) controlPoint2: CGPointMake(10.56, 29.95)];
    [path addCurveToPoint: CGPointMake(9.54, 31.37) controlPoint1: CGPointMake(9.94, 30.69) controlPoint2: CGPointMake(9.7, 31)];
    [path addCurveToPoint: CGPointMake(9.41, 31.89) controlPoint1: CGPointMake(9.46, 31.56) controlPoint2: CGPointMake(9.41, 31.76)];
    [path addLineToPoint: CGPointMake(9.41, 32.04)];
    [path addCurveToPoint: CGPointMake(9.54, 32.62) controlPoint1: CGPointMake(9.41, 32.24) controlPoint2: CGPointMake(9.46, 32.44)];
    [path closePath];
    return path;
}

UIBezierPath *RoundBackButtonRightArrowIconPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(54.46, 31.38)];
    [path addCurveToPoint: CGPointMake(53.83, 30.41) controlPoint1: CGPointMake(54.3, 31) controlPoint2: CGPointMake(54.06, 30.69)];
    [path addCurveToPoint: CGPointMake(52.7, 29.23) controlPoint1: CGPointMake(53.45, 29.95) controlPoint2: CGPointMake(53.02, 29.53)];
    [path addLineToPoint: CGPointMake(52.56, 29.1)];
    [path addCurveToPoint: CGPointMake(52.45, 29) controlPoint1: CGPointMake(52.53, 29.07) controlPoint2: CGPointMake(52.5, 29.04)];
    [path addCurveToPoint: CGPointMake(48.68, 25.71) controlPoint1: CGPointMake(51.26, 27.89) controlPoint2: CGPointMake(50.04, 26.86)];
    [path addCurveToPoint: CGPointMake(38.63, 17.28) controlPoint1: CGPointMake(45.33, 22.9) controlPoint2: CGPointMake(41.98, 20.09)];
    [path addCurveToPoint: CGPointMake(36.26, 15.35) controlPoint1: CGPointMake(37.85, 16.63) controlPoint2: CGPointMake(37.05, 15.99)];
    [path addCurveToPoint: CGPointMake(34.5, 14.05) controlPoint1: CGPointMake(35.62, 14.84) controlPoint2: CGPointMake(35.05, 14.42)];
    [path addCurveToPoint: CGPointMake(33.18, 13.33) controlPoint1: CGPointMake(34.12, 13.8) controlPoint2: CGPointMake(33.68, 13.52)];
    [path addCurveToPoint: CGPointMake(32.52, 13.17) controlPoint1: CGPointMake(32.95, 13.24) controlPoint2: CGPointMake(32.74, 13.19)];
    [path addCurveToPoint: CGPointMake(31.5, 13.53) controlPoint1: CGPointMake(32.14, 13.14) controlPoint2: CGPointMake(31.79, 13.27)];
    [path addCurveToPoint: CGPointMake(31.12, 13.92) controlPoint1: CGPointMake(31.37, 13.65) controlPoint2: CGPointMake(31.24, 13.78)];
    [path addCurveToPoint: CGPointMake(30.53, 14.61) controlPoint1: CGPointMake(30.92, 14.15) controlPoint2: CGPointMake(30.73, 14.38)];
    [path addLineToPoint: CGPointMake(30.31, 14.88)];
    [path addLineToPoint: CGPointMake(30.12, 14.97)];
    [path addLineToPoint: CGPointMake(30.12, 15.1)];
    [path addLineToPoint: CGPointMake(29.95, 15.31)];
    [path addCurveToPoint: CGPointMake(29.63, 15.76) controlPoint1: CGPointMake(29.83, 15.45) controlPoint2: CGPointMake(29.72, 15.61)];
    [path addCurveToPoint: CGPointMake(29.45, 16.83) controlPoint1: CGPointMake(29.42, 16.09) controlPoint2: CGPointMake(29.36, 16.46)];
    [path addCurveToPoint: CGPointMake(29.72, 17.44) controlPoint1: CGPointMake(29.51, 17.03) controlPoint2: CGPointMake(29.59, 17.23)];
    [path addCurveToPoint: CGPointMake(30.67, 18.62) controlPoint1: CGPointMake(30, 17.91) controlPoint2: CGPointMake(30.36, 18.29)];
    [path addCurveToPoint: CGPointMake(32.25, 20.13) controlPoint1: CGPointMake(31.12, 19.09) controlPoint2: CGPointMake(31.64, 19.59)];
    [path addCurveToPoint: CGPointMake(34.56, 22.13) controlPoint1: CGPointMake(33.02, 20.8) controlPoint2: CGPointMake(33.78, 21.47)];
    [path addCurveToPoint: CGPointMake(42.74, 28.99) controlPoint1: CGPointMake(37.29, 24.42) controlPoint2: CGPointMake(40.01, 26.7)];
    [path addCurveToPoint: CGPointMake(40.32, 28.98) controlPoint1: CGPointMake(41.93, 28.99) controlPoint2: CGPointMake(41.12, 28.98)];
    [path addLineToPoint: CGPointMake(40.18, 28.98)];
    [path addCurveToPoint: CGPointMake(20.84, 28.99) controlPoint1: CGPointMake(33.73, 28.98) controlPoint2: CGPointMake(27.28, 28.98)];
    [path addCurveToPoint: CGPointMake(16.34, 29.03) controlPoint1: CGPointMake(19.34, 28.99) controlPoint2: CGPointMake(17.84, 29.01)];
    [path addCurveToPoint: CGPointMake(13.15, 29.17) controlPoint1: CGPointMake(15.16, 29.05) controlPoint2: CGPointMake(14.12, 29.1)];
    [path addCurveToPoint: CGPointMake(11.06, 29.45) controlPoint1: CGPointMake(12.37, 29.23) controlPoint2: CGPointMake(11.71, 29.3)];
    [path addCurveToPoint: CGPointMake(10.26, 29.72) controlPoint1: CGPointMake(10.75, 29.52) controlPoint2: CGPointMake(10.49, 29.61)];
    [path addCurveToPoint: CGPointMake(9.47, 30.66) controlPoint1: CGPointMake(9.71, 29.99) controlPoint2: CGPointMake(9.53, 30.38)];
    [path addCurveToPoint: CGPointMake(9.41, 31.24) controlPoint1: CGPointMake(9.44, 30.85) controlPoint2: CGPointMake(9.41, 31.05)];
    [path addLineToPoint: CGPointMake(9.4, 32.15)];
    [path addCurveToPoint: CGPointMake(9.41, 33.06) controlPoint1: CGPointMake(9.4, 32.45) controlPoint2: CGPointMake(9.41, 32.75)];
    [path addLineToPoint: CGPointMake(9.41, 33.06)];
    [path addCurveToPoint: CGPointMake(9.47, 33.64) controlPoint1: CGPointMake(9.41, 33.25) controlPoint2: CGPointMake(9.44, 33.45)];
    [path addCurveToPoint: CGPointMake(10.26, 34.58) controlPoint1: CGPointMake(9.53, 33.92) controlPoint2: CGPointMake(9.71, 34.31)];
    [path addCurveToPoint: CGPointMake(11.06, 34.85) controlPoint1: CGPointMake(10.49, 34.69) controlPoint2: CGPointMake(10.75, 34.78)];
    [path addCurveToPoint: CGPointMake(13.15, 35.13) controlPoint1: CGPointMake(11.71, 35) controlPoint2: CGPointMake(12.37, 35.07)];
    [path addCurveToPoint: CGPointMake(16.34, 35.26) controlPoint1: CGPointMake(14.12, 35.2) controlPoint2: CGPointMake(15.16, 35.25)];
    [path addCurveToPoint: CGPointMake(20.84, 35.31) controlPoint1: CGPointMake(17.84, 35.29) controlPoint2: CGPointMake(19.34, 35.31)];
    [path addCurveToPoint: CGPointMake(33.4, 35.32) controlPoint1: CGPointMake(25.02, 35.31) controlPoint2: CGPointMake(29.21, 35.32)];
    [path addCurveToPoint: CGPointMake(42.38, 35.31) controlPoint1: CGPointMake(36.4, 35.32) controlPoint2: CGPointMake(39.39, 35.32)];
    [path addCurveToPoint: CGPointMake(34.56, 41.88) controlPoint1: CGPointMake(39.77, 37.5) controlPoint2: CGPointMake(37.17, 39.68)];
    [path addCurveToPoint: CGPointMake(32.25, 43.88) controlPoint1: CGPointMake(33.78, 42.53) controlPoint2: CGPointMake(33.02, 43.2)];
    [path addCurveToPoint: CGPointMake(30.67, 45.38) controlPoint1: CGPointMake(31.64, 44.41) controlPoint2: CGPointMake(31.12, 44.91)];
    [path addCurveToPoint: CGPointMake(29.72, 46.56) controlPoint1: CGPointMake(30.36, 45.71) controlPoint2: CGPointMake(30, 46.09)];
    [path addCurveToPoint: CGPointMake(29.45, 47.17) controlPoint1: CGPointMake(29.59, 46.77) controlPoint2: CGPointMake(29.51, 46.97)];
    [path addCurveToPoint: CGPointMake(29.63, 48.24) controlPoint1: CGPointMake(29.36, 47.54) controlPoint2: CGPointMake(29.42, 47.91)];
    [path addCurveToPoint: CGPointMake(29.95, 48.69) controlPoint1: CGPointMake(29.72, 48.39) controlPoint2: CGPointMake(29.83, 48.55)];
    [path addLineToPoint: CGPointMake(30.53, 49.39)];
    [path addCurveToPoint: CGPointMake(31.12, 50.08) controlPoint1: CGPointMake(30.73, 49.62) controlPoint2: CGPointMake(30.92, 49.85)];
    [path addCurveToPoint: CGPointMake(31.5, 50.48) controlPoint1: CGPointMake(31.24, 50.22) controlPoint2: CGPointMake(31.37, 50.35)];
    [path addCurveToPoint: CGPointMake(32.42, 50.83) controlPoint1: CGPointMake(31.76, 50.71) controlPoint2: CGPointMake(32.08, 50.83)];
    [path addCurveToPoint: CGPointMake(32.52, 50.83) controlPoint1: CGPointMake(32.45, 50.83) controlPoint2: CGPointMake(32.49, 50.83)];
    [path addCurveToPoint: CGPointMake(33.18, 50.67) controlPoint1: CGPointMake(32.73, 50.82) controlPoint2: CGPointMake(32.95, 50.76)];
    [path addCurveToPoint: CGPointMake(34.49, 49.95) controlPoint1: CGPointMake(33.68, 50.48) controlPoint2: CGPointMake(34.12, 50.2)];
    [path addCurveToPoint: CGPointMake(36.26, 48.65) controlPoint1: CGPointMake(35.05, 49.58) controlPoint2: CGPointMake(35.62, 49.16)];
    [path addCurveToPoint: CGPointMake(38.63, 46.72) controlPoint1: CGPointMake(37.05, 48.01) controlPoint2: CGPointMake(37.85, 47.37)];
    [path addCurveToPoint: CGPointMake(48.68, 38.29) controlPoint1: CGPointMake(41.98, 43.91) controlPoint2: CGPointMake(45.33, 41.1)];
    [path addCurveToPoint: CGPointMake(52.38, 35.05) controlPoint1: CGPointMake(50.04, 37.14) controlPoint2: CGPointMake(51.27, 36.11)];
    [path addLineToPoint: CGPointMake(52.47, 34.99)];
    [path addCurveToPoint: CGPointMake(52.61, 34.86) controlPoint1: CGPointMake(52.5, 34.96) controlPoint2: CGPointMake(52.53, 34.94)];
    [path addLineToPoint: CGPointMake(52.7, 34.78)];
    [path addCurveToPoint: CGPointMake(53.83, 33.59) controlPoint1: CGPointMake(53.02, 34.47) controlPoint2: CGPointMake(53.44, 34.05)];
    [path addCurveToPoint: CGPointMake(54.46, 32.63) controlPoint1: CGPointMake(54.06, 33.31) controlPoint2: CGPointMake(54.3, 33)];
    [path addCurveToPoint: CGPointMake(54.59, 32.11) controlPoint1: CGPointMake(54.54, 32.44) controlPoint2: CGPointMake(54.59, 32.24)];
    [path addLineToPoint: CGPointMake(54.59, 31.96)];
    [path addCurveToPoint: CGPointMake(54.46, 31.38) controlPoint1: CGPointMake(54.59, 31.76) controlPoint2: CGPointMake(54.54, 31.56)];
    [path closePath];
    return path;
}

UIBezierPath *TextButtonFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(187.99, 17.78)];
    [path addLineToPoint: CGPointMake(187.96, 16.93)];
    [path addCurveToPoint: CGPointMake(185.49, 7.8) controlPoint1: CGPointMake(187.85, 14.17) controlPoint2: CGPointMake(187.73, 10.74)];
    [path addCurveToPoint: CGPointMake(164.5, 0.96) controlPoint1: CGPointMake(181.26, 2.33) controlPoint2: CGPointMake(171.17, 1.5)];
    [path addLineToPoint: CGPointMake(162.92, 0.83)];
    [path addCurveToPoint: CGPointMake(124.81, 0.02) controlPoint1: CGPointMake(150.2, 0.03) controlPoint2: CGPointMake(137.29, 0.03)];
    [path addCurveToPoint: CGPointMake(114.06, 0) controlPoint1: CGPointMake(121.24, 0.02) controlPoint2: CGPointMake(117.66, 0.02)];
    [path addCurveToPoint: CGPointMake(73.92, 0) controlPoint1: CGPointMake(100.69, 0) controlPoint2: CGPointMake(87.31, 0)];
    [path addCurveToPoint: CGPointMake(63.19, 0.02) controlPoint1: CGPointMake(70.34, 0.02) controlPoint2: CGPointMake(66.76, 0.02)];
    [path addCurveToPoint: CGPointMake(24.99, 0.83) controlPoint1: CGPointMake(50.71, 0.03) controlPoint2: CGPointMake(37.8, 0.03)];
    [path addLineToPoint: CGPointMake(23.5, 0.96)];
    [path addCurveToPoint: CGPointMake(2.49, 7.82) controlPoint1: CGPointMake(16.84, 1.5) controlPoint2: CGPointMake(6.77, 2.33)];
    [path addCurveToPoint: CGPointMake(0.05, 16.89) controlPoint1: CGPointMake(0.28, 10.72) controlPoint2: CGPointMake(0.15, 14.14)];
    [path addLineToPoint: CGPointMake(0.01, 17.78)];
    [path addCurveToPoint: CGPointMake(0.01, 58.22) controlPoint1: CGPointMake(-0, 32.61) controlPoint2: CGPointMake(-0, 43.39)];
    [path addLineToPoint: CGPointMake(0.05, 59.06)];
    [path addCurveToPoint: CGPointMake(2.51, 68.21) controlPoint1: CGPointMake(0.15, 61.82) controlPoint2: CGPointMake(0.27, 65.26)];
    [path addCurveToPoint: CGPointMake(23.51, 75.05) controlPoint1: CGPointMake(6.74, 73.67) controlPoint2: CGPointMake(16.83, 74.5)];
    [path addLineToPoint: CGPointMake(25.07, 75.18)];
    [path addCurveToPoint: CGPointMake(61.74, 75.98) controlPoint1: CGPointMake(37.32, 75.95) controlPoint2: CGPointMake(49.73, 75.96)];
    [path addCurveToPoint: CGPointMake(69.97, 75.99) controlPoint1: CGPointMake(64.48, 75.98) controlPoint2: CGPointMake(67.22, 75.98)];
    [path addCurveToPoint: CGPointMake(94, 76) controlPoint1: CGPointMake(77.98, 76) controlPoint2: CGPointMake(85.99, 76)];
    [path addCurveToPoint: CGPointMake(118.03, 75.99) controlPoint1: CGPointMake(102.01, 76) controlPoint2: CGPointMake(110.02, 76)];
    [path addCurveToPoint: CGPointMake(151.6, 75.7) controlPoint1: CGPointMake(128.96, 75.99) controlPoint2: CGPointMake(140.25, 75.98)];
    [path addLineToPoint: CGPointMake(153.29, 75.64)];
    [path addCurveToPoint: CGPointMake(174.07, 73.84) controlPoint1: CGPointMake(160.07, 75.4) controlPoint2: CGPointMake(167.08, 75.15)];
    [path addCurveToPoint: CGPointMake(185.51, 68.18) controlPoint1: CGPointMake(177.78, 73.05) controlPoint2: CGPointMake(182.4, 72.07)];
    [path addCurveToPoint: CGPointMake(187.95, 59.11) controlPoint1: CGPointMake(187.72, 65.28) controlPoint2: CGPointMake(187.85, 61.86)];
    [path addLineToPoint: CGPointMake(187.99, 58.22)];
    [path addCurveToPoint: CGPointMake(187.99, 17.78) controlPoint1: CGPointMake(188.01, 43.39) controlPoint2: CGPointMake(188.01, 32.61)];
    [path closePath];
    return path;
}

UIBezierPath *TextButtonStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(7.05, 58.14)];
    [path addLineToPoint: CGPointMake(7.08, 58.81)];
    [path addCurveToPoint: CGPointMake(8.11, 63.97) controlPoint1: CGPointMake(7.15, 60.86) controlPoint2: CGPointMake(7.22, 62.8)];
    [path addCurveToPoint: CGPointMake(24.08, 68.07) controlPoint1: CGPointMake(10.42, 66.95) controlPoint2: CGPointMake(19.65, 67.71)];
    [path addLineToPoint: CGPointMake(25.61, 68.2)];
    [path addCurveToPoint: CGPointMake(61.75, 68.98) controlPoint1: CGPointMake(37.54, 68.95) controlPoint2: CGPointMake(49.85, 68.96)];
    [path addCurveToPoint: CGPointMake(69.98, 68.99) controlPoint1: CGPointMake(64.49, 68.98) controlPoint2: CGPointMake(67.24, 68.98)];
    [path addCurveToPoint: CGPointMake(118.03, 68.99) controlPoint1: CGPointMake(85.99, 69) controlPoint2: CGPointMake(102.01, 69)];
    [path addCurveToPoint: CGPointMake(151.39, 68.71) controlPoint1: CGPointMake(128.91, 68.99) controlPoint2: CGPointMake(140.16, 68.98)];
    [path addLineToPoint: CGPointMake(153.03, 68.65)];
    [path addCurveToPoint: CGPointMake(172.69, 66.97) controlPoint1: CGPointMake(159.56, 68.42) controlPoint2: CGPointMake(166.3, 68.18)];
    [path addCurveToPoint: CGPointMake(179.95, 63.89) controlPoint1: CGPointMake(175.49, 66.38) controlPoint2: CGPointMake(178.47, 65.75)];
    [path addCurveToPoint: CGPointMake(180.92, 58.85) controlPoint1: CGPointMake(180.77, 62.81) controlPoint2: CGPointMake(180.84, 60.89)];
    [path addLineToPoint: CGPointMake(180.95, 58.14)];
    [path addCurveToPoint: CGPointMake(180.95, 17.86) controlPoint1: CGPointMake(180.97, 43.37) controlPoint2: CGPointMake(180.97, 32.63)];
    [path addLineToPoint: CGPointMake(180.92, 17.19)];
    [path addCurveToPoint: CGPointMake(179.9, 12.04) controlPoint1: CGPointMake(180.85, 15.14) controlPoint2: CGPointMake(180.78, 13.2)];
    [path addCurveToPoint: CGPointMake(163.92, 7.93) controlPoint1: CGPointMake(177.58, 9.05) controlPoint2: CGPointMake(168.36, 8.29)];
    [path addLineToPoint: CGPointMake(162.39, 7.8)];
    [path addCurveToPoint: CGPointMake(124.81, 7.02) controlPoint1: CGPointMake(149.98, 7.03) controlPoint2: CGPointMake(137.18, 7.03)];
    [path addCurveToPoint: CGPointMake(114.05, 7) controlPoint1: CGPointMake(121.22, 7.02) controlPoint2: CGPointMake(117.63, 7.02)];
    [path addCurveToPoint: CGPointMake(73.93, 7) controlPoint1: CGPointMake(100.69, 7.01) controlPoint2: CGPointMake(87.31, 7.01)];
    [path addCurveToPoint: CGPointMake(63.19, 7.02) controlPoint1: CGPointMake(70.37, 7.02) controlPoint2: CGPointMake(66.78, 7.02)];
    [path addCurveToPoint: CGPointMake(25.52, 7.81) controlPoint1: CGPointMake(50.82, 7.03) controlPoint2: CGPointMake(38.02, 7.03)];
    [path addLineToPoint: CGPointMake(24.08, 7.93)];
    [path addCurveToPoint: CGPointMake(8.08, 12.07) controlPoint1: CGPointMake(19.65, 8.3) controlPoint2: CGPointMake(10.43, 9.05)];
    [path addCurveToPoint: CGPointMake(7.08, 17.15) controlPoint1: CGPointMake(7.23, 13.19) controlPoint2: CGPointMake(7.16, 15.11)];
    [path addLineToPoint: CGPointMake(7.05, 17.86)];
    [path addCurveToPoint: CGPointMake(7.05, 58.14) controlPoint1: CGPointMake(7.03, 32.63) controlPoint2: CGPointMake(7.03, 43.37)];
    [path closePath];
    [path moveToPoint: CGPointMake(94, 76)];
    [path addCurveToPoint: CGPointMake(69.97, 75.99) controlPoint1: CGPointMake(85.99, 76) controlPoint2: CGPointMake(77.98, 76)];
    [path addCurveToPoint: CGPointMake(61.74, 75.98) controlPoint1: CGPointMake(67.22, 75.98) controlPoint2: CGPointMake(64.48, 75.98)];
    [path addCurveToPoint: CGPointMake(25.07, 75.18) controlPoint1: CGPointMake(49.73, 75.96) controlPoint2: CGPointMake(37.32, 75.95)];
    [path addLineToPoint: CGPointMake(23.51, 75.05)];
    [path addCurveToPoint: CGPointMake(2.51, 68.21) controlPoint1: CGPointMake(16.83, 74.5) controlPoint2: CGPointMake(6.74, 73.67)];
    [path addCurveToPoint: CGPointMake(0.05, 59.06) controlPoint1: CGPointMake(0.27, 65.26) controlPoint2: CGPointMake(0.15, 61.82)];
    [path addLineToPoint: CGPointMake(0.02, 58.22)];
    [path addCurveToPoint: CGPointMake(0.01, 17.78) controlPoint1: CGPointMake(-0, 43.39) controlPoint2: CGPointMake(-0, 32.62)];
    [path addLineToPoint: CGPointMake(0.05, 16.89)];
    [path addCurveToPoint: CGPointMake(2.49, 7.82) controlPoint1: CGPointMake(0.15, 14.14) controlPoint2: CGPointMake(0.28, 10.73)];
    [path addCurveToPoint: CGPointMake(23.5, 0.96) controlPoint1: CGPointMake(6.77, 2.33) controlPoint2: CGPointMake(16.84, 1.5)];
    [path addLineToPoint: CGPointMake(24.99, 0.83)];
    [path addCurveToPoint: CGPointMake(63.19, 0.02) controlPoint1: CGPointMake(37.8, 0.03) controlPoint2: CGPointMake(50.71, 0.03)];
    [path addCurveToPoint: CGPointMake(73.92, -0) controlPoint1: CGPointMake(66.76, 0.02) controlPoint2: CGPointMake(70.34, 0.02)];
    [path addCurveToPoint: CGPointMake(114.06, -0) controlPoint1: CGPointMake(87.31, 0) controlPoint2: CGPointMake(100.69, 0)];
    [path addCurveToPoint: CGPointMake(124.81, 0.02) controlPoint1: CGPointMake(117.66, 0.02) controlPoint2: CGPointMake(121.24, 0.02)];
    [path addCurveToPoint: CGPointMake(162.92, 0.83) controlPoint1: CGPointMake(137.29, 0.03) controlPoint2: CGPointMake(150.2, 0.03)];
    [path addLineToPoint: CGPointMake(164.5, 0.96)];
    [path addCurveToPoint: CGPointMake(185.49, 7.79) controlPoint1: CGPointMake(171.17, 1.5) controlPoint2: CGPointMake(181.26, 2.33)];
    [path addCurveToPoint: CGPointMake(187.96, 16.93) controlPoint1: CGPointMake(187.73, 10.74) controlPoint2: CGPointMake(187.85, 14.17)];
    [path addLineToPoint: CGPointMake(187.99, 17.78)];
    [path addCurveToPoint: CGPointMake(187.99, 58.22) controlPoint1: CGPointMake(188, 32.62) controlPoint2: CGPointMake(188, 43.39)];
    [path addLineToPoint: CGPointMake(187.95, 59.11)];
    [path addCurveToPoint: CGPointMake(185.51, 68.18) controlPoint1: CGPointMake(187.85, 61.86) controlPoint2: CGPointMake(187.72, 65.28)];
    [path addCurveToPoint: CGPointMake(174.07, 73.83) controlPoint1: CGPointMake(182.4, 72.07) controlPoint2: CGPointMake(177.78, 73.05)];
    [path addCurveToPoint: CGPointMake(153.28, 75.64) controlPoint1: CGPointMake(167.08, 75.15) controlPoint2: CGPointMake(160.07, 75.4)];
    [path addLineToPoint: CGPointMake(151.6, 75.7)];
    [path addCurveToPoint: CGPointMake(118.03, 75.99) controlPoint1: CGPointMake(140.25, 75.98) controlPoint2: CGPointMake(128.96, 75.99)];
    [path addCurveToPoint: CGPointMake(94, 76) controlPoint1: CGPointMake(110.02, 76) controlPoint2: CGPointMake(102.01, 76)];
    [path closePath];
    return path;
}

UIBezierPath *WordTrayFillPath()
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

UIBezierPath *WordTrayStrokePath()
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

UIBezierPath *ChoiceLeftFillPathSelected()
{
    // checkmark
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(69.28, 25.09)];
    [path addCurveToPoint: CGPointMake(68.92, 24.65) controlPoint1: CGPointMake(69.17, 24.93) controlPoint2: CGPointMake(69.05, 24.79)];
    [path addLineToPoint: CGPointMake(68.25, 23.98)];
    [path addCurveToPoint: CGPointMake(67.59, 23.32) controlPoint1: CGPointMake(68.03, 23.76) controlPoint2: CGPointMake(67.81, 23.54)];
    [path addCurveToPoint: CGPointMake(67.15, 22.96) controlPoint1: CGPointMake(67.45, 23.19) controlPoint2: CGPointMake(67.3, 23.07)];
    [path addCurveToPoint: CGPointMake(66.07, 22.81) controlPoint1: CGPointMake(66.84, 22.75) controlPoint2: CGPointMake(66.47, 22.69)];
    [path addCurveToPoint: CGPointMake(65.38, 23.12) controlPoint1: CGPointMake(65.85, 22.87) controlPoint2: CGPointMake(65.63, 22.97)];
    [path addCurveToPoint: CGPointMake(63.83, 24.25) controlPoint1: CGPointMake(64.85, 23.42) controlPoint2: CGPointMake(64.38, 23.79)];
    [path addCurveToPoint: CGPointMake(61.69, 26.19) controlPoint1: CGPointMake(63.17, 24.81) controlPoint2: CGPointMake(62.47, 25.45)];
    [path addCurveToPoint: CGPointMake(58.78, 29.04) controlPoint1: CGPointMake(60.72, 27.14) controlPoint2: CGPointMake(59.74, 28.08)];
    [path addCurveToPoint: CGPointMake(46.38, 41.44) controlPoint1: CGPointMake(54.64, 33.17) controlPoint2: CGPointMake(50.51, 37.3)];
    [path addCurveToPoint: CGPointMake(44.45, 43.37) controlPoint1: CGPointMake(45.73, 42.08) controlPoint2: CGPointMake(45.09, 42.72)];
    [path addLineToPoint: CGPointMake(44.33, 42.89)];
    [path addCurveToPoint: CGPointMake(43.48, 39.72) controlPoint1: CGPointMake(44.04, 41.83) controlPoint2: CGPointMake(43.76, 40.77)];
    [path addLineToPoint: CGPointMake(43.45, 39.63)];
    [path addCurveToPoint: CGPointMake(42.52, 36.65) controlPoint1: CGPointMake(43.19, 38.64) controlPoint2: CGPointMake(42.91, 37.63)];
    [path addCurveToPoint: CGPointMake(42.05, 35.73) controlPoint1: CGPointMake(42.42, 36.39) controlPoint2: CGPointMake(42.27, 36.05)];
    [path addCurveToPoint: CGPointMake(41.46, 35.15) controlPoint1: CGPointMake(41.92, 35.54) controlPoint2: CGPointMake(41.74, 35.32)];
    [path addCurveToPoint: CGPointMake(40.37, 35) controlPoint1: CGPointMake(41.16, 34.98) controlPoint2: CGPointMake(40.8, 34.93)];
    [path addCurveToPoint: CGPointMake(39.85, 35.12) controlPoint1: CGPointMake(40.2, 35.03) controlPoint2: CGPointMake(40.02, 35.07)];
    [path addLineToPoint: CGPointMake(37.61, 35.72)];
    [path addCurveToPoint: CGPointMake(37.1, 35.88) controlPoint1: CGPointMake(37.44, 35.76) controlPoint2: CGPointMake(37.27, 35.82)];
    [path addCurveToPoint: CGPointMake(36.23, 36.55) controlPoint1: CGPointMake(36.7, 36.03) controlPoint2: CGPointMake(36.4, 36.25)];
    [path addCurveToPoint: CGPointMake(36.01, 37.35) controlPoint1: CGPointMake(36.07, 36.84) controlPoint2: CGPointMake(36.03, 37.11)];
    [path addCurveToPoint: CGPointMake(36.06, 38.39) controlPoint1: CGPointMake(35.98, 37.74) controlPoint2: CGPointMake(36.02, 38.11)];
    [path addCurveToPoint: CGPointMake(36.77, 41.51) controlPoint1: CGPointMake(36.21, 39.43) controlPoint2: CGPointMake(36.49, 40.46)];
    [path addCurveToPoint: CGPointMake(38.8, 49.08) controlPoint1: CGPointMake(37.44, 44.04) controlPoint2: CGPointMake(38.12, 46.56)];
    [path addCurveToPoint: CGPointMake(39.13, 50.21) controlPoint1: CGPointMake(38.9, 49.46) controlPoint2: CGPointMake(39.02, 49.83)];
    [path addLineToPoint: CGPointMake(39.32, 50.83)];
    [path addCurveToPoint: CGPointMake(39.83, 52.08) controlPoint1: CGPointMake(39.47, 51.31) controlPoint2: CGPointMake(39.64, 51.72)];
    [path addCurveToPoint: CGPointMake(40.42, 52.9) controlPoint1: CGPointMake(39.96, 52.34) controlPoint2: CGPointMake(40.13, 52.64)];
    [path addCurveToPoint: CGPointMake(40.87, 53.17) controlPoint1: CGPointMake(40.56, 53.02) controlPoint2: CGPointMake(40.71, 53.11)];
    [path addCurveToPoint: CGPointMake(41.37, 53.25) controlPoint1: CGPointMake(41.02, 53.22) controlPoint2: CGPointMake(41.19, 53.25)];
    [path addCurveToPoint: CGPointMake(41.79, 53.21) controlPoint1: CGPointMake(41.51, 53.25) controlPoint2: CGPointMake(41.64, 53.24)];
    [path addCurveToPoint: CGPointMake(42.46, 53.05) controlPoint1: CGPointMake(41.98, 53.17) controlPoint2: CGPointMake(42.18, 53.13)];
    [path addLineToPoint: CGPointMake(42.71, 52.98)];
    [path addCurveToPoint: CGPointMake(42.86, 52.93) controlPoint1: CGPointMake(42.76, 52.97) controlPoint2: CGPointMake(42.81, 52.95)];
    [path addCurveToPoint: CGPointMake(44.06, 52.18) controlPoint1: CGPointMake(43.3, 52.73) controlPoint2: CGPointMake(43.7, 52.46)];
    [path addCurveToPoint: CGPointMake(45.7, 50.8) controlPoint1: CGPointMake(44.68, 51.71) controlPoint2: CGPointMake(45.26, 51.2)];
    [path addLineToPoint: CGPointMake(45.98, 50.54)];
    [path addCurveToPoint: CGPointMake(50.8, 45.86) controlPoint1: CGPointMake(47.57, 49.08) controlPoint2: CGPointMake(49.04, 47.62)];
    [path addCurveToPoint: CGPointMake(63.2, 33.46) controlPoint1: CGPointMake(54.94, 41.73) controlPoint2: CGPointMake(59.07, 37.6)];
    [path addCurveToPoint: CGPointMake(66.05, 30.54) controlPoint1: CGPointMake(64.15, 32.5) controlPoint2: CGPointMake(65.1, 31.52)];
    [path addCurveToPoint: CGPointMake(67.99, 28.4) controlPoint1: CGPointMake(66.79, 29.77) controlPoint2: CGPointMake(67.42, 29.07)];
    [path addCurveToPoint: CGPointMake(69.12, 26.86) controlPoint1: CGPointMake(68.36, 27.96) controlPoint2: CGPointMake(68.79, 27.44)];
    [path addCurveToPoint: CGPointMake(69.43, 26.16) controlPoint1: CGPointMake(69.27, 26.61) controlPoint2: CGPointMake(69.37, 26.39)];
    [path addCurveToPoint: CGPointMake(69.28, 25.09) controlPoint1: CGPointMake(69.54, 25.76) controlPoint2: CGPointMake(69.49, 25.39)];
    [path closePath];
    return path;
}

UIBezierPath *ChoiceRightFillPathSelected()
{
    // checkmark
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(268.28, 23.09)];
    [path addCurveToPoint: CGPointMake(267.91, 22.65) controlPoint1: CGPointMake(268.17, 22.93) controlPoint2: CGPointMake(268.05, 22.79)];
    [path addLineToPoint: CGPointMake(267.25, 21.98)];
    [path addCurveToPoint: CGPointMake(266.59, 21.32) controlPoint1: CGPointMake(267.03, 21.76) controlPoint2: CGPointMake(266.81, 21.54)];
    [path addCurveToPoint: CGPointMake(266.15, 20.96) controlPoint1: CGPointMake(266.45, 21.19) controlPoint2: CGPointMake(266.3, 21.07)];
    [path addCurveToPoint: CGPointMake(265.07, 20.81) controlPoint1: CGPointMake(265.84, 20.75) controlPoint2: CGPointMake(265.47, 20.69)];
    [path addCurveToPoint: CGPointMake(264.38, 21.12) controlPoint1: CGPointMake(264.85, 20.87) controlPoint2: CGPointMake(264.63, 20.97)];
    [path addCurveToPoint: CGPointMake(262.83, 22.25) controlPoint1: CGPointMake(263.85, 21.42) controlPoint2: CGPointMake(263.38, 21.79)];
    [path addCurveToPoint: CGPointMake(260.69, 24.19) controlPoint1: CGPointMake(262.17, 22.81) controlPoint2: CGPointMake(261.47, 23.45)];
    [path addCurveToPoint: CGPointMake(257.78, 27.04) controlPoint1: CGPointMake(259.72, 25.14) controlPoint2: CGPointMake(258.74, 26.08)];
    [path addCurveToPoint: CGPointMake(245.38, 39.44) controlPoint1: CGPointMake(253.64, 31.17) controlPoint2: CGPointMake(249.51, 35.3)];
    [path addCurveToPoint: CGPointMake(243.45, 41.37) controlPoint1: CGPointMake(244.73, 40.08) controlPoint2: CGPointMake(244.09, 40.72)];
    [path addLineToPoint: CGPointMake(243.32, 40.89)];
    [path addCurveToPoint: CGPointMake(242.48, 37.72) controlPoint1: CGPointMake(243.04, 39.83) controlPoint2: CGPointMake(242.76, 38.77)];
    [path addLineToPoint: CGPointMake(242.45, 37.63)];
    [path addCurveToPoint: CGPointMake(241.52, 34.65) controlPoint1: CGPointMake(242.19, 36.64) controlPoint2: CGPointMake(241.91, 35.63)];
    [path addCurveToPoint: CGPointMake(241.05, 33.73) controlPoint1: CGPointMake(241.42, 34.39) controlPoint2: CGPointMake(241.27, 34.05)];
    [path addCurveToPoint: CGPointMake(240.46, 33.15) controlPoint1: CGPointMake(240.92, 33.54) controlPoint2: CGPointMake(240.74, 33.32)];
    [path addCurveToPoint: CGPointMake(239.37, 33) controlPoint1: CGPointMake(240.16, 32.98) controlPoint2: CGPointMake(239.79, 32.93)];
    [path addCurveToPoint: CGPointMake(238.85, 33.12) controlPoint1: CGPointMake(239.2, 33.03) controlPoint2: CGPointMake(239.02, 33.07)];
    [path addLineToPoint: CGPointMake(236.61, 33.72)];
    [path addCurveToPoint: CGPointMake(236.1, 33.88) controlPoint1: CGPointMake(236.44, 33.76) controlPoint2: CGPointMake(236.26, 33.82)];
    [path addCurveToPoint: CGPointMake(235.23, 34.55) controlPoint1: CGPointMake(235.7, 34.03) controlPoint2: CGPointMake(235.4, 34.25)];
    [path addCurveToPoint: CGPointMake(235.01, 35.35) controlPoint1: CGPointMake(235.07, 34.84) controlPoint2: CGPointMake(235.03, 35.11)];
    [path addCurveToPoint: CGPointMake(235.06, 36.39) controlPoint1: CGPointMake(234.98, 35.74) controlPoint2: CGPointMake(235.02, 36.11)];
    [path addCurveToPoint: CGPointMake(235.77, 39.51) controlPoint1: CGPointMake(235.21, 37.43) controlPoint2: CGPointMake(235.49, 38.46)];
    [path addCurveToPoint: CGPointMake(237.8, 47.08) controlPoint1: CGPointMake(236.44, 42.04) controlPoint2: CGPointMake(237.12, 44.56)];
    [path addCurveToPoint: CGPointMake(238.13, 48.21) controlPoint1: CGPointMake(237.9, 47.46) controlPoint2: CGPointMake(238.02, 47.83)];
    [path addLineToPoint: CGPointMake(238.32, 48.83)];
    [path addCurveToPoint: CGPointMake(238.83, 50.08) controlPoint1: CGPointMake(238.47, 49.31) controlPoint2: CGPointMake(238.64, 49.72)];
    [path addCurveToPoint: CGPointMake(239.42, 50.9) controlPoint1: CGPointMake(238.96, 50.34) controlPoint2: CGPointMake(239.13, 50.64)];
    [path addCurveToPoint: CGPointMake(239.87, 51.17) controlPoint1: CGPointMake(239.56, 51.02) controlPoint2: CGPointMake(239.71, 51.11)];
    [path addCurveToPoint: CGPointMake(240.37, 51.25) controlPoint1: CGPointMake(240.02, 51.22) controlPoint2: CGPointMake(240.19, 51.25)];
    [path addCurveToPoint: CGPointMake(240.79, 51.21) controlPoint1: CGPointMake(240.51, 51.25) controlPoint2: CGPointMake(240.64, 51.24)];
    [path addCurveToPoint: CGPointMake(241.46, 51.05) controlPoint1: CGPointMake(240.98, 51.17) controlPoint2: CGPointMake(241.18, 51.13)];
    [path addLineToPoint: CGPointMake(241.7, 50.98)];
    [path addCurveToPoint: CGPointMake(241.86, 50.93) controlPoint1: CGPointMake(241.76, 50.97) controlPoint2: CGPointMake(241.81, 50.95)];
    [path addCurveToPoint: CGPointMake(243.06, 50.18) controlPoint1: CGPointMake(242.3, 50.73) controlPoint2: CGPointMake(242.7, 50.46)];
    [path addCurveToPoint: CGPointMake(244.7, 48.8) controlPoint1: CGPointMake(243.68, 49.71) controlPoint2: CGPointMake(244.26, 49.2)];
    [path addLineToPoint: CGPointMake(244.98, 48.54)];
    [path addCurveToPoint: CGPointMake(249.8, 43.86) controlPoint1: CGPointMake(246.57, 47.08) controlPoint2: CGPointMake(248.04, 45.62)];
    [path addCurveToPoint: CGPointMake(262.19, 31.46) controlPoint1: CGPointMake(253.93, 39.73) controlPoint2: CGPointMake(258.07, 35.6)];
    [path addCurveToPoint: CGPointMake(265.05, 28.54) controlPoint1: CGPointMake(263.15, 30.5) controlPoint2: CGPointMake(264.1, 29.52)];
    [path addCurveToPoint: CGPointMake(266.99, 26.4) controlPoint1: CGPointMake(265.79, 27.77) controlPoint2: CGPointMake(266.42, 27.07)];
    [path addCurveToPoint: CGPointMake(268.12, 24.86) controlPoint1: CGPointMake(267.36, 25.96) controlPoint2: CGPointMake(267.79, 25.44)];
    [path addCurveToPoint: CGPointMake(268.43, 24.16) controlPoint1: CGPointMake(268.27, 24.61) controlPoint2: CGPointMake(268.37, 24.39)];
    [path addCurveToPoint: CGPointMake(268.28, 23.09) controlPoint1: CGPointMake(268.54, 23.76) controlPoint2: CGPointMake(268.49, 23.39)];
    [path closePath];
    return path;
}

}  // namespace UP

using namespace UP;

@implementation UPControl (UPSpell)

+ (UPControl *)roundGameControl
{
    UPControl *control = [UPControl control];
    control.canonicalSize = SpellLayout::CanonicalRoundGameButtonSize;
    [control setFillPath:RoundGameButtonFillPath() forState:UPControlStateNormal];
    [control setFillColorCategory:UPColorCategoryPrimaryFill forState:UPControlStateNormal];
    [control setFillColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [control setStrokePath:RoundGameButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateNormal];
    [control setStrokeColorCategory:UPColorCategoryHighlightedStroke forState:UPControlStateHighlighted];
    return control;
}

+ (UPControl *)roundGameControlMinusSign
{
    UPControl *control = [UPControl roundGameControl];
    [control setContentPath:RoundGameButtonMinusSignIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)wordTrayControl
{
    UPControl *control = [UPControl control];
    control.canonicalSize = SpellLayout::CanonicalWordTrayFrame.size;
    [control setFillPath:WordTrayFillPath() forState:UPControlStateNormal];
    [control setFillColorCategory:UPColorCategorySecondaryInactiveFill forState:UPControlStateNormal];
    [control setFillColorCategory:UPColorCategorySecondaryActiveFill forState:UPControlStateActive];
    [control setFillColorCategory:UPColorCategorySecondaryHighlightedFill forState:(UPControlStateHighlighted | UPControlStateActive)];
    [control setFillColorAnimationDuration:0.1 fromState:(UPControlStateHighlighted | UPControlStateActive) toState:UPControlStateActive];
    [control setFillColorAnimationDuration:0.1 fromState:(UPControlStateHighlighted | UPControlStateActive) toState:UPControlStateNormal];
    [control setFillColorAnimationDuration:0.1 fromState:UPControlStateActive toState:UPControlStateNormal];
    [control setFillColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [control setStrokePath:WordTrayStrokePath() forState:UPControlStateNormal];
    [control setStrokeColorCategory:UPColorCategorySecondaryInactiveStroke forState:UPControlStateNormal];
    [control setStrokeColorCategory:UPColorCategorySecondaryActiveStroke forState:UPControlStateActive];
    [control setStrokeColorCategory:UPColorCategorySecondaryHighlightedStroke forState:(UPControlStateHighlighted | UPControlStateActive)];
    [control setStrokeColorCategory:UPColorCategorySecondaryHighlightedStroke forState:UPControlStateHighlighted];
    [control setStrokeColorAnimationDuration:0.1 fromState:(UPControlStateHighlighted | UPControlStateActive) toState:UPControlStateActive];
    [control setStrokeColorAnimationDuration:0.1 fromState:(UPControlStateHighlighted | UPControlStateActive) toState:UPControlStateNormal];
    [control setStrokeColorAnimationDuration:0.1 fromState:UPControlStateActive toState:UPControlStateNormal];
    [control setStrokeColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    return control;
}

@end

@implementation UPButton (UPSpell)

+ (UPButton *)roundBackButton
{
    UPButton *button = [UPButton button];
    button.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    [button setFillPath:RoundBackButtonFillPath() forState:UPControlStateNormal];
    [button setFillColorCategory:UPColorCategoryPrimaryFill forState:UPControlStateNormal];
    [button setFillColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [button setStrokePath:RoundBackButtonStrokePath() forState:UPControlStateNormal];
    [button setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateNormal];
    [button setStrokeColorCategory:UPColorCategoryHighlightedStroke forState:UPControlStateHighlighted];
    return button;
}

+ (UPButton *)roundBackButtonLeftArrow
{
    UPButton *button = [UPButton roundBackButton];
    [button setContentPath:RoundBackButtonLeftArrowIconPath() forState:UPControlStateNormal];
    return button;
}

+ (UPButton *)roundBackButtonRightArrow
{
    UPButton *button = [UPButton roundBackButton];
    [button setContentPath:RoundBackButtonRightArrowIconPath() forState:UPControlStateNormal];
    return button;
}

+ (UPButton *)textButton
{
    UPButton *button = [UPButton button];
    button.canonicalSize = SpellLayout::CanonicalTextButtonSize;
    [button setFillPath:TextButtonFillPath() forState:UPControlStateNormal];
    [button setFillColorCategory:UPColorCategoryPrimaryFill forState:UPControlStateNormal];
    [button setFillColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [button setStrokePath:TextButtonStrokePath() forState:UPControlStateNormal];
    [button setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateNormal];
    [button setStrokeColorCategory:UPColorCategoryHighlightedStroke forState:UPControlStateHighlighted];
    return button;
}

+ (UPButton *)textButtonAbout
{
    UPButton *button = [UPButton textButton];
    [button setFillColorCategory:UPColorCategoryHighlightedFill forState:(UPControlStateSelected | UPControlStateHighlighted)];
    [button setFillColorCategory:UPColorCategoryClear forState:UPControlStateSelected];
    [button setFillColorAnimationDuration:0.75 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
    [button setFillColorAnimationDuration:0.75 fromState:UPControlStateSelected toState:UPControlStateNormal];
    [button setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:(UPControlStateSelected | UPControlStateHighlighted)];
    [button setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateSelected];
    [button setStrokeColorAnimationDuration:0.75 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
    [button setStrokeColorAnimationDuration:0.75 fromState:UPControlStateSelected toState:UPControlStateNormal];
    [button setContentPath:UP::TextPathContentAbout() forState:UPControlStateNormal];
    [button setContentColorCategory:UPColorCategoryControlText forState:UPControlStateSelected];
    [button setContentColorAnimationDuration:0.75 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
    [button setContentColorAnimationDuration:0.75 fromState:UPControlStateSelected toState:UPControlStateNormal];
    button.autoHighlights = YES;
    button.autoSelects = YES;
    button.band = UP::BandModeUI;
    return button;
}

+ (UPButton *)textButtonExtras
{
    UPButton *button = [UPButton textButton];
    [button setFillColorCategory:UPColorCategoryHighlightedFill forState:(UPControlStateSelected | UPControlStateHighlighted)];
    [button setFillColorCategory:UPColorCategoryClear forState:UPControlStateSelected];
    [button setFillColorAnimationDuration:0.75 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
    [button setFillColorAnimationDuration:0.75 fromState:UPControlStateSelected toState:UPControlStateNormal];
    [button setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:(UPControlStateSelected | UPControlStateHighlighted)];
    [button setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateSelected];
    [button setStrokeColorAnimationDuration:0.75 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
    [button setStrokeColorAnimationDuration:0.75 fromState:UPControlStateSelected toState:UPControlStateNormal];
    [button setContentPath:UP::TextPathContentExtras() forState:UPControlStateNormal];
    [button setContentColorCategory:UPColorCategoryControlText forState:UPControlStateSelected];
    [button setContentColorAnimationDuration:0.75 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
    [button setContentColorAnimationDuration:0.75 fromState:UPControlStateSelected toState:UPControlStateNormal];
    button.autoHighlights = YES;
    button.autoSelects = YES;
    button.band = UP::BandModeUI;
    return button;
}

+ (UPButton *)textButtonPlay
{
    UPButton *button = [UPButton textButton];
    [button setContentPath:UP::TextPathContentPlay() forState:UPControlStateNormal];
    return button;
}

+ (UPButton *)textButtonQuit
{
    UPButton *button = [UPButton textButton];
    [button setContentPath:UP::TextPathContentQuit() forState:UPControlStateNormal];
    return button;
}

+ (UPButton *)textButtonResume
{
    UPButton *button = [UPButton textButton];
    [button setContentPath:UP::TextPathContentResume() forState:UPControlStateNormal];
    return button;
}

+ (UPButton *)textButtonStats
{
    UPButton *button = [UPButton textButton];
    [button setContentPath:UP::TextPathContentStats() forState:UPControlStateNormal];
    return button;
}

@end


@implementation UPChoice (UPSpell)

+ (UPChoice *)optionsChoice
{
    UPChoice *choice = [UPChoice choice];
    choice.canonicalSize = SpellLayout::CanonicalChoiceSize;
    [choice setAccentColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
    [choice setAccentColorCategory:UPColorCategoryActiveFill forState:UPControlStateSelected];
    [choice setAccentPath:[UIBezierPath bezierPathWithRect:up_rect_make(choice.canonicalSize)] forState:UPControlStateSelected];
    [choice setAuxiliaryColorCategory:UPColorCategoryPrimaryFill forState:UPControlStateSelected];
    choice.autoSelects = YES;
    choice.autoHighlights = NO;
    return choice;
}

+ (UPChoice *)choiceLeftColors
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceLeftColors()];
    [choice setAuxiliaryPath:ChoiceLeftFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

+ (UPChoice *)choiceLeftSounds
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceLeftSounds()];
    [choice setAuxiliaryPath:ChoiceLeftFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

+ (UPChoice *)choiceLeftStats
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceLeftStats()];
    [choice setAuxiliaryPath:ChoiceLeftFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

+ (UPChoice *)choiceLeftGameKeys
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceLeftGameKeys()];
    [choice setAuxiliaryPath:ChoiceLeftFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

+ (UPChoice *)choiceRightUpSpell
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceRightUpSpell()];
    [choice setAuxiliaryPath:ChoiceRightFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

+ (UPChoice *)choiceRightRules
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceRightRules()];
    [choice setAuxiliaryPath:ChoiceRightFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

+ (UPChoice *)choiceRightLegal
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceRightLegal()];
    [choice setAuxiliaryPath:ChoiceRightFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

+ (UPChoice *)choiceRightThanks
{
    UPChoice *choice = [UPChoice optionsChoice];
    [choice setFillPath:UP::TextPathChoiceRightThanks()];
    [choice setAuxiliaryPath:ChoiceRightFillPathSelected() forState:UPControlStateSelected];
    return choice;
}

@end
