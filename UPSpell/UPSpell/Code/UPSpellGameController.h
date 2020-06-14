//
//  UPSpellGameController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPSpellControllerMode) {
    UPSpellControllerModeNone,
    UPSpellControllerModeStart,
    UPSpellControllerModeAbout,
    UPSpellControllerModeExtras,
    UPSpellControllerModeAttract,
    UPSpellControllerModeReady,
    UPSpellControllerModePlay,
    UPSpellControllerModePause,
    UPSpellControllerModeGameOver,
    UPSpellControllerModeQuit,
    UPSpellControllerModeEnd,
};

@interface UPSpellGameController : UIViewController

@property (nonatomic) UPSpellControllerMode mode;

@end
