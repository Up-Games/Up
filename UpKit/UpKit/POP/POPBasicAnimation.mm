/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "POPBasicAnimationInternal.h"

@implementation POPBasicAnimation

#undef __state
#define __state ((POPBasicAnimationState *)_state)

#pragma mark - Lifecycle

+ (instancetype)animation
{
    return [[self alloc] init];
}

+ (instancetype)animationWithPropertyNamed:(NSString *)aName
{
    POPBasicAnimation *anim = [self animation];
    anim.property = [POPAnimatableProperty propertyWithName:aName];
    return anim;
}

- (void)_initState
{
    _state = new POPBasicAnimationState(self);
}

+ (instancetype)linearAnimation
{
    POPBasicAnimation *anim = [self animation];
    anim.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeLinear];
    return anim;
}

+ (instancetype)easeInAnimation
{
    POPBasicAnimation *anim = [self animation];
    anim.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseIn];
    return anim;
}

+ (instancetype)easeOutAnimation
{
    POPBasicAnimation *anim = [self animation];
    anim.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseOut];
    return anim;
}

+ (instancetype)easeInEaseOutAnimation
{
    POPBasicAnimation *anim = [self animation];
    anim.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeEaseInEaseOut];
    return anim;
}

+ (instancetype)defaultAnimation
{
    POPBasicAnimation *anim = [self animation];
    anim.timingFunction = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeDefault];
    return anim;
}

- (id)init
{
    return [self _init];
}

#pragma mark - Properties

DEFINE_RW_PROPERTY(POPBasicAnimationState, duration, setDuration:, CFTimeInterval);
DEFINE_RW_PROPERTY_OBJ(POPBasicAnimationState, timingFunction, setTimingFunction:, UPUnitFunction *);

#pragma mark - Utility

- (void)_appendDescription:(NSMutableString *)s debug:(BOOL)debug
{
    [super _appendDescription:s debug:debug];
    if (__state->duration) {
        [s appendFormat:@"; duration = %f", __state->duration];
    }
}

@end

@implementation POPBasicAnimation (NSCopying)

- (instancetype)copyWithZone:(NSZone *)zone
{
    POPBasicAnimation *copy = [super copyWithZone:zone];
    if (copy) {
        copy.duration = self.duration;
        copy.timingFunction = self.timingFunction; // not a 'copy', but timing functions are publicly immutable.
    }
    return copy;
}

@end
