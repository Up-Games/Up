//
//  UPSharedGameRequest.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPGameKey;

@interface UPSharedGameRequest : NSObject

@property (nonatomic, readonly) UPGameKey *gameKey;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) BOOL valid;

+ (UPSharedGameRequest *)sharedGameRequestWithGameKey:(UPGameKey *)gameKey score:(int)score;
+ (UPSharedGameRequest *)sharedGameRequestWithURL:(NSURL *)URL;

- (instancetype)init NS_UNAVAILABLE;

@end
