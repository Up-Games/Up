//
//  UPActivityViewController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPContainerView.h>
#import <UpKit/UPLayoutRule.h>

#import "UPActivityViewController.h"

@interface UPActivityViewController ()
@property (nonatomic) UPContainerView *previewContainerView;
@property (nonatomic) NSArray *activityItems;
@end

@implementation UPActivityViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems
{
    return [self initWithActivityItems:activityItems applicationActivities:nil];
}

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities
{
    self = [super initWithActivityItems:activityItems applicationActivities:applicationActivities];
    self.activityItems = activityItems;
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    self.previewContainerView = [[UPContainerView alloc] initWithFrame:CGRectZero];
//    self.previewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.previewContainerView];
//
//    self.previewContainerView.backgroundColor = [UIColor testColor1];
//}
//
//- (void)viewDidLayoutSubviews
//{
//    CGRect bounds = self.view.bounds;
//
////    UPLayoutRule *rule = [UPLayoutRule layoutRuleWithReferenceFrame:bounds hLayout:<#(UPLayoutHorizontal)#> vLayout:<#(UPLayoutVertical)#>];
//
//    self.previewContainerView.frame = bounds;
//}

@end
