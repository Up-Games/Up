//
//  UPSpellNavigationController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPSpellNavigationController : UINavigationController <UIViewControllerTransitioningDelegate>

+ (UPSpellNavigationController *)instance;

- (void)presentExtrasController;
- (void)presentAboutController;

@end

@interface UPSpellExtrasPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellExtrasDismissAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellAboutPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellAboutDismissAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end
