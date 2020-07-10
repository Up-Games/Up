//
//  UPRotor.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UPGeometry.h>

#import "UIFont+UPSpell.h"
#import "UPRotor.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

static UIBezierPath *RotorBezelPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(46.99, 148.38)];
    [path addCurveToPoint: CGPointMake(46.14, 186.58) controlPoint1: CGPointMake(46.97, 161.12) controlPoint2: CGPointMake(46.99, 173.86)];
    [path addCurveToPoint: CGPointMake(44.78, 197.91) controlPoint1: CGPointMake(45.88, 190.38) controlPoint2: CGPointMake(45.52, 194.16)];
    [path addCurveToPoint: CGPointMake(42.5, 204.86) controlPoint1: CGPointMake(44.3, 200.31) controlPoint2: CGPointMake(43.71, 202.67)];
    [path addCurveToPoint: CGPointMake(37.22, 208.69) controlPoint1: CGPointMake(41.38, 206.88) controlPoint2: CGPointMake(39.73, 208.3)];
    [path addCurveToPoint: CGPointMake(33.83, 208.97) controlPoint1: CGPointMake(36.11, 208.86) controlPoint2: CGPointMake(34.96, 208.96)];
    [path addCurveToPoint: CGPointMake(30.06, 208.99) controlPoint1: CGPointMake(32.57, 208.99) controlPoint2: CGPointMake(31.31, 208.99)];
    [path addCurveToPoint: CGPointMake(29.57, 209) controlPoint1: CGPointMake(29.89, 209) controlPoint2: CGPointMake(29.73, 209)];
    [path addCurveToPoint: CGPointMake(25.98, 209) controlPoint1: CGPointMake(28.38, 209) controlPoint2: CGPointMake(27.18, 209)];
    [path addCurveToPoint: CGPointMake(18.17, 208.97) controlPoint1: CGPointMake(23.38, 209) controlPoint2: CGPointMake(20.77, 209)];
    [path addCurveToPoint: CGPointMake(14.78, 208.69) controlPoint1: CGPointMake(17.04, 208.96) controlPoint2: CGPointMake(15.9, 208.86)];
    [path addCurveToPoint: CGPointMake(9.5, 204.86) controlPoint1: CGPointMake(12.27, 208.3) controlPoint2: CGPointMake(10.62, 206.88)];
    [path addCurveToPoint: CGPointMake(7.22, 197.91) controlPoint1: CGPointMake(8.29, 202.67) controlPoint2: CGPointMake(7.7, 200.31)];
    [path addCurveToPoint: CGPointMake(5.86, 186.58) controlPoint1: CGPointMake(6.49, 194.16) controlPoint2: CGPointMake(6.11, 190.38)];
    [path addCurveToPoint: CGPointMake(5.01, 148.38) controlPoint1: CGPointMake(5.01, 173.86) controlPoint2: CGPointMake(5.03, 161.12)];
    [path addCurveToPoint: CGPointMake(5.05, 72.46) controlPoint1: CGPointMake(4.99, 116.87) controlPoint2: CGPointMake(5, 103.97)];
    [path addCurveToPoint: CGPointMake(5.4, 50.5) controlPoint1: CGPointMake(5.06, 65.14) controlPoint2: CGPointMake(5.23, 57.82)];
    [path addCurveToPoint: CGPointMake(6.45, 35.08) controlPoint1: CGPointMake(5.53, 45.35) controlPoint2: CGPointMake(5.83, 40.2)];
    [path addCurveToPoint: CGPointMake(8.56, 25.2) controlPoint1: CGPointMake(6.86, 31.73) controlPoint2: CGPointMake(7.37, 28.4)];
    [path addCurveToPoint: CGPointMake(10.39, 21.83) controlPoint1: CGPointMake(9, 24) controlPoint2: CGPointMake(9.57, 22.86)];
    [path addCurveToPoint: CGPointMake(15.04, 19.29) controlPoint1: CGPointMake(11.54, 20.37) controlPoint2: CGPointMake(13.11, 19.53)];
    [path addCurveToPoint: CGPointMake(18.91, 19.03) controlPoint1: CGPointMake(16.32, 19.13) controlPoint2: CGPointMake(17.62, 19.04)];
    [path addCurveToPoint: CGPointMake(25.97, 19) controlPoint1: CGPointMake(21.26, 19.01) controlPoint2: CGPointMake(23.62, 19)];
    [path addCurveToPoint: CGPointMake(29.53, 19) controlPoint1: CGPointMake(27.16, 19) controlPoint2: CGPointMake(28.35, 19)];
    [path addLineToPoint: CGPointMake(29.55, 19)];
    [path addCurveToPoint: CGPointMake(33.09, 19.03) controlPoint1: CGPointMake(30.73, 19.01) controlPoint2: CGPointMake(31.91, 19.02)];
    [path addCurveToPoint: CGPointMake(36.97, 19.29) controlPoint1: CGPointMake(34.38, 19.04) controlPoint2: CGPointMake(35.68, 19.13)];
    [path addCurveToPoint: CGPointMake(41.61, 21.83) controlPoint1: CGPointMake(38.89, 19.53) controlPoint2: CGPointMake(40.46, 20.37)];
    [path addCurveToPoint: CGPointMake(43.44, 25.2) controlPoint1: CGPointMake(42.43, 22.86) controlPoint2: CGPointMake(43, 24)];
    [path addCurveToPoint: CGPointMake(45.55, 35.08) controlPoint1: CGPointMake(44.63, 28.4) controlPoint2: CGPointMake(45.14, 31.73)];
    [path addCurveToPoint: CGPointMake(46.6, 50.5) controlPoint1: CGPointMake(46.17, 40.2) controlPoint2: CGPointMake(46.47, 45.35)];
    [path addCurveToPoint: CGPointMake(46.95, 72.46) controlPoint1: CGPointMake(46.77, 57.82) controlPoint2: CGPointMake(46.94, 65.14)];
    [path addCurveToPoint: CGPointMake(46.99, 148.38) controlPoint1: CGPointMake(47, 103.97) controlPoint2: CGPointMake(47.01, 116.87)];
    [path closePath];
    [path moveToPoint: CGPointMake(0, 228)];
    [path addLineToPoint: CGPointMake(52, 228)];
    [path addLineToPoint: CGPointMake(52, -0)];
    [path addLineToPoint: CGPointMake(0, -0)];
    [path addLineToPoint: CGPointMake(0, 228)];
    [path closePath];
    return path;
}

static UIBezierPath *RotorFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(29.53, 19)];
    [path addCurveToPoint: CGPointMake(25.97, 19) controlPoint1: CGPointMake(28.35, 19) controlPoint2: CGPointMake(27.16, 19)];
    [path addCurveToPoint: CGPointMake(18.91, 19.03) controlPoint1: CGPointMake(23.62, 19) controlPoint2: CGPointMake(21.26, 19.01)];
    [path addCurveToPoint: CGPointMake(15.04, 19.29) controlPoint1: CGPointMake(17.62, 19.04) controlPoint2: CGPointMake(16.32, 19.13)];
    [path addCurveToPoint: CGPointMake(10.39, 21.83) controlPoint1: CGPointMake(13.11, 19.53) controlPoint2: CGPointMake(11.54, 20.37)];
    [path addCurveToPoint: CGPointMake(8.56, 25.2) controlPoint1: CGPointMake(9.57, 22.86) controlPoint2: CGPointMake(9, 24)];
    [path addCurveToPoint: CGPointMake(6.45, 35.08) controlPoint1: CGPointMake(7.37, 28.4) controlPoint2: CGPointMake(6.86, 31.73)];
    [path addCurveToPoint: CGPointMake(5.4, 50.5) controlPoint1: CGPointMake(5.83, 40.2) controlPoint2: CGPointMake(5.53, 45.35)];
    [path addCurveToPoint: CGPointMake(5.05, 72.46) controlPoint1: CGPointMake(5.23, 57.82) controlPoint2: CGPointMake(5.06, 65.14)];
    [path addCurveToPoint: CGPointMake(5.01, 148.38) controlPoint1: CGPointMake(5, 103.98) controlPoint2: CGPointMake(4.99, 116.87)];
    [path addCurveToPoint: CGPointMake(5.86, 186.58) controlPoint1: CGPointMake(5.03, 161.12) controlPoint2: CGPointMake(5.01, 173.86)];
    [path addCurveToPoint: CGPointMake(7.22, 197.92) controlPoint1: CGPointMake(6.12, 190.38) controlPoint2: CGPointMake(6.49, 194.17)];
    [path addCurveToPoint: CGPointMake(9.5, 204.87) controlPoint1: CGPointMake(7.7, 200.31) controlPoint2: CGPointMake(8.29, 202.67)];
    [path addCurveToPoint: CGPointMake(14.78, 208.69) controlPoint1: CGPointMake(10.62, 206.88) controlPoint2: CGPointMake(12.27, 208.3)];
    [path addCurveToPoint: CGPointMake(18.17, 208.97) controlPoint1: CGPointMake(15.9, 208.86) controlPoint2: CGPointMake(17.04, 208.96)];
    [path addCurveToPoint: CGPointMake(25.98, 209) controlPoint1: CGPointMake(20.77, 209) controlPoint2: CGPointMake(23.38, 209)];
    [path addCurveToPoint: CGPointMake(29.57, 209) controlPoint1: CGPointMake(27.18, 209) controlPoint2: CGPointMake(28.38, 209)];
    [path addCurveToPoint: CGPointMake(30.06, 209) controlPoint1: CGPointMake(29.73, 209) controlPoint2: CGPointMake(29.89, 209)];
    [path addCurveToPoint: CGPointMake(33.83, 208.97) controlPoint1: CGPointMake(31.31, 208.99) controlPoint2: CGPointMake(32.57, 208.99)];
    [path addCurveToPoint: CGPointMake(37.22, 208.69) controlPoint1: CGPointMake(34.96, 208.96) controlPoint2: CGPointMake(36.1, 208.86)];
    [path addCurveToPoint: CGPointMake(42.5, 204.87) controlPoint1: CGPointMake(39.73, 208.3) controlPoint2: CGPointMake(41.38, 206.88)];
    [path addCurveToPoint: CGPointMake(44.78, 197.92) controlPoint1: CGPointMake(43.71, 202.67) controlPoint2: CGPointMake(44.3, 200.31)];
    [path addCurveToPoint: CGPointMake(46.14, 186.58) controlPoint1: CGPointMake(45.51, 194.17) controlPoint2: CGPointMake(45.89, 190.38)];
    [path addCurveToPoint: CGPointMake(46.99, 148.38) controlPoint1: CGPointMake(46.99, 173.86) controlPoint2: CGPointMake(46.97, 161.12)];
    [path addCurveToPoint: CGPointMake(46.95, 72.46) controlPoint1: CGPointMake(47.01, 116.87) controlPoint2: CGPointMake(47, 103.98)];
    [path addCurveToPoint: CGPointMake(46.6, 50.5) controlPoint1: CGPointMake(46.94, 65.14) controlPoint2: CGPointMake(46.77, 57.82)];
    [path addCurveToPoint: CGPointMake(45.55, 35.08) controlPoint1: CGPointMake(46.47, 45.35) controlPoint2: CGPointMake(46.17, 40.2)];
    [path addCurveToPoint: CGPointMake(43.44, 25.2) controlPoint1: CGPointMake(45.14, 31.73) controlPoint2: CGPointMake(44.63, 28.4)];
    [path addCurveToPoint: CGPointMake(41.61, 21.83) controlPoint1: CGPointMake(43, 24) controlPoint2: CGPointMake(42.43, 22.86)];
    [path addCurveToPoint: CGPointMake(36.97, 19.29) controlPoint1: CGPointMake(40.46, 20.37) controlPoint2: CGPointMake(38.89, 19.53)];
    [path addCurveToPoint: CGPointMake(33.09, 19.03) controlPoint1: CGPointMake(35.68, 19.13) controlPoint2: CGPointMake(34.38, 19.04)];
    [path addCurveToPoint: CGPointMake(29.55, 19) controlPoint1: CGPointMake(31.91, 19.02) controlPoint2: CGPointMake(30.73, 19.01)];
    [path addLineToPoint: CGPointMake(29.53, 19)];
    [path closePath];
    return path;
}

static UIBezierPath *RotorStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(27.18, 19)];
    [path addCurveToPoint: CGPointMake(25.97, 19) controlPoint1: CGPointMake(26.78, 19) controlPoint2: CGPointMake(26.38, 19)];
    [path addCurveToPoint: CGPointMake(24.89, 19) controlPoint1: CGPointMake(25.61, 19) controlPoint2: CGPointMake(25.25, 19)];
    [path addCurveToPoint: CGPointMake(18.74, 19.03) controlPoint1: CGPointMake(22.84, 19) controlPoint2: CGPointMake(20.79, 19.01)];
    [path addCurveToPoint: CGPointMake(14.77, 19.29) controlPoint1: CGPointMake(17.42, 19.04) controlPoint2: CGPointMake(16.09, 19.13)];
    [path addCurveToPoint: CGPointMake(10.02, 21.83) controlPoint1: CGPointMake(12.81, 19.53) controlPoint2: CGPointMake(11.2, 20.37)];
    [path addCurveToPoint: CGPointMake(8.14, 25.2) controlPoint1: CGPointMake(9.18, 22.86) controlPoint2: CGPointMake(8.6, 24)];
    [path addCurveToPoint: CGPointMake(5.99, 35.08) controlPoint1: CGPointMake(6.93, 28.4) controlPoint2: CGPointMake(6.4, 31.74)];
    [path addCurveToPoint: CGPointMake(4.91, 50.5) controlPoint1: CGPointMake(5.35, 40.2) controlPoint2: CGPointMake(5.04, 45.35)];
    [path addCurveToPoint: CGPointMake(4.55, 72.46) controlPoint1: CGPointMake(4.73, 57.82) controlPoint2: CGPointMake(4.56, 65.14)];
    [path addCurveToPoint: CGPointMake(4.51, 148.38) controlPoint1: CGPointMake(4.5, 103.98) controlPoint2: CGPointMake(4.49, 116.87)];
    [path addCurveToPoint: CGPointMake(5.38, 186.58) controlPoint1: CGPointMake(4.53, 161.12) controlPoint2: CGPointMake(4.51, 173.86)];
    [path addCurveToPoint: CGPointMake(6.78, 197.91) controlPoint1: CGPointMake(5.64, 190.38) controlPoint2: CGPointMake(6.02, 194.16)];
    [path addCurveToPoint: CGPointMake(9.11, 204.87) controlPoint1: CGPointMake(7.26, 200.31) controlPoint2: CGPointMake(7.87, 202.67)];
    [path addCurveToPoint: CGPointMake(14.51, 208.69) controlPoint1: CGPointMake(10.25, 206.88) controlPoint2: CGPointMake(11.94, 208.3)];
    [path addCurveToPoint: CGPointMake(17.98, 208.97) controlPoint1: CGPointMake(15.65, 208.86) controlPoint2: CGPointMake(16.82, 208.97)];
    [path addCurveToPoint: CGPointMake(24.91, 209) controlPoint1: CGPointMake(20.29, 208.99) controlPoint2: CGPointMake(22.6, 209)];
    [path addLineToPoint: CGPointMake(25.98, 209)];
    [path addLineToPoint: CGPointMake(26.94, 209)];
    [path addCurveToPoint: CGPointMake(29.66, 209) controlPoint1: CGPointMake(27.84, 209) controlPoint2: CGPointMake(28.75, 209)];
    [path addCurveToPoint: CGPointMake(30.15, 209) controlPoint1: CGPointMake(29.82, 209) controlPoint2: CGPointMake(29.99, 209)];
    [path addCurveToPoint: CGPointMake(34.02, 208.97) controlPoint1: CGPointMake(31.44, 208.99) controlPoint2: CGPointMake(32.73, 208.99)];
    [path addCurveToPoint: CGPointMake(37.49, 208.69) controlPoint1: CGPointMake(35.18, 208.97) controlPoint2: CGPointMake(36.35, 208.86)];
    [path addCurveToPoint: CGPointMake(42.89, 204.87) controlPoint1: CGPointMake(40.05, 208.3) controlPoint2: CGPointMake(41.75, 206.88)];
    [path addCurveToPoint: CGPointMake(45.22, 197.91) controlPoint1: CGPointMake(44.13, 202.67) controlPoint2: CGPointMake(44.74, 200.31)];
    [path addCurveToPoint: CGPointMake(46.62, 186.58) controlPoint1: CGPointMake(45.98, 194.16) controlPoint2: CGPointMake(46.36, 190.38)];
    [path addCurveToPoint: CGPointMake(47.49, 148.38) controlPoint1: CGPointMake(47.49, 173.86) controlPoint2: CGPointMake(47.47, 161.12)];
    [path addCurveToPoint: CGPointMake(47.45, 72.46) controlPoint1: CGPointMake(47.51, 116.87) controlPoint2: CGPointMake(47.5, 103.98)];
    [path addCurveToPoint: CGPointMake(47.09, 50.5) controlPoint1: CGPointMake(47.44, 65.14) controlPoint2: CGPointMake(47.27, 57.82)];
    [path addCurveToPoint: CGPointMake(46.01, 35.08) controlPoint1: CGPointMake(46.96, 45.35) controlPoint2: CGPointMake(46.65, 40.2)];
    [path addCurveToPoint: CGPointMake(43.86, 25.2) controlPoint1: CGPointMake(45.6, 31.74) controlPoint2: CGPointMake(45.07, 28.4)];
    [path addCurveToPoint: CGPointMake(41.98, 21.83) controlPoint1: CGPointMake(43.4, 24) controlPoint2: CGPointMake(42.82, 22.86)];
    [path addCurveToPoint: CGPointMake(37.23, 19.29) controlPoint1: CGPointMake(40.8, 20.37) controlPoint2: CGPointMake(39.19, 19.53)];
    [path addCurveToPoint: CGPointMake(33.26, 19.03) controlPoint1: CGPointMake(35.91, 19.13) controlPoint2: CGPointMake(34.58, 19.04)];
    [path addCurveToPoint: CGPointMake(29.64, 19) controlPoint1: CGPointMake(32.05, 19.02) controlPoint2: CGPointMake(30.84, 19.01)];
    [path addLineToPoint: CGPointMake(29.62, 19)];
    [path addCurveToPoint: CGPointMake(27.18, 19) controlPoint1: CGPointMake(28.8, 19) controlPoint2: CGPointMake(27.99, 19)];
    [path closePath];
    [path moveToPoint: CGPointMake(27.18, 20)];
    [path addCurveToPoint: CGPointMake(29.63, 20) controlPoint1: CGPointMake(27.99, 20) controlPoint2: CGPointMake(28.8, 20)];
    [path addCurveToPoint: CGPointMake(33.25, 20.03) controlPoint1: CGPointMake(30.84, 20.01) controlPoint2: CGPointMake(32.04, 20.02)];
    [path addCurveToPoint: CGPointMake(37.1, 20.28) controlPoint1: CGPointMake(34.48, 20.04) controlPoint2: CGPointMake(35.78, 20.12)];
    [path addCurveToPoint: CGPointMake(41.18, 22.45) controlPoint1: CGPointMake(38.81, 20.49) controlPoint2: CGPointMake(40.18, 21.22)];
    [path addCurveToPoint: CGPointMake(42.9, 25.54) controlPoint1: CGPointMake(41.87, 23.29) controlPoint2: CGPointMake(42.43, 24.31)];
    [path addCurveToPoint: CGPointMake(45, 35.2) controlPoint1: CGPointMake(44.13, 28.79) controlPoint2: CGPointMake(44.63, 32.23)];
    [path addCurveToPoint: CGPointMake(46.06, 50.53) controlPoint1: CGPointMake(45.57, 39.82) controlPoint2: CGPointMake(45.92, 44.83)];
    [path addCurveToPoint: CGPointMake(46.43, 72.46) controlPoint1: CGPointMake(46.26, 58.34) controlPoint2: CGPointMake(46.42, 65.39)];
    [path addCurveToPoint: CGPointMake(46.46, 148.38) controlPoint1: CGPointMake(46.48, 103.68) controlPoint2: CGPointMake(46.49, 116.45)];
    [path addLineToPoint: CGPointMake(46.46, 149.45)];
    [path addCurveToPoint: CGPointMake(45.6, 186.51) controlPoint1: CGPointMake(46.45, 161.6) controlPoint2: CGPointMake(46.44, 174.18)];
    [path addCurveToPoint: CGPointMake(44.22, 197.72) controlPoint1: CGPointMake(45.39, 189.6) controlPoint2: CGPointMake(45.04, 193.66)];
    [path addCurveToPoint: CGPointMake(42, 204.38) controlPoint1: CGPointMake(43.77, 199.93) controlPoint2: CGPointMake(43.19, 202.27)];
    [path addCurveToPoint: CGPointMake(37.33, 207.7) controlPoint1: CGPointMake(40.91, 206.31) controlPoint2: CGPointMake(39.38, 207.39)];
    [path addCurveToPoint: CGPointMake(34.01, 207.97) controlPoint1: CGPointMake(36.19, 207.87) controlPoint2: CGPointMake(35.07, 207.97)];
    [path addCurveToPoint: CGPointMake(30.15, 208) controlPoint1: CGPointMake(32.72, 207.99) controlPoint2: CGPointMake(31.44, 207.99)];
    [path addLineToPoint: CGPointMake(29.87, 208)];
    [path addLineToPoint: CGPointMake(29.65, 208)];
    [path addCurveToPoint: CGPointMake(26.94, 208) controlPoint1: CGPointMake(28.75, 208) controlPoint2: CGPointMake(27.84, 208)];
    [path addLineToPoint: CGPointMake(25.98, 208)];
    [path addLineToPoint: CGPointMake(24.91, 208)];
    [path addCurveToPoint: CGPointMake(17.99, 207.97) controlPoint1: CGPointMake(22.61, 208) controlPoint2: CGPointMake(20.3, 207.99)];
    [path addCurveToPoint: CGPointMake(14.67, 207.7) controlPoint1: CGPointMake(16.93, 207.97) controlPoint2: CGPointMake(15.81, 207.87)];
    [path addCurveToPoint: CGPointMake(10, 204.38) controlPoint1: CGPointMake(12.62, 207.39) controlPoint2: CGPointMake(11.09, 206.31)];
    [path addCurveToPoint: CGPointMake(7.78, 197.72) controlPoint1: CGPointMake(8.81, 202.27) controlPoint2: CGPointMake(8.23, 199.93)];
    [path addCurveToPoint: CGPointMake(6.4, 186.51) controlPoint1: CGPointMake(6.96, 193.66) controlPoint2: CGPointMake(6.61, 189.6)];
    [path addCurveToPoint: CGPointMake(5.54, 149.45) controlPoint1: CGPointMake(5.56, 174.18) controlPoint2: CGPointMake(5.55, 161.6)];
    [path addLineToPoint: CGPointMake(5.54, 148.38)];
    [path addCurveToPoint: CGPointMake(5.57, 72.46) controlPoint1: CGPointMake(5.51, 116.46) controlPoint2: CGPointMake(5.52, 103.68)];
    [path addCurveToPoint: CGPointMake(5.94, 50.53) controlPoint1: CGPointMake(5.58, 65.39) controlPoint2: CGPointMake(5.74, 58.34)];
    [path addCurveToPoint: CGPointMake(7, 35.2) controlPoint1: CGPointMake(6.08, 44.83) controlPoint2: CGPointMake(6.43, 39.82)];
    [path addCurveToPoint: CGPointMake(9.1, 25.54) controlPoint1: CGPointMake(7.37, 32.23) controlPoint2: CGPointMake(7.87, 28.79)];
    [path addCurveToPoint: CGPointMake(10.82, 22.45) controlPoint1: CGPointMake(9.57, 24.31) controlPoint2: CGPointMake(10.13, 23.29)];
    [path addCurveToPoint: CGPointMake(14.9, 20.28) controlPoint1: CGPointMake(11.82, 21.22) controlPoint2: CGPointMake(13.19, 20.49)];
    [path addCurveToPoint: CGPointMake(18.75, 20.03) controlPoint1: CGPointMake(16.22, 20.12) controlPoint2: CGPointMake(17.52, 20.04)];
    [path addCurveToPoint: CGPointMake(24.89, 20) controlPoint1: CGPointMake(20.79, 20.01) controlPoint2: CGPointMake(22.84, 20)];
    [path addLineToPoint: CGPointMake(25.97, 20)];
    [path addLineToPoint: CGPointMake(27.18, 20)];
    [path closePath];
    return path;
}

// =========================================================================================================================================

@interface UPRotorLabel : UIView
@property (nonatomic) NSArray<NSString *> *elements;
@property (nonatomic) CGFloat elementHeight;
@property (nonatomic) NSUInteger selectedIndex;
@end

@implementation UPRotorLabel

- (instancetype)initWithElements:(NSArray<NSString *> *)elements elementHeight:(CGFloat)elementHeight
{
    self = [super initWithFrame:CGRectZero];
    self.elements = elements;
    self.elementHeight = elementHeight;
    self.opaque = NO;
    return self;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIFont *font = [UIFont checkboxControlFontOfSize:40 * 0.786];
    
    CGRect bounds = self.bounds;
    CGFloat elementY = 0;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@" "];
    [attrString setTextAlignment:NSTextAlignmentCenter];
    [attrString setFont:font];
    NSUInteger i = 0;
    elementY = self.elementHeight * 2;
    UIColor *selectedColor = [UIColor themeColorWithCategory:UPColorCategoryContent];
    UIColor *unselectedColor = [selectedColor colorWithAlphaComponent:[UIColor themeDisabledAlpha]];
        //[UIColor themeColorWithCategory:UPColorCategoryInactiveContent];
    for (NSString *element in self.elements) {
        attrString.string = element;
        if (i == self.selectedIndex) {
            [attrString setTextColor:selectedColor];
        }
        else {
            [attrString setTextColor:unselectedColor];
        }
        CGRect textRect = CGRectMake(0, elementY, up_rect_width(bounds), self.elementHeight);
        CGRect elementRect = textRect;
        elementRect.size.height = font.lineHeight;
        elementRect = up_rect_centered_in_rect(elementRect, textRect);
        //elementRect.origin.y -= (font.capHeight / 2);
        elementRect.origin.y -= (font.lineHeight * 0.035);
//        LOG(General, "rects: %@ : %@", NSStringFromCGRect(textRect), NSStringFromCGRect(elementRect));
        [attrString drawInRect:elementRect];
        elementY += self.elementHeight;

//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(ctx);
//        if (i % 2 == 0) {
//            CGContextSetFillColorWithColor(ctx, [UIColor testColor1].CGColor);
//        }
//        else {
//            CGContextSetFillColorWithColor(ctx, [UIColor testColor2].CGColor);
//        }
//        CGContextFillRect(ctx, textRect);
//        CGContextRestoreGState(ctx);
        i++;
    }
}

@end

// =========================================================================================================================================

@interface UPRotor () <UIScrollViewDelegate>
@property (nonatomic, readwrite) UPRotorType type;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UPRotorLabel *elementsLabel;
@property (nonatomic) NSMutableAttributedString *elementsString;
@property (nonatomic) UPDivider *divider;
@property (nonatomic) CGFloat zeroOffset;
@property (nonatomic) CGFloat elementHeight;
@end

@implementation UPRotor

+ (UPRotor *)rotorWithType:(UPRotorType)type
{
    return [[UPRotor alloc] initWithType:type];
}

- (instancetype)initWithType:(UPRotorType)type
{
    self = [super initWithFrame:CGRectZero];
    self.type = type;
    
    self.clipsToBounds = YES;
    
    SpellLayout &layout = SpellLayout::instance();
    
    self.canonicalSize = SpellLayout::CanonicalRotorSize;

    [self setFillPath:RotorFillPath()];
    [self setFillColorCategory:UPColorCategoryPrimaryFill];

    [self setStrokePath:RotorStrokePath()];

//    [self setAuxiliaryPath:RotorBezelPath()];
//    [self setAuxiliaryColorCategory:UPColorCategoryInfinity];
//    [self setAuxiliaryColorCategory:UPColorCategoryInactiveFill];

    CGFloat canonicalHeight = 228;
    self.elementHeight = (canonicalHeight / 5) * layout.layout_scale();
    
//    LOG(General, "elementHeight: %.2f : %.2f", canonicalHeight / 5, self.elementHeight);
    
    switch (type) {
        case UPRotorTypeDefault:
        case UPRotorTypeAlphabet: {
            NSArray<NSString *> *elements = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
                                              @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T",
                                              @"U", @"V", @"W", @"X", @"Y", @"Z"];
            self.elementsLabel = [[UPRotorLabel alloc] initWithElements:elements elementHeight:self.elementHeight];
            break;
        }
        case UPRotorTypeNumbers: {
            NSArray<NSString *> *elements = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
            self.elementsLabel = [[UPRotorLabel alloc] initWithElements:elements elementHeight:self.elementHeight];
            break;
        }
    }

//    self.divider = [UPDivider divider];
//    self.divider.colorCategory = UPColorCategoryInactiveFill;
//    [self addSubview:self.divider];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delaysContentTouches = NO;
    [self.scrollView addSubview:self.elementsLabel];
//    self.zeroOffset = 86 * layout.layout_scale();
//    self.elementHeight = up_rect_height(self.elementsLabel.frame) / self.elementsCount;
//    self.scrollView.contentInset = UIEdgeInsetsMake(86 * layout.layout_scale(), 0, 86 * layout.layout_scale(), 0);
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
//    self.scrollView.contentSize = CGSizeMake();

//    self.divider = [UPDivider divider];
//    self.divider.colorCategory = UPColorCategoryInactiveFill;
//    [self addSubview:self.divider];
//    [self sendSubviewToBack:self.divider];
    
//    [self bringPathViewToFront:self.auxiliaryPathView];

    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSUInteger selectedIndex = 0;
    CGFloat dy = FLT_MAX;
    for (NSUInteger i = 0; i < self.elementsCount; i++) {
        CGFloat toffsetY = -self.zeroOffset + (i * self.elementHeight);
        CGFloat tdy = fabs(toffsetY - offsetY);
        if (tdy < dy) {
            dy = tdy;
            selectedIndex = i;
        }
    }
//    LOG(General, "index: %lu", selectedIndex);
    [self.elementsLabel setSelectedIndex:selectedIndex];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offsetY = targetContentOffset->y;
    CGFloat closestY = -self.zeroOffset;
    CGFloat dy = FLT_MAX;
    for (NSUInteger i = 0; i < self.elementsCount; i++) {
        CGFloat toffsetY = -self.zeroOffset + (i * self.elementHeight);
        CGFloat tdy = fabs(toffsetY - offsetY);
        if (tdy < dy) {
            dy = tdy;
            closestY = toffsetY;
        }
        
    }
    targetContentOffset->y = closestY;
//    LOG(General, "offset: %.2f : %.2f : %.2f", self.zeroOffset, self.elementHeight, closestY);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(self.bounds, point) ? self.scrollView : nil;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (NSUInteger)elementsCount
{
    switch (self.type) {
        case UPRotorTypeDefault:
        case UPRotorTypeAlphabet:
            return 26;
        case UPRotorTypeNumbers:
            return 10;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    SpellLayout &layout = SpellLayout::instance();

    CGRect bounds = self.bounds;
    self.scrollView.frame = bounds;
    CGFloat elementsLabelHeight = (4 + [self elementsCount]) * self.elementHeight;
    self.elementsLabel.frame = CGRectMake(0, 0, up_rect_width(bounds), elementsLabelHeight);
//    LOG(General, "bounds:   %@", NSStringFromCGRect(bounds));
//    LOG(General, "elements: %@", NSStringFromCGRect(self.elementsLabel.frame));
    self.scrollView.contentSize = self.elementsLabel.frame.size;
    self.divider.frame = CGRectMake(0, up_rect_mid_y(bounds) - 0.5, up_rect_width(bounds), 1);
}

@end
