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

    self.v1 = [[UPShapeView alloc] initWithFrame:CGRectMake(157.5, 100, 72, 90)];
//    self.v1.shapeFillColor = [UIColor orangeColor];
    self.v1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.v1];
    self.v1.clipsToBounds = NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)_handleTap:(UITapGestureRecognizer *)tap
{
    if (tap.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    CGPoint point = [tap locationInView:self.view];
    [self.v1 bloopWithDuration:0.4 toPosition:point size:CGSizeMake(72, 90)];
}

@end
