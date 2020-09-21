//
//  UPSpellGameController.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPGameKey.h>

#import "UPMode.h"

@class UPSpellGameRetry;
@class UPGameLink;

@interface UPSpellGameController : UIViewController

+ (UPSpellGameController *)instance;

@property (nonatomic) UP::Mode mode;
@property (nonatomic) UPSpellGameRetry *retry;

- (void)setMode:(UP::Mode)mode transitionScenario:(UPModeTransitionScenario)transitionScenario;
- (void)setGameLink:(UPGameLink *)share;
- (void)shareSheetDismissed;

@end
