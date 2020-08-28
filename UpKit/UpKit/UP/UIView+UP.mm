//
//  UIView+UP.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <objc/runtime.h>

#import "UPAssertions.h"
#import "UPLayoutRule.h"
#import "UIView+UP.h"

@implementation UIView (UP)

+ (UIView *)view
{
    return [[[self class] alloc] initWithFrame:CGRectZero];
}

+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize
{
    return [[[self class] alloc] initWithBoundsSize:boundsSize];
}

- (instancetype)initWithBoundsSize:(CGSize)boundsSize
{
    return [self initWithFrame:CGRectMake(0, 0, boundsSize.width, boundsSize.height)];
}

#pragma mark - UPLayoutRule

@dynamic layoutRule;

- (void)setLayoutRule:(UPLayoutRule *)layoutRule
{
    objc_setAssociatedObject(self, @selector(layoutRule), layoutRule, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UPLayoutRule *)layoutRule
{
    return objc_getAssociatedObject(self, @selector(layoutRule));
}

- (void)layoutWithRule
{
    self.frame = [self.layoutRule layoutFrameForBoundsSize:self.bounds.size];
}

#pragma mark - Destination

@dynamic destination;

- (void)setDestination:(CGPoint)destination
{
    objc_setAssociatedObject(self, @selector(destination), [NSValue valueWithCGPoint:destination], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)destination
{
    NSValue *value = objc_getAssociatedObject(self, @selector(destination));
    return value ? [value CGPointValue] : self.center;
}

#pragma mark - borderColor

@dynamic borderColor;

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

#pragma mark - borderWidth

@dynamic borderWidth;

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

#pragma mark - cornerRadius

@dynamic cornerRadius;

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
