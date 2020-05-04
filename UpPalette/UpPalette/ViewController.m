//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) UIView *chip1;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chip1 = [UIView viewWithBoundsSize:CGSizeMake(200, 200)];
    [self.view addSubview:self.chip1];

    [self colorize];

}

- (void)colorize
{
    static CGFloat hue = 0;
    hue++;
    if (hue >= 360) {
        hue = 0;
    }

    CGFloat saturation = 0.65;
    CGFloat lightness = 0;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"hue: %.0f", hue);
        self.chip1.backgroundColor = [UIColor colorizedColorWithGrayValue:0.35 hue:hue saturation:saturation lightness:lightness];
//        self.chip1.backgroundColor = colorizedGrayValue(0.5, hue, saturation, lightness);
        [self colorize];
    });
}

- (void)viewDidLayoutSubviews
{
    CGRect layoutRect1 = CGRectInset(self.view.bounds, 40, 40);
    self.chip1.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutRect1 hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalMiddle];
    [self.chip1 layoutWithRule];
}

@end

