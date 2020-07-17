//
//  UPSpellDossier.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPSpellModel.h"

@interface UPSpellDossier : NSObject <NSSecureCoding>

@property (class, readonly) BOOL supportsSecureCoding;

@property (nonatomic) int highScore;
@property (nonatomic) uint32_t highGameKey;
@property (nonatomic) int lastScore;
@property (nonatomic) uint32_t lastGameKey;

@property (nonatomic) size_t totalGamesPlayed;
@property (nonatomic) size_t totalGameScore;
@property (nonatomic) size_t totalWordsSubmitted;
@property (nonatomic) size_t totalTilesSubmitted;

+ (UPSpellDossier *)instance;

- (void)updateWithModel:(UP::SpellModelPtr)model;
- (void)save;

@end
