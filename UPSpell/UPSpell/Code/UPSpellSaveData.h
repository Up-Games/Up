//
//  UPSpellSaveData.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

namespace UP {

static constexpr int NotAScore = -1;

}  // namespace UP


@interface UPSpellPersistentData : NSObject <NSSecureCoding>

@property(class, readonly) BOOL supportsSecureCoding;

@property(nonatomic, readonly) int highScore;
@property(nonatomic, readonly) uint32_t highGameKey;
@property(nonatomic, readonly) int lastScore;
@property(nonatomic, readonly) uint32_t lastGameKey;

@property(nonatomic, readonly) NSInteger totalGamesPlayed;
@property(nonatomic, readonly) NSInteger totalGameScore;
@property(nonatomic, readonly) NSInteger totalWordsSubmitted;
@property(nonatomic, readonly) NSInteger totalTitlesSubmitted;

- (instancetype)init;
- (instancetype)initWithCoder:(NSCoder *)coder;

@end
