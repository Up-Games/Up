//
//  UPSceneDelegate.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPChallenge;

@interface UPSceneDelegate : UIResponder <UIWindowSceneDelegate>

+ (UPSceneDelegate *)instance;

@property (nonatomic, readonly) CGRect canvasFrame;

@property (nonatomic) UIWindow *window;
@property (nonatomic) UPChallenge *challenge;

@end

