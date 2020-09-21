//
//  UPGameLink.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UPGameLinkType) {
    UPGameLinkTypeDefault,
    UPGameLinkTypeChallenge = 0,
    UPGameLinkTypeDuel,
};

@class UPGameKey;

@interface UPGameLink : NSObject

@property (nonatomic, readonly) UPGameLinkType type;
@property (nonatomic, readonly) UPGameKey *gameKey;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly) BOOL valid;

+ (UPGameLink *)challengeGameLinkWithGameKey:(UPGameKey *)gameKey score:(int)score;
+ (UPGameLink *)duelGameLinkWithGameKey:(UPGameKey *)gameKey;
+ (UPGameLink *)gameLinkWithURL:(NSURL *)URL;

- (instancetype)init NS_UNAVAILABLE;

@end
