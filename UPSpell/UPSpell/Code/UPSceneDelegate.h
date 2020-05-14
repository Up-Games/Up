//
//  UPSceneDelegate.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPSceneDelegate : UIResponder <UIWindowSceneDelegate>

+ (UPSceneDelegate *)instance;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) CGRect canvasFrame;

@end

