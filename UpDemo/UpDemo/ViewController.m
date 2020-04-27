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

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect referenceFrame = CGRectInset(screenBounds, 36, 36);
    
    self.v1 = [UIView viewWithBoundsSize:CGSizeMake(100, 100)];
    self.v1.backgroundColor = [UIColor orangeColor];
    self.v1.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:referenceFrame hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalBottom];
    [self.view addSubview:self.v1];
}

- (void)viewDidLayoutSubviews
{
    [self.v1 layoutWithRule];
}

@end
