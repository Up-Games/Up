//
//  UPButton.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPButton.h"

@interface UPButton ()
@end

@implementation UPButton

+ (UPButton *)button
{
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"begin tracking");
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"continue tracking");
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"end tracking");
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    NSLog(@"cancel tracking");

}

@end
