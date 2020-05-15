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
    return self;
}

@end
