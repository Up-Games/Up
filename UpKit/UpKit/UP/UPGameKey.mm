//
//  UPGameKey.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPMacros.h>
#import <UpKit/UPStringTools.h>

#import "UPGameKey.h"

@interface UPGameKey ()
{
    UP::GameKey m_inner;
}
@end

@implementation UPGameKey

+ (UPGameKey *)randomGameKey
{
    return [[UPGameKey alloc] init];
}

+ (UPGameKey *)gameKeyWithString:(NSString *)string
{
    return [[UPGameKey alloc] initWithString:string];
}

+ (UPGameKey *)gameKeyWithValue:(uint32_t)value
{
    return [[UPGameKey alloc] initWithValue:value];
}

+ (BOOL)isWellFormedGameKeyString:(NSString *)string;
{
    return UP::GameKey::is_well_formed(UP::cpp_str(string));
}

- (instancetype)init
{
    self = [super init];
    m_inner = UP::GameKey::random();
    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    m_inner = UP::GameKey(UP::cpp_str(string));
    return self;
}

- (instancetype)initWithValue:(uint32_t)value
{
    self = [super init];
    m_inner = UP::GameKey(value);
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    uint32_t value = [coder decodeInt32ForKey:NSStringFromSelector(@selector(value))];
    self = [self initWithValue:value];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt32:m_inner.value() forKey:NSStringFromSelector(@selector(value))];
}

@dynamic string;
- (NSString *)string
{
    return UP::ns_str(m_inner.string());
}

@dynamic value;
- (uint32_t)value
{
    return m_inner.value();
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
