//
//  UPGameCode.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPStringTools.h>

#import "UPGameCode.h"

@interface UPGameCode ()
{
    UP::GameCode inner;
}
@end

@implementation UPGameCode

+ (UPGameCode *)randomGameCode
{
    return [[UPGameCode alloc] _initRandom];
}

+ (UPGameCode *)gameCodeWithString:(NSString *)string
{
    return [[UPGameCode alloc] _initWithString:string];
}

+ (UPGameCode *)gameCodeWithValue:(uint32_t)value
{
    return [[UPGameCode alloc] _initWithValue:value];
}

- (instancetype)_initRandom
{
    self = [super init];
    return self;
}

- (instancetype)_initWithString:(NSString *)string
{
    self = [super init];
    inner = UP::GameCode(UP::cpp_str(string));
    return self;
}

- (instancetype)_initWithValue:(uint32_t)value
{
    self = [super init];
    inner = UP::GameCode(value);
    return self;
}

@end
