//
//  UIView+UPLayout.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>

#import "UPLayoutRule.h"
#import "UIView+UPLayout.h"

@implementation UIView (UPLayout)

@dynamic layoutRule;

- (void)setLayoutRule:(UPLayoutRule *)layoutRule
{
    objc_setAssociatedObject(self, @selector(layoutRule), layoutRule, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UPLayoutRule *)layoutRule
{
    return objc_getAssociatedObject(self, @selector(layoutRule));
}

+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsSize.width, boundsSize.height)];
}

- (void)layoutWithRule
{
    self.frame = [self.layoutRule layoutFrameForBoundsSize:self.bounds.size];
}

@end
