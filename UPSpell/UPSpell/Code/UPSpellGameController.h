//
//  UPSpellGameController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPSpellGameMode) {
    UPSpellGameModeStart,
    UPSpellGameModeOffscreenLeft,
    UPSpellGameModeOffscreenRight,
    UPSpellGameModeMenu,
    UPSpellGameModeCountdown,
    UPSpellGameModePlay,
    UPSpellGameModePause,
    UPSpellGameModeOverInterstitial,
    UPSpellGameModeOver,
};

@interface UPSpellGameController : UIViewController

@property (nonatomic) UPSpellGameMode mode;

- (void)setMode:(UPSpellGameMode)mode animated:(BOOL)animated;

@end
