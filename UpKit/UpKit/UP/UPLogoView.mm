//
//  UPLogoView.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UIColor+UP.h"
#import "UPBezierPathView.h"
#import "UPGeometry.h"
#import "UPGradientView.h"
#import "UPLogoView.h"

static constexpr CGSize UPVectorLogoCanonicalSize = { 1024, 1024 };
static constexpr CGSize UPVectorLogoCanonicalFillSize = { 874, 874 };

static UIColor *UPVectorLogoBorderBackgroundColor()
{
    return [UIColor colorWithWhite:0.5 alpha:0.7];
}

static UIColor *UPVectorLogoBorderColor()
{
    return [UIColor colorWithWhite:0.13 alpha:1.0];
}

static UIColor *UPVectorLogoArrowColor()
{
    return [UIColor colorWithWhite:0.13 alpha:1.0];
}

static UIColor *UPVectorLogoMeatballColor()
{
    return [UIColor colorWithWhite:0.96 alpha:1.0];
}

static NSArray<UIColor *> *UPVectorLogoBackgroundColors(int hue)
{
    switch (hue) {
        case 0:
            return @[ up_rgb(206, 174, 174), up_rgb(177, 128, 128) ];
        case 15:
            return @[ up_rgb(208, 70, 23),   up_rgb(184, 140, 124) ];
        case 30:
            return @[ up_rgb(208, 190, 171), up_rgb(185, 153, 124) ];
        case 45:
            return @[ up_rgb(216, 202, 164), up_rgb(194, 172, 113) ];
        case 60:
            return @[ up_rgb(206, 206, 174), up_rgb(178, 178, 128) ];
        case 75:
            return @[ up_rgb(197, 206, 174), up_rgb(166, 179, 128) ];
        case 90:
            return @[ up_rgb(190, 206, 173), up_rgb(154, 179, 129) ];
        case 105:
            return @[ up_rgb(183, 206, 174), up_rgb(143, 178, 128) ];
        case 120:
            return @[ up_rgb(173, 206, 173), up_rgb(128, 178, 128) ];
        case 135:
            return @[ up_rgb(174, 207, 182), up_rgb(128, 178, 140) ];
        case 150:
            return @[ up_rgb(174, 206, 189), up_rgb(128, 178, 152) ];
        case 165:
            return @[ up_rgb(174, 206, 196), up_rgb(128, 178, 164) ];
        case 180:
            return @[ up_rgb(174, 206, 206), up_rgb(128, 179, 179) ];
        case 195:
            return @[ up_rgb(174, 197, 206), up_rgb(128, 164, 178) ];
        case 210:
        default:
            return @[ up_rgb(175, 190, 206), up_rgb(128, 154, 179) ];
        case 225:
            return @[ up_rgb(173, 181, 206), up_rgb(128, 141, 179) ];
        case 240:
            return @[ up_rgb(174, 175, 206), up_rgb(62, 62, 185) ];
        case 255:
            return @[ up_rgb(182, 175, 206), up_rgb(141, 127, 178) ];
        case 270:
            return @[ up_rgb(190, 174, 206), up_rgb(153, 128, 179) ];
        case 285:
            return @[ up_rgb(197, 174, 206), up_rgb(123, 39, 157) ];
        case 300:
            return @[ up_rgb(206, 174, 206), up_rgb(178, 128, 178) ];
        case 315:
            return @[ up_rgb(206, 173, 196), up_rgb(177, 128, 164) ];
        case 330:
            return @[ up_rgb(206, 175, 191), up_rgb(177, 127, 154) ];
        case 345:
            return @[ up_rgb(206, 174, 182), up_rgb(180, 32, 73) ];
    }
}

static NSArray<UIColor *> *UPVectorLogoFillColors(int hue)
{
    switch (hue) {
        case 0:
            return @[ up_rgb(201, 36, 36), up_rgb(181, 32, 32) ];
        case 15:
            return @[ up_rgb(227, 76, 25),  up_rgb(208, 70, 23) ];
        case 30:
            return @[ up_rgb(231, 132, 35), up_rgb(222, 122, 25) ];
        case 45:
            return @[ up_rgb(244, 193, 53), up_rgb(244, 188, 34) ];
        case 60:
            return @[ up_rgb(193, 193, 27), up_rgb(172, 172, 25) ];
        case 75:
            return @[ up_rgb(154, 194, 42), up_rgb(139, 175, 38) ];
        case 90:
            return @[ up_rgb(102, 175, 31), up_rgb(88, 153, 27) ];
        case 105:
            return @[ up_rgb(75, 170, 37),  up_rgb(63, 148, 32) ];
        case 120:
            return @[ up_rgb(37, 169, 36),  up_rgb(33, 148, 33) ];
        case 135:
            return @[ up_rgb(37, 170, 70),  up_rgb(33, 148, 62) ];
        case 150:
            return @[ up_rgb(38, 169, 99),  up_rgb(33, 148, 87) ];
        case 165:
            return @[ up_rgb(36, 170, 132), up_rgb(31, 148, 116) ];
        case 180:
            return @[ up_rgb(37, 169, 170), up_rgb(32, 148, 149) ];
        case 195:
            return @[ up_rgb(30, 137, 175), up_rgb(28, 119, 153) ];
        case 210:
            return @[ up_rgb(32, 102, 175), up_rgb(27, 89, 153) ];
        default:
        case 225:
            return @[ up_rgb(39, 74, 181),  up_rgb(36, 67, 163) ];
        case 240:
            return @[ up_rgb(72, 71, 194),  up_rgb(62, 62, 185) ];
        case 255:
            return @[ up_rgb(96, 63, 189),  up_rgb(87, 58, 173) ];
        case 270:
            return @[ up_rgb(116, 52, 182), up_rgb(106, 48, 165) ];
        case 285:
            return @[ up_rgb(137, 44, 175), up_rgb(123, 39, 157) ];
        case 300:
            return @[ up_rgb(170, 40, 171), up_rgb(148, 33, 148) ];
        case 315:
            return @[ up_rgb(181, 39, 143), up_rgb(162, 35, 128) ];
        case 330:
            return @[ up_rgb(202, 51, 129), up_rgb(184, 46, 118) ];
        case 345:
            return @[ up_rgb(201, 36, 82),  up_rgb(181, 32, 73) ];
    }
}

static UIBezierPath *UPVectorLogoBorderBackgroundPath()
{
    return [UIBezierPath bezierPathWithOvalInRect: CGRectMake(44, 44, 936, 936)];
}

static UIBezierPath *UPVectorLogoBorderPath()
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(512, 78)];
    [path addCurveToPoint: CGPointMake(342.68, 112.18) controlPoint1: CGPointMake(453.27, 78) controlPoint2: CGPointMake(396.3, 89.5)];
    [path addCurveToPoint: CGPointMake(204.41, 205.41) controlPoint1: CGPointMake(290.88, 134.09) controlPoint2: CGPointMake(244.36, 165.45)];
    [path addCurveToPoint: CGPointMake(111.18, 343.68) controlPoint1: CGPointMake(164.45, 245.36) controlPoint2: CGPointMake(133.09, 291.88)];
    [path addCurveToPoint: CGPointMake(77, 513) controlPoint1: CGPointMake(88.5, 397.3) controlPoint2: CGPointMake(77, 454.27)];
    [path addCurveToPoint: CGPointMake(111.18, 682.32) controlPoint1: CGPointMake(77, 571.73) controlPoint2: CGPointMake(88.5, 628.7)];
    [path addCurveToPoint: CGPointMake(204.41, 820.59) controlPoint1: CGPointMake(133.09, 734.12) controlPoint2: CGPointMake(164.45, 780.64)];
    [path addCurveToPoint: CGPointMake(342.68, 913.82) controlPoint1: CGPointMake(244.36, 860.55) controlPoint2: CGPointMake(290.88, 891.91)];
    [path addCurveToPoint: CGPointMake(512, 948) controlPoint1: CGPointMake(396.3, 936.5) controlPoint2: CGPointMake(453.27, 948)];
    [path addCurveToPoint: CGPointMake(681.32, 913.82) controlPoint1: CGPointMake(570.73, 948) controlPoint2: CGPointMake(627.7, 936.5)];
    [path addCurveToPoint: CGPointMake(819.59, 820.59) controlPoint1: CGPointMake(733.11, 891.91) controlPoint2: CGPointMake(779.64, 860.55)];
    [path addCurveToPoint: CGPointMake(912.82, 682.32) controlPoint1: CGPointMake(859.55, 780.64) controlPoint2: CGPointMake(890.91, 734.12)];
    [path addCurveToPoint: CGPointMake(947, 513) controlPoint1: CGPointMake(935.5, 628.7) controlPoint2: CGPointMake(947, 571.73)];
    [path addCurveToPoint: CGPointMake(912.82, 343.68) controlPoint1: CGPointMake(947, 454.27) controlPoint2: CGPointMake(935.5, 397.3)];
    [path addCurveToPoint: CGPointMake(819.59, 205.41) controlPoint1: CGPointMake(890.91, 291.88) controlPoint2: CGPointMake(859.55, 245.36)];
    [path addCurveToPoint: CGPointMake(681.32, 112.18) controlPoint1: CGPointMake(779.64, 165.45) controlPoint2: CGPointMake(733.11, 134.09)];
    [path addCurveToPoint: CGPointMake(512, 78) controlPoint1: CGPointMake(627.7, 89.5) controlPoint2: CGPointMake(570.73, 78)];
    [path closePath];
    [path moveToPoint: CGPointMake(512, 978)];
    [path addCurveToPoint: CGPointMake(331, 941.45) controlPoint1: CGPointMake(449.23, 978) controlPoint2: CGPointMake(388.33, 965.7)];
    [path addCurveToPoint: CGPointMake(183.19, 841.81) controlPoint1: CGPointMake(275.62, 918.03) controlPoint2: CGPointMake(225.89, 884.5)];
    [path addCurveToPoint: CGPointMake(83.55, 694) controlPoint1: CGPointMake(140.5, 799.1) controlPoint2: CGPointMake(106.97, 749.38)];
    [path addCurveToPoint: CGPointMake(47, 513) controlPoint1: CGPointMake(59.3, 636.67) controlPoint2: CGPointMake(47, 575.77)];
    [path addCurveToPoint: CGPointMake(83.55, 332) controlPoint1: CGPointMake(47, 450.23) controlPoint2: CGPointMake(59.3, 389.33)];
    [path addCurveToPoint: CGPointMake(183.19, 184.2) controlPoint1: CGPointMake(106.97, 276.62) controlPoint2: CGPointMake(140.5, 226.89)];
    [path addCurveToPoint: CGPointMake(331, 84.55) controlPoint1: CGPointMake(225.89, 141.5) controlPoint2: CGPointMake(275.62, 107.97)];
    [path addCurveToPoint: CGPointMake(512, 48) controlPoint1: CGPointMake(388.33, 60.3) controlPoint2: CGPointMake(449.23, 48)];
    [path addCurveToPoint: CGPointMake(693, 84.55) controlPoint1: CGPointMake(574.77, 48) controlPoint2: CGPointMake(635.67, 60.3)];
    [path addCurveToPoint: CGPointMake(840.81, 184.2) controlPoint1: CGPointMake(748.38, 107.97) controlPoint2: CGPointMake(798.1, 141.5)];
    [path addCurveToPoint: CGPointMake(940.45, 332) controlPoint1: CGPointMake(883.5, 226.89) controlPoint2: CGPointMake(917.03, 276.62)];
    [path addCurveToPoint: CGPointMake(977, 513) controlPoint1: CGPointMake(964.7, 389.33) controlPoint2: CGPointMake(977, 450.23)];
    [path addCurveToPoint: CGPointMake(940.45, 694) controlPoint1: CGPointMake(977, 575.77) controlPoint2: CGPointMake(964.7, 636.67)];
    [path addCurveToPoint: CGPointMake(840.81, 841.81) controlPoint1: CGPointMake(917.03, 749.38) controlPoint2: CGPointMake(883.5, 799.1)];
    [path addCurveToPoint: CGPointMake(693, 941.45) controlPoint1: CGPointMake(798.1, 884.5) controlPoint2: CGPointMake(748.38, 918.03)];
    [path addCurveToPoint: CGPointMake(512, 978) controlPoint1: CGPointMake(635.67, 965.7) controlPoint2: CGPointMake(574.77, 978)];
    [path closePath];
    return path;
}

static UIBezierPath *UPVectorLogoFillClipPath()
{
    CGFloat x = (up_size_width(UPVectorLogoCanonicalSize) - up_size_width(UPVectorLogoCanonicalFillSize)) * 0.5;
    CGFloat y = (up_size_height(UPVectorLogoCanonicalSize) - up_size_height(UPVectorLogoCanonicalFillSize)) * 0.5;
    CGRect rect = CGRectMake(x, y, up_size_width(UPVectorLogoCanonicalFillSize), up_size_height(UPVectorLogoCanonicalFillSize));
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

static UIBezierPath *UPVectorLogoMeatballPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(715.28, 500.9)];
    [path addCurveToPoint: CGPointMake(471.81, 257.34) controlPoint1: CGPointMake(696.3, 379.53) controlPoint2: CGPointMake(593.68, 275.17)];
    [path addCurveToPoint: CGPointMake(210.97, 718.58) controlPoint1: CGPointMake(226.33, 230.85) controlPoint2: CGPointMake(66.18, 521.6)];
    [path addCurveToPoint: CGPointMake(590.79, 789.12) controlPoint1: CGPointMake(298.38, 841.54) controlPoint2: CGPointMake(466.9, 882.05)];
    [path addCurveToPoint: CGPointMake(715.28, 500.9) controlPoint1: CGPointMake(680.59, 725.21) controlPoint2: CGPointMake(733.3, 611.29)];
    [path closePath];
    return path;
}

static UIBezierPath *UPVectorLogoArrowPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(402.57, 323.86)];
    [path addCurveToPoint: CGPointMake(252.23, 648.07) controlPoint1: CGPointMake(341.2, 408.92) controlPoint2: CGPointMake(275.35, 513.95)];
    [path addCurveToPoint: CGPointMake(336.5, 606.73) controlPoint1: CGPointMake(277.49, 634.41) controlPoint2: CGPointMake(292.74, 626.17)];
    [path addCurveToPoint: CGPointMake(350.86, 699.76) controlPoint1: CGPointMake(339.52, 638.04) controlPoint2: CGPointMake(344.22, 669.19)];
    [path addCurveToPoint: CGPointMake(455.71, 697.58) controlPoint1: CGPointMake(385.73, 699.4) controlPoint2: CGPointMake(420.79, 698.64)];
    [path addCurveToPoint: CGPointMake(448.17, 603.21) controlPoint1: CGPointMake(452.45, 666.33) controlPoint2: CGPointMake(449.97, 634.78)];
    [path addCurveToPoint: CGPointMake(565.1, 639.6) controlPoint1: CGPointMake(487.14, 615.35) controlPoint2: CGPointMake(526.14, 627.41)];
    [path addCurveToPoint: CGPointMake(402.57, 323.86) controlPoint1: CGPointMake(414.79, 353.79) controlPoint2: CGPointMake(414.79, 353.79)];
    [path closePath];
    [path moveToPoint: CGPointMake(457.98, 718.1)];
    [path addCurveToPoint: CGPointMake(355.56, 719.99) controlPoint1: CGPointMake(423.88, 719.11) controlPoint2: CGPointMake(389.62, 719.79)];
    [path addCurveToPoint: CGPointMake(365.68, 756.17) controlPoint1: CGPointMake(358.59, 732.17) controlPoint2: CGPointMake(361.95, 744.24)];
    [path addCurveToPoint: CGPointMake(462.71, 754.78) controlPoint1: CGPointMake(397.95, 756.22) controlPoint2: CGPointMake(430.4, 755.7)];
    [path addCurveToPoint: CGPointMake(457.98, 718.1) controlPoint1: CGPointMake(460.98, 742.6) controlPoint2: CGPointMake(459.41, 730.37)];
    [path closePath];
    return path;
}

@interface UPLogoView ()
@property (nonatomic, readwrite) BOOL drawsBackground;
@property (nonatomic) UPGradientView *gradientBackgroundView;
@property (nonatomic) UPBezierPathView *borderBackgroundView;
@property (nonatomic) UPBezierPathView *borderView;
@property (nonatomic) UPGradientView *fillView;
@property (nonatomic) UPBezierPathView *fillClipView;
@property (nonatomic) UPBezierPathView *meatballView;
@property (nonatomic) UPBezierPathView *arrowView;
@end

@implementation UPLogoView

+ (UPLogoView *)logoView
{
    return [self logoViewWithDrawsBackground:NO];
}

+ (UPLogoView *)logoViewWithDrawsBackground:(BOOL)drawsBackground
{
    CGRect frame = CGRectMake(0, 0, up_size_width(UPVectorLogoCanonicalSize), up_size_height(UPVectorLogoCanonicalSize));
    return [[self alloc] initWithFrame:frame drawsBackground:drawsBackground];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame drawsBackground:NO];
}

- (instancetype)initWithFrame:(CGRect)frame drawsBackground:(BOOL)drawsBackground
{
    self = [super initWithFrame:frame];

    self.drawsBackground = drawsBackground;
    if (self.drawsBackground) {
        self.gradientBackgroundView = [UPGradientView gradientView];
        [self addSubview:self.gradientBackgroundView];
    }
    else {
        self.borderBackgroundView = [UPBezierPathView bezierPathView];
        self.borderBackgroundView.canonicalSize = UPVectorLogoCanonicalSize;
        self.borderBackgroundView.path = UPVectorLogoBorderBackgroundPath();
        self.borderBackgroundView.fillColor = UPVectorLogoBorderBackgroundColor();
        [self addSubview:self.borderBackgroundView];
    }

    self.borderView = [UPBezierPathView bezierPathView];
    self.borderView.canonicalSize = UPVectorLogoCanonicalSize;
    self.borderView.path = UPVectorLogoBorderPath();
    self.borderView.fillColor = UPVectorLogoBorderColor();
    [self addSubview:self.borderView];

    self.fillView = [UPGradientView gradientView];
    self.fillClipView = [UPBezierPathView bezierPathView];
    self.fillClipView.canonicalSize = UPVectorLogoCanonicalSize;
    self.fillClipView.path = UPVectorLogoFillClipPath();
    self.fillClipView.fillColor = [UIColor blackColor];
    self.fillView.layer.mask = self.fillClipView.shapeLayer;
    [self addSubview:self.fillView];

    self.meatballView = [UPBezierPathView bezierPathView];
    self.meatballView.canonicalSize = UPVectorLogoCanonicalSize;
    self.meatballView.path = UPVectorLogoMeatballPath();
    self.meatballView.fillColor = UPVectorLogoMeatballColor();
    [self addSubview:self.meatballView];
    
    self.arrowView = [UPBezierPathView bezierPathView];
    self.arrowView.canonicalSize = UPVectorLogoCanonicalSize;
    self.arrowView.path = UPVectorLogoArrowPath();
    self.arrowView.fillColor = UPVectorLogoArrowColor();
    [self addSubview:self.arrowView];
    
    [self updateThemeColors];
    
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;

    if (up_rect_width(bounds) == 0 || up_rect_height(bounds) == 0) {
        return;
    }
    
    if (self.drawsBackground) {
        self.gradientBackgroundView.frame = bounds;
        self.gradientBackgroundView.startPoint = CGPointZero;
        self.gradientBackgroundView.endPoint = CGPointMake(0, up_rect_height(bounds));
    }
    else {
        self.borderBackgroundView.frame = bounds;
    }
    self.borderView.frame = bounds;
    self.meatballView.frame = bounds;
    self.arrowView.frame = bounds;

    self.fillClipView.frame = bounds;
    self.fillView.frame = self.fillClipView.bounds;
    self.fillView.endPoint = CGPointZero;
    self.fillView.startPoint = CGPointMake(0, up_rect_height(self.fillView.bounds));
}

- (void)updateThemeColors
{
    int hue = up_closest_milepost_hue([UIColor themeColorHue]);
    if (self.drawsBackground) {
        self.gradientBackgroundView.colors = UPVectorLogoBackgroundColors(hue);
    }
    self.fillView.colors = UPVectorLogoFillColors(hue);
}

@end
