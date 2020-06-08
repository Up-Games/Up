//
//  UPSpellNavigationController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPSpellNavigationController : UINavigationController <UIViewControllerTransitioningDelegate>

+ (UPSpellNavigationController *)instance;

- (void)presentExtrasController;
- (void)dismissExtrasController;

- (void)presentAboutController;
- (void)dismissAboutController;

@end

@interface UPSpellExtrasPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end

@interface UPSpellAboutPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@end
