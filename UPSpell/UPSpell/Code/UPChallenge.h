//
//  UPShare.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPGameKey;

@interface UPChallenge : NSObject

@property (nonatomic, readonly) UPGameKey *gameKey;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly) BOOL valid;

+ (UPChallenge *)challengeWithGameKey:(UPGameKey *)gameKey score:(int)score;
+ (UPChallenge *)challengeWithURL:(NSURL *)URL;

- (instancetype)init NS_UNAVAILABLE;

@end
