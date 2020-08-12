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
    [self parseSharedGameRequestFromURLContexts:connectionOptions.URLContexts];
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
    UPSpellExtrasController *extrasController = [UPSpellExtrasController instance];
    if (extrasController.presentedViewController) {
        [extrasController dismissViewControllerAnimated:NO completion:nil];
    }

    UPSpellGameController *gameController = [UPSpellGameController instance];
    if ([gameController.presentedViewController isKindOfClass:[UIActivityViewController class]]) {
        [gameController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    [self parseSharedGameRequestFromURLContexts:URLContexts];
}

- (void)scene:(UIScene *)scene willContinueUserActivityWithType:(NSString *)userActivityType
{
    LOG(General, "willContinueUserActivityWithType: %@", userActivityType);
    if ([userActivityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        [[UPSpellNavigationController instance] dismissPresentedControllerImmediateIfNecessary];
    }
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity
{
    LOG(General, "continueUserActivity: %@", userActivity);
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return;
    }
    
    NSURL *incomingURL = userActivity.webpageURL;
    UPChallenge *share = [UPChallenge challengeWithURL:incomingURL];
    [[UPSpellGameController instance] setChallenge:share];
}

- (void)parseSharedGameRequestFromURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    if (URLContexts.count != 1) {
        return;
    }
    
    UIOpenURLContext *ctx = [URLContexts anyObject];
    UPChallenge *share = [UPChallenge challengeWithURL:ctx.URL];
    [[UPSpellGameController instance] setChallenge:share];
}

@end
