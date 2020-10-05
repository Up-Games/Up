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
        [self teaser1];
    });
}

- (void)tap
{
    [self.pane botSpotTap];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tap];
    });
}

- (void)teaser1
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.pane.gameTimer start];
        [self.pane bloopInTilesFromString:@"NODGGBO"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pane botSpellWord:@"GOOD" completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.pane submitWordReplacingWithTilesFromString:@"GIOT"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.pane botSpellWord:@"GOING" completion:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.pane highlight2XLetterFive];
                            });
                        }];
                    });
                });
            }];
        });
    });
}

- (void)viewDidLayoutSubviews
{
    self.pane.frame = self.view.bounds;
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeNone;
}

@end
