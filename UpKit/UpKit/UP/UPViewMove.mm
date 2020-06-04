//
//  UPViewMove.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPViewMove.h"

@interface UPViewMove ()
@property (nonatomic, readwrite) UIView *view;
@property (nonatomic, readwrite) CGPoint beginning;
@property (nonatomic, readwrite) CGPoint destination;
@end

@implementation UPViewMove

+ (UPViewMove *)view:(UIView *)view beginning:(CGPoint)beginning destination:(CGPoint)destination
{
    return [[UPViewMove alloc] initWithView:view beginning:beginning destination:destination];
}

- (instancetype)initWithView:(UIView *)view beginning:(CGPoint)beginning destination:(CGPoint)destination
{
    self = [super init];
    self.view = view;
    self.beginning = beginning;
    self.destination = destination;
    return self;
}

@end
