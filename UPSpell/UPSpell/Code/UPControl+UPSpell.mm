//
//  UPControl+UPSpell.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>

#import "UPControl+UPSpell.h"
#import "UPSpellLayout.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

static UIBezierPath *_RoundGameButtonFillPath()
{
    CGRect rect = up_rect_make(SpellLayout::CanonicalRoundGameButtonSize);
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

static UIBezierPath *_RoundBackButtonFillPath()
{
    CGRect rect = up_rect_make(SpellLayout::CanonicalRoundBackButtonSize);
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

static UIBezierPath *_RoundGameButtonStrokePath()
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

static UIBezierPath *_RoundBackButtonStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(28, 0)];
    [path addCurveToPoint: CGPointMake(0, 28) controlPoint1: CGPointMake(12.54, 0) controlPoint2: CGPointMake(0, 12.54)];
    [path addCurveToPoint: CGPointMake(28, 56) controlPoint1: CGPointMake(0, 43.46) controlPoint2: CGPointMake(12.54, 56)];
    [path addCurveToPoint: CGPointMake(56, 28) controlPoint1: CGPointMake(43.46, 56) controlPoint2: CGPointMake(56, 43.46)];
    [path addCurveToPoint: CGPointMake(28, 0) controlPoint1: CGPointMake(56, 12.54) controlPoint2: CGPointMake(43.46, 0)];
    [path closePath];
    [path moveToPoint: CGPointMake(28, 3)];
    [path addCurveToPoint: CGPointMake(53, 28) controlPoint1: CGPointMake(41.78, 3) controlPoint2: CGPointMake(53, 14.21)];
    [path addCurveToPoint: CGPointMake(28, 53) controlPoint1: CGPointMake(53, 41.79) controlPoint2: CGPointMake(41.78, 53)];
    [path addCurveToPoint: CGPointMake(3, 28) controlPoint1: CGPointMake(14.21, 53) controlPoint2: CGPointMake(3, 41.79)];
    [path addCurveToPoint: CGPointMake(28, 3) controlPoint1: CGPointMake(3, 14.21) controlPoint2: CGPointMake(14.21, 3)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundGameButtonMinusSignIconPath()
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

static UIBezierPath *_RoundGameButtonTrashIconPath()
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

static UIBezierPath *_RoundGameButtonDownArrowIconPath()
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

static UIBezierPath *_RoundBackButtonLeftArrowIconPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(47.33, 27.08)];
    [path addCurveToPoint: CGPointMake(47.28, 26.65) controlPoint1: CGPointMake(47.33, 26.94) controlPoint2: CGPointMake(47.31, 26.79)];
    [path addCurveToPoint: CGPointMake(46.83, 26.13) controlPoint1: CGPointMake(47.24, 26.44) controlPoint2: CGPointMake(47.09, 26.26)];
    [path addCurveToPoint: CGPointMake(46.22, 25.93) controlPoint1: CGPointMake(46.64, 26.04) controlPoint2: CGPointMake(46.44, 25.98)];
    [path addCurveToPoint: CGPointMake(44.46, 25.7) controlPoint1: CGPointMake(45.65, 25.8) controlPoint2: CGPointMake(45.05, 25.74)];
    [path addCurveToPoint: CGPointMake(41.7, 25.58) controlPoint1: CGPointMake(43.54, 25.63) controlPoint2: CGPointMake(42.62, 25.59)];
    [path addCurveToPoint: CGPointMake(37.77, 25.54) controlPoint1: CGPointMake(40.39, 25.56) controlPoint2: CGPointMake(39.08, 25.54)];
    [path addCurveToPoint: CGPointMake(20.85, 25.54) controlPoint1: CGPointMake(32.13, 25.54) controlPoint2: CGPointMake(26.49, 25.53)];
    [path addCurveToPoint: CGPointMake(17.7, 25.55) controlPoint1: CGPointMake(19.8, 25.54) controlPoint2: CGPointMake(18.75, 25.54)];
    [path addCurveToPoint: CGPointMake(25.47, 19.02) controlPoint1: CGPointMake(20.3, 23.38) controlPoint2: CGPointMake(22.89, 21.2)];
    [path addCurveToPoint: CGPointMake(27.49, 17.28) controlPoint1: CGPointMake(26.15, 18.45) controlPoint2: CGPointMake(26.82, 17.87)];
    [path addCurveToPoint: CGPointMake(28.85, 15.99) controlPoint1: CGPointMake(27.96, 16.87) controlPoint2: CGPointMake(28.42, 16.44)];
    [path addCurveToPoint: CGPointMake(29.62, 15.04) controlPoint1: CGPointMake(29.13, 15.69) controlPoint2: CGPointMake(29.41, 15.39)];
    [path addCurveToPoint: CGPointMake(29.8, 14.62) controlPoint1: CGPointMake(29.7, 14.91) controlPoint2: CGPointMake(29.76, 14.77)];
    [path addCurveToPoint: CGPointMake(29.71, 14.02) controlPoint1: CGPointMake(29.85, 14.41) controlPoint2: CGPointMake(29.82, 14.21)];
    [path addCurveToPoint: CGPointMake(29.45, 13.67) controlPoint1: CGPointMake(29.63, 13.9) controlPoint2: CGPointMake(29.55, 13.78)];
    [path addCurveToPoint: CGPointMake(29.2, 13.37) controlPoint1: CGPointMake(29.37, 13.57) controlPoint2: CGPointMake(29.29, 13.47)];
    [path addCurveToPoint: CGPointMake(29.2, 13.37) controlPoint1: CGPointMake(29.2, 13.37) controlPoint2: CGPointMake(29.2, 13.37)];
    [path addCurveToPoint: CGPointMake(28.95, 13.07) controlPoint1: CGPointMake(29.12, 13.27) controlPoint2: CGPointMake(29.03, 13.17)];
    [path addCurveToPoint: CGPointMake(28.44, 12.47) controlPoint1: CGPointMake(28.78, 12.87) controlPoint2: CGPointMake(28.61, 12.67)];
    [path addCurveToPoint: CGPointMake(28.14, 12.16) controlPoint1: CGPointMake(28.35, 12.36) controlPoint2: CGPointMake(28.25, 12.25)];
    [path addCurveToPoint: CGPointMake(27.57, 11.96) controlPoint1: CGPointMake(27.98, 12.01) controlPoint2: CGPointMake(27.79, 11.94)];
    [path addCurveToPoint: CGPointMake(27.13, 12.07) controlPoint1: CGPointMake(27.42, 11.97) controlPoint2: CGPointMake(27.27, 12.01)];
    [path addCurveToPoint: CGPointMake(26.06, 12.66) controlPoint1: CGPointMake(26.74, 12.22) controlPoint2: CGPointMake(26.4, 12.43)];
    [path addCurveToPoint: CGPointMake(24.55, 13.77) controlPoint1: CGPointMake(25.54, 13.01) controlPoint2: CGPointMake(25.04, 13.38)];
    [path addCurveToPoint: CGPointMake(22.48, 15.46) controlPoint1: CGPointMake(23.86, 14.33) controlPoint2: CGPointMake(23.16, 14.89)];
    [path addCurveToPoint: CGPointMake(13.68, 22.83) controlPoint1: CGPointMake(19.55, 17.91) controlPoint2: CGPointMake(16.61, 20.37)];
    [path addCurveToPoint: CGPointMake(10.4, 25.7) controlPoint1: CGPointMake(12.57, 23.77) controlPoint2: CGPointMake(11.46, 24.71)];
    [path addCurveToPoint: CGPointMake(10.37, 25.72) controlPoint1: CGPointMake(10.39, 25.71) controlPoint2: CGPointMake(10.38, 25.71)];
    [path addCurveToPoint: CGPointMake(10.3, 25.79) controlPoint1: CGPointMake(10.35, 25.74) controlPoint2: CGPointMake(10.32, 25.77)];
    [path addCurveToPoint: CGPointMake(10.19, 25.89) controlPoint1: CGPointMake(10.26, 25.82) controlPoint2: CGPointMake(10.23, 25.85)];
    [path addCurveToPoint: CGPointMake(9.23, 26.89) controlPoint1: CGPointMake(9.86, 26.21) controlPoint2: CGPointMake(9.53, 26.53)];
    [path addCurveToPoint: CGPointMake(8.75, 27.62) controlPoint1: CGPointMake(9.05, 27.12) controlPoint2: CGPointMake(8.87, 27.35)];
    [path addCurveToPoint: CGPointMake(8.67, 27.97) controlPoint1: CGPointMake(8.7, 27.74) controlPoint2: CGPointMake(8.67, 27.86)];
    [path addCurveToPoint: CGPointMake(8.67, 28) controlPoint1: CGPointMake(8.67, 27.98) controlPoint2: CGPointMake(8.67, 27.99)];
    [path addCurveToPoint: CGPointMake(8.67, 28.02) controlPoint1: CGPointMake(8.67, 28.01) controlPoint2: CGPointMake(8.67, 28.02)];
    [path addCurveToPoint: CGPointMake(8.75, 28.37) controlPoint1: CGPointMake(8.67, 28.14) controlPoint2: CGPointMake(8.7, 28.26)];
    [path addCurveToPoint: CGPointMake(9.23, 29.11) controlPoint1: CGPointMake(8.87, 28.65) controlPoint2: CGPointMake(9.05, 28.88)];
    [path addCurveToPoint: CGPointMake(10.19, 30.11) controlPoint1: CGPointMake(9.53, 29.47) controlPoint2: CGPointMake(9.86, 29.79)];
    [path addCurveToPoint: CGPointMake(10.3, 30.21) controlPoint1: CGPointMake(10.23, 30.14) controlPoint2: CGPointMake(10.26, 30.18)];
    [path addCurveToPoint: CGPointMake(10.37, 30.28) controlPoint1: CGPointMake(10.32, 30.23) controlPoint2: CGPointMake(10.35, 30.26)];
    [path addCurveToPoint: CGPointMake(10.4, 30.3) controlPoint1: CGPointMake(10.38, 30.29) controlPoint2: CGPointMake(10.39, 30.29)];
    [path addCurveToPoint: CGPointMake(13.68, 33.16) controlPoint1: CGPointMake(11.46, 31.29) controlPoint2: CGPointMake(12.57, 32.23)];
    [path addCurveToPoint: CGPointMake(22.48, 40.54) controlPoint1: CGPointMake(16.61, 35.63) controlPoint2: CGPointMake(19.55, 38.09)];
    [path addCurveToPoint: CGPointMake(24.55, 42.23) controlPoint1: CGPointMake(23.16, 41.11) controlPoint2: CGPointMake(23.86, 41.67)];
    [path addCurveToPoint: CGPointMake(26.06, 43.34) controlPoint1: CGPointMake(25.04, 42.62) controlPoint2: CGPointMake(25.54, 42.99)];
    [path addCurveToPoint: CGPointMake(27.13, 43.93) controlPoint1: CGPointMake(26.4, 43.57) controlPoint2: CGPointMake(26.74, 43.78)];
    [path addCurveToPoint: CGPointMake(27.57, 44.04) controlPoint1: CGPointMake(27.27, 43.99) controlPoint2: CGPointMake(27.42, 44.03)];
    [path addCurveToPoint: CGPointMake(28.14, 43.84) controlPoint1: CGPointMake(27.79, 44.05) controlPoint2: CGPointMake(27.98, 43.99)];
    [path addCurveToPoint: CGPointMake(28.44, 43.53) controlPoint1: CGPointMake(28.25, 43.75) controlPoint2: CGPointMake(28.35, 43.64)];
    [path addCurveToPoint: CGPointMake(28.95, 42.93) controlPoint1: CGPointMake(28.61, 43.33) controlPoint2: CGPointMake(28.78, 43.13)];
    [path addCurveToPoint: CGPointMake(29.2, 42.63) controlPoint1: CGPointMake(29.03, 42.83) controlPoint2: CGPointMake(29.12, 42.73)];
    [path addCurveToPoint: CGPointMake(29.2, 42.63) controlPoint1: CGPointMake(29.2, 42.63) controlPoint2: CGPointMake(29.2, 42.63)];
    [path addCurveToPoint: CGPointMake(29.45, 42.33) controlPoint1: CGPointMake(29.29, 42.53) controlPoint2: CGPointMake(29.37, 42.43)];
    [path addCurveToPoint: CGPointMake(29.71, 41.98) controlPoint1: CGPointMake(29.55, 42.21) controlPoint2: CGPointMake(29.63, 42.1)];
    [path addCurveToPoint: CGPointMake(29.8, 41.38) controlPoint1: CGPointMake(29.82, 41.79) controlPoint2: CGPointMake(29.85, 41.59)];
    [path addCurveToPoint: CGPointMake(29.62, 40.96) controlPoint1: CGPointMake(29.76, 41.23) controlPoint2: CGPointMake(29.7, 41.09)];
    [path addCurveToPoint: CGPointMake(28.85, 40.01) controlPoint1: CGPointMake(29.41, 40.61) controlPoint2: CGPointMake(29.13, 40.31)];
    [path addCurveToPoint: CGPointMake(27.49, 38.72) controlPoint1: CGPointMake(28.42, 39.56) controlPoint2: CGPointMake(27.96, 39.13)];
    [path addCurveToPoint: CGPointMake(25.47, 36.98) controlPoint1: CGPointMake(26.82, 38.13) controlPoint2: CGPointMake(26.15, 37.55)];
    [path addCurveToPoint: CGPointMake(17.39, 30.19) controlPoint1: CGPointMake(22.78, 34.71) controlPoint2: CGPointMake(20.09, 32.45)];
    [path addCurveToPoint: CGPointMake(20.85, 30.2) controlPoint1: CGPointMake(18.54, 30.2) controlPoint2: CGPointMake(19.69, 30.2)];
    [path addCurveToPoint: CGPointMake(37.77, 30.2) controlPoint1: CGPointMake(26.49, 30.2) controlPoint2: CGPointMake(32.13, 30.2)];
    [path addCurveToPoint: CGPointMake(41.7, 30.16) controlPoint1: CGPointMake(39.08, 30.2) controlPoint2: CGPointMake(40.39, 30.18)];
    [path addCurveToPoint: CGPointMake(44.46, 30.04) controlPoint1: CGPointMake(42.62, 30.14) controlPoint2: CGPointMake(43.54, 30.11)];
    [path addCurveToPoint: CGPointMake(46.22, 29.81) controlPoint1: CGPointMake(45.05, 30) controlPoint2: CGPointMake(45.65, 29.94)];
    [path addCurveToPoint: CGPointMake(46.83, 29.6) controlPoint1: CGPointMake(46.44, 29.76) controlPoint2: CGPointMake(46.64, 29.69)];
    [path addCurveToPoint: CGPointMake(47.28, 29.09) controlPoint1: CGPointMake(47.09, 29.48) controlPoint2: CGPointMake(47.24, 29.3)];
    [path addCurveToPoint: CGPointMake(47.33, 28.66) controlPoint1: CGPointMake(47.31, 28.95) controlPoint2: CGPointMake(47.33, 28.8)];
    [path addCurveToPoint: CGPointMake(47.33, 28.26) controlPoint1: CGPointMake(47.33, 28.53) controlPoint2: CGPointMake(47.33, 28.39)];
    [path addLineToPoint: CGPointMake(47.33, 28.26)];
    [path addCurveToPoint: CGPointMake(47.33, 27.87) controlPoint1: CGPointMake(47.33, 28.13) controlPoint2: CGPointMake(47.33, 28)];
    [path addCurveToPoint: CGPointMake(47.33, 27.08) controlPoint1: CGPointMake(47.33, 27.6) controlPoint2: CGPointMake(47.33, 27.34)];
    [path closePath];
    return path;
}

static UIBezierPath *_RoundBackButtonRightArrowIconPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(8.67, 28.92)];
    [path addCurveToPoint: CGPointMake(8.72, 29.35) controlPoint1: CGPointMake(8.67, 29.06) controlPoint2: CGPointMake(8.69, 29.21)];
    [path addCurveToPoint: CGPointMake(9.17, 29.87) controlPoint1: CGPointMake(8.76, 29.56) controlPoint2: CGPointMake(8.91, 29.74)];
    [path addCurveToPoint: CGPointMake(9.77, 30.07) controlPoint1: CGPointMake(9.36, 29.96) controlPoint2: CGPointMake(9.56, 30.02)];
    [path addCurveToPoint: CGPointMake(11.54, 30.3) controlPoint1: CGPointMake(10.35, 30.2) controlPoint2: CGPointMake(10.94, 30.26)];
    [path addCurveToPoint: CGPointMake(14.3, 30.42) controlPoint1: CGPointMake(12.46, 30.37) controlPoint2: CGPointMake(13.38, 30.41)];
    [path addCurveToPoint: CGPointMake(18.23, 30.46) controlPoint1: CGPointMake(15.61, 30.44) controlPoint2: CGPointMake(16.92, 30.46)];
    [path addCurveToPoint: CGPointMake(35.15, 30.46) controlPoint1: CGPointMake(23.87, 30.46) controlPoint2: CGPointMake(29.51, 30.47)];
    [path addCurveToPoint: CGPointMake(38.3, 30.45) controlPoint1: CGPointMake(36.2, 30.46) controlPoint2: CGPointMake(37.25, 30.46)];
    [path addCurveToPoint: CGPointMake(30.52, 36.98) controlPoint1: CGPointMake(35.7, 32.62) controlPoint2: CGPointMake(33.11, 34.8)];
    [path addCurveToPoint: CGPointMake(28.51, 38.72) controlPoint1: CGPointMake(29.85, 37.55) controlPoint2: CGPointMake(29.18, 38.13)];
    [path addCurveToPoint: CGPointMake(27.15, 40.01) controlPoint1: CGPointMake(28.04, 39.13) controlPoint2: CGPointMake(27.58, 39.56)];
    [path addCurveToPoint: CGPointMake(26.38, 40.96) controlPoint1: CGPointMake(26.87, 40.31) controlPoint2: CGPointMake(26.59, 40.61)];
    [path addCurveToPoint: CGPointMake(26.2, 41.38) controlPoint1: CGPointMake(26.3, 41.09) controlPoint2: CGPointMake(26.23, 41.23)];
    [path addCurveToPoint: CGPointMake(26.29, 41.98) controlPoint1: CGPointMake(26.14, 41.59) controlPoint2: CGPointMake(26.18, 41.79)];
    [path addCurveToPoint: CGPointMake(26.55, 42.33) controlPoint1: CGPointMake(26.37, 42.1) controlPoint2: CGPointMake(26.45, 42.22)];
    [path addCurveToPoint: CGPointMake(26.8, 42.63) controlPoint1: CGPointMake(26.63, 42.43) controlPoint2: CGPointMake(26.71, 42.53)];
    [path addCurveToPoint: CGPointMake(26.8, 42.63) controlPoint1: CGPointMake(26.8, 42.63) controlPoint2: CGPointMake(26.8, 42.63)];
    [path addCurveToPoint: CGPointMake(27.05, 42.93) controlPoint1: CGPointMake(26.88, 42.73) controlPoint2: CGPointMake(26.97, 42.83)];
    [path addCurveToPoint: CGPointMake(27.56, 43.53) controlPoint1: CGPointMake(27.22, 43.13) controlPoint2: CGPointMake(27.39, 43.33)];
    [path addCurveToPoint: CGPointMake(27.86, 43.84) controlPoint1: CGPointMake(27.65, 43.64) controlPoint2: CGPointMake(27.75, 43.75)];
    [path addCurveToPoint: CGPointMake(28.43, 44.04) controlPoint1: CGPointMake(28.02, 43.99) controlPoint2: CGPointMake(28.21, 44.06)];
    [path addCurveToPoint: CGPointMake(28.87, 43.93) controlPoint1: CGPointMake(28.58, 44.03) controlPoint2: CGPointMake(28.73, 43.99)];
    [path addCurveToPoint: CGPointMake(29.94, 43.34) controlPoint1: CGPointMake(29.25, 43.78) controlPoint2: CGPointMake(29.6, 43.57)];
    [path addCurveToPoint: CGPointMake(31.45, 42.23) controlPoint1: CGPointMake(30.46, 42.99) controlPoint2: CGPointMake(30.96, 42.62)];
    [path addCurveToPoint: CGPointMake(33.52, 40.54) controlPoint1: CGPointMake(32.14, 41.67) controlPoint2: CGPointMake(32.84, 41.11)];
    [path addCurveToPoint: CGPointMake(42.32, 33.17) controlPoint1: CGPointMake(36.45, 38.09) controlPoint2: CGPointMake(39.39, 35.63)];
    [path addCurveToPoint: CGPointMake(45.6, 30.3) controlPoint1: CGPointMake(43.43, 32.23) controlPoint2: CGPointMake(44.54, 31.29)];
    [path addCurveToPoint: CGPointMake(45.63, 30.28) controlPoint1: CGPointMake(45.61, 30.29) controlPoint2: CGPointMake(45.62, 30.29)];
    [path addCurveToPoint: CGPointMake(45.7, 30.21) controlPoint1: CGPointMake(45.65, 30.26) controlPoint2: CGPointMake(45.67, 30.23)];
    [path addCurveToPoint: CGPointMake(45.81, 30.11) controlPoint1: CGPointMake(45.74, 30.18) controlPoint2: CGPointMake(45.77, 30.15)];
    [path addCurveToPoint: CGPointMake(46.77, 29.11) controlPoint1: CGPointMake(46.14, 29.79) controlPoint2: CGPointMake(46.47, 29.47)];
    [path addCurveToPoint: CGPointMake(47.25, 28.38) controlPoint1: CGPointMake(46.95, 28.88) controlPoint2: CGPointMake(47.13, 28.65)];
    [path addCurveToPoint: CGPointMake(47.33, 28.03) controlPoint1: CGPointMake(47.3, 28.26) controlPoint2: CGPointMake(47.33, 28.14)];
    [path addCurveToPoint: CGPointMake(47.33, 28) controlPoint1: CGPointMake(47.33, 28.02) controlPoint2: CGPointMake(47.33, 28.01)];
    [path addCurveToPoint: CGPointMake(47.33, 27.97) controlPoint1: CGPointMake(47.33, 27.99) controlPoint2: CGPointMake(47.33, 27.98)];
    [path addCurveToPoint: CGPointMake(47.25, 27.63) controlPoint1: CGPointMake(47.33, 27.86) controlPoint2: CGPointMake(47.3, 27.74)];
    [path addCurveToPoint: CGPointMake(46.77, 26.89) controlPoint1: CGPointMake(47.13, 27.35) controlPoint2: CGPointMake(46.95, 27.12)];
    [path addCurveToPoint: CGPointMake(45.81, 25.89) controlPoint1: CGPointMake(46.47, 26.53) controlPoint2: CGPointMake(46.14, 26.21)];
    [path addCurveToPoint: CGPointMake(45.7, 25.79) controlPoint1: CGPointMake(45.77, 25.86) controlPoint2: CGPointMake(45.74, 25.82)];
    [path addCurveToPoint: CGPointMake(45.63, 25.72) controlPoint1: CGPointMake(45.67, 25.77) controlPoint2: CGPointMake(45.65, 25.74)];
    [path addCurveToPoint: CGPointMake(45.6, 25.7) controlPoint1: CGPointMake(45.62, 25.71) controlPoint2: CGPointMake(45.61, 25.71)];
    [path addCurveToPoint: CGPointMake(42.32, 22.84) controlPoint1: CGPointMake(44.54, 24.71) controlPoint2: CGPointMake(43.43, 23.77)];
    [path addCurveToPoint: CGPointMake(33.52, 15.46) controlPoint1: CGPointMake(39.39, 20.37) controlPoint2: CGPointMake(36.45, 17.91)];
    [path addCurveToPoint: CGPointMake(31.45, 13.77) controlPoint1: CGPointMake(32.84, 14.89) controlPoint2: CGPointMake(32.14, 14.33)];
    [path addCurveToPoint: CGPointMake(29.94, 12.66) controlPoint1: CGPointMake(30.96, 13.38) controlPoint2: CGPointMake(30.46, 13.01)];
    [path addCurveToPoint: CGPointMake(28.87, 12.07) controlPoint1: CGPointMake(29.6, 12.43) controlPoint2: CGPointMake(29.25, 12.22)];
    [path addCurveToPoint: CGPointMake(28.43, 11.96) controlPoint1: CGPointMake(28.73, 12.01) controlPoint2: CGPointMake(28.58, 11.97)];
    [path addCurveToPoint: CGPointMake(27.86, 12.16) controlPoint1: CGPointMake(28.21, 11.95) controlPoint2: CGPointMake(28.02, 12.01)];
    [path addCurveToPoint: CGPointMake(27.56, 12.47) controlPoint1: CGPointMake(27.75, 12.25) controlPoint2: CGPointMake(27.65, 12.36)];
    [path addCurveToPoint: CGPointMake(27.05, 13.07) controlPoint1: CGPointMake(27.39, 12.67) controlPoint2: CGPointMake(27.22, 12.87)];
    [path addCurveToPoint: CGPointMake(26.8, 13.37) controlPoint1: CGPointMake(26.97, 13.17) controlPoint2: CGPointMake(26.88, 13.27)];
    [path addCurveToPoint: CGPointMake(26.8, 13.37) controlPoint1: CGPointMake(26.8, 13.37) controlPoint2: CGPointMake(26.8, 13.37)];
    [path addCurveToPoint: CGPointMake(26.55, 13.67) controlPoint1: CGPointMake(26.71, 13.47) controlPoint2: CGPointMake(26.63, 13.57)];
    [path addCurveToPoint: CGPointMake(26.29, 14.02) controlPoint1: CGPointMake(26.45, 13.79) controlPoint2: CGPointMake(26.37, 13.9)];
    [path addCurveToPoint: CGPointMake(26.2, 14.62) controlPoint1: CGPointMake(26.18, 14.21) controlPoint2: CGPointMake(26.14, 14.41)];
    [path addCurveToPoint: CGPointMake(26.38, 15.04) controlPoint1: CGPointMake(26.23, 14.77) controlPoint2: CGPointMake(26.3, 14.91)];
    [path addCurveToPoint: CGPointMake(27.15, 15.99) controlPoint1: CGPointMake(26.59, 15.39) controlPoint2: CGPointMake(26.87, 15.69)];
    [path addCurveToPoint: CGPointMake(28.51, 17.28) controlPoint1: CGPointMake(27.58, 16.44) controlPoint2: CGPointMake(28.04, 16.87)];
    [path addCurveToPoint: CGPointMake(30.52, 19.02) controlPoint1: CGPointMake(29.18, 17.87) controlPoint2: CGPointMake(29.85, 18.45)];
    [path addCurveToPoint: CGPointMake(38.61, 25.81) controlPoint1: CGPointMake(33.22, 21.29) controlPoint2: CGPointMake(35.91, 23.55)];
    [path addCurveToPoint: CGPointMake(35.15, 25.8) controlPoint1: CGPointMake(37.46, 25.8) controlPoint2: CGPointMake(36.31, 25.8)];
    [path addCurveToPoint: CGPointMake(18.23, 25.8) controlPoint1: CGPointMake(29.51, 25.8) controlPoint2: CGPointMake(23.87, 25.8)];
    [path addCurveToPoint: CGPointMake(14.3, 25.84) controlPoint1: CGPointMake(16.92, 25.8) controlPoint2: CGPointMake(15.61, 25.82)];
    [path addCurveToPoint: CGPointMake(11.54, 25.96) controlPoint1: CGPointMake(13.38, 25.86) controlPoint2: CGPointMake(12.46, 25.89)];
    [path addCurveToPoint: CGPointMake(9.77, 26.19) controlPoint1: CGPointMake(10.94, 26) controlPoint2: CGPointMake(10.35, 26.06)];
    [path addCurveToPoint: CGPointMake(9.17, 26.4) controlPoint1: CGPointMake(9.56, 26.24) controlPoint2: CGPointMake(9.36, 26.31)];
    [path addCurveToPoint: CGPointMake(8.72, 26.91) controlPoint1: CGPointMake(8.91, 26.52) controlPoint2: CGPointMake(8.76, 26.7)];
    [path addCurveToPoint: CGPointMake(8.67, 27.34) controlPoint1: CGPointMake(8.69, 27.05) controlPoint2: CGPointMake(8.67, 27.2)];
    [path addCurveToPoint: CGPointMake(8.67, 27.74) controlPoint1: CGPointMake(8.67, 27.47) controlPoint2: CGPointMake(8.67, 27.61)];
    [path addLineToPoint: CGPointMake(8.67, 27.74)];
    [path addCurveToPoint: CGPointMake(8.67, 28.13) controlPoint1: CGPointMake(8.67, 27.87) controlPoint2: CGPointMake(8.67, 28)];
    [path addCurveToPoint: CGPointMake(8.67, 28.92) controlPoint1: CGPointMake(8.67, 28.4) controlPoint2: CGPointMake(8.67, 28.66)];
    [path closePath];
    return path;
}

static UIBezierPath *_WordTrayFillPath()
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

static UIBezierPath *_WordTrayStrokePath()
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

static UIBezierPath *_TextButtonFillPath()
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

static UIBezierPath *_TextButtonStrokePath()
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

static UIBezierPath *_ChoiceRowLeftFillPathSelected()
{
    // checkmark
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(71.04, 60.7)];
    [path addCurveToPoint: CGPointMake(69.86, 60.54) controlPoint1: CGPointMake(70.64, 60.7) controlPoint2: CGPointMake(70.25, 60.65)];
    [path addCurveToPoint: CGPointMake(66.68, 57.31) controlPoint1: CGPointMake(68.29, 60.12) controlPoint2: CGPointMake(67.08, 58.88)];
    [path addLineToPoint: CGPointMake(62.45, 40.68)];
    [path addCurveToPoint: CGPointMake(65.7, 35.21) controlPoint1: CGPointMake(61.84, 38.27) controlPoint2: CGPointMake(63.3, 35.82)];
    [path addCurveToPoint: CGPointMake(71.17, 38.46) controlPoint1: CGPointMake(68.11, 34.59) controlPoint2: CGPointMake(70.56, 36.05)];
    [path addLineToPoint: CGPointMake(73.43, 47.34)];
    [path addLineToPoint: CGPointMake(95.98, 24.38)];
    [path addCurveToPoint: CGPointMake(102.34, 24.32) controlPoint1: CGPointMake(97.72, 22.6) controlPoint2: CGPointMake(100.57, 22.58)];
    [path addCurveToPoint: CGPointMake(102.4, 30.68) controlPoint1: CGPointMake(104.11, 26.06) controlPoint2: CGPointMake(104.14, 28.91)];
    [path addLineToPoint: CGPointMake(74.25, 59.35)];
    [path addCurveToPoint: CGPointMake(71.04, 60.7) controlPoint1: CGPointMake(73.39, 60.23) controlPoint2: CGPointMake(72.23, 60.7)];
    [path closePath];
    return path;
}

static UIBezierPath *_ChoiceRowLeftArrowPath()
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(99.89, 39.25)];
    [path addLineToPoint: CGPointMake(73.79, 39.25)];
    [path addLineToPoint: CGPointMake(85.1, 29.66)];
    [path addCurveToPoint: CGPointMake(86.24, 27.45) controlPoint1: CGPointMake(85.76, 29.1) controlPoint2: CGPointMake(86.17, 28.31)];
    [path addCurveToPoint: CGPointMake(85.48, 25.08) controlPoint1: CGPointMake(86.31, 26.58) controlPoint2: CGPointMake(86.04, 25.74)];
    [path addCurveToPoint: CGPointMake(83.27, 23.94) controlPoint1: CGPointMake(84.92, 24.41) controlPoint2: CGPointMake(84.13, 24.01)];
    [path addCurveToPoint: CGPointMake(80.9, 24.7) controlPoint1: CGPointMake(82.41, 23.87) controlPoint2: CGPointMake(81.56, 24.14)];
    [path addLineToPoint: CGPointMake(62.83, 40.02)];
    [path addCurveToPoint: CGPointMake(61.68, 42.5) controlPoint1: CGPointMake(62.1, 40.64) controlPoint2: CGPointMake(61.68, 41.54)];
    [path addCurveToPoint: CGPointMake(62.83, 44.98) controlPoint1: CGPointMake(61.68, 43.46) controlPoint2: CGPointMake(62.1, 44.36)];
    [path addLineToPoint: CGPointMake(80.9, 60.3)];
    [path addCurveToPoint: CGPointMake(83, 61.07) controlPoint1: CGPointMake(81.49, 60.8) controlPoint2: CGPointMake(82.23, 61.07)];
    [path addCurveToPoint: CGPointMake(83.27, 61.06) controlPoint1: CGPointMake(83.08, 61.07) controlPoint2: CGPointMake(83.18, 61.07)];
    [path addCurveToPoint: CGPointMake(85.48, 59.92) controlPoint1: CGPointMake(84.13, 60.99) controlPoint2: CGPointMake(84.92, 60.58)];
    [path addCurveToPoint: CGPointMake(86.24, 57.55) controlPoint1: CGPointMake(86.04, 59.26) controlPoint2: CGPointMake(86.31, 58.42)];
    [path addCurveToPoint: CGPointMake(85.1, 55.34) controlPoint1: CGPointMake(86.17, 56.69) controlPoint2: CGPointMake(85.76, 55.9)];
    [path addLineToPoint: CGPointMake(73.79, 45.75)];
    [path addLineToPoint: CGPointMake(99.89, 45.75)];
    [path addCurveToPoint: CGPointMake(103.14, 42.5) controlPoint1: CGPointMake(101.69, 45.75) controlPoint2: CGPointMake(103.14, 44.29)];
    [path addCurveToPoint: CGPointMake(99.89, 39.25) controlPoint1: CGPointMake(103.14, 40.71) controlPoint2: CGPointMake(101.69, 39.25)];
    [path closePath];
    return path;
}

static UIBezierPath *_ChoiceTitleLeftFillPath()
{
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 9.5, 66, 66)];
}

static UIBezierPath *_ChoiceTitleLeftStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(99.89, 39.25)];
    [path addLineToPoint: CGPointMake(73.79, 39.25)];
    [path addLineToPoint: CGPointMake(85.1, 29.66)];
    [path addCurveToPoint: CGPointMake(86.24, 27.45) controlPoint1: CGPointMake(85.76, 29.1) controlPoint2: CGPointMake(86.17, 28.31)];
    [path addCurveToPoint: CGPointMake(85.48, 25.08) controlPoint1: CGPointMake(86.31, 26.58) controlPoint2: CGPointMake(86.04, 25.74)];
    [path addCurveToPoint: CGPointMake(83.27, 23.94) controlPoint1: CGPointMake(84.92, 24.41) controlPoint2: CGPointMake(84.13, 24.01)];
    [path addCurveToPoint: CGPointMake(80.9, 24.7) controlPoint1: CGPointMake(82.41, 23.87) controlPoint2: CGPointMake(81.56, 24.14)];
    [path addLineToPoint: CGPointMake(62.83, 40.02)];
    [path addCurveToPoint: CGPointMake(61.68, 42.5) controlPoint1: CGPointMake(62.1, 40.64) controlPoint2: CGPointMake(61.68, 41.54)];
    [path addCurveToPoint: CGPointMake(62.83, 44.98) controlPoint1: CGPointMake(61.68, 43.46) controlPoint2: CGPointMake(62.1, 44.36)];
    [path addLineToPoint: CGPointMake(80.9, 60.3)];
    [path addCurveToPoint: CGPointMake(83, 61.07) controlPoint1: CGPointMake(81.49, 60.8) controlPoint2: CGPointMake(82.23, 61.07)];
    [path addCurveToPoint: CGPointMake(83.27, 61.06) controlPoint1: CGPointMake(83.08, 61.07) controlPoint2: CGPointMake(83.18, 61.07)];
    [path addCurveToPoint: CGPointMake(85.48, 59.92) controlPoint1: CGPointMake(84.13, 60.99) controlPoint2: CGPointMake(84.92, 60.58)];
    [path addCurveToPoint: CGPointMake(86.24, 57.55) controlPoint1: CGPointMake(86.04, 59.26) controlPoint2: CGPointMake(86.31, 58.42)];
    [path addCurveToPoint: CGPointMake(85.1, 55.34) controlPoint1: CGPointMake(86.17, 56.69) controlPoint2: CGPointMake(85.76, 55.9)];
    [path addLineToPoint: CGPointMake(73.79, 45.75)];
    [path addLineToPoint: CGPointMake(99.89, 45.75)];
    [path addCurveToPoint: CGPointMake(103.14, 42.5) controlPoint1: CGPointMake(101.69, 45.75) controlPoint2: CGPointMake(103.14, 44.29)];
    [path addCurveToPoint: CGPointMake(99.89, 39.25) controlPoint1: CGPointMake(103.14, 40.71) controlPoint2: CGPointMake(101.69, 39.25)];
    [path closePath];
    return path;
}

static UIBezierPath *_ChoiceRowLeftTextExtras()
{
    // E
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(147.02, 23.55)];
    [path addLineToPoint: CGPointMake(166.88, 23.55)];
    [path addLineToPoint: CGPointMake(165.32, 31.66)];
    [path addLineToPoint: CGPointMake(154.87, 31.66)];
    [path addLineToPoint: CGPointMake(153.68, 37.79)];
    [path addLineToPoint: CGPointMake(162.62, 37.79)];
    [path addLineToPoint: CGPointMake(161.11, 45.39)];
    [path addLineToPoint: CGPointMake(152.22, 45.39)];
    [path addLineToPoint: CGPointMake(150.97, 51.83)];
    [path addLineToPoint: CGPointMake(162.05, 51.83)];
    [path addLineToPoint: CGPointMake(159.55, 59.95)];
    [path addLineToPoint: CGPointMake(140, 59.95)];
    [path addLineToPoint: CGPointMake(147.02, 23.55)];
    [path closePath];
    
    // X
    [path moveToPoint: CGPointMake(178.37, 48.51)];
    [path addLineToPoint: CGPointMake(172.03, 59.95)];
    [path addLineToPoint: CGPointMake(161.73, 59.95)];
    [path addLineToPoint: CGPointMake(161.73, 59.79)];
    [path addLineToPoint: CGPointMake(173.64, 41.07)];
    [path addLineToPoint: CGPointMake(169.02, 23.55)];
    [path addLineToPoint: CGPointMake(179.21, 23.55)];
    [path addLineToPoint: CGPointMake(181.23, 34.21)];
    [path addLineToPoint: CGPointMake(187.06, 23.55)];
    [path addLineToPoint: CGPointMake(197.3, 23.55)];
    [path addLineToPoint: CGPointMake(197.3, 23.65)];
    [path addLineToPoint: CGPointMake(185.92, 41.75)];
    [path addLineToPoint: CGPointMake(190.75, 59.95)];
    [path addLineToPoint: CGPointMake(180.56, 59.95)];
    [path addLineToPoint: CGPointMake(178.37, 48.51)];
    [path closePath];
    
    // T
    [path moveToPoint: CGPointMake(214.36, 31.87)];
    [path addLineToPoint: CGPointMake(208.95, 59.95)];
    [path addLineToPoint: CGPointMake(199.33, 59.95)];
    [path addLineToPoint: CGPointMake(204.74, 31.87)];
    [path addLineToPoint: CGPointMake(197.09, 31.87)];
    [path addLineToPoint: CGPointMake(198.76, 23.55)];
    [path addLineToPoint: CGPointMake(223.56, 23.55)];
    [path addLineToPoint: CGPointMake(221.9, 31.87)];
    [path addLineToPoint: CGPointMake(214.36, 31.87)];
    [path closePath];
    
    // R
    [path moveToPoint: CGPointMake(234.38, 30.88)];
    [path addLineToPoint: CGPointMake(232.45, 40.81)];
    [path addLineToPoint: CGPointMake(233.44, 40.81)];
    [path addCurveToPoint: CGPointMake(238.69, 34.36) controlPoint1: CGPointMake(236.77, 40.81) controlPoint2: CGPointMake(238.69, 37.74)];
    [path addCurveToPoint: CGPointMake(235.26, 30.88) controlPoint1: CGPointMake(238.69, 32.07) controlPoint2: CGPointMake(237.65, 30.88)];
    [path addLineToPoint: CGPointMake(234.38, 30.88)];
    [path closePath];
    [path moveToPoint: CGPointMake(231.94, 46.84)];
    [path addLineToPoint: CGPointMake(231.36, 46.84)];
    [path addLineToPoint: CGPointMake(228.87, 59.95)];
    [path addLineToPoint: CGPointMake(219.3, 59.95)];
    [path addLineToPoint: CGPointMake(226.32, 23.55)];
    [path addLineToPoint: CGPointMake(236.41, 23.55)];
    [path addCurveToPoint: CGPointMake(248.21, 33.58) controlPoint1: CGPointMake(244.15, 23.55) controlPoint2: CGPointMake(248.21, 27.19)];
    [path addCurveToPoint: CGPointMake(240.88, 45.13) controlPoint1: CGPointMake(248.21, 38.99) controlPoint2: CGPointMake(245.09, 42.99)];
    [path addLineToPoint: CGPointMake(245.72, 59.95)];
    [path addLineToPoint: CGPointMake(235.68, 59.95)];
    [path addLineToPoint: CGPointMake(231.94, 46.84)];
    [path closePath];
    
    // A
    [path moveToPoint: CGPointMake(266.1, 45.8)];
    [path addLineToPoint: CGPointMake(265.63, 33.27)];
    [path addLineToPoint: CGPointMake(260.43, 45.8)];
    [path addLineToPoint: CGPointMake(266.1, 45.8)];
    [path closePath];
    [path moveToPoint: CGPointMake(261.83, 23.49)];
    [path addLineToPoint: CGPointMake(273.33, 23.49)];
    [path addLineToPoint: CGPointMake(275.93, 59.95)];
    [path addLineToPoint: CGPointMake(266.05, 59.95)];
    [path addLineToPoint: CGPointMake(265.94, 53.34)];
    [path addLineToPoint: CGPointMake(257.73, 53.34)];
    [path addLineToPoint: CGPointMake(255.02, 59.95)];
    [path addLineToPoint: CGPointMake(245.14, 59.95)];
    [path addLineToPoint: CGPointMake(261.83, 23.49)];
    [path closePath];
    
    // S
    [path moveToPoint: CGPointMake(303.02, 25.78)];
    [path addLineToPoint: CGPointMake(302.19, 34.67)];
    [path addLineToPoint: CGPointMake(302.03, 34.67)];
    [path addCurveToPoint: CGPointMake(294.08, 30.88) controlPoint1: CGPointMake(299.54, 32.49) controlPoint2: CGPointMake(296.57, 30.88)];
    [path addCurveToPoint: CGPointMake(291.53, 32.96) controlPoint1: CGPointMake(292.57, 30.88) controlPoint2: CGPointMake(291.53, 31.66)];
    [path addCurveToPoint: CGPointMake(294.75, 37.85) controlPoint1: CGPointMake(291.53, 34.15) controlPoint2: CGPointMake(292.36, 35.45)];
    [path addCurveToPoint: CGPointMake(300.37, 48.92) controlPoint1: CGPointMake(298.86, 41.69) controlPoint2: CGPointMake(300.37, 45.02)];
    [path addCurveToPoint: CGPointMake(288.25, 60.62) controlPoint1: CGPointMake(300.37, 56.1) controlPoint2: CGPointMake(295.74, 60.62)];
    [path addCurveToPoint: CGPointMake(278.37, 57.4) controlPoint1: CGPointMake(284.2, 60.62) controlPoint2: CGPointMake(280.55, 59.22)];
    [path addLineToPoint: CGPointMake(278.68, 47.67)];
    [path addLineToPoint: CGPointMake(278.84, 47.62)];
    [path addCurveToPoint: CGPointMake(287.83, 52.61) controlPoint1: CGPointMake(281.8, 50.74) controlPoint2: CGPointMake(285.23, 52.61)];
    [path addCurveToPoint: CGPointMake(290.7, 50.22) controlPoint1: CGPointMake(289.66, 52.61) controlPoint2: CGPointMake(290.7, 51.63)];
    [path addCurveToPoint: CGPointMake(287.78, 45.33) controlPoint1: CGPointMake(290.7, 48.77) controlPoint2: CGPointMake(289.81, 47.31)];
    [path addCurveToPoint: CGPointMake(281.91, 34.05) controlPoint1: CGPointMake(283.31, 41.07) controlPoint2: CGPointMake(281.91, 37.95)];
    [path addCurveToPoint: CGPointMake(293.76, 22.87) controlPoint1: CGPointMake(281.91, 27.55) controlPoint2: CGPointMake(286.54, 22.87)];
    [path addCurveToPoint: CGPointMake(303.02, 25.78) controlPoint1: CGPointMake(297.4, 22.87) controlPoint2: CGPointMake(300.73, 24.01)];
    [path closePath];

    return path;
}

static UIBezierPath *_ChoiceRowLeftTextColors()
{
    // C
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(160.85, 60.54)];
    [path addCurveToPoint: CGPointMake(153.05, 62.77) controlPoint1: CGPointMake(158.67, 61.89) controlPoint2: CGPointMake(156.38, 62.77)];
    [path addCurveToPoint: CGPointMake(141.56, 48.73) controlPoint1: CGPointMake(145.57, 62.77) controlPoint2: CGPointMake(141.56, 57.31)];
    [path addCurveToPoint: CGPointMake(158.77, 25.23) controlPoint1: CGPointMake(141.56, 37.71) controlPoint2: CGPointMake(147.28, 25.23)];
    [path addCurveToPoint: CGPointMake(167.15, 28.3) controlPoint1: CGPointMake(162.36, 25.23) controlPoint2: CGPointMake(165.17, 26.42)];
    [path addLineToPoint: CGPointMake(165.38, 37.45)];
    [path addLineToPoint: CGPointMake(165.27, 37.5)];
    [path addCurveToPoint: CGPointMake(159.24, 34.02) controlPoint1: CGPointMake(163.56, 35.37) controlPoint2: CGPointMake(161.79, 34.02)];
    [path addCurveToPoint: CGPointMake(151.7, 43.58) controlPoint1: CGPointMake(155.65, 34.02) controlPoint2: CGPointMake(152.69, 38.44)];
    [path addCurveToPoint: CGPointMake(151.29, 47.38) controlPoint1: CGPointMake(151.49, 44.83) controlPoint2: CGPointMake(151.29, 46.13)];
    [path addCurveToPoint: CGPointMake(156.23, 53.98) controlPoint1: CGPointMake(151.29, 51.75) controlPoint2: CGPointMake(153.16, 53.98)];
    [path addCurveToPoint: CGPointMake(163.09, 50.76) controlPoint1: CGPointMake(158.51, 53.98) controlPoint2: CGPointMake(160.7, 52.74)];
    [path addLineToPoint: CGPointMake(163.25, 50.86)];
    [path addLineToPoint: CGPointMake(160.85, 60.54)];
    [path closePath];
    
    // O
    [path moveToPoint: CGPointMake(185.24, 44.26)];
    [path addCurveToPoint: CGPointMake(185.97, 38.23) controlPoint1: CGPointMake(185.81, 41.09) controlPoint2: CGPointMake(185.97, 39.37)];
    [path addCurveToPoint: CGPointMake(182.69, 33.44) controlPoint1: CGPointMake(185.97, 35) controlPoint2: CGPointMake(184.62, 33.44)];
    [path addCurveToPoint: CGPointMake(176.51, 43.74) controlPoint1: CGPointMake(180.09, 33.44) controlPoint2: CGPointMake(177.81, 36.88)];
    [path addCurveToPoint: CGPointMake(175.78, 49.77) controlPoint1: CGPointMake(175.93, 46.91) controlPoint2: CGPointMake(175.78, 48.68)];
    [path addCurveToPoint: CGPointMake(179.05, 54.56) controlPoint1: CGPointMake(175.78, 53) controlPoint2: CGPointMake(177.13, 54.56)];
    [path addCurveToPoint: CGPointMake(185.24, 44.26) controlPoint1: CGPointMake(181.65, 54.56) controlPoint2: CGPointMake(183.94, 51.12)];
    [path closePath];
    [path moveToPoint: CGPointMake(166.42, 49.25)];
    [path addCurveToPoint: CGPointMake(183.11, 25.07) controlPoint1: CGPointMake(166.42, 35.42) controlPoint2: CGPointMake(173.28, 25.07)];
    [path addCurveToPoint: CGPointMake(195.33, 38.75) controlPoint1: CGPointMake(191.01, 25.07) controlPoint2: CGPointMake(195.33, 30.64)];
    [path addCurveToPoint: CGPointMake(178.64, 62.93) controlPoint1: CGPointMake(195.33, 52.58) controlPoint2: CGPointMake(188.41, 62.93)];
    [path addCurveToPoint: CGPointMake(166.42, 49.25) controlPoint1: CGPointMake(170.73, 62.93) controlPoint2: CGPointMake(166.42, 57.36)];
    [path closePath];
    
    // L
    [path moveToPoint: CGPointMake(213.74, 62.2)];
    [path addLineToPoint: CGPointMake(194.55, 62.2)];
    [path addLineToPoint: CGPointMake(201.57, 25.8)];
    [path addLineToPoint: CGPointMake(211.14, 25.8)];
    [path addLineToPoint: CGPointMake(205.78, 53.88)];
    [path addLineToPoint: CGPointMake(215.35, 53.88)];
    [path addLineToPoint: CGPointMake(213.74, 62.2)];
    [path closePath];
    
    // O
    [path moveToPoint: CGPointMake(236.1, 44.26)];
    [path addCurveToPoint: CGPointMake(236.83, 38.23) controlPoint1: CGPointMake(236.67, 41.09) controlPoint2: CGPointMake(236.83, 39.37)];
    [path addCurveToPoint: CGPointMake(233.55, 33.44) controlPoint1: CGPointMake(236.83, 35) controlPoint2: CGPointMake(235.47, 33.44)];
    [path addCurveToPoint: CGPointMake(227.36, 43.74) controlPoint1: CGPointMake(230.95, 33.44) controlPoint2: CGPointMake(228.66, 36.88)];
    [path addCurveToPoint: CGPointMake(226.63, 49.77) controlPoint1: CGPointMake(226.79, 46.91) controlPoint2: CGPointMake(226.63, 48.68)];
    [path addCurveToPoint: CGPointMake(229.91, 54.56) controlPoint1: CGPointMake(226.63, 53) controlPoint2: CGPointMake(227.98, 54.56)];
    [path addCurveToPoint: CGPointMake(236.1, 44.26) controlPoint1: CGPointMake(232.51, 54.56) controlPoint2: CGPointMake(234.8, 51.12)];
    [path closePath];
    [path moveToPoint: CGPointMake(217.27, 49.25)];
    [path addCurveToPoint: CGPointMake(233.96, 25.07) controlPoint1: CGPointMake(217.27, 35.42) controlPoint2: CGPointMake(224.14, 25.07)];
    [path addCurveToPoint: CGPointMake(246.19, 38.75) controlPoint1: CGPointMake(241.87, 25.07) controlPoint2: CGPointMake(246.19, 30.64)];
    [path addCurveToPoint: CGPointMake(229.49, 62.93) controlPoint1: CGPointMake(246.19, 52.58) controlPoint2: CGPointMake(239.27, 62.93)];
    [path addCurveToPoint: CGPointMake(217.27, 49.25) controlPoint1: CGPointMake(221.59, 62.93) controlPoint2: CGPointMake(217.27, 57.36)];
    [path closePath];
    
    // R
    [path moveToPoint: CGPointMake(260.48, 33.13)];
    [path addLineToPoint: CGPointMake(258.56, 43.06)];
    [path addLineToPoint: CGPointMake(259.55, 43.06)];
    [path addCurveToPoint: CGPointMake(264.8, 36.62) controlPoint1: CGPointMake(262.88, 43.06) controlPoint2: CGPointMake(264.8, 40)];
    [path addCurveToPoint: CGPointMake(261.37, 33.13) controlPoint1: CGPointMake(264.8, 34.33) controlPoint2: CGPointMake(263.76, 33.13)];
    [path addLineToPoint: CGPointMake(260.48, 33.13)];
    [path closePath];
    [path moveToPoint: CGPointMake(258.04, 49.1)];
    [path addLineToPoint: CGPointMake(257.47, 49.1)];
    [path addLineToPoint: CGPointMake(254.97, 62.2)];
    [path addLineToPoint: CGPointMake(245.4, 62.2)];
    [path addLineToPoint: CGPointMake(252.42, 25.8)];
    [path addLineToPoint: CGPointMake(262.51, 25.8)];
    [path addCurveToPoint: CGPointMake(274.32, 35.84) controlPoint1: CGPointMake(270.26, 25.8) controlPoint2: CGPointMake(274.32, 29.44)];
    [path addCurveToPoint: CGPointMake(266.99, 47.38) controlPoint1: CGPointMake(274.32, 41.24) controlPoint2: CGPointMake(271.2, 45.25)];
    [path addLineToPoint: CGPointMake(271.82, 62.2)];
    [path addLineToPoint: CGPointMake(261.78, 62.2)];
    [path addLineToPoint: CGPointMake(258.04, 49.1)];
    [path closePath];
    
    // S
    [path moveToPoint: CGPointMake(298.7, 28.04)];
    [path addLineToPoint: CGPointMake(297.87, 36.93)];
    [path addLineToPoint: CGPointMake(297.72, 36.93)];
    [path addCurveToPoint: CGPointMake(289.76, 33.13) controlPoint1: CGPointMake(295.22, 34.74) controlPoint2: CGPointMake(292.26, 33.13)];
    [path addCurveToPoint: CGPointMake(287.21, 35.21) controlPoint1: CGPointMake(288.25, 33.13) controlPoint2: CGPointMake(287.21, 33.91)];
    [path addCurveToPoint: CGPointMake(290.43, 40.1) controlPoint1: CGPointMake(287.21, 36.41) controlPoint2: CGPointMake(288.04, 37.71)];
    [path addCurveToPoint: CGPointMake(296.05, 51.18) controlPoint1: CGPointMake(294.54, 43.95) controlPoint2: CGPointMake(296.05, 47.28)];
    [path addCurveToPoint: CGPointMake(283.93, 62.88) controlPoint1: CGPointMake(296.05, 58.35) controlPoint2: CGPointMake(291.42, 62.88)];
    [path addCurveToPoint: CGPointMake(274.06, 59.65) controlPoint1: CGPointMake(279.88, 62.88) controlPoint2: CGPointMake(276.24, 61.47)];
    [path addLineToPoint: CGPointMake(274.37, 49.93)];
    [path addLineToPoint: CGPointMake(274.52, 49.88)];
    [path addCurveToPoint: CGPointMake(283.52, 54.87) controlPoint1: CGPointMake(277.49, 53) controlPoint2: CGPointMake(280.92, 54.87)];
    [path addCurveToPoint: CGPointMake(286.38, 52.48) controlPoint1: CGPointMake(285.34, 54.87) controlPoint2: CGPointMake(286.38, 53.88)];
    [path addCurveToPoint: CGPointMake(283.47, 47.59) controlPoint1: CGPointMake(286.38, 51.02) controlPoint2: CGPointMake(285.49, 49.56)];
    [path addCurveToPoint: CGPointMake(277.59, 36.3) controlPoint1: CGPointMake(278.99, 43.32) controlPoint2: CGPointMake(277.59, 40.2)];
    [path addCurveToPoint: CGPointMake(289.45, 25.12) controlPoint1: CGPointMake(277.59, 29.8) controlPoint2: CGPointMake(282.22, 25.12)];
    [path addCurveToPoint: CGPointMake(298.7, 28.04) controlPoint1: CGPointMake(293.09, 25.12) controlPoint2: CGPointMake(296.42, 26.27)];
    [path closePath];

    return path;
}

static UIBezierPath *_ChoiceRowLeftTextSounds()
{
    // S
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(164.75, 28.04)];
    [path addLineToPoint: CGPointMake(163.92, 36.93)];
    [path addLineToPoint: CGPointMake(163.77, 36.93)];
    [path addCurveToPoint: CGPointMake(155.81, 33.13) controlPoint1: CGPointMake(161.27, 34.74) controlPoint2: CGPointMake(158.31, 33.13)];
    [path addCurveToPoint: CGPointMake(153.26, 35.21) controlPoint1: CGPointMake(154.3, 33.13) controlPoint2: CGPointMake(153.26, 33.91)];
    [path addCurveToPoint: CGPointMake(156.48, 40.1) controlPoint1: CGPointMake(153.26, 36.41) controlPoint2: CGPointMake(154.09, 37.71)];
    [path addCurveToPoint: CGPointMake(162.1, 51.18) controlPoint1: CGPointMake(160.59, 43.95) controlPoint2: CGPointMake(162.1, 47.28)];
    [path addCurveToPoint: CGPointMake(149.98, 62.88) controlPoint1: CGPointMake(162.1, 58.35) controlPoint2: CGPointMake(157.47, 62.88)];
    [path addCurveToPoint: CGPointMake(140.1, 59.65) controlPoint1: CGPointMake(145.93, 62.88) controlPoint2: CGPointMake(142.29, 61.47)];
    [path addLineToPoint: CGPointMake(140.42, 49.93)];
    [path addLineToPoint: CGPointMake(140.57, 49.88)];
    [path addCurveToPoint: CGPointMake(149.57, 54.87) controlPoint1: CGPointMake(143.54, 53) controlPoint2: CGPointMake(146.97, 54.87)];
    [path addCurveToPoint: CGPointMake(152.43, 52.48) controlPoint1: CGPointMake(151.39, 54.87) controlPoint2: CGPointMake(152.43, 53.88)];
    [path addCurveToPoint: CGPointMake(149.52, 47.59) controlPoint1: CGPointMake(152.43, 51.02) controlPoint2: CGPointMake(151.55, 49.56)];
    [path addCurveToPoint: CGPointMake(143.64, 36.3) controlPoint1: CGPointMake(145.04, 43.32) controlPoint2: CGPointMake(143.64, 40.2)];
    [path addCurveToPoint: CGPointMake(155.5, 25.12) controlPoint1: CGPointMake(143.64, 29.8) controlPoint2: CGPointMake(148.27, 25.12)];
    [path addCurveToPoint: CGPointMake(164.75, 28.04) controlPoint1: CGPointMake(159.14, 25.12) controlPoint2: CGPointMake(162.47, 26.27)];
    [path closePath];
    
    // O
    [path moveToPoint: CGPointMake(183.99, 44.26)];
    [path addCurveToPoint: CGPointMake(184.72, 38.23) controlPoint1: CGPointMake(184.56, 41.09) controlPoint2: CGPointMake(184.72, 39.37)];
    [path addCurveToPoint: CGPointMake(181.44, 33.44) controlPoint1: CGPointMake(184.72, 35) controlPoint2: CGPointMake(183.37, 33.44)];
    [path addCurveToPoint: CGPointMake(175.26, 43.74) controlPoint1: CGPointMake(178.84, 33.44) controlPoint2: CGPointMake(176.56, 36.88)];
    [path addCurveToPoint: CGPointMake(174.53, 49.77) controlPoint1: CGPointMake(174.68, 46.91) controlPoint2: CGPointMake(174.53, 48.68)];
    [path addCurveToPoint: CGPointMake(177.81, 54.56) controlPoint1: CGPointMake(174.53, 53) controlPoint2: CGPointMake(175.88, 54.56)];
    [path addCurveToPoint: CGPointMake(183.99, 44.26) controlPoint1: CGPointMake(180.4, 54.56) controlPoint2: CGPointMake(182.69, 51.12)];
    [path closePath];
    [path moveToPoint: CGPointMake(165.17, 49.25)];
    [path addCurveToPoint: CGPointMake(181.86, 25.07) controlPoint1: CGPointMake(165.17, 35.42) controlPoint2: CGPointMake(172.03, 25.07)];
    [path addCurveToPoint: CGPointMake(194.08, 38.75) controlPoint1: CGPointMake(189.76, 25.07) controlPoint2: CGPointMake(194.08, 30.64)];
    [path addCurveToPoint: CGPointMake(177.39, 62.93) controlPoint1: CGPointMake(194.08, 52.58) controlPoint2: CGPointMake(187.16, 62.93)];
    [path addCurveToPoint: CGPointMake(165.17, 49.25) controlPoint1: CGPointMake(169.48, 62.93) controlPoint2: CGPointMake(165.17, 57.36)];
    [path closePath];
    
    // U
    [path moveToPoint: CGPointMake(200.16, 25.8)];
    [path addLineToPoint: CGPointMake(209.73, 25.8)];
    [path addLineToPoint: CGPointMake(205.31, 49.36)];
    [path addCurveToPoint: CGPointMake(205.1, 51.49) controlPoint1: CGPointMake(205.16, 50.14) controlPoint2: CGPointMake(205.1, 50.81)];
    [path addCurveToPoint: CGPointMake(207.91, 54.5) controlPoint1: CGPointMake(205.1, 53.46) controlPoint2: CGPointMake(206.09, 54.5)];
    [path addCurveToPoint: CGPointMake(212.02, 49.93) controlPoint1: CGPointMake(209.94, 54.5) controlPoint2: CGPointMake(211.4, 53.05)];
    [path addLineToPoint: CGPointMake(216.54, 25.8)];
    [path addLineToPoint: CGPointMake(225.9, 25.8)];
    [path addLineToPoint: CGPointMake(221.33, 49.98)];
    [path addCurveToPoint: CGPointMake(206.82, 62.88) controlPoint1: CGPointMake(219.66, 58.61) controlPoint2: CGPointMake(214.83, 62.88)];
    [path addCurveToPoint: CGPointMake(195.54, 52.11) controlPoint1: CGPointMake(199.49, 62.88) controlPoint2: CGPointMake(195.54, 58.92)];
    [path addCurveToPoint: CGPointMake(196, 47.74) controlPoint1: CGPointMake(195.54, 50.76) controlPoint2: CGPointMake(195.74, 49.3)];
    [path addLineToPoint: CGPointMake(200.16, 25.8)];
    [path closePath];
    
    // N
    [path moveToPoint: CGPointMake(229.75, 25.8)];
    [path addLineToPoint: CGPointMake(238.54, 25.8)];
    [path addLineToPoint: CGPointMake(243.84, 43.32)];
    [path addLineToPoint: CGPointMake(247.12, 25.8)];
    [path addLineToPoint: CGPointMake(255.86, 25.8)];
    [path addLineToPoint: CGPointMake(248.89, 62.25)];
    [path addLineToPoint: CGPointMake(241.35, 62.25)];
    [path addLineToPoint: CGPointMake(235.21, 42.28)];
    [path addLineToPoint: CGPointMake(231.52, 62.2)];
    [path addLineToPoint: CGPointMake(222.73, 62.2)];
    [path addLineToPoint: CGPointMake(229.75, 25.8)];
    [path closePath];
    
    // D
    [path moveToPoint: CGPointMake(267.66, 34.12)];
    [path addLineToPoint: CGPointMake(263.81, 53.88)];
    [path addLineToPoint: CGPointMake(264.49, 53.88)];
    [path addCurveToPoint: CGPointMake(273.01, 43.32) controlPoint1: CGPointMake(268.96, 53.88) controlPoint2: CGPointMake(271.72, 50.4)];
    [path addCurveToPoint: CGPointMake(273.43, 39.63) controlPoint1: CGPointMake(273.22, 42.13) controlPoint2: CGPointMake(273.43, 40.78)];
    [path addCurveToPoint: CGPointMake(268.44, 34.12) controlPoint1: CGPointMake(273.43, 36.04) controlPoint2: CGPointMake(271.82, 34.12)];
    [path addLineToPoint: CGPointMake(267.66, 34.12)];
    [path closePath];
    [path moveToPoint: CGPointMake(252.79, 62.2)];
    [path addLineToPoint: CGPointMake(259.81, 25.8)];
    [path addLineToPoint: CGPointMake(269.01, 25.8)];
    [path addCurveToPoint: CGPointMake(283.05, 39.32) controlPoint1: CGPointMake(278.68, 25.8) controlPoint2: CGPointMake(283.05, 30.9)];
    [path addCurveToPoint: CGPointMake(262.41, 62.2) controlPoint1: CGPointMake(283.05, 49.41) controlPoint2: CGPointMake(277.59, 62.2)];
    [path addLineToPoint: CGPointMake(252.79, 62.2)];
    [path closePath];
    
    // S
    [path moveToPoint: CGPointMake(307.65, 28.04)];
    [path addLineToPoint: CGPointMake(306.82, 36.93)];
    [path addLineToPoint: CGPointMake(306.66, 36.93)];
    [path addCurveToPoint: CGPointMake(298.7, 33.13) controlPoint1: CGPointMake(304.16, 34.74) controlPoint2: CGPointMake(301.2, 33.13)];
    [path addCurveToPoint: CGPointMake(296.16, 35.21) controlPoint1: CGPointMake(297.2, 33.13) controlPoint2: CGPointMake(296.16, 33.91)];
    [path addCurveToPoint: CGPointMake(299.38, 40.1) controlPoint1: CGPointMake(296.16, 36.41) controlPoint2: CGPointMake(296.99, 37.71)];
    [path addCurveToPoint: CGPointMake(305, 51.18) controlPoint1: CGPointMake(303.49, 43.95) controlPoint2: CGPointMake(305, 47.28)];
    [path addCurveToPoint: CGPointMake(292.88, 62.88) controlPoint1: CGPointMake(305, 58.35) controlPoint2: CGPointMake(300.37, 62.88)];
    [path addCurveToPoint: CGPointMake(283, 59.65) controlPoint1: CGPointMake(288.82, 62.88) controlPoint2: CGPointMake(285.18, 61.47)];
    [path addLineToPoint: CGPointMake(283.31, 49.93)];
    [path addLineToPoint: CGPointMake(283.47, 49.88)];
    [path addCurveToPoint: CGPointMake(292.46, 54.87) controlPoint1: CGPointMake(286.43, 53) controlPoint2: CGPointMake(289.86, 54.87)];
    [path addCurveToPoint: CGPointMake(295.32, 52.48) controlPoint1: CGPointMake(294.28, 54.87) controlPoint2: CGPointMake(295.32, 53.88)];
    [path addCurveToPoint: CGPointMake(292.41, 47.59) controlPoint1: CGPointMake(295.32, 51.02) controlPoint2: CGPointMake(294.44, 49.56)];
    [path addCurveToPoint: CGPointMake(286.53, 36.3) controlPoint1: CGPointMake(287.94, 43.32) controlPoint2: CGPointMake(286.53, 40.2)];
    [path addCurveToPoint: CGPointMake(298.39, 25.12) controlPoint1: CGPointMake(286.53, 29.8) controlPoint2: CGPointMake(291.16, 25.12)];
    [path addCurveToPoint: CGPointMake(307.65, 28.04) controlPoint1: CGPointMake(302.03, 25.12) controlPoint2: CGPointMake(305.36, 26.27)];
    [path closePath];

    return path;
}

static UIBezierPath *_ChoiceRowLeftTextStats()
{
    // S
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(164.75, 28.04)];
    [path addLineToPoint: CGPointMake(163.92, 36.93)];
    [path addLineToPoint: CGPointMake(163.77, 36.93)];
    [path addCurveToPoint: CGPointMake(155.81, 33.13) controlPoint1: CGPointMake(161.27, 34.74) controlPoint2: CGPointMake(158.31, 33.13)];
    [path addCurveToPoint: CGPointMake(153.26, 35.21) controlPoint1: CGPointMake(154.3, 33.13) controlPoint2: CGPointMake(153.26, 33.91)];
    [path addCurveToPoint: CGPointMake(156.48, 40.1) controlPoint1: CGPointMake(153.26, 36.41) controlPoint2: CGPointMake(154.09, 37.71)];
    [path addCurveToPoint: CGPointMake(162.1, 51.18) controlPoint1: CGPointMake(160.59, 43.95) controlPoint2: CGPointMake(162.1, 47.28)];
    [path addCurveToPoint: CGPointMake(149.98, 62.88) controlPoint1: CGPointMake(162.1, 58.35) controlPoint2: CGPointMake(157.47, 62.88)];
    [path addCurveToPoint: CGPointMake(140.1, 59.65) controlPoint1: CGPointMake(145.93, 62.88) controlPoint2: CGPointMake(142.29, 61.47)];
    [path addLineToPoint: CGPointMake(140.42, 49.93)];
    [path addLineToPoint: CGPointMake(140.57, 49.88)];
    [path addCurveToPoint: CGPointMake(149.57, 54.87) controlPoint1: CGPointMake(143.54, 53) controlPoint2: CGPointMake(146.97, 54.87)];
    [path addCurveToPoint: CGPointMake(152.43, 52.48) controlPoint1: CGPointMake(151.39, 54.87) controlPoint2: CGPointMake(152.43, 53.88)];
    [path addCurveToPoint: CGPointMake(149.52, 47.59) controlPoint1: CGPointMake(152.43, 51.02) controlPoint2: CGPointMake(151.55, 49.56)];
    [path addCurveToPoint: CGPointMake(143.64, 36.3) controlPoint1: CGPointMake(145.04, 43.32) controlPoint2: CGPointMake(143.64, 40.2)];
    [path addCurveToPoint: CGPointMake(155.5, 25.12) controlPoint1: CGPointMake(143.64, 29.8) controlPoint2: CGPointMake(148.27, 25.12)];
    [path addCurveToPoint: CGPointMake(164.75, 28.04) controlPoint1: CGPointMake(159.14, 25.12) controlPoint2: CGPointMake(162.47, 26.27)];
    [path closePath];
    
    // T
    [path moveToPoint: CGPointMake(183.68, 34.12)];
    [path addLineToPoint: CGPointMake(178.27, 62.2)];
    [path addLineToPoint: CGPointMake(168.65, 62.2)];
    [path addLineToPoint: CGPointMake(174.06, 34.12)];
    [path addLineToPoint: CGPointMake(166.42, 34.12)];
    [path addLineToPoint: CGPointMake(168.08, 25.8)];
    [path addLineToPoint: CGPointMake(192.89, 25.8)];
    [path addLineToPoint: CGPointMake(191.22, 34.12)];
    [path addLineToPoint: CGPointMake(183.68, 34.12)];
    [path closePath];
    
    // A
    [path moveToPoint: CGPointMake(204.9, 48.06)];
    [path addLineToPoint: CGPointMake(204.43, 35.52)];
    [path addLineToPoint: CGPointMake(199.23, 48.06)];
    [path addLineToPoint: CGPointMake(204.9, 48.06)];
    [path closePath];
    [path moveToPoint: CGPointMake(200.63, 25.75)];
    [path addLineToPoint: CGPointMake(212.13, 25.75)];
    [path addLineToPoint: CGPointMake(214.73, 62.2)];
    [path addLineToPoint: CGPointMake(204.85, 62.2)];
    [path addLineToPoint: CGPointMake(204.74, 55.6)];
    [path addLineToPoint: CGPointMake(196.53, 55.6)];
    [path addLineToPoint: CGPointMake(193.82, 62.2)];
    [path addLineToPoint: CGPointMake(183.94, 62.2)];
    [path addLineToPoint: CGPointMake(200.63, 25.75)];
    [path closePath];
    
    // T
    [path moveToPoint: CGPointMake(234.75, 34.12)];
    [path addLineToPoint: CGPointMake(229.34, 62.2)];
    [path addLineToPoint: CGPointMake(219.72, 62.2)];
    [path addLineToPoint: CGPointMake(225.13, 34.12)];
    [path addLineToPoint: CGPointMake(217.48, 34.12)];
    [path addLineToPoint: CGPointMake(219.14, 25.8)];
    [path addLineToPoint: CGPointMake(243.95, 25.8)];
    [path addLineToPoint: CGPointMake(242.29, 34.12)];
    [path addLineToPoint: CGPointMake(234.75, 34.12)];
    [path closePath];
    
    // S
    [path moveToPoint: CGPointMake(265.43, 28.04)];
    [path addLineToPoint: CGPointMake(264.59, 36.93)];
    [path addLineToPoint: CGPointMake(264.44, 36.93)];
    [path addCurveToPoint: CGPointMake(256.48, 33.13) controlPoint1: CGPointMake(261.94, 34.74) controlPoint2: CGPointMake(258.98, 33.13)];
    [path addCurveToPoint: CGPointMake(253.93, 35.21) controlPoint1: CGPointMake(254.97, 33.13) controlPoint2: CGPointMake(253.93, 33.91)];
    [path addCurveToPoint: CGPointMake(257.16, 40.1) controlPoint1: CGPointMake(253.93, 36.41) controlPoint2: CGPointMake(254.77, 37.71)];
    [path addCurveToPoint: CGPointMake(262.77, 51.18) controlPoint1: CGPointMake(261.27, 43.95) controlPoint2: CGPointMake(262.77, 47.28)];
    [path addCurveToPoint: CGPointMake(250.66, 62.88) controlPoint1: CGPointMake(262.77, 58.35) controlPoint2: CGPointMake(258.15, 62.88)];
    [path addCurveToPoint: CGPointMake(240.78, 59.65) controlPoint1: CGPointMake(246.6, 62.88) controlPoint2: CGPointMake(242.96, 61.47)];
    [path addLineToPoint: CGPointMake(241.09, 49.93)];
    [path addLineToPoint: CGPointMake(241.24, 49.88)];
    [path addCurveToPoint: CGPointMake(250.24, 54.87) controlPoint1: CGPointMake(244.21, 53) controlPoint2: CGPointMake(247.64, 54.87)];
    [path addCurveToPoint: CGPointMake(253.1, 52.48) controlPoint1: CGPointMake(252.06, 54.87) controlPoint2: CGPointMake(253.1, 53.88)];
    [path addCurveToPoint: CGPointMake(250.19, 47.59) controlPoint1: CGPointMake(253.1, 51.02) controlPoint2: CGPointMake(252.22, 49.56)];
    [path addCurveToPoint: CGPointMake(244.31, 36.3) controlPoint1: CGPointMake(245.72, 43.32) controlPoint2: CGPointMake(244.31, 40.2)];
    [path addCurveToPoint: CGPointMake(256.17, 25.12) controlPoint1: CGPointMake(244.31, 29.8) controlPoint2: CGPointMake(248.94, 25.12)];
    [path addCurveToPoint: CGPointMake(265.43, 28.04) controlPoint1: CGPointMake(259.81, 25.12) controlPoint2: CGPointMake(263.14, 26.27)];
    [path closePath];

    return path;
}

static UIBezierPath *_ChoiceRowLeftTextGameCodes()
{
    // G
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(154.3, 62.82)];
    [path addCurveToPoint: CGPointMake(141.56, 48.84) controlPoint1: CGPointMake(146.34, 62.82) controlPoint2: CGPointMake(141.56, 57.94)];
    [path addCurveToPoint: CGPointMake(160.49, 25.23) controlPoint1: CGPointMake(141.56, 36.04) controlPoint2: CGPointMake(148.69, 25.23)];
    [path addCurveToPoint: CGPointMake(170.11, 27.88) controlPoint1: CGPointMake(164.44, 25.23) controlPoint2: CGPointMake(167.87, 26.32)];
    [path addLineToPoint: CGPointMake(168.29, 36.82)];
    [path addLineToPoint: CGPointMake(168.13, 36.82)];
    [path addCurveToPoint: CGPointMake(160.65, 33.81) controlPoint1: CGPointMake(165.69, 34.85) controlPoint2: CGPointMake(163.35, 33.81)];
    [path addCurveToPoint: CGPointMake(151.55, 44.57) controlPoint1: CGPointMake(156.12, 33.81) controlPoint2: CGPointMake(152.79, 37.92)];
    [path addCurveToPoint: CGPointMake(151.08, 49.15) controlPoint1: CGPointMake(151.28, 45.98) controlPoint2: CGPointMake(151.08, 47.33)];
    [path addCurveToPoint: CGPointMake(155.71, 54.82) controlPoint1: CGPointMake(151.08, 52.89) controlPoint2: CGPointMake(152.69, 54.82)];
    [path addCurveToPoint: CGPointMake(157.16, 54.76) controlPoint1: CGPointMake(156.23, 54.82) controlPoint2: CGPointMake(156.69, 54.82)];
    [path addLineToPoint: CGPointMake(158.62, 48)];
    [path addLineToPoint: CGPointMake(154.93, 48)];
    [path addLineToPoint: CGPointMake(156.23, 41.5)];
    [path addLineToPoint: CGPointMake(168.24, 41.5)];
    [path addLineToPoint: CGPointMake(164.39, 60.28)];
    [path addCurveToPoint: CGPointMake(154.3, 62.82) controlPoint1: CGPointMake(161.37, 61.84) controlPoint2: CGPointMake(157.84, 62.82)];
    [path closePath];
    
    // A
    [path moveToPoint: CGPointMake(187.16, 48.06)];
    [path addLineToPoint: CGPointMake(186.7, 35.52)];
    [path addLineToPoint: CGPointMake(181.5, 48.06)];
    [path addLineToPoint: CGPointMake(187.16, 48.06)];
    [path closePath];
    [path moveToPoint: CGPointMake(182.9, 25.75)];
    [path addLineToPoint: CGPointMake(194.39, 25.75)];
    [path addLineToPoint: CGPointMake(196.99, 62.2)];
    [path addLineToPoint: CGPointMake(187.11, 62.2)];
    [path addLineToPoint: CGPointMake(187.01, 55.6)];
    [path addLineToPoint: CGPointMake(178.79, 55.6)];
    [path addLineToPoint: CGPointMake(176.09, 62.2)];
    [path addLineToPoint: CGPointMake(166.21, 62.2)];
    [path addLineToPoint: CGPointMake(182.9, 25.75)];
    [path closePath];
    
    // M
    [path moveToPoint: CGPointMake(220.18, 43.38)];
    [path addLineToPoint: CGPointMake(228.04, 25.8)];
    [path addLineToPoint: CGPointMake(240.93, 25.8)];
    [path addLineToPoint: CGPointMake(234.8, 62.2)];
    [path addLineToPoint: CGPointMake(225.64, 62.2)];
    [path addLineToPoint: CGPointMake(229.86, 37.86)];
    [path addLineToPoint: CGPointMake(217.95, 62.36)];
    [path addLineToPoint: CGPointMake(215.09, 62.36)];
    [path addLineToPoint: CGPointMake(212.64, 37.92)];
    [path addLineToPoint: CGPointMake(207.55, 62.2)];
    [path addLineToPoint: CGPointMake(198.76, 62.2)];
    [path addLineToPoint: CGPointMake(206.56, 25.8)];
    [path addLineToPoint: CGPointMake(219.09, 25.8)];
    [path addLineToPoint: CGPointMake(220.18, 43.38)];
    [path closePath];
    
    // E
    [path moveToPoint: CGPointMake(245.35, 25.8)];
    [path addLineToPoint: CGPointMake(265.22, 25.8)];
    [path addLineToPoint: CGPointMake(263.66, 33.91)];
    [path addLineToPoint: CGPointMake(253.2, 33.91)];
    [path addLineToPoint: CGPointMake(252.01, 40.05)];
    [path addLineToPoint: CGPointMake(260.95, 40.05)];
    [path addLineToPoint: CGPointMake(259.44, 47.64)];
    [path addLineToPoint: CGPointMake(250.55, 47.64)];
    [path addLineToPoint: CGPointMake(249.3, 54.09)];
    [path addLineToPoint: CGPointMake(260.38, 54.09)];
    [path addLineToPoint: CGPointMake(257.88, 62.2)];
    [path addLineToPoint: CGPointMake(238.33, 62.2)];
    [path addLineToPoint: CGPointMake(245.35, 25.8)];
    [path closePath];
    
    // C
    [path moveToPoint: CGPointMake(282.95, 60.54)];
    [path addCurveToPoint: CGPointMake(275.15, 62.77) controlPoint1: CGPointMake(280.76, 61.89) controlPoint2: CGPointMake(278.48, 62.77)];
    [path addCurveToPoint: CGPointMake(263.65, 48.73) controlPoint1: CGPointMake(267.66, 62.77) controlPoint2: CGPointMake(263.65, 57.31)];
    [path addCurveToPoint: CGPointMake(280.87, 25.23) controlPoint1: CGPointMake(263.65, 37.71) controlPoint2: CGPointMake(269.38, 25.23)];
    [path addCurveToPoint: CGPointMake(289.24, 28.3) controlPoint1: CGPointMake(284.46, 25.23) controlPoint2: CGPointMake(287.26, 26.42)];
    [path addLineToPoint: CGPointMake(287.47, 37.45)];
    [path addLineToPoint: CGPointMake(287.37, 37.5)];
    [path addCurveToPoint: CGPointMake(281.34, 34.02) controlPoint1: CGPointMake(285.65, 35.37) controlPoint2: CGPointMake(283.88, 34.02)];
    [path addCurveToPoint: CGPointMake(273.8, 43.58) controlPoint1: CGPointMake(277.75, 34.02) controlPoint2: CGPointMake(274.78, 38.44)];
    [path addCurveToPoint: CGPointMake(273.38, 47.38) controlPoint1: CGPointMake(273.59, 44.83) controlPoint2: CGPointMake(273.38, 46.13)];
    [path addCurveToPoint: CGPointMake(278.32, 53.98) controlPoint1: CGPointMake(273.38, 51.75) controlPoint2: CGPointMake(275.25, 53.98)];
    [path addCurveToPoint: CGPointMake(285.18, 50.76) controlPoint1: CGPointMake(280.61, 53.98) controlPoint2: CGPointMake(282.79, 52.74)];
    [path addLineToPoint: CGPointMake(285.34, 50.86)];
    [path addLineToPoint: CGPointMake(282.95, 60.54)];
    [path closePath];
        
    // O
    [path moveToPoint: CGPointMake(307.34, 44.26)];
    [path addCurveToPoint: CGPointMake(308.06, 38.23) controlPoint1: CGPointMake(307.91, 41.09) controlPoint2: CGPointMake(308.06, 39.37)];
    [path addCurveToPoint: CGPointMake(304.79, 33.44) controlPoint1: CGPointMake(308.06, 35) controlPoint2: CGPointMake(306.71, 33.44)];
    [path addCurveToPoint: CGPointMake(298.6, 43.74) controlPoint1: CGPointMake(302.19, 33.44) controlPoint2: CGPointMake(299.9, 36.88)];
    [path addCurveToPoint: CGPointMake(297.87, 49.77) controlPoint1: CGPointMake(298.03, 46.91) controlPoint2: CGPointMake(297.87, 48.68)];
    [path addCurveToPoint: CGPointMake(301.15, 54.56) controlPoint1: CGPointMake(297.87, 53) controlPoint2: CGPointMake(299.22, 54.56)];
    [path addCurveToPoint: CGPointMake(307.34, 44.26) controlPoint1: CGPointMake(303.75, 54.56) controlPoint2: CGPointMake(306.04, 51.12)];
    [path closePath];
    [path moveToPoint: CGPointMake(288.51, 49.25)];
    [path addCurveToPoint: CGPointMake(305.2, 25.07) controlPoint1: CGPointMake(288.51, 35.42) controlPoint2: CGPointMake(295.38, 25.07)];
    [path addCurveToPoint: CGPointMake(317.42, 38.75) controlPoint1: CGPointMake(313.11, 25.07) controlPoint2: CGPointMake(317.42, 30.64)];
    [path addCurveToPoint: CGPointMake(300.73, 62.93) controlPoint1: CGPointMake(317.42, 52.58) controlPoint2: CGPointMake(310.51, 62.93)];
    [path addCurveToPoint: CGPointMake(288.51, 49.25) controlPoint1: CGPointMake(292.83, 62.93) controlPoint2: CGPointMake(288.51, 57.36)];
    [path closePath];
    
    // D
    [path moveToPoint: CGPointMake(331.51, 34.12)];
    [path addLineToPoint: CGPointMake(327.67, 53.88)];
    [path addLineToPoint: CGPointMake(328.34, 53.88)];
    [path addCurveToPoint: CGPointMake(336.87, 43.32) controlPoint1: CGPointMake(332.82, 53.88) controlPoint2: CGPointMake(335.57, 50.4)];
    [path addCurveToPoint: CGPointMake(337.29, 39.63) controlPoint1: CGPointMake(337.08, 42.13) controlPoint2: CGPointMake(337.29, 40.78)];
    [path addCurveToPoint: CGPointMake(332.29, 34.12) controlPoint1: CGPointMake(337.29, 36.04) controlPoint2: CGPointMake(335.67, 34.12)];
    [path addLineToPoint: CGPointMake(331.51, 34.12)];
    [path closePath];
    [path moveToPoint: CGPointMake(316.64, 62.2)];
    [path addLineToPoint: CGPointMake(323.66, 25.8)];
    [path addLineToPoint: CGPointMake(332.87, 25.8)];
    [path addCurveToPoint: CGPointMake(346.91, 39.32) controlPoint1: CGPointMake(342.54, 25.8) controlPoint2: CGPointMake(346.91, 30.9)];
    [path addCurveToPoint: CGPointMake(326.26, 62.2) controlPoint1: CGPointMake(346.91, 49.41) controlPoint2: CGPointMake(341.45, 62.2)];
    [path addLineToPoint: CGPointMake(316.64, 62.2)];
    [path closePath];
    
    // E
    [path moveToPoint: CGPointMake(353.09, 25.8)];
    [path addLineToPoint: CGPointMake(372.96, 25.8)];
    [path addLineToPoint: CGPointMake(371.4, 33.91)];
    [path addLineToPoint: CGPointMake(360.95, 33.91)];
    [path addLineToPoint: CGPointMake(359.75, 40.05)];
    [path addLineToPoint: CGPointMake(368.7, 40.05)];
    [path addLineToPoint: CGPointMake(367.19, 47.64)];
    [path addLineToPoint: CGPointMake(358.3, 47.64)];
    [path addLineToPoint: CGPointMake(357.05, 54.09)];
    [path addLineToPoint: CGPointMake(368.12, 54.09)];
    [path addLineToPoint: CGPointMake(365.63, 62.2)];
    [path addLineToPoint: CGPointMake(346.07, 62.2)];
    [path addLineToPoint: CGPointMake(353.09, 25.8)];
    [path closePath];
    
    // S
    [path moveToPoint: CGPointMake(394.95, 28.04)];
    [path addLineToPoint: CGPointMake(394.12, 36.93)];
    [path addLineToPoint: CGPointMake(393.97, 36.93)];
    [path addCurveToPoint: CGPointMake(386.01, 33.13) controlPoint1: CGPointMake(391.47, 34.74) controlPoint2: CGPointMake(388.51, 33.13)];
    [path addCurveToPoint: CGPointMake(383.46, 35.21) controlPoint1: CGPointMake(384.5, 33.13) controlPoint2: CGPointMake(383.46, 33.91)];
    [path addCurveToPoint: CGPointMake(386.69, 40.1) controlPoint1: CGPointMake(383.46, 36.41) controlPoint2: CGPointMake(384.29, 37.71)];
    [path addCurveToPoint: CGPointMake(392.3, 51.18) controlPoint1: CGPointMake(390.79, 43.95) controlPoint2: CGPointMake(392.3, 47.28)];
    [path addCurveToPoint: CGPointMake(380.19, 62.88) controlPoint1: CGPointMake(392.3, 58.35) controlPoint2: CGPointMake(387.67, 62.88)];
    [path addCurveToPoint: CGPointMake(370.31, 59.65) controlPoint1: CGPointMake(376.13, 62.88) controlPoint2: CGPointMake(372.49, 61.47)];
    [path addLineToPoint: CGPointMake(370.62, 49.93)];
    [path addLineToPoint: CGPointMake(370.77, 49.88)];
    [path addCurveToPoint: CGPointMake(379.77, 54.87) controlPoint1: CGPointMake(373.74, 53) controlPoint2: CGPointMake(377.17, 54.87)];
    [path addCurveToPoint: CGPointMake(382.63, 52.48) controlPoint1: CGPointMake(381.59, 54.87) controlPoint2: CGPointMake(382.63, 53.88)];
    [path addCurveToPoint: CGPointMake(379.72, 47.59) controlPoint1: CGPointMake(382.63, 51.02) controlPoint2: CGPointMake(381.75, 49.56)];
    [path addCurveToPoint: CGPointMake(373.84, 36.3) controlPoint1: CGPointMake(375.25, 43.32) controlPoint2: CGPointMake(373.84, 40.2)];
    [path addCurveToPoint: CGPointMake(385.7, 25.12) controlPoint1: CGPointMake(373.84, 29.8) controlPoint2: CGPointMake(378.47, 25.12)];
    [path addCurveToPoint: CGPointMake(394.95, 28.04) controlPoint1: CGPointMake(389.34, 25.12) controlPoint2: CGPointMake(392.67, 26.27)];
    [path closePath];

    return path;
}

@implementation UPControl (UPSpell)

+ (UPControl *)roundGameButton
{
    UPControl *control = [UPControl control];
    control.canonicalSize = SpellLayout::CanonicalRoundGameButtonSize;
    [control setFillPath:_RoundGameButtonFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setStrokePath:_RoundGameButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    return control;
}

+ (UPControl *)roundBackButton
{
    UPControl *control = [UPControl control];
    control.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    [control setFillPath:_RoundBackButtonFillPath() forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setStrokePath:_RoundBackButtonStrokePath() forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    return control;
}

+ (UPControl *)roundGameButtonMinusSign
{
    UPControl *control = [UPControl roundGameButton];
    [control setContentPath:_RoundGameButtonMinusSignIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundGameButtonTrash
{
    UPControl *control = [UPControl roundGameButton];
    [control setContentPath:_RoundGameButtonTrashIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundGameButtonDownArrow
{
    UPControl *control = [UPControl roundGameButton];
    [control setContentPath:_RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundBackButtonLeftArrow
{
    UPControl *control = [UPControl roundBackButton];
    [control setContentPath:_RoundBackButtonLeftArrowIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)roundBackButtonRightArrow
{
    UPControl *control = [UPControl roundBackButton];
    [control setContentPath:_RoundBackButtonRightArrowIconPath() forState:UPControlStateNormal];
    return control;
}

+ (UPControl *)wordTray
{
    UPControl *control = [UPControl control];
    control.canonicalSize = SpellLayout::CanonicalWordTrayFrame.size;
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
    control.canonicalSize = SpellLayout::CanonicalTextButtonSize;
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

+ (UPControl *)choiceTitleRow
{
    UPControl *control = [UPControl control];
    control.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    [control setAccentColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill]];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateNormal];
    [control setFillColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] forState:UPControlStateHighlighted];
    [control setFillPath:_ChoiceTitleLeftFillPath()];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryStroke] forState:UPControlStateNormal];
    [control setStrokeColor:[UIColor themeColorWithCategory:UPColorCategoryHighlightedStroke] forState:UPControlStateHighlighted];
    [control setStrokePath:_ChoiceTitleLeftStrokePath()];
    return control;
}

+ (UPControl *)choiceItemRow
{
    UPControl *control = [UPControl control];
    control.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    [control setAccentColor:[UIColor clearColor] forState:UPControlStateNormal];
    [control setAccentColor:[UIColor themeColorWithCategory:UPColorCategoryActiveFill] forState:UPControlStateSelected];
    [control setAccentPath:[UIBezierPath bezierPathWithRect:up_rect_make(control.canonicalSize)] forState:UPControlStateSelected];
    [control setAuxiliaryColor:[UIColor themeColorWithCategory:UPColorCategoryPrimaryFill] forState:UPControlStateSelected];
    [control setAuxiliaryPath:_ChoiceRowLeftFillPathSelected() forState:UPControlStateSelected];
    control.autoSelects = YES;
    control.autoHighlights = NO;
    return control;
}

+ (UPControl *)choiceTitleRowLeftExtras
{
    UPControl *control = [UPControl choiceTitleRow];
    [control setContentPath:_ChoiceRowLeftArrowPath()];
    [control setAuxiliaryPath:_ChoiceRowLeftTextExtras()];
    return control;
}

+ (UPControl *)choiceItemRowLeftColors
{
    UPControl *control = [UPControl choiceItemRow];
    [control setFillPath:_ChoiceRowLeftTextColors()];
    return control;
}

+ (UPControl *)choiceItemRowLeftSounds
{
    UPControl *control = [UPControl choiceItemRow];
    [control setFillPath:_ChoiceRowLeftTextSounds()];
    return control;
}

+ (UPControl *)choiceItemRowLeftStats
{
    UPControl *control = [UPControl choiceItemRow];
    [control setFillPath:_ChoiceRowLeftTextStats()];
    return control;
}

+ (UPControl *)choiceItemRowLeftGameCodes
{
    UPControl *control = [UPControl choiceItemRow];
    [control setFillPath:_ChoiceRowLeftTextGameCodes()];
    return control;
}

@end
