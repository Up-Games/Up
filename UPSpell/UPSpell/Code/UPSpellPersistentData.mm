//
//  UPSpellPersistentData.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>

#import <UpKit/UPMacros.h>

#import "UPSpellPersistentData.h"

@interface UPSpellPersistentData ()

@property (nonatomic, readwrite) int highScore;
@property (nonatomic, readwrite) uint32_t highGameKey;
@property (nonatomic, readwrite) int lastScore;
@property (nonatomic, readwrite) uint32_t lastGameKey;

@property (nonatomic, readwrite) NSInteger totalGamesPlayed;
@property (nonatomic, readwrite) NSInteger totalGameScore;
@property (nonatomic, readwrite) NSInteger totalWordsSubmitted;
@property (nonatomic, readwrite) NSInteger totalTitlesSubmitted;

@property (nonatomic, readwrite) UPSpellModel *gameInProgress;

@end

@implementation UPSpellPersistentData

- (instancetype)init
{
    self = [super init];

    self.highScore = 0;
    self.highGameKey = 0;
    self.lastScore = 0;
    self.lastGameKey = 0;
    
    self.totalGamesPlayed = 0;
    self.totalGameScore = 0;
    self.totalWordsSubmitted = 0;
    self.totalTitlesSubmitted = 0;

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];

    UP_DECODE(coder, highScore, Int);
    UP_DECODE(coder, highGameKey, Int32);
    UP_DECODE(coder, lastScore, Int);
    UP_DECODE(coder, lastGameKey, Int32);

    UP_DECODE(coder, totalGamesPlayed, Integer);
    UP_DECODE(coder, totalGameScore, Integer);
    UP_DECODE(coder, totalWordsSubmitted, Integer);
    UP_DECODE(coder, totalTitlesSubmitted, Integer);

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    UP_ENCODE(coder, highScore, Int);
    UP_ENCODE(coder, highGameKey, Int32);
    UP_ENCODE(coder, lastScore, Int);
    UP_ENCODE(coder, lastGameKey, Int32);
    
    UP_ENCODE(coder, totalGamesPlayed, Integer);
    UP_ENCODE(coder, totalGameScore, Integer);
    UP_ENCODE(coder, totalWordsSubmitted, Integer);
    UP_ENCODE(coder, totalTitlesSubmitted, Integer);
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
