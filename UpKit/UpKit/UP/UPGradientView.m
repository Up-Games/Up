//
//  UPGradientView.m
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPGradientView.h"

#define GradientLayer() ((CAGradientLayer *)self.layer)

@interface UPGradientView ()
@end

@implementation UPGradientView

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

+ (UPGradientView *)gradientView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

+ (UPGradientView *)gradientViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.type = UPGradientTypeLinear;
    return self;
}

@dynamic gradientLayer;
- (CAGradientLayer *)gradientLayer
{
    return GradientLayer();
}

@dynamic colors;
- (void)setColors:(NSArray<UIColor *> *)colors
{
    NSMutableArray *layerColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        CGColorRef layerColor = color.CGColor;
        [layerColors addObject:(__bridge id _Nonnull)(layerColor)];
    }
    GradientLayer().colors = layerColors;
}

- (NSArray <UIColor *> *)colors
{
    NSMutableArray *viewColors = [NSMutableArray array];
    NSArray *layerColors = GradientLayer().colors;
    for (NSUInteger idx = 0; idx < layerColors.count; idx++) {
        CGColorRef color = (__bridge CGColorRef)(layerColors[idx]);
        [viewColors addObject:[UIColor colorWithCGColor:color]];
    }
    return viewColors;
}

@dynamic locations;
- (void)setLocations:(NSArray<NSNumber *> *)locations
{
    GradientLayer().locations = locations;
}

- (NSArray<NSNumber *> *)locations
{
    return GradientLayer().locations;
}

@dynamic startPoint;
- (void)setStartPoint:(CGPoint)startPoint
{
    GradientLayer().startPoint = startPoint;
}

- (CGPoint)startPoint
{
    return GradientLayer().startPoint;
}

@dynamic endPoint;
- (void)setEndPoint:(CGPoint)endPoint
{
    GradientLayer().endPoint = endPoint;
}

- (CGPoint)endPoint
{
    return GradientLayer().endPoint;
}

@dynamic type;
- (void)setType:(UPGradientType)type
{
    switch (type) {
        case UPGradientTypeDefault:
        case UPGradientTypeLinear:
            GradientLayer().type = kCAGradientLayerAxial;
            break;
        case UPGradientTypeRadial:
            GradientLayer().type = kCAGradientLayerRadial;
            break;
        case UPGradientTypeConic:
            GradientLayer().type = kCAGradientLayerConic;
            break;
    }
}

- (UPGradientType)type
{
    NSString *layerType = GradientLayer().type;
    if ([layerType isEqualToString:kCAGradientLayerAxial]) {
        return UPGradientTypeLinear;
    }
    else if ([layerType isEqualToString:kCAGradientLayerRadial]) {
        return UPGradientTypeRadial;
    }
    else if ([layerType isEqualToString:kCAGradientLayerConic]) {
        return UPGradientTypeConic;
    }
    return UPGradientTypeLinear;
}

@end
