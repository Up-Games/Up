//
//  UPSceneDelegate.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"

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
