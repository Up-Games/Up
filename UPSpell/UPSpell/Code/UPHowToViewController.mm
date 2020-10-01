//
//  UPHowToViewController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPGameTimer.h>

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
    [self.pane configureForFullScreen];
    [self.pane configureForBot];
    [self.pane centerBotSpotWithDuration:0.0];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pane.gameTimer start];
        [self.pane bloopInTilesFromString:@"KIEDCLP"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pane.gameTimer start];
            [self.pane botSpellWord:@"PICKLED"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.pane submitWordReplacingWithTilesFromString:@""];
            });
        });
    });
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
