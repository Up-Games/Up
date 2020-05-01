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

    static BOOL flag;
    
    if (flag) {
        [self.v1 bloopToFrame:CGRectMake(50, 50, 144, 180)];
    }
    else {
        CGPoint point = [tap locationInView:self.view];
        [self.v1 bloopToPosition:point size:CGSizeMake(72, 90)];
    
    }
    flag = !flag;
}

@end
