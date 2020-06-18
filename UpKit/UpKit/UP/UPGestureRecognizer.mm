//
//  UPGestureRecognizer.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPGestureRecognizer.h"

@interface UPGestureRecognizer ()
@end

@implementation UPGestureRecognizer

- (void)preempt
{
    [self handlePreemption];
    [self reset];
}

- (void)handlePreemption
{
    // for subclasses
}

@end
