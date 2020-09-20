//
//  UPSpellNavigationController.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPSpellGameRetry;

@interface UPSpellNavigationController : UINavigationController <UIViewControllerTransitioningDelegate>

+ (UPSpellNavigationController *)instance;

- (void)presentExtrasController;
- (void)presentAboutController;
- (void)dismissPresentedControllerImmediateIfNecessary;

- (void)dialogMenuPlayButtonTapped;
- (void)dialogMenuExtrasButtonTapped;
- (void)dialogMenuInviteButtonTapped;

@end

@interface UPSpellExtrasPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellExtrasDismissAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellAboutPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellAboutDismissAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end
