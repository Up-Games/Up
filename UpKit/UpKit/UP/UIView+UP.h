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

- (void)slideWithDuration:(CFTimeInterval)duration toPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion;
- (void)slideWithDuration:(CFTimeInterval)duration delay:(CFTimeInterval)delay toPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion;
- (void)shakeWithDuration:(CFTimeInterval)duration amount:(CGFloat)amount completion:(void (^)(BOOL finished))completion;
- (void)fadeWithDuration:(CFTimeInterval)duration completion:(void (^)(BOOL finished))completion;

extern CFTimeInterval UPDefaultBloopDuration;

- (void)bloopToFrame:(CGRect)frame completion:(void (^)(BOOL finished))completion;
- (void)bloopWithDuration:(CFTimeInterval)duration toFrame:(CGRect)frame completion:(void (^)(BOOL finished))completion;
- (void)bloopToPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion;
- (void)bloopToPosition:(CGPoint)position size:(CGSize)size completion:(void (^)(BOOL finished))completion;
- (void)bloopWithDuration:(CFTimeInterval)duration toPosition:(CGPoint)position completion:(void (^)(BOOL finished))completion;
- (void)bloopWithDuration:(CFTimeInterval)duration toPosition:(CGPoint)position size:(CGSize)size completion:(void (^)(BOOL finished))completion;

@end

