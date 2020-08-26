//
//  UPSpellGameRetry.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPGameKey.h>

#import "UPSpellGameRetry.h"

@interface UPSpellGameRetry ()
@property (nonatomic, readwrite) UPSpellGameRetryType type;
@property (nonatomic, readwrite) UPGameKey *gameKey;
@property (nonatomic, readwrite) int score;
@end

@implementation UPSpellGameRetry

+ (UPSpellGameRetry *)retryWithType:(UPSpellGameRetryType)type gameKey:(UPGameKey *)gameKey score:(int)score
{
    return [[UPSpellGameRetry alloc] initWithType:type gameKey:gameKey score:score];
}

- (instancetype)initWithType:(UPSpellGameRetryType)type gameKey:(UPGameKey *)gameKey score:(int)score
{
    self = [super init];
    self.type = type;
    self.gameKey = gameKey;
    self.score = score;
    return self;
}

@end
