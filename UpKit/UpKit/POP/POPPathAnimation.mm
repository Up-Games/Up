//
//  POPPathAnimation.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <vector>

#import "POPPathAnimation.h"
#import "UPGeometry.h"
#import "UPTypes.h"

struct _POPCGPathElement {
    _POPCGPathElement() {}
    _POPCGPathElement(const CGPathElement *element) {
        switch (element->type) {
            case kCGPathElementMoveToPoint:
            case kCGPathElementAddLineToPoint:
                point0 = element->points[0];
                break;
            case kCGPathElementAddQuadCurveToPoint:
                point0 = element->points[0];
                point1 = element->points[1];
                break;
            case kCGPathElementAddCurveToPoint:
                point0 = element->points[0];
                point1 = element->points[1];
                point2 = element->points[2];
                break;
            case kCGPathElementCloseSubpath:
                // no-op
                break;
        }
    }

    CGPathElementType type = kCGPathElementMoveToPoint;
    CGPoint point0 = CGPointZero;
    CGPoint point1 = CGPointZero;
    CGPoint point2 = CGPointZero;
};

@interface POPPathAnimation ()
{
    std::vector<_POPCGPathElement> _fromPathElements;
    std::vector<_POPCGPathElement> _toPathElements;
}
@property (nonatomic, readwrite) UIBezierPath *interpolatedPath;
@end

@implementation POPPathAnimation

+ (instancetype)animation
{
    return [[self alloc] _init];
}

- (id)_init
{
    self = [super initWithBlock:^BOOL(id target, POPCustomAnimation *animation) {
        BOOL result = [self advanceWithTarget:target];
        if ([target respondsToSelector:@selector(pathAnimationUpdated:)]) {
            [target pathAnimationUpdated:self];
        }
        return result;
    }];
    self.duration = 0.4;
    return self;
}

- (void)setFromPath:(UIBezierPath *)fromPath
{
    _fromPath = fromPath;
    _fromPathElements.clear();
    CGPathApplyWithBlock(_fromPath.CGPath, ^(const CGPathElement *element) {
        self->_fromPathElements.push_back(element);
    });
}

- (void)setToPath:(UIBezierPath *)toPath
{
    _toPath = toPath;
    _toPathElements.clear();
    CGPathApplyWithBlock(_toPath.CGPath, ^(const CGPathElement *element) {
        self->_toPathElements.push_back(element);
    });
}

- (BOOL)advanceWithTarget:(id)target
{
    if (!self.interpolatedPath) {
        self.interpolatedPath = [UIBezierPath bezierPath];
        if (!self.fromPath || !self.toPath) {
            return NO;
        }
    }

    if (self.elapsedTime > self.duration) {
        return NO;
    }

    UPUnit fraction = self.elapsedTime / self.duration;

    [self computeInterpolatedPathWithFraction:fraction];

    return YES;
}

- (void)computeInterpolatedPathWithFraction:(UPUnit)fraction
{
    __block size_t idx = 0;
    
    [self.interpolatedPath removeAllPoints];
    
    CGPathApplyWithBlock(self.fromPath.CGPath, ^(const CGPathElement *element) {
        switch (element->type) {
            case kCGPathElementMoveToPoint: {
                CGPoint point0 = up_lerp_points(self->_fromPathElements[idx].point0, self->_toPathElements[idx].point0, fraction);
                [self.interpolatedPath moveToPoint:point0];
                break;
            }
            case kCGPathElementAddLineToPoint: {
                CGPoint point0 = up_lerp_points(self->_fromPathElements[idx].point0, self->_toPathElements[idx].point0, fraction);
                [self.interpolatedPath addLineToPoint:point0];
                break;
            }
            case kCGPathElementAddQuadCurveToPoint: {
                CGPoint point0 = up_lerp_points(self->_fromPathElements[idx].point0, self->_toPathElements[idx].point0, fraction);
                CGPoint point1 = up_lerp_points(self->_fromPathElements[idx].point1, self->_toPathElements[idx].point1, fraction);
                [self.interpolatedPath addQuadCurveToPoint:point1 controlPoint:point0];
                break;
            }
            case kCGPathElementAddCurveToPoint: {
                CGPoint point0 = up_lerp_points(self->_fromPathElements[idx].point0, self->_toPathElements[idx].point0, fraction);
                CGPoint point1 = up_lerp_points(self->_fromPathElements[idx].point1, self->_toPathElements[idx].point1, fraction);
                CGPoint point2 = up_lerp_points(self->_fromPathElements[idx].point2, self->_toPathElements[idx].point2, fraction);
                [self.interpolatedPath addCurveToPoint:point2 controlPoint1:point0 controlPoint2:point1];
                break;
            }
            case kCGPathElementCloseSubpath:
                [self.interpolatedPath closePath];
                break;
        }
        idx++;
    });
}

@end
