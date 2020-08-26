//
//  UIFont+UP.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (UP)

@property (nonatomic) CGFloat baselineAdjustment;
@property (nonatomic) CGFloat kerning;

+ (UIFont *)fontWithName:(NSString *)name capHeight:(CGFloat)capHeight;

@end
