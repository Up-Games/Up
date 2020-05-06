//
//  GameMockupView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "AppDelegate.h"
#import "GameMockupView.h"

@implementation GameMockupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    
    return self;
}

- (void)setColors:(NSDictionary *)colors
{
    _colors = [colors copy];
    [self setNeedsDisplay];
}

- (void)setWordTrayActive:(BOOL)wordTrayActive
{
    _wordTrayActive = wordTrayActive;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeScale(0.33333, 0.33333));

    UIColor *primaryFillColor = self.colors[PrimaryFillKey];
    UIColor *inactiveFillColor = self.colors[InactiveFillKey];
    UIColor *activeFillColor = self.colors[ActiveFillKey];
    UIColor *highlightedFillColor = self.colors[HighlightedFillKey];
    UIColor *primaryStrokeColor = self.colors[PrimaryStrokeKey];
    UIColor *inactiveStrokeColor = self.colors[InactiveStrokeKey];
    UIColor *activeStrokeColor = self.colors[ActiveStrokeKey];
    UIColor *highlightedStrokeColor = self.colors[HighlightedStrokeKey];
    UIColor *contentColor = self.colors[ContentKey];
    UIColor *informationColor = self.colors[InformationKey];
    UIColor *canvasColor = self.colors[CanvasKey];

    //// Canvas-Backdrop Drawing
    UIBezierPath* canvasBackdropPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 2436, 1125)];
    [canvasColor setFill];
    [canvasBackdropPath fill];


    //// Time-1 Drawing
    UIBezierPath* time1Path = [UIBezierPath bezierPath];
    [time1Path moveToPoint: CGPointMake(755.53, 109.52)];
    [time1Path addLineToPoint: CGPointMake(810.13, 82.92)];
    [time1Path addLineToPoint: CGPointMake(813.13, 83.72)];
    [time1Path addLineToPoint: CGPointMake(813.13, 200.32)];
    [time1Path addLineToPoint: CGPointMake(839.33, 200.32)];
    [time1Path addLineToPoint: CGPointMake(839.33, 225.31)];
    [time1Path addLineToPoint: CGPointMake(755.13, 225.31)];
    [time1Path addLineToPoint: CGPointMake(755.13, 200.32)];
    [time1Path addLineToPoint: CGPointMake(783.73, 200.32)];
    [time1Path addLineToPoint: CGPointMake(783.73, 124.92)];
    [time1Path addLineToPoint: CGPointMake(755.93, 138.72)];
    [time1Path addLineToPoint: CGPointMake(755.53, 138.52)];
    [time1Path addLineToPoint: CGPointMake(755.53, 109.52)];
    [time1Path closePath];
    [informationColor setFill];
    [time1Path fill];


    //// Time-2 Drawing
    UIBezierPath* time2Path = [UIBezierPath bezierPath];
    [time2Path moveToPoint: CGPointMake(872.53, 164.12)];
    [time2Path addCurveToPoint: CGPointMake(889.92, 182.32) controlPoint1: CGPointMake(882.33, 164.12) controlPoint2: CGPointMake(889.92, 172.52)];
    [time2Path addCurveToPoint: CGPointMake(872.53, 200.32) controlPoint1: CGPointMake(889.92, 191.92) controlPoint2: CGPointMake(882.33, 200.32)];
    [time2Path addCurveToPoint: CGPointMake(854.93, 182.32) controlPoint1: CGPointMake(862.53, 200.32) controlPoint2: CGPointMake(854.93, 191.92)];
    [time2Path addCurveToPoint: CGPointMake(872.53, 164.12) controlPoint1: CGPointMake(854.93, 172.52) controlPoint2: CGPointMake(862.53, 164.12)];
    [time2Path closePath];
    [time2Path moveToPoint: CGPointMake(872.53, 108.12)];
    [time2Path addCurveToPoint: CGPointMake(889.92, 126.12) controlPoint1: CGPointMake(882.33, 108.12) controlPoint2: CGPointMake(889.92, 116.32)];
    [time2Path addCurveToPoint: CGPointMake(872.53, 144.32) controlPoint1: CGPointMake(889.92, 135.92) controlPoint2: CGPointMake(882.33, 144.32)];
    [time2Path addCurveToPoint: CGPointMake(854.93, 126.12) controlPoint1: CGPointMake(862.53, 144.32) controlPoint2: CGPointMake(854.93, 135.92)];
    [time2Path addCurveToPoint: CGPointMake(872.53, 108.12) controlPoint1: CGPointMake(854.93, 116.32) controlPoint2: CGPointMake(862.53, 108.12)];
    [time2Path closePath];
    [informationColor setFill];
    [time2Path fill];


    //// Time-3 Drawing
    UIBezierPath* time3Path = [UIBezierPath bezierPath];
    [time3Path moveToPoint: CGPointMake(947.12, 227.52)];
    [time3Path addCurveToPoint: CGPointMake(908.12, 217.12) controlPoint1: CGPointMake(930.52, 227.52) controlPoint2: CGPointMake(918.12, 223.32)];
    [time3Path addLineToPoint: CGPointMake(905.32, 187.92)];
    [time3Path addLineToPoint: CGPointMake(905.72, 187.72)];
    [time3Path addCurveToPoint: CGPointMake(942.72, 202.72) controlPoint1: CGPointMake(917.92, 197.32) controlPoint2: CGPointMake(931.12, 202.72)];
    [time3Path addCurveToPoint: CGPointMake(963.32, 186.12) controlPoint1: CGPointMake(955.12, 202.72) controlPoint2: CGPointMake(963.32, 195.92)];
    [time3Path addCurveToPoint: CGPointMake(923.52, 159.92) controlPoint1: CGPointMake(963.32, 174.92) controlPoint2: CGPointMake(954.92, 167.52)];
    [time3Path addLineToPoint: CGPointMake(923.52, 149.32)];
    [time3Path addCurveToPoint: CGPointMake(961.52, 121.32) controlPoint1: CGPointMake(953.32, 138.12) controlPoint2: CGPointMake(961.52, 130.52)];
    [time3Path addCurveToPoint: CGPointMake(944.52, 107.92) controlPoint1: CGPointMake(961.52, 113.12) controlPoint2: CGPointMake(954.72, 107.92)];
    [time3Path addCurveToPoint: CGPointMake(908.72, 125.32) controlPoint1: CGPointMake(932.32, 107.92) controlPoint2: CGPointMake(919.72, 114.92)];
    [time3Path addLineToPoint: CGPointMake(908.32, 125.32)];
    [time3Path addLineToPoint: CGPointMake(908.32, 98.12)];
    [time3Path addCurveToPoint: CGPointMake(949.32, 83.12) controlPoint1: CGPointMake(917.52, 90.12) controlPoint2: CGPointMake(932.32, 83.12)];
    [time3Path addCurveToPoint: CGPointMake(991.12, 116.92) controlPoint1: CGPointMake(974.72, 83.12) controlPoint2: CGPointMake(991.12, 96.72)];
    [time3Path addCurveToPoint: CGPointMake(964.12, 152.32) controlPoint1: CGPointMake(991.12, 132.12) controlPoint2: CGPointMake(982.32, 143.32)];
    [time3Path addCurveToPoint: CGPointMake(992.92, 188.92) controlPoint1: CGPointMake(982.92, 158.72) controlPoint2: CGPointMake(992.92, 171.32)];
    [time3Path addCurveToPoint: CGPointMake(947.12, 227.52) controlPoint1: CGPointMake(992.92, 213.32) controlPoint2: CGPointMake(971.72, 227.52)];
    [time3Path closePath];
    [informationColor setFill];
    [time3Path fill];


    //// Time-4 Drawing
    UIBezierPath* time4Path = [UIBezierPath bezierPath];
    [time4Path moveToPoint: CGPointMake(1070.72, 155.32)];
    [time4Path addCurveToPoint: CGPointMake(1052.12, 108.12) controlPoint1: CGPointMake(1070.72, 123.32) controlPoint2: CGPointMake(1063.92, 108.12)];
    [time4Path addCurveToPoint: CGPointMake(1033.92, 155.32) controlPoint1: CGPointMake(1040.52, 108.12) controlPoint2: CGPointMake(1033.92, 123.52)];
    [time4Path addCurveToPoint: CGPointMake(1052.52, 202.51) controlPoint1: CGPointMake(1033.92, 187.12) controlPoint2: CGPointMake(1040.52, 202.51)];
    [time4Path addCurveToPoint: CGPointMake(1070.72, 155.32) controlPoint1: CGPointMake(1064.12, 202.51) controlPoint2: CGPointMake(1070.72, 187.12)];
    [time4Path closePath];
    [time4Path moveToPoint: CGPointMake(1098.32, 155.32)];
    [time4Path addCurveToPoint: CGPointMake(1052.32, 228.11) controlPoint1: CGPointMake(1098.32, 202.71) controlPoint2: CGPointMake(1080.92, 228.11)];
    [time4Path addCurveToPoint: CGPointMake(1006.32, 155.32) controlPoint1: CGPointMake(1023.12, 228.11) controlPoint2: CGPointMake(1006.32, 202.92)];
    [time4Path addCurveToPoint: CGPointMake(1052.32, 82.52) controlPoint1: CGPointMake(1006.32, 108.12) controlPoint2: CGPointMake(1023.72, 82.52)];
    [time4Path addCurveToPoint: CGPointMake(1098.32, 155.32) controlPoint1: CGPointMake(1081.32, 82.52) controlPoint2: CGPointMake(1098.32, 107.72)];
    [time4Path closePath];
    [informationColor setFill];
    [time4Path fill];


    //// Score-1 Drawing
    UIBezierPath* score1Path = [UIBezierPath bezierPath];
    [score1Path moveToPoint: CGPointMake(1561.01, 144.47)];
    [score1Path addCurveToPoint: CGPointMake(1576.81, 124.67) controlPoint1: CGPointMake(1570.41, 144.47) controlPoint2: CGPointMake(1576.81, 136.47)];
    [score1Path addCurveToPoint: CGPointMake(1561.01, 105.47) controlPoint1: CGPointMake(1576.81, 113.07) controlPoint2: CGPointMake(1570.61, 105.47)];
    [score1Path addCurveToPoint: CGPointMake(1545.21, 124.67) controlPoint1: CGPointMake(1551.21, 105.47) controlPoint2: CGPointMake(1545.21, 113.07)];
    [score1Path addCurveToPoint: CGPointMake(1561.01, 144.47) controlPoint1: CGPointMake(1545.21, 136.47) controlPoint2: CGPointMake(1551.81, 144.47)];
    [score1Path closePath];
    [score1Path moveToPoint: CGPointMake(1561.01, 205.86)];
    [score1Path addCurveToPoint: CGPointMake(1578.81, 185.07) controlPoint1: CGPointMake(1571.61, 205.86) controlPoint2: CGPointMake(1578.81, 198.46)];
    [score1Path addCurveToPoint: CGPointMake(1561.01, 164.87) controlPoint1: CGPointMake(1578.81, 172.67) controlPoint2: CGPointMake(1570.81, 164.87)];
    [score1Path addCurveToPoint: CGPointMake(1543.21, 185.07) controlPoint1: CGPointMake(1551.21, 164.87) controlPoint2: CGPointMake(1543.21, 172.67)];
    [score1Path addCurveToPoint: CGPointMake(1561.01, 205.86) controlPoint1: CGPointMake(1543.21, 198.46) controlPoint2: CGPointMake(1550.81, 205.86)];
    [score1Path closePath];
    [score1Path moveToPoint: CGPointMake(1561.01, 228.06)];
    [score1Path addCurveToPoint: CGPointMake(1515.61, 188.47) controlPoint1: CGPointMake(1533.81, 228.06) controlPoint2: CGPointMake(1515.61, 212.66)];
    [score1Path addCurveToPoint: CGPointMake(1536.01, 154.27) controlPoint1: CGPointMake(1515.61, 172.47) controlPoint2: CGPointMake(1523.81, 160.87)];
    [score1Path addCurveToPoint: CGPointMake(1518.61, 122.47) controlPoint1: CGPointMake(1525.21, 147.67) controlPoint2: CGPointMake(1518.61, 136.47)];
    [score1Path addCurveToPoint: CGPointMake(1561.01, 83.27) controlPoint1: CGPointMake(1518.61, 99.67) controlPoint2: CGPointMake(1534.81, 83.27)];
    [score1Path addCurveToPoint: CGPointMake(1603.41, 122.47) controlPoint1: CGPointMake(1587.41, 83.27) controlPoint2: CGPointMake(1603.41, 99.67)];
    [score1Path addCurveToPoint: CGPointMake(1586.01, 154.27) controlPoint1: CGPointMake(1603.41, 136.47) controlPoint2: CGPointMake(1596.81, 147.67)];
    [score1Path addCurveToPoint: CGPointMake(1606.41, 188.47) controlPoint1: CGPointMake(1598.21, 160.67) controlPoint2: CGPointMake(1606.41, 172.47)];
    [score1Path addCurveToPoint: CGPointMake(1561.01, 228.06) controlPoint1: CGPointMake(1606.41, 212.46) controlPoint2: CGPointMake(1587.61, 228.06)];
    [score1Path closePath];
    [informationColor setFill];
    [score1Path fill];


    //// Score-2 Drawing
    UIBezierPath* score2Path = [UIBezierPath bezierPath];
    [score2Path moveToPoint: CGPointMake(1658.61, 225.66)];
    [score2Path addLineToPoint: CGPointMake(1628.01, 225.66)];
    [score2Path addLineToPoint: CGPointMake(1673.41, 111.67)];
    [score2Path addLineToPoint: CGPointMake(1621.61, 111.67)];
    [score2Path addLineToPoint: CGPointMake(1618.41, 85.67)];
    [score2Path addLineToPoint: CGPointMake(1711.21, 85.67)];
    [score2Path addLineToPoint: CGPointMake(1711.81, 87.47)];
    [score2Path addLineToPoint: CGPointMake(1658.61, 225.66)];
    [score2Path closePath];
    [informationColor setFill];
    [score2Path fill];


    //// Tile-1-Fill Drawing
    UIBezierPath* tile1FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(299.5, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tile1FillPath fill];


    //// Tile-1-Stroke Drawing
    UIBezierPath* tile1StrokePath = [UIBezierPath bezierPath];
    [tile1StrokePath moveToPoint: CGPointMake(525, 780)];
    [tile1StrokePath addLineToPoint: CGPointMake(297, 780)];
    [tile1StrokePath addLineToPoint: CGPointMake(297, 1034)];
    [tile1StrokePath addLineToPoint: CGPointMake(525, 1034)];
    [tile1StrokePath addLineToPoint: CGPointMake(525, 780)];
    [tile1StrokePath closePath];
    [tile1StrokePath moveToPoint: CGPointMake(520, 1029)];
    [tile1StrokePath addLineToPoint: CGPointMake(302, 1029)];
    [tile1StrokePath addLineToPoint: CGPointMake(302, 785)];
    [tile1StrokePath addLineToPoint: CGPointMake(520, 785)];
    [tile1StrokePath addLineToPoint: CGPointMake(520, 1029)];
    [tile1StrokePath closePath];
    [primaryStrokeColor setFill];
    [tile1StrokePath fill];


    //// Tile-1-Score Drawing
    UIBezierPath* tile1ScorePath = [UIBezierPath bezierPath];
    [tile1ScorePath moveToPoint: CGPointMake(492.32, 1014.36)];
    [tile1ScorePath addCurveToPoint: CGPointMake(483.38, 1012.49) controlPoint1: CGPointMake(488.47, 1014.36) controlPoint2: CGPointMake(485.74, 1013.59)];
    [tile1ScorePath addLineToPoint: CGPointMake(482.61, 1005.48)];
    [tile1ScorePath addLineToPoint: CGPointMake(482.71, 1005.43)];
    [tile1ScorePath addCurveToPoint: CGPointMake(491.45, 1008.36) controlPoint1: CGPointMake(485.59, 1007.3) controlPoint2: CGPointMake(488.62, 1008.36)];
    [tile1ScorePath addCurveToPoint: CGPointMake(496.54, 1004.18) controlPoint1: CGPointMake(494.48, 1008.36) controlPoint2: CGPointMake(496.54, 1006.63)];
    [tile1ScorePath addCurveToPoint: CGPointMake(487.08, 997.56) controlPoint1: CGPointMake(496.54, 1001.35) controlPoint2: CGPointMake(494.38, 999.43)];
    [tile1ScorePath addLineToPoint: CGPointMake(487.08, 994.82)];
    [tile1ScorePath addCurveToPoint: CGPointMake(496.06, 987.76) controlPoint1: CGPointMake(494.19, 991.8) controlPoint2: CGPointMake(496.06, 990.07)];
    [tile1ScorePath addCurveToPoint: CGPointMake(491.98, 984.35) controlPoint1: CGPointMake(496.06, 985.7) controlPoint2: CGPointMake(494.43, 984.35)];
    [tile1ScorePath addCurveToPoint: CGPointMake(483.57, 987.52) controlPoint1: CGPointMake(489.05, 984.35) controlPoint2: CGPointMake(486.07, 985.75)];
    [tile1ScorePath addLineToPoint: CGPointMake(483.48, 987.52)];
    [tile1ScorePath addLineToPoint: CGPointMake(483.48, 981.09)];
    [tile1ScorePath addCurveToPoint: CGPointMake(493.13, 978.35) controlPoint1: CGPointMake(485.69, 979.7) controlPoint2: CGPointMake(489.05, 978.35)];
    [tile1ScorePath addCurveToPoint: CGPointMake(503.27, 986.71) controlPoint1: CGPointMake(499.33, 978.35) controlPoint2: CGPointMake(503.27, 981.71)];
    [tile1ScorePath addCurveToPoint: CGPointMake(496.45, 995.59) controlPoint1: CGPointMake(503.27, 990.26) controlPoint2: CGPointMake(501.11, 993.14)];
    [tile1ScorePath addCurveToPoint: CGPointMake(503.7, 1004.66) controlPoint1: CGPointMake(501.2, 997.32) controlPoint2: CGPointMake(503.7, 1000.68)];
    [tile1ScorePath addCurveToPoint: CGPointMake(492.32, 1014.36) controlPoint1: CGPointMake(503.7, 1010.85) controlPoint2: CGPointMake(498.22, 1014.36)];
    [tile1ScorePath closePath];
    [contentColor setFill];
    [tile1ScorePath fill];


    //// Tile-1-Letter Drawing
    UIBezierPath* tile1LetterPath = [UIBezierPath bezierPath];
    [tile1LetterPath moveToPoint: CGPointMake(411, 910.96)];
    [tile1LetterPath addLineToPoint: CGPointMake(431.9, 838.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(468.64, 838.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(468.64, 964.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(442.88, 964.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(443.06, 872.44)];
    [tile1LetterPath addLineToPoint: CGPointMake(414.43, 964.78)];
    [tile1LetterPath addLineToPoint: CGPointMake(406.14, 964.78)];
    [tile1LetterPath addLineToPoint: CGPointMake(377.5, 872.62)];
    [tile1LetterPath addLineToPoint: CGPointMake(377.86, 964.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(353.37, 964.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(353.37, 838.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(390.11, 838.06)];
    [tile1LetterPath addLineToPoint: CGPointMake(411, 910.96)];
    [tile1LetterPath closePath];
    [contentColor setFill];
    [tile1LetterPath fill];


    //// Tile-2-Fill Drawing
    UIBezierPath* tile2FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(558.85, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tile2FillPath fill];


    //// Tile-2-Stroke Drawing
    UIBezierPath* tile2StrokePath = [UIBezierPath bezierPath];
    [tile2StrokePath moveToPoint: CGPointMake(784.33, 780)];
    [tile2StrokePath addLineToPoint: CGPointMake(556.33, 780)];
    [tile2StrokePath addLineToPoint: CGPointMake(556.33, 1034)];
    [tile2StrokePath addLineToPoint: CGPointMake(784.33, 1034)];
    [tile2StrokePath addLineToPoint: CGPointMake(784.33, 780)];
    [tile2StrokePath closePath];
    [tile2StrokePath moveToPoint: CGPointMake(779.33, 1029)];
    [tile2StrokePath addLineToPoint: CGPointMake(561.33, 1029)];
    [tile2StrokePath addLineToPoint: CGPointMake(561.33, 785)];
    [tile2StrokePath addLineToPoint: CGPointMake(779.33, 785)];
    [tile2StrokePath addLineToPoint: CGPointMake(779.33, 1029)];
    [tile2StrokePath closePath];
    [primaryStrokeColor setFill];
    [tile2StrokePath fill];


    //// Tile-2-Letter Drawing
    UIBezierPath* tile2LetterPath = [UIBezierPath bezierPath];
    [tile2LetterPath moveToPoint: CGPointMake(627.92, 838.06)];
    [tile2LetterPath addLineToPoint: CGPointMake(654.58, 838.06)];
    [tile2LetterPath addLineToPoint: CGPointMake(654.58, 921.04)];
    [tile2LetterPath addCurveToPoint: CGPointMake(670.79, 942.64) controlPoint1: CGPointMake(654.58, 935.98) controlPoint2: CGPointMake(660.7, 942.64)];
    [tile2LetterPath addCurveToPoint: CGPointMake(686.82, 921.04) controlPoint1: CGPointMake(680.69, 942.64) controlPoint2: CGPointMake(686.82, 935.98)];
    [tile2LetterPath addLineToPoint: CGPointMake(686.82, 838.06)];
    [tile2LetterPath addLineToPoint: CGPointMake(712.93, 838.06)];
    [tile2LetterPath addLineToPoint: CGPointMake(712.93, 918.34)];
    [tile2LetterPath addCurveToPoint: CGPointMake(670.43, 966.22) controlPoint1: CGPointMake(712.93, 949.12) controlPoint2: CGPointMake(697.62, 966.22)];
    [tile2LetterPath addCurveToPoint: CGPointMake(627.92, 918.34) controlPoint1: CGPointMake(643.05, 966.22) controlPoint2: CGPointMake(627.92, 949.12)];
    [tile2LetterPath addLineToPoint: CGPointMake(627.92, 838.06)];
    [tile2LetterPath closePath];
    [contentColor setFill];
    [tile2LetterPath fill];


    //// Tile-2-Score Drawing
    UIBezierPath* tile2ScorePath = [UIBezierPath bezierPath];
    [tile2ScorePath moveToPoint: CGPointMake(746.32, 986.42)];
    [tile2ScorePath addLineToPoint: CGPointMake(760.44, 978.26)];
    [tile2ScorePath addLineToPoint: CGPointMake(761.07, 978.5)];
    [tile2ScorePath addLineToPoint: CGPointMake(761.07, 1013.83)];
    [tile2ScorePath addLineToPoint: CGPointMake(753.96, 1013.83)];
    [tile2ScorePath addLineToPoint: CGPointMake(753.96, 989.3)];
    [tile2ScorePath addLineToPoint: CGPointMake(746.41, 993.67)];
    [tile2ScorePath addLineToPoint: CGPointMake(746.32, 993.62)];
    [tile2ScorePath addLineToPoint: CGPointMake(746.32, 986.42)];
    [tile2ScorePath closePath];
    [contentColor setFill];
    [tile2ScorePath fill];


    //// Tile-3-Fill Drawing
    UIBezierPath* tile3FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(818.15, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tile3FillPath fill];


    //// Tile-3-Stroke Drawing
    UIBezierPath* tile3StrokePath = [UIBezierPath bezierPath];
    [tile3StrokePath moveToPoint: CGPointMake(1043.67, 780)];
    [tile3StrokePath addLineToPoint: CGPointMake(815.67, 780)];
    [tile3StrokePath addLineToPoint: CGPointMake(815.67, 1034)];
    [tile3StrokePath addLineToPoint: CGPointMake(1043.67, 1034)];
    [tile3StrokePath addLineToPoint: CGPointMake(1043.67, 780)];
    [tile3StrokePath closePath];
    [tile3StrokePath moveToPoint: CGPointMake(1038.67, 1029)];
    [tile3StrokePath addLineToPoint: CGPointMake(820.67, 1029)];
    [tile3StrokePath addLineToPoint: CGPointMake(820.67, 785)];
    [tile3StrokePath addLineToPoint: CGPointMake(1038.67, 785)];
    [tile3StrokePath addLineToPoint: CGPointMake(1038.67, 1029)];
    [tile3StrokePath closePath];
    [primaryStrokeColor setFill];
    [tile3StrokePath fill];


    //// Tile-3-Letter Drawing
    UIBezierPath* tile3LetterPath = [UIBezierPath bezierPath];
    [tile3LetterPath moveToPoint: CGPointMake(946.33, 912.04)];
    [tile3LetterPath addLineToPoint: CGPointMake(913.01, 912.04)];
    [tile3LetterPath addLineToPoint: CGPointMake(913.01, 964.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(886.35, 964.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(886.35, 838.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(913.01, 838.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(913.01, 888.28)];
    [tile3LetterPath addLineToPoint: CGPointMake(946.33, 888.28)];
    [tile3LetterPath addLineToPoint: CGPointMake(946.33, 838.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(972.99, 838.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(972.99, 964.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(946.33, 964.06)];
    [tile3LetterPath addLineToPoint: CGPointMake(946.33, 912.04)];
    [tile3LetterPath closePath];
    [contentColor setFill];
    [tile3LetterPath fill];


    //// Tile-3-Score Drawing
    UIBezierPath* tile3ScorePath = [UIBezierPath bezierPath];
    [tile3ScorePath moveToPoint: CGPointMake(1012.04, 1001.25)];
    [tile3ScorePath addLineToPoint: CGPointMake(1012.04, 984.4)];
    [tile3ScorePath addLineToPoint: CGPointMake(1003.44, 1001.25)];
    [tile3ScorePath addLineToPoint: CGPointMake(1012.04, 1001.25)];
    [tile3ScorePath closePath];
    [tile3ScorePath moveToPoint: CGPointMake(1018.62, 1013.83)];
    [tile3ScorePath addLineToPoint: CGPointMake(1011.85, 1013.83)];
    [tile3ScorePath addLineToPoint: CGPointMake(1011.85, 1006.63)];
    [tile3ScorePath addLineToPoint: CGPointMake(996.62, 1006.63)];
    [tile3ScorePath addLineToPoint: CGPointMake(996.29, 1003.32)];
    [tile3ScorePath addLineToPoint: CGPointMake(1009.59, 978.69)];
    [tile3ScorePath addLineToPoint: CGPointMake(1018.62, 978.69)];
    [tile3ScorePath addLineToPoint: CGPointMake(1018.62, 1001.25)];
    [tile3ScorePath addLineToPoint: CGPointMake(1023.04, 1001.25)];
    [tile3ScorePath addLineToPoint: CGPointMake(1023.04, 1006.63)];
    [tile3ScorePath addLineToPoint: CGPointMake(1018.62, 1006.63)];
    [tile3ScorePath addLineToPoint: CGPointMake(1018.62, 1013.83)];
    [tile3ScorePath closePath];
    [contentColor setFill];
    [tile3ScorePath fill];


    //// Tile-4-Fill Drawing
    UIBezierPath* tile4FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1077.5, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tile4FillPath fill];


    //// Tile-4-Stroke Drawing
    UIBezierPath* tile4StrokePath = [UIBezierPath bezierPath];
    [tile4StrokePath moveToPoint: CGPointMake(1303, 780)];
    [tile4StrokePath addLineToPoint: CGPointMake(1075, 780)];
    [tile4StrokePath addLineToPoint: CGPointMake(1075, 1034)];
    [tile4StrokePath addLineToPoint: CGPointMake(1303, 1034)];
    [tile4StrokePath addLineToPoint: CGPointMake(1303, 780)];
    [tile4StrokePath closePath];
    [tile4StrokePath moveToPoint: CGPointMake(1298, 1029)];
    [tile4StrokePath addLineToPoint: CGPointMake(1080, 1029)];
    [tile4StrokePath addLineToPoint: CGPointMake(1080, 785)];
    [tile4StrokePath addLineToPoint: CGPointMake(1298, 785)];
    [tile4StrokePath addLineToPoint: CGPointMake(1298, 1029)];
    [tile4StrokePath closePath];
    [primaryStrokeColor setFill];
    [tile4StrokePath fill];


    //// Tile-4-Letter Drawing
    UIBezierPath* tile4LetterPath = [UIBezierPath bezierPath];
    [tile4LetterPath moveToPoint: CGPointMake(1150.28, 901.06)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1197.65, 836.08) controlPoint1: CGPointMake(1150.28, 861.1) controlPoint2: CGPointMake(1170.09, 836.08)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1225.75, 846.34) controlPoint1: CGPointMake(1209.9, 836.08) controlPoint2: CGPointMake(1219.44, 840.94)];
    [tile4LetterPath addLineToPoint: CGPointMake(1225.75, 874.6)];
    [tile4LetterPath addLineToPoint: CGPointMake(1225.39, 874.6)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1201.25, 860.74) controlPoint1: CGPointMake(1218.72, 867.22) controlPoint2: CGPointMake(1210.08, 860.74)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1177.65, 900.7) controlPoint1: CGPointMake(1187.92, 860.74) controlPoint2: CGPointMake(1177.65, 876.4)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1201.25, 941.38) controlPoint1: CGPointMake(1177.65, 927.34) controlPoint2: CGPointMake(1187.92, 941.38)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1226.47, 927.88) controlPoint1: CGPointMake(1210.44, 941.38) controlPoint2: CGPointMake(1219.26, 935.62)];
    [tile4LetterPath addLineToPoint: CGPointMake(1227.01, 928.06)];
    [tile4LetterPath addLineToPoint: CGPointMake(1224.67, 955.78)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1195.85, 966.04) controlPoint1: CGPointMake(1217.64, 961.36) controlPoint2: CGPointMake(1208.45, 966.04)];
    [tile4LetterPath addCurveToPoint: CGPointMake(1150.28, 901.06) controlPoint1: CGPointMake(1169.73, 966.04) controlPoint2: CGPointMake(1150.28, 942.64)];
    [tile4LetterPath closePath];
    [contentColor setFill];
    [tile4LetterPath fill];


    //// Tile-4-Score Drawing
    UIBezierPath* tile4ScorePath = [UIBezierPath bezierPath];
    [tile4ScorePath moveToPoint: CGPointMake(1270.32, 997.22)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1273.34, 996.93) controlPoint1: CGPointMake(1271.28, 997.22) controlPoint2: CGPointMake(1272.29, 997.12)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1274.74, 990.55) controlPoint1: CGPointMake(1274.35, 994.68) controlPoint2: CGPointMake(1274.74, 992.75)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1269.89, 984.02) controlPoint1: CGPointMake(1274.74, 986.51) controlPoint2: CGPointMake(1272.82, 984.02)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1264.89, 990.74) controlPoint1: CGPointMake(1266.81, 984.02) controlPoint2: CGPointMake(1264.89, 986.75)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1270.32, 997.22) controlPoint1: CGPointMake(1264.89, 995.35) controlPoint2: CGPointMake(1267, 997.22)];
    [tile4ScorePath closePath];
    [tile4ScorePath moveToPoint: CGPointMake(1271.38, 1013.83)];
    [tile4ScorePath addLineToPoint: CGPointMake(1263.4, 1013.83)];
    [tile4ScorePath addLineToPoint: CGPointMake(1269.93, 1003.84)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1270.99, 1002.12) controlPoint1: CGPointMake(1270.32, 1003.27) controlPoint2: CGPointMake(1270.65, 1002.69)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1267.72, 1002.5) controlPoint1: CGPointMake(1269.93, 1002.4) controlPoint2: CGPointMake(1268.88, 1002.5)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1257.83, 990.98) controlPoint1: CGPointMake(1262.44, 1002.5) controlPoint2: CGPointMake(1257.83, 998.56)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1270.03, 978.16) controlPoint1: CGPointMake(1257.83, 983.83) controlPoint2: CGPointMake(1262.54, 978.16)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1281.8, 990.59) controlPoint1: CGPointMake(1277.67, 978.16) controlPoint2: CGPointMake(1281.8, 983.2)];
    [tile4ScorePath addCurveToPoint: CGPointMake(1275.99, 1006.1) controlPoint1: CGPointMake(1281.8, 995.54) controlPoint2: CGPointMake(1279.78, 999.91)];
    [tile4ScorePath addLineToPoint: CGPointMake(1271.38, 1013.83)];
    [tile4ScorePath closePath];
    [contentColor setFill];
    [tile4ScorePath fill];


    //// Tile-5-Fill Drawing
    UIBezierPath* tile5FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1336.85, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tile5FillPath fill];


    //// Tile-5-Stroke Drawing
    UIBezierPath* tile5StrokePath = [UIBezierPath bezierPath];
    [tile5StrokePath moveToPoint: CGPointMake(1562.33, 780)];
    [tile5StrokePath addLineToPoint: CGPointMake(1334.33, 780)];
    [tile5StrokePath addLineToPoint: CGPointMake(1334.33, 1034)];
    [tile5StrokePath addLineToPoint: CGPointMake(1562.33, 1034)];
    [tile5StrokePath addLineToPoint: CGPointMake(1562.33, 780)];
    [tile5StrokePath closePath];
    [tile5StrokePath moveToPoint: CGPointMake(1557.33, 1029)];
    [tile5StrokePath addLineToPoint: CGPointMake(1339.33, 1029)];
    [tile5StrokePath addLineToPoint: CGPointMake(1339.33, 785)];
    [tile5StrokePath addLineToPoint: CGPointMake(1557.33, 785)];
    [tile5StrokePath addLineToPoint: CGPointMake(1557.33, 1029)];
    [tile5StrokePath closePath];
    [primaryStrokeColor setFill];
    [tile5StrokePath fill];


    //// Tile-5-Letter Drawing
    UIBezierPath* tile5LetterPath = [UIBezierPath bezierPath];
    [tile5LetterPath moveToPoint: CGPointMake(1405.11, 838.06)];
    [tile5LetterPath addLineToPoint: CGPointMake(1430.32, 838.06)];
    [tile5LetterPath addLineToPoint: CGPointMake(1467.07, 906.64)];
    [tile5LetterPath addLineToPoint: CGPointMake(1466.89, 838.06)];
    [tile5LetterPath addLineToPoint: CGPointMake(1491.56, 838.06)];
    [tile5LetterPath addLineToPoint: CGPointMake(1491.56, 964.42)];
    [tile5LetterPath addLineToPoint: CGPointMake(1471.75, 964.42)];
    [tile5LetterPath addLineToPoint: CGPointMake(1429.42, 887.38)];
    [tile5LetterPath addLineToPoint: CGPointMake(1429.78, 964.06)];
    [tile5LetterPath addLineToPoint: CGPointMake(1405.11, 964.06)];
    [tile5LetterPath addLineToPoint: CGPointMake(1405.11, 838.06)];
    [tile5LetterPath closePath];
    [contentColor setFill];
    [tile5LetterPath fill];


    //// Tile-5-Score Drawing
    UIBezierPath* tile5ScorePath = [UIBezierPath bezierPath];
    [tile5ScorePath moveToPoint: CGPointMake(1524.32, 986.42)];
    [tile5ScorePath addLineToPoint: CGPointMake(1538.44, 978.26)];
    [tile5ScorePath addLineToPoint: CGPointMake(1539.07, 978.5)];
    [tile5ScorePath addLineToPoint: CGPointMake(1539.07, 1013.83)];
    [tile5ScorePath addLineToPoint: CGPointMake(1531.96, 1013.83)];
    [tile5ScorePath addLineToPoint: CGPointMake(1531.96, 989.3)];
    [tile5ScorePath addLineToPoint: CGPointMake(1524.41, 993.67)];
    [tile5ScorePath addLineToPoint: CGPointMake(1524.32, 993.62)];
    [tile5ScorePath addLineToPoint: CGPointMake(1524.32, 986.42)];
    [tile5ScorePath closePath];
    [contentColor setFill];
    [tile5ScorePath fill];


    //// Tile-6-Fill Drawing
    UIBezierPath* tile6FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1596.15, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tile6FillPath fill];


    //// Tile-6-Stroke Drawing
    UIBezierPath* tile6StrokePath = [UIBezierPath bezierPath];
    [tile6StrokePath moveToPoint: CGPointMake(1821.67, 780)];
    [tile6StrokePath addLineToPoint: CGPointMake(1593.67, 780)];
    [tile6StrokePath addLineToPoint: CGPointMake(1593.67, 1034)];
    [tile6StrokePath addLineToPoint: CGPointMake(1821.67, 1034)];
    [tile6StrokePath addLineToPoint: CGPointMake(1821.67, 780)];
    [tile6StrokePath closePath];
    [tile6StrokePath moveToPoint: CGPointMake(1816.67, 1029)];
    [tile6StrokePath addLineToPoint: CGPointMake(1598.67, 1029)];
    [tile6StrokePath addLineToPoint: CGPointMake(1598.67, 785)];
    [tile6StrokePath addLineToPoint: CGPointMake(1816.67, 785)];
    [tile6StrokePath addLineToPoint: CGPointMake(1816.67, 1029)];
    [tile6StrokePath closePath];
    [primaryStrokeColor setFill];
    [tile6StrokePath fill];


    //// Tile-6-Letter Drawing
    UIBezierPath* tile6LetterPath = [UIBezierPath bezierPath];
    [tile6LetterPath moveToPoint: CGPointMake(1719.11, 915.46)];
    [tile6LetterPath addLineToPoint: CGPointMake(1707.22, 867.58)];
    [tile6LetterPath addLineToPoint: CGPointMake(1694.97, 915.46)];
    [tile6LetterPath addLineToPoint: CGPointMake(1719.11, 915.46)];
    [tile6LetterPath closePath];
    [tile6LetterPath moveToPoint: CGPointMake(1692.81, 837.7)];
    [tile6LetterPath addLineToPoint: CGPointMake(1723.43, 837.7)];
    [tile6LetterPath addLineToPoint: CGPointMake(1758.55, 964.06)];
    [tile6LetterPath addLineToPoint: CGPointMake(1730.09, 964.06)];
    [tile6LetterPath addLineToPoint: CGPointMake(1723.61, 937.24)];
    [tile6LetterPath addLineToPoint: CGPointMake(1690.29, 937.24)];
    [tile6LetterPath addLineToPoint: CGPointMake(1683.8, 964.06)];
    [tile6LetterPath addLineToPoint: CGPointMake(1656.79, 964.06)];
    [tile6LetterPath addLineToPoint: CGPointMake(1692.81, 837.7)];
    [tile6LetterPath closePath];
    [contentColor setFill];
    [tile6LetterPath fill];


    //// Tile-6-Score Drawing
    UIBezierPath* tile6ScorePath = [UIBezierPath bezierPath];
    [tile6ScorePath moveToPoint: CGPointMake(1783.65, 986.42)];
    [tile6ScorePath addLineToPoint: CGPointMake(1797.77, 978.26)];
    [tile6ScorePath addLineToPoint: CGPointMake(1798.4, 978.5)];
    [tile6ScorePath addLineToPoint: CGPointMake(1798.4, 1013.83)];
    [tile6ScorePath addLineToPoint: CGPointMake(1791.29, 1013.83)];
    [tile6ScorePath addLineToPoint: CGPointMake(1791.29, 989.3)];
    [tile6ScorePath addLineToPoint: CGPointMake(1783.75, 993.67)];
    [tile6ScorePath addLineToPoint: CGPointMake(1783.65, 993.62)];
    [tile6ScorePath addLineToPoint: CGPointMake(1783.65, 986.42)];
    [tile6ScorePath closePath];
    [contentColor setFill];
    [tile6ScorePath fill];


    //// Tile-7-Fill Drawing
    UIBezierPath* tile7FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1855.5, 782.5, 223, 249)];
    [primaryFillColor setFill];
    [tile7FillPath fill];


    //// Tile-7-Stroke Drawing
    UIBezierPath* tile7StrokePath = [UIBezierPath bezierPath];
    [tile7StrokePath moveToPoint: CGPointMake(2081, 780)];
    [tile7StrokePath addLineToPoint: CGPointMake(1853, 780)];
    [tile7StrokePath addLineToPoint: CGPointMake(1853, 1034)];
    [tile7StrokePath addLineToPoint: CGPointMake(2081, 1034)];
    [tile7StrokePath addLineToPoint: CGPointMake(2081, 780)];
    [tile7StrokePath closePath];
    [tile7StrokePath moveToPoint: CGPointMake(2076, 1029)];
    [tile7StrokePath addLineToPoint: CGPointMake(1858, 1029)];
    [tile7StrokePath addLineToPoint: CGPointMake(1858, 785)];
    [tile7StrokePath addLineToPoint: CGPointMake(2076, 785)];
    [tile7StrokePath addLineToPoint: CGPointMake(2076, 1029)];
    [tile7StrokePath closePath];
    [primaryStrokeColor setFill];
    [tile7StrokePath fill];


    //// Tile-7-Letter Drawing
    UIBezierPath* tile7LetterPath = [UIBezierPath bezierPath];
    [tile7LetterPath moveToPoint: CGPointMake(1966.91, 943)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1977.36, 939.58) controlPoint1: CGPointMake(1970.88, 943) controlPoint2: CGPointMake(1974.48, 941.74)];
    [tile7LetterPath addLineToPoint: CGPointMake(1962.77, 922.66)];
    [tile7LetterPath addLineToPoint: CGPointMake(1977.9, 911.5)];
    [tile7LetterPath addLineToPoint: CGPointMake(1986, 921.4)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1987.63, 900.34) controlPoint1: CGPointMake(1987.09, 915.82) controlPoint2: CGPointMake(1987.63, 908.8)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1966.91, 859.3) controlPoint1: CGPointMake(1987.63, 873.52) controlPoint2: CGPointMake(1979.52, 859.3)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1946.2, 900.52) controlPoint1: CGPointMake(1954.31, 859.3) controlPoint2: CGPointMake(1946.2, 873.52)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1966.91, 943) controlPoint1: CGPointMake(1946.2, 928.24) controlPoint2: CGPointMake(1954.12, 943)];
    [tile7LetterPath closePath];
    [tile7LetterPath moveToPoint: CGPointMake(1999.69, 967.3)];
    [tile7LetterPath addLineToPoint: CGPointMake(1991.95, 957.4)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1966.37, 965.68) controlPoint1: CGPointMake(1984.92, 962.62) controlPoint2: CGPointMake(1976.28, 965.68)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1919, 900.34) controlPoint1: CGPointMake(1937.55, 965.68) controlPoint2: CGPointMake(1919, 940.12)];
    [tile7LetterPath addCurveToPoint: CGPointMake(1966.91, 835.54) controlPoint1: CGPointMake(1919, 860.92) controlPoint2: CGPointMake(1937.73, 835.54)];
    [tile7LetterPath addCurveToPoint: CGPointMake(2014.64, 899.98) controlPoint1: CGPointMake(1996.09, 835.54) controlPoint2: CGPointMake(2014.64, 861.1)];
    [tile7LetterPath addCurveToPoint: CGPointMake(2004.38, 943.54) controlPoint1: CGPointMake(2014.64, 917.98) controlPoint2: CGPointMake(2011.04, 932.56)];
    [tile7LetterPath addLineToPoint: CGPointMake(2015, 956.14)];
    [tile7LetterPath addLineToPoint: CGPointMake(1999.69, 967.3)];
    [tile7LetterPath closePath];
    [contentColor setFill];
    [tile7LetterPath fill];


    //// Tile-7-Score Drawing
    UIBezierPath* tile7ScorePath = [UIBezierPath bezierPath];
    [tile7ScorePath moveToPoint: CGPointMake(2048.32, 997.22)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2051.34, 996.93) controlPoint1: CGPointMake(2049.28, 997.22) controlPoint2: CGPointMake(2050.29, 997.12)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2052.74, 990.55) controlPoint1: CGPointMake(2052.35, 994.68) controlPoint2: CGPointMake(2052.74, 992.75)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2047.88, 984.02) controlPoint1: CGPointMake(2052.74, 986.51) controlPoint2: CGPointMake(2050.82, 984.02)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2042.89, 990.74) controlPoint1: CGPointMake(2044.81, 984.02) controlPoint2: CGPointMake(2042.89, 986.75)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2048.32, 997.22) controlPoint1: CGPointMake(2042.89, 995.35) controlPoint2: CGPointMake(2045, 997.22)];
    [tile7ScorePath closePath];
    [tile7ScorePath moveToPoint: CGPointMake(2049.38, 1013.83)];
    [tile7ScorePath addLineToPoint: CGPointMake(2041.4, 1013.83)];
    [tile7ScorePath addLineToPoint: CGPointMake(2047.93, 1003.84)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2048.99, 1002.12) controlPoint1: CGPointMake(2048.32, 1003.27) controlPoint2: CGPointMake(2048.65, 1002.69)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2045.72, 1002.5) controlPoint1: CGPointMake(2047.93, 1002.4) controlPoint2: CGPointMake(2046.88, 1002.5)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2035.83, 990.98) controlPoint1: CGPointMake(2040.44, 1002.5) controlPoint2: CGPointMake(2035.83, 998.56)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2048.03, 978.16) controlPoint1: CGPointMake(2035.83, 983.83) controlPoint2: CGPointMake(2040.54, 978.16)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2059.8, 990.59) controlPoint1: CGPointMake(2055.67, 978.16) controlPoint2: CGPointMake(2059.8, 983.2)];
    [tile7ScorePath addCurveToPoint: CGPointMake(2053.99, 1006.1) controlPoint1: CGPointMake(2059.8, 995.54) controlPoint2: CGPointMake(2057.78, 999.91)];
    [tile7ScorePath addLineToPoint: CGPointMake(2049.38, 1013.83)];
    [tile7ScorePath closePath];
    [contentColor setFill];
    [tile7ScorePath fill];


    //// Tray-Fill Drawing
    UIBezierPath* trayFillPath = [UIBezierPath bezierPath];
    [trayFillPath moveToPoint: CGPointMake(2239.16, 406.01)];
    [trayFillPath addCurveToPoint: CGPointMake(2239.23, 379.08) controlPoint1: CGPointMake(2239.17, 397.03) controlPoint2: CGPointMake(2239.19, 388.06)];
    [trayFillPath addLineToPoint: CGPointMake(2238.87, 379.14)];
    [trayFillPath addCurveToPoint: CGPointMake(2238.65, 363.08) controlPoint1: CGPointMake(2238.8, 373.78) controlPoint2: CGPointMake(2238.73, 368.43)];
    [trayFillPath addCurveToPoint: CGPointMake(2223.85, 339.43) controlPoint1: CGPointMake(2238.06, 352.59) controlPoint2: CGPointMake(2234.32, 343.73)];
    [trayFillPath addCurveToPoint: CGPointMake(2206.92, 333.7) controlPoint1: CGPointMake(2218.34, 337.16) controlPoint2: CGPointMake(2212.72, 334.73)];
    [trayFillPath addCurveToPoint: CGPointMake(2164.84, 327.65) controlPoint1: CGPointMake(2192.97, 331.21) controlPoint2: CGPointMake(2178.94, 328.7)];
    [trayFillPath addCurveToPoint: CGPointMake(1718.64, 318.37) controlPoint1: CGPointMake(2016.39, 316.97) controlPoint2: CGPointMake(1867.37, 319.24)];
    [trayFillPath addCurveToPoint: CGPointMake(1189.43, 317.99) controlPoint1: CGPointMake(1548.15, 318) controlPoint2: CGPointMake(1360.19, 317.92)];
    [trayFillPath addCurveToPoint: CGPointMake(660.22, 318.37) controlPoint1: CGPointMake(1018.66, 317.92) controlPoint2: CGPointMake(830.71, 318)];
    [trayFillPath addCurveToPoint: CGPointMake(214.02, 327.65) controlPoint1: CGPointMake(511.48, 319.24) controlPoint2: CGPointMake(362.47, 316.97)];
    [trayFillPath addCurveToPoint: CGPointMake(171.94, 333.7) controlPoint1: CGPointMake(199.91, 328.7) controlPoint2: CGPointMake(185.89, 331.21)];
    [trayFillPath addCurveToPoint: CGPointMake(155, 339.43) controlPoint1: CGPointMake(166.14, 334.73) controlPoint2: CGPointMake(160.51, 337.16)];
    [trayFillPath addCurveToPoint: CGPointMake(140.21, 363.08) controlPoint1: CGPointMake(144.54, 343.73) controlPoint2: CGPointMake(140.8, 352.59)];
    [trayFillPath addCurveToPoint: CGPointMake(139.98, 379.14) controlPoint1: CGPointMake(140.13, 368.43) controlPoint2: CGPointMake(140.05, 373.78)];
    [trayFillPath addLineToPoint: CGPointMake(139.63, 379.08)];
    [trayFillPath addCurveToPoint: CGPointMake(139.69, 406) controlPoint1: CGPointMake(139.67, 388.05) controlPoint2: CGPointMake(139.68, 397.03)];
    [trayFillPath addCurveToPoint: CGPointMake(139.69, 609.93) controlPoint1: CGPointMake(139.34, 446.82) controlPoint2: CGPointMake(139.34, 569.11)];
    [trayFillPath addCurveToPoint: CGPointMake(139.63, 636.85) controlPoint1: CGPointMake(139.68, 618.9) controlPoint2: CGPointMake(139.67, 627.87)];
    [trayFillPath addLineToPoint: CGPointMake(139.98, 636.79)];
    [trayFillPath addCurveToPoint: CGPointMake(140.21, 652.85) controlPoint1: CGPointMake(140.05, 642.15) controlPoint2: CGPointMake(140.13, 647.5)];
    [trayFillPath addCurveToPoint: CGPointMake(155, 676.5) controlPoint1: CGPointMake(140.8, 663.34) controlPoint2: CGPointMake(144.54, 672.2)];
    [trayFillPath addCurveToPoint: CGPointMake(171.94, 682.23) controlPoint1: CGPointMake(160.51, 678.77) controlPoint2: CGPointMake(166.14, 681.2)];
    [trayFillPath addCurveToPoint: CGPointMake(214.02, 688.28) controlPoint1: CGPointMake(185.89, 684.72) controlPoint2: CGPointMake(199.91, 687.23)];
    [trayFillPath addCurveToPoint: CGPointMake(660.22, 697.56) controlPoint1: CGPointMake(362.47, 698.96) controlPoint2: CGPointMake(511.48, 696.69)];
    [trayFillPath addCurveToPoint: CGPointMake(1189.43, 697.94) controlPoint1: CGPointMake(830.71, 697.93) controlPoint2: CGPointMake(1018.66, 698.01)];
    [trayFillPath addCurveToPoint: CGPointMake(1718.64, 697.56) controlPoint1: CGPointMake(1360.19, 698.01) controlPoint2: CGPointMake(1548.15, 697.93)];
    [trayFillPath addCurveToPoint: CGPointMake(2164.84, 688.28) controlPoint1: CGPointMake(1867.37, 696.69) controlPoint2: CGPointMake(2016.39, 698.96)];
    [trayFillPath addCurveToPoint: CGPointMake(2206.92, 682.23) controlPoint1: CGPointMake(2178.94, 687.23) controlPoint2: CGPointMake(2192.97, 684.72)];
    [trayFillPath addCurveToPoint: CGPointMake(2223.85, 676.5) controlPoint1: CGPointMake(2212.72, 681.2) controlPoint2: CGPointMake(2218.34, 678.77)];
    [trayFillPath addCurveToPoint: CGPointMake(2238.65, 652.85) controlPoint1: CGPointMake(2234.32, 672.2) controlPoint2: CGPointMake(2238.06, 663.34)];
    [trayFillPath addCurveToPoint: CGPointMake(2238.87, 636.79) controlPoint1: CGPointMake(2238.73, 647.5) controlPoint2: CGPointMake(2238.8, 642.15)];
    [trayFillPath addLineToPoint: CGPointMake(2239.23, 636.85)];
    [trayFillPath addCurveToPoint: CGPointMake(2239.16, 609.92) controlPoint1: CGPointMake(2239.19, 627.87) controlPoint2: CGPointMake(2239.17, 618.9)];
    [trayFillPath addCurveToPoint: CGPointMake(2239.16, 406.01) controlPoint1: CGPointMake(2239.52, 569.11) controlPoint2: CGPointMake(2239.52, 446.82)];
    [trayFillPath closePath];
    if (self.wordTrayActive) {
        [activeFillColor setFill];
    }
    else {
        [inactiveFillColor setFill];
    }
    [trayFillPath fill];


    //// Tray-Stroke Drawing
    UIBezierPath* trayStrokePath = [UIBezierPath bezierPath];
    [trayStrokePath moveToPoint: CGPointMake(2239.16, 406.01)];
    [trayStrokePath addCurveToPoint: CGPointMake(2239.23, 379.08) controlPoint1: CGPointMake(2239.17, 397.03) controlPoint2: CGPointMake(2239.19, 388.06)];
    [trayStrokePath addLineToPoint: CGPointMake(2238.87, 379.14)];
    [trayStrokePath addCurveToPoint: CGPointMake(2238.65, 363.08) controlPoint1: CGPointMake(2238.8, 373.78) controlPoint2: CGPointMake(2238.73, 368.43)];
    [trayStrokePath addCurveToPoint: CGPointMake(2223.85, 339.43) controlPoint1: CGPointMake(2238.06, 352.59) controlPoint2: CGPointMake(2234.32, 343.73)];
    [trayStrokePath addCurveToPoint: CGPointMake(2206.92, 333.7) controlPoint1: CGPointMake(2218.34, 337.16) controlPoint2: CGPointMake(2212.72, 334.73)];
    [trayStrokePath addCurveToPoint: CGPointMake(2164.84, 327.65) controlPoint1: CGPointMake(2192.97, 331.21) controlPoint2: CGPointMake(2178.94, 328.7)];
    [trayStrokePath addCurveToPoint: CGPointMake(1718.64, 318.37) controlPoint1: CGPointMake(2016.39, 316.97) controlPoint2: CGPointMake(1867.37, 319.24)];
    [trayStrokePath addCurveToPoint: CGPointMake(1189.43, 317.99) controlPoint1: CGPointMake(1548.15, 318) controlPoint2: CGPointMake(1360.19, 317.92)];
    [trayStrokePath addCurveToPoint: CGPointMake(660.22, 318.37) controlPoint1: CGPointMake(1018.66, 317.92) controlPoint2: CGPointMake(830.71, 318)];
    [trayStrokePath addCurveToPoint: CGPointMake(214.02, 327.65) controlPoint1: CGPointMake(511.48, 319.24) controlPoint2: CGPointMake(362.47, 316.97)];
    [trayStrokePath addCurveToPoint: CGPointMake(171.94, 333.7) controlPoint1: CGPointMake(199.91, 328.7) controlPoint2: CGPointMake(185.89, 331.21)];
    [trayStrokePath addCurveToPoint: CGPointMake(155, 339.43) controlPoint1: CGPointMake(166.14, 334.73) controlPoint2: CGPointMake(160.51, 337.16)];
    [trayStrokePath addCurveToPoint: CGPointMake(140.21, 363.08) controlPoint1: CGPointMake(144.54, 343.73) controlPoint2: CGPointMake(140.8, 352.59)];
    [trayStrokePath addCurveToPoint: CGPointMake(139.98, 379.14) controlPoint1: CGPointMake(140.13, 368.43) controlPoint2: CGPointMake(140.05, 373.78)];
    [trayStrokePath addLineToPoint: CGPointMake(139.63, 379.08)];
    [trayStrokePath addCurveToPoint: CGPointMake(139.69, 406) controlPoint1: CGPointMake(139.67, 388.05) controlPoint2: CGPointMake(139.68, 397.03)];
    [trayStrokePath addCurveToPoint: CGPointMake(139.69, 609.93) controlPoint1: CGPointMake(139.34, 446.82) controlPoint2: CGPointMake(139.34, 569.11)];
    [trayStrokePath addCurveToPoint: CGPointMake(139.63, 636.85) controlPoint1: CGPointMake(139.68, 618.9) controlPoint2: CGPointMake(139.67, 627.87)];
    [trayStrokePath addLineToPoint: CGPointMake(139.98, 636.79)];
    [trayStrokePath addCurveToPoint: CGPointMake(140.21, 652.85) controlPoint1: CGPointMake(140.05, 642.15) controlPoint2: CGPointMake(140.13, 647.5)];
    [trayStrokePath addCurveToPoint: CGPointMake(155, 676.5) controlPoint1: CGPointMake(140.8, 663.34) controlPoint2: CGPointMake(144.54, 672.2)];
    [trayStrokePath addCurveToPoint: CGPointMake(171.94, 682.23) controlPoint1: CGPointMake(160.51, 678.77) controlPoint2: CGPointMake(166.14, 681.2)];
    [trayStrokePath addCurveToPoint: CGPointMake(214.02, 688.28) controlPoint1: CGPointMake(185.89, 684.72) controlPoint2: CGPointMake(199.91, 687.23)];
    [trayStrokePath addCurveToPoint: CGPointMake(660.22, 697.56) controlPoint1: CGPointMake(362.47, 698.96) controlPoint2: CGPointMake(511.48, 696.69)];
    [trayStrokePath addCurveToPoint: CGPointMake(1189.43, 697.94) controlPoint1: CGPointMake(830.71, 697.93) controlPoint2: CGPointMake(1018.66, 698.01)];
    [trayStrokePath addCurveToPoint: CGPointMake(1718.64, 697.56) controlPoint1: CGPointMake(1360.19, 698.01) controlPoint2: CGPointMake(1548.15, 697.93)];
    [trayStrokePath addCurveToPoint: CGPointMake(2164.84, 688.28) controlPoint1: CGPointMake(1867.37, 696.69) controlPoint2: CGPointMake(2016.39, 698.96)];
    [trayStrokePath addCurveToPoint: CGPointMake(2206.92, 682.23) controlPoint1: CGPointMake(2178.94, 687.23) controlPoint2: CGPointMake(2192.97, 684.72)];
    [trayStrokePath addCurveToPoint: CGPointMake(2223.85, 676.5) controlPoint1: CGPointMake(2212.72, 681.2) controlPoint2: CGPointMake(2218.34, 678.77)];
    [trayStrokePath addCurveToPoint: CGPointMake(2238.65, 652.85) controlPoint1: CGPointMake(2234.32, 672.2) controlPoint2: CGPointMake(2238.06, 663.34)];
    [trayStrokePath addCurveToPoint: CGPointMake(2238.87, 636.79) controlPoint1: CGPointMake(2238.73, 647.5) controlPoint2: CGPointMake(2238.8, 642.15)];
    [trayStrokePath addLineToPoint: CGPointMake(2239.23, 636.85)];
    [trayStrokePath addCurveToPoint: CGPointMake(2239.16, 609.92) controlPoint1: CGPointMake(2239.19, 627.87) controlPoint2: CGPointMake(2239.17, 618.9)];
    [trayStrokePath addCurveToPoint: CGPointMake(2239.16, 406.01) controlPoint1: CGPointMake(2239.52, 569.11) controlPoint2: CGPointMake(2239.52, 446.82)];
    [trayStrokePath closePath];
    if (self.wordTrayActive) {
        [activeStrokeColor setStroke];
    }
    else {
        [inactiveStrokeColor setStroke];
    }
    trayStrokePath.lineWidth = 24;
    [trayStrokePath stroke];


    //// Ex-Fill Drawing
    UIBezierPath* exFillPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(190.85, 69.9, 180.1, 179.9)];
    [primaryFillColor setFill];
    [exFillPath fill];


    //// Ex-Stroke Drawing
    UIBezierPath* exStrokePath = [UIBezierPath bezierPath];
    [exStrokePath moveToPoint: CGPointMake(280.85, 67.3)];
    [exStrokePath addCurveToPoint: CGPointMake(188.35, 159.8) controlPoint1: CGPointMake(229.76, 67.3) controlPoint2: CGPointMake(188.35, 108.71)];
    [exStrokePath addCurveToPoint: CGPointMake(280.85, 252.3) controlPoint1: CGPointMake(188.35, 210.88) controlPoint2: CGPointMake(229.76, 252.3)];
    [exStrokePath addCurveToPoint: CGPointMake(373.35, 159.8) controlPoint1: CGPointMake(331.93, 252.3) controlPoint2: CGPointMake(373.35, 210.88)];
    [exStrokePath addCurveToPoint: CGPointMake(280.85, 67.3) controlPoint1: CGPointMake(373.35, 108.71) controlPoint2: CGPointMake(331.93, 67.3)];
    [exStrokePath closePath];
    [exStrokePath moveToPoint: CGPointMake(280.85, 72.3)];
    [exStrokePath addCurveToPoint: CGPointMake(368.35, 159.8) controlPoint1: CGPointMake(329.09, 72.3) controlPoint2: CGPointMake(368.35, 111.55)];
    [exStrokePath addCurveToPoint: CGPointMake(280.85, 247.3) controlPoint1: CGPointMake(368.35, 208.05) controlPoint2: CGPointMake(329.09, 247.3)];
    [exStrokePath addCurveToPoint: CGPointMake(193.35, 159.8) controlPoint1: CGPointMake(232.6, 247.3) controlPoint2: CGPointMake(193.35, 208.05)];
    [exStrokePath addCurveToPoint: CGPointMake(280.85, 72.3) controlPoint1: CGPointMake(193.35, 111.55) controlPoint2: CGPointMake(232.6, 72.3)];
    [exStrokePath closePath];
    [primaryStrokeColor setFill];
    [exStrokePath fill];


    //// Ex-Icon Drawing
    UIBezierPath* exIconPath = [UIBezierPath bezierPath];
    [exIconPath moveToPoint: CGPointMake(323.88, 209.8)];
    [exIconPath addCurveToPoint: CGPointMake(318.95, 207.76) controlPoint1: CGPointMake(322.01, 209.8) controlPoint2: CGPointMake(320.26, 209.08)];
    [exIconPath addLineToPoint: CGPointMake(280.85, 169.66)];
    [exIconPath addLineToPoint: CGPointMake(242.75, 207.76)];
    [exIconPath addCurveToPoint: CGPointMake(237.81, 209.8) controlPoint1: CGPointMake(241.43, 209.08) controlPoint2: CGPointMake(239.68, 209.8)];
    [exIconPath addCurveToPoint: CGPointMake(232.88, 207.76) controlPoint1: CGPointMake(235.95, 209.8) controlPoint2: CGPointMake(234.2, 209.08)];
    [exIconPath addCurveToPoint: CGPointMake(232.88, 197.9) controlPoint1: CGPointMake(230.17, 205.04) controlPoint2: CGPointMake(230.17, 200.62)];
    [exIconPath addLineToPoint: CGPointMake(270.99, 159.8)];
    [exIconPath addLineToPoint: CGPointMake(232.88, 121.7)];
    [exIconPath addCurveToPoint: CGPointMake(232.88, 111.84) controlPoint1: CGPointMake(230.17, 118.98) controlPoint2: CGPointMake(230.17, 114.55)];
    [exIconPath addCurveToPoint: CGPointMake(237.81, 109.79) controlPoint1: CGPointMake(234.2, 110.52) controlPoint2: CGPointMake(235.95, 109.79)];
    [exIconPath addCurveToPoint: CGPointMake(242.75, 111.84) controlPoint1: CGPointMake(239.68, 109.79) controlPoint2: CGPointMake(241.43, 110.52)];
    [exIconPath addLineToPoint: CGPointMake(280.85, 149.94)];
    [exIconPath addLineToPoint: CGPointMake(318.95, 111.84)];
    [exIconPath addCurveToPoint: CGPointMake(323.88, 109.79) controlPoint1: CGPointMake(320.26, 110.52) controlPoint2: CGPointMake(322.01, 109.79)];
    [exIconPath addCurveToPoint: CGPointMake(328.81, 111.84) controlPoint1: CGPointMake(325.74, 109.79) controlPoint2: CGPointMake(327.49, 110.52)];
    [exIconPath addCurveToPoint: CGPointMake(328.81, 121.7) controlPoint1: CGPointMake(331.53, 114.55) controlPoint2: CGPointMake(331.53, 118.98)];
    [exIconPath addLineToPoint: CGPointMake(290.71, 159.8)];
    [exIconPath addLineToPoint: CGPointMake(328.81, 197.9)];
    [exIconPath addCurveToPoint: CGPointMake(328.81, 207.76) controlPoint1: CGPointMake(331.53, 200.62) controlPoint2: CGPointMake(331.53, 205.04)];
    [exIconPath addCurveToPoint: CGPointMake(323.88, 209.8) controlPoint1: CGPointMake(327.49, 209.08) controlPoint2: CGPointMake(325.74, 209.8)];
    [exIconPath closePath];
    [contentColor setFill];
    [exIconPath fill];


    //// Trash-Fill Drawing
    UIBezierPath* trashFillPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2083, 70.1, 180.1, 179.9)];
    [primaryFillColor setFill];
    [trashFillPath fill];


    //// Trash-Stroke Drawing
    UIBezierPath* trashStrokePath = [UIBezierPath bezierPath];
    [trashStrokePath moveToPoint: CGPointMake(2173, 67.5)];
    [trashStrokePath addCurveToPoint: CGPointMake(2080.5, 160) controlPoint1: CGPointMake(2121.91, 67.5) controlPoint2: CGPointMake(2080.5, 108.91)];
    [trashStrokePath addCurveToPoint: CGPointMake(2173, 252.5) controlPoint1: CGPointMake(2080.5, 211.09) controlPoint2: CGPointMake(2121.91, 252.5)];
    [trashStrokePath addCurveToPoint: CGPointMake(2265.5, 160) controlPoint1: CGPointMake(2224.09, 252.5) controlPoint2: CGPointMake(2265.5, 211.09)];
    [trashStrokePath addCurveToPoint: CGPointMake(2173, 67.5) controlPoint1: CGPointMake(2265.5, 108.91) controlPoint2: CGPointMake(2224.09, 67.5)];
    [trashStrokePath closePath];
    [trashStrokePath moveToPoint: CGPointMake(2173, 72.5)];
    [trashStrokePath addCurveToPoint: CGPointMake(2260.5, 160) controlPoint1: CGPointMake(2221.25, 72.5) controlPoint2: CGPointMake(2260.5, 111.75)];
    [trashStrokePath addCurveToPoint: CGPointMake(2173, 247.5) controlPoint1: CGPointMake(2260.5, 208.25) controlPoint2: CGPointMake(2221.25, 247.5)];
    [trashStrokePath addCurveToPoint: CGPointMake(2085.5, 160) controlPoint1: CGPointMake(2124.75, 247.5) controlPoint2: CGPointMake(2085.5, 208.25)];
    [trashStrokePath addCurveToPoint: CGPointMake(2173, 72.5) controlPoint1: CGPointMake(2085.5, 111.75) controlPoint2: CGPointMake(2124.75, 72.5)];
    [trashStrokePath closePath];
    [primaryStrokeColor setFill];
    [trashStrokePath fill];


    //// Trash-Icon-1 Drawing
    UIBezierPath* trashIcon1Path = [UIBezierPath bezierPath];
    [trashIcon1Path moveToPoint: CGPointMake(2157.89, 200.74)];
    [trashIcon1Path addCurveToPoint: CGPointMake(2158.22, 200.72) controlPoint1: CGPointMake(2158, 200.74) controlPoint2: CGPointMake(2158.11, 200.73)];
    [trashIcon1Path addCurveToPoint: CGPointMake(2161.48, 196.81) controlPoint1: CGPointMake(2160.2, 200.54) controlPoint2: CGPointMake(2161.66, 198.79)];
    [trashIcon1Path addLineToPoint: CGPointMake(2157.77, 137.43)];
    [trashIcon1Path addCurveToPoint: CGPointMake(2153.85, 134.17) controlPoint1: CGPointMake(2157.58, 135.45) controlPoint2: CGPointMake(2155.84, 133.99)];
    [trashIcon1Path addCurveToPoint: CGPointMake(2150.59, 138.09) controlPoint1: CGPointMake(2151.87, 134.35) controlPoint2: CGPointMake(2150.41, 136.11)];
    [trashIcon1Path addLineToPoint: CGPointMake(2154.31, 197.47)];
    [trashIcon1Path addCurveToPoint: CGPointMake(2157.89, 200.74) controlPoint1: CGPointMake(2154.48, 199.33) controlPoint2: CGPointMake(2156.05, 200.74)];
    [trashIcon1Path closePath];
    [contentColor setFill];
    [trashIcon1Path fill];


    //// Trash-Icon-2 Drawing
    UIBezierPath* trashIcon2Path = [UIBezierPath bezierPath];
    [trashIcon2Path moveToPoint: CGPointMake(2187.54, 200.72)];
    [trashIcon2Path addCurveToPoint: CGPointMake(2187.88, 200.74) controlPoint1: CGPointMake(2187.66, 200.73) controlPoint2: CGPointMake(2187.77, 200.74)];
    [trashIcon2Path addCurveToPoint: CGPointMake(2191.46, 197.47) controlPoint1: CGPointMake(2189.72, 200.74) controlPoint2: CGPointMake(2191.29, 199.33)];
    [trashIcon2Path addLineToPoint: CGPointMake(2195.17, 138.09)];
    [trashIcon2Path addCurveToPoint: CGPointMake(2191.91, 134.17) controlPoint1: CGPointMake(2195.35, 136.11) controlPoint2: CGPointMake(2193.89, 134.35)];
    [trashIcon2Path addCurveToPoint: CGPointMake(2188, 137.43) controlPoint1: CGPointMake(2189.92, 133.99) controlPoint2: CGPointMake(2188.18, 135.45)];
    [trashIcon2Path addLineToPoint: CGPointMake(2184.29, 196.81)];
    [trashIcon2Path addCurveToPoint: CGPointMake(2187.54, 200.72) controlPoint1: CGPointMake(2184.11, 198.79) controlPoint2: CGPointMake(2185.56, 200.54)];
    [trashIcon2Path closePath];
    [contentColor setFill];
    [trashIcon2Path fill];


    //// Trash-Icon-3 Drawing
    UIBezierPath* trashIcon3Path = [UIBezierPath bezierPath];
    [trashIcon3Path moveToPoint: CGPointMake(2172.88, 200.74)];
    [trashIcon3Path addCurveToPoint: CGPointMake(2176.48, 197.14) controlPoint1: CGPointMake(2174.87, 200.74) controlPoint2: CGPointMake(2176.48, 199.12)];
    [trashIcon3Path addLineToPoint: CGPointMake(2176.48, 137.76)];
    [trashIcon3Path addCurveToPoint: CGPointMake(2172.88, 134.16) controlPoint1: CGPointMake(2176.48, 135.77) controlPoint2: CGPointMake(2174.87, 134.16)];
    [trashIcon3Path addCurveToPoint: CGPointMake(2169.28, 137.76) controlPoint1: CGPointMake(2170.89, 134.16) controlPoint2: CGPointMake(2169.28, 135.77)];
    [trashIcon3Path addLineToPoint: CGPointMake(2169.28, 197.14)];
    [trashIcon3Path addCurveToPoint: CGPointMake(2172.88, 200.74) controlPoint1: CGPointMake(2169.28, 199.12) controlPoint2: CGPointMake(2170.89, 200.74)];
    [trashIcon3Path closePath];
    [contentColor setFill];
    [trashIcon3Path fill];


    //// Trash-Icon-4 Drawing
    UIBezierPath* trashIcon4Path = [UIBezierPath bezierPath];
    [trashIcon4Path moveToPoint: CGPointMake(2167.04, 107.59)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2158.84, 115.74) controlPoint1: CGPointMake(2162.55, 107.59) controlPoint2: CGPointMake(2158.87, 111.25)];
    [trashIcon4Path addLineToPoint: CGPointMake(2158.83, 116.74)];
    [trashIcon4Path addLineToPoint: CGPointMake(2186.93, 116.74)];
    [trashIcon4Path addLineToPoint: CGPointMake(2186.93, 115.74)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2178.73, 107.59) controlPoint1: CGPointMake(2186.89, 111.25) controlPoint2: CGPointMake(2183.22, 107.59)];
    [trashIcon4Path addLineToPoint: CGPointMake(2167.04, 107.59)];
    [trashIcon4Path closePath];
    [trashIcon4Path moveToPoint: CGPointMake(2145.37, 202.43)];
    [trashIcon4Path addLineToPoint: CGPointMake(2145.37, 202.59)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2152.18, 209.39) controlPoint1: CGPointMake(2145.37, 206.34) controlPoint2: CGPointMake(2148.42, 209.39)];
    [trashIcon4Path addLineToPoint: CGPointMake(2193.58, 209.39)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2200.4, 202.59) controlPoint1: CGPointMake(2197.34, 209.39) controlPoint2: CGPointMake(2200.4, 206.34)];
    [trashIcon4Path addLineToPoint: CGPointMake(2200.42, 202.15)];
    [trashIcon4Path addLineToPoint: CGPointMake(2207.12, 126.21)];
    [trashIcon4Path addLineToPoint: CGPointMake(2138.65, 126.21)];
    [trashIcon4Path addLineToPoint: CGPointMake(2145.37, 202.43)];
    [trashIcon4Path closePath];
    [trashIcon4Path moveToPoint: CGPointMake(2152.18, 218.59)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2136.15, 202.84) controlPoint1: CGPointMake(2143.48, 218.59) controlPoint2: CGPointMake(2136.29, 211.53)];
    [trashIcon4Path addLineToPoint: CGPointMake(2129.23, 124.34)];
    [trashIcon4Path addLineToPoint: CGPointMake(2126.48, 124.34)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2122.68, 120.54) controlPoint1: CGPointMake(2124.39, 124.34) controlPoint2: CGPointMake(2122.68, 122.64)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2126.48, 116.74) controlPoint1: CGPointMake(2122.68, 118.45) controlPoint2: CGPointMake(2124.39, 116.74)];
    [trashIcon4Path addLineToPoint: CGPointMake(2151.23, 116.74)];
    [trashIcon4Path addLineToPoint: CGPointMake(2151.24, 115.75)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2167.04, 99.99) controlPoint1: CGPointMake(2151.26, 107.06) controlPoint2: CGPointMake(2158.35, 99.99)];
    [trashIcon4Path addLineToPoint: CGPointMake(2178.73, 99.99)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2194.53, 115.75) controlPoint1: CGPointMake(2187.41, 99.99) controlPoint2: CGPointMake(2194.5, 107.06)];
    [trashIcon4Path addLineToPoint: CGPointMake(2194.53, 116.74)];
    [trashIcon4Path addLineToPoint: CGPointMake(2219.28, 116.74)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2223.08, 120.54) controlPoint1: CGPointMake(2221.38, 116.74) controlPoint2: CGPointMake(2223.08, 118.45)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2219.28, 124.34) controlPoint1: CGPointMake(2223.08, 122.64) controlPoint2: CGPointMake(2221.38, 124.34)];
    [trashIcon4Path addLineToPoint: CGPointMake(2216.53, 124.34)];
    [trashIcon4Path addLineToPoint: CGPointMake(2209.62, 202.77)];
    [trashIcon4Path addCurveToPoint: CGPointMake(2193.58, 218.59) controlPoint1: CGPointMake(2209.48, 211.53) controlPoint2: CGPointMake(2202.29, 218.59)];
    [trashIcon4Path addLineToPoint: CGPointMake(2152.18, 218.59)];
    [trashIcon4Path closePath];
    [contentColor setFill];
    [trashIcon4Path fill];
}

@end
