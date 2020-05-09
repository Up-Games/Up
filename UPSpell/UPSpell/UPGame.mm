//
//  UPGame.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPLexicon.h>

#import "UPGame.h"

#if __OBJC__

@interface UPGame ()
@end

@implementation UPGame

+ (UPGame *)instance
{
    static dispatch_once_t onceToken;
    static UPGame *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPGame alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    self = [super init];
    return self;
}

@end

#endif  // __OBJC__
