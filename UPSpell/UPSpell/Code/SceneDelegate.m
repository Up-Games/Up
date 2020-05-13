//
//  SceneDelegate.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPSceneDelegate.h"

@interface UPSceneDelegate ()
@end

@implementation UPSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    UILayoutGuide *safeAreaLayoutGuide = self.window.safeAreaLayoutGuide;
    NSLog(@"rect [w1]: %@", NSStringFromCGRect(self.window.bounds));
    NSLog(@"safe [w1]: %@", NSStringFromCGRect(safeAreaLayoutGuide.layoutFrame));
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
