//
//  UPHowToViewController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPHowToViewController.h"

#import "UPSpellExtrasPaneHowTo.h"

@interface UPHowToViewController ()
@property (nonatomic) UPSpellExtrasPaneHowTo *pane;
@end

@implementation UPHowToViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pane = [[UPSpellExtrasPaneHowTo alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pane];
    [self.pane configureForFullScreenTutorial];
}

- (void)viewDidLayoutSubviews
{
    self.pane.frame = self.view.bounds;
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeAll;
}

@end
