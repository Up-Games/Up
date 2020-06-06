//
//  UPTextPaths.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPTextPaths.h"

#if __cplusplus

namespace UP {

UIBezierPath *TextPathContentAbout()
{
    // A
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50.41, 40.27)];
    [path addLineToPoint:CGPointMake(50.03, 30.15)];
    [path addLineToPoint:CGPointMake(45.83, 40.27)];
    [path addLineToPoint:CGPointMake(50.41, 40.27)];
    [path closePath];
    [path moveToPoint:CGPointMake(46.96, 22.25)];
    [path addLineToPoint:CGPointMake(56.25, 22.25)];
    [path addLineToPoint:CGPointMake(58.35, 51.7)];
    [path addLineToPoint:CGPointMake(50.37, 51.7)];
    [path addLineToPoint:CGPointMake(50.28, 46.37)];
    [path addLineToPoint:CGPointMake(43.64, 46.37)];
    [path addLineToPoint:CGPointMake(41.46, 51.7)];
    [path addLineToPoint:CGPointMake(33.48, 51.7)];
    [path addLineToPoint:CGPointMake(46.96, 22.25)];
    [path closePath];

    // B
    [path moveToPoint:CGPointMake(71.95, 27.97)];
    [path addLineToPoint:CGPointMake(70.73, 34.35)];
    [path addLineToPoint:CGPointMake(71.95, 34.35)];
    [path addCurveToPoint:CGPointMake(75.77, 30.4) controlPoint1:CGPointMake(74.26, 34.35) controlPoint2:CGPointMake(75.77, 32.5)];
    [path addCurveToPoint:CGPointMake(73.21, 27.97) controlPoint1:CGPointMake(75.77, 28.85) controlPoint2:CGPointMake(74.85, 27.97)];
    [path addLineToPoint:CGPointMake(71.95, 27.97)];
    [path closePath];
    [path moveToPoint:CGPointMake(69.81, 39.35)];
    [path addLineToPoint:CGPointMake(68.51, 46.11)];
    [path addLineToPoint:CGPointMake(69.77, 46.11)];
    [path addCurveToPoint:CGPointMake(73.76, 41.83) controlPoint1:CGPointMake(72.12, 46.11) controlPoint2:CGPointMake(73.76, 44.31)];
    [path addCurveToPoint:CGPointMake(70.98, 39.35) controlPoint1:CGPointMake(73.76, 40.19) controlPoint2:CGPointMake(72.75, 39.35)];
    [path addLineToPoint:CGPointMake(69.81, 39.35)];
    [path closePath];
    [path moveToPoint:CGPointMake(69.43, 51.7)];
    [path addLineToPoint:CGPointMake(60.06, 51.7)];
    [path addLineToPoint:CGPointMake(65.73, 22.29)];
    [path addLineToPoint:CGPointMake(74.22, 22.29)];
    [path addCurveToPoint:CGPointMake(83.08, 29.14) controlPoint1:CGPointMake(80.27, 22.29) controlPoint2:CGPointMake(83.08, 25.03)];
    [path addCurveToPoint:CGPointMake(77.92, 36.66) controlPoint1:CGPointMake(83.08, 32.38) controlPoint2:CGPointMake(81.32, 35.19)];
    [path addCurveToPoint:CGPointMake(81.23, 42.42) controlPoint1:CGPointMake(80.1, 37.84) controlPoint2:CGPointMake(81.23, 39.85)];
    [path addCurveToPoint:CGPointMake(69.43, 51.7) controlPoint1:CGPointMake(81.23, 48.05) controlPoint2:CGPointMake(76.82, 51.7)];
    [path closePath];

    // O
    [path moveToPoint:CGPointMake(98.87, 37.21)];
    [path addCurveToPoint:CGPointMake(99.46, 32.33) controlPoint1:CGPointMake(99.34, 34.64) controlPoint2:CGPointMake(99.46, 33.26)];
    [path addCurveToPoint:CGPointMake(96.81, 28.47) controlPoint1:CGPointMake(99.46, 29.73) controlPoint2:CGPointMake(98.37, 28.47)];
    [path addCurveToPoint:CGPointMake(91.82, 36.79) controlPoint1:CGPointMake(94.72, 28.47) controlPoint2:CGPointMake(92.87, 31.24)];
    [path addCurveToPoint:CGPointMake(91.23, 41.66) controlPoint1:CGPointMake(91.35, 39.35) controlPoint2:CGPointMake(91.23, 40.78)];
    [path addCurveToPoint:CGPointMake(93.87, 45.52) controlPoint1:CGPointMake(91.23, 44.26) controlPoint2:CGPointMake(92.32, 45.52)];
    [path addCurveToPoint:CGPointMake(98.87, 37.21) controlPoint1:CGPointMake(95.98, 45.52) controlPoint2:CGPointMake(97.82, 42.75)];
    [path closePath];
    [path moveToPoint:CGPointMake(83.67, 41.24)];
    [path addCurveToPoint:CGPointMake(97.15, 21.71) controlPoint1:CGPointMake(83.67, 30.07) controlPoint2:CGPointMake(89.21, 21.71)];
    [path addCurveToPoint:CGPointMake(107.02, 32.75) controlPoint1:CGPointMake(103.54, 21.71) controlPoint2:CGPointMake(107.02, 26.2)];
    [path addCurveToPoint:CGPointMake(93.54, 52.29) controlPoint1:CGPointMake(107.02, 43.93) controlPoint2:CGPointMake(101.44, 52.29)];
    [path addCurveToPoint:CGPointMake(83.67, 41.24) controlPoint1:CGPointMake(87.15, 52.29) controlPoint2:CGPointMake(83.67, 47.79)];
    [path closePath];

    // U
    [path moveToPoint:CGPointMake(111.93, 22.3)];
    [path addLineToPoint:CGPointMake(119.66, 22.3)];
    [path addLineToPoint:CGPointMake(116.09, 41.32)];
    [path addCurveToPoint:CGPointMake(115.92, 43.05) controlPoint1:CGPointMake(115.97, 41.96) controlPoint2:CGPointMake(115.92, 42.5)];
    [path addCurveToPoint:CGPointMake(118.19, 45.48) controlPoint1:CGPointMake(115.92, 44.64) controlPoint2:CGPointMake(116.72, 45.48)];
    [path addCurveToPoint:CGPointMake(121.51, 41.79) controlPoint1:CGPointMake(119.83, 45.48) controlPoint2:CGPointMake(121.01, 44.31)];
    [path addLineToPoint:CGPointMake(125.17, 22.3)];
    [path addLineToPoint:CGPointMake(132.73, 22.3)];
    [path addLineToPoint:CGPointMake(129.03, 41.83)];
    [path addCurveToPoint:CGPointMake(117.31, 52.25) controlPoint1:CGPointMake(127.69, 48.8) controlPoint2:CGPointMake(123.78, 52.25)];
    [path addCurveToPoint:CGPointMake(108.19, 43.55) controlPoint1:CGPointMake(111.39, 52.25) controlPoint2:CGPointMake(108.19, 49.05)];
    [path addCurveToPoint:CGPointMake(108.57, 40.02) controlPoint1:CGPointMake(108.19, 42.46) controlPoint2:CGPointMake(108.36, 41.28)];
    [path addLineToPoint:CGPointMake(111.93, 22.3)];
    [path closePath];

    // T
    [path moveToPoint:CGPointMake(147.51, 29.02)];
    [path addLineToPoint:CGPointMake(143.14, 51.7)];
    [path addLineToPoint:CGPointMake(135.37, 51.7)];
    [path addLineToPoint:CGPointMake(139.74, 29.02)];
    [path addLineToPoint:CGPointMake(133.56, 29.02)];
    [path addLineToPoint:CGPointMake(134.91, 22.3)];
    [path addLineToPoint:CGPointMake(154.95, 22.3)];
    [path addLineToPoint:CGPointMake(153.6, 29.02)];
    [path addLineToPoint:CGPointMake(147.51, 29.02)];
    [path closePath];
    
    return path;
}

UIBezierPath *TextPathContentExtras()
{
    // E
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(33.56, 22.3)];
    [path addLineToPoint:CGPointMake(49.61, 22.3)];
    [path addLineToPoint:CGPointMake(48.35, 28.85)];
    [path addLineToPoint:CGPointMake(39.91, 28.85)];
    [path addLineToPoint:CGPointMake(38.94, 33.8)];
    [path addLineToPoint:CGPointMake(46.17, 33.8)];
    [path addLineToPoint:CGPointMake(44.95, 39.94)];
    [path addLineToPoint:CGPointMake(37.76, 39.94)];
    [path addLineToPoint:CGPointMake(36.76, 45.15)];
    [path addLineToPoint:CGPointMake(45.7, 45.15)];
    [path addLineToPoint:CGPointMake(43.69, 51.7)];
    [path addLineToPoint:CGPointMake(27.89, 51.7)];
    [path addLineToPoint:CGPointMake(33.56, 22.3)];
    [path closePath];

    // X
    [path moveToPoint:CGPointMake(58.89, 42.46)];
    [path addLineToPoint:CGPointMake(53.76, 51.7)];
    [path addLineToPoint:CGPointMake(45.45, 51.7)];
    [path addLineToPoint:CGPointMake(45.45, 51.57)];
    [path addLineToPoint:CGPointMake(55.07, 36.45)];
    [path addLineToPoint:CGPointMake(51.33, 22.29)];
    [path addLineToPoint:CGPointMake(59.56, 22.29)];
    [path addLineToPoint:CGPointMake(61.2, 30.91)];
    [path addLineToPoint:CGPointMake(65.91, 22.29)];
    [path addLineToPoint:CGPointMake(74.18, 22.29)];
    [path addLineToPoint:CGPointMake(74.18, 22.38)];
    [path addLineToPoint:CGPointMake(64.98, 37)];
    [path addLineToPoint:CGPointMake(68.89, 51.7)];
    [path addLineToPoint:CGPointMake(60.65, 51.7)];
    [path addLineToPoint:CGPointMake(58.89, 42.46)];
    [path closePath];

    // T
    [path moveToPoint:CGPointMake(87.95, 29.02)];
    [path addLineToPoint:CGPointMake(83.59, 51.7)];
    [path addLineToPoint:CGPointMake(75.81, 51.7)];
    [path addLineToPoint:CGPointMake(80.18, 29.02)];
    [path addLineToPoint:CGPointMake(74.01, 29.02)];
    [path addLineToPoint:CGPointMake(75.35, 22.3)];
    [path addLineToPoint:CGPointMake(95.39, 22.3)];
    [path addLineToPoint:CGPointMake(94.05, 29.02)];
    [path addLineToPoint:CGPointMake(87.95, 29.02)];
    [path closePath];

    // R
    [path moveToPoint:CGPointMake(104.12, 28.22)];
    [path addLineToPoint:CGPointMake(102.57, 36.24)];
    [path addLineToPoint:CGPointMake(103.37, 36.24)];
    [path addCurveToPoint:CGPointMake(107.61, 31.03) controlPoint1:CGPointMake(106.06, 36.24) controlPoint2:CGPointMake(107.61, 33.76)];
    [path addCurveToPoint:CGPointMake(104.84, 28.22) controlPoint1:CGPointMake(107.61, 29.18) controlPoint2:CGPointMake(106.77, 28.22)];
    [path addLineToPoint:CGPointMake(104.12, 28.22)];
    [path closePath];
    [path moveToPoint:CGPointMake(102.15, 41.11)];
    [path addLineToPoint:CGPointMake(101.69, 41.11)];
    [path addLineToPoint:CGPointMake(99.67, 51.7)];
    [path addLineToPoint:CGPointMake(91.94, 51.7)];
    [path addLineToPoint:CGPointMake(97.61, 22.3)];
    [path addLineToPoint:CGPointMake(105.76, 22.3)];
    [path addCurveToPoint:CGPointMake(115.3, 30.4) controlPoint1:CGPointMake(112.02, 22.3) controlPoint2:CGPointMake(115.3, 25.24)];
    [path addCurveToPoint:CGPointMake(109.37, 39.73) controlPoint1:CGPointMake(115.3, 34.77) controlPoint2:CGPointMake(112.78, 38.01)];
    [path addLineToPoint:CGPointMake(113.28, 51.7)];
    [path addLineToPoint:CGPointMake(105.17, 51.7)];
    [path addLineToPoint:CGPointMake(102.15, 41.11)];
    [path closePath];

    // A
    [path moveToPoint:CGPointMake(129.74, 40.27)];
    [path addLineToPoint:CGPointMake(129.36, 30.15)];
    [path addLineToPoint:CGPointMake(125.16, 40.27)];
    [path addLineToPoint:CGPointMake(129.74, 40.27)];
    [path closePath];
    [path moveToPoint:CGPointMake(126.3, 22.25)];
    [path addLineToPoint:CGPointMake(135.58, 22.25)];
    [path addLineToPoint:CGPointMake(137.68, 51.7)];
    [path addLineToPoint:CGPointMake(129.7, 51.7)];
    [path addLineToPoint:CGPointMake(129.62, 46.37)];
    [path addLineToPoint:CGPointMake(122.98, 46.37)];
    [path addLineToPoint:CGPointMake(120.8, 51.7)];
    [path addLineToPoint:CGPointMake(112.81, 51.7)];
    [path addLineToPoint:CGPointMake(126.3, 22.25)];
    [path closePath];

    // S
    [path moveToPoint:CGPointMake(159.56, 24.1)];
    [path addLineToPoint:CGPointMake(158.89, 31.29)];
    [path addLineToPoint:CGPointMake(158.77, 31.29)];
    [path addCurveToPoint:CGPointMake(152.34, 28.22) controlPoint1:CGPointMake(156.75, 29.52) controlPoint2:CGPointMake(154.36, 28.22)];
    [path addCurveToPoint:CGPointMake(150.28, 29.9) controlPoint1:CGPointMake(151.12, 28.22) controlPoint2:CGPointMake(150.28, 28.85)];
    [path addCurveToPoint:CGPointMake(152.89, 33.85) controlPoint1:CGPointMake(150.28, 30.86) controlPoint2:CGPointMake(150.95, 31.91)];
    [path addCurveToPoint:CGPointMake(157.42, 42.79) controlPoint1:CGPointMake(156.2, 36.96) controlPoint2:CGPointMake(157.42, 39.64)];
    [path addCurveToPoint:CGPointMake(147.63, 52.25) controlPoint1:CGPointMake(157.42, 48.59) controlPoint2:CGPointMake(153.68, 52.25)];
    [path addCurveToPoint:CGPointMake(139.65, 49.64) controlPoint1:CGPointMake(144.36, 52.25) controlPoint2:CGPointMake(141.42, 51.11)];
    [path addLineToPoint:CGPointMake(139.91, 41.79)];
    [path addLineToPoint:CGPointMake(140.03, 41.75)];
    [path addCurveToPoint:CGPointMake(147.3, 45.78) controlPoint1:CGPointMake(142.43, 44.27) controlPoint2:CGPointMake(145.2, 45.78)];
    [path addCurveToPoint:CGPointMake(149.61, 43.85) controlPoint1:CGPointMake(148.77, 45.78) controlPoint2:CGPointMake(149.61, 44.98)];
    [path addCurveToPoint:CGPointMake(147.26, 39.9) controlPoint1:CGPointMake(149.61, 42.67) controlPoint2:CGPointMake(148.89, 41.49)];
    [path addCurveToPoint:CGPointMake(142.51, 30.78) controlPoint1:CGPointMake(143.64, 36.45) controlPoint2:CGPointMake(142.51, 33.93)];
    [path addCurveToPoint:CGPointMake(152.09, 21.75) controlPoint1:CGPointMake(142.51, 25.53) controlPoint2:CGPointMake(146.25, 21.75)];
    [path addCurveToPoint:CGPointMake(159.56, 24.1) controlPoint1:CGPointMake(155.03, 21.75) controlPoint2:CGPointMake(157.72, 22.67)];
    [path closePath];

    return path;
}

UIBezierPath *TextPathContentMenu()
{
    // M
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(60.66, 36.49)];
    [path addLineToPoint:CGPointMake(67, 22.29)];
    [path addLineToPoint:CGPointMake(77.42, 22.29)];
    [path addLineToPoint:CGPointMake(72.46, 51.7)];
    [path addLineToPoint:CGPointMake(65.07, 51.7)];
    [path addLineToPoint:CGPointMake(68.47, 32.04)];
    [path addLineToPoint:CGPointMake(58.85, 51.83)];
    [path addLineToPoint:CGPointMake(56.54, 51.83)];
    [path addLineToPoint:CGPointMake(54.56, 32.08)];
    [path addLineToPoint:CGPointMake(50.45, 51.7)];
    [path addLineToPoint:CGPointMake(43.35, 51.7)];
    [path addLineToPoint:CGPointMake(49.65, 22.29)];
    [path addLineToPoint:CGPointMake(59.77, 22.29)];
    [path addLineToPoint:CGPointMake(60.66, 36.49)];
    [path closePath];

    // E
    [path moveToPoint:CGPointMake(80.98, 22.3)];
    [path addLineToPoint:CGPointMake(97.03, 22.3)];
    [path addLineToPoint:CGPointMake(95.77, 28.85)];
    [path addLineToPoint:CGPointMake(87.32, 28.85)];
    [path addLineToPoint:CGPointMake(86.36, 33.8)];
    [path addLineToPoint:CGPointMake(93.58, 33.8)];
    [path addLineToPoint:CGPointMake(92.37, 39.94)];
    [path addLineToPoint:CGPointMake(85.18, 39.94)];
    [path addLineToPoint:CGPointMake(84.17, 45.15)];
    [path addLineToPoint:CGPointMake(93.12, 45.15)];
    [path addLineToPoint:CGPointMake(91.11, 51.7)];
    [path addLineToPoint:CGPointMake(75.31, 51.7)];
    [path addLineToPoint:CGPointMake(80.98, 22.3)];
    [path closePath];

    // N
    [path moveToPoint:CGPointMake(99.92, 22.3)];
    [path addLineToPoint:CGPointMake(107.02, 22.3)];
    [path addLineToPoint:CGPointMake(111.31, 36.45)];
    [path addLineToPoint:CGPointMake(113.95, 22.3)];
    [path addLineToPoint:CGPointMake(121.01, 22.3)];
    [path addLineToPoint:CGPointMake(115.38, 51.74)];
    [path addLineToPoint:CGPointMake(109.29, 51.74)];
    [path addLineToPoint:CGPointMake(104.33, 35.61)];
    [path addLineToPoint:CGPointMake(101.35, 51.7)];
    [path addLineToPoint:CGPointMake(94.25, 51.7)];
    [path addLineToPoint:CGPointMake(99.92, 22.3)];
    [path closePath];

    // U
    [path moveToPoint:CGPointMake(124.07, 22.3)];
    [path addLineToPoint:CGPointMake(131.8, 22.3)];
    [path addLineToPoint:CGPointMake(128.23, 41.32)];
    [path addCurveToPoint:CGPointMake(128.06, 43.05) controlPoint1:CGPointMake(128.1, 41.96) controlPoint2:CGPointMake(128.06, 42.5)];
    [path addCurveToPoint:CGPointMake(130.33, 45.48) controlPoint1:CGPointMake(128.06, 44.64) controlPoint2:CGPointMake(128.86, 45.48)];
    [path addCurveToPoint:CGPointMake(133.65, 41.79) controlPoint1:CGPointMake(131.97, 45.48) controlPoint2:CGPointMake(133.15, 44.31)];
    [path addLineToPoint:CGPointMake(137.3, 22.3)];
    [path addLineToPoint:CGPointMake(144.87, 22.3)];
    [path addLineToPoint:CGPointMake(141.17, 41.83)];
    [path addCurveToPoint:CGPointMake(129.45, 52.25) controlPoint1:CGPointMake(139.82, 48.8) controlPoint2:CGPointMake(135.92, 52.25)];
    [path addCurveToPoint:CGPointMake(120.33, 43.55) controlPoint1:CGPointMake(123.53, 52.25) controlPoint2:CGPointMake(120.33, 49.05)];
    [path addCurveToPoint:CGPointMake(120.71, 40.02) controlPoint1:CGPointMake(120.33, 42.46) controlPoint2:CGPointMake(120.5, 41.28)];
    [path addLineToPoint:CGPointMake(124.07, 22.3)];
    [path closePath];

    return path;
}

UIBezierPath *TextPathContentPlay()
{
    // P
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(63.3, 28.47)];
    [path addLineToPoint:CGPointMake(61.66, 36.83)];
    [path addLineToPoint:CGPointMake(62.59, 36.83)];
    [path addCurveToPoint:CGPointMake(66.79, 31.07) controlPoint1:CGPointMake(65.02, 36.83) controlPoint2:CGPointMake(66.79, 34.39)];
    [path addCurveToPoint:CGPointMake(64.14, 28.47) controlPoint1:CGPointMake(66.79, 29.48) controlPoint2:CGPointMake(65.99, 28.47)];
    [path addLineToPoint:CGPointMake(63.3, 28.47)];
    [path closePath];
    [path moveToPoint:CGPointMake(60.61, 42.79)];
    [path addLineToPoint:CGPointMake(58.89, 51.7)];
    [path addLineToPoint:CGPointMake(51.12, 51.7)];
    [path addLineToPoint:CGPointMake(56.79, 22.3)];
    [path addLineToPoint:CGPointMake(64.98, 22.3)];
    [path addCurveToPoint:CGPointMake(74.43, 30.82) controlPoint1:CGPointMake(71.49, 22.3) controlPoint2:CGPointMake(74.43, 25.91)];
    [path addCurveToPoint:CGPointMake(62.04, 42.79) controlPoint1:CGPointMake(74.43, 37.8) controlPoint2:CGPointMake(69.73, 42.79)];
    [path addLineToPoint:CGPointMake(60.61, 42.79)];
    [path closePath];

    // L
    [path moveToPoint:CGPointMake(88.21, 51.7)];
    [path addLineToPoint:CGPointMake(72.71, 51.7)];
    [path addLineToPoint:CGPointMake(78.38, 22.3)];
    [path addLineToPoint:CGPointMake(86.11, 22.3)];
    [path addLineToPoint:CGPointMake(81.78, 44.98)];
    [path addLineToPoint:CGPointMake(89.51, 44.98)];
    [path addLineToPoint:CGPointMake(88.21, 51.7)];
    [path closePath];

    // A
    [path moveToPoint:CGPointMake(106.27, 40.27)];
    [path addLineToPoint:CGPointMake(105.89, 30.15)];
    [path addLineToPoint:CGPointMake(101.69, 40.27)];
    [path addLineToPoint:CGPointMake(106.27, 40.27)];
    [path closePath];
    [path moveToPoint:CGPointMake(102.82, 22.25)];
    [path addLineToPoint:CGPointMake(112.11, 22.25)];
    [path addLineToPoint:CGPointMake(114.21, 51.7)];
    [path addLineToPoint:CGPointMake(106.22, 51.7)];
    [path addLineToPoint:CGPointMake(106.14, 46.37)];
    [path addLineToPoint:CGPointMake(99.5, 46.37)];
    [path addLineToPoint:CGPointMake(97.32, 51.7)];
    [path addLineToPoint:CGPointMake(89.34, 51.7)];
    [path addLineToPoint:CGPointMake(102.82, 22.25)];
    [path closePath];

    // Y
    [path moveToPoint:CGPointMake(128.06, 40.82)];
    [path addLineToPoint:CGPointMake(125.96, 51.7)];
    [path addLineToPoint:CGPointMake(118.23, 51.7)];
    [path addLineToPoint:CGPointMake(120.34, 40.82)];
    [path addLineToPoint:CGPointMake(116.26, 22.3)];
    [path addLineToPoint:CGPointMake(124.24, 22.3)];
    [path addLineToPoint:CGPointMake(125.67, 33.01)];
    [path addLineToPoint:CGPointMake(131.09, 22.3)];
    [path addLineToPoint:CGPointMake(139.2, 22.3)];
    [path addLineToPoint:CGPointMake(139.2, 22.38)];
    [path addLineToPoint:CGPointMake(128.06, 40.82)];
    [path closePath];
    
    return path;
}

UIBezierPath *TextPathContentQuit()
{
    // Q
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(69.83, 37.21)];
    [path addCurveToPoint:CGPointMake(70.42, 32.33) controlPoint1:CGPointMake(70.29, 34.64) controlPoint2:CGPointMake(70.42, 33.26)];
    [path addCurveToPoint:CGPointMake(67.77, 28.47) controlPoint1:CGPointMake(70.42, 29.73) controlPoint2:CGPointMake(69.33, 28.47)];
    [path addCurveToPoint:CGPointMake(62.77, 36.79) controlPoint1:CGPointMake(65.67, 28.47) controlPoint2:CGPointMake(63.82, 31.24)];
    [path addCurveToPoint:CGPointMake(62.19, 41.66) controlPoint1:CGPointMake(62.31, 39.35) controlPoint2:CGPointMake(62.19, 40.78)];
    [path addCurveToPoint:CGPointMake(64.83, 45.52) controlPoint1:CGPointMake(62.19, 44.26) controlPoint2:CGPointMake(63.28, 45.52)];
    [path addCurveToPoint:CGPointMake(69.83, 37.21) controlPoint1:CGPointMake(66.93, 45.52) controlPoint2:CGPointMake(68.78, 42.75)];
    [path closePath];
    [path moveToPoint:CGPointMake(68.53, 56.83)];
    [path addCurveToPoint:CGPointMake(61.18, 51.57) controlPoint1:CGPointMake(65.42, 56.83) controlPoint2:CGPointMake(62.77, 55.98)];
    [path addCurveToPoint:CGPointMake(54.62, 41.24) controlPoint1:CGPointMake(56.94, 50.27) controlPoint2:CGPointMake(54.62, 46.49)];
    [path addCurveToPoint:CGPointMake(68.11, 21.71) controlPoint1:CGPointMake(54.62, 30.07) controlPoint2:CGPointMake(60.17, 21.71)];
    [path addCurveToPoint:CGPointMake(77.98, 32.75) controlPoint1:CGPointMake(74.49, 21.71) controlPoint2:CGPointMake(77.98, 26.2)];
    [path addCurveToPoint:CGPointMake(69.29, 50.65) controlPoint1:CGPointMake(77.98, 41.32) controlPoint2:CGPointMake(74.58, 48.13)];
    [path addCurveToPoint:CGPointMake(71.64, 51.83) controlPoint1:CGPointMake(69.87, 51.49) controlPoint2:CGPointMake(70.63, 51.83)];
    [path addCurveToPoint:CGPointMake(74.41, 50.99) controlPoint1:CGPointMake(72.52, 51.83) controlPoint2:CGPointMake(73.53, 51.45)];
    [path addLineToPoint:CGPointMake(74.49, 51.11)];
    [path addLineToPoint:CGPointMake(72.18, 56.03)];
    [path addCurveToPoint:CGPointMake(68.53, 56.83) controlPoint1:CGPointMake(71.18, 56.49) controlPoint2:CGPointMake(69.92, 56.83)];
    [path closePath];

    // U
    [path moveToPoint:CGPointMake(82.89, 22.3)];
    [path addLineToPoint:CGPointMake(90.62, 22.3)];
    [path addLineToPoint:CGPointMake(87.05, 41.32)];
    [path addCurveToPoint:CGPointMake(86.88, 43.05) controlPoint1:CGPointMake(86.92, 41.96) controlPoint2:CGPointMake(86.88, 42.5)];
    [path addCurveToPoint:CGPointMake(89.15, 45.48) controlPoint1:CGPointMake(86.88, 44.64) controlPoint2:CGPointMake(87.68, 45.48)];
    [path addCurveToPoint:CGPointMake(92.47, 41.79) controlPoint1:CGPointMake(90.79, 45.48) controlPoint2:CGPointMake(91.96, 44.31)];
    [path addLineToPoint:CGPointMake(96.12, 22.3)];
    [path addLineToPoint:CGPointMake(103.69, 22.3)];
    [path addLineToPoint:CGPointMake(99.99, 41.83)];
    [path addCurveToPoint:CGPointMake(88.27, 52.25) controlPoint1:CGPointMake(98.64, 48.8) controlPoint2:CGPointMake(94.74, 52.25)];
    [path addCurveToPoint:CGPointMake(79.15, 43.55) controlPoint1:CGPointMake(82.35, 52.25) controlPoint2:CGPointMake(79.15, 49.05)];
    [path addCurveToPoint:CGPointMake(79.53, 40.02) controlPoint1:CGPointMake(79.15, 42.46) controlPoint2:CGPointMake(79.32, 41.28)];
    [path addLineToPoint:CGPointMake(82.89, 22.3)];
    [path closePath];

    // I
    [path moveToPoint:CGPointMake(106.87, 22.3)];
    [path addLineToPoint:CGPointMake(114.64, 22.3)];
    [path addLineToPoint:CGPointMake(108.97, 51.7)];
    [path addLineToPoint:CGPointMake(101.24, 51.7)];
    [path addLineToPoint:CGPointMake(106.87, 22.3)];
    [path closePath];

    // T
    [path moveToPoint:CGPointMake(129.6, 29.02)];
    [path addLineToPoint:CGPointMake(125.23, 51.7)];
    [path addLineToPoint:CGPointMake(117.46, 51.7)];
    [path addLineToPoint:CGPointMake(121.83, 29.02)];
    [path addLineToPoint:CGPointMake(115.65, 29.02)];
    [path addLineToPoint:CGPointMake(117, 22.3)];
    [path addLineToPoint:CGPointMake(137.03, 22.3)];
    [path addLineToPoint:CGPointMake(135.69, 29.02)];
    [path addLineToPoint:CGPointMake(129.6, 29.02)];
    [path closePath];

    return path;
}

UIBezierPath *TextPathContentResume()
{
    // R
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(37.83, 28.22)];
    [path addLineToPoint:CGPointMake(36.27, 36.24)];
    [path addLineToPoint:CGPointMake(37.07, 36.24)];
    [path addCurveToPoint:CGPointMake(41.31, 31.03) controlPoint1:CGPointMake(39.76, 36.24) controlPoint2:CGPointMake(41.31, 33.76)];
    [path addCurveToPoint:CGPointMake(38.54, 28.22) controlPoint1:CGPointMake(41.31, 29.18) controlPoint2:CGPointMake(40.47, 28.22)];
    [path addLineToPoint:CGPointMake(37.83, 28.22)];
    [path closePath];
    [path moveToPoint:CGPointMake(35.85, 41.11)];
    [path addLineToPoint:CGPointMake(35.39, 41.11)];
    [path addLineToPoint:CGPointMake(33.37, 51.7)];
    [path addLineToPoint:CGPointMake(25.64, 51.7)];
    [path addLineToPoint:CGPointMake(31.32, 22.3)];
    [path addLineToPoint:CGPointMake(39.47, 22.3)];
    [path addCurveToPoint:CGPointMake(49, 30.4) controlPoint1:CGPointMake(45.72, 22.3) controlPoint2:CGPointMake(49, 25.24)];
    [path addCurveToPoint:CGPointMake(43.08, 39.73) controlPoint1:CGPointMake(49, 34.77) controlPoint2:CGPointMake(46.48, 38.01)];
    [path addLineToPoint:CGPointMake(46.98, 51.7)];
    [path addLineToPoint:CGPointMake(38.88, 51.7)];
    [path addLineToPoint:CGPointMake(35.85, 41.11)];
    [path closePath];

    // E
    [path moveToPoint:CGPointMake(53.83, 22.3)];
    [path addLineToPoint:CGPointMake(69.87, 22.3)];
    [path addLineToPoint:CGPointMake(68.61, 28.85)];
    [path addLineToPoint:CGPointMake(60.17, 28.85)];
    [path addLineToPoint:CGPointMake(59.2, 33.8)];
    [path addLineToPoint:CGPointMake(66.43, 33.8)];
    [path addLineToPoint:CGPointMake(65.21, 39.94)];
    [path addLineToPoint:CGPointMake(58.03, 39.94)];
    [path addLineToPoint:CGPointMake(57.02, 45.15)];
    [path addLineToPoint:CGPointMake(65.97, 45.15)];
    [path addLineToPoint:CGPointMake(63.95, 51.7)];
    [path addLineToPoint:CGPointMake(48.16, 51.7)];
    [path addLineToPoint:CGPointMake(53.83, 22.3)];
    [path closePath];

    // S
    [path moveToPoint:CGPointMake(87.64, 24.1)];
    [path addLineToPoint:CGPointMake(86.97, 31.29)];
    [path addLineToPoint:CGPointMake(86.84, 31.29)];
    [path addCurveToPoint:CGPointMake(80.41, 28.22) controlPoint1:CGPointMake(84.83, 29.52) controlPoint2:CGPointMake(82.43, 28.22)];
    [path addCurveToPoint:CGPointMake(78.36, 29.9) controlPoint1:CGPointMake(79.2, 28.22) controlPoint2:CGPointMake(78.36, 28.85)];
    [path addCurveToPoint:CGPointMake(80.96, 33.85) controlPoint1:CGPointMake(78.36, 30.86) controlPoint2:CGPointMake(79.03, 31.91)];
    [path addCurveToPoint:CGPointMake(85.5, 42.79) controlPoint1:CGPointMake(84.28, 36.96) controlPoint2:CGPointMake(85.5, 39.64)];
    [path addCurveToPoint:CGPointMake(75.71, 52.25) controlPoint1:CGPointMake(85.5, 48.59) controlPoint2:CGPointMake(81.76, 52.25)];
    [path addCurveToPoint:CGPointMake(67.73, 49.64) controlPoint1:CGPointMake(72.43, 52.25) controlPoint2:CGPointMake(69.49, 51.11)];
    [path addLineToPoint:CGPointMake(67.98, 41.79)];
    [path addLineToPoint:CGPointMake(68.11, 41.75)];
    [path addCurveToPoint:CGPointMake(75.37, 45.78) controlPoint1:CGPointMake(70.5, 44.27) controlPoint2:CGPointMake(73.27, 45.78)];
    [path addCurveToPoint:CGPointMake(77.68, 43.85) controlPoint1:CGPointMake(76.84, 45.78) controlPoint2:CGPointMake(77.68, 44.98)];
    [path addCurveToPoint:CGPointMake(75.33, 39.9) controlPoint1:CGPointMake(77.68, 42.67) controlPoint2:CGPointMake(76.97, 41.49)];
    [path addCurveToPoint:CGPointMake(70.58, 30.78) controlPoint1:CGPointMake(71.72, 36.45) controlPoint2:CGPointMake(70.58, 33.93)];
    [path addCurveToPoint:CGPointMake(80.16, 21.75) controlPoint1:CGPointMake(70.58, 25.53) controlPoint2:CGPointMake(74.32, 21.75)];
    [path addCurveToPoint:CGPointMake(87.64, 24.1) controlPoint1:CGPointMake(83.1, 21.75) controlPoint2:CGPointMake(85.79, 22.67)];
    [path closePath];

    // U
    [path moveToPoint:CGPointMake(91.46, 22.3)];
    [path addLineToPoint:CGPointMake(99.19, 22.3)];
    [path addLineToPoint:CGPointMake(95.62, 41.32)];
    [path addCurveToPoint:CGPointMake(95.45, 43.05) controlPoint1:CGPointMake(95.49, 41.96) controlPoint2:CGPointMake(95.45, 42.5)];
    [path addCurveToPoint:CGPointMake(97.72, 45.48) controlPoint1:CGPointMake(95.45, 44.64) controlPoint2:CGPointMake(96.25, 45.48)];
    [path addCurveToPoint:CGPointMake(101.04, 41.79) controlPoint1:CGPointMake(99.36, 45.48) controlPoint2:CGPointMake(100.53, 44.31)];
    [path addLineToPoint:CGPointMake(104.69, 22.3)];
    [path addLineToPoint:CGPointMake(112.25, 22.3)];
    [path addLineToPoint:CGPointMake(108.56, 41.83)];
    [path addCurveToPoint:CGPointMake(96.84, 52.25) controlPoint1:CGPointMake(107.21, 48.8) controlPoint2:CGPointMake(103.31, 52.25)];
    [path addCurveToPoint:CGPointMake(87.72, 43.55) controlPoint1:CGPointMake(90.91, 52.25) controlPoint2:CGPointMake(87.72, 49.05)];
    [path addCurveToPoint:CGPointMake(88.1, 40.02) controlPoint1:CGPointMake(87.72, 42.46) controlPoint2:CGPointMake(87.89, 41.28)];
    [path addLineToPoint:CGPointMake(91.46, 22.3)];
    [path closePath];

    // M
    [path moveToPoint:CGPointMake(126.7, 36.49)];
    [path addLineToPoint:CGPointMake(133.04, 22.29)];
    [path addLineToPoint:CGPointMake(143.46, 22.29)];
    [path addLineToPoint:CGPointMake(138.5, 51.7)];
    [path addLineToPoint:CGPointMake(131.11, 51.7)];
    [path addLineToPoint:CGPointMake(134.51, 32.04)];
    [path addLineToPoint:CGPointMake(124.89, 51.83)];
    [path addLineToPoint:CGPointMake(122.58, 51.83)];
    [path addLineToPoint:CGPointMake(120.61, 32.08)];
    [path addLineToPoint:CGPointMake(116.49, 51.7)];
    [path addLineToPoint:CGPointMake(109.39, 51.7)];
    [path addLineToPoint:CGPointMake(115.69, 22.29)];
    [path addLineToPoint:CGPointMake(125.82, 22.29)];
    [path addLineToPoint:CGPointMake(126.7, 36.49)];
    [path closePath];

    // E
    [path moveToPoint:CGPointMake(147.03, 22.3)];
    [path addLineToPoint:CGPointMake(163.07, 22.3)];
    [path addLineToPoint:CGPointMake(161.81, 28.85)];
    [path addLineToPoint:CGPointMake(153.37, 28.85)];
    [path addLineToPoint:CGPointMake(152.4, 33.8)];
    [path addLineToPoint:CGPointMake(159.63, 33.8)];
    [path addLineToPoint:CGPointMake(158.41, 39.94)];
    [path addLineToPoint:CGPointMake(151.23, 39.94)];
    [path addLineToPoint:CGPointMake(150.22, 45.15)];
    [path addLineToPoint:CGPointMake(159.17, 45.15)];
    [path addLineToPoint:CGPointMake(157.15, 51.7)];
    [path addLineToPoint:CGPointMake(141.35, 51.7)];
    [path addLineToPoint:CGPointMake(147.03, 22.3)];
    [path closePath];

    return path;
}

UIBezierPath *TextPathContentStats()
{
    // S
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(63.24, 24.1)];
    [path addLineToPoint:CGPointMake(62.57, 31.29)];
    [path addLineToPoint:CGPointMake(62.44, 31.29)];
    [path addCurveToPoint:CGPointMake(56.01, 28.22) controlPoint1:CGPointMake(60.42, 29.52) controlPoint2:CGPointMake(58.03, 28.22)];
    [path addCurveToPoint:CGPointMake(53.95, 29.9) controlPoint1:CGPointMake(54.8, 28.22) controlPoint2:CGPointMake(53.95, 28.85)];
    [path addCurveToPoint:CGPointMake(56.56, 33.85) controlPoint1:CGPointMake(53.95, 30.86) controlPoint2:CGPointMake(54.63, 31.91)];
    [path addCurveToPoint:CGPointMake(61.1, 42.79) controlPoint1:CGPointMake(59.88, 36.96) controlPoint2:CGPointMake(61.1, 39.64)];
    [path addCurveToPoint:CGPointMake(51.31, 52.25) controlPoint1:CGPointMake(61.1, 48.59) controlPoint2:CGPointMake(57.36, 52.25)];
    [path addCurveToPoint:CGPointMake(43.33, 49.64) controlPoint1:CGPointMake(48.03, 52.25) controlPoint2:CGPointMake(45.09, 51.11)];
    [path addLineToPoint:CGPointMake(43.58, 41.79)];
    [path addLineToPoint:CGPointMake(43.7, 41.75)];
    [path addCurveToPoint:CGPointMake(50.97, 45.78) controlPoint1:CGPointMake(46.1, 44.27) controlPoint2:CGPointMake(48.87, 45.78)];
    [path addCurveToPoint:CGPointMake(53.28, 43.85) controlPoint1:CGPointMake(52.44, 45.78) controlPoint2:CGPointMake(53.28, 44.98)];
    [path addCurveToPoint:CGPointMake(50.93, 39.9) controlPoint1:CGPointMake(53.28, 42.67) controlPoint2:CGPointMake(52.57, 41.49)];
    [path addCurveToPoint:CGPointMake(46.18, 30.78) controlPoint1:CGPointMake(47.32, 36.45) controlPoint2:CGPointMake(46.18, 33.93)];
    [path addCurveToPoint:CGPointMake(55.76, 21.75) controlPoint1:CGPointMake(46.18, 25.53) controlPoint2:CGPointMake(49.92, 21.75)];
    [path addCurveToPoint:CGPointMake(63.24, 24.1) controlPoint1:CGPointMake(58.7, 21.75) controlPoint2:CGPointMake(61.39, 22.67)];
    [path closePath];

    // T
    [path moveToPoint:CGPointMake(78.53, 29.02)];
    [path addLineToPoint:CGPointMake(74.16, 51.7)];
    [path addLineToPoint:CGPointMake(66.39, 51.7)];
    [path addLineToPoint:CGPointMake(70.76, 29.02)];
    [path addLineToPoint:CGPointMake(64.58, 29.02)];
    [path addLineToPoint:CGPointMake(65.92, 22.3)];
    [path addLineToPoint:CGPointMake(85.96, 22.3)];
    [path addLineToPoint:CGPointMake(84.62, 29.02)];
    [path addLineToPoint:CGPointMake(78.53, 29.02)];
    [path closePath];

    // A
    [path moveToPoint:CGPointMake(95.66, 40.27)];
    [path addLineToPoint:CGPointMake(95.28, 30.15)];
    [path addLineToPoint:CGPointMake(91.08, 40.27)];
    [path addLineToPoint:CGPointMake(95.66, 40.27)];
    [path closePath];
    [path moveToPoint:CGPointMake(92.22, 22.25)];
    [path addLineToPoint:CGPointMake(101.5, 22.25)];
    [path addLineToPoint:CGPointMake(103.6, 51.7)];
    [path addLineToPoint:CGPointMake(95.62, 51.7)];
    [path addLineToPoint:CGPointMake(95.54, 46.37)];
    [path addLineToPoint:CGPointMake(88.9, 46.37)];
    [path addLineToPoint:CGPointMake(86.71, 51.7)];
    [path addLineToPoint:CGPointMake(78.73, 51.7)];
    [path addLineToPoint:CGPointMake(92.22, 22.25)];
    [path closePath];

    // T
    [path moveToPoint:CGPointMake(119.77, 29.02)];
    [path addLineToPoint:CGPointMake(115.4, 51.7)];
    [path addLineToPoint:CGPointMake(107.63, 51.7)];
    [path addLineToPoint:CGPointMake(112, 29.02)];
    [path addLineToPoint:CGPointMake(105.82, 29.02)];
    [path addLineToPoint:CGPointMake(107.17, 22.3)];
    [path addLineToPoint:CGPointMake(127.21, 22.3)];
    [path addLineToPoint:CGPointMake(125.86, 29.02)];
    [path addLineToPoint:CGPointMake(119.77, 29.02)];
    [path closePath];

    // S
    [path moveToPoint:CGPointMake(144.55, 24.1)];
    [path addLineToPoint:CGPointMake(143.88, 31.29)];
    [path addLineToPoint:CGPointMake(143.75, 31.29)];
    [path addCurveToPoint:CGPointMake(137.33, 28.22) controlPoint1:CGPointMake(141.74, 29.52) controlPoint2:CGPointMake(139.34, 28.22)];
    [path addCurveToPoint:CGPointMake(135.27, 29.9) controlPoint1:CGPointMake(136.11, 28.22) controlPoint2:CGPointMake(135.27, 28.85)];
    [path addCurveToPoint:CGPointMake(137.87, 33.85) controlPoint1:CGPointMake(135.27, 30.86) controlPoint2:CGPointMake(135.94, 31.91)];
    [path addCurveToPoint:CGPointMake(142.41, 42.79) controlPoint1:CGPointMake(141.19, 36.96) controlPoint2:CGPointMake(142.41, 39.64)];
    [path addCurveToPoint:CGPointMake(132.62, 52.25) controlPoint1:CGPointMake(142.41, 48.59) controlPoint2:CGPointMake(138.67, 52.25)];
    [path addCurveToPoint:CGPointMake(124.64, 49.64) controlPoint1:CGPointMake(129.34, 52.25) controlPoint2:CGPointMake(126.4, 51.11)];
    [path addLineToPoint:CGPointMake(124.89, 41.79)];
    [path addLineToPoint:CGPointMake(125.02, 41.75)];
    [path addCurveToPoint:CGPointMake(132.28, 45.78) controlPoint1:CGPointMake(127.41, 44.27) controlPoint2:CGPointMake(130.18, 45.78)];
    [path addCurveToPoint:CGPointMake(134.6, 43.85) controlPoint1:CGPointMake(133.75, 45.78) controlPoint2:CGPointMake(134.6, 44.98)];
    [path addCurveToPoint:CGPointMake(132.24, 39.9) controlPoint1:CGPointMake(134.6, 42.67) controlPoint2:CGPointMake(133.88, 41.49)];
    [path addCurveToPoint:CGPointMake(127.5, 30.78) controlPoint1:CGPointMake(128.63, 36.45) controlPoint2:CGPointMake(127.5, 33.93)];
    [path addCurveToPoint:CGPointMake(137.07, 21.75) controlPoint1:CGPointMake(127.5, 25.53) controlPoint2:CGPointMake(131.23, 21.75)];
    [path addCurveToPoint:CGPointMake(144.55, 24.1) controlPoint1:CGPointMake(140.01, 21.75) controlPoint2:CGPointMake(142.7, 22.67)];
    [path closePath];

    return path;
}

UIBezierPath *TextPathDialogGameOver()
{
    // G
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(224.04, 126.75)];
    [path addCurveToPoint:CGPointMake(198.56, 98.78) controlPoint1:CGPointMake(208.13, 126.75) controlPoint2:CGPointMake(198.56, 116.98)];
    [path addCurveToPoint:CGPointMake(236.42, 51.56) controlPoint1:CGPointMake(198.56, 73.19) controlPoint2:CGPointMake(212.81, 51.56)];
    [path addCurveToPoint:CGPointMake(255.66, 56.86) controlPoint1:CGPointMake(244.32, 51.56) controlPoint2:CGPointMake(251.19, 53.74)];
    [path addLineToPoint:CGPointMake(252.02, 74.75)];
    [path addLineToPoint:CGPointMake(251.71, 74.75)];
    [path addCurveToPoint:CGPointMake(236.73, 68.72) controlPoint1:CGPointMake(246.82, 70.8) controlPoint2:CGPointMake(242.14, 68.72)];
    [path addCurveToPoint:CGPointMake(218.53, 90.25) controlPoint1:CGPointMake(227.68, 68.72) controlPoint2:CGPointMake(221.03, 76.94)];
    [path addCurveToPoint:CGPointMake(217.6, 99.4) controlPoint1:CGPointMake(218.01, 93.06) controlPoint2:CGPointMake(217.6, 95.76)];
    [path addCurveToPoint:CGPointMake(226.85, 110.74) controlPoint1:CGPointMake(217.6, 106.89) controlPoint2:CGPointMake(220.82, 110.74)];
    [path addCurveToPoint:CGPointMake(229.76, 110.63) controlPoint1:CGPointMake(227.89, 110.74) controlPoint2:CGPointMake(228.83, 110.74)];
    [path addLineToPoint:CGPointMake(232.68, 97.11)];
    [path addLineToPoint:CGPointMake(225.29, 97.11)];
    [path addLineToPoint:CGPointMake(227.89, 84.11)];
    [path addLineToPoint:CGPointMake(251.92, 84.11)];
    [path addLineToPoint:CGPointMake(244.22, 121.66)];
    [path addCurveToPoint:CGPointMake(224.04, 126.75) controlPoint1:CGPointMake(238.19, 124.78) controlPoint2:CGPointMake(231.11, 126.75)];
    [path closePath];

    // A
    [path moveToPoint:CGPointMake(289.77, 97.22)];
    [path addLineToPoint:CGPointMake(288.83, 72.15)];
    [path addLineToPoint:CGPointMake(278.43, 97.22)];
    [path addLineToPoint:CGPointMake(289.77, 97.22)];
    [path closePath];
    [path moveToPoint:CGPointMake(281.24, 52.6)];
    [path addLineToPoint:CGPointMake(304.23, 52.6)];
    [path addLineToPoint:CGPointMake(309.43, 125.51)];
    [path addLineToPoint:CGPointMake(289.67, 125.51)];
    [path addLineToPoint:CGPointMake(289.46, 112.3)];
    [path addLineToPoint:CGPointMake(273.03, 112.3)];
    [path addLineToPoint:CGPointMake(267.62, 125.51)];
    [path addLineToPoint:CGPointMake(247.86, 125.51)];
    [path addLineToPoint:CGPointMake(281.24, 52.6)];
    [path closePath];

    // M
    [path moveToPoint:CGPointMake(355.81, 87.86)];
    [path addLineToPoint:CGPointMake(371.51, 52.7)];
    [path addLineToPoint:CGPointMake(397.31, 52.7)];
    [path addLineToPoint:CGPointMake(385.04, 125.51)];
    [path addLineToPoint:CGPointMake(366.73, 125.51)];
    [path addLineToPoint:CGPointMake(375.15, 76.83)];
    [path addLineToPoint:CGPointMake(351.34, 125.82)];
    [path addLineToPoint:CGPointMake(345.62, 125.82)];
    [path addLineToPoint:CGPointMake(340.73, 76.94)];
    [path addLineToPoint:CGPointMake(330.54, 125.51)];
    [path addLineToPoint:CGPointMake(312.96, 125.51)];
    [path addLineToPoint:CGPointMake(328.56, 52.7)];
    [path addLineToPoint:CGPointMake(353.62, 52.7)];
    [path addLineToPoint:CGPointMake(355.81, 87.86)];
    [path closePath];

    // E
    [path moveToPoint:CGPointMake(406.14, 52.7)];
    [path addLineToPoint:CGPointMake(445.87, 52.7)];
    [path addLineToPoint:CGPointMake(442.75, 68.93)];
    [path addLineToPoint:CGPointMake(421.85, 68.93)];
    [path addLineToPoint:CGPointMake(419.46, 81.2)];
    [path addLineToPoint:CGPointMake(437.35, 81.2)];
    [path addLineToPoint:CGPointMake(434.33, 96.38)];
    [path addLineToPoint:CGPointMake(416.54, 96.38)];
    [path addLineToPoint:CGPointMake(414.05, 109.28)];
    [path addLineToPoint:CGPointMake(436.2, 109.28)];
    [path addLineToPoint:CGPointMake(431.21, 125.51)];
    [path addLineToPoint:CGPointMake(392.1, 125.51)];
    [path addLineToPoint:CGPointMake(406.14, 52.7)];
    [path closePath];

    // O
    [path moveToPoint:CGPointMake(497.66, 89.62)];
    [path addCurveToPoint:CGPointMake(499.12, 77.56) controlPoint1:CGPointMake(498.81, 83.28) controlPoint2:CGPointMake(499.12, 79.85)];
    [path addCurveToPoint:CGPointMake(492.57, 67.99) controlPoint1:CGPointMake(499.12, 71.11) controlPoint2:CGPointMake(496.42, 67.99)];
    [path addCurveToPoint:CGPointMake(480.19, 88.58) controlPoint1:CGPointMake(487.37, 67.99) controlPoint2:CGPointMake(482.79, 74.86)];
    [path addCurveToPoint:CGPointMake(478.73, 100.65) controlPoint1:CGPointMake(479.05, 94.93) controlPoint2:CGPointMake(478.73, 98.46)];
    [path addCurveToPoint:CGPointMake(485.29, 110.22) controlPoint1:CGPointMake(478.73, 107.1) controlPoint2:CGPointMake(481.44, 110.22)];
    [path addCurveToPoint:CGPointMake(497.66, 89.62) controlPoint1:CGPointMake(490.49, 110.22) controlPoint2:CGPointMake(495.06, 103.35)];
    [path closePath];
    [path moveToPoint:CGPointMake(460.01, 99.61)];
    [path addCurveToPoint:CGPointMake(493.4, 51.25) controlPoint1:CGPointMake(460.01, 71.94) controlPoint2:CGPointMake(473.74, 51.25)];
    [path addCurveToPoint:CGPointMake(517.84, 78.6) controlPoint1:CGPointMake(509.21, 51.25) controlPoint2:CGPointMake(517.84, 62.38)];
    [path addCurveToPoint:CGPointMake(484.45, 126.96) controlPoint1:CGPointMake(517.84, 106.27) controlPoint2:CGPointMake(504.01, 126.96)];
    [path addCurveToPoint:CGPointMake(460.01, 99.61) controlPoint1:CGPointMake(468.65, 126.96) controlPoint2:CGPointMake(460.01, 115.83)];
    [path closePath];

    // V
    [path moveToPoint:CGPointMake(548.21, 125.82)];
    [path addLineToPoint:CGPointMake(527.82, 125.82)];
    [path addLineToPoint:CGPointMake(522.73, 52.7)];
    [path addLineToPoint:CGPointMake(542.38, 52.7)];
    [path addLineToPoint:CGPointMake(543.32, 98.26)];
    [path addLineToPoint:CGPointMake(561.52, 52.7)];
    [path addLineToPoint:CGPointMake(581.38, 52.7)];
    [path addLineToPoint:CGPointMake(548.21, 125.82)];
    [path closePath];

    // E
    [path moveToPoint:CGPointMake(585.75, 52.7)];
    [path addLineToPoint:CGPointMake(625.48, 52.7)];
    [path addLineToPoint:CGPointMake(622.36, 68.93)];
    [path addLineToPoint:CGPointMake(601.45, 68.93)];
    [path addLineToPoint:CGPointMake(599.06, 81.2)];
    [path addLineToPoint:CGPointMake(616.95, 81.2)];
    [path addLineToPoint:CGPointMake(613.94, 96.38)];
    [path addLineToPoint:CGPointMake(596.15, 96.38)];
    [path addLineToPoint:CGPointMake(593.65, 109.28)];
    [path addLineToPoint:CGPointMake(615.81, 109.28)];
    [path addLineToPoint:CGPointMake(610.81, 125.51)];
    [path addLineToPoint:CGPointMake(571.71, 125.51)];
    [path addLineToPoint:CGPointMake(585.75, 52.7)];
    [path closePath];

    // R
    [path moveToPoint:CGPointMake(648.77, 67.37)];
    [path addLineToPoint:CGPointMake(644.92, 87.23)];
    [path addLineToPoint:CGPointMake(646.9, 87.23)];
    [path addCurveToPoint:CGPointMake(657.41, 74.34) controlPoint1:CGPointMake(653.56, 87.23) controlPoint2:CGPointMake(657.41, 81.1)];
    [path addCurveToPoint:CGPointMake(650.54, 67.37) controlPoint1:CGPointMake(657.41, 69.76) controlPoint2:CGPointMake(655.33, 67.37)];
    [path addLineToPoint:CGPointMake(648.77, 67.37)];
    [path closePath];
    [path moveToPoint:CGPointMake(643.88, 99.3)];
    [path addLineToPoint:CGPointMake(642.74, 99.3)];
    [path addLineToPoint:CGPointMake(637.75, 125.51)];
    [path addLineToPoint:CGPointMake(618.61, 125.51)];
    [path addLineToPoint:CGPointMake(632.65, 52.7)];
    [path addLineToPoint:CGPointMake(652.83, 52.7)];
    [path addCurveToPoint:CGPointMake(676.44, 72.78) controlPoint1:CGPointMake(668.33, 52.7) controlPoint2:CGPointMake(676.44, 59.98)];
    [path addCurveToPoint:CGPointMake(661.77, 95.87) controlPoint1:CGPointMake(676.44, 83.59) controlPoint2:CGPointMake(670.2, 91.6)];
    [path addLineToPoint:CGPointMake(671.45, 125.51)];
    [path addLineToPoint:CGPointMake(651.37, 125.51)];
    [path addLineToPoint:CGPointMake(643.88, 99.3)];
    [path closePath];

    return path;
}

UIBezierPath *TextPathDialogPaused()
{
    // P
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(307.09, 67.89)];
    [path addLineToPoint:CGPointMake(303.03, 88.58)];
    [path addLineToPoint:CGPointMake(305.32, 88.58)];
    [path addCurveToPoint:CGPointMake(315.72, 74.33) controlPoint1:CGPointMake(311.35, 88.58) controlPoint2:CGPointMake(315.72, 82.55)];
    [path addCurveToPoint:CGPointMake(309.17, 67.89) controlPoint1:CGPointMake(315.72, 70.38) controlPoint2:CGPointMake(313.74, 67.89)];
    [path addLineToPoint:CGPointMake(307.09, 67.89)];
    [path closePath];
    [path moveToPoint:CGPointMake(300.43, 103.35)];
    [path addLineToPoint:CGPointMake(296.17, 125.4)];
    [path addLineToPoint:CGPointMake(276.92, 125.4)];
    [path addLineToPoint:CGPointMake(290.97, 52.6)];
    [path addLineToPoint:CGPointMake(311.25, 52.6)];
    [path addCurveToPoint:CGPointMake(334.65, 73.71) controlPoint1:CGPointMake(327.37, 52.6) controlPoint2:CGPointMake(334.65, 61.54)];
    [path addCurveToPoint:CGPointMake(303.97, 103.35) controlPoint1:CGPointMake(334.65, 90.98) controlPoint2:CGPointMake(323, 103.35)];
    [path addLineToPoint:CGPointMake(300.43, 103.35)];
    [path closePath];

    // A
    [path moveToPoint:CGPointMake(363.97, 97.11)];
    [path addLineToPoint:CGPointMake(363.04, 72.05)];
    [path addLineToPoint:CGPointMake(352.64, 97.11)];
    [path addLineToPoint:CGPointMake(363.97, 97.11)];
    [path closePath];
    [path moveToPoint:CGPointMake(355.45, 52.5)];
    [path addLineToPoint:CGPointMake(378.43, 52.5)];
    [path addLineToPoint:CGPointMake(383.63, 125.4)];
    [path addLineToPoint:CGPointMake(363.87, 125.4)];
    [path addLineToPoint:CGPointMake(363.66, 112.19)];
    [path addLineToPoint:CGPointMake(347.23, 112.19)];
    [path addLineToPoint:CGPointMake(341.82, 125.4)];
    [path addLineToPoint:CGPointMake(322.06, 125.4)];
    [path addLineToPoint:CGPointMake(355.45, 52.5)];
    [path closePath];

    // U
    [path moveToPoint:CGPointMake(398.4, 52.6)];
    [path addLineToPoint:CGPointMake(417.53, 52.6)];
    [path addLineToPoint:CGPointMake(408.69, 99.71)];
    [path addCurveToPoint:CGPointMake(408.28, 103.98) controlPoint1:CGPointMake(408.38, 101.27) controlPoint2:CGPointMake(408.28, 102.62)];
    [path addCurveToPoint:CGPointMake(413.89, 110.01) controlPoint1:CGPointMake(408.28, 107.93) controlPoint2:CGPointMake(410.25, 110.01)];
    [path addCurveToPoint:CGPointMake(422.11, 100.86) controlPoint1:CGPointMake(417.95, 110.01) controlPoint2:CGPointMake(420.86, 107.1)];
    [path addLineToPoint:CGPointMake(431.16, 52.6)];
    [path addLineToPoint:CGPointMake(449.88, 52.6)];
    [path addLineToPoint:CGPointMake(440.73, 100.96)];
    [path addCurveToPoint:CGPointMake(411.71, 126.75) controlPoint1:CGPointMake(437.4, 118.23) controlPoint2:CGPointMake(427.73, 126.75)];
    [path addCurveToPoint:CGPointMake(389.14, 105.22) controlPoint1:CGPointMake(397.04, 126.75) controlPoint2:CGPointMake(389.14, 118.85)];
    [path addCurveToPoint:CGPointMake(390.08, 96.49) controlPoint1:CGPointMake(389.14, 102.52) controlPoint2:CGPointMake(389.56, 99.61)];
    [path addLineToPoint:CGPointMake(398.4, 52.6)];
    [path closePath];

    // S
    [path moveToPoint:CGPointMake(494.39, 57.07)];
    [path addLineToPoint:CGPointMake(492.73, 74.86)];
    [path addLineToPoint:CGPointMake(492.41, 74.86)];
    [path addCurveToPoint:CGPointMake(476.5, 67.26) controlPoint1:CGPointMake(487.42, 70.49) controlPoint2:CGPointMake(481.49, 67.26)];
    [path addCurveToPoint:CGPointMake(471.41, 71.42) controlPoint1:CGPointMake(473.49, 67.26) controlPoint2:CGPointMake(471.41, 68.82)];
    [path addCurveToPoint:CGPointMake(477.85, 81.2) controlPoint1:CGPointMake(471.41, 73.82) controlPoint2:CGPointMake(473.07, 76.42)];
    [path addCurveToPoint:CGPointMake(489.08, 103.35) controlPoint1:CGPointMake(486.07, 88.9) controlPoint2:CGPointMake(489.08, 95.55)];
    [path addCurveToPoint:CGPointMake(464.85, 126.75) controlPoint1:CGPointMake(489.08, 117.71) controlPoint2:CGPointMake(479.83, 126.75)];
    [path addCurveToPoint:CGPointMake(445.09, 120.31) controlPoint1:CGPointMake(456.74, 126.75) controlPoint2:CGPointMake(449.46, 123.95)];
    [path addLineToPoint:CGPointMake(445.72, 100.86)];
    [path addLineToPoint:CGPointMake(446.03, 100.75)];
    [path addCurveToPoint:CGPointMake(464.02, 110.74) controlPoint1:CGPointMake(451.96, 106.99) controlPoint2:CGPointMake(458.82, 110.74)];
    [path addCurveToPoint:CGPointMake(469.74, 105.95) controlPoint1:CGPointMake(467.66, 110.74) controlPoint2:CGPointMake(469.74, 108.76)];
    [path addCurveToPoint:CGPointMake(463.92, 96.18) controlPoint1:CGPointMake(469.74, 103.04) controlPoint2:CGPointMake(467.97, 100.13)];
    [path addCurveToPoint:CGPointMake(452.16, 73.61) controlPoint1:CGPointMake(454.97, 87.65) controlPoint2:CGPointMake(452.16, 81.41)];
    [path addCurveToPoint:CGPointMake(475.88, 51.25) controlPoint1:CGPointMake(452.16, 60.61) controlPoint2:CGPointMake(461.42, 51.25)];
    [path addCurveToPoint:CGPointMake(494.39, 57.07) controlPoint1:CGPointMake(483.16, 51.25) controlPoint2:CGPointMake(489.81, 53.53)];
    [path closePath];

    // E
    [path moveToPoint:CGPointMake(504.68, 52.6)];
    [path addLineToPoint:CGPointMake(544.41, 52.6)];
    [path addLineToPoint:CGPointMake(541.29, 68.82)];
    [path addLineToPoint:CGPointMake(520.39, 68.82)];
    [path addLineToPoint:CGPointMake(518, 81.1)];
    [path addLineToPoint:CGPointMake(535.88, 81.1)];
    [path addLineToPoint:CGPointMake(532.87, 96.28)];
    [path addLineToPoint:CGPointMake(515.08, 96.28)];
    [path addLineToPoint:CGPointMake(512.59, 109.18)];
    [path addLineToPoint:CGPointMake(534.74, 109.18)];
    [path addLineToPoint:CGPointMake(529.75, 125.4)];
    [path addLineToPoint:CGPointMake(490.64, 125.4)];
    [path addLineToPoint:CGPointMake(504.68, 52.6)];
    [path closePath];

    // D
    [path moveToPoint:CGPointMake(567.29, 69.24)];
    [path addLineToPoint:CGPointMake(559.59, 108.76)];
    [path addLineToPoint:CGPointMake(560.95, 108.76)];
    [path addCurveToPoint:CGPointMake(578, 87.65) controlPoint1:CGPointMake(569.89, 108.76) controlPoint2:CGPointMake(575.4, 101.79)];
    [path addCurveToPoint:CGPointMake(578.83, 80.26) controlPoint1:CGPointMake(578.42, 85.26) controlPoint2:CGPointMake(578.83, 82.55)];
    [path addCurveToPoint:CGPointMake(568.85, 69.24) controlPoint1:CGPointMake(578.83, 73.09) controlPoint2:CGPointMake(575.61, 69.24)];
    [path addLineToPoint:CGPointMake(567.29, 69.24)];
    [path closePath];
    [path moveToPoint:CGPointMake(537.55, 125.4)];
    [path addLineToPoint:CGPointMake(551.59, 52.6)];
    [path addLineToPoint:CGPointMake(569.99, 52.6)];
    [path addCurveToPoint:CGPointMake(598.07, 79.64) controlPoint1:CGPointMake(589.34, 52.6) controlPoint2:CGPointMake(598.07, 62.79)];
    [path addCurveToPoint:CGPointMake(556.79, 125.4) controlPoint1:CGPointMake(598.07, 99.82) controlPoint2:CGPointMake(587.15, 125.4)];
    [path addLineToPoint:CGPointMake(537.55, 125.4)];
    [path closePath];

    return path;
}

UIBezierPath *TextPathDialogReady()
{
    // R
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(325.34, 67.26)];
    [path addLineToPoint:CGPointMake(321.49, 87.13)];
    [path addLineToPoint:CGPointMake(323.47, 87.13)];
    [path addCurveToPoint:CGPointMake(333.97, 74.23) controlPoint1:CGPointMake(330.12, 87.13) controlPoint2:CGPointMake(333.97, 80.99)];
    [path addCurveToPoint:CGPointMake(327.11, 67.26) controlPoint1:CGPointMake(333.97, 69.66) controlPoint2:CGPointMake(331.89, 67.26)];
    [path addLineToPoint:CGPointMake(325.34, 67.26)];
    [path closePath];
    [path moveToPoint:CGPointMake(320.45, 99.19)];
    [path addLineToPoint:CGPointMake(319.31, 99.19)];
    [path addLineToPoint:CGPointMake(314.31, 125.4)];
    [path addLineToPoint:CGPointMake(295.18, 125.4)];
    [path addLineToPoint:CGPointMake(309.22, 52.6)];
    [path addLineToPoint:CGPointMake(329.39, 52.6)];
    [path addCurveToPoint:CGPointMake(353, 72.67) controlPoint1:CGPointMake(344.89, 52.6) controlPoint2:CGPointMake(353, 59.88)];
    [path addCurveToPoint:CGPointMake(338.34, 95.76) controlPoint1:CGPointMake(353, 83.49) controlPoint2:CGPointMake(346.76, 91.5)];
    [path addLineToPoint:CGPointMake(348.01, 125.4)];
    [path addLineToPoint:CGPointMake(327.94, 125.4)];
    [path addLineToPoint:CGPointMake(320.45, 99.19)];
    [path closePath];
    
    // E
    [path moveToPoint:CGPointMake(364.96, 52.6)];
    [path addLineToPoint:CGPointMake(404.69, 52.6)];
    [path addLineToPoint:CGPointMake(401.57, 68.82)];
    [path addLineToPoint:CGPointMake(380.66, 68.82)];
    [path addLineToPoint:CGPointMake(378.27, 81.1)];
    [path addLineToPoint:CGPointMake(396.16, 81.1)];
    [path addLineToPoint:CGPointMake(393.15, 96.28)];
    [path addLineToPoint:CGPointMake(375.36, 96.28)];
    [path addLineToPoint:CGPointMake(372.86, 109.18)];
    [path addLineToPoint:CGPointMake(395.02, 109.18)];
    [path addLineToPoint:CGPointMake(390.02, 125.4)];
    [path addLineToPoint:CGPointMake(350.92, 125.4)];
    [path addLineToPoint:CGPointMake(364.96, 52.6)];
    [path closePath];
    
    // A
    [path moveToPoint:CGPointMake(436.3, 97.11)];
    [path addLineToPoint:CGPointMake(435.37, 72.05)];
    [path addLineToPoint:CGPointMake(424.97, 97.11)];
    [path addLineToPoint:CGPointMake(436.3, 97.11)];
    [path closePath];
    [path moveToPoint:CGPointMake(427.78, 52.5)];
    [path addLineToPoint:CGPointMake(450.76, 52.5)];
    [path addLineToPoint:CGPointMake(455.96, 125.4)];
    [path addLineToPoint:CGPointMake(436.2, 125.4)];
    [path addLineToPoint:CGPointMake(435.99, 112.19)];
    [path addLineToPoint:CGPointMake(419.56, 112.19)];
    [path addLineToPoint:CGPointMake(414.15, 125.4)];
    [path addLineToPoint:CGPointMake(394.39, 125.4)];
    [path addLineToPoint:CGPointMake(427.78, 52.5)];
    [path closePath];
    
    // D
    [path moveToPoint:CGPointMake(489.97, 69.24)];
    [path addLineToPoint:CGPointMake(482.27, 108.76)];
    [path addLineToPoint:CGPointMake(483.62, 108.76)];
    [path addCurveToPoint:CGPointMake(500.68, 87.65) controlPoint1:CGPointMake(492.57, 108.76) controlPoint2:CGPointMake(498.08, 101.79)];
    [path addCurveToPoint:CGPointMake(501.51, 80.26) controlPoint1:CGPointMake(501.09, 85.26) controlPoint2:CGPointMake(501.51, 82.55)];
    [path addCurveToPoint:CGPointMake(491.53, 69.24) controlPoint1:CGPointMake(501.51, 73.09) controlPoint2:CGPointMake(498.29, 69.24)];
    [path addLineToPoint:CGPointMake(489.97, 69.24)];
    [path closePath];
    [path moveToPoint:CGPointMake(460.22, 125.4)];
    [path addLineToPoint:CGPointMake(474.26, 52.6)];
    [path addLineToPoint:CGPointMake(492.67, 52.6)];
    [path addCurveToPoint:CGPointMake(520.75, 79.64) controlPoint1:CGPointMake(512.01, 52.6) controlPoint2:CGPointMake(520.75, 62.79)];
    [path addCurveToPoint:CGPointMake(479.46, 125.4) controlPoint1:CGPointMake(520.75, 99.82) controlPoint2:CGPointMake(509.83, 125.4)];
    [path addLineToPoint:CGPointMake(460.22, 125.4)];
    [path closePath];
    
    // Y
    [path moveToPoint:CGPointMake(552.26, 98.46)];
    [path addLineToPoint:CGPointMake(547.06, 125.4)];
    [path addLineToPoint:CGPointMake(527.93, 125.4)];
    [path addLineToPoint:CGPointMake(533.13, 98.46)];
    [path addLineToPoint:CGPointMake(523.04, 52.6)];
    [path addLineToPoint:CGPointMake(542.8, 52.6)];
    [path addLineToPoint:CGPointMake(546.33, 79.12)];
    [path addLineToPoint:CGPointMake(559.75, 52.6)];
    [path addLineToPoint:CGPointMake(579.82, 52.6)];
    [path addLineToPoint:CGPointMake(579.82, 52.81)];
    [path addLineToPoint:CGPointMake(552.26, 98.46)];
    [path closePath];

    return path;
}

}  // namespace UP

#endif  // __cplusplus
