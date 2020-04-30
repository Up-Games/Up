/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "POPAnimationInternal.h"

#import "POPCustomAnimation.h"

@interface POPCustomAnimation ()
@property (nonatomic, copy) POPCustomAnimationBlock animate;
@end

@implementation POPCustomAnimation
@dynamic elapsedTime;

+ (instancetype)animationWithBlock:(BOOL(^)(id target, POPCustomAnimation *))block
{
    POPCustomAnimation *b = [[self alloc] _init];
    b.animate = block;
    return b;
}

- (id)_init
{
    self = [super _init];
    _state->type = kPOPAnimationCustom;
    return self;
}

- (CFTimeInterval)beginTime
{
    POPAnimationState *s = POPAnimationGetState(self);
    return s->startTime > 0 ? s->startTime : s->beginTime;
}

- (BOOL)_advance:(id)object currentTime:(CFTimeInterval)currentTime intervalTime:(CFTimeInterval)intervalTime
{
    _currentTime = currentTime;
    _intervalTime = intervalTime;
    return _animate(object, self);
}

- (void)_appendDescription:(NSMutableString *)s debug:(BOOL)debug
{
    [s appendFormat:@"; intervalTime = %f; currentTime = %f; elapsedTime = %f;", _intervalTime, _currentTime, self.elapsedTime];
}

- (CFTimeInterval)elapsedTime
{
    return _currentTime - self.beginTime;
}

@end

/**
 *  Note that only the animate block is copied, but not the current/elapsed times
 */
@implementation POPCustomAnimation (NSCopying)

- (instancetype)copyWithZone:(NSZone *)zone
{
    POPCustomAnimation *copy = [super copyWithZone:zone];
    if (copy) {
        copy.animate = self.animate;
    }
    return copy;
}

@end
