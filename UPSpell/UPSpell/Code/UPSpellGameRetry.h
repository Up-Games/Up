//
//  UPSpellGameRetry.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UPSpellGameRetryType) {
    UPSpellGameRetryTypeDefault,
    UPSpellGameRetryTypeLastGame,
    UPSpellGameRetryTypeHighScore,
};

@class UPGameKey;

@interface UPSpellGameRetry : NSObject

@property (nonatomic, readonly) UPSpellGameRetryType type;
@property (nonatomic, readonly) UPGameKey *gameKey;
@property (nonatomic, readonly) int score;

+ (UPSpellGameRetry *)retryWithType:(UPSpellGameRetryType)type gameKey:(UPGameKey *)gameKey score:(int)score;

- (instancetype)init NS_UNAVAILABLE;

@end
