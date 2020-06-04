//
//  UPViewTo.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPViewTo.h"

@interface UPViewTo ()
@property (nonatomic, readwrite) UIView *view;
@property (nonatomic, readwrite) CGPoint beginning;
@property (nonatomic, readwrite) CGPoint destination;
@end

@implementation UPViewTo

+ (UPViewTo *)view:(UIView *)view destination:(CGPoint)destination
{
    return [[UPViewTo alloc] initWithView:view destination:destination];
}

- (instancetype)initWithView:(UIView *)view destination:(CGPoint)destination
{
    self = [super init];
    self.view = view;
    self.beginning = view.center;
    self.destination = destination;
    return self;
}

@end
