//
//  UPSceneDelegate.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"
#import "UPSpellLayoutManager.h"

@interface UPSceneDelegate ()
@end

@implementation UPSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    UILayoutGuide *safeAreaLayoutGuide = self.window.safeAreaLayoutGuide;
    NSLog(@"rect:  %@", NSStringFromCGRect(self.window.bounds));
    NSLog(@"safe:  %@", NSStringFromCGRect(safeAreaLayoutGuide.layoutFrame));
    
    UPSpellLayoutManager *layoutManager = [UPSpellLayoutManager instance];
    layoutManager.canvasFrame = safeAreaLayoutGuide.layoutFrame;

    NSLog(@"mode:  %ld", (long)layoutManager.aspectMode);
    NSLog(@"ratio: %.2f", layoutManager.aspectRatio);
}

- (void)sceneDidDisconnect:(UIScene *)scene
{
}

- (void)sceneDidBecomeActive:(UIScene *)scene
{
}

- (void)sceneWillResignActive:(UIScene *)scene
{
}

- (void)sceneWillEnterForeground:(UIScene *)scene
{
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
}

@end
