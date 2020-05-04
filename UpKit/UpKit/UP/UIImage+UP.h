//
//  UIImage+UP.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UP)

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

+ (UIImage *)imageNamed:(NSString *)name colorizedWith:(UIColor *)color;
- (UIImage *)colorizedWith:(UIColor *)color;

- (UIImage *)imageOverlaidWithColor:(UIColor *)color;

@end
