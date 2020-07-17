//
//  UPSpellPersistentData.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPSpellPersistentData : NSObject <NSSecureCoding>

@property (class, readonly) BOOL supportsSecureCoding;

@property (nonatomic) int highScore;
@property (nonatomic) uint32_t highGameKey;
@property (nonatomic) int lastScore;
@property (nonatomic) uint32_t lastGameKey;

@property (nonatomic) NSInteger totalGamesPlayed;
@property (nonatomic) NSInteger totalGameScore;
@property (nonatomic) NSInteger totalWordsSubmitted;
@property (nonatomic) NSInteger totalTilesSubmitted;

+ (UPSpellPersistentData *)instance;

- (void)save;

@end
