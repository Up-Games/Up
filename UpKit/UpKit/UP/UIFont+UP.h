//
//  UIFont+UP.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (UP)

@property (nonatomic) CGFloat baselineAdjustment;
@property (nonatomic) CGFloat kerning;

+ (UIFont *)fontWithName:(NSString *)name capHeight:(CGFloat)capHeight;

@end
