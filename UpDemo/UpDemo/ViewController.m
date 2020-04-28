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
    UPViewState *state1 = [self.v1 currentState];
    UPViewState *state2 = [[UPViewState alloc] init];
    
    CGFloat w = arc4random_uniform(200) + 100;
    CGFloat h = arc4random_uniform(200) + 100;
    CGFloat x = arc4random_uniform(375 - w);
    CGFloat y = arc4random_uniform(812 - h);

    state2.frame = CGRectMake(x, y, w, h);
    UPAnimator *animator = [UPAnimator animatorWithDuration:0.5 unitFunctionType:UPUnitFunctionTypeEaseOutBack
                                                    applier:^(UPAnimator *animator, UPUnit fraction) {
        [self.v1 applyInterpolatedWithStartState:state1 endState:state2 fraction:fraction];

    } completion:^(UPAnimator *animator, BOOL completed) {

    }];
    [animator start];
}

@end
