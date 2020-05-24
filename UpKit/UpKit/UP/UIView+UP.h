//
//  UIView+UP.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPGeometry.h>

@class UPLayoutRule;

@interface UIView (UP)

+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize;
- (instancetype)initWithBoundsSize:(CGSize)boundsSize;

@property (nonatomic) UPLayoutRule *layoutRule;
- (void)layoutWithRule;

@end
