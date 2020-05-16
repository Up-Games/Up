//
//  UIFont+UP.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

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

@end
