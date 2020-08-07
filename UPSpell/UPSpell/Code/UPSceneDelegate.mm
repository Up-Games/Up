//
//  UPSceneDelegate.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"
#import "UPSharedGameRequest.h"
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
    NSLog(@"willConnectToSession: %@", connectionOptions);
    [self parseSharedGameRequestFromURLContexts:connectionOptions.URLContexts];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    NSLog(@"openURLContexts: %@", URLContexts);
    [self parseSharedGameRequestFromURLContexts:URLContexts];
}

- (void)parseSharedGameRequestFromURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts
{
    if (URLContexts.count == 0) {
        return;
    }
    
    for (UIOpenURLContext *ctx in URLContexts) {
        UPSharedGameRequest *req = [UPSharedGameRequest sharedGameRequestWithURL:ctx.URL];
        if (req.valid) {
            self.sharedGameRequest = req;
            [[UPSpellGameController instance] checkForSharedGameRequest];
            NSLog(@"*** sharedGameRequest: %@", self.sharedGameRequest);
            break;
        }
    }
    
    
}

@end
