//
//  UPBezierPathView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPNeedsUpdater.h>

@interface UPBezierPathView : UIView <UPNeedsUpdatable>
@property (nonatomic) UIBezierPath *path;
@property (nonatomic) CGSize canonicalSize; // size used for scaling
@property (nonatomic, readonly) CGAffineTransform pathTransform;
@property (nonatomic, readonly) UIBezierPath *transformedPath;
@property (nonatomic, readonly) CAShapeLayer *shapeLayer;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CAShapeLayerFillRule fillRule;

+ (UPBezierPathView *)bezierPathView;
+ (UPBezierPathView *)bezierPathViewWithFrame:(CGRect)frame;

@end
