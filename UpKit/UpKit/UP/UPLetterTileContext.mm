//
//  UPLetterTileContext.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPLexicon.h>

#import "UPLetterTileContext.h"

#if __OBJC__

@interface UPLetterTileContext ()
@end

@implementation UPLetterTileContext

+ (UPLetterTileContext *)instance
{
    static dispatch_once_t onceToken;
    static UPLetterTileContext *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPLetterTileContext alloc] _init];
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
