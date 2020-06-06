//
//  GameMockupView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "AppDelegate.h"
#import "GameMockupView.h"

@implementation GameMockupView

- (void)setColors:(NSDictionary *)colors
{
    _colors = [colors copy];
    [self setNeedsDisplay];
}

- (void)setColorTheme:(ColorTheme)colorTheme
{
    _colorTheme = colorTheme;
    [self setNeedsDisplay];
}

- (void)setGameState:(GameState)gameState
{
    _gameState = gameState;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeScale(0.33333, 0.33333));

    UIColor *primaryFillColor = self.colors[PrimaryFillKey];
    UIColor *inactiveFillColor = self.colors[InactiveFillKey];
//    UIColor *activeFillColor = self.colors[ActiveFillKey];
    UIColor *highlightedFillColor = self.colors[HighlightedFillKey];
    UIColor *secondaryFillColor = self.colors[SecondaryFillKey];
    UIColor *secondaryInactiveFillColor = self.colors[SecondaryInactiveFillKey];
    UIColor *secondaryActiveFillColor = self.colors[SecondaryActiveFillKey];
    UIColor *secondaryHighlightedFillColor = self.colors[SecondaryHighlightedFillKey];
    UIColor *primaryStrokeColor = self.colors[PrimaryStrokeKey];
    UIColor *inactiveStrokeColor = self.colors[InactiveStrokeKey];
    UIColor *activeStrokeColor = self.colors[ActiveStrokeKey];
    UIColor *highlightedStrokeColor = self.colors[HighlightedStrokeKey];
    UIColor *secondaryStrokeColor = self.colors[SecondaryStrokeKey];
    UIColor *secondaryInactiveStrokeColor = self.colors[SecondaryInactiveStrokeKey];
    UIColor *secondaryActiveStrokeColor = self.colors[SecondaryActiveStrokeKey];
    UIColor *secondaryHighlightedStrokeColor = self.colors[SecondaryHighlightedStrokeKey];
    UIColor *contentColor = self.colors[ContentKey];
    UIColor *inactiveContentColor = self.colors[InactiveContentKey];
    UIColor *activeContentColor = self.colors[ActiveContentKey];
    UIColor *highlightedContentColor = self.colors[HighlightedContentKey];
    UIColor *informationColor = self.colors[InformationKey];
    UIColor *infinityColor = self.colors[InfinityKey];

    BOOL tappablesStroke = self.colorTheme == ColorThemeLightStark || self.colorTheme == ColorThemeDarkStark;

    UIColor *wordTileFillColor = [UIColor clearColor];
    UIColor *wordTileStrokeColor = [UIColor clearColor];
    UIColor *wordTileContentColor = [UIColor clearColor];

    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            wordTileFillColor = [UIColor clearColor];
            wordTileStrokeColor = [UIColor clearColor];
            wordTileContentColor = [UIColor clearColor];
            break;
        case GameStateSpell:
            wordTileFillColor = primaryFillColor;
            wordTileStrokeColor = primaryStrokeColor;
            wordTileContentColor = contentColor;
            break;
        case GameStateWord:
            wordTileFillColor = primaryFillColor;
            wordTileStrokeColor = primaryStrokeColor;
            wordTileContentColor = contentColor;
            break;
        case GameStateSubmit:
            wordTileFillColor = primaryFillColor;
            wordTileStrokeColor = primaryStrokeColor;
            wordTileContentColor = contentColor;
            break;
    }

    //// Canvas-Background Drawing
    UIBezierPath* canvasBackgroundPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 2436, 1125)];
    [infinityColor setFill];
    [canvasBackgroundPath fill];


    //// Time-1 Drawing
    UIBezierPath* time1Path = [UIBezierPath bezierPath];
    [time1Path moveToPoint:CGPointMake(753.8, 109.52)];
    [time1Path addLineToPoint:CGPointMake(808.4, 82.92)];
    [time1Path addLineToPoint:CGPointMake(811.4, 83.72)];
    [time1Path addLineToPoint:CGPointMake(811.4, 200.32)];
    [time1Path addLineToPoint:CGPointMake(837.6, 200.32)];
    [time1Path addLineToPoint:CGPointMake(837.6, 225.31)];
    [time1Path addLineToPoint:CGPointMake(753.4, 225.31)];
    [time1Path addLineToPoint:CGPointMake(753.4, 200.32)];
    [time1Path addLineToPoint:CGPointMake(782, 200.32)];
    [time1Path addLineToPoint:CGPointMake(782, 124.92)];
    [time1Path addLineToPoint:CGPointMake(754.2, 138.72)];
    [time1Path addLineToPoint:CGPointMake(753.8, 138.52)];
    [time1Path addLineToPoint:CGPointMake(753.8, 109.52)];
    [time1Path closePath];
    [informationColor setFill];
    [time1Path fill];


    //// Time-2 Drawing
    UIBezierPath* time2Path = [UIBezierPath bezierPath];
    [time2Path moveToPoint:CGPointMake(870.8, 164.12)];
    [time2Path addCurveToPoint:CGPointMake(888.2, 182.32) controlPoint1:CGPointMake(880.6, 164.12) controlPoint2:CGPointMake(888.2, 172.52)];
    [time2Path addCurveToPoint:CGPointMake(870.8, 200.32) controlPoint1:CGPointMake(888.2, 191.92) controlPoint2:CGPointMake(880.6, 200.32)];
    [time2Path addCurveToPoint:CGPointMake(853.2, 182.32) controlPoint1:CGPointMake(860.8, 200.32) controlPoint2:CGPointMake(853.2, 191.92)];
    [time2Path addCurveToPoint:CGPointMake(870.8, 164.12) controlPoint1:CGPointMake(853.2, 172.52) controlPoint2:CGPointMake(860.8, 164.12)];
    [time2Path closePath];
    [time2Path moveToPoint:CGPointMake(870.8, 108.12)];
    [time2Path addCurveToPoint:CGPointMake(888.2, 126.12) controlPoint1:CGPointMake(880.6, 108.12) controlPoint2:CGPointMake(888.2, 116.32)];
    [time2Path addCurveToPoint:CGPointMake(870.8, 144.32) controlPoint1:CGPointMake(888.2, 135.92) controlPoint2:CGPointMake(880.6, 144.32)];
    [time2Path addCurveToPoint:CGPointMake(853.2, 126.12) controlPoint1:CGPointMake(860.8, 144.32) controlPoint2:CGPointMake(853.2, 135.92)];
    [time2Path addCurveToPoint:CGPointMake(870.8, 108.12) controlPoint1:CGPointMake(853.2, 116.32) controlPoint2:CGPointMake(860.8, 108.12)];
    [time2Path closePath];
    [informationColor setFill];
    [time2Path fill];


    //// Time-3 Drawing
    UIBezierPath* time3Path = [UIBezierPath bezierPath];
    [time3Path moveToPoint:CGPointMake(945.4, 227.52)];
    [time3Path addCurveToPoint:CGPointMake(906.4, 217.12) controlPoint1:CGPointMake(928.8, 227.52) controlPoint2:CGPointMake(916.4, 223.32)];
    [time3Path addLineToPoint:CGPointMake(903.6, 187.92)];
    [time3Path addLineToPoint:CGPointMake(904, 187.72)];
    [time3Path addCurveToPoint:CGPointMake(941, 202.72) controlPoint1:CGPointMake(916.2, 197.32) controlPoint2:CGPointMake(929.4, 202.72)];
    [time3Path addCurveToPoint:CGPointMake(961.6, 186.12) controlPoint1:CGPointMake(953.4, 202.72) controlPoint2:CGPointMake(961.6, 195.92)];
    [time3Path addCurveToPoint:CGPointMake(921.8, 159.92) controlPoint1:CGPointMake(961.6, 174.92) controlPoint2:CGPointMake(953.2, 167.52)];
    [time3Path addLineToPoint:CGPointMake(921.8, 149.32)];
    [time3Path addCurveToPoint:CGPointMake(959.8, 121.32) controlPoint1:CGPointMake(951.6, 138.12) controlPoint2:CGPointMake(959.8, 130.52)];
    [time3Path addCurveToPoint:CGPointMake(942.8, 107.92) controlPoint1:CGPointMake(959.8, 113.12) controlPoint2:CGPointMake(953, 107.92)];
    [time3Path addCurveToPoint:CGPointMake(907, 125.32) controlPoint1:CGPointMake(930.6, 107.92) controlPoint2:CGPointMake(918, 114.92)];
    [time3Path addLineToPoint:CGPointMake(906.6, 125.32)];
    [time3Path addLineToPoint:CGPointMake(906.6, 98.12)];
    [time3Path addCurveToPoint:CGPointMake(947.6, 83.12) controlPoint1:CGPointMake(915.8, 90.12) controlPoint2:CGPointMake(930.6, 83.12)];
    [time3Path addCurveToPoint:CGPointMake(989.4, 116.92) controlPoint1:CGPointMake(973, 83.12) controlPoint2:CGPointMake(989.4, 96.72)];
    [time3Path addCurveToPoint:CGPointMake(962.4, 152.32) controlPoint1:CGPointMake(989.4, 132.12) controlPoint2:CGPointMake(980.6, 143.32)];
    [time3Path addCurveToPoint:CGPointMake(991.2, 188.92) controlPoint1:CGPointMake(981.2, 158.72) controlPoint2:CGPointMake(991.2, 171.32)];
    [time3Path addCurveToPoint:CGPointMake(945.4, 227.52) controlPoint1:CGPointMake(991.2, 213.32) controlPoint2:CGPointMake(970, 227.52)];
    [time3Path closePath];
    [informationColor setFill];
    [time3Path fill];


    //// Time-4 Drawing
    UIBezierPath* time4Path = [UIBezierPath bezierPath];
    [time4Path moveToPoint:CGPointMake(1069, 155.32)];
    [time4Path addCurveToPoint:CGPointMake(1050.4, 108.12) controlPoint1:CGPointMake(1069, 123.32) controlPoint2:CGPointMake(1062.2, 108.12)];
    [time4Path addCurveToPoint:CGPointMake(1032.2, 155.32) controlPoint1:CGPointMake(1038.8, 108.12) controlPoint2:CGPointMake(1032.2, 123.52)];
    [time4Path addCurveToPoint:CGPointMake(1050.8, 202.51) controlPoint1:CGPointMake(1032.2, 187.12) controlPoint2:CGPointMake(1038.8, 202.51)];
    [time4Path addCurveToPoint:CGPointMake(1069, 155.32) controlPoint1:CGPointMake(1062.4, 202.51) controlPoint2:CGPointMake(1069, 187.12)];
    [time4Path closePath];
    [time4Path moveToPoint:CGPointMake(1096.6, 155.32)];
    [time4Path addCurveToPoint:CGPointMake(1050.6, 228.11) controlPoint1:CGPointMake(1096.6, 202.71) controlPoint2:CGPointMake(1079.2, 228.11)];
    [time4Path addCurveToPoint:CGPointMake(1004.6, 155.32) controlPoint1:CGPointMake(1021.4, 228.11) controlPoint2:CGPointMake(1004.6, 202.92)];
    [time4Path addCurveToPoint:CGPointMake(1050.6, 82.52) controlPoint1:CGPointMake(1004.6, 108.12) controlPoint2:CGPointMake(1022, 82.52)];
    [time4Path addCurveToPoint:CGPointMake(1096.6, 155.32) controlPoint1:CGPointMake(1079.6, 82.52) controlPoint2:CGPointMake(1096.6, 107.72)];
    [time4Path closePath];
    [informationColor setFill];
    [time4Path fill];


    //// Score-1 Drawing
    UIBezierPath* score1Path = [UIBezierPath bezierPath];
    [score1Path moveToPoint:CGPointMake(1561.01, 144.47)];
    [score1Path addCurveToPoint:CGPointMake(1576.81, 124.67) controlPoint1:CGPointMake(1570.41, 144.47) controlPoint2:CGPointMake(1576.81, 136.47)];
    [score1Path addCurveToPoint:CGPointMake(1561.01, 105.47) controlPoint1:CGPointMake(1576.81, 113.07) controlPoint2:CGPointMake(1570.61, 105.47)];
    [score1Path addCurveToPoint:CGPointMake(1545.21, 124.67) controlPoint1:CGPointMake(1551.21, 105.47) controlPoint2:CGPointMake(1545.21, 113.07)];
    [score1Path addCurveToPoint:CGPointMake(1561.01, 144.47) controlPoint1:CGPointMake(1545.21, 136.47) controlPoint2:CGPointMake(1551.81, 144.47)];
    [score1Path closePath];
    [score1Path moveToPoint:CGPointMake(1561.01, 205.86)];
    [score1Path addCurveToPoint:CGPointMake(1578.81, 185.07) controlPoint1:CGPointMake(1571.61, 205.86) controlPoint2:CGPointMake(1578.81, 198.46)];
    [score1Path addCurveToPoint:CGPointMake(1561.01, 164.87) controlPoint1:CGPointMake(1578.81, 172.67) controlPoint2:CGPointMake(1570.81, 164.87)];
    [score1Path addCurveToPoint:CGPointMake(1543.21, 185.07) controlPoint1:CGPointMake(1551.21, 164.87) controlPoint2:CGPointMake(1543.21, 172.67)];
    [score1Path addCurveToPoint:CGPointMake(1561.01, 205.86) controlPoint1:CGPointMake(1543.21, 198.46) controlPoint2:CGPointMake(1550.81, 205.86)];
    [score1Path closePath];
    [score1Path moveToPoint:CGPointMake(1561.01, 228.06)];
    [score1Path addCurveToPoint:CGPointMake(1515.61, 188.47) controlPoint1:CGPointMake(1533.81, 228.06) controlPoint2:CGPointMake(1515.61, 212.66)];
    [score1Path addCurveToPoint:CGPointMake(1536.01, 154.27) controlPoint1:CGPointMake(1515.61, 172.47) controlPoint2:CGPointMake(1523.81, 160.87)];
    [score1Path addCurveToPoint:CGPointMake(1518.61, 122.47) controlPoint1:CGPointMake(1525.21, 147.67) controlPoint2:CGPointMake(1518.61, 136.47)];
    [score1Path addCurveToPoint:CGPointMake(1561.01, 83.27) controlPoint1:CGPointMake(1518.61, 99.67) controlPoint2:CGPointMake(1534.81, 83.27)];
    [score1Path addCurveToPoint:CGPointMake(1603.41, 122.47) controlPoint1:CGPointMake(1587.41, 83.27) controlPoint2:CGPointMake(1603.41, 99.67)];
    [score1Path addCurveToPoint:CGPointMake(1586.01, 154.27) controlPoint1:CGPointMake(1603.41, 136.47) controlPoint2:CGPointMake(1596.81, 147.67)];
    [score1Path addCurveToPoint:CGPointMake(1606.41, 188.47) controlPoint1:CGPointMake(1598.21, 160.67) controlPoint2:CGPointMake(1606.41, 172.47)];
    [score1Path addCurveToPoint:CGPointMake(1561.01, 228.06) controlPoint1:CGPointMake(1606.41, 212.46) controlPoint2:CGPointMake(1587.61, 228.06)];
    [score1Path closePath];
    [informationColor setFill];
    [score1Path fill];


    //// Score-2 Drawing
    UIBezierPath* score2Path = [UIBezierPath bezierPath];
    [score2Path moveToPoint:CGPointMake(1658.61, 225.66)];
    [score2Path addLineToPoint:CGPointMake(1628.01, 225.66)];
    [score2Path addLineToPoint:CGPointMake(1673.41, 111.67)];
    [score2Path addLineToPoint:CGPointMake(1621.61, 111.67)];
    [score2Path addLineToPoint:CGPointMake(1618.41, 85.67)];
    [score2Path addLineToPoint:CGPointMake(1711.21, 85.67)];
    [score2Path addLineToPoint:CGPointMake(1711.81, 87.47)];
    [score2Path addLineToPoint:CGPointMake(1658.61, 225.66)];
    [score2Path closePath];
    [informationColor setFill];
    [score2Path fill];


    //// Tray-Fill Drawing
    UIBezierPath* trayFillPath = [UIBezierPath bezierPath];
    [trayFillPath moveToPoint:CGPointMake(2267.74, 406.01)];
    [trayFillPath addCurveToPoint:CGPointMake(2267.8, 379.08) controlPoint1:CGPointMake(2267.75, 397.03) controlPoint2:CGPointMake(2267.76, 388.06)];
    [trayFillPath addLineToPoint:CGPointMake(2267.45, 379.14)];
    [trayFillPath addCurveToPoint:CGPointMake(2267.22, 363.08) controlPoint1:CGPointMake(2267.38, 373.78) controlPoint2:CGPointMake(2267.3, 368.43)];
    [trayFillPath addCurveToPoint:CGPointMake(2252.43, 339.43) controlPoint1:CGPointMake(2266.63, 352.59) controlPoint2:CGPointMake(2262.89, 343.73)];
    [trayFillPath addCurveToPoint:CGPointMake(2235.49, 333.7) controlPoint1:CGPointMake(2246.91, 337.16) controlPoint2:CGPointMake(2241.29, 334.73)];
    [trayFillPath addCurveToPoint:CGPointMake(2193.41, 327.65) controlPoint1:CGPointMake(2221.54, 331.21) controlPoint2:CGPointMake(2207.51, 328.7)];
    [trayFillPath addCurveToPoint:CGPointMake(1747.21, 318.37) controlPoint1:CGPointMake(2044.96, 316.97) controlPoint2:CGPointMake(1895.95, 319.24)];
    [trayFillPath addCurveToPoint:CGPointMake(1218, 317.99) controlPoint1:CGPointMake(1576.72, 318) controlPoint2:CGPointMake(1388.77, 317.92)];
    [trayFillPath addCurveToPoint:CGPointMake(688.79, 318.37) controlPoint1:CGPointMake(1047.23, 317.92) controlPoint2:CGPointMake(859.28, 318)];
    [trayFillPath addCurveToPoint:CGPointMake(242.59, 327.65) controlPoint1:CGPointMake(540.05, 319.24) controlPoint2:CGPointMake(391.04, 316.97)];
    [trayFillPath addCurveToPoint:CGPointMake(200.51, 333.7) controlPoint1:CGPointMake(228.49, 328.7) controlPoint2:CGPointMake(214.46, 331.21)];
    [trayFillPath addCurveToPoint:CGPointMake(183.57, 339.43) controlPoint1:CGPointMake(194.71, 334.73) controlPoint2:CGPointMake(189.09, 337.16)];
    [trayFillPath addCurveToPoint:CGPointMake(168.78, 363.08) controlPoint1:CGPointMake(173.11, 343.73) controlPoint2:CGPointMake(169.37, 352.59)];
    [trayFillPath addCurveToPoint:CGPointMake(168.55, 379.14) controlPoint1:CGPointMake(168.7, 368.43) controlPoint2:CGPointMake(168.62, 373.78)];
    [trayFillPath addLineToPoint:CGPointMake(168.2, 379.08)];
    [trayFillPath addCurveToPoint:CGPointMake(168.26, 406) controlPoint1:CGPointMake(168.24, 388.05) controlPoint2:CGPointMake(168.25, 397.03)];
    [trayFillPath addCurveToPoint:CGPointMake(168.26, 609.93) controlPoint1:CGPointMake(167.91, 446.82) controlPoint2:CGPointMake(167.91, 569.11)];
    [trayFillPath addCurveToPoint:CGPointMake(168.2, 636.85) controlPoint1:CGPointMake(168.25, 618.9) controlPoint2:CGPointMake(168.24, 627.87)];
    [trayFillPath addLineToPoint:CGPointMake(168.55, 636.79)];
    [trayFillPath addCurveToPoint:CGPointMake(168.78, 652.85) controlPoint1:CGPointMake(168.62, 642.15) controlPoint2:CGPointMake(168.7, 647.5)];
    [trayFillPath addCurveToPoint:CGPointMake(183.57, 676.5) controlPoint1:CGPointMake(169.37, 663.34) controlPoint2:CGPointMake(173.11, 672.2)];
    [trayFillPath addCurveToPoint:CGPointMake(200.51, 682.23) controlPoint1:CGPointMake(189.09, 678.77) controlPoint2:CGPointMake(194.71, 681.2)];
    [trayFillPath addCurveToPoint:CGPointMake(242.59, 688.28) controlPoint1:CGPointMake(214.46, 684.72) controlPoint2:CGPointMake(228.49, 687.23)];
    [trayFillPath addCurveToPoint:CGPointMake(688.79, 697.56) controlPoint1:CGPointMake(391.04, 698.96) controlPoint2:CGPointMake(540.05, 696.69)];
    [trayFillPath addCurveToPoint:CGPointMake(1218, 697.94) controlPoint1:CGPointMake(859.28, 697.93) controlPoint2:CGPointMake(1047.23, 698.01)];
    [trayFillPath addCurveToPoint:CGPointMake(1747.21, 697.56) controlPoint1:CGPointMake(1388.77, 698.01) controlPoint2:CGPointMake(1576.72, 697.93)];
    [trayFillPath addCurveToPoint:CGPointMake(2193.41, 688.28) controlPoint1:CGPointMake(1895.95, 696.69) controlPoint2:CGPointMake(2044.96, 698.96)];
    [trayFillPath addCurveToPoint:CGPointMake(2235.49, 682.23) controlPoint1:CGPointMake(2207.51, 687.23) controlPoint2:CGPointMake(2221.54, 684.72)];
    [trayFillPath addCurveToPoint:CGPointMake(2252.43, 676.5) controlPoint1:CGPointMake(2241.29, 681.2) controlPoint2:CGPointMake(2246.91, 678.77)];
    [trayFillPath addCurveToPoint:CGPointMake(2267.22, 652.85) controlPoint1:CGPointMake(2262.89, 672.2) controlPoint2:CGPointMake(2266.63, 663.34)];
    [trayFillPath addCurveToPoint:CGPointMake(2267.45, 636.79) controlPoint1:CGPointMake(2267.3, 647.5) controlPoint2:CGPointMake(2267.38, 642.15)];
    [trayFillPath addLineToPoint:CGPointMake(2267.8, 636.85)];
    [trayFillPath addCurveToPoint:CGPointMake(2267.74, 609.92) controlPoint1:CGPointMake(2267.76, 627.87) controlPoint2:CGPointMake(2267.75, 618.9)];
    [trayFillPath addCurveToPoint:CGPointMake(2267.74, 406.01) controlPoint1:CGPointMake(2268.09, 569.11) controlPoint2:CGPointMake(2268.09, 446.82)];
    [trayFillPath closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
        case GameStateSpell:
            [secondaryInactiveFillColor setFill];
            break;
        case GameStateWord:
            [secondaryActiveFillColor setFill];
            break;
        case GameStateSubmit:
            [secondaryHighlightedFillColor setFill];
            break;
    }
    [trayFillPath fill];


    //// Tray-Stroke Drawing
    UIBezierPath* trayStrokePath = [UIBezierPath bezierPath];
    [trayStrokePath moveToPoint:CGPointMake(2267.74, 406.01)];
    [trayStrokePath addCurveToPoint:CGPointMake(2267.8, 379.08) controlPoint1:CGPointMake(2267.75, 397.03) controlPoint2:CGPointMake(2267.76, 388.06)];
    [trayStrokePath addLineToPoint:CGPointMake(2267.45, 379.14)];
    [trayStrokePath addCurveToPoint:CGPointMake(2267.22, 363.08) controlPoint1:CGPointMake(2267.38, 373.78) controlPoint2:CGPointMake(2267.3, 368.43)];
    [trayStrokePath addCurveToPoint:CGPointMake(2252.43, 339.43) controlPoint1:CGPointMake(2266.63, 352.59) controlPoint2:CGPointMake(2262.89, 343.73)];
    [trayStrokePath addCurveToPoint:CGPointMake(2235.49, 333.7) controlPoint1:CGPointMake(2246.91, 337.16) controlPoint2:CGPointMake(2241.29, 334.73)];
    [trayStrokePath addCurveToPoint:CGPointMake(2193.41, 327.65) controlPoint1:CGPointMake(2221.54, 331.21) controlPoint2:CGPointMake(2207.51, 328.7)];
    [trayStrokePath addCurveToPoint:CGPointMake(1747.21, 318.37) controlPoint1:CGPointMake(2044.96, 316.97) controlPoint2:CGPointMake(1895.95, 319.24)];
    [trayStrokePath addCurveToPoint:CGPointMake(1218, 317.99) controlPoint1:CGPointMake(1576.72, 318) controlPoint2:CGPointMake(1388.77, 317.92)];
    [trayStrokePath addCurveToPoint:CGPointMake(688.79, 318.37) controlPoint1:CGPointMake(1047.23, 317.92) controlPoint2:CGPointMake(859.28, 318)];
    [trayStrokePath addCurveToPoint:CGPointMake(242.59, 327.65) controlPoint1:CGPointMake(540.05, 319.24) controlPoint2:CGPointMake(391.04, 316.97)];
    [trayStrokePath addCurveToPoint:CGPointMake(200.51, 333.7) controlPoint1:CGPointMake(228.49, 328.7) controlPoint2:CGPointMake(214.46, 331.21)];
    [trayStrokePath addCurveToPoint:CGPointMake(183.57, 339.43) controlPoint1:CGPointMake(194.71, 334.73) controlPoint2:CGPointMake(189.09, 337.16)];
    [trayStrokePath addCurveToPoint:CGPointMake(168.78, 363.08) controlPoint1:CGPointMake(173.11, 343.73) controlPoint2:CGPointMake(169.37, 352.59)];
    [trayStrokePath addCurveToPoint:CGPointMake(168.55, 379.14) controlPoint1:CGPointMake(168.7, 368.43) controlPoint2:CGPointMake(168.62, 373.78)];
    [trayStrokePath addLineToPoint:CGPointMake(168.2, 379.08)];
    [trayStrokePath addCurveToPoint:CGPointMake(168.26, 406) controlPoint1:CGPointMake(168.24, 388.05) controlPoint2:CGPointMake(168.25, 397.03)];
    [trayStrokePath addCurveToPoint:CGPointMake(168.26, 609.93) controlPoint1:CGPointMake(167.91, 446.82) controlPoint2:CGPointMake(167.91, 569.11)];
    [trayStrokePath addCurveToPoint:CGPointMake(168.2, 636.85) controlPoint1:CGPointMake(168.25, 618.9) controlPoint2:CGPointMake(168.24, 627.87)];
    [trayStrokePath addLineToPoint:CGPointMake(168.55, 636.79)];
    [trayStrokePath addCurveToPoint:CGPointMake(168.78, 652.85) controlPoint1:CGPointMake(168.62, 642.15) controlPoint2:CGPointMake(168.7, 647.5)];
    [trayStrokePath addCurveToPoint:CGPointMake(183.57, 676.5) controlPoint1:CGPointMake(169.37, 663.34) controlPoint2:CGPointMake(173.11, 672.2)];
    [trayStrokePath addCurveToPoint:CGPointMake(200.51, 682.23) controlPoint1:CGPointMake(189.09, 678.77) controlPoint2:CGPointMake(194.71, 681.2)];
    [trayStrokePath addCurveToPoint:CGPointMake(242.59, 688.28) controlPoint1:CGPointMake(214.46, 684.72) controlPoint2:CGPointMake(228.49, 687.23)];
    [trayStrokePath addCurveToPoint:CGPointMake(688.79, 697.56) controlPoint1:CGPointMake(391.04, 698.96) controlPoint2:CGPointMake(540.05, 696.69)];
    [trayStrokePath addCurveToPoint:CGPointMake(1218, 697.94) controlPoint1:CGPointMake(859.28, 697.93) controlPoint2:CGPointMake(1047.23, 698.01)];
    [trayStrokePath addCurveToPoint:CGPointMake(1747.21, 697.56) controlPoint1:CGPointMake(1388.77, 698.01) controlPoint2:CGPointMake(1576.72, 697.93)];
    [trayStrokePath addCurveToPoint:CGPointMake(2193.41, 688.28) controlPoint1:CGPointMake(1895.95, 696.69) controlPoint2:CGPointMake(2044.96, 698.96)];
    [trayStrokePath addCurveToPoint:CGPointMake(2235.49, 682.23) controlPoint1:CGPointMake(2207.51, 687.23) controlPoint2:CGPointMake(2221.54, 684.72)];
    [trayStrokePath addCurveToPoint:CGPointMake(2252.43, 676.5) controlPoint1:CGPointMake(2241.29, 681.2) controlPoint2:CGPointMake(2246.91, 678.77)];
    [trayStrokePath addCurveToPoint:CGPointMake(2267.22, 652.85) controlPoint1:CGPointMake(2262.89, 672.2) controlPoint2:CGPointMake(2266.63, 663.34)];
    [trayStrokePath addCurveToPoint:CGPointMake(2267.45, 636.79) controlPoint1:CGPointMake(2267.3, 647.5) controlPoint2:CGPointMake(2267.38, 642.15)];
    [trayStrokePath addLineToPoint:CGPointMake(2267.8, 636.85)];
    [trayStrokePath addCurveToPoint:CGPointMake(2267.74, 609.92) controlPoint1:CGPointMake(2267.76, 627.87) controlPoint2:CGPointMake(2267.75, 618.9)];
    [trayStrokePath addCurveToPoint:CGPointMake(2267.74, 406.01) controlPoint1:CGPointMake(2268.09, 569.11) controlPoint2:CGPointMake(2268.09, 446.82)];
    [trayStrokePath closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
        case GameStateSpell:
            [secondaryInactiveStrokeColor setStroke];
            break;
        case GameStateWord:
            [secondaryActiveStrokeColor setStroke];
            break;
        case GameStateSubmit:
            [secondaryHighlightedStrokeColor setStroke];
            break;
    }
    trayStrokePath.lineWidth = 24;
    [trayStrokePath stroke];


    //// Word-Tile-Fill-1 Drawing
    UIBezierPath* wordTileFill1Path = [UIBezierPath bezierPathWithRect: CGRectMake(328.5, 383.45, 223, 249)];
    [wordTileFillColor setFill];
    [wordTileFill1Path fill];


    //// Word-Tile-Fill-2 Drawing
    UIBezierPath* wordTileFill2Path = [UIBezierPath bezierPathWithRect: CGRectMake(587.85, 383.45, 223, 249)];
    [wordTileFillColor setFill];
    [wordTileFill2Path fill];


    //// Word-Tile-Fill-3 Drawing
    UIBezierPath* wordTileFill3Path = [UIBezierPath bezierPathWithRect: CGRectMake(847.15, 383.45, 223, 249)];
    [wordTileFillColor setFill];
    [wordTileFill3Path fill];


    if (tappablesStroke) {

        //// Word-Tile-Stroke-1 Drawing
        UIBezierPath* wordTileStroke1Path = [UIBezierPath bezierPath];
        [wordTileStroke1Path moveToPoint:CGPointMake(554, 380.97)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(326, 380.97)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(326, 634.97)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(554, 634.97)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(554, 380.97)];
        [wordTileStroke1Path closePath];
        [wordTileStroke1Path moveToPoint:CGPointMake(549, 629.96)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(331, 629.96)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(331, 385.96)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(549, 385.96)];
        [wordTileStroke1Path addLineToPoint:CGPointMake(549, 629.96)];
        [wordTileStroke1Path closePath];
        [wordTileStrokeColor setFill];
        [wordTileStroke1Path fill];


        //// Word-Tile-Stroke-2 Drawing
        UIBezierPath* wordTileStroke2Path = [UIBezierPath bezierPath];
        [wordTileStroke2Path moveToPoint:CGPointMake(813.33, 380.97)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(585.33, 380.97)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(585.33, 634.97)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(813.33, 634.97)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(813.33, 380.97)];
        [wordTileStroke2Path closePath];
        [wordTileStroke2Path moveToPoint:CGPointMake(808.33, 629.96)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(590.33, 629.96)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(590.33, 385.96)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(808.33, 385.96)];
        [wordTileStroke2Path addLineToPoint:CGPointMake(808.33, 629.96)];
        [wordTileStroke2Path closePath];
        [wordTileStrokeColor setFill];
        [wordTileStroke2Path fill];


        //// Word-Tile-Stroke-3 Drawing
        UIBezierPath* wordTileStroke3Path = [UIBezierPath bezierPath];
        [wordTileStroke3Path moveToPoint:CGPointMake(1072.67, 380.97)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(844.67, 380.97)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(844.67, 634.97)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(1072.67, 634.97)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(1072.67, 380.97)];
        [wordTileStroke3Path closePath];
        [wordTileStroke3Path moveToPoint:CGPointMake(1067.67, 629.96)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(849.67, 629.96)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(849.67, 385.96)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(1067.67, 385.96)];
        [wordTileStroke3Path addLineToPoint:CGPointMake(1067.67, 629.96)];
        [wordTileStroke3Path closePath];
        [wordTileStrokeColor setFill];
        [wordTileStroke3Path fill];
    }

    //// Word-Tile-Letter-1 Drawing
    UIBezierPath* wordTileLetter1Path = [UIBezierPath bezierPath];
    [wordTileLetter1Path moveToPoint:CGPointMake(440, 511.93)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(460.9, 439.03)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(497.64, 439.03)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(497.64, 565.02)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(471.88, 565.02)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(472.06, 473.41)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(443.43, 565.74)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(435.14, 565.74)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(406.5, 473.59)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(406.86, 565.02)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(382.37, 565.02)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(382.37, 439.03)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(419.11, 439.03)];
    [wordTileLetter1Path addLineToPoint:CGPointMake(440, 511.93)];
    [wordTileLetter1Path closePath];
    [wordTileContentColor setFill];
    [wordTileLetter1Path fill];


    //// Word-Tile-Letter-2 Drawing
    UIBezierPath* wordTileLetter2Path = [UIBezierPath bezierPath];
    [wordTileLetter2Path moveToPoint:CGPointMake(710.77, 516.43)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(698.88, 468.55)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(686.64, 516.43)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(710.77, 516.43)];
    [wordTileLetter2Path closePath];
    [wordTileLetter2Path moveToPoint:CGPointMake(684.48, 438.67)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(715.1, 438.67)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(750.22, 565.02)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(721.76, 565.02)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(715.28, 538.21)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(681.96, 538.21)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(675.47, 565.02)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(648.45, 565.02)];
    [wordTileLetter2Path addLineToPoint:CGPointMake(684.48, 438.67)];
    [wordTileLetter2Path closePath];
    [wordTileContentColor setFill];
    [wordTileLetter2Path fill];


    //// Word-Tile-Score-1 Drawing
    UIBezierPath* wordTileScore1Path = [UIBezierPath bezierPath];
    [wordTileScore1Path moveToPoint:CGPointMake(521.32, 615.32)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(512.38, 613.45) controlPoint1:CGPointMake(517.47, 615.32) controlPoint2:CGPointMake(514.74, 614.55)];
    [wordTileScore1Path addLineToPoint:CGPointMake(511.61, 606.44)];
    [wordTileScore1Path addLineToPoint:CGPointMake(511.71, 606.39)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(520.45, 609.32) controlPoint1:CGPointMake(514.59, 608.27) controlPoint2:CGPointMake(517.62, 609.32)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(525.54, 605.15) controlPoint1:CGPointMake(523.48, 609.32) controlPoint2:CGPointMake(525.54, 607.59)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(516.08, 598.52) controlPoint1:CGPointMake(525.54, 602.31) controlPoint2:CGPointMake(523.38, 600.39)];
    [wordTileScore1Path addLineToPoint:CGPointMake(516.08, 595.78)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(525.06, 588.73) controlPoint1:CGPointMake(523.19, 592.76) controlPoint2:CGPointMake(525.06, 591.03)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(520.98, 585.32) controlPoint1:CGPointMake(525.06, 586.66) controlPoint2:CGPointMake(523.43, 585.32)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(512.57, 588.49) controlPoint1:CGPointMake(518.05, 585.32) controlPoint2:CGPointMake(515.07, 586.71)];
    [wordTileScore1Path addLineToPoint:CGPointMake(512.48, 588.49)];
    [wordTileScore1Path addLineToPoint:CGPointMake(512.48, 582.05)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(522.13, 579.32) controlPoint1:CGPointMake(514.69, 580.66) controlPoint2:CGPointMake(518.05, 579.32)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(532.27, 587.67) controlPoint1:CGPointMake(528.33, 579.32) controlPoint2:CGPointMake(532.27, 582.68)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(525.45, 596.55) controlPoint1:CGPointMake(532.27, 591.22) controlPoint2:CGPointMake(530.11, 594.1)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(532.7, 605.63) controlPoint1:CGPointMake(530.2, 598.28) controlPoint2:CGPointMake(532.7, 601.64)];
    [wordTileScore1Path addCurveToPoint:CGPointMake(521.32, 615.32) controlPoint1:CGPointMake(532.7, 611.82) controlPoint2:CGPointMake(527.22, 615.32)];
    [wordTileScore1Path closePath];
    [wordTileContentColor setFill];
    [wordTileScore1Path fill];


    //// Word-Tile-Letter-3 Drawing
    UIBezierPath* wordTileLetter3Path = [UIBezierPath bezierPath];
    [wordTileLetter3Path moveToPoint:CGPointMake(915.44, 439.03)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(940.66, 439.03)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(977.4, 507.61)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(977.22, 439.03)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(1001.9, 439.03)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(1001.9, 565.38)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(982.09, 565.38)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(939.76, 488.35)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(940.12, 565.02)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(915.44, 565.02)];
    [wordTileLetter3Path addLineToPoint:CGPointMake(915.44, 439.03)];
    [wordTileLetter3Path closePath];
    [wordTileContentColor setFill];
    [wordTileLetter3Path fill];


    //// Word-Tile-Score-2 Drawing
    UIBezierPath* wordTileScore2Path = [UIBezierPath bezierPath];
    [wordTileScore2Path moveToPoint:CGPointMake(775.32, 587.38)];
    [wordTileScore2Path addLineToPoint:CGPointMake(789.44, 579.22)];
    [wordTileScore2Path addLineToPoint:CGPointMake(790.06, 579.46)];
    [wordTileScore2Path addLineToPoint:CGPointMake(790.06, 614.79)];
    [wordTileScore2Path addLineToPoint:CGPointMake(782.96, 614.79)];
    [wordTileScore2Path addLineToPoint:CGPointMake(782.96, 590.26)];
    [wordTileScore2Path addLineToPoint:CGPointMake(775.41, 594.63)];
    [wordTileScore2Path addLineToPoint:CGPointMake(775.32, 594.58)];
    [wordTileScore2Path addLineToPoint:CGPointMake(775.32, 587.38)];
    [wordTileScore2Path closePath];
    [wordTileContentColor setFill];
    [wordTileScore2Path fill];


    //// Word-Tile-Score-3 Drawing
    UIBezierPath* wordTileScore3Path = [UIBezierPath bezierPath];
    [wordTileScore3Path moveToPoint:CGPointMake(1034.65, 587.38)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1048.78, 579.22)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1049.4, 579.46)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1049.4, 614.79)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1042.29, 614.79)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1042.29, 590.26)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1034.75, 594.63)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1034.65, 594.58)];
    [wordTileScore3Path addLineToPoint:CGPointMake(1034.65, 587.38)];
    [wordTileScore3Path closePath];
    [wordTileContentColor setFill];
    [wordTileScore3Path fill];


    //// Ex-Fill Drawing
    UIBezierPath* exFillPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(187.5, 69.6, 180.1, 179.9)];
    [primaryFillColor setFill];
    [exFillPath fill];


    //// Trash-Fill Drawing
    UIBezierPath* trashFillPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2068.5, 69.6, 180.1, 179.9)];
    [primaryFillColor setFill];
    [trashFillPath fill];


    //// Ex-Stroke Drawing
    UIBezierPath* exStrokePath = [UIBezierPath bezierPath];
    [exStrokePath moveToPoint:CGPointMake(277.5, 67)];
    [exStrokePath addCurveToPoint:CGPointMake(185, 159.5) controlPoint1:CGPointMake(226.41, 67) controlPoint2:CGPointMake(185, 108.41)];
    [exStrokePath addCurveToPoint:CGPointMake(277.5, 252) controlPoint1:CGPointMake(185, 210.59) controlPoint2:CGPointMake(226.41, 252)];
    [exStrokePath addCurveToPoint:CGPointMake(370, 159.5) controlPoint1:CGPointMake(328.59, 252) controlPoint2:CGPointMake(370, 210.59)];
    [exStrokePath addCurveToPoint:CGPointMake(277.5, 67) controlPoint1:CGPointMake(370, 108.41) controlPoint2:CGPointMake(328.59, 67)];
    [exStrokePath closePath];
    [exStrokePath moveToPoint:CGPointMake(277.5, 72)];
    [exStrokePath addCurveToPoint:CGPointMake(365, 159.5) controlPoint1:CGPointMake(325.75, 72) controlPoint2:CGPointMake(365, 111.25)];
    [exStrokePath addCurveToPoint:CGPointMake(277.5, 247) controlPoint1:CGPointMake(365, 207.75) controlPoint2:CGPointMake(325.75, 247)];
    [exStrokePath addCurveToPoint:CGPointMake(190, 159.5) controlPoint1:CGPointMake(229.25, 247) controlPoint2:CGPointMake(190, 207.75)];
    [exStrokePath addCurveToPoint:CGPointMake(277.5, 72) controlPoint1:CGPointMake(190, 111.25) controlPoint2:CGPointMake(229.25, 72)];
    [exStrokePath closePath];
    [primaryStrokeColor setFill];
    [exStrokePath fill];


    //// Trash-Stroke Drawing
    UIBezierPath* trashStrokePath = [UIBezierPath bezierPath];
    [trashStrokePath moveToPoint:CGPointMake(2158.5, 67)];
    [trashStrokePath addCurveToPoint:CGPointMake(2066, 159.5) controlPoint1:CGPointMake(2107.41, 67) controlPoint2:CGPointMake(2066, 108.41)];
    [trashStrokePath addCurveToPoint:CGPointMake(2158.5, 252) controlPoint1:CGPointMake(2066, 210.59) controlPoint2:CGPointMake(2107.41, 252)];
    [trashStrokePath addCurveToPoint:CGPointMake(2251, 159.5) controlPoint1:CGPointMake(2209.59, 252) controlPoint2:CGPointMake(2251, 210.59)];
    [trashStrokePath addCurveToPoint:CGPointMake(2158.5, 67) controlPoint1:CGPointMake(2251, 108.41) controlPoint2:CGPointMake(2209.59, 67)];
    [trashStrokePath closePath];
    [trashStrokePath moveToPoint:CGPointMake(2158.5, 72)];
    [trashStrokePath addCurveToPoint:CGPointMake(2246, 159.5) controlPoint1:CGPointMake(2206.75, 72) controlPoint2:CGPointMake(2246, 111.25)];
    [trashStrokePath addCurveToPoint:CGPointMake(2158.5, 247) controlPoint1:CGPointMake(2246, 207.75) controlPoint2:CGPointMake(2206.75, 247)];
    [trashStrokePath addCurveToPoint:CGPointMake(2071, 159.5) controlPoint1:CGPointMake(2110.25, 247) controlPoint2:CGPointMake(2071, 207.75)];
    [trashStrokePath addCurveToPoint:CGPointMake(2158.5, 72) controlPoint1:CGPointMake(2071, 111.25) controlPoint2:CGPointMake(2110.25, 72)];
    [trashStrokePath closePath];
    [primaryStrokeColor setFill];
    [trashStrokePath fill];


    //// Trash-Icon-1 Drawing
    UIBezierPath* trashIcon1Path = [UIBezierPath bezierPath];
    [trashIcon1Path moveToPoint:CGPointMake(2143.39, 200.24)];
    [trashIcon1Path addCurveToPoint:CGPointMake(2143.72, 200.22) controlPoint1:CGPointMake(2143.5, 200.24) controlPoint2:CGPointMake(2143.61, 200.23)];
    [trashIcon1Path addCurveToPoint:CGPointMake(2146.98, 196.31) controlPoint1:CGPointMake(2145.7, 200.04) controlPoint2:CGPointMake(2147.16, 198.29)];
    [trashIcon1Path addLineToPoint:CGPointMake(2143.27, 136.93)];
    [trashIcon1Path addCurveToPoint:CGPointMake(2139.35, 133.67) controlPoint1:CGPointMake(2143.08, 134.95) controlPoint2:CGPointMake(2141.34, 133.49)];
    [trashIcon1Path addCurveToPoint:CGPointMake(2136.09, 137.59) controlPoint1:CGPointMake(2137.37, 133.85) controlPoint2:CGPointMake(2135.91, 135.61)];
    [trashIcon1Path addLineToPoint:CGPointMake(2139.81, 196.97)];
    [trashIcon1Path addCurveToPoint:CGPointMake(2143.39, 200.24) controlPoint1:CGPointMake(2139.98, 198.83) controlPoint2:CGPointMake(2141.55, 200.24)];
    [trashIcon1Path closePath];
    [contentColor setFill];
    [trashIcon1Path fill];


    //// Trash-Icon-2 Drawing
    UIBezierPath* trashIcon2Path = [UIBezierPath bezierPath];
    [trashIcon2Path moveToPoint:CGPointMake(2173.04, 200.22)];
    [trashIcon2Path addCurveToPoint:CGPointMake(2173.38, 200.24) controlPoint1:CGPointMake(2173.16, 200.23) controlPoint2:CGPointMake(2173.27, 200.24)];
    [trashIcon2Path addCurveToPoint:CGPointMake(2176.96, 196.97) controlPoint1:CGPointMake(2175.22, 200.24) controlPoint2:CGPointMake(2176.79, 198.83)];
    [trashIcon2Path addLineToPoint:CGPointMake(2180.67, 137.59)];
    [trashIcon2Path addCurveToPoint:CGPointMake(2177.41, 133.67) controlPoint1:CGPointMake(2180.85, 135.61) controlPoint2:CGPointMake(2179.39, 133.85)];
    [trashIcon2Path addCurveToPoint:CGPointMake(2173.5, 136.93) controlPoint1:CGPointMake(2175.42, 133.49) controlPoint2:CGPointMake(2173.68, 134.95)];
    [trashIcon2Path addLineToPoint:CGPointMake(2169.79, 196.31)];
    [trashIcon2Path addCurveToPoint:CGPointMake(2173.04, 200.22) controlPoint1:CGPointMake(2169.61, 198.29) controlPoint2:CGPointMake(2171.06, 200.04)];
    [trashIcon2Path closePath];
    [contentColor setFill];
    [trashIcon2Path fill];


    //// Trash-Icon-3 Drawing
    UIBezierPath* trashIcon3Path = [UIBezierPath bezierPath];
    [trashIcon3Path moveToPoint:CGPointMake(2158.38, 200.24)];
    [trashIcon3Path addCurveToPoint:CGPointMake(2161.98, 196.64) controlPoint1:CGPointMake(2160.37, 200.24) controlPoint2:CGPointMake(2161.98, 198.62)];
    [trashIcon3Path addLineToPoint:CGPointMake(2161.98, 137.26)];
    [trashIcon3Path addCurveToPoint:CGPointMake(2158.38, 133.66) controlPoint1:CGPointMake(2161.98, 135.27) controlPoint2:CGPointMake(2160.37, 133.66)];
    [trashIcon3Path addCurveToPoint:CGPointMake(2154.78, 137.26) controlPoint1:CGPointMake(2156.39, 133.66) controlPoint2:CGPointMake(2154.78, 135.27)];
    [trashIcon3Path addLineToPoint:CGPointMake(2154.78, 196.64)];
    [trashIcon3Path addCurveToPoint:CGPointMake(2158.38, 200.24) controlPoint1:CGPointMake(2154.78, 198.62) controlPoint2:CGPointMake(2156.39, 200.24)];
    [trashIcon3Path closePath];
    [contentColor setFill];
    [trashIcon3Path fill];


    //// Trash-Icon-4 Drawing
    UIBezierPath* trashIcon4Path = [UIBezierPath bezierPath];
    [trashIcon4Path moveToPoint:CGPointMake(2152.54, 107.09)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2144.34, 115.24) controlPoint1:CGPointMake(2148.05, 107.09) controlPoint2:CGPointMake(2144.37, 110.75)];
    [trashIcon4Path addLineToPoint:CGPointMake(2144.33, 116.24)];
    [trashIcon4Path addLineToPoint:CGPointMake(2172.43, 116.24)];
    [trashIcon4Path addLineToPoint:CGPointMake(2172.43, 115.24)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2164.23, 107.09) controlPoint1:CGPointMake(2172.39, 110.75) controlPoint2:CGPointMake(2168.72, 107.09)];
    [trashIcon4Path addLineToPoint:CGPointMake(2152.54, 107.09)];
    [trashIcon4Path closePath];
    [trashIcon4Path moveToPoint:CGPointMake(2130.87, 201.93)];
    [trashIcon4Path addLineToPoint:CGPointMake(2130.87, 202.09)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2137.68, 208.89) controlPoint1:CGPointMake(2130.87, 205.84) controlPoint2:CGPointMake(2133.92, 208.89)];
    [trashIcon4Path addLineToPoint:CGPointMake(2179.08, 208.89)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2185.9, 202.09) controlPoint1:CGPointMake(2182.84, 208.89) controlPoint2:CGPointMake(2185.9, 205.84)];
    [trashIcon4Path addLineToPoint:CGPointMake(2185.92, 201.65)];
    [trashIcon4Path addLineToPoint:CGPointMake(2192.62, 125.71)];
    [trashIcon4Path addLineToPoint:CGPointMake(2124.15, 125.71)];
    [trashIcon4Path addLineToPoint:CGPointMake(2130.87, 201.93)];
    [trashIcon4Path closePath];
    [trashIcon4Path moveToPoint:CGPointMake(2137.68, 218.09)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2121.65, 202.34) controlPoint1:CGPointMake(2128.98, 218.09) controlPoint2:CGPointMake(2121.79, 211.03)];
    [trashIcon4Path addLineToPoint:CGPointMake(2114.73, 123.84)];
    [trashIcon4Path addLineToPoint:CGPointMake(2111.98, 123.84)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2108.18, 120.04) controlPoint1:CGPointMake(2109.89, 123.84) controlPoint2:CGPointMake(2108.18, 122.14)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2111.98, 116.24) controlPoint1:CGPointMake(2108.18, 117.95) controlPoint2:CGPointMake(2109.89, 116.24)];
    [trashIcon4Path addLineToPoint:CGPointMake(2136.73, 116.24)];
    [trashIcon4Path addLineToPoint:CGPointMake(2136.74, 115.25)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2152.54, 99.49) controlPoint1:CGPointMake(2136.76, 106.56) controlPoint2:CGPointMake(2143.85, 99.49)];
    [trashIcon4Path addLineToPoint:CGPointMake(2164.23, 99.49)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2180.03, 115.25) controlPoint1:CGPointMake(2172.91, 99.49) controlPoint2:CGPointMake(2180, 106.56)];
    [trashIcon4Path addLineToPoint:CGPointMake(2180.03, 116.24)];
    [trashIcon4Path addLineToPoint:CGPointMake(2204.78, 116.24)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2208.58, 120.04) controlPoint1:CGPointMake(2206.88, 116.24) controlPoint2:CGPointMake(2208.58, 117.95)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2204.78, 123.84) controlPoint1:CGPointMake(2208.58, 122.14) controlPoint2:CGPointMake(2206.88, 123.84)];
    [trashIcon4Path addLineToPoint:CGPointMake(2202.03, 123.84)];
    [trashIcon4Path addLineToPoint:CGPointMake(2195.12, 202.27)];
    [trashIcon4Path addCurveToPoint:CGPointMake(2179.08, 218.09) controlPoint1:CGPointMake(2194.98, 211.03) controlPoint2:CGPointMake(2187.79, 218.09)];
    [trashIcon4Path addLineToPoint:CGPointMake(2137.68, 218.09)];
    [trashIcon4Path closePath];
    [contentColor setFill];
    [trashIcon4Path fill];


    //// Ex-Icon Drawing
    UIBezierPath* exIconPath = [UIBezierPath bezierPath];
    [exIconPath moveToPoint:CGPointMake(320.53, 209.5)];
    [exIconPath addCurveToPoint:CGPointMake(315.6, 207.46) controlPoint1:CGPointMake(318.67, 209.5) controlPoint2:CGPointMake(316.92, 208.78)];
    [exIconPath addLineToPoint:CGPointMake(277.5, 169.36)];
    [exIconPath addLineToPoint:CGPointMake(239.4, 207.46)];
    [exIconPath addCurveToPoint:CGPointMake(234.47, 209.5) controlPoint1:CGPointMake(238.08, 208.78) controlPoint2:CGPointMake(236.33, 209.5)];
    [exIconPath addCurveToPoint:CGPointMake(229.54, 207.46) controlPoint1:CGPointMake(232.61, 209.5) controlPoint2:CGPointMake(230.86, 208.78)];
    [exIconPath addCurveToPoint:CGPointMake(229.54, 197.6) controlPoint1:CGPointMake(226.82, 204.74) controlPoint2:CGPointMake(226.82, 200.32)];
    [exIconPath addLineToPoint:CGPointMake(267.64, 159.5)];
    [exIconPath addLineToPoint:CGPointMake(229.54, 121.4)];
    [exIconPath addCurveToPoint:CGPointMake(229.54, 111.54) controlPoint1:CGPointMake(226.82, 118.68) controlPoint2:CGPointMake(226.82, 114.26)];
    [exIconPath addCurveToPoint:CGPointMake(234.47, 109.5) controlPoint1:CGPointMake(230.86, 110.22) controlPoint2:CGPointMake(232.61, 109.5)];
    [exIconPath addCurveToPoint:CGPointMake(239.4, 111.54) controlPoint1:CGPointMake(236.33, 109.5) controlPoint2:CGPointMake(238.08, 110.22)];
    [exIconPath addLineToPoint:CGPointMake(277.5, 149.64)];
    [exIconPath addLineToPoint:CGPointMake(315.6, 111.54)];
    [exIconPath addCurveToPoint:CGPointMake(320.53, 109.5) controlPoint1:CGPointMake(316.92, 110.22) controlPoint2:CGPointMake(318.67, 109.5)];
    [exIconPath addCurveToPoint:CGPointMake(325.46, 111.54) controlPoint1:CGPointMake(322.39, 109.5) controlPoint2:CGPointMake(324.14, 110.22)];
    [exIconPath addCurveToPoint:CGPointMake(325.46, 121.4) controlPoint1:CGPointMake(328.18, 114.26) controlPoint2:CGPointMake(328.18, 118.68)];
    [exIconPath addLineToPoint:CGPointMake(287.36, 159.5)];
    [exIconPath addLineToPoint:CGPointMake(325.46, 197.6)];
    [exIconPath addCurveToPoint:CGPointMake(325.46, 207.46) controlPoint1:CGPointMake(328.18, 200.32) controlPoint2:CGPointMake(328.18, 204.74)];
    [exIconPath addCurveToPoint:CGPointMake(320.53, 209.5) controlPoint1:CGPointMake(324.14, 208.78) controlPoint2:CGPointMake(322.39, 209.5)];
    [exIconPath closePath];
    [contentColor setFill];
    [exIconPath fill];


    //// Tile-Fill-1 Drawing
    UIBezierPath* tileFill1Path = [UIBezierPath bezierPathWithRect: CGRectMake(328.5, 782.5, 223, 249)];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [primaryFillColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveFillColor setFill];
    }
    [tileFill1Path fill];


    //// Tile-Fill-2 Drawing
    UIBezierPath* tileFill2Path = [UIBezierPath bezierPathWithRect: CGRectMake(587.85, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tileFill2Path fill];


    //// Tile-Fill-3 Drawing
    UIBezierPath* tileFill3Path = [UIBezierPath bezierPathWithRect: CGRectMake(847.15, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tileFill3Path fill];


    //// Tile-Fill-4 Drawing
    UIBezierPath* tileFill4Path = [UIBezierPath bezierPathWithRect: CGRectMake(1106.5, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tileFill4Path fill];


    //// Tile-Fill-5 Drawing
    UIBezierPath* tileFill5Path = [UIBezierPath bezierPathWithRect: CGRectMake(1365.85, 782.5, 223, 249)];
    switch (self.gameState) {
        case GameStateStart:
            [primaryFillColor setFill];
            break;
        case GameStateTap:
            [highlightedFillColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveFillColor setFill];
    }
    [tileFill5Path fill];


    //// Tile-Fill-6 Drawing
    UIBezierPath* tileFill6Path = [UIBezierPath bezierPathWithRect: CGRectMake(1625.15, 782.5, 223, 249)];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [primaryFillColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveFillColor setFill];
    }
    [tileFill6Path fill];


    //// Tile-Fill-7 Drawing
    UIBezierPath* tileFill7Path = [UIBezierPath bezierPathWithRect: CGRectMake(1884.5, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tileFill7Path fill];

    //// Tile-Stroke-1 Drawing
    UIBezierPath* tileStroke1Path = [UIBezierPath bezierPath];
    [tileStroke1Path moveToPoint:CGPointMake(554, 780)];
    [tileStroke1Path addLineToPoint:CGPointMake(326, 780)];
    [tileStroke1Path addLineToPoint:CGPointMake(326, 1034)];
    [tileStroke1Path addLineToPoint:CGPointMake(554, 1034)];
    [tileStroke1Path addLineToPoint:CGPointMake(554, 780)];
    [tileStroke1Path closePath];
    [tileStroke1Path moveToPoint:CGPointMake(549, 1029)];
    [tileStroke1Path addLineToPoint:CGPointMake(331, 1029)];
    [tileStroke1Path addLineToPoint:CGPointMake(331, 785)];
    [tileStroke1Path addLineToPoint:CGPointMake(549, 785)];
    [tileStroke1Path addLineToPoint:CGPointMake(549, 1029)];
    [tileStroke1Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [primaryStrokeColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveStrokeColor setFill];
    }
    [tileStroke1Path fill];


    //// Tile-Stroke-2 Drawing
    UIBezierPath* tileStroke2Path = [UIBezierPath bezierPath];
    [tileStroke2Path moveToPoint:CGPointMake(813.33, 780)];
    [tileStroke2Path addLineToPoint:CGPointMake(585.33, 780)];
    [tileStroke2Path addLineToPoint:CGPointMake(585.33, 1034)];
    [tileStroke2Path addLineToPoint:CGPointMake(813.33, 1034)];
    [tileStroke2Path addLineToPoint:CGPointMake(813.33, 780)];
    [tileStroke2Path closePath];
    [tileStroke2Path moveToPoint:CGPointMake(808.33, 1029)];
    [tileStroke2Path addLineToPoint:CGPointMake(590.33, 1029)];
    [tileStroke2Path addLineToPoint:CGPointMake(590.33, 785)];
    [tileStroke2Path addLineToPoint:CGPointMake(808.33, 785)];
    [tileStroke2Path addLineToPoint:CGPointMake(808.33, 1029)];
    [tileStroke2Path closePath];
    [primaryStrokeColor setFill];
    [tileStroke2Path fill];


    //// Tile-Stroke-3 Drawing
    UIBezierPath* tileStroke3Path = [UIBezierPath bezierPath];
    [tileStroke3Path moveToPoint:CGPointMake(1072.67, 780)];
    [tileStroke3Path addLineToPoint:CGPointMake(844.67, 780)];
    [tileStroke3Path addLineToPoint:CGPointMake(844.67, 1034)];
    [tileStroke3Path addLineToPoint:CGPointMake(1072.67, 1034)];
    [tileStroke3Path addLineToPoint:CGPointMake(1072.67, 780)];
    [tileStroke3Path closePath];
    [tileStroke3Path moveToPoint:CGPointMake(1067.67, 1029)];
    [tileStroke3Path addLineToPoint:CGPointMake(849.67, 1029)];
    [tileStroke3Path addLineToPoint:CGPointMake(849.67, 785)];
    [tileStroke3Path addLineToPoint:CGPointMake(1067.67, 785)];
    [tileStroke3Path addLineToPoint:CGPointMake(1067.67, 1029)];
    [tileStroke3Path closePath];
    [primaryStrokeColor setFill];
    [tileStroke3Path fill];


    //// Tile-Stroke-4 Drawing
    UIBezierPath* tileStroke4Path = [UIBezierPath bezierPath];
    [tileStroke4Path moveToPoint:CGPointMake(1332, 780)];
    [tileStroke4Path addLineToPoint:CGPointMake(1104, 780)];
    [tileStroke4Path addLineToPoint:CGPointMake(1104, 1034)];
    [tileStroke4Path addLineToPoint:CGPointMake(1332, 1034)];
    [tileStroke4Path addLineToPoint:CGPointMake(1332, 780)];
    [tileStroke4Path closePath];
    [tileStroke4Path moveToPoint:CGPointMake(1327, 1029)];
    [tileStroke4Path addLineToPoint:CGPointMake(1109, 1029)];
    [tileStroke4Path addLineToPoint:CGPointMake(1109, 785)];
    [tileStroke4Path addLineToPoint:CGPointMake(1327, 785)];
    [tileStroke4Path addLineToPoint:CGPointMake(1327, 1029)];
    [tileStroke4Path closePath];
    [primaryStrokeColor setFill];
    [tileStroke4Path fill];


    //// Tile-Stroke-5 Drawing
    UIBezierPath* tileStroke5Path = [UIBezierPath bezierPath];
    [tileStroke5Path moveToPoint:CGPointMake(1591.33, 780)];
    [tileStroke5Path addLineToPoint:CGPointMake(1363.33, 780)];
    [tileStroke5Path addLineToPoint:CGPointMake(1363.33, 1034)];
    [tileStroke5Path addLineToPoint:CGPointMake(1591.33, 1034)];
    [tileStroke5Path addLineToPoint:CGPointMake(1591.33, 780)];
    [tileStroke5Path closePath];
    [tileStroke5Path moveToPoint:CGPointMake(1586.33, 1029)];
    [tileStroke5Path addLineToPoint:CGPointMake(1368.33, 1029)];
    [tileStroke5Path addLineToPoint:CGPointMake(1368.33, 785)];
    [tileStroke5Path addLineToPoint:CGPointMake(1586.33, 785)];
    [tileStroke5Path addLineToPoint:CGPointMake(1586.33, 1029)];
    [tileStroke5Path closePath];
    switch (self.gameState) {
        case GameStateStart:
            [primaryStrokeColor setFill];
            break;
        case GameStateTap:
            [highlightedStrokeColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveStrokeColor setFill];
    }
    [tileStroke5Path fill];

    //// Tile-Stroke-6 Drawing
    UIBezierPath* tileStroke6Path = [UIBezierPath bezierPath];
    [tileStroke6Path moveToPoint:CGPointMake(1850.67, 780)];
    [tileStroke6Path addLineToPoint:CGPointMake(1622.67, 780)];
    [tileStroke6Path addLineToPoint:CGPointMake(1622.67, 1034)];
    [tileStroke6Path addLineToPoint:CGPointMake(1850.67, 1034)];
    [tileStroke6Path addLineToPoint:CGPointMake(1850.67, 780)];
    [tileStroke6Path closePath];
    [tileStroke6Path moveToPoint:CGPointMake(1845.67, 1029)];
    [tileStroke6Path addLineToPoint:CGPointMake(1627.67, 1029)];
    [tileStroke6Path addLineToPoint:CGPointMake(1627.67, 785)];
    [tileStroke6Path addLineToPoint:CGPointMake(1845.67, 785)];
    [tileStroke6Path addLineToPoint:CGPointMake(1845.67, 1029)];
    [tileStroke6Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [primaryStrokeColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveStrokeColor setFill];
    }
    [tileStroke6Path fill];


    //// Tile-Stroke-7 Drawing
    UIBezierPath* tileStroke7Path = [UIBezierPath bezierPath];
    [tileStroke7Path moveToPoint:CGPointMake(2110, 780)];
    [tileStroke7Path addLineToPoint:CGPointMake(1882, 780)];
    [tileStroke7Path addLineToPoint:CGPointMake(1882, 1034)];
    [tileStroke7Path addLineToPoint:CGPointMake(2110, 1034)];
    [tileStroke7Path addLineToPoint:CGPointMake(2110, 780)];
    [tileStroke7Path closePath];
    [tileStroke7Path moveToPoint:CGPointMake(2105, 1029)];
    [tileStroke7Path addLineToPoint:CGPointMake(1887, 1029)];
    [tileStroke7Path addLineToPoint:CGPointMake(1887, 785)];
    [tileStroke7Path addLineToPoint:CGPointMake(2105, 785)];
    [tileStroke7Path addLineToPoint:CGPointMake(2105, 1029)];
    [tileStroke7Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [primaryStrokeColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveStrokeColor setFill];
    }
    [tileStroke7Path fill];


    //// Tile-Letter-1 Drawing
    UIBezierPath* tileLetter1Path = [UIBezierPath bezierPath];
    [tileLetter1Path moveToPoint:CGPointMake(440, 910.96)];
    [tileLetter1Path addLineToPoint:CGPointMake(460.9, 838.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(497.64, 838.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(497.64, 964.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(471.88, 964.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(472.06, 872.44)];
    [tileLetter1Path addLineToPoint:CGPointMake(443.43, 964.78)];
    [tileLetter1Path addLineToPoint:CGPointMake(435.14, 964.78)];
    [tileLetter1Path addLineToPoint:CGPointMake(406.5, 872.62)];
    [tileLetter1Path addLineToPoint:CGPointMake(406.86, 964.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(382.37, 964.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(382.37, 838.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(419.11, 838.06)];
    [tileLetter1Path addLineToPoint:CGPointMake(440, 910.96)];
    [tileLetter1Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [contentColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveContentColor setFill];
    }
    [tileLetter1Path fill];


    //// Tile-Letter-2 Drawing
    UIBezierPath* tileLetter2Path = [UIBezierPath bezierPath];
    [tileLetter2Path moveToPoint:CGPointMake(656.92, 838.06)];
    [tileLetter2Path addLineToPoint:CGPointMake(683.58, 838.06)];
    [tileLetter2Path addLineToPoint:CGPointMake(683.58, 921.04)];
    [tileLetter2Path addCurveToPoint:CGPointMake(699.79, 942.64) controlPoint1:CGPointMake(683.58, 935.98) controlPoint2:CGPointMake(689.7, 942.64)];
    [tileLetter2Path addCurveToPoint:CGPointMake(715.82, 921.04) controlPoint1:CGPointMake(709.69, 942.64) controlPoint2:CGPointMake(715.82, 935.98)];
    [tileLetter2Path addLineToPoint:CGPointMake(715.82, 838.06)];
    [tileLetter2Path addLineToPoint:CGPointMake(741.93, 838.06)];
    [tileLetter2Path addLineToPoint:CGPointMake(741.93, 918.34)];
    [tileLetter2Path addCurveToPoint:CGPointMake(699.43, 966.22) controlPoint1:CGPointMake(741.93, 949.12) controlPoint2:CGPointMake(726.62, 966.22)];
    [tileLetter2Path addCurveToPoint:CGPointMake(656.92, 918.34) controlPoint1:CGPointMake(672.05, 966.22) controlPoint2:CGPointMake(656.92, 949.12)];
    [tileLetter2Path addLineToPoint:CGPointMake(656.92, 838.06)];
    [tileLetter2Path closePath];
    [contentColor setFill];
    [tileLetter2Path fill];


    //// Tile-Letter-3 Drawing
    UIBezierPath* tileLetter3Path = [UIBezierPath bezierPath];
    [tileLetter3Path moveToPoint:CGPointMake(975.33, 912.04)];
    [tileLetter3Path addLineToPoint:CGPointMake(942.01, 912.04)];
    [tileLetter3Path addLineToPoint:CGPointMake(942.01, 964.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(915.35, 964.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(915.35, 838.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(942.01, 838.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(942.01, 888.28)];
    [tileLetter3Path addLineToPoint:CGPointMake(975.33, 888.28)];
    [tileLetter3Path addLineToPoint:CGPointMake(975.33, 838.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(1001.99, 838.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(1001.99, 964.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(975.33, 964.06)];
    [tileLetter3Path addLineToPoint:CGPointMake(975.33, 912.04)];
    [tileLetter3Path closePath];
    [contentColor setFill];
    [tileLetter3Path fill];


    //// Tile-Letter-4 Drawing
    UIBezierPath* tileLetter4Path = [UIBezierPath bezierPath];
    [tileLetter4Path moveToPoint:CGPointMake(1179.28, 901.06)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1226.65, 836.08) controlPoint1:CGPointMake(1179.28, 861.1) controlPoint2:CGPointMake(1199.09, 836.08)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1254.75, 846.34) controlPoint1:CGPointMake(1238.9, 836.08) controlPoint2:CGPointMake(1248.44, 840.94)];
    [tileLetter4Path addLineToPoint:CGPointMake(1254.75, 874.6)];
    [tileLetter4Path addLineToPoint:CGPointMake(1254.39, 874.6)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1230.25, 860.74) controlPoint1:CGPointMake(1247.72, 867.22) controlPoint2:CGPointMake(1239.08, 860.74)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1206.65, 900.7) controlPoint1:CGPointMake(1216.92, 860.74) controlPoint2:CGPointMake(1206.65, 876.4)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1230.25, 941.38) controlPoint1:CGPointMake(1206.65, 927.34) controlPoint2:CGPointMake(1216.92, 941.38)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1255.47, 927.88) controlPoint1:CGPointMake(1239.44, 941.38) controlPoint2:CGPointMake(1248.26, 935.62)];
    [tileLetter4Path addLineToPoint:CGPointMake(1256.01, 928.06)];
    [tileLetter4Path addLineToPoint:CGPointMake(1253.67, 955.78)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1224.85, 966.04) controlPoint1:CGPointMake(1246.64, 961.36) controlPoint2:CGPointMake(1237.45, 966.04)];
    [tileLetter4Path addCurveToPoint:CGPointMake(1179.28, 901.06) controlPoint1:CGPointMake(1198.73, 966.04) controlPoint2:CGPointMake(1179.28, 942.64)];
    [tileLetter4Path closePath];
    [contentColor setFill];
    [tileLetter4Path fill];


    //// Tile-Letter-5 Drawing
    UIBezierPath* tileLetter5Path = [UIBezierPath bezierPath];
    [tileLetter5Path moveToPoint:CGPointMake(1434.11, 838.06)];
    [tileLetter5Path addLineToPoint:CGPointMake(1459.32, 838.06)];
    [tileLetter5Path addLineToPoint:CGPointMake(1496.07, 906.64)];
    [tileLetter5Path addLineToPoint:CGPointMake(1495.89, 838.06)];
    [tileLetter5Path addLineToPoint:CGPointMake(1520.56, 838.06)];
    [tileLetter5Path addLineToPoint:CGPointMake(1520.56, 964.42)];
    [tileLetter5Path addLineToPoint:CGPointMake(1500.75, 964.42)];
    [tileLetter5Path addLineToPoint:CGPointMake(1458.42, 887.38)];
    [tileLetter5Path addLineToPoint:CGPointMake(1458.78, 964.06)];
    [tileLetter5Path addLineToPoint:CGPointMake(1434.11, 964.06)];
    [tileLetter5Path addLineToPoint:CGPointMake(1434.11, 838.06)];
    [tileLetter5Path closePath];
    switch (self.gameState) {
        case GameStateStart:
            [contentColor setFill];
            break;
        case GameStateTap:
            [contentColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveContentColor setFill];
    }
    [tileLetter5Path fill];


    //// Tile-Letter-6 Drawing
    UIBezierPath* tileLetter6Path = [UIBezierPath bezierPath];
    [tileLetter6Path moveToPoint:CGPointMake(1748.11, 915.46)];
    [tileLetter6Path addLineToPoint:CGPointMake(1736.22, 867.58)];
    [tileLetter6Path addLineToPoint:CGPointMake(1723.97, 915.46)];
    [tileLetter6Path addLineToPoint:CGPointMake(1748.11, 915.46)];
    [tileLetter6Path closePath];
    [tileLetter6Path moveToPoint:CGPointMake(1721.81, 837.7)];
    [tileLetter6Path addLineToPoint:CGPointMake(1752.43, 837.7)];
    [tileLetter6Path addLineToPoint:CGPointMake(1787.55, 964.06)];
    [tileLetter6Path addLineToPoint:CGPointMake(1759.09, 964.06)];
    [tileLetter6Path addLineToPoint:CGPointMake(1752.61, 937.24)];
    [tileLetter6Path addLineToPoint:CGPointMake(1719.29, 937.24)];
    [tileLetter6Path addLineToPoint:CGPointMake(1712.8, 964.06)];
    [tileLetter6Path addLineToPoint:CGPointMake(1685.79, 964.06)];
    [tileLetter6Path addLineToPoint:CGPointMake(1721.81, 837.7)];
    [tileLetter6Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [contentColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveContentColor setFill];
    }
    [tileLetter6Path fill];


    //// Tile-Letter-7 Drawing
    UIBezierPath* tileLetter7Path = [UIBezierPath bezierPath];
    [tileLetter7Path moveToPoint:CGPointMake(1995.91, 943)];
    [tileLetter7Path addCurveToPoint:CGPointMake(2006.36, 939.58) controlPoint1:CGPointMake(1999.88, 943) controlPoint2:CGPointMake(2003.48, 941.74)];
    [tileLetter7Path addLineToPoint:CGPointMake(1991.77, 922.66)];
    [tileLetter7Path addLineToPoint:CGPointMake(2006.9, 911.5)];
    [tileLetter7Path addLineToPoint:CGPointMake(2015, 921.4)];
    [tileLetter7Path addCurveToPoint:CGPointMake(2016.63, 900.34) controlPoint1:CGPointMake(2016.09, 915.82) controlPoint2:CGPointMake(2016.63, 908.8)];
    [tileLetter7Path addCurveToPoint:CGPointMake(1995.91, 859.3) controlPoint1:CGPointMake(2016.63, 873.52) controlPoint2:CGPointMake(2008.52, 859.3)];
    [tileLetter7Path addCurveToPoint:CGPointMake(1975.2, 900.52) controlPoint1:CGPointMake(1983.31, 859.3) controlPoint2:CGPointMake(1975.2, 873.52)];
    [tileLetter7Path addCurveToPoint:CGPointMake(1995.91, 943) controlPoint1:CGPointMake(1975.2, 928.24) controlPoint2:CGPointMake(1983.12, 943)];
    [tileLetter7Path closePath];
    [tileLetter7Path moveToPoint:CGPointMake(2028.69, 967.3)];
    [tileLetter7Path addLineToPoint:CGPointMake(2020.95, 957.4)];
    [tileLetter7Path addCurveToPoint:CGPointMake(1995.37, 965.68) controlPoint1:CGPointMake(2013.92, 962.62) controlPoint2:CGPointMake(2005.28, 965.68)];
    [tileLetter7Path addCurveToPoint:CGPointMake(1948, 900.34) controlPoint1:CGPointMake(1966.55, 965.68) controlPoint2:CGPointMake(1948, 940.12)];
    [tileLetter7Path addCurveToPoint:CGPointMake(1995.91, 835.54) controlPoint1:CGPointMake(1948, 860.92) controlPoint2:CGPointMake(1966.73, 835.54)];
    [tileLetter7Path addCurveToPoint:CGPointMake(2043.64, 899.98) controlPoint1:CGPointMake(2025.09, 835.54) controlPoint2:CGPointMake(2043.64, 861.1)];
    [tileLetter7Path addCurveToPoint:CGPointMake(2033.38, 943.54) controlPoint1:CGPointMake(2043.64, 917.98) controlPoint2:CGPointMake(2040.04, 932.56)];
    [tileLetter7Path addLineToPoint:CGPointMake(2044, 956.14)];
    [tileLetter7Path addLineToPoint:CGPointMake(2028.69, 967.3)];
    [tileLetter7Path closePath];
    [contentColor setFill];
    [tileLetter7Path fill];


    //// Tile-Score-1 Drawing
    UIBezierPath* tileScore1Path = [UIBezierPath bezierPath];
    [tileScore1Path moveToPoint:CGPointMake(521.32, 1014.36)];
    [tileScore1Path addCurveToPoint:CGPointMake(512.38, 1012.49) controlPoint1:CGPointMake(517.47, 1014.36) controlPoint2:CGPointMake(514.74, 1013.59)];
    [tileScore1Path addLineToPoint:CGPointMake(511.61, 1005.48)];
    [tileScore1Path addLineToPoint:CGPointMake(511.71, 1005.43)];
    [tileScore1Path addCurveToPoint:CGPointMake(520.45, 1008.36) controlPoint1:CGPointMake(514.59, 1007.3) controlPoint2:CGPointMake(517.62, 1008.36)];
    [tileScore1Path addCurveToPoint:CGPointMake(525.54, 1004.18) controlPoint1:CGPointMake(523.48, 1008.36) controlPoint2:CGPointMake(525.54, 1006.63)];
    [tileScore1Path addCurveToPoint:CGPointMake(516.08, 997.56) controlPoint1:CGPointMake(525.54, 1001.35) controlPoint2:CGPointMake(523.38, 999.43)];
    [tileScore1Path addLineToPoint:CGPointMake(516.08, 994.82)];
    [tileScore1Path addCurveToPoint:CGPointMake(525.06, 987.76) controlPoint1:CGPointMake(523.19, 991.8) controlPoint2:CGPointMake(525.06, 990.07)];
    [tileScore1Path addCurveToPoint:CGPointMake(520.98, 984.35) controlPoint1:CGPointMake(525.06, 985.7) controlPoint2:CGPointMake(523.43, 984.35)];
    [tileScore1Path addCurveToPoint:CGPointMake(512.57, 987.52) controlPoint1:CGPointMake(518.05, 984.35) controlPoint2:CGPointMake(515.07, 985.75)];
    [tileScore1Path addLineToPoint:CGPointMake(512.48, 987.52)];
    [tileScore1Path addLineToPoint:CGPointMake(512.48, 981.09)];
    [tileScore1Path addCurveToPoint:CGPointMake(522.13, 978.35) controlPoint1:CGPointMake(514.69, 979.7) controlPoint2:CGPointMake(518.05, 978.35)];
    [tileScore1Path addCurveToPoint:CGPointMake(532.27, 986.71) controlPoint1:CGPointMake(528.33, 978.35) controlPoint2:CGPointMake(532.27, 981.71)];
    [tileScore1Path addCurveToPoint:CGPointMake(525.45, 995.59) controlPoint1:CGPointMake(532.27, 990.26) controlPoint2:CGPointMake(530.11, 993.14)];
    [tileScore1Path addCurveToPoint:CGPointMake(532.7, 1004.66) controlPoint1:CGPointMake(530.2, 997.32) controlPoint2:CGPointMake(532.7, 1000.68)];
    [tileScore1Path addCurveToPoint:CGPointMake(521.32, 1014.36) controlPoint1:CGPointMake(532.7, 1010.85) controlPoint2:CGPointMake(527.22, 1014.36)];
    [tileScore1Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [contentColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveContentColor setFill];
    }
    [tileScore1Path fill];


    //// Tile-Score-2 Drawing
    UIBezierPath* tileScore2Path = [UIBezierPath bezierPath];
    [tileScore2Path moveToPoint:CGPointMake(775.32, 986.42)];
    [tileScore2Path addLineToPoint:CGPointMake(789.44, 978.26)];
    [tileScore2Path addLineToPoint:CGPointMake(790.07, 978.5)];
    [tileScore2Path addLineToPoint:CGPointMake(790.07, 1013.83)];
    [tileScore2Path addLineToPoint:CGPointMake(782.96, 1013.83)];
    [tileScore2Path addLineToPoint:CGPointMake(782.96, 989.3)];
    [tileScore2Path addLineToPoint:CGPointMake(775.41, 993.67)];
    [tileScore2Path addLineToPoint:CGPointMake(775.32, 993.62)];
    [tileScore2Path addLineToPoint:CGPointMake(775.32, 986.42)];
    [tileScore2Path closePath];
    [contentColor setFill];
    [tileScore2Path fill];


    //// Tile-Score-3 Drawing
    UIBezierPath* tileScore3Path = [UIBezierPath bezierPath];
    [tileScore3Path moveToPoint:CGPointMake(1041.04, 1001.25)];
    [tileScore3Path addLineToPoint:CGPointMake(1041.04, 984.4)];
    [tileScore3Path addLineToPoint:CGPointMake(1032.44, 1001.25)];
    [tileScore3Path addLineToPoint:CGPointMake(1041.04, 1001.25)];
    [tileScore3Path closePath];
    [tileScore3Path moveToPoint:CGPointMake(1047.62, 1013.83)];
    [tileScore3Path addLineToPoint:CGPointMake(1040.85, 1013.83)];
    [tileScore3Path addLineToPoint:CGPointMake(1040.85, 1006.63)];
    [tileScore3Path addLineToPoint:CGPointMake(1025.62, 1006.63)];
    [tileScore3Path addLineToPoint:CGPointMake(1025.29, 1003.32)];
    [tileScore3Path addLineToPoint:CGPointMake(1038.59, 978.69)];
    [tileScore3Path addLineToPoint:CGPointMake(1047.62, 978.69)];
    [tileScore3Path addLineToPoint:CGPointMake(1047.62, 1001.25)];
    [tileScore3Path addLineToPoint:CGPointMake(1052.04, 1001.25)];
    [tileScore3Path addLineToPoint:CGPointMake(1052.04, 1006.63)];
    [tileScore3Path addLineToPoint:CGPointMake(1047.62, 1006.63)];
    [tileScore3Path addLineToPoint:CGPointMake(1047.62, 1013.83)];
    [tileScore3Path closePath];
    [contentColor setFill];
    [tileScore3Path fill];


    //// Tile-Score-4 Drawing
    UIBezierPath* tileScore4Path = [UIBezierPath bezierPath];
    [tileScore4Path moveToPoint:CGPointMake(1299.41, 1014.36)];
    [tileScore4Path addCurveToPoint:CGPointMake(1290.48, 1012.49) controlPoint1:CGPointMake(1295.57, 1014.36) controlPoint2:CGPointMake(1292.83, 1013.59)];
    [tileScore4Path addLineToPoint:CGPointMake(1289.71, 1005.48)];
    [tileScore4Path addLineToPoint:CGPointMake(1289.81, 1005.43)];
    [tileScore4Path addCurveToPoint:CGPointMake(1298.55, 1008.36) controlPoint1:CGPointMake(1292.69, 1007.3) controlPoint2:CGPointMake(1295.72, 1008.36)];
    [tileScore4Path addCurveToPoint:CGPointMake(1303.64, 1004.18) controlPoint1:CGPointMake(1301.58, 1008.36) controlPoint2:CGPointMake(1303.64, 1006.63)];
    [tileScore4Path addCurveToPoint:CGPointMake(1294.18, 997.56) controlPoint1:CGPointMake(1303.64, 1001.35) controlPoint2:CGPointMake(1301.48, 999.43)];
    [tileScore4Path addLineToPoint:CGPointMake(1294.18, 994.82)];
    [tileScore4Path addCurveToPoint:CGPointMake(1303.16, 987.76) controlPoint1:CGPointMake(1301.29, 991.8) controlPoint2:CGPointMake(1303.16, 990.07)];
    [tileScore4Path addCurveToPoint:CGPointMake(1299.08, 984.35) controlPoint1:CGPointMake(1303.16, 985.7) controlPoint2:CGPointMake(1301.53, 984.35)];
    [tileScore4Path addCurveToPoint:CGPointMake(1290.67, 987.52) controlPoint1:CGPointMake(1296.15, 984.35) controlPoint2:CGPointMake(1293.17, 985.75)];
    [tileScore4Path addLineToPoint:CGPointMake(1290.58, 987.52)];
    [tileScore4Path addLineToPoint:CGPointMake(1290.58, 981.09)];
    [tileScore4Path addCurveToPoint:CGPointMake(1300.23, 978.35) controlPoint1:CGPointMake(1292.79, 979.7) controlPoint2:CGPointMake(1296.15, 978.35)];
    [tileScore4Path addCurveToPoint:CGPointMake(1310.37, 986.71) controlPoint1:CGPointMake(1306.43, 978.35) controlPoint2:CGPointMake(1310.37, 981.71)];
    [tileScore4Path addCurveToPoint:CGPointMake(1303.55, 995.59) controlPoint1:CGPointMake(1310.37, 990.26) controlPoint2:CGPointMake(1308.2, 993.14)];
    [tileScore4Path addCurveToPoint:CGPointMake(1310.8, 1004.66) controlPoint1:CGPointMake(1308.3, 997.32) controlPoint2:CGPointMake(1310.8, 1000.68)];
    [tileScore4Path addCurveToPoint:CGPointMake(1299.41, 1014.36) controlPoint1:CGPointMake(1310.8, 1010.85) controlPoint2:CGPointMake(1305.32, 1014.36)];
    [tileScore4Path closePath];
    [contentColor setFill];
    [tileScore4Path fill];


    //// Tile-Score-5 Drawing
    UIBezierPath* tileScore5Path = [UIBezierPath bezierPath];
    [tileScore5Path moveToPoint:CGPointMake(1553.32, 986.42)];
    [tileScore5Path addLineToPoint:CGPointMake(1567.44, 978.26)];
    [tileScore5Path addLineToPoint:CGPointMake(1568.07, 978.5)];
    [tileScore5Path addLineToPoint:CGPointMake(1568.07, 1013.83)];
    [tileScore5Path addLineToPoint:CGPointMake(1560.96, 1013.83)];
    [tileScore5Path addLineToPoint:CGPointMake(1560.96, 989.3)];
    [tileScore5Path addLineToPoint:CGPointMake(1553.41, 993.67)];
    [tileScore5Path addLineToPoint:CGPointMake(1553.32, 993.62)];
    [tileScore5Path addLineToPoint:CGPointMake(1553.32, 986.42)];
    [tileScore5Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [contentColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveContentColor setFill];
    }
    [tileScore5Path fill];


    //// Tile-Score-6 Drawing
    UIBezierPath* tileScore6Path = [UIBezierPath bezierPath];
    [tileScore6Path moveToPoint:CGPointMake(1812.65, 986.42)];
    [tileScore6Path addLineToPoint:CGPointMake(1826.77, 978.26)];
    [tileScore6Path addLineToPoint:CGPointMake(1827.4, 978.5)];
    [tileScore6Path addLineToPoint:CGPointMake(1827.4, 1013.83)];
    [tileScore6Path addLineToPoint:CGPointMake(1820.29, 1013.83)];
    [tileScore6Path addLineToPoint:CGPointMake(1820.29, 989.3)];
    [tileScore6Path addLineToPoint:CGPointMake(1812.75, 993.67)];
    [tileScore6Path addLineToPoint:CGPointMake(1812.65, 993.62)];
    [tileScore6Path addLineToPoint:CGPointMake(1812.65, 986.42)];
    [tileScore6Path closePath];
    switch (self.gameState) {
        case GameStateStart:
        case GameStateTap:
            [contentColor setFill];
            break;
        case GameStateSpell:
        case GameStateWord:
        case GameStateSubmit:
            [inactiveContentColor setFill];
    }
    [tileScore6Path fill];


    //// Tile-Score-7 Drawing
    UIBezierPath* tileScore7Path = [UIBezierPath bezierPath];
    [tileScore7Path moveToPoint:CGPointMake(2077.32, 997.22)];
    [tileScore7Path addCurveToPoint:CGPointMake(2080.34, 996.93) controlPoint1:CGPointMake(2078.28, 997.22) controlPoint2:CGPointMake(2079.29, 997.12)];
    [tileScore7Path addCurveToPoint:CGPointMake(2081.74, 990.55) controlPoint1:CGPointMake(2081.35, 994.68) controlPoint2:CGPointMake(2081.74, 992.75)];
    [tileScore7Path addCurveToPoint:CGPointMake(2076.88, 984.02) controlPoint1:CGPointMake(2081.74, 986.51) controlPoint2:CGPointMake(2079.82, 984.02)];
    [tileScore7Path addCurveToPoint:CGPointMake(2071.89, 990.74) controlPoint1:CGPointMake(2073.81, 984.02) controlPoint2:CGPointMake(2071.89, 986.75)];
    [tileScore7Path addCurveToPoint:CGPointMake(2077.32, 997.22) controlPoint1:CGPointMake(2071.89, 995.35) controlPoint2:CGPointMake(2074, 997.22)];
    [tileScore7Path closePath];
    [tileScore7Path moveToPoint:CGPointMake(2078.38, 1013.83)];
    [tileScore7Path addLineToPoint:CGPointMake(2070.4, 1013.83)];
    [tileScore7Path addLineToPoint:CGPointMake(2076.93, 1003.84)];
    [tileScore7Path addCurveToPoint:CGPointMake(2077.99, 1002.12) controlPoint1:CGPointMake(2077.32, 1003.27) controlPoint2:CGPointMake(2077.65, 1002.69)];
    [tileScore7Path addCurveToPoint:CGPointMake(2074.72, 1002.5) controlPoint1:CGPointMake(2076.93, 1002.4) controlPoint2:CGPointMake(2075.88, 1002.5)];
    [tileScore7Path addCurveToPoint:CGPointMake(2064.83, 990.98) controlPoint1:CGPointMake(2069.44, 1002.5) controlPoint2:CGPointMake(2064.83, 998.56)];
    [tileScore7Path addCurveToPoint:CGPointMake(2077.03, 978.16) controlPoint1:CGPointMake(2064.83, 983.83) controlPoint2:CGPointMake(2069.54, 978.16)];
    [tileScore7Path addCurveToPoint:CGPointMake(2088.8, 990.59) controlPoint1:CGPointMake(2084.67, 978.16) controlPoint2:CGPointMake(2088.8, 983.2)];
    [tileScore7Path addCurveToPoint:CGPointMake(2082.99, 1006.1) controlPoint1:CGPointMake(2088.8, 995.54) controlPoint2:CGPointMake(2086.78, 999.91)];
    [tileScore7Path addLineToPoint:CGPointMake(2078.38, 1013.83)];
    [tileScore7Path closePath];
    [contentColor setFill];
    [tileScore7Path fill];
}

@end
