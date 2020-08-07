//
//  UPSceneDelegate.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPSharedGameRequest;

@interface UPSceneDelegate : UIResponder <UIWindowSceneDelegate>

+ (UPSceneDelegate *)instance;

@property (nonatomic, readonly) CGRect canvasFrame;

@property (nonatomic) UIWindow *window;
@property (nonatomic) UPSharedGameRequest *sharedGameRequest;

@end

