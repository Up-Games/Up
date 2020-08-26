//
//  UIImage+UP.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UIImage+UP.h"

@implementation UIImage (UP)

@dynamic width;
@dynamic height;

- (CGFloat)width
{
    return self.size.width;
}

- (CGFloat)height
{
    return self.size.height;
}

+ (UIImage *)imageNamed:(NSString *)name colorizedWith:(UIColor *)color
{
    UIImage *originalImage = [UIImage imageNamed:name];
    return [originalImage colorizedWith:color];
}

- (UIImage *)colorizedWith:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, self.width, self.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorizedImage;
}

- (UIImage *)imageOverlaidWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, self.width, self.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

@end
