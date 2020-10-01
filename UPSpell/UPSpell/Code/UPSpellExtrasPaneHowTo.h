//
//  UPSpellExtrasPaneHowTo.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPAccessoryPane.h"

@class UPGameTimer;

@interface UPSpellExtrasPaneHowTo : UPAccessoryPane

@property (nonatomic) UPGameTimer *gameTimer;

+ (UPSpellExtrasPaneHowTo *)pane;

- (void)commonConfigure;
- (void)configureForFullScreen;
- (void)startTutorial;
- (void)finish;

- (void)configureForBot;
- (void)centerBotSpotWithDuration:(CFTimeInterval)duration;
- (void)setTilesFromString:(NSString *)string;
- (void)bloopInTilesFromString:(NSString *)string;
- (void)botSpellWord:(NSString *)string;
- (void)submitWordReplacingWithTilesFromString:(NSString *)string;

@end
