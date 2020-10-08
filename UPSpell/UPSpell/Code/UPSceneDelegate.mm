//
//  UPSceneDelegate.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"
#import "UPGameLink.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameController.h"
#import "UPSpellNavigationController.h"
#import "UPSpellExtrasPaneShare.h"

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
    self.gameLink = nil;
    for (NSUserActivity *userActivity in connectionOptions.userActivities) {
        if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
            [[UPSpellNavigationController instance] dismissPresentedControllerImmediateIfNecessary];
            NSURL *incomingURL = userActivity.webpageURL;
            self.gameLink = [UPGameLink gameLinkWithURL:incomingURL];
            if (self.gameLink) {
                break;
            }
        }
    }
    if (self.gameLink == nil) {
        for (UIOpenURLContext *ctx in connectionOptions.URLContexts) {
            self.gameLink = [UPGameLink gameLinkWithURL:ctx.URL];
            if (self.gameLink) {
                [[UPSpellGameController instance] setGameLink:self.gameLink];
                break;
            }
        }
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    [[UPSpellNavigationController instance] dismissPresentedControllerImmediateIfNecessary];
    for (UIOpenURLContext *ctx in URLContexts) {
        self.gameLink = [UPGameLink gameLinkWithURL:ctx.URL];
        if (self.gameLink) {
            [[UPSpellGameController instance] setGameLink:self.gameLink];
            break;
        }
    }
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
}

- (void)scene:(UIScene *)scene willContinueUserActivityWithType:(NSString *)userActivityType
{
    if ([userActivityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        [[UPSpellNavigationController instance] dismissPresentedControllerImmediateIfNecessary];
    }
}

- (void)_setGameLinkWithURL:(NSURL *)gameLinkURL
{
    UPGameLink *gameLink = [UPGameLink gameLinkWithURL:gameLinkURL];
    [[UPSpellGameController instance] setGameLink:gameLink];
}

- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity
{
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return;
    }
    
    UPSpellExtrasController *extrasController = [UPSpellExtrasController instance];
    UPSpellGameController *gameController = [UPSpellGameController instance];
    if (extrasController.presentedViewController) {
        [extrasController dismissViewControllerAnimated:NO completion:^{
            if ([extrasController.selectedPane isKindOfClass:[UPSpellExtrasPaneShare class]]) {
                UPSpellExtrasPaneShare *pane = (UPSpellExtrasPaneShare *)extrasController.selectedPane;
                [pane shareSheetDismissed];
            }
            [self _setGameLinkWithURL:userActivity.webpageURL];
        }];
    }
    else if ([gameController.presentedViewController isKindOfClass:[UIActivityViewController class]]) {
        [gameController dismissViewControllerAnimated:NO completion:^{
            [gameController shareSheetDismissed];
            [self _setGameLinkWithURL:userActivity.webpageURL];
        }];
    }
    else {
        [self _setGameLinkWithURL:userActivity.webpageURL];
    }
}

@end
