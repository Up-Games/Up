//
//  UPShare.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPGameKey;

@interface UPShareRequest : NSObject

@property (nonatomic, readonly) UPGameKey *gameKey;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) BOOL valid;

+ (UPShareRequest *)shareRequestWithGameKey:(UPGameKey *)gameKey score:(int)score;
+ (UPShareRequest *)shareRequestWithURL:(NSURL *)URL;

- (instancetype)init NS_UNAVAILABLE;

@end
