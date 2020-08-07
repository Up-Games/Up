//
//  UPSceneDelegate.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"
#import "UPTaunt.h"
#import "UPSpellGameController.h"

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

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    [self parseSharedGameRequestFromURLContexts:URLContexts];
}

- (void)parseSharedGameRequestFromURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    if (URLContexts.count != 1) {
        return;
    }
    
    UIOpenURLContext *ctx = [URLContexts anyObject];
    UPTaunt *taunt = [UPTaunt tauntWithURL:ctx.URL];
    [[UPSpellGameController instance] setTaunt:taunt];
}

@end
