//
//  UPGameKey.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPStringTools.h>

#import "UPGameKey.h"

@interface UPGameKey ()
{
    UP::GameKey inner;
}
@end

@implementation UPGameKey

+ (UPGameKey *)randomGameKey
{
    return [[UPGameKey alloc] _initRandom];
}

+ (UPGameKey *)gameKeyWithString:(NSString *)string
{
    return [[UPGameKey alloc] _initWithString:string];
}

+ (UPGameKey *)gameKeyWithValue:(uint32_t)value
{
    return [[UPGameKey alloc] _initWithValue:value];
}

- (instancetype)_initRandom
{
    self = [super init];
    return self;
}

- (instancetype)_initWithString:(NSString *)string
{
    self = [super init];
    inner = UP::GameKey(UP::cpp_str(string));
    return self;
}

- (instancetype)_initWithValue:(uint32_t)value
{
    self = [super init];
    inner = UP::GameKey(value);
    return self;
}

@end
