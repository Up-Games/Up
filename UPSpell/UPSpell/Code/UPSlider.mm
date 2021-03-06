//
//  UPSlider.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPSlideGestureRecognizer.h>

#import "UPSpellLayout.h"
#import "UPSlider.h"

using UP::SpellLayout;

static UIBezierPath *SliderThumbFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(20.28, 0)];
    [path addCurveToPoint: CGPointMake(17.63, 1.05) controlPoint1: CGPointMake(19.12, 0) controlPoint2: CGPointMake(18.21, 0.69)];
    [path addCurveToPoint: CGPointMake(11.5, 6.66) controlPoint1: CGPointMake(15.36, 2.69) controlPoint2: CGPointMake(13.49, 4.73)];
    [path addCurveToPoint: CGPointMake(6.66, 11.5) controlPoint1: CGPointMake(9.89, 8.28) controlPoint2: CGPointMake(8.28, 9.89)];
    [path addCurveToPoint: CGPointMake(1.05, 17.63) controlPoint1: CGPointMake(4.73, 13.49) controlPoint2: CGPointMake(2.69, 15.36)];
    [path addCurveToPoint: CGPointMake(0.42, 21.82) controlPoint1: CGPointMake(0.53, 18.47) controlPoint2: CGPointMake(-0.61, 19.92)];
    [path addCurveToPoint: CGPointMake(2.69, 24.52) controlPoint1: CGPointMake(0.92, 22.73) controlPoint2: CGPointMake(1.85, 23.66)];
    [path addCurveToPoint: CGPointMake(15.48, 37.31) controlPoint1: CGPointMake(7.38, 29.21) controlPoint2: CGPointMake(10.78, 32.62)];
    [path addCurveToPoint: CGPointMake(18.18, 39.58) controlPoint1: CGPointMake(16.34, 38.15) controlPoint2: CGPointMake(17.26, 39.08)];
    [path addCurveToPoint: CGPointMake(19.72, 40) controlPoint1: CGPointMake(18.73, 39.88) controlPoint2: CGPointMake(19.24, 40)];
    [path addCurveToPoint: CGPointMake(22.36, 38.95) controlPoint1: CGPointMake(20.87, 40) controlPoint2: CGPointMake(21.78, 39.31)];
    [path addCurveToPoint: CGPointMake(28.01, 33.81) controlPoint1: CGPointMake(24.46, 37.45) controlPoint2: CGPointMake(26.19, 35.59)];
    [path addCurveToPoint: CGPointMake(33.81, 28.02) controlPoint1: CGPointMake(29.95, 31.88) controlPoint2: CGPointMake(31.88, 29.95)];
    [path addCurveToPoint: CGPointMake(37.75, 23.89) controlPoint1: CGPointMake(35.15, 26.67) controlPoint2: CGPointMake(36.49, 25.32)];
    [path addCurveToPoint: CGPointMake(39.82, 20.68) controlPoint1: CGPointMake(38.55, 22.92) controlPoint2: CGPointMake(39.38, 21.98)];
    [path addCurveToPoint: CGPointMake(39.58, 18.18) controlPoint1: CGPointMake(40, 20.05) controlPoint2: CGPointMake(40.2, 19.35)];
    [path addCurveToPoint: CGPointMake(37.3, 15.48) controlPoint1: CGPointMake(39.07, 17.27) controlPoint2: CGPointMake(38.14, 16.34)];
    [path addCurveToPoint: CGPointMake(24.51, 2.69) controlPoint1: CGPointMake(32.62, 10.79) controlPoint2: CGPointMake(29.21, 7.38)];
    [path addCurveToPoint: CGPointMake(21.82, 0.42) controlPoint1: CGPointMake(23.65, 1.85) controlPoint2: CGPointMake(22.73, 0.92)];
    [path addCurveToPoint: CGPointMake(20.28, 0) controlPoint1: CGPointMake(21.26, 0.12) controlPoint2: CGPointMake(20.75, 0)];
    [path closePath];
    [path moveToPoint: CGPointMake(20.21, 4.15)];
    [path addCurveToPoint: CGPointMake(21.49, 5.33) controlPoint1: CGPointMake(20.59, 4.45) controlPoint2: CGPointMake(21.1, 4.95)];
    [path addLineToPoint: CGPointMake(21.71, 5.54)];
    [path addCurveToPoint: CGPointMake(34.45, 18.29) controlPoint1: CGPointMake(26.38, 10.21) controlPoint2: CGPointMake(29.78, 13.61)];
    [path addLineToPoint: CGPointMake(34.67, 18.51)];
    [path addCurveToPoint: CGPointMake(35.85, 19.79) controlPoint1: CGPointMake(35.04, 18.89) controlPoint2: CGPointMake(35.55, 19.41)];
    [path addCurveToPoint: CGPointMake(34.85, 21.12) controlPoint1: CGPointMake(35.63, 20.18) controlPoint2: CGPointMake(35.27, 20.61)];
    [path addLineToPoint: CGPointMake(34.71, 21.29)];
    [path addCurveToPoint: CGPointMake(30.97, 25.19) controlPoint1: CGPointMake(33.52, 22.64) controlPoint2: CGPointMake(32.23, 23.94)];
    [path addCurveToPoint: CGPointMake(25.21, 30.95) controlPoint1: CGPointMake(29.05, 27.12) controlPoint2: CGPointMake(27.12, 29.05)];
    [path addCurveToPoint: CGPointMake(24.19, 31.96) controlPoint1: CGPointMake(24.87, 31.29) controlPoint2: CGPointMake(24.53, 31.63)];
    [path addCurveToPoint: CGPointMake(20.12, 35.63) controlPoint1: CGPointMake(22.82, 33.32) controlPoint2: CGPointMake(21.53, 34.61)];
    [path addCurveToPoint: CGPointMake(19.97, 35.73) controlPoint1: CGPointMake(20.07, 35.66) controlPoint2: CGPointMake(20.02, 35.7)];
    [path addCurveToPoint: CGPointMake(19.78, 35.85) controlPoint1: CGPointMake(19.91, 35.77) controlPoint2: CGPointMake(19.85, 35.81)];
    [path addCurveToPoint: CGPointMake(18.5, 34.67) controlPoint1: CGPointMake(19.4, 35.55) controlPoint2: CGPointMake(18.9, 35.05)];
    [path addLineToPoint: CGPointMake(18.28, 34.46)];
    [path addCurveToPoint: CGPointMake(5.54, 21.71) controlPoint1: CGPointMake(13.61, 29.79) controlPoint2: CGPointMake(10.21, 26.39)];
    [path addLineToPoint: CGPointMake(5.32, 21.49)];
    [path addCurveToPoint: CGPointMake(4.15, 20.22) controlPoint1: CGPointMake(4.96, 21.11) controlPoint2: CGPointMake(4.45, 20.59)];
    [path addCurveToPoint: CGPointMake(4.27, 20.03) controlPoint1: CGPointMake(4.19, 20.15) controlPoint2: CGPointMake(4.23, 20.08)];
    [path addCurveToPoint: CGPointMake(4.37, 19.88) controlPoint1: CGPointMake(4.3, 19.97) controlPoint2: CGPointMake(4.34, 19.93)];
    [path addCurveToPoint: CGPointMake(8.21, 15.63) controlPoint1: CGPointMake(5.44, 18.4) controlPoint2: CGPointMake(6.79, 17.05)];
    [path addCurveToPoint: CGPointMake(9.51, 14.31) controlPoint1: CGPointMake(8.64, 15.19) controlPoint2: CGPointMake(9.08, 14.76)];
    [path addCurveToPoint: CGPointMake(14.31, 9.51) controlPoint1: CGPointMake(11.11, 12.71) controlPoint2: CGPointMake(12.71, 11.11)];
    [path addCurveToPoint: CGPointMake(15.63, 8.2) controlPoint1: CGPointMake(14.76, 9.08) controlPoint2: CGPointMake(15.2, 8.64)];
    [path addCurveToPoint: CGPointMake(19.87, 4.37) controlPoint1: CGPointMake(17.06, 6.78) controlPoint2: CGPointMake(18.4, 5.44)];
    [path addCurveToPoint: CGPointMake(20.02, 4.27) controlPoint1: CGPointMake(19.92, 4.34) controlPoint2: CGPointMake(19.97, 4.3)];
    [path addCurveToPoint: CGPointMake(20.21, 4.15) controlPoint1: CGPointMake(20.08, 4.23) controlPoint2: CGPointMake(20.14, 4.19)];
    [path closePath];
    return path;
}

static UIBezierPath *SliderThumbStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(20.28, 0)];
    [path addCurveToPoint: CGPointMake(17.63, 1.05) controlPoint1: CGPointMake(19.12, 0) controlPoint2: CGPointMake(18.21, 0.69)];
    [path addCurveToPoint: CGPointMake(11.5, 6.66) controlPoint1: CGPointMake(15.36, 2.69) controlPoint2: CGPointMake(13.49, 4.73)];
    [path addCurveToPoint: CGPointMake(6.66, 11.5) controlPoint1: CGPointMake(9.89, 8.28) controlPoint2: CGPointMake(8.28, 9.89)];
    [path addCurveToPoint: CGPointMake(1.05, 17.63) controlPoint1: CGPointMake(4.73, 13.49) controlPoint2: CGPointMake(2.69, 15.36)];
    [path addCurveToPoint: CGPointMake(0.42, 21.82) controlPoint1: CGPointMake(0.53, 18.47) controlPoint2: CGPointMake(-0.61, 19.92)];
    [path addCurveToPoint: CGPointMake(2.69, 24.52) controlPoint1: CGPointMake(0.92, 22.73) controlPoint2: CGPointMake(1.85, 23.66)];
    [path addCurveToPoint: CGPointMake(15.48, 37.31) controlPoint1: CGPointMake(7.38, 29.21) controlPoint2: CGPointMake(10.79, 32.62)];
    [path addCurveToPoint: CGPointMake(18.18, 39.58) controlPoint1: CGPointMake(16.34, 38.15) controlPoint2: CGPointMake(17.26, 39.08)];
    [path addCurveToPoint: CGPointMake(19.72, 40) controlPoint1: CGPointMake(18.73, 39.88) controlPoint2: CGPointMake(19.24, 40)];
    [path addCurveToPoint: CGPointMake(22.37, 38.95) controlPoint1: CGPointMake(20.87, 40) controlPoint2: CGPointMake(21.78, 39.31)];
    [path addCurveToPoint: CGPointMake(28.01, 33.81) controlPoint1: CGPointMake(24.46, 37.45) controlPoint2: CGPointMake(26.19, 35.59)];
    [path addCurveToPoint: CGPointMake(33.81, 28.02) controlPoint1: CGPointMake(29.95, 31.88) controlPoint2: CGPointMake(31.88, 29.95)];
    [path addCurveToPoint: CGPointMake(37.75, 23.89) controlPoint1: CGPointMake(35.15, 26.67) controlPoint2: CGPointMake(36.49, 25.32)];
    [path addCurveToPoint: CGPointMake(39.82, 20.68) controlPoint1: CGPointMake(38.55, 22.92) controlPoint2: CGPointMake(39.38, 21.98)];
    [path addCurveToPoint: CGPointMake(39.58, 18.18) controlPoint1: CGPointMake(40, 20.05) controlPoint2: CGPointMake(40.2, 19.35)];
    [path addCurveToPoint: CGPointMake(37.3, 15.48) controlPoint1: CGPointMake(39.08, 17.27) controlPoint2: CGPointMake(38.14, 16.34)];
    [path addCurveToPoint: CGPointMake(24.52, 2.69) controlPoint1: CGPointMake(32.62, 10.79) controlPoint2: CGPointMake(29.21, 7.38)];
    [path addCurveToPoint: CGPointMake(21.82, 0.42) controlPoint1: CGPointMake(23.65, 1.85) controlPoint2: CGPointMake(22.73, 0.92)];
    [path addCurveToPoint: CGPointMake(20.28, 0) controlPoint1: CGPointMake(21.27, 0.12) controlPoint2: CGPointMake(20.75, 0)];
    [path closePath];
    [path moveToPoint: CGPointMake(20.27, 3)];
    [path addCurveToPoint: CGPointMake(20.37, 3.04) controlPoint1: CGPointMake(20.29, 3.01) controlPoint2: CGPointMake(20.32, 3.02)];
    [path addCurveToPoint: CGPointMake(22.19, 4.61) controlPoint1: CGPointMake(20.85, 3.31) controlPoint2: CGPointMake(21.56, 4)];
    [path addLineToPoint: CGPointMake(22.4, 4.81)];
    [path addCurveToPoint: CGPointMake(35.17, 17.59) controlPoint1: CGPointMake(27.08, 9.5) controlPoint2: CGPointMake(30.49, 12.9)];
    [path addLineToPoint: CGPointMake(35.4, 17.82)];
    [path addCurveToPoint: CGPointMake(36.93, 19.59) controlPoint1: CGPointMake(36, 18.45) controlPoint2: CGPointMake(36.69, 19.15)];
    [path addCurveToPoint: CGPointMake(36.98, 19.7) controlPoint1: CGPointMake(36.95, 19.63) controlPoint2: CGPointMake(36.97, 19.67)];
    [path addCurveToPoint: CGPointMake(36.96, 19.78) controlPoint1: CGPointMake(36.98, 19.72) controlPoint2: CGPointMake(36.97, 19.75)];
    [path addCurveToPoint: CGPointMake(35.63, 21.75) controlPoint1: CGPointMake(36.72, 20.43) controlPoint2: CGPointMake(36.24, 21.01)];
    [path addLineToPoint: CGPointMake(35.47, 21.94)];
    [path addCurveToPoint: CGPointMake(31.68, 25.9) controlPoint1: CGPointMake(34.27, 23.31) controlPoint2: CGPointMake(32.96, 24.62)];
    [path addCurveToPoint: CGPointMake(25.91, 31.67) controlPoint1: CGPointMake(29.76, 27.83) controlPoint2: CGPointMake(27.83, 29.76)];
    [path addCurveToPoint: CGPointMake(24.9, 32.67) controlPoint1: CGPointMake(25.57, 32) controlPoint2: CGPointMake(25.24, 32.34)];
    [path addCurveToPoint: CGPointMake(20.69, 36.46) controlPoint1: CGPointMake(23.49, 34.07) controlPoint2: CGPointMake(22.17, 35.39)];
    [path addCurveToPoint: CGPointMake(20.51, 36.57) controlPoint1: CGPointMake(20.63, 36.49) controlPoint2: CGPointMake(20.57, 36.53)];
    [path addCurveToPoint: CGPointMake(19.73, 37) controlPoint1: CGPointMake(20.29, 36.72) controlPoint2: CGPointMake(19.87, 36.99)];
    [path addCurveToPoint: CGPointMake(19.63, 36.96) controlPoint1: CGPointMake(19.73, 37) controlPoint2: CGPointMake(19.69, 36.99)];
    [path addCurveToPoint: CGPointMake(17.81, 35.39) controlPoint1: CGPointMake(19.15, 36.69) controlPoint2: CGPointMake(18.43, 36)];
    [path addLineToPoint: CGPointMake(17.6, 35.19)];
    [path addCurveToPoint: CGPointMake(4.85, 22.43) controlPoint1: CGPointMake(12.91, 30.5) controlPoint2: CGPointMake(9.5, 27.09)];
    [path addLineToPoint: CGPointMake(4.6, 22.19)];
    [path addCurveToPoint: CGPointMake(3.05, 20.39) controlPoint1: CGPointMake(4, 21.56) controlPoint2: CGPointMake(3.3, 20.85)];
    [path addCurveToPoint: CGPointMake(3, 20.28) controlPoint1: CGPointMake(3.01, 20.32) controlPoint2: CGPointMake(3, 20.28)];
    [path addCurveToPoint: CGPointMake(3.43, 19.48) controlPoint1: CGPointMake(3.02, 20.12) controlPoint2: CGPointMake(3.29, 19.71)];
    [path addLineToPoint: CGPointMake(3.53, 19.32)];
    [path addCurveToPoint: CGPointMake(7.5, 14.93) controlPoint1: CGPointMake(4.66, 17.77) controlPoint2: CGPointMake(6.04, 16.39)];
    [path addCurveToPoint: CGPointMake(8.78, 13.63) controlPoint1: CGPointMake(7.94, 14.48) controlPoint2: CGPointMake(8.38, 14.04)];
    [path addCurveToPoint: CGPointMake(13.59, 8.81) controlPoint1: CGPointMake(10.4, 12.01) controlPoint2: CGPointMake(12.01, 10.4)];
    [path addCurveToPoint: CGPointMake(14.93, 7.49) controlPoint1: CGPointMake(14.04, 8.38) controlPoint2: CGPointMake(14.48, 7.94)];
    [path addCurveToPoint: CGPointMake(19.31, 3.54) controlPoint1: CGPointMake(16.39, 6.04) controlPoint2: CGPointMake(17.76, 4.66)];
    [path addCurveToPoint: CGPointMake(19.48, 3.43) controlPoint1: CGPointMake(19.36, 3.51) controlPoint2: CGPointMake(19.42, 3.47)];
    [path addCurveToPoint: CGPointMake(20.27, 3) controlPoint1: CGPointMake(19.7, 3.29) controlPoint2: CGPointMake(20.1, 3.03)];
    [path closePath];
    return path;
}

static UIBezierPath *SliderThumbBackgroundPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(24.29, 3.56)];
    [path addCurveToPoint: CGPointMake(21.73, 1.39) controlPoint1: CGPointMake(23.47, 2.76) controlPoint2: CGPointMake(22.59, 1.87)];
    [path addCurveToPoint: CGPointMake(17.75, 2) controlPoint1: CGPointMake(19.92, 0.41) controlPoint2: CGPointMake(18.53, 1.51)];
    [path addCurveToPoint: CGPointMake(11.93, 7.33) controlPoint1: CGPointMake(15.59, 3.55) controlPoint2: CGPointMake(13.81, 5.5)];
    [path addCurveToPoint: CGPointMake(7.33, 11.93) controlPoint1: CGPointMake(10.4, 8.86) controlPoint2: CGPointMake(8.86, 10.4)];
    [path addCurveToPoint: CGPointMake(2, 17.75) controlPoint1: CGPointMake(5.5, 13.81) controlPoint2: CGPointMake(3.55, 15.59)];
    [path addCurveToPoint: CGPointMake(1.39, 21.73) controlPoint1: CGPointMake(1.5, 18.55) controlPoint2: CGPointMake(0.42, 19.93)];
    [path addCurveToPoint: CGPointMake(3.55, 24.29) controlPoint1: CGPointMake(1.87, 22.6) controlPoint2: CGPointMake(2.76, 23.47)];
    [path addCurveToPoint: CGPointMake(15.7, 36.45) controlPoint1: CGPointMake(8.01, 28.75) controlPoint2: CGPointMake(11.25, 31.99)];
    [path addCurveToPoint: CGPointMake(18.27, 38.61) controlPoint1: CGPointMake(16.52, 37.24) controlPoint2: CGPointMake(17.4, 38.13)];
    [path addCurveToPoint: CGPointMake(22.25, 38) controlPoint1: CGPointMake(20.07, 39.59) controlPoint2: CGPointMake(21.46, 38.49)];
    [path addCurveToPoint: CGPointMake(27.61, 33.12) controlPoint1: CGPointMake(24.23, 36.58) controlPoint2: CGPointMake(25.88, 34.81)];
    [path addCurveToPoint: CGPointMake(33.12, 27.61) controlPoint1: CGPointMake(29.45, 31.29) controlPoint2: CGPointMake(31.28, 29.45)];
    [path addCurveToPoint: CGPointMake(36.86, 23.69) controlPoint1: CGPointMake(34.39, 26.34) controlPoint2: CGPointMake(35.67, 25.06)];
    [path addCurveToPoint: CGPointMake(38.83, 20.65) controlPoint1: CGPointMake(37.62, 22.78) controlPoint2: CGPointMake(38.41, 21.88)];
    [path addCurveToPoint: CGPointMake(38.6, 18.27) controlPoint1: CGPointMake(39, 20.05) controlPoint2: CGPointMake(39.19, 19.38)];
    [path addCurveToPoint: CGPointMake(36.44, 15.71) controlPoint1: CGPointMake(38.12, 17.4) controlPoint2: CGPointMake(37.23, 16.53)];
    [path addCurveToPoint: CGPointMake(24.29, 3.56) controlPoint1: CGPointMake(31.98, 11.25) controlPoint2: CGPointMake(28.75, 8.01)];
    [path closePath];
    return path;
}

static UIBezierPath *SoundSliderTrackFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(434, 10)];
    [path addCurveToPoint: CGPointMake(431.5, 12.5) controlPoint1: CGPointMake(432.62, 10) controlPoint2: CGPointMake(431.5, 11.12)];
    [path addLineToPoint: CGPointMake(431.5, 17.5)];
    [path addLineToPoint: CGPointMake(376.83, 17.5)];
    [path addLineToPoint: CGPointMake(376.83, 12.5)];
    [path addCurveToPoint: CGPointMake(374.33, 10) controlPoint1: CGPointMake(376.83, 11.12) controlPoint2: CGPointMake(375.71, 10)];
    [path addCurveToPoint: CGPointMake(371.83, 12.5) controlPoint1: CGPointMake(372.95, 10) controlPoint2: CGPointMake(371.83, 11.12)];
    [path addLineToPoint: CGPointMake(371.83, 17.5)];
    [path addLineToPoint: CGPointMake(317.17, 17.5)];
    [path addLineToPoint: CGPointMake(317.17, 12.5)];
    [path addCurveToPoint: CGPointMake(314.67, 10) controlPoint1: CGPointMake(317.17, 11.12) controlPoint2: CGPointMake(316.05, 10)];
    [path addCurveToPoint: CGPointMake(312.17, 12.5) controlPoint1: CGPointMake(313.29, 10) controlPoint2: CGPointMake(312.17, 11.12)];
    [path addLineToPoint: CGPointMake(312.17, 17.5)];
    [path addLineToPoint: CGPointMake(257.5, 17.5)];
    [path addLineToPoint: CGPointMake(257.5, 12.5)];
    [path addCurveToPoint: CGPointMake(255, 10) controlPoint1: CGPointMake(257.5, 11.12) controlPoint2: CGPointMake(256.38, 10)];
    [path addCurveToPoint: CGPointMake(252.5, 12.5) controlPoint1: CGPointMake(253.62, 10) controlPoint2: CGPointMake(252.5, 11.12)];
    [path addLineToPoint: CGPointMake(252.5, 17.5)];
    [path addLineToPoint: CGPointMake(198.83, 17.5)];
    [path addLineToPoint: CGPointMake(198.83, 12.5)];
    [path addCurveToPoint: CGPointMake(196.33, 10) controlPoint1: CGPointMake(198.83, 11.12) controlPoint2: CGPointMake(197.71, 10)];
    [path addCurveToPoint: CGPointMake(193.83, 12.5) controlPoint1: CGPointMake(194.95, 10) controlPoint2: CGPointMake(193.83, 11.12)];
    [path addLineToPoint: CGPointMake(193.83, 17.5)];
    [path addLineToPoint: CGPointMake(140.17, 17.5)];
    [path addLineToPoint: CGPointMake(140.17, 12.5)];
    [path addCurveToPoint: CGPointMake(137.67, 10) controlPoint1: CGPointMake(140.17, 11.12) controlPoint2: CGPointMake(139.05, 10)];
    [path addCurveToPoint: CGPointMake(135.17, 12.5) controlPoint1: CGPointMake(136.29, 10) controlPoint2: CGPointMake(135.17, 11.12)];
    [path addLineToPoint: CGPointMake(135.17, 17.5)];
    [path addLineToPoint: CGPointMake(81.5, 17.5)];
    [path addLineToPoint: CGPointMake(81.5, 12.5)];
    [path addCurveToPoint: CGPointMake(79, 10) controlPoint1: CGPointMake(81.5, 11.12) controlPoint2: CGPointMake(80.38, 10)];
    [path addCurveToPoint: CGPointMake(76.5, 12.5) controlPoint1: CGPointMake(77.62, 10) controlPoint2: CGPointMake(76.5, 11.12)];
    [path addLineToPoint: CGPointMake(76.5, 27.5)];
    [path addCurveToPoint: CGPointMake(79, 30) controlPoint1: CGPointMake(76.5, 28.88) controlPoint2: CGPointMake(77.62, 30)];
    [path addCurveToPoint: CGPointMake(81.5, 27.5) controlPoint1: CGPointMake(80.38, 30) controlPoint2: CGPointMake(81.5, 28.88)];
    [path addLineToPoint: CGPointMake(81.5, 22.5)];
    [path addLineToPoint: CGPointMake(135.17, 22.5)];
    [path addLineToPoint: CGPointMake(135.17, 27.5)];
    [path addCurveToPoint: CGPointMake(137.67, 30) controlPoint1: CGPointMake(135.17, 28.88) controlPoint2: CGPointMake(136.29, 30)];
    [path addCurveToPoint: CGPointMake(140.17, 27.5) controlPoint1: CGPointMake(139.05, 30) controlPoint2: CGPointMake(140.17, 28.88)];
    [path addLineToPoint: CGPointMake(140.17, 22.5)];
    [path addLineToPoint: CGPointMake(193.83, 22.5)];
    [path addLineToPoint: CGPointMake(193.83, 27.5)];
    [path addCurveToPoint: CGPointMake(196.33, 30) controlPoint1: CGPointMake(193.83, 28.88) controlPoint2: CGPointMake(194.95, 30)];
    [path addCurveToPoint: CGPointMake(198.83, 27.5) controlPoint1: CGPointMake(197.71, 30) controlPoint2: CGPointMake(198.83, 28.88)];
    [path addLineToPoint: CGPointMake(198.83, 22.5)];
    [path addLineToPoint: CGPointMake(252.5, 22.5)];
    [path addLineToPoint: CGPointMake(252.5, 27.5)];
    [path addCurveToPoint: CGPointMake(255, 30) controlPoint1: CGPointMake(252.5, 28.88) controlPoint2: CGPointMake(253.62, 30)];
    [path addCurveToPoint: CGPointMake(257.5, 27.5) controlPoint1: CGPointMake(256.38, 30) controlPoint2: CGPointMake(257.5, 28.88)];
    [path addLineToPoint: CGPointMake(257.5, 22.5)];
    [path addLineToPoint: CGPointMake(312.17, 22.5)];
    [path addLineToPoint: CGPointMake(312.17, 27.5)];
    [path addCurveToPoint: CGPointMake(314.67, 30) controlPoint1: CGPointMake(312.17, 28.88) controlPoint2: CGPointMake(313.29, 30)];
    [path addCurveToPoint: CGPointMake(317.17, 27.5) controlPoint1: CGPointMake(316.05, 30) controlPoint2: CGPointMake(317.17, 28.88)];
    [path addLineToPoint: CGPointMake(317.17, 22.5)];
    [path addLineToPoint: CGPointMake(371.83, 22.5)];
    [path addLineToPoint: CGPointMake(371.83, 27.5)];
    [path addCurveToPoint: CGPointMake(374.33, 30) controlPoint1: CGPointMake(371.83, 28.88) controlPoint2: CGPointMake(372.95, 30)];
    [path addCurveToPoint: CGPointMake(376.83, 27.5) controlPoint1: CGPointMake(375.71, 30) controlPoint2: CGPointMake(376.83, 28.88)];
    [path addLineToPoint: CGPointMake(376.83, 22.5)];
    [path addLineToPoint: CGPointMake(431.5, 22.5)];
    [path addLineToPoint: CGPointMake(431.5, 27.5)];
    [path addCurveToPoint: CGPointMake(434, 30) controlPoint1: CGPointMake(431.5, 28.88) controlPoint2: CGPointMake(432.62, 30)];
    [path addCurveToPoint: CGPointMake(436.5, 27.5) controlPoint1: CGPointMake(435.38, 30) controlPoint2: CGPointMake(436.5, 28.88)];
    [path addLineToPoint: CGPointMake(436.5, 12.5)];
    [path addCurveToPoint: CGPointMake(434, 10) controlPoint1: CGPointMake(436.5, 11.12) controlPoint2: CGPointMake(435.38, 10)];
    [path closePath];
    return path;
}

static UIBezierPath *SoundSliderTrackStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(434, 10.5)];
    [path addCurveToPoint: CGPointMake(432, 12.5) controlPoint1: CGPointMake(432.9, 10.5) controlPoint2: CGPointMake(432, 11.4)];
    [path addLineToPoint: CGPointMake(432, 18)];
    [path addLineToPoint: CGPointMake(376.33, 18)];
    [path addLineToPoint: CGPointMake(376.33, 12.5)];
    [path addCurveToPoint: CGPointMake(374.33, 10.5) controlPoint1: CGPointMake(376.33, 11.4) controlPoint2: CGPointMake(375.44, 10.5)];
    [path addCurveToPoint: CGPointMake(372.33, 12.5) controlPoint1: CGPointMake(373.23, 10.5) controlPoint2: CGPointMake(372.33, 11.4)];
    [path addLineToPoint: CGPointMake(372.33, 18)];
    [path addLineToPoint: CGPointMake(316.67, 18)];
    [path addLineToPoint: CGPointMake(316.67, 12.5)];
    [path addCurveToPoint: CGPointMake(314.67, 10.5) controlPoint1: CGPointMake(316.67, 11.4) controlPoint2: CGPointMake(315.77, 10.5)];
    [path addCurveToPoint: CGPointMake(312.67, 12.5) controlPoint1: CGPointMake(313.56, 10.5) controlPoint2: CGPointMake(312.67, 11.4)];
    [path addLineToPoint: CGPointMake(312.67, 18)];
    [path addLineToPoint: CGPointMake(257, 18)];
    [path addLineToPoint: CGPointMake(257, 12.5)];
    [path addCurveToPoint: CGPointMake(255, 10.5) controlPoint1: CGPointMake(257, 11.4) controlPoint2: CGPointMake(256.1, 10.5)];
    [path addCurveToPoint: CGPointMake(253, 12.5) controlPoint1: CGPointMake(253.9, 10.5) controlPoint2: CGPointMake(253, 11.4)];
    [path addLineToPoint: CGPointMake(253, 18)];
    [path addLineToPoint: CGPointMake(198.33, 18)];
    [path addLineToPoint: CGPointMake(198.33, 12.5)];
    [path addCurveToPoint: CGPointMake(196.33, 10.5) controlPoint1: CGPointMake(198.33, 11.4) controlPoint2: CGPointMake(197.44, 10.5)];
    [path addCurveToPoint: CGPointMake(194.33, 12.5) controlPoint1: CGPointMake(195.23, 10.5) controlPoint2: CGPointMake(194.33, 11.4)];
    [path addLineToPoint: CGPointMake(194.33, 18)];
    [path addLineToPoint: CGPointMake(139.67, 18)];
    [path addLineToPoint: CGPointMake(139.67, 12.5)];
    [path addCurveToPoint: CGPointMake(137.67, 10.5) controlPoint1: CGPointMake(139.67, 11.4) controlPoint2: CGPointMake(138.77, 10.5)];
    [path addCurveToPoint: CGPointMake(135.67, 12.5) controlPoint1: CGPointMake(136.56, 10.5) controlPoint2: CGPointMake(135.67, 11.4)];
    [path addLineToPoint: CGPointMake(135.67, 18)];
    [path addLineToPoint: CGPointMake(81, 18)];
    [path addLineToPoint: CGPointMake(81, 12.5)];
    [path addCurveToPoint: CGPointMake(79, 10.5) controlPoint1: CGPointMake(81, 11.4) controlPoint2: CGPointMake(80.1, 10.5)];
    [path addCurveToPoint: CGPointMake(77, 12.5) controlPoint1: CGPointMake(77.9, 10.5) controlPoint2: CGPointMake(77, 11.4)];
    [path addLineToPoint: CGPointMake(77, 27.5)];
    [path addCurveToPoint: CGPointMake(79, 29.5) controlPoint1: CGPointMake(77, 28.6) controlPoint2: CGPointMake(77.9, 29.5)];
    [path addCurveToPoint: CGPointMake(81, 27.5) controlPoint1: CGPointMake(80.1, 29.5) controlPoint2: CGPointMake(81, 28.6)];
    [path addLineToPoint: CGPointMake(81, 22)];
    [path addLineToPoint: CGPointMake(135.67, 22)];
    [path addLineToPoint: CGPointMake(135.67, 27.5)];
    [path addCurveToPoint: CGPointMake(137.67, 29.5) controlPoint1: CGPointMake(135.67, 28.6) controlPoint2: CGPointMake(136.56, 29.5)];
    [path addCurveToPoint: CGPointMake(139.67, 27.5) controlPoint1: CGPointMake(138.77, 29.5) controlPoint2: CGPointMake(139.67, 28.6)];
    [path addLineToPoint: CGPointMake(139.67, 22)];
    [path addLineToPoint: CGPointMake(194.33, 22)];
    [path addLineToPoint: CGPointMake(194.33, 27.5)];
    [path addCurveToPoint: CGPointMake(196.33, 29.5) controlPoint1: CGPointMake(194.33, 28.6) controlPoint2: CGPointMake(195.23, 29.5)];
    [path addCurveToPoint: CGPointMake(198.33, 27.5) controlPoint1: CGPointMake(197.44, 29.5) controlPoint2: CGPointMake(198.33, 28.6)];
    [path addLineToPoint: CGPointMake(198.33, 22)];
    [path addLineToPoint: CGPointMake(253, 22)];
    [path addLineToPoint: CGPointMake(253, 27.5)];
    [path addCurveToPoint: CGPointMake(255, 29.5) controlPoint1: CGPointMake(253, 28.6) controlPoint2: CGPointMake(253.9, 29.5)];
    [path addCurveToPoint: CGPointMake(257, 27.5) controlPoint1: CGPointMake(256.1, 29.5) controlPoint2: CGPointMake(257, 28.6)];
    [path addLineToPoint: CGPointMake(257, 22)];
    [path addLineToPoint: CGPointMake(312.67, 22)];
    [path addLineToPoint: CGPointMake(312.67, 27.5)];
    [path addCurveToPoint: CGPointMake(314.67, 29.5) controlPoint1: CGPointMake(312.67, 28.6) controlPoint2: CGPointMake(313.56, 29.5)];
    [path addCurveToPoint: CGPointMake(316.67, 27.5) controlPoint1: CGPointMake(315.77, 29.5) controlPoint2: CGPointMake(316.67, 28.6)];
    [path addLineToPoint: CGPointMake(316.67, 22)];
    [path addLineToPoint: CGPointMake(372.33, 22)];
    [path addLineToPoint: CGPointMake(372.33, 27.5)];
    [path addCurveToPoint: CGPointMake(374.33, 29.5) controlPoint1: CGPointMake(372.33, 28.6) controlPoint2: CGPointMake(373.23, 29.5)];
    [path addCurveToPoint: CGPointMake(376.33, 27.5) controlPoint1: CGPointMake(375.44, 29.5) controlPoint2: CGPointMake(376.33, 28.6)];
    [path addLineToPoint: CGPointMake(376.33, 22)];
    [path addLineToPoint: CGPointMake(432, 22)];
    [path addLineToPoint: CGPointMake(432, 27.5)];
    [path addCurveToPoint: CGPointMake(434, 29.5) controlPoint1: CGPointMake(432, 28.6) controlPoint2: CGPointMake(432.9, 29.5)];
    [path addCurveToPoint: CGPointMake(436, 27.5) controlPoint1: CGPointMake(435.1, 29.5) controlPoint2: CGPointMake(436, 28.6)];
    [path addLineToPoint: CGPointMake(436, 12.5)];
    [path addCurveToPoint: CGPointMake(434, 10.5) controlPoint1: CGPointMake(436, 11.4) controlPoint2: CGPointMake(435.1, 10.5)];
    [path closePath];
    return path;
}

static UIBezierPath *SoundSliderFilledIcons()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(469.5, 14.5)];
    [path addLineToPoint: CGPointMake(465.75, 14.5)];
    [path addLineToPoint: CGPointMake(465.75, 25.5)];
    [path addLineToPoint: CGPointMake(469.5, 25.5)];
    [path addLineToPoint: CGPointMake(477.5, 32.5)];
    [path addLineToPoint: CGPointMake(477.5, 7.5)];
    [path addLineToPoint: CGPointMake(469.5, 14.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(497.75, 37.5)];
    [path addCurveToPoint: CGPointMake(497.17, 37.38) controlPoint1: CGPointMake(497.56, 37.5) controlPoint2: CGPointMake(497.36, 37.46)];
    [path addCurveToPoint: CGPointMake(496.37, 35.42) controlPoint1: CGPointMake(496.41, 37.06) controlPoint2: CGPointMake(496.05, 36.18)];
    [path addCurveToPoint: CGPointMake(499.25, 20) controlPoint1: CGPointMake(498.25, 30.93) controlPoint2: CGPointMake(499.25, 25.59)];
    [path addCurveToPoint: CGPointMake(496.37, 4.58) controlPoint1: CGPointMake(499.25, 14.41) controlPoint2: CGPointMake(498.25, 9.07)];
    [path addCurveToPoint: CGPointMake(497.17, 2.62) controlPoint1: CGPointMake(496.05, 3.82) controlPoint2: CGPointMake(496.41, 2.94)];
    [path addCurveToPoint: CGPointMake(499.13, 3.42) controlPoint1: CGPointMake(497.94, 2.3) controlPoint2: CGPointMake(498.81, 2.66)];
    [path addCurveToPoint: CGPointMake(502.25, 20) controlPoint1: CGPointMake(501.17, 8.28) controlPoint2: CGPointMake(502.25, 14.01)];
    [path addCurveToPoint: CGPointMake(499.13, 36.58) controlPoint1: CGPointMake(502.25, 25.99) controlPoint2: CGPointMake(501.17, 31.72)];
    [path addCurveToPoint: CGPointMake(497.75, 37.5) controlPoint1: CGPointMake(498.89, 37.15) controlPoint2: CGPointMake(498.34, 37.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(490.75, 34)];
    [path addCurveToPoint: CGPointMake(490.04, 33.82) controlPoint1: CGPointMake(490.51, 34) controlPoint2: CGPointMake(490.27, 33.94)];
    [path addCurveToPoint: CGPointMake(489.43, 31.79) controlPoint1: CGPointMake(489.31, 33.43) controlPoint2: CGPointMake(489.04, 32.52)];
    [path addCurveToPoint: CGPointMake(492.25, 20) controlPoint1: CGPointMake(491.27, 28.35) controlPoint2: CGPointMake(492.25, 24.28)];
    [path addCurveToPoint: CGPointMake(489.43, 8.21) controlPoint1: CGPointMake(492.25, 15.72) controlPoint2: CGPointMake(491.27, 11.65)];
    [path addCurveToPoint: CGPointMake(490.04, 6.18) controlPoint1: CGPointMake(489.04, 7.48) controlPoint2: CGPointMake(489.31, 6.57)];
    [path addCurveToPoint: CGPointMake(492.07, 6.79) controlPoint1: CGPointMake(490.77, 5.79) controlPoint2: CGPointMake(491.68, 6.06)];
    [path addCurveToPoint: CGPointMake(495.25, 20) controlPoint1: CGPointMake(494.15, 10.66) controlPoint2: CGPointMake(495.25, 15.23)];
    [path addCurveToPoint: CGPointMake(492.07, 33.21) controlPoint1: CGPointMake(495.25, 24.77) controlPoint2: CGPointMake(494.15, 29.34)];
    [path addCurveToPoint: CGPointMake(490.75, 34) controlPoint1: CGPointMake(491.8, 33.71) controlPoint2: CGPointMake(491.28, 34)];
    [path closePath];
    [path moveToPoint: CGPointMake(484.75, 30.5)];
    [path addCurveToPoint: CGPointMake(484.08, 30.34) controlPoint1: CGPointMake(484.52, 30.5) controlPoint2: CGPointMake(484.3, 30.45)];
    [path addCurveToPoint: CGPointMake(483.41, 28.33) controlPoint1: CGPointMake(483.34, 29.97) controlPoint2: CGPointMake(483.04, 29.07)];
    [path addCurveToPoint: CGPointMake(485.25, 20) controlPoint1: CGPointMake(484.61, 25.91) controlPoint2: CGPointMake(485.25, 23.03)];
    [path addCurveToPoint: CGPointMake(483.41, 11.67) controlPoint1: CGPointMake(485.25, 16.97) controlPoint2: CGPointMake(484.61, 14.09)];
    [path addCurveToPoint: CGPointMake(484.08, 9.66) controlPoint1: CGPointMake(483.04, 10.93) controlPoint2: CGPointMake(483.34, 10.03)];
    [path addCurveToPoint: CGPointMake(486.09, 10.33) controlPoint1: CGPointMake(484.82, 9.29) controlPoint2: CGPointMake(485.72, 9.59)];
    [path addCurveToPoint: CGPointMake(488.25, 20) controlPoint1: CGPointMake(487.5, 13.17) controlPoint2: CGPointMake(488.25, 16.51)];
    [path addCurveToPoint: CGPointMake(486.09, 29.67) controlPoint1: CGPointMake(488.25, 23.49) controlPoint2: CGPointMake(487.5, 26.83)];
    [path addCurveToPoint: CGPointMake(484.75, 30.5) controlPoint1: CGPointMake(485.83, 30.19) controlPoint2: CGPointMake(485.3, 30.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(27.5, 14.5)];
    [path addLineToPoint: CGPointMake(23.75, 14.5)];
    [path addLineToPoint: CGPointMake(23.75, 25.5)];
    [path addLineToPoint: CGPointMake(27.5, 25.5)];
    [path addLineToPoint: CGPointMake(35.5, 32.5)];
    [path addLineToPoint: CGPointMake(35.5, 7.5)];
    [path addLineToPoint: CGPointMake(27.5, 14.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(42.75, 30.5)];
    [path addCurveToPoint: CGPointMake(42.08, 30.34) controlPoint1: CGPointMake(42.52, 30.5) controlPoint2: CGPointMake(42.3, 30.45)];
    [path addCurveToPoint: CGPointMake(41.41, 28.33) controlPoint1: CGPointMake(41.34, 29.97) controlPoint2: CGPointMake(41.04, 29.07)];
    [path addCurveToPoint: CGPointMake(43.25, 20) controlPoint1: CGPointMake(42.61, 25.91) controlPoint2: CGPointMake(43.25, 23.03)];
    [path addCurveToPoint: CGPointMake(41.41, 11.67) controlPoint1: CGPointMake(43.25, 16.97) controlPoint2: CGPointMake(42.61, 14.09)];
    [path addCurveToPoint: CGPointMake(42.08, 9.66) controlPoint1: CGPointMake(41.04, 10.93) controlPoint2: CGPointMake(41.34, 10.03)];
    [path addCurveToPoint: CGPointMake(44.09, 10.33) controlPoint1: CGPointMake(42.82, 9.29) controlPoint2: CGPointMake(43.73, 9.59)];
    [path addCurveToPoint: CGPointMake(46.25, 20) controlPoint1: CGPointMake(45.5, 13.17) controlPoint2: CGPointMake(46.25, 16.51)];
    [path addCurveToPoint: CGPointMake(44.09, 29.67) controlPoint1: CGPointMake(46.25, 23.49) controlPoint2: CGPointMake(45.5, 26.83)];
    [path addCurveToPoint: CGPointMake(42.75, 30.5) controlPoint1: CGPointMake(43.83, 30.19) controlPoint2: CGPointMake(43.3, 30.5)];
    [path closePath];
    return path;
}

static UIBezierPath *SoundSliderStrokedIcons()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(469.5, 14.5)];
    [path addLineToPoint: CGPointMake(465.75, 14.5)];
    [path addLineToPoint: CGPointMake(465.75, 25.5)];
    [path addLineToPoint: CGPointMake(469.5, 25.5)];
    [path addLineToPoint: CGPointMake(477.5, 32.5)];
    [path addLineToPoint: CGPointMake(477.5, 7.5)];
    [path addLineToPoint: CGPointMake(469.5, 14.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(497.75, 37.5)];
    [path addCurveToPoint: CGPointMake(497.17, 37.38) controlPoint1: CGPointMake(497.56, 37.5) controlPoint2: CGPointMake(497.36, 37.46)];
    [path addCurveToPoint: CGPointMake(496.37, 35.42) controlPoint1: CGPointMake(496.41, 37.06) controlPoint2: CGPointMake(496.05, 36.18)];
    [path addCurveToPoint: CGPointMake(499.25, 20) controlPoint1: CGPointMake(498.25, 30.93) controlPoint2: CGPointMake(499.25, 25.59)];
    [path addCurveToPoint: CGPointMake(496.37, 4.58) controlPoint1: CGPointMake(499.25, 14.41) controlPoint2: CGPointMake(498.25, 9.07)];
    [path addCurveToPoint: CGPointMake(497.17, 2.62) controlPoint1: CGPointMake(496.05, 3.82) controlPoint2: CGPointMake(496.41, 2.94)];
    [path addCurveToPoint: CGPointMake(499.13, 3.42) controlPoint1: CGPointMake(497.94, 2.3) controlPoint2: CGPointMake(498.81, 2.66)];
    [path addCurveToPoint: CGPointMake(502.25, 20) controlPoint1: CGPointMake(501.17, 8.28) controlPoint2: CGPointMake(502.25, 14.01)];
    [path addCurveToPoint: CGPointMake(499.13, 36.58) controlPoint1: CGPointMake(502.25, 25.99) controlPoint2: CGPointMake(501.17, 31.72)];
    [path addCurveToPoint: CGPointMake(497.75, 37.5) controlPoint1: CGPointMake(498.89, 37.15) controlPoint2: CGPointMake(498.34, 37.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(490.75, 34)];
    [path addCurveToPoint: CGPointMake(490.04, 33.82) controlPoint1: CGPointMake(490.51, 34) controlPoint2: CGPointMake(490.27, 33.94)];
    [path addCurveToPoint: CGPointMake(489.43, 31.79) controlPoint1: CGPointMake(489.31, 33.43) controlPoint2: CGPointMake(489.04, 32.52)];
    [path addCurveToPoint: CGPointMake(492.25, 20) controlPoint1: CGPointMake(491.27, 28.35) controlPoint2: CGPointMake(492.25, 24.28)];
    [path addCurveToPoint: CGPointMake(489.43, 8.21) controlPoint1: CGPointMake(492.25, 15.72) controlPoint2: CGPointMake(491.27, 11.65)];
    [path addCurveToPoint: CGPointMake(490.04, 6.18) controlPoint1: CGPointMake(489.04, 7.48) controlPoint2: CGPointMake(489.31, 6.57)];
    [path addCurveToPoint: CGPointMake(492.07, 6.79) controlPoint1: CGPointMake(490.77, 5.79) controlPoint2: CGPointMake(491.68, 6.06)];
    [path addCurveToPoint: CGPointMake(495.25, 20) controlPoint1: CGPointMake(494.15, 10.66) controlPoint2: CGPointMake(495.25, 15.23)];
    [path addCurveToPoint: CGPointMake(492.07, 33.21) controlPoint1: CGPointMake(495.25, 24.77) controlPoint2: CGPointMake(494.15, 29.34)];
    [path addCurveToPoint: CGPointMake(490.75, 34) controlPoint1: CGPointMake(491.8, 33.71) controlPoint2: CGPointMake(491.28, 34)];
    [path closePath];
    [path moveToPoint: CGPointMake(484.75, 30.5)];
    [path addCurveToPoint: CGPointMake(484.08, 30.34) controlPoint1: CGPointMake(484.52, 30.5) controlPoint2: CGPointMake(484.3, 30.45)];
    [path addCurveToPoint: CGPointMake(483.41, 28.33) controlPoint1: CGPointMake(483.34, 29.97) controlPoint2: CGPointMake(483.04, 29.07)];
    [path addCurveToPoint: CGPointMake(485.25, 20) controlPoint1: CGPointMake(484.61, 25.91) controlPoint2: CGPointMake(485.25, 23.03)];
    [path addCurveToPoint: CGPointMake(483.41, 11.67) controlPoint1: CGPointMake(485.25, 16.97) controlPoint2: CGPointMake(484.61, 14.09)];
    [path addCurveToPoint: CGPointMake(484.08, 9.66) controlPoint1: CGPointMake(483.04, 10.93) controlPoint2: CGPointMake(483.34, 10.03)];
    [path addCurveToPoint: CGPointMake(486.09, 10.33) controlPoint1: CGPointMake(484.82, 9.29) controlPoint2: CGPointMake(485.72, 9.59)];
    [path addCurveToPoint: CGPointMake(488.25, 20) controlPoint1: CGPointMake(487.5, 13.17) controlPoint2: CGPointMake(488.25, 16.51)];
    [path addCurveToPoint: CGPointMake(486.09, 29.67) controlPoint1: CGPointMake(488.25, 23.49) controlPoint2: CGPointMake(487.5, 26.83)];
    [path addCurveToPoint: CGPointMake(484.75, 30.5) controlPoint1: CGPointMake(485.83, 30.19) controlPoint2: CGPointMake(485.3, 30.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(27.5, 14.5)];
    [path addLineToPoint: CGPointMake(23.75, 14.5)];
    [path addLineToPoint: CGPointMake(23.75, 25.5)];
    [path addLineToPoint: CGPointMake(27.5, 25.5)];
    [path addLineToPoint: CGPointMake(35.5, 32.5)];
    [path addLineToPoint: CGPointMake(35.5, 7.5)];
    [path addLineToPoint: CGPointMake(27.5, 14.5)];
    [path closePath];
    [path moveToPoint: CGPointMake(42.75, 30.5)];
    [path addCurveToPoint: CGPointMake(42.08, 30.34) controlPoint1: CGPointMake(42.52, 30.5) controlPoint2: CGPointMake(42.3, 30.45)];
    [path addCurveToPoint: CGPointMake(41.41, 28.33) controlPoint1: CGPointMake(41.34, 29.97) controlPoint2: CGPointMake(41.04, 29.07)];
    [path addCurveToPoint: CGPointMake(43.25, 20) controlPoint1: CGPointMake(42.61, 25.91) controlPoint2: CGPointMake(43.25, 23.03)];
    [path addCurveToPoint: CGPointMake(41.41, 11.67) controlPoint1: CGPointMake(43.25, 16.97) controlPoint2: CGPointMake(42.61, 14.09)];
    [path addCurveToPoint: CGPointMake(42.08, 9.66) controlPoint1: CGPointMake(41.04, 10.93) controlPoint2: CGPointMake(41.34, 10.03)];
    [path addCurveToPoint: CGPointMake(44.09, 10.33) controlPoint1: CGPointMake(42.82, 9.29) controlPoint2: CGPointMake(43.73, 9.59)];
    [path addCurveToPoint: CGPointMake(46.25, 20) controlPoint1: CGPointMake(45.5, 13.17) controlPoint2: CGPointMake(46.25, 16.51)];
    [path addCurveToPoint: CGPointMake(44.09, 29.67) controlPoint1: CGPointMake(46.25, 23.49) controlPoint2: CGPointMake(45.5, 26.83)];
    [path addCurveToPoint: CGPointMake(42.75, 30.5) controlPoint1: CGPointMake(43.83, 30.19) controlPoint2: CGPointMake(43.3, 30.5)];
    [path closePath];
    return path;
}

@interface UPSlider ()
@property (nonatomic, readwrite) BOOL discrete;
@property (nonatomic, readwrite) NSUInteger marks;
@property (nonatomic, readwrite) NSUInteger valueAsMark;
@property (nonatomic, readwrite) CGFloat valueAsFraction;
@property (nonatomic, readwrite) UPSlideGestureRecognizer *slideGesture;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;

@property (nonatomic) UPControl *thumbControl;

@end

@implementation UPSlider

+ (UPSlider *)discreteSliderWithMarks:(NSUInteger)marks
{
    return [[UPSlider alloc] initWithDiscrete:YES marks:marks];
}

+ (UPSlider *)continuousSliderWithMarks:(NSUInteger)marks
{
    return [[UPSlider alloc] initWithDiscrete:NO marks:marks];
}

- (instancetype)initWithDiscrete:(BOOL)discrete marks:(NSUInteger)marks
{
    self = [super initWithFrame:CGRectZero];
    self.discrete = discrete;
    self.marks = marks;

    SpellLayout &layout = SpellLayout::instance();
    
    self.canonicalSize = SpellLayout::CanonicalSliderSize;
    self.chargeOutsets = layout.ballot_control_charge_outsets();

    self.slideGesture = [UPSlideGestureRecognizer gestureWithTarget:self action:@selector(handleSlide:)];
    [self addGestureRecognizer:self.slideGesture];

    [self setFillPath:SoundSliderTrackFillPath() forState:UPControlStateNormal];
    [self setFillColorCategory:UPColorCategoryControlShapeFill forState:UPControlStateNormal];
    [self setFillColorCategory:UPColorCategoryControlShapeInactiveFill forState:UPControlStateDisabled];

    [self setStrokePath:SoundSliderTrackStrokePath() forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryControlShapeStroke forState:UPControlStateNormal];
    [self setStrokeColorCategory:UPColorCategoryControlShapeInactiveStroke forState:UPControlStateDisabled];

    [self setAuxiliaryPath:SoundSliderFilledIcons()];
    [self setAuxiliaryColorCategory:UPColorCategoryControlAccentFill forState:UPControlStateNormal];
    [self setAuxiliaryColorCategory:UPColorCategoryControlShapeInactiveFill forState:UPControlStateDisabled];

    [self setAccentPath:SoundSliderStrokedIcons()];
    [self setAccentColorCategory:UPColorCategoryControlAccentStroke forState:UPControlStateNormal];
    [self setAccentColorCategory:UPColorCategoryControlShapeInactiveStroke forState:UPControlStateDisabled];

    self.thumbControl = [UPControl control];
    self.thumbControl.autoSelects = NO;
    self.thumbControl.autoHighlights = NO;
    self.thumbControl.userInteractionEnabled = NO;
    self.thumbControl.canonicalSize = SpellLayout::CanonicalSliderThumbSize;
    [self addSubview:self.thumbControl];

    [self.thumbControl setFillPath:SliderThumbFillPath()];
    [self.thumbControl setStrokePath:SliderThumbStrokePath()];
    [self.thumbControl setAuxiliaryPath:SliderThumbBackgroundPath()];

    [self.thumbControl setFillColorCategory:UPColorCategoryControlAccentFill];
    [self.thumbControl setFillColorCategory:UPColorCategoryControlAccentInactiveFill forState:UPControlStateDisabled];
    [self.thumbControl setStrokeColorCategory:UPColorCategoryControlAccentStroke];
    [self.thumbControl setStrokeColorCategory:UPColorCategoryControlAccentInactiveStroke forState:UPControlStateDisabled];
    [self.thumbControl setAuxiliaryColorCategory:UPColorCategoryInfinity forState:UPControlStateNormal];
    [self.thumbControl setAuxiliaryColorCategory:UPColorCategoryHighlightedFill forState:UPControlStateHighlighted];
    [self.thumbControl sendPathViewToBack:self.thumbControl.auxiliaryPathView];

    [self updateThemeColors];
    
    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setMarkValue:(NSUInteger)markValue
{
    self.valueAsMark = UPClampT(NSUInteger, markValue, 0, self.marks);
    self.valueAsFraction = self.marks > 0 ? (self.valueAsMark / (CGFloat)self.marks) : 0.0;
    [self setNeedsLayout];
}

- (void)setFractionValue:(CGFloat)fractionValue
{
    self.valueAsFraction = UPClampT(CGFloat, fractionValue, 0.0, 1.0);
    if (self.marks == 0) {
        self.valueAsMark = 0;
    }
    else {
        self.valueAsMark = (NSUInteger)round(self.valueAsFraction * self.marks);
    }
    [self setNeedsLayout];
}

- (void)handleSlide:(UPSlideGestureRecognizer *)gesture
{
    if (!self.enabled) {
        return;
    }

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            [self.thumbControl setHighlighted:YES];
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self.thumbControl setHighlighted:NO];
            break;
    }
    
    CGRect bounds = self.bounds;
    CGFloat scale = up_rect_width(bounds) / up_size_width(SpellLayout::CanonicalSliderSize);
    constexpr CGFloat CanonicalTrackWidth = up_size_width(SpellLayout::CanonicalSliderSize) - (SpellLayout::CanonicalSliderIconInset * 2);
    CGFloat scaledTrackWidth = CanonicalTrackWidth * scale;
    CGFloat scaledInset = SpellLayout::CanonicalSliderIconInset * scale;

    CGPoint point = gesture.locationInView;
    CGFloat x = point.x - scaledInset;

    self.valueAsFraction = UPClampT(CGFloat, x / scaledTrackWidth, 0.0, 1.0);
    if (self.marks == 0) {
        self.valueAsMark = 0;
    }
    else {
        self.valueAsMark = (NSUInteger)round(self.valueAsFraction * self.marks);
    }
    
    [self setNeedsLayout];

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
}

#pragma mark - UPControl overrides

- (void)setDisabled:(BOOL)disabled
{
    [super setDisabled:disabled];
    self.thumbControl.enabled = !disabled;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat scale = up_rect_width(bounds) / up_size_width(SpellLayout::CanonicalSliderSize);
    constexpr CGFloat CanonicalTrackWidth = up_size_width(SpellLayout::CanonicalSliderSize) - (SpellLayout::CanonicalSliderIconInset * 2);
    CGFloat scaledTrackWidth = CanonicalTrackWidth * scale;
    CGFloat scaledInset = SpellLayout::CanonicalSliderIconInset * scale;
    CGRect thumbBounds = self.thumbControl.bounds;
    
    if (self.discrete) {
        CGFloat fraction = self.marks > 0 ? (self.valueAsMark / (CGFloat)self.marks) : 0.0;
        CGFloat x = scaledInset + (fraction * scaledTrackWidth);
        x -= up_rect_width(thumbBounds) * 0.5;
        self.thumbControl.frame = CGRectMake(x, 0, up_rect_height(bounds), up_rect_height(bounds));
    }
    else {
        CGFloat x = scaledInset + (self.valueAsFraction * scaledTrackWidth);
        x -= up_rect_width(thumbBounds) * 0.5;
        self.thumbControl.frame = CGRectMake(x, 0, up_rect_height(bounds), up_rect_height(bounds));
    }
    
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.thumbControl updateThemeColors];
}

@end
