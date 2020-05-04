//
//  ColorChip.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ColorChip : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGFloat grayValue;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat lightness;
@property (nonatomic) CGFloat hue;
@property (nonatomic, readonly) UIColor *color;

- (instancetype)initWithName:(NSString *)name grayValue:(CGFloat)grayValue saturation:(CGFloat)saturation lightness:(CGFloat)lightness;

- (NSAttributedString *)attributedDescription;

@end
