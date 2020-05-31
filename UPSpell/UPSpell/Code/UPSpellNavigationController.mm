//
//  UPSpellNavigationController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPSpellNavigationController.h"
#import "UPSpellGameController.h"

@interface UPSpellNavigationController () <UINavigationControllerDelegate>

@end

@implementation UPSpellNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    self.delegate = self;
    
    NSArray<UIViewController *> *viewControllers = @[
        [[UPSpellGameController alloc] initWithNibName:nil bundle:nil]
    ];
    [self setViewControllers:viewControllers animated:NO];
}

@end
