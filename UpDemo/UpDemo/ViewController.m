//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) UIView *v1;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    CGRect referenceFrame = CGRectInset(screenBounds, 36, 100);
    
    self.v1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//    self.v1.layer.cornerRadius
    self.v1.backgroundColor = [UIColor orangeColor];
//    self.v1.shapeFillColor = [UIColor orangeColor];
//    self.v1.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:referenceFrame hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
    [self.view addSubview:self.v1];

//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, 0, 0);
//    CGPathAddLineToPoint(path, NULL, 0, 100);
//    CGPathAddLineToPoint(path, NULL, 100, 100);
//    CGPathAddLineToPoint(path, NULL, 100, 0);
//    CGPathCloseSubpath(path);
//
//    UIBezierPath *shape = [UIBezierPath bezierPathWithCGPath:path];
//    self.v1.shape = shape;
//
//    CGMutablePathRef path2 = CGPathCreateMutable();
//    CGPathMoveToPoint(path2, NULL, 0, 0);
//    CGPathAddLineToPoint(path2, NULL, 0, 200);
//    CGPathAddLineToPoint(path2, NULL, 200, 200);
//    CGPathAddLineToPoint(path2, NULL, 200, 0);
//    CGPathCloseSubpath(path2);
//    UIBezierPath *shape2 = [UIBezierPath bezierPathWithCGPath:path2];
//
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewDidLayoutSubviews
{
//    [self.v1 layoutWithRule];
}

- (void)_handleTap:(UITapGestureRecognizer *)tap
{
//    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
//    anim.duration = 2;
//    [self.v1 pop_addAnimation:anim forKey:@"alpha"];

    CGFloat w = arc4random_uniform(200) + 100;
    CGFloat h = arc4random_uniform(200) + 100;
    CGFloat x = arc4random_uniform(375 - w);
    CGFloat y = arc4random_uniform(812 - h);

//    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
//    anim.velocity = @(1000.0);
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
//    anim.duration = 0.5;
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anim.fromValue = [NSValue valueWithCGRect:self.v1.frame];
//    anim.toValue = [NSValue valueWithCGRect:CGRectMake(x, y, w, h)];
//    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//        NSLog(@"done: %@", finished ? @"Y" : @"N");
//    };
//    [self.v1 pop_addAnimation:anim forKey:@"frame"];

    [self animateView:self.v1 toFrame:CGRectMake(x, y, w, h) withTuning:^(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient) {
        anim.dynamicsMass       = 100;
        anim.dynamicsFriction   = 37;
        anim.dynamicsTension    = 2;
        anim.springBounciness   = AGKInterpolate(5, 12, dragCoefficient);
        anim.springSpeed        = AGKInterpolate(4, 7, dragCoefficient);
    }];

//    UPViewState *state1 = [self.v1 currentState];
//    UPViewState *state2 = [[UPViewState alloc] init];
//    
//    CGFloat w = arc4random_uniform(200) + 100;
//    CGFloat h = arc4random_uniform(200) + 100;
//    CGFloat x = arc4random_uniform(375 - w);
//    CGFloat y = arc4random_uniform(812 - h);
//
//    state2.frame = CGRectMake(x, y, w, h);
//    UPAnimator *animator = [UPAnimator animatorWithDuration:0.5 unitFunctionType:UPUnitFunctionTypeEaseOutBack
//                                                    applier:^(UPAnimator *animator, UPUnit fraction) {
//        [self.v1 applyInterpolatedWithStartState:state1 endState:state2 fraction:fraction];
//
//    } completion:^(UPAnimator *animator, BOOL completed) {
//
//    }];
//    [animator start];
}

- (CGFloat)longestDistanceOfPointsInQuad:(AGKQuad)quad toPoint:(CGPoint)point
{
    CGFloat longest = 0.0;
    for(int cornerIndex = 0; cornerIndex < 4; cornerIndex++) {
        CGPoint currentCornerPoint = AGKQuadGetPointForCorner(quad, AGKQuadCornerForCornerIndex(cornerIndex));
        CGFloat distance = fabs(CGPointLengthBetween_AGK(point, currentCornerPoint));
        if (distance > longest) {
            longest = distance;
        }
    }
    return longest;
}

- (void)animateView:(UIView *)view toFrame:(CGRect)frame withTuning:(void(^)(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient))tuning
{
    [view.layer ensureAnchorPointIsSetToZero];

    CGPoint currentCenter = up_rect_center(view.frame);
    AGKQuad desiredQuad = AGKQuadMakeWithCGRect(frame);
    AGKQuad innerQuad = [view.layer.superlayer convertAGKQuad:desiredQuad toLayer:self.view.layer];
    NSArray *cornersForProperties = @[kPOPLayerAGKQuadTopLeft, kPOPLayerAGKQuadTopRight, kPOPLayerAGKQuadBottomRight, kPOPLayerAGKQuadBottomLeft];
    CGFloat longestDistanceFromCenter = [self longestDistanceOfPointsInQuad:innerQuad toPoint:currentCenter];

    for(int cornerIndex = 0; cornerIndex < 4; cornerIndex++) {
        NSString *propertyName = cornersForProperties[cornerIndex];

        POPSpringAnimation *anim = [view.layer pop_animationForKey:propertyName];
        if (anim == nil) {
            anim = [POPSpringAnimation animation];
            anim.property = [POPAnimatableProperty AGKPropertyWithName:propertyName];
            [view.layer pop_addAnimation:anim forKey:propertyName];
        }

        CGPoint currentCornerPoint = AGKQuadGetPointForCorner(innerQuad, AGKQuadCornerForCornerIndex(cornerIndex));
        CGFloat distance = fabs(CGPointLengthBetween_AGK(currentCenter, currentCornerPoint));
        CGFloat dragCoefficient = AGKRemapToZeroOne(distance, longestDistanceFromCenter, 0);

        anim.toValue = [NSValue valueWithCGPoint:AGKQuadGetPointForCorner(desiredQuad, AGKQuadCornerForCornerIndex(cornerIndex))];
        tuning(anim, cornerIndex, dragCoefficient);
    }
}

@end
