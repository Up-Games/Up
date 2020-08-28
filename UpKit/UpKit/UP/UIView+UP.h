//
//  UIView+UP.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPGeometry.h>

@class UPLayoutRule;

@interface UIView (UP)

+ (UIView *)view;
+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize;
- (instancetype)initWithBoundsSize:(CGSize)boundsSize;

@property (nonatomic) UPLayoutRule *layoutRule;
- (void)layoutWithRule;

@property (nonatomic) CGPoint destination;

@property (nonatomic) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;

@end
