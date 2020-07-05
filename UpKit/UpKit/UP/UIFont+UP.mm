//
//  UIFont+UP.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>

#import <string>
#import <unordered_map>

#import "UIFont+UP.h"
#import "UPStringTools.h"

@implementation UIFont (UP)

+ (UIFont *)fontWithName:(NSString *)fontName capHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:fontName size:1];
    if (!canonicalFont) {
        return nil;
    }
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont fontWithName:fontName size:pointSize];
}

@dynamic baselineAdjustment;

- (void)setBaselineAdjustment:(CGFloat)baselineAdjustment
{
    objc_setAssociatedObject(self, @selector(baselineAdjustment), @(baselineAdjustment), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)baselineAdjustment
{
    id value = objc_getAssociatedObject(self, @selector(baselineAdjustment));
    return value ? [value doubleValue] : 0;
}

@dynamic kerning;

- (void)setKerning:(CGFloat)kerning
{
    objc_setAssociatedObject(self, @selector(kerning), @(kerning), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)kerning
{
    id value = objc_getAssociatedObject(self, @selector(kerning));
    return value ? [value doubleValue] : 0;
}

@end
