//
//  UPSpellDossier.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPSpellModel.h"

@interface UPSpellDossier : NSObject <NSSecureCoding>

@property (class, readonly) BOOL supportsSecureCoding;

@property (nonatomic) int highScore;
@property (nonatomic) uint32_t highScoreGameKeyValue;
@property (nonatomic) int lastScore;
@property (nonatomic) int lastGameChallengeScore;
@property (nonatomic) uint32_t lastGameKeyValue;
@property (nonatomic) BOOL lastGameWasChallenge;

@property (nonatomic) size_t totalGamesPlayed;
@property (nonatomic) size_t totalGameScore;
@property (nonatomic) size_t totalWordsSubmitted;
@property (nonatomic) size_t totalTilesSubmitted;

+ (UPSpellDossier *)instance;

- (void)updateWithModel:(UP::SpellModelPtr)model;
- (void)save;
- (BOOL)lastGameIsHighScore;

@end
