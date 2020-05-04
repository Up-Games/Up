//
//  GameMockupView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "GameMockupView.h"

@implementation GameMockupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.hintColor = [UIColor whiteColor];
    self.extraLightColor = [UIColor whiteColor];
    self.lightColor = [UIColor whiteColor];
    self.normalColor = [UIColor blackColor];
    self.brightColor = [UIColor blackColor];
    self.accentColor = [UIColor blackColor];
    
    return self;
}

- (void)setHintColor:(UIColor *)hintColor
{
    _hintColor = hintColor;
    [self setNeedsDisplay];
}

- (void)setExtraLightColor:(UIColor *)extraLightColor
{
    _extraLightColor = extraLightColor;
    [self setNeedsDisplay];
}

- (void)setLightColor:(UIColor *)lightColor
{
    _lightColor = lightColor;
    [self setNeedsDisplay];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [self setNeedsDisplay];
}

- (void)setBrightColor:(UIColor *)brightColor
{
    _brightColor = brightColor;
    [self setNeedsDisplay];
}

- (void)setAccentColor:(UIColor *)accentColor
{
    _accentColor = accentColor;
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
    UIColor *backdropColor = self.hintColor;
    UIColor *timeColor = self.normalColor;
    UIColor *scoreColor = self.normalColor;

    UIColor *tileFillColor = self.brightColor;
    UIColor *tileStrokeColor = self.brightColor;
    UIColor *tileLetterColor = self.extraLightColor;
    UIColor *tileScoreColor = self.extraLightColor;

//    UIColor *tileFillColor = self.extraLightColor;
//    UIColor *tileStrokeColor = self.brightColor;
//    UIColor *tileLetterColor = self.brightColor;
//    UIColor *tileScoreColor = self.brightColor;

    UIColor *trayFillColor = self.extraLightColor;
    UIColor *trayStrokeColor = self.lightColor;
    UIColor *trayScoreColor = self.lightColor;
    if (self.wordTrayActive) {
        trayFillColor = self.extraLightColor;
        trayStrokeColor = self.accentColor;
        trayScoreColor = self.accentColor;
    }
    UIColor *exColor = self.brightColor;
    UIColor *trashColor = self.brightColor;

    //// Group 2
    {
        //// Backdrop Drawing
        UIBezierPath* backdropPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 2436, 1125)];
        [backdropColor setFill];
        [backdropPath fill];


        //// Time-Minute Drawing
        UIBezierPath* timeMinutePath = [UIBezierPath bezierPath];
        [timeMinutePath moveToPoint: CGPointMake(755.53, 114.52)];
        [timeMinutePath addLineToPoint: CGPointMake(810.13, 87.92)];
        [timeMinutePath addLineToPoint: CGPointMake(813.13, 88.72)];
        [timeMinutePath addLineToPoint: CGPointMake(813.13, 205.32)];
        [timeMinutePath addLineToPoint: CGPointMake(839.33, 205.32)];
        [timeMinutePath addLineToPoint: CGPointMake(839.33, 230.31)];
        [timeMinutePath addLineToPoint: CGPointMake(755.13, 230.31)];
        [timeMinutePath addLineToPoint: CGPointMake(755.13, 205.32)];
        [timeMinutePath addLineToPoint: CGPointMake(783.73, 205.32)];
        [timeMinutePath addLineToPoint: CGPointMake(783.73, 129.92)];
        [timeMinutePath addLineToPoint: CGPointMake(755.93, 143.72)];
        [timeMinutePath addLineToPoint: CGPointMake(755.53, 143.52)];
        [timeMinutePath addLineToPoint: CGPointMake(755.53, 114.52)];
        [timeMinutePath closePath];
        [timeColor setFill];
        [timeMinutePath fill];


        //// Time-Colon Drawing
        UIBezierPath* timeColonPath = [UIBezierPath bezierPath];
        [timeColonPath moveToPoint: CGPointMake(872.53, 169.12)];
        [timeColonPath addCurveToPoint: CGPointMake(889.92, 187.32) controlPoint1: CGPointMake(882.33, 169.12) controlPoint2: CGPointMake(889.92, 177.52)];
        [timeColonPath addCurveToPoint: CGPointMake(872.53, 205.32) controlPoint1: CGPointMake(889.92, 196.92) controlPoint2: CGPointMake(882.33, 205.32)];
        [timeColonPath addCurveToPoint: CGPointMake(854.93, 187.32) controlPoint1: CGPointMake(862.53, 205.32) controlPoint2: CGPointMake(854.93, 196.92)];
        [timeColonPath addCurveToPoint: CGPointMake(872.53, 169.12) controlPoint1: CGPointMake(854.93, 177.52) controlPoint2: CGPointMake(862.53, 169.12)];
        [timeColonPath closePath];
        [timeColonPath moveToPoint: CGPointMake(872.53, 113.12)];
        [timeColonPath addCurveToPoint: CGPointMake(889.92, 131.12) controlPoint1: CGPointMake(882.33, 113.12) controlPoint2: CGPointMake(889.92, 121.32)];
        [timeColonPath addCurveToPoint: CGPointMake(872.53, 149.32) controlPoint1: CGPointMake(889.92, 140.92) controlPoint2: CGPointMake(882.33, 149.32)];
        [timeColonPath addCurveToPoint: CGPointMake(854.93, 131.12) controlPoint1: CGPointMake(862.53, 149.32) controlPoint2: CGPointMake(854.93, 140.92)];
        [timeColonPath addCurveToPoint: CGPointMake(872.53, 113.12) controlPoint1: CGPointMake(854.93, 121.32) controlPoint2: CGPointMake(862.53, 113.12)];
        [timeColonPath closePath];
        [timeColor setFill];
        [timeColonPath fill];


        //// Time-Seconds-Tens Drawing
        UIBezierPath* timeSecondsTensPath = [UIBezierPath bezierPath];
        [timeSecondsTensPath moveToPoint: CGPointMake(947.12, 232.52)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(908.12, 222.12) controlPoint1: CGPointMake(930.52, 232.52) controlPoint2: CGPointMake(918.12, 228.31)];
        [timeSecondsTensPath addLineToPoint: CGPointMake(905.32, 192.92)];
        [timeSecondsTensPath addLineToPoint: CGPointMake(905.72, 192.71)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(942.72, 207.71) controlPoint1: CGPointMake(917.92, 202.32) controlPoint2: CGPointMake(931.12, 207.71)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(963.32, 191.12) controlPoint1: CGPointMake(955.12, 207.71) controlPoint2: CGPointMake(963.32, 200.92)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(923.52, 164.92) controlPoint1: CGPointMake(963.32, 179.92) controlPoint2: CGPointMake(954.92, 172.52)];
        [timeSecondsTensPath addLineToPoint: CGPointMake(923.52, 154.32)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(961.52, 126.32) controlPoint1: CGPointMake(953.32, 143.12) controlPoint2: CGPointMake(961.52, 135.52)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(944.52, 112.92) controlPoint1: CGPointMake(961.52, 118.12) controlPoint2: CGPointMake(954.72, 112.92)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(908.72, 130.32) controlPoint1: CGPointMake(932.32, 112.92) controlPoint2: CGPointMake(919.72, 119.92)];
        [timeSecondsTensPath addLineToPoint: CGPointMake(908.32, 130.32)];
        [timeSecondsTensPath addLineToPoint: CGPointMake(908.32, 103.12)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(949.32, 88.12) controlPoint1: CGPointMake(917.52, 95.12) controlPoint2: CGPointMake(932.32, 88.12)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(991.12, 121.92) controlPoint1: CGPointMake(974.72, 88.12) controlPoint2: CGPointMake(991.12, 101.72)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(964.12, 157.32) controlPoint1: CGPointMake(991.12, 137.12) controlPoint2: CGPointMake(982.32, 148.32)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(992.92, 193.92) controlPoint1: CGPointMake(982.92, 163.72) controlPoint2: CGPointMake(992.92, 176.32)];
        [timeSecondsTensPath addCurveToPoint: CGPointMake(947.12, 232.52) controlPoint1: CGPointMake(992.92, 218.31) controlPoint2: CGPointMake(971.72, 232.52)];
        [timeSecondsTensPath closePath];
        [timeColor setFill];
        [timeSecondsTensPath fill];


        //// Time-Seconds Drawing
        UIBezierPath* timeSecondsPath = [UIBezierPath bezierPath];
        [timeSecondsPath moveToPoint: CGPointMake(1070.72, 160.32)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1052.12, 113.12) controlPoint1: CGPointMake(1070.72, 128.32) controlPoint2: CGPointMake(1063.92, 113.12)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1033.92, 160.32) controlPoint1: CGPointMake(1040.52, 113.12) controlPoint2: CGPointMake(1033.92, 128.52)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1052.52, 207.52) controlPoint1: CGPointMake(1033.92, 192.12) controlPoint2: CGPointMake(1040.52, 207.52)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1070.72, 160.32) controlPoint1: CGPointMake(1064.12, 207.52) controlPoint2: CGPointMake(1070.72, 192.12)];
        [timeSecondsPath closePath];
        [timeSecondsPath moveToPoint: CGPointMake(1098.32, 160.32)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1052.32, 233.12) controlPoint1: CGPointMake(1098.32, 207.71) controlPoint2: CGPointMake(1080.92, 233.12)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1006.32, 160.32) controlPoint1: CGPointMake(1023.12, 233.12) controlPoint2: CGPointMake(1006.32, 207.92)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1052.32, 87.52) controlPoint1: CGPointMake(1006.32, 113.12) controlPoint2: CGPointMake(1023.72, 87.52)];
        [timeSecondsPath addCurveToPoint: CGPointMake(1098.32, 160.32) controlPoint1: CGPointMake(1081.32, 87.52) controlPoint2: CGPointMake(1098.32, 112.72)];
        [timeSecondsPath closePath];
        [timeColor setFill];
        [timeSecondsPath fill];



        //// Score-Tens Drawing
        UIBezierPath* scoreTensPath = [UIBezierPath bezierPath];
        [scoreTensPath moveToPoint: CGPointMake(1561.01, 149.47)];
        [scoreTensPath addCurveToPoint: CGPointMake(1576.81, 129.67) controlPoint1: CGPointMake(1570.41, 149.47) controlPoint2: CGPointMake(1576.81, 141.47)];
        [scoreTensPath addCurveToPoint: CGPointMake(1561.01, 110.47) controlPoint1: CGPointMake(1576.81, 118.07) controlPoint2: CGPointMake(1570.61, 110.47)];
        [scoreTensPath addCurveToPoint: CGPointMake(1545.21, 129.67) controlPoint1: CGPointMake(1551.21, 110.47) controlPoint2: CGPointMake(1545.21, 118.07)];
        [scoreTensPath addCurveToPoint: CGPointMake(1561.01, 149.47) controlPoint1: CGPointMake(1545.21, 141.47) controlPoint2: CGPointMake(1551.81, 149.47)];
        [scoreTensPath closePath];
        [scoreTensPath moveToPoint: CGPointMake(1561.01, 210.86)];
        [scoreTensPath addCurveToPoint: CGPointMake(1578.81, 190.07) controlPoint1: CGPointMake(1571.61, 210.86) controlPoint2: CGPointMake(1578.81, 203.46)];
        [scoreTensPath addCurveToPoint: CGPointMake(1561.01, 169.87) controlPoint1: CGPointMake(1578.81, 177.67) controlPoint2: CGPointMake(1570.81, 169.87)];
        [scoreTensPath addCurveToPoint: CGPointMake(1543.21, 190.07) controlPoint1: CGPointMake(1551.21, 169.87) controlPoint2: CGPointMake(1543.21, 177.67)];
        [scoreTensPath addCurveToPoint: CGPointMake(1561.01, 210.86) controlPoint1: CGPointMake(1543.21, 203.46) controlPoint2: CGPointMake(1550.81, 210.86)];
        [scoreTensPath closePath];
        [scoreTensPath moveToPoint: CGPointMake(1561.01, 233.06)];
        [scoreTensPath addCurveToPoint: CGPointMake(1515.61, 193.47) controlPoint1: CGPointMake(1533.81, 233.06) controlPoint2: CGPointMake(1515.61, 217.66)];
        [scoreTensPath addCurveToPoint: CGPointMake(1536.01, 159.27) controlPoint1: CGPointMake(1515.61, 177.47) controlPoint2: CGPointMake(1523.81, 165.87)];
        [scoreTensPath addCurveToPoint: CGPointMake(1518.61, 127.47) controlPoint1: CGPointMake(1525.21, 152.67) controlPoint2: CGPointMake(1518.61, 141.47)];
        [scoreTensPath addCurveToPoint: CGPointMake(1561.01, 88.27) controlPoint1: CGPointMake(1518.61, 104.67) controlPoint2: CGPointMake(1534.81, 88.27)];
        [scoreTensPath addCurveToPoint: CGPointMake(1603.41, 127.47) controlPoint1: CGPointMake(1587.41, 88.27) controlPoint2: CGPointMake(1603.41, 104.67)];
        [scoreTensPath addCurveToPoint: CGPointMake(1586.01, 159.27) controlPoint1: CGPointMake(1603.41, 141.47) controlPoint2: CGPointMake(1596.81, 152.67)];
        [scoreTensPath addCurveToPoint: CGPointMake(1606.41, 193.47) controlPoint1: CGPointMake(1598.21, 165.67) controlPoint2: CGPointMake(1606.41, 177.47)];
        [scoreTensPath addCurveToPoint: CGPointMake(1561.01, 233.06) controlPoint1: CGPointMake(1606.41, 217.46) controlPoint2: CGPointMake(1587.61, 233.06)];
        [scoreTensPath closePath];
        [scoreColor setFill];
        [scoreTensPath fill];


        //// Score-Ones Drawing
        UIBezierPath* scoreOnesPath = [UIBezierPath bezierPath];
        [scoreOnesPath moveToPoint: CGPointMake(1658.61, 230.66)];
        [scoreOnesPath addLineToPoint: CGPointMake(1628.01, 230.66)];
        [scoreOnesPath addLineToPoint: CGPointMake(1673.41, 116.67)];
        [scoreOnesPath addLineToPoint: CGPointMake(1621.61, 116.67)];
        [scoreOnesPath addLineToPoint: CGPointMake(1618.41, 90.67)];
        [scoreOnesPath addLineToPoint: CGPointMake(1711.21, 90.67)];
        [scoreOnesPath addLineToPoint: CGPointMake(1711.81, 92.47)];
        [scoreOnesPath addLineToPoint: CGPointMake(1658.61, 230.66)];
        [scoreOnesPath closePath];
        [scoreColor setFill];
        [scoreOnesPath fill];


        //// Tile-1-Fill Drawing
        UIBezierPath* tile1FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(304.2, 787.2, 213.6, 239.6)];
        [tileFillColor setFill];
        [tile1FillPath fill];


        //// Tile-1-Stroke Drawing
        UIBezierPath* tile1StrokePath = [UIBezierPath bezierPath];
        [tile1StrokePath moveToPoint: CGPointMake(525, 780)];
        [tile1StrokePath addLineToPoint: CGPointMake(297, 780)];
        [tile1StrokePath addLineToPoint: CGPointMake(297, 1034)];
        [tile1StrokePath addLineToPoint: CGPointMake(525, 1034)];
        [tile1StrokePath addLineToPoint: CGPointMake(525, 780)];
        [tile1StrokePath closePath];
        [tile1StrokePath moveToPoint: CGPointMake(510.59, 1019.59)];
        [tile1StrokePath addLineToPoint: CGPointMake(311.41, 1019.59)];
        [tile1StrokePath addLineToPoint: CGPointMake(311.41, 794.41)];
        [tile1StrokePath addLineToPoint: CGPointMake(510.59, 794.41)];
        [tile1StrokePath addLineToPoint: CGPointMake(510.59, 1019.59)];
        [tile1StrokePath closePath];
        [tileStrokeColor setFill];
        [tile1StrokePath fill];


        //// Tile-1-Letter Drawing
        UIBezierPath* tile1LetterPath = [UIBezierPath bezierPath];
        [tile1LetterPath moveToPoint: CGPointMake(411, 912.96)];
        [tile1LetterPath addLineToPoint: CGPointMake(431.9, 840.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(468.64, 840.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(468.64, 966.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(442.88, 966.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(443.06, 874.44)];
        [tile1LetterPath addLineToPoint: CGPointMake(414.43, 966.78)];
        [tile1LetterPath addLineToPoint: CGPointMake(406.14, 966.78)];
        [tile1LetterPath addLineToPoint: CGPointMake(377.5, 874.62)];
        [tile1LetterPath addLineToPoint: CGPointMake(377.86, 966.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(353.37, 966.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(353.37, 840.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(390.11, 840.06)];
        [tile1LetterPath addLineToPoint: CGPointMake(411, 912.96)];
        [tile1LetterPath closePath];
        [tileLetterColor setFill];
        [tile1LetterPath fill];


        //// Tile-1-Score Drawing
        UIBezierPath* tile1ScorePath = [UIBezierPath bezierPath];
        [tile1ScorePath moveToPoint: CGPointMake(490.32, 1008.36)];
        [tile1ScorePath addCurveToPoint: CGPointMake(481.38, 1006.49) controlPoint1: CGPointMake(486.47, 1008.36) controlPoint2: CGPointMake(483.74, 1007.59)];
        [tile1ScorePath addLineToPoint: CGPointMake(480.61, 999.48)];
        [tile1ScorePath addLineToPoint: CGPointMake(480.71, 999.43)];
        [tile1ScorePath addCurveToPoint: CGPointMake(489.45, 1002.36) controlPoint1: CGPointMake(483.59, 1001.3) controlPoint2: CGPointMake(486.62, 1002.36)];
        [tile1ScorePath addCurveToPoint: CGPointMake(494.54, 998.18) controlPoint1: CGPointMake(492.48, 1002.36) controlPoint2: CGPointMake(494.54, 1000.63)];
        [tile1ScorePath addCurveToPoint: CGPointMake(485.08, 991.56) controlPoint1: CGPointMake(494.54, 995.35) controlPoint2: CGPointMake(492.38, 993.43)];
        [tile1ScorePath addLineToPoint: CGPointMake(485.08, 988.82)];
        [tile1ScorePath addCurveToPoint: CGPointMake(494.06, 981.76) controlPoint1: CGPointMake(492.19, 985.8) controlPoint2: CGPointMake(494.06, 984.07)];
        [tile1ScorePath addCurveToPoint: CGPointMake(489.98, 978.35) controlPoint1: CGPointMake(494.06, 979.7) controlPoint2: CGPointMake(492.43, 978.35)];
        [tile1ScorePath addCurveToPoint: CGPointMake(481.57, 981.52) controlPoint1: CGPointMake(487.05, 978.35) controlPoint2: CGPointMake(484.07, 979.75)];
        [tile1ScorePath addLineToPoint: CGPointMake(481.48, 981.52)];
        [tile1ScorePath addLineToPoint: CGPointMake(481.48, 975.09)];
        [tile1ScorePath addCurveToPoint: CGPointMake(491.13, 972.35) controlPoint1: CGPointMake(483.69, 973.7) controlPoint2: CGPointMake(487.05, 972.35)];
        [tile1ScorePath addCurveToPoint: CGPointMake(501.27, 980.71) controlPoint1: CGPointMake(497.33, 972.35) controlPoint2: CGPointMake(501.27, 975.71)];
        [tile1ScorePath addCurveToPoint: CGPointMake(494.45, 989.59) controlPoint1: CGPointMake(501.27, 984.26) controlPoint2: CGPointMake(499.11, 987.14)];
        [tile1ScorePath addCurveToPoint: CGPointMake(501.7, 998.66) controlPoint1: CGPointMake(499.2, 991.32) controlPoint2: CGPointMake(501.7, 994.68)];
        [tile1ScorePath addCurveToPoint: CGPointMake(490.32, 1008.36) controlPoint1: CGPointMake(501.7, 1004.85) controlPoint2: CGPointMake(496.23, 1008.36)];
        [tile1ScorePath closePath];
        [tileScoreColor setFill];
        [tile1ScorePath fill];


        //// Tile-2-Fill Drawing
        UIBezierPath* tile2FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(563.55, 787.2, 213.6, 239.6)];
        [tileFillColor setFill];
        [tile2FillPath fill];


        //// Tile-2-Stroke Drawing
        UIBezierPath* tile2StrokePath = [UIBezierPath bezierPath];
        [tile2StrokePath moveToPoint: CGPointMake(784.33, 780)];
        [tile2StrokePath addLineToPoint: CGPointMake(556.33, 780)];
        [tile2StrokePath addLineToPoint: CGPointMake(556.33, 1034)];
        [tile2StrokePath addLineToPoint: CGPointMake(784.33, 1034)];
        [tile2StrokePath addLineToPoint: CGPointMake(784.33, 780)];
        [tile2StrokePath closePath];
        [tile2StrokePath moveToPoint: CGPointMake(769.93, 1019.59)];
        [tile2StrokePath addLineToPoint: CGPointMake(570.74, 1019.59)];
        [tile2StrokePath addLineToPoint: CGPointMake(570.74, 794.41)];
        [tile2StrokePath addLineToPoint: CGPointMake(769.93, 794.41)];
        [tile2StrokePath addLineToPoint: CGPointMake(769.93, 1019.59)];
        [tile2StrokePath closePath];
        [tileStrokeColor setFill];
        [tile2StrokePath fill];


        //// Tile-2-Letter Drawing
        UIBezierPath* tile2LetterPath = [UIBezierPath bezierPath];
        [tile2LetterPath moveToPoint: CGPointMake(627.92, 840.06)];
        [tile2LetterPath addLineToPoint: CGPointMake(654.58, 840.06)];
        [tile2LetterPath addLineToPoint: CGPointMake(654.58, 923.04)];
        [tile2LetterPath addCurveToPoint: CGPointMake(670.79, 944.64) controlPoint1: CGPointMake(654.58, 937.98) controlPoint2: CGPointMake(660.7, 944.64)];
        [tile2LetterPath addCurveToPoint: CGPointMake(686.82, 923.04) controlPoint1: CGPointMake(680.69, 944.64) controlPoint2: CGPointMake(686.82, 937.98)];
        [tile2LetterPath addLineToPoint: CGPointMake(686.82, 840.06)];
        [tile2LetterPath addLineToPoint: CGPointMake(712.93, 840.06)];
        [tile2LetterPath addLineToPoint: CGPointMake(712.93, 920.34)];
        [tile2LetterPath addCurveToPoint: CGPointMake(670.43, 968.22) controlPoint1: CGPointMake(712.93, 951.12) controlPoint2: CGPointMake(697.62, 968.22)];
        [tile2LetterPath addCurveToPoint: CGPointMake(627.92, 920.34) controlPoint1: CGPointMake(643.05, 968.22) controlPoint2: CGPointMake(627.92, 951.12)];
        [tile2LetterPath addLineToPoint: CGPointMake(627.92, 840.06)];
        [tile2LetterPath closePath];
        [tileLetterColor setFill];
        [tile2LetterPath fill];


        //// Tile-2-Score Drawing
        UIBezierPath* tile2ScorePath = [UIBezierPath bezierPath];
        [tile2ScorePath moveToPoint: CGPointMake(744.32, 980.42)];
        [tile2ScorePath addLineToPoint: CGPointMake(758.44, 972.26)];
        [tile2ScorePath addLineToPoint: CGPointMake(759.07, 972.5)];
        [tile2ScorePath addLineToPoint: CGPointMake(759.07, 1007.83)];
        [tile2ScorePath addLineToPoint: CGPointMake(751.96, 1007.83)];
        [tile2ScorePath addLineToPoint: CGPointMake(751.96, 983.3)];
        [tile2ScorePath addLineToPoint: CGPointMake(744.41, 987.67)];
        [tile2ScorePath addLineToPoint: CGPointMake(744.32, 987.62)];
        [tile2ScorePath addLineToPoint: CGPointMake(744.32, 980.42)];
        [tile2ScorePath closePath];
        [tileScoreColor setFill];
        [tile2ScorePath fill];


        //// Tile-3-Fill Drawing
        UIBezierPath* tile3FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(822.85, 787.2, 213.6, 239.6)];
        [tileFillColor setFill];
        [tile3FillPath fill];


        //// Tile-3-Stroke Drawing
        UIBezierPath* tile3StrokePath = [UIBezierPath bezierPath];
        [tile3StrokePath moveToPoint: CGPointMake(1043.67, 780)];
        [tile3StrokePath addLineToPoint: CGPointMake(815.67, 780)];
        [tile3StrokePath addLineToPoint: CGPointMake(815.67, 1034)];
        [tile3StrokePath addLineToPoint: CGPointMake(1043.67, 1034)];
        [tile3StrokePath addLineToPoint: CGPointMake(1043.67, 780)];
        [tile3StrokePath closePath];
        [tile3StrokePath moveToPoint: CGPointMake(1029.26, 1019.59)];
        [tile3StrokePath addLineToPoint: CGPointMake(830.08, 1019.59)];
        [tile3StrokePath addLineToPoint: CGPointMake(830.08, 794.41)];
        [tile3StrokePath addLineToPoint: CGPointMake(1029.26, 794.41)];
        [tile3StrokePath addLineToPoint: CGPointMake(1029.26, 1019.59)];
        [tile3StrokePath closePath];
        [tileStrokeColor setFill];
        [tile3StrokePath fill];


        //// Tile-3-Letter Drawing
        UIBezierPath* tile3LetterPath = [UIBezierPath bezierPath];
        [tile3LetterPath moveToPoint: CGPointMake(946.33, 914.04)];
        [tile3LetterPath addLineToPoint: CGPointMake(913.01, 914.04)];
        [tile3LetterPath addLineToPoint: CGPointMake(913.01, 966.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(886.35, 966.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(886.35, 840.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(913.01, 840.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(913.01, 890.28)];
        [tile3LetterPath addLineToPoint: CGPointMake(946.33, 890.28)];
        [tile3LetterPath addLineToPoint: CGPointMake(946.33, 840.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(972.99, 840.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(972.99, 966.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(946.33, 966.06)];
        [tile3LetterPath addLineToPoint: CGPointMake(946.33, 914.04)];
        [tile3LetterPath closePath];
        [tileLetterColor setFill];
        [tile3LetterPath fill];


        //// Tile-3-Score Drawing
        UIBezierPath* tile3ScorePath = [UIBezierPath bezierPath];
        [tile3ScorePath moveToPoint: CGPointMake(1010.04, 995.25)];
        [tile3ScorePath addLineToPoint: CGPointMake(1010.04, 978.4)];
        [tile3ScorePath addLineToPoint: CGPointMake(1001.44, 995.25)];
        [tile3ScorePath addLineToPoint: CGPointMake(1010.04, 995.25)];
        [tile3ScorePath closePath];
        [tile3ScorePath moveToPoint: CGPointMake(1016.62, 1007.83)];
        [tile3ScorePath addLineToPoint: CGPointMake(1009.85, 1007.83)];
        [tile3ScorePath addLineToPoint: CGPointMake(1009.85, 1000.63)];
        [tile3ScorePath addLineToPoint: CGPointMake(994.62, 1000.63)];
        [tile3ScorePath addLineToPoint: CGPointMake(994.29, 997.32)];
        [tile3ScorePath addLineToPoint: CGPointMake(1007.59, 972.69)];
        [tile3ScorePath addLineToPoint: CGPointMake(1016.62, 972.69)];
        [tile3ScorePath addLineToPoint: CGPointMake(1016.62, 995.25)];
        [tile3ScorePath addLineToPoint: CGPointMake(1021.04, 995.25)];
        [tile3ScorePath addLineToPoint: CGPointMake(1021.04, 1000.63)];
        [tile3ScorePath addLineToPoint: CGPointMake(1016.62, 1000.63)];
        [tile3ScorePath addLineToPoint: CGPointMake(1016.62, 1007.83)];
        [tile3ScorePath closePath];
        [tileScoreColor setFill];
        [tile3ScorePath fill];


        //// Tile-4-Fill Drawing
        UIBezierPath* tile4FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1082.2, 787.2, 213.6, 239.6)];
        [tileFillColor setFill];
        [tile4FillPath fill];


        //// Tile-4-Stroke Drawing
        UIBezierPath* tile4StrokePath = [UIBezierPath bezierPath];
        [tile4StrokePath moveToPoint: CGPointMake(1303, 780)];
        [tile4StrokePath addLineToPoint: CGPointMake(1075, 780)];
        [tile4StrokePath addLineToPoint: CGPointMake(1075, 1034)];
        [tile4StrokePath addLineToPoint: CGPointMake(1303, 1034)];
        [tile4StrokePath addLineToPoint: CGPointMake(1303, 780)];
        [tile4StrokePath closePath];
        [tile4StrokePath moveToPoint: CGPointMake(1288.59, 1019.59)];
        [tile4StrokePath addLineToPoint: CGPointMake(1089.41, 1019.59)];
        [tile4StrokePath addLineToPoint: CGPointMake(1089.41, 794.41)];
        [tile4StrokePath addLineToPoint: CGPointMake(1288.59, 794.41)];
        [tile4StrokePath addLineToPoint: CGPointMake(1288.59, 1019.59)];
        [tile4StrokePath closePath];
        [tileStrokeColor setFill];
        [tile4StrokePath fill];


        //// Tile-4-Letter Drawing
        UIBezierPath* tile4LetterPath = [UIBezierPath bezierPath];
        [tile4LetterPath moveToPoint: CGPointMake(1150.28, 903.06)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1197.65, 838.08) controlPoint1: CGPointMake(1150.28, 863.1) controlPoint2: CGPointMake(1170.09, 838.08)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1225.75, 848.34) controlPoint1: CGPointMake(1209.9, 838.08) controlPoint2: CGPointMake(1219.44, 842.94)];
        [tile4LetterPath addLineToPoint: CGPointMake(1225.75, 876.6)];
        [tile4LetterPath addLineToPoint: CGPointMake(1225.38, 876.6)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1201.25, 862.74) controlPoint1: CGPointMake(1218.72, 869.22) controlPoint2: CGPointMake(1210.08, 862.74)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1177.65, 902.7) controlPoint1: CGPointMake(1187.92, 862.74) controlPoint2: CGPointMake(1177.65, 878.4)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1201.25, 943.38) controlPoint1: CGPointMake(1177.65, 929.34) controlPoint2: CGPointMake(1187.92, 943.38)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1226.47, 929.88) controlPoint1: CGPointMake(1210.44, 943.38) controlPoint2: CGPointMake(1219.26, 937.62)];
        [tile4LetterPath addLineToPoint: CGPointMake(1227.01, 930.06)];
        [tile4LetterPath addLineToPoint: CGPointMake(1224.66, 957.78)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1195.85, 968.04) controlPoint1: CGPointMake(1217.64, 963.36) controlPoint2: CGPointMake(1208.45, 968.04)];
        [tile4LetterPath addCurveToPoint: CGPointMake(1150.28, 903.06) controlPoint1: CGPointMake(1169.73, 968.04) controlPoint2: CGPointMake(1150.28, 944.64)];
        [tile4LetterPath closePath];
        [tileLetterColor setFill];
        [tile4LetterPath fill];


        //// Tile-4-Score Drawing
        UIBezierPath* tile4ScorePath = [UIBezierPath bezierPath];
        [tile4ScorePath moveToPoint: CGPointMake(1268.32, 991.22)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1271.34, 990.93) controlPoint1: CGPointMake(1269.28, 991.22) controlPoint2: CGPointMake(1270.29, 991.12)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1272.74, 984.55) controlPoint1: CGPointMake(1272.35, 988.68) controlPoint2: CGPointMake(1272.74, 986.75)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1267.89, 978.02) controlPoint1: CGPointMake(1272.74, 980.51) controlPoint2: CGPointMake(1270.82, 978.02)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1262.89, 984.74) controlPoint1: CGPointMake(1264.81, 978.02) controlPoint2: CGPointMake(1262.89, 980.75)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1268.32, 991.22) controlPoint1: CGPointMake(1262.89, 989.35) controlPoint2: CGPointMake(1265, 991.22)];
        [tile4ScorePath closePath];
        [tile4ScorePath moveToPoint: CGPointMake(1269.38, 1007.83)];
        [tile4ScorePath addLineToPoint: CGPointMake(1261.4, 1007.83)];
        [tile4ScorePath addLineToPoint: CGPointMake(1267.93, 997.84)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1268.99, 996.12) controlPoint1: CGPointMake(1268.32, 997.27) controlPoint2: CGPointMake(1268.65, 996.69)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1265.72, 996.5) controlPoint1: CGPointMake(1267.93, 996.4) controlPoint2: CGPointMake(1266.88, 996.5)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1255.83, 984.98) controlPoint1: CGPointMake(1260.44, 996.5) controlPoint2: CGPointMake(1255.83, 992.56)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1268.03, 972.16) controlPoint1: CGPointMake(1255.83, 977.83) controlPoint2: CGPointMake(1260.54, 972.16)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1279.8, 984.59) controlPoint1: CGPointMake(1275.67, 972.16) controlPoint2: CGPointMake(1279.8, 977.2)];
        [tile4ScorePath addCurveToPoint: CGPointMake(1273.99, 1000.1) controlPoint1: CGPointMake(1279.8, 989.54) controlPoint2: CGPointMake(1277.78, 993.91)];
        [tile4ScorePath addLineToPoint: CGPointMake(1269.38, 1007.83)];
        [tile4ScorePath closePath];
        [tileScoreColor setFill];
        [tile4ScorePath fill];


        //// Tile-5-Fill Drawing
        UIBezierPath* tile5FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1341.55, 787.2, 213.6, 239.6)];
        [tileFillColor setFill];
        [tile5FillPath fill];


        //// Tile-5-Stroke Drawing
        UIBezierPath* tile5StrokePath = [UIBezierPath bezierPath];
        [tile5StrokePath moveToPoint: CGPointMake(1562.33, 780)];
        [tile5StrokePath addLineToPoint: CGPointMake(1334.33, 780)];
        [tile5StrokePath addLineToPoint: CGPointMake(1334.33, 1034)];
        [tile5StrokePath addLineToPoint: CGPointMake(1562.33, 1034)];
        [tile5StrokePath addLineToPoint: CGPointMake(1562.33, 780)];
        [tile5StrokePath closePath];
        [tile5StrokePath moveToPoint: CGPointMake(1547.93, 1019.59)];
        [tile5StrokePath addLineToPoint: CGPointMake(1348.74, 1019.59)];
        [tile5StrokePath addLineToPoint: CGPointMake(1348.74, 794.41)];
        [tile5StrokePath addLineToPoint: CGPointMake(1547.93, 794.41)];
        [tile5StrokePath addLineToPoint: CGPointMake(1547.93, 1019.59)];
        [tile5StrokePath closePath];
        [tileStrokeColor setFill];
        [tile5StrokePath fill];


        //// Tile-5-Letter Drawing
        UIBezierPath* tile5LetterPath = [UIBezierPath bezierPath];
        [tile5LetterPath moveToPoint: CGPointMake(1405.11, 840.06)];
        [tile5LetterPath addLineToPoint: CGPointMake(1430.32, 840.06)];
        [tile5LetterPath addLineToPoint: CGPointMake(1467.07, 908.64)];
        [tile5LetterPath addLineToPoint: CGPointMake(1466.89, 840.06)];
        [tile5LetterPath addLineToPoint: CGPointMake(1491.56, 840.06)];
        [tile5LetterPath addLineToPoint: CGPointMake(1491.56, 966.42)];
        [tile5LetterPath addLineToPoint: CGPointMake(1471.75, 966.42)];
        [tile5LetterPath addLineToPoint: CGPointMake(1429.42, 889.38)];
        [tile5LetterPath addLineToPoint: CGPointMake(1429.78, 966.06)];
        [tile5LetterPath addLineToPoint: CGPointMake(1405.11, 966.06)];
        [tile5LetterPath addLineToPoint: CGPointMake(1405.11, 840.06)];
        [tile5LetterPath closePath];
        [tileLetterColor setFill];
        [tile5LetterPath fill];


        //// Tile-5-Score Drawing
        UIBezierPath* tile5ScorePath = [UIBezierPath bezierPath];
        [tile5ScorePath moveToPoint: CGPointMake(1522.32, 980.42)];
        [tile5ScorePath addLineToPoint: CGPointMake(1536.44, 972.26)];
        [tile5ScorePath addLineToPoint: CGPointMake(1537.07, 972.5)];
        [tile5ScorePath addLineToPoint: CGPointMake(1537.07, 1007.83)];
        [tile5ScorePath addLineToPoint: CGPointMake(1529.96, 1007.83)];
        [tile5ScorePath addLineToPoint: CGPointMake(1529.96, 983.3)];
        [tile5ScorePath addLineToPoint: CGPointMake(1522.41, 987.67)];
        [tile5ScorePath addLineToPoint: CGPointMake(1522.32, 987.62)];
        [tile5ScorePath addLineToPoint: CGPointMake(1522.32, 980.42)];
        [tile5ScorePath closePath];
        [tileScoreColor setFill];
        [tile5ScorePath fill];


        //// Tile-6-Fill Drawing
        UIBezierPath* tile6FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1600.85, 787.2, 213.6, 239.6)];
        [tileFillColor setFill];
        [tile6FillPath fill];


        //// Tile-6-Stroke Drawing
        UIBezierPath* tile6StrokePath = [UIBezierPath bezierPath];
        [tile6StrokePath moveToPoint: CGPointMake(1821.67, 780)];
        [tile6StrokePath addLineToPoint: CGPointMake(1593.67, 780)];
        [tile6StrokePath addLineToPoint: CGPointMake(1593.67, 1034)];
        [tile6StrokePath addLineToPoint: CGPointMake(1821.67, 1034)];
        [tile6StrokePath addLineToPoint: CGPointMake(1821.67, 780)];
        [tile6StrokePath closePath];
        [tile6StrokePath moveToPoint: CGPointMake(1807.26, 1019.59)];
        [tile6StrokePath addLineToPoint: CGPointMake(1608.07, 1019.59)];
        [tile6StrokePath addLineToPoint: CGPointMake(1608.07, 794.41)];
        [tile6StrokePath addLineToPoint: CGPointMake(1807.26, 794.41)];
        [tile6StrokePath addLineToPoint: CGPointMake(1807.26, 1019.59)];
        [tile6StrokePath closePath];
        [tileStrokeColor setFill];
        [tile6StrokePath fill];


        //// Tile-6-Letter Drawing
        UIBezierPath* tile6LetterPath = [UIBezierPath bezierPath];
        [tile6LetterPath moveToPoint: CGPointMake(1719.11, 917.46)];
        [tile6LetterPath addLineToPoint: CGPointMake(1707.22, 869.58)];
        [tile6LetterPath addLineToPoint: CGPointMake(1694.97, 917.46)];
        [tile6LetterPath addLineToPoint: CGPointMake(1719.11, 917.46)];
        [tile6LetterPath closePath];
        [tile6LetterPath moveToPoint: CGPointMake(1692.81, 839.7)];
        [tile6LetterPath addLineToPoint: CGPointMake(1723.43, 839.7)];
        [tile6LetterPath addLineToPoint: CGPointMake(1758.55, 966.06)];
        [tile6LetterPath addLineToPoint: CGPointMake(1730.09, 966.06)];
        [tile6LetterPath addLineToPoint: CGPointMake(1723.61, 939.24)];
        [tile6LetterPath addLineToPoint: CGPointMake(1690.29, 939.24)];
        [tile6LetterPath addLineToPoint: CGPointMake(1683.8, 966.06)];
        [tile6LetterPath addLineToPoint: CGPointMake(1656.79, 966.06)];
        [tile6LetterPath addLineToPoint: CGPointMake(1692.81, 839.7)];
        [tile6LetterPath closePath];
        [tileLetterColor setFill];
        [tile6LetterPath fill];


        //// Tile-6-Score Drawing
        UIBezierPath* tile6ScorePath = [UIBezierPath bezierPath];
        [tile6ScorePath moveToPoint: CGPointMake(1781.65, 980.42)];
        [tile6ScorePath addLineToPoint: CGPointMake(1795.77, 972.26)];
        [tile6ScorePath addLineToPoint: CGPointMake(1796.4, 972.5)];
        [tile6ScorePath addLineToPoint: CGPointMake(1796.4, 1007.83)];
        [tile6ScorePath addLineToPoint: CGPointMake(1789.29, 1007.83)];
        [tile6ScorePath addLineToPoint: CGPointMake(1789.29, 983.3)];
        [tile6ScorePath addLineToPoint: CGPointMake(1781.75, 987.67)];
        [tile6ScorePath addLineToPoint: CGPointMake(1781.65, 987.62)];
        [tile6ScorePath addLineToPoint: CGPointMake(1781.65, 980.42)];
        [tile6ScorePath closePath];
        [tileScoreColor setFill];
        [tile6ScorePath fill];


        //// Tile-7-Fill Drawing
        UIBezierPath* tile7FillPath = [UIBezierPath bezierPathWithRect: CGRectMake(1860.2, 787.2, 213.6, 239.6)];
        [tileFillColor setFill];
        [tile7FillPath fill];


        //// Tile-7-Stroke Drawing
        UIBezierPath* tile7StrokePath = [UIBezierPath bezierPath];
        [tile7StrokePath moveToPoint: CGPointMake(2081, 780)];
        [tile7StrokePath addLineToPoint: CGPointMake(1853, 780)];
        [tile7StrokePath addLineToPoint: CGPointMake(1853, 1034)];
        [tile7StrokePath addLineToPoint: CGPointMake(2081, 1034)];
        [tile7StrokePath addLineToPoint: CGPointMake(2081, 780)];
        [tile7StrokePath closePath];
        [tile7StrokePath moveToPoint: CGPointMake(2066.59, 1019.59)];
        [tile7StrokePath addLineToPoint: CGPointMake(1867.41, 1019.59)];
        [tile7StrokePath addLineToPoint: CGPointMake(1867.41, 794.41)];
        [tile7StrokePath addLineToPoint: CGPointMake(2066.59, 794.41)];
        [tile7StrokePath addLineToPoint: CGPointMake(2066.59, 1019.59)];
        [tile7StrokePath closePath];
        [tileStrokeColor setFill];
        [tile7StrokePath fill];


        //// Tile-7-Letter Drawing
        UIBezierPath* tile7LetterPath = [UIBezierPath bezierPath];
        [tile7LetterPath moveToPoint: CGPointMake(1966.91, 945)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1977.36, 941.58) controlPoint1: CGPointMake(1970.88, 945) controlPoint2: CGPointMake(1974.48, 943.74)];
        [tile7LetterPath addLineToPoint: CGPointMake(1962.77, 924.66)];
        [tile7LetterPath addLineToPoint: CGPointMake(1977.9, 913.5)];
        [tile7LetterPath addLineToPoint: CGPointMake(1986, 923.4)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1987.63, 902.34) controlPoint1: CGPointMake(1987.09, 917.82) controlPoint2: CGPointMake(1987.63, 910.8)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1966.91, 861.3) controlPoint1: CGPointMake(1987.63, 875.52) controlPoint2: CGPointMake(1979.52, 861.3)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1946.2, 902.52) controlPoint1: CGPointMake(1954.3, 861.3) controlPoint2: CGPointMake(1946.2, 875.52)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1966.91, 945) controlPoint1: CGPointMake(1946.2, 930.24) controlPoint2: CGPointMake(1954.12, 945)];
        [tile7LetterPath closePath];
        [tile7LetterPath moveToPoint: CGPointMake(1999.69, 969.3)];
        [tile7LetterPath addLineToPoint: CGPointMake(1991.95, 959.4)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1966.37, 967.68) controlPoint1: CGPointMake(1984.92, 964.62) controlPoint2: CGPointMake(1976.28, 967.68)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1919, 902.34) controlPoint1: CGPointMake(1937.55, 967.68) controlPoint2: CGPointMake(1919, 942.12)];
        [tile7LetterPath addCurveToPoint: CGPointMake(1966.91, 837.54) controlPoint1: CGPointMake(1919, 862.92) controlPoint2: CGPointMake(1937.73, 837.54)];
        [tile7LetterPath addCurveToPoint: CGPointMake(2014.64, 901.98) controlPoint1: CGPointMake(1996.09, 837.54) controlPoint2: CGPointMake(2014.64, 863.1)];
        [tile7LetterPath addCurveToPoint: CGPointMake(2004.38, 945.54) controlPoint1: CGPointMake(2014.64, 919.98) controlPoint2: CGPointMake(2011.04, 934.56)];
        [tile7LetterPath addLineToPoint: CGPointMake(2015, 958.14)];
        [tile7LetterPath addLineToPoint: CGPointMake(1999.69, 969.3)];
        [tile7LetterPath closePath];
        [tileLetterColor setFill];
        [tile7LetterPath fill];


        //// Label Drawing
//        CGRect labelRect = CGRectMake(2015.07, 948.83, 44.57, 72);
//        {
//            NSString* textContent = @"18";
//            NSMutableParagraphStyle* labelStyle = [[NSMutableParagraphStyle alloc] init];
//            labelStyle.alignment = NSTextAlignmentCenter;
//            NSDictionary* labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"MalloryMPNarrow-Bold" size: 44], NSForegroundColorAttributeName: textForeground, NSParagraphStyleAttributeName: labelStyle};
//
//            CGFloat labelTextHeight = [textContent boundingRectWithSize: CGSizeMake(labelRect.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: labelFontAttributes context: nil].size.height;
//            CGContextSaveGState(context);
//            CGContextClipToRect(context, labelRect);
//            [textContent drawInRect: CGRectMake(CGRectGetMinX(labelRect), CGRectGetMinY(labelRect) + (labelRect.size.height - labelTextHeight) / 2, labelRect.size.width, labelTextHeight) withAttributes: labelFontAttributes];
//            CGContextRestoreGState(context);
//        }


        //// Trash-1 Drawing
        UIBezierPath* trash1Path = [UIBezierPath bezierPath];
        [trash1Path moveToPoint: CGPointMake(2154.14, 213.47)];
        [trash1Path addCurveToPoint: CGPointMake(2154.55, 213.45) controlPoint1: CGPointMake(2154.27, 213.47) controlPoint2: CGPointMake(2154.41, 213.47)];
        [trash1Path addCurveToPoint: CGPointMake(2158.62, 208.56) controlPoint1: CGPointMake(2157.03, 213.23) controlPoint2: CGPointMake(2158.85, 211.04)];
        [trash1Path addLineToPoint: CGPointMake(2151.49, 130.59)];
        [trash1Path addCurveToPoint: CGPointMake(2146.59, 126.52) controlPoint1: CGPointMake(2151.26, 128.12) controlPoint2: CGPointMake(2149.08, 126.29)];
        [trash1Path addCurveToPoint: CGPointMake(2142.52, 131.41) controlPoint1: CGPointMake(2144.12, 126.74) controlPoint2: CGPointMake(2142.3, 128.93)];
        [trash1Path addLineToPoint: CGPointMake(2149.66, 209.38)];
        [trash1Path addCurveToPoint: CGPointMake(2154.14, 213.47) controlPoint1: CGPointMake(2149.87, 211.72) controlPoint2: CGPointMake(2151.84, 213.47)];
        [trash1Path closePath];
        [trashColor setFill];
        [trash1Path fill];


        //// Trash-2 Drawing
        UIBezierPath* trash2Path = [UIBezierPath bezierPath];
        [trash2Path moveToPoint: CGPointMake(2191.21, 213.45)];
        [trash2Path addCurveToPoint: CGPointMake(2191.62, 213.47) controlPoint1: CGPointMake(2191.35, 213.47) controlPoint2: CGPointMake(2191.49, 213.47)];
        [trash2Path addCurveToPoint: CGPointMake(2196.1, 209.38) controlPoint1: CGPointMake(2193.93, 213.47) controlPoint2: CGPointMake(2195.89, 211.72)];
        [trash2Path addLineToPoint: CGPointMake(2203.24, 131.41)];
        [trash2Path addCurveToPoint: CGPointMake(2199.17, 126.52) controlPoint1: CGPointMake(2203.47, 128.93) controlPoint2: CGPointMake(2201.64, 126.74)];
        [trash2Path addCurveToPoint: CGPointMake(2194.28, 130.59) controlPoint1: CGPointMake(2196.68, 126.29) controlPoint2: CGPointMake(2194.5, 128.12)];
        [trash2Path addLineToPoint: CGPointMake(2187.14, 208.56)];
        [trash2Path addCurveToPoint: CGPointMake(2191.21, 213.45) controlPoint1: CGPointMake(2186.91, 211.04) controlPoint2: CGPointMake(2188.74, 213.23)];
        [trash2Path closePath];
        [trashColor setFill];
        [trash2Path fill];


        //// Trash-3 Drawing
        UIBezierPath* trash3Path = [UIBezierPath bezierPath];
        [trash3Path moveToPoint: CGPointMake(2172.88, 213.47)];
        [trash3Path addCurveToPoint: CGPointMake(2177.38, 208.97) controlPoint1: CGPointMake(2175.37, 213.47) controlPoint2: CGPointMake(2177.38, 211.46)];
        [trash3Path addLineToPoint: CGPointMake(2177.38, 131)];
        [trash3Path addCurveToPoint: CGPointMake(2172.88, 126.5) controlPoint1: CGPointMake(2177.38, 128.51) controlPoint2: CGPointMake(2175.37, 126.5)];
        [trash3Path addCurveToPoint: CGPointMake(2168.38, 131) controlPoint1: CGPointMake(2170.4, 126.5) controlPoint2: CGPointMake(2168.38, 128.51)];
        [trash3Path addLineToPoint: CGPointMake(2168.38, 208.97)];
        [trash3Path addCurveToPoint: CGPointMake(2172.88, 213.47) controlPoint1: CGPointMake(2168.38, 211.46) controlPoint2: CGPointMake(2170.4, 213.47)];
        [trash3Path closePath];
        [trashColor setFill];
        [trash3Path fill];


        //// Trash-4 Drawing
        UIBezierPath* trash4Path = [UIBezierPath bezierPath];
        [trash4Path moveToPoint: CGPointMake(2206.05, 213.93)];
        [trash4Path addLineToPoint: CGPointMake(2206.02, 214.54)];
        [trash4Path addCurveToPoint: CGPointMake(2198.76, 221.79) controlPoint1: CGPointMake(2206.02, 218.54) controlPoint2: CGPointMake(2202.77, 221.79)];
        [trash4Path addLineToPoint: CGPointMake(2147, 221.79)];
        [trash4Path addCurveToPoint: CGPointMake(2139.74, 214.54) controlPoint1: CGPointMake(2143, 221.79) controlPoint2: CGPointMake(2139.74, 218.54)];
        [trash4Path addLineToPoint: CGPointMake(2139.74, 214.23)];
        [trash4Path addLineToPoint: CGPointMake(2131.45, 119.07)];
        [trash4Path addLineToPoint: CGPointMake(2214.31, 119.07)];
        [trash4Path addLineToPoint: CGPointMake(2206.05, 213.93)];
        [trash4Path closePath];
        [trash4Path moveToPoint: CGPointMake(2165.57, 95.79)];
        [trash4Path addLineToPoint: CGPointMake(2180.19, 95.79)];
        [trash4Path addCurveToPoint: CGPointMake(2189.19, 104.73) controlPoint1: CGPointMake(2185.13, 95.79) controlPoint2: CGPointMake(2189.15, 99.8)];
        [trash4Path addLineToPoint: CGPointMake(2156.58, 104.73)];
        [trash4Path addCurveToPoint: CGPointMake(2165.57, 95.79) controlPoint1: CGPointMake(2156.61, 99.8) controlPoint2: CGPointMake(2160.63, 95.79)];
        [trash4Path closePath];
        [trash4Path moveToPoint: CGPointMake(2230.88, 104.73)];
        [trash4Path addLineToPoint: CGPointMake(2201.19, 104.73)];
        [trash4Path addCurveToPoint: CGPointMake(2180.19, 83.79) controlPoint1: CGPointMake(2201.15, 93.18) controlPoint2: CGPointMake(2191.75, 83.79)];
        [trash4Path addLineToPoint: CGPointMake(2165.57, 83.79)];
        [trash4Path addCurveToPoint: CGPointMake(2144.58, 104.73) controlPoint1: CGPointMake(2154.01, 83.79) controlPoint2: CGPointMake(2144.61, 93.18)];
        [trash4Path addLineToPoint: CGPointMake(2114.88, 104.73)];
        [trash4Path addCurveToPoint: CGPointMake(2108.88, 110.73) controlPoint1: CGPointMake(2111.57, 104.73) controlPoint2: CGPointMake(2108.88, 107.42)];
        [trash4Path addCurveToPoint: CGPointMake(2114.88, 116.73) controlPoint1: CGPointMake(2108.88, 114.05) controlPoint2: CGPointMake(2111.57, 116.73)];
        [trash4Path addLineToPoint: CGPointMake(2117.17, 116.73)];
        [trash4Path addLineToPoint: CGPointMake(2125.72, 214.87)];
        [trash4Path addCurveToPoint: CGPointMake(2147, 235.79) controlPoint1: CGPointMake(2125.9, 226.44) controlPoint2: CGPointMake(2135.38, 235.79)];
        [trash4Path addLineToPoint: CGPointMake(2198.76, 235.79)];
        [trash4Path addCurveToPoint: CGPointMake(2220.04, 214.87) controlPoint1: CGPointMake(2210.38, 235.79) controlPoint2: CGPointMake(2219.86, 226.44)];
        [trash4Path addLineToPoint: CGPointMake(2228.59, 116.73)];
        [trash4Path addLineToPoint: CGPointMake(2230.88, 116.73)];
        [trash4Path addCurveToPoint: CGPointMake(2236.88, 110.73) controlPoint1: CGPointMake(2234.2, 116.73) controlPoint2: CGPointMake(2236.88, 114.05)];
        [trash4Path addCurveToPoint: CGPointMake(2230.88, 104.73) controlPoint1: CGPointMake(2236.88, 107.42) controlPoint2: CGPointMake(2234.2, 104.73)];
        [trash4Path closePath];
        [trashColor setFill];
        [trash4Path fill];


        //// Tray-Fill Drawing
        UIBezierPath* trayFillPath = [UIBezierPath bezierPath];
        [trayFillPath moveToPoint: CGPointMake(2239.1, 406.01)];
        [trayFillPath addCurveToPoint: CGPointMake(2239.16, 379.08) controlPoint1: CGPointMake(2239.11, 397.03) controlPoint2: CGPointMake(2239.13, 388.06)];
        [trayFillPath addLineToPoint: CGPointMake(2238.81, 379.14)];
        [trayFillPath addCurveToPoint: CGPointMake(2238.58, 363.08) controlPoint1: CGPointMake(2238.74, 373.78) controlPoint2: CGPointMake(2238.67, 368.43)];
        [trayFillPath addCurveToPoint: CGPointMake(2223.79, 339.43) controlPoint1: CGPointMake(2237.99, 352.59) controlPoint2: CGPointMake(2234.25, 343.73)];
        [trayFillPath addCurveToPoint: CGPointMake(2206.85, 333.7) controlPoint1: CGPointMake(2218.28, 337.16) controlPoint2: CGPointMake(2212.66, 334.73)];
        [trayFillPath addCurveToPoint: CGPointMake(2164.78, 327.65) controlPoint1: CGPointMake(2192.91, 331.21) controlPoint2: CGPointMake(2178.88, 328.7)];
        [trayFillPath addCurveToPoint: CGPointMake(1718.59, 318.37) controlPoint1: CGPointMake(2016.33, 316.97) controlPoint2: CGPointMake(1867.32, 319.24)];
        [trayFillPath addCurveToPoint: CGPointMake(1189.4, 317.99) controlPoint1: CGPointMake(1548.11, 318) controlPoint2: CGPointMake(1360.16, 317.92)];
        [trayFillPath addCurveToPoint: CGPointMake(660.2, 318.37) controlPoint1: CGPointMake(1018.64, 317.92) controlPoint2: CGPointMake(830.68, 318)];
        [trayFillPath addCurveToPoint: CGPointMake(214.01, 327.65) controlPoint1: CGPointMake(511.47, 319.24) controlPoint2: CGPointMake(362.46, 316.97)];
        [trayFillPath addCurveToPoint: CGPointMake(171.94, 333.7) controlPoint1: CGPointMake(199.91, 328.7) controlPoint2: CGPointMake(185.89, 331.21)];
        [trayFillPath addCurveToPoint: CGPointMake(155, 339.43) controlPoint1: CGPointMake(166.13, 334.73) controlPoint2: CGPointMake(160.51, 337.16)];
        [trayFillPath addCurveToPoint: CGPointMake(140.21, 363.08) controlPoint1: CGPointMake(144.54, 343.73) controlPoint2: CGPointMake(140.8, 352.59)];
        [trayFillPath addCurveToPoint: CGPointMake(139.98, 379.14) controlPoint1: CGPointMake(140.12, 368.43) controlPoint2: CGPointMake(140.05, 373.78)];
        [trayFillPath addLineToPoint: CGPointMake(139.63, 379.08)];
        [trayFillPath addCurveToPoint: CGPointMake(139.69, 406) controlPoint1: CGPointMake(139.67, 388.05) controlPoint2: CGPointMake(139.68, 397.03)];
        [trayFillPath addCurveToPoint: CGPointMake(139.69, 609.93) controlPoint1: CGPointMake(139.34, 446.82) controlPoint2: CGPointMake(139.34, 569.11)];
        [trayFillPath addCurveToPoint: CGPointMake(139.63, 636.85) controlPoint1: CGPointMake(139.68, 618.9) controlPoint2: CGPointMake(139.67, 627.87)];
        [trayFillPath addLineToPoint: CGPointMake(139.98, 636.79)];
        [trayFillPath addCurveToPoint: CGPointMake(140.21, 652.85) controlPoint1: CGPointMake(140.05, 642.15) controlPoint2: CGPointMake(140.12, 647.5)];
        [trayFillPath addCurveToPoint: CGPointMake(155, 676.5) controlPoint1: CGPointMake(140.8, 663.34) controlPoint2: CGPointMake(144.54, 672.2)];
        [trayFillPath addCurveToPoint: CGPointMake(171.94, 682.23) controlPoint1: CGPointMake(160.51, 678.77) controlPoint2: CGPointMake(166.13, 681.2)];
        [trayFillPath addCurveToPoint: CGPointMake(214.01, 688.28) controlPoint1: CGPointMake(185.89, 684.72) controlPoint2: CGPointMake(199.91, 687.23)];
        [trayFillPath addCurveToPoint: CGPointMake(660.2, 697.56) controlPoint1: CGPointMake(362.46, 698.96) controlPoint2: CGPointMake(511.47, 696.69)];
        [trayFillPath addCurveToPoint: CGPointMake(1189.4, 697.94) controlPoint1: CGPointMake(830.68, 697.93) controlPoint2: CGPointMake(1018.64, 698.01)];
        [trayFillPath addCurveToPoint: CGPointMake(1718.59, 697.56) controlPoint1: CGPointMake(1360.16, 698.01) controlPoint2: CGPointMake(1548.11, 697.93)];
        [trayFillPath addCurveToPoint: CGPointMake(2164.78, 688.28) controlPoint1: CGPointMake(1867.32, 696.69) controlPoint2: CGPointMake(2016.33, 698.96)];
        [trayFillPath addCurveToPoint: CGPointMake(2206.85, 682.23) controlPoint1: CGPointMake(2178.88, 687.23) controlPoint2: CGPointMake(2192.91, 684.72)];
        [trayFillPath addCurveToPoint: CGPointMake(2223.79, 676.5) controlPoint1: CGPointMake(2212.66, 681.2) controlPoint2: CGPointMake(2218.28, 678.77)];
        [trayFillPath addCurveToPoint: CGPointMake(2238.58, 652.85) controlPoint1: CGPointMake(2234.25, 672.2) controlPoint2: CGPointMake(2237.99, 663.34)];
        [trayFillPath addCurveToPoint: CGPointMake(2238.81, 636.79) controlPoint1: CGPointMake(2238.67, 647.5) controlPoint2: CGPointMake(2238.74, 642.15)];
        [trayFillPath addLineToPoint: CGPointMake(2239.16, 636.85)];
        [trayFillPath addCurveToPoint: CGPointMake(2239.1, 609.92) controlPoint1: CGPointMake(2239.13, 627.87) controlPoint2: CGPointMake(2239.11, 618.9)];
        [trayFillPath addCurveToPoint: CGPointMake(2239.1, 406.01) controlPoint1: CGPointMake(2239.45, 569.11) controlPoint2: CGPointMake(2239.45, 446.82)];
        [trayFillPath closePath];
        [trayFillColor setFill];
        [trayFillPath fill];


        //// Tray-Stroke Drawing
        UIBezierPath* trayStrokePath = [UIBezierPath bezierPath];
        [trayStrokePath moveToPoint: CGPointMake(2239.1, 406.01)];
        [trayStrokePath addCurveToPoint: CGPointMake(2239.16, 379.08) controlPoint1: CGPointMake(2239.11, 397.03) controlPoint2: CGPointMake(2239.13, 388.06)];
        [trayStrokePath addLineToPoint: CGPointMake(2238.81, 379.14)];
        [trayStrokePath addCurveToPoint: CGPointMake(2238.58, 363.08) controlPoint1: CGPointMake(2238.74, 373.78) controlPoint2: CGPointMake(2238.67, 368.43)];
        [trayStrokePath addCurveToPoint: CGPointMake(2223.79, 339.43) controlPoint1: CGPointMake(2237.99, 352.59) controlPoint2: CGPointMake(2234.25, 343.73)];
        [trayStrokePath addCurveToPoint: CGPointMake(2206.85, 333.7) controlPoint1: CGPointMake(2218.28, 337.16) controlPoint2: CGPointMake(2212.66, 334.73)];
        [trayStrokePath addCurveToPoint: CGPointMake(2164.78, 327.65) controlPoint1: CGPointMake(2192.91, 331.21) controlPoint2: CGPointMake(2178.88, 328.7)];
        [trayStrokePath addCurveToPoint: CGPointMake(1718.59, 318.37) controlPoint1: CGPointMake(2016.33, 316.97) controlPoint2: CGPointMake(1867.32, 319.24)];
        [trayStrokePath addCurveToPoint: CGPointMake(1189.4, 317.99) controlPoint1: CGPointMake(1548.11, 318) controlPoint2: CGPointMake(1360.16, 317.92)];
        [trayStrokePath addCurveToPoint: CGPointMake(660.2, 318.37) controlPoint1: CGPointMake(1018.64, 317.92) controlPoint2: CGPointMake(830.68, 318)];
        [trayStrokePath addCurveToPoint: CGPointMake(214.01, 327.65) controlPoint1: CGPointMake(511.47, 319.24) controlPoint2: CGPointMake(362.46, 316.97)];
        [trayStrokePath addCurveToPoint: CGPointMake(171.94, 333.7) controlPoint1: CGPointMake(199.91, 328.7) controlPoint2: CGPointMake(185.89, 331.21)];
        [trayStrokePath addCurveToPoint: CGPointMake(155, 339.43) controlPoint1: CGPointMake(166.13, 334.73) controlPoint2: CGPointMake(160.51, 337.16)];
        [trayStrokePath addCurveToPoint: CGPointMake(140.21, 363.08) controlPoint1: CGPointMake(144.54, 343.73) controlPoint2: CGPointMake(140.8, 352.59)];
        [trayStrokePath addCurveToPoint: CGPointMake(139.98, 379.14) controlPoint1: CGPointMake(140.12, 368.43) controlPoint2: CGPointMake(140.05, 373.78)];
        [trayStrokePath addLineToPoint: CGPointMake(139.63, 379.08)];
        [trayStrokePath addCurveToPoint: CGPointMake(139.69, 406) controlPoint1: CGPointMake(139.67, 388.05) controlPoint2: CGPointMake(139.68, 397.03)];
        [trayStrokePath addCurveToPoint: CGPointMake(139.69, 609.93) controlPoint1: CGPointMake(139.34, 446.82) controlPoint2: CGPointMake(139.34, 569.11)];
        [trayStrokePath addCurveToPoint: CGPointMake(139.63, 636.85) controlPoint1: CGPointMake(139.68, 618.9) controlPoint2: CGPointMake(139.67, 627.87)];
        [trayStrokePath addLineToPoint: CGPointMake(139.98, 636.79)];
        [trayStrokePath addCurveToPoint: CGPointMake(140.21, 652.85) controlPoint1: CGPointMake(140.05, 642.15) controlPoint2: CGPointMake(140.12, 647.5)];
        [trayStrokePath addCurveToPoint: CGPointMake(155, 676.5) controlPoint1: CGPointMake(140.8, 663.34) controlPoint2: CGPointMake(144.54, 672.2)];
        [trayStrokePath addCurveToPoint: CGPointMake(171.94, 682.23) controlPoint1: CGPointMake(160.51, 678.77) controlPoint2: CGPointMake(166.13, 681.2)];
        [trayStrokePath addCurveToPoint: CGPointMake(214.01, 688.28) controlPoint1: CGPointMake(185.89, 684.72) controlPoint2: CGPointMake(199.91, 687.23)];
        [trayStrokePath addCurveToPoint: CGPointMake(660.2, 697.56) controlPoint1: CGPointMake(362.46, 698.96) controlPoint2: CGPointMake(511.47, 696.69)];
        [trayStrokePath addCurveToPoint: CGPointMake(1189.4, 697.94) controlPoint1: CGPointMake(830.68, 697.93) controlPoint2: CGPointMake(1018.64, 698.01)];
        [trayStrokePath addCurveToPoint: CGPointMake(1718.59, 697.56) controlPoint1: CGPointMake(1360.16, 698.01) controlPoint2: CGPointMake(1548.11, 697.93)];
        [trayStrokePath addCurveToPoint: CGPointMake(2164.78, 688.28) controlPoint1: CGPointMake(1867.32, 696.69) controlPoint2: CGPointMake(2016.33, 698.96)];
        [trayStrokePath addCurveToPoint: CGPointMake(2206.85, 682.23) controlPoint1: CGPointMake(2178.88, 687.23) controlPoint2: CGPointMake(2192.91, 684.72)];
        [trayStrokePath addCurveToPoint: CGPointMake(2223.79, 676.5) controlPoint1: CGPointMake(2212.66, 681.2) controlPoint2: CGPointMake(2218.28, 678.77)];
        [trayStrokePath addCurveToPoint: CGPointMake(2238.58, 652.85) controlPoint1: CGPointMake(2234.25, 672.2) controlPoint2: CGPointMake(2237.99, 663.34)];
        [trayStrokePath addCurveToPoint: CGPointMake(2238.81, 636.79) controlPoint1: CGPointMake(2238.67, 647.5) controlPoint2: CGPointMake(2238.74, 642.15)];
        [trayStrokePath addLineToPoint: CGPointMake(2239.16, 636.85)];
        [trayStrokePath addCurveToPoint: CGPointMake(2239.1, 609.92) controlPoint1: CGPointMake(2239.13, 627.87) controlPoint2: CGPointMake(2239.11, 618.9)];
        [trayStrokePath addCurveToPoint: CGPointMake(2239.1, 406.01) controlPoint1: CGPointMake(2239.45, 569.11) controlPoint2: CGPointMake(2239.45, 446.82)];
        [trayStrokePath closePath];
        [trayStrokeColor setStroke];
        trayStrokePath.lineWidth = 24;
        [trayStrokePath stroke];


        //// Ex Drawing
        UIBezierPath* exPath = [UIBezierPath bezierPath];
        [exPath moveToPoint: CGPointMake(294.61, 162.79)];
        [exPath addLineToPoint: CGPointMake(341.54, 115.86)];
        [exPath addCurveToPoint: CGPointMake(341.54, 101.72) controlPoint1: CGPointMake(345.44, 111.96) controlPoint2: CGPointMake(345.44, 105.63)];
        [exPath addCurveToPoint: CGPointMake(327.39, 101.72) controlPoint1: CGPointMake(337.63, 97.82) controlPoint2: CGPointMake(331.3, 97.82)];
        [exPath addLineToPoint: CGPointMake(280.46, 148.65)];
        [exPath addLineToPoint: CGPointMake(233.54, 101.72)];
        [exPath addCurveToPoint: CGPointMake(219.39, 101.72) controlPoint1: CGPointMake(229.63, 97.82) controlPoint2: CGPointMake(223.3, 97.82)];
        [exPath addCurveToPoint: CGPointMake(219.39, 115.86) controlPoint1: CGPointMake(215.49, 105.63) controlPoint2: CGPointMake(215.49, 111.96)];
        [exPath addLineToPoint: CGPointMake(266.32, 162.79)];
        [exPath addLineToPoint: CGPointMake(219.39, 209.72)];
        [exPath addCurveToPoint: CGPointMake(219.39, 223.86) controlPoint1: CGPointMake(215.49, 213.63) controlPoint2: CGPointMake(215.49, 219.96)];
        [exPath addCurveToPoint: CGPointMake(226.46, 226.79) controlPoint1: CGPointMake(221.35, 225.82) controlPoint2: CGPointMake(223.9, 226.79)];
        [exPath addCurveToPoint: CGPointMake(233.54, 223.86) controlPoint1: CGPointMake(229.02, 226.79) controlPoint2: CGPointMake(231.58, 225.82)];
        [exPath addLineToPoint: CGPointMake(280.46, 176.94)];
        [exPath addLineToPoint: CGPointMake(327.39, 223.86)];
        [exPath addCurveToPoint: CGPointMake(334.46, 226.79) controlPoint1: CGPointMake(329.35, 225.82) controlPoint2: CGPointMake(331.9, 226.79)];
        [exPath addCurveToPoint: CGPointMake(341.54, 223.86) controlPoint1: CGPointMake(337.02, 226.79) controlPoint2: CGPointMake(339.58, 225.82)];
        [exPath addCurveToPoint: CGPointMake(341.54, 209.72) controlPoint1: CGPointMake(345.44, 219.96) controlPoint2: CGPointMake(345.44, 213.63)];
        [exPath addLineToPoint: CGPointMake(294.61, 162.79)];
        [exPath closePath];
        [exColor setFill];
        [exPath fill];


        //// Tray-Score Drawing
        UIBezierPath* trayScorePath = [UIBezierPath bezierPath];
        [trayScorePath moveToPoint: CGPointMake(2183, 623.26)];
        [trayScorePath addCurveToPoint: CGPointMake(2176.02, 605.56) controlPoint1: CGPointMake(2183, 611.26) controlPoint2: CGPointMake(2180.45, 605.56)];
        [trayScorePath addCurveToPoint: CGPointMake(2169.2, 623.26) controlPoint1: CGPointMake(2171.67, 605.56) controlPoint2: CGPointMake(2169.2, 611.34)];
        [trayScorePath addCurveToPoint: CGPointMake(2176.17, 640.96) controlPoint1: CGPointMake(2169.2, 635.19) controlPoint2: CGPointMake(2171.67, 640.96)];
        [trayScorePath addCurveToPoint: CGPointMake(2183, 623.26) controlPoint1: CGPointMake(2180.52, 640.96) controlPoint2: CGPointMake(2183, 635.19)];
        [trayScorePath closePath];
        [trayScorePath moveToPoint: CGPointMake(2193.35, 623.26)];
        [trayScorePath addCurveToPoint: CGPointMake(2176.1, 650.56) controlPoint1: CGPointMake(2193.35, 641.04) controlPoint2: CGPointMake(2186.82, 650.56)];
        [trayScorePath addCurveToPoint: CGPointMake(2158.85, 623.26) controlPoint1: CGPointMake(2165.15, 650.56) controlPoint2: CGPointMake(2158.85, 641.11)];
        [trayScorePath addCurveToPoint: CGPointMake(2176.1, 595.96) controlPoint1: CGPointMake(2158.85, 605.56) controlPoint2: CGPointMake(2165.37, 595.96)];
        [trayScorePath addCurveToPoint: CGPointMake(2193.35, 623.26) controlPoint1: CGPointMake(2186.97, 595.96) controlPoint2: CGPointMake(2193.35, 605.41)];
        [trayScorePath closePath];
        [trayScoreColor setFill];
        [trayScorePath fill];
    }
}

@end
