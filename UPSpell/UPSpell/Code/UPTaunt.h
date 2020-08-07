//
//  UPTaunt.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPGameKey;

@interface UPTaunt : NSObject

@property (nonatomic, readonly) UPGameKey *gameKey;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) BOOL valid;

+ (UPTaunt *)tauntWithGameKey:(UPGameKey *)gameKey score:(int)score;
+ (UPTaunt *)tauntWithURL:(NSURL *)URL;

- (instancetype)init NS_UNAVAILABLE;

@end
