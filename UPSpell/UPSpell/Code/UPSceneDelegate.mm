//
//  UPSceneDelegate.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"
#import "UPChallenge.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameController.h"
#import "UPSpellNavigationController.h"

static UPSceneDelegate *_Instance;

@interface UPSceneDelegate ()
@end

@implementation UPSceneDelegate

+ (UPSceneDelegate *)instance
{
    return _Instance;
}

@dynamic canvasFrame;
- (CGRect)canvasFrame
{
    return self.window.safeAreaLayoutGuide.layoutFrame;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    _Instance = self;
    self.challenge = nil;
    for (NSUserActivity *userActivity in connectionOptions.userActivities) {
        if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
            [[UPSpellNavigationController instance] dismissPresentedControllerImmediateIfNecessary];
            NSURL *incomingURL = userActivity.webpageURL;
            UPChallenge *challenge = [UPChallenge challengeWithURL:incomingURL];
            if (challenge.valid) {
                self.challenge = challenge;
            }
        }
    }
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
    UPSpellExtrasController *extrasController = [UPSpellExtrasController instance];
    if (extrasController.presentedViewController) {
        [extrasController dismissViewControllerAnimated:NO completion:nil];
    }

    UPSpellGameController *gameController = [UPSpellGameController instance];
    if ([gameController.presentedViewController isKindOfClass:[UIActivityViewController class]]) {
        [gameController dismissViewControllerAnimated:NO completion:^{
            [gameController shareSheetDismissed];
        }];
    }
}

- (void)scene:(UIScene *)scene willContinueUserActivityWithType:(NSString *)userActivityType
{
    if ([userActivityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        [[UPSpellNavigationController instance] dismissPresentedControllerImmediateIfNecessary];
    }
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity
{
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return;
    }
    
    NSURL *incomingURL = userActivity.webpageURL;
    UPChallenge *challenge = [UPChallenge challengeWithURL:incomingURL];
    if (challenge.valid) {
        [[UPSpellGameController instance] setChallenge:challenge];
    }
}

@end
