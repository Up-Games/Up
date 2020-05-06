//
//  GameMockupView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, GameState) {
    GameStateStart,
    GameStateTap,
    GameStateSpell,
    GameStateWord,
    GameStateSubmit,
};

@interface GameMockupView : UIView
@property (nonatomic, copy) NSDictionary *colors;
@property (nonatomic) ColorTheme colorTheme;
@property (nonatomic) GameState gameState;
@end
