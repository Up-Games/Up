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

@property (nonatomic) UPQuadOffsets quadOffsets;

extern CFTimeInterval UPDefaultBloopDuration;

- (void)bloopToFrame:(CGRect)frame;
- (void)bloopWithDuration:(UPTick)duration toFrame:(CGRect)frame;
- (void)bloopToPosition:(CGPoint)position;
- (void)bloopToPosition:(CGPoint)position size:(CGSize)size;
- (void)bloopWithDuration:(UPTick)duration toPosition:(CGPoint)position size:(CGSize)size;

@end

