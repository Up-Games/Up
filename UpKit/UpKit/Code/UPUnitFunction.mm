//
//  UPUnitFunction.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPUnitFunction.h>
#import <UpKit/UPUnitFunction.hpp>

@interface UPUnitFunction ()
@property UP::UnitFunction inner;
@end

@implementation UPUnitFunction

+ (UPUnitFunction *)unitFunctionWithType:(UPUnitFunctionType)type
{
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(UPUnitFunctionType)type
{
    self = [super init];
    self.inner = UP::UnitFunction(type);
    return self;
}

- (Float)valueForInput:(Float)input
{
    return self.inner.value_for_t(input);
}

@end
