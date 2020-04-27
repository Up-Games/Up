//
//  UIView+UPLayout.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UPLayout)
@property (nonatomic) UPLayoutRule *layoutRule;

+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize;

- (void)layoutWithRule;

@end
