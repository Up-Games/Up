//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) UPShapeView *v1;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    CGRect referenceFrame = CGRectInset(screenBounds, 36, 100);
    
    self.v1 = [[UPShapeView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.v1.shapeFillColor = [UIColor orangeColor];
//    self.v1.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:referenceFrame hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
    [self.view addSubview:self.v1];

    UIBezierPath *shape1 = [UIBezierPath bezierPath];
    [shape1 moveToPoint:CGPointMake(0, 200)];
    [shape1 addLineToPoint:CGPointMake(100, 200)];
    [shape1 addLineToPoint:CGPointMake(50, 300)];
    [shape1 closePath];
    [shape1 moveToPoint:CGPointMake(0, 300)];
    [shape1 addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(50, 400)];
    [shape1 closePath];
    [shape1 moveToPoint:CGPointMake(100, 200)];
    [shape1 addCurveToPoint:CGPointMake(200, 200) controlPoint1:CGPointMake(125, 300) controlPoint2:CGPointMake(175, 100)];
    [shape1 closePath];
    self.v1.shape = shape1;

    UIBezierPath *shape2 = [UIBezierPath bezierPath];
    [shape2 moveToPoint:CGPointMake(0, 200)];
    [shape2 addLineToPoint:CGPointMake(100, 200)];
    [shape2 addLineToPoint:CGPointMake(50, 50)];
    [shape2 closePath];
    [shape2 moveToPoint:CGPointMake(0, 300)];
    [shape2 addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(50, 400)];
    [shape2 closePath];
    [shape2 moveToPoint:CGPointMake(100, 200)];
    [shape2 addCurveToPoint:CGPointMake(200, 200) controlPoint1:CGPointMake(125, 300) controlPoint2:CGPointMake(175, 100)];
    [shape2 closePath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        POPCustomAnimation *anim = [POPCustomAnimation animationWithBlock:^BOOL(id target, POPCustomAnimation *animation) {
            NSLog(@"fraction: %.2f : %@", animation.elapsedTime, target);
            if (animation.elapsedTime > 3) {
                return NO;
            }
            return YES;
        }];
        anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            NSLog(@"done: %@", finished ? @"Y" : @"N");
        };
        [self.v1 pop_addAnimation:anim forKey:@"custom"];
    });


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

    for (int cornerIndex = 0; cornerIndex < 4; cornerIndex++) {
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
