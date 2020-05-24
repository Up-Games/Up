//
//  UPBezierPathView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPBezierPathView.h"
#import "UPMath.h"

#define ShapeLayer() ((CAShapeLayer *)self.layer)

@interface UPBezierPathView ()
@property (nonatomic, readwrite) CGAffineTransform pathTransform;
@property (nonatomic) UIBezierPath *effectivePath;
@property (nonatomic) BOOL needsPathUpdate;
@end

@implementation UPBezierPathView

static NSMutableSet *_PathsNeedingUpdateSet;

+ (void)initialize
{
    // support for calling -setNeedsPathUpdate.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _PathsNeedingUpdateSet = [NSMutableSet set];
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeWaiting, YES, 0,
            ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                if (_PathsNeedingUpdateSet.count) {
                    NSSet *set = [_PathsNeedingUpdateSet copy];
                    [_PathsNeedingUpdateSet removeAllObjects];
                    for (UPBezierPathView *view in set) {
                        [view updatePath];
                    }
                }
            }
        );
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    });
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

+ (UPBezierPathView *)bezierPathView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

+ (UPBezierPathView *)bezierPathViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.pathTransform = CGAffineTransformIdentity;
    return self;
}

- (void)setPath:(UIBezierPath *)path
{
    _path = path;
    [self setNeedsPathUpdate];
}

- (void)setCanonicalSize:(CGSize)canonicalSize
{
    _canonicalSize = canonicalSize;
    [self setNeedsPathUpdate];
}

@dynamic fillColor;
- (void)setFillColor:(UIColor *)fillColor
{
    ShapeLayer().fillColor = fillColor ? fillColor.CGColor : nil;
}

- (UIColor *)fillColor
{
    return ShapeLayer().fillColor ? [UIColor colorWithCGColor:ShapeLayer().fillColor] : nil;
}

@dynamic strokeColor;
- (void)setStrokeColor:(UIColor *)strokeColor
{
    ShapeLayer().strokeColor = strokeColor ? strokeColor.CGColor : nil;
}

- (UIColor *)strokeColor
{
    return ShapeLayer().strokeColor ? [UIColor colorWithCGColor:ShapeLayer().strokeColor] : nil;
}

@dynamic lineWidth;
- (void)setLineWidth:(CGFloat)lineWidth
{
    ShapeLayer().lineWidth = lineWidth;
}

- (CGFloat)lineWidth
{
    return ShapeLayer().lineWidth;
}

@dynamic fillRule;
- (void)setFillRule:(CAShapeLayerFillRule)fillRule
{
    ShapeLayer().fillRule = fillRule;
}

- (CAShapeLayerFillRule)fillRule
{
    return ShapeLayer().fillRule;
}

@dynamic transformedPath;
- (UIBezierPath *)transformedPath
{
    return [self.effectivePath copy];
}

#pragma mark - Geometry and Layout

- (void)setNeedsPathUpdate
{
    [_PathsNeedingUpdateSet addObject:self];
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    self.needsPathUpdate = YES;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.path ? self.path.bounds.size : CGSizeZero;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsPathUpdate];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setNeedsPathUpdate];
}

- (void)updatePath
{
    if (!self.path) {
        self.effectivePath = nil;
        ShapeLayer().path = nil;
        return;
    }

    // This code could conceivably switch on -contentMode, and if I were writing
    // a framework, I would do so. However, since I'm writing an app, and all I
    // care about is scaling the path to fill a view's whose aspect ratio will
    // never change, that's all this code does.
    CGRect bounds = self.bounds;
    CGFloat pathWidth = self.canonicalSize.width;
    CGFloat pathHeight = self.canonicalSize.height;
    if (up_is_fuzzy_equal(CGRectGetWidth(bounds), pathWidth) && up_is_fuzzy_equal(CGRectGetHeight(bounds), pathHeight)) {
        self.pathTransform = CGAffineTransformIdentity;
        self.effectivePath = self.path;
    }
    else {
        CGFloat sx = pathWidth > 0 ? (CGRectGetWidth(bounds) / pathWidth) : 0;
        CGFloat sy = pathHeight > 0 ? (CGRectGetHeight(bounds) / pathHeight) : 0;
        self.pathTransform = CGAffineTransformMakeScale(sx, sy);
        self.effectivePath = [self.path copy];
        [self.effectivePath applyTransform:self.pathTransform];
    }

    ShapeLayer().path = self.effectivePath.CGPath;
}

@end
