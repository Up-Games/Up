//
//  UPSpellNavigationController.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPSpellGameRetry;

@interface UPSpellNavigationController : UINavigationController <UIViewControllerTransitioningDelegate>

+ (UPSpellNavigationController *)instance;

- (void)presentExtrasController;
- (void)dismissPresentedControllerImmediateIfNecessary;

- (void)dialogMenuPlayButtonTapped;
- (void)dialogMenuExtrasButtonTapped;

@end

@interface UPSpellExtrasPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellExtrasDismissAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end
