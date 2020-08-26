//
//  UPLayoutRule.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, UPLayoutHorizontal) {
    UPLayoutHorizontalDefault,
    UPLayoutHorizontalLeft,
    UPLayoutHorizontalMiddle,
    UPLayoutHorizontalRight,
};

typedef NS_ENUM(NSInteger, UPLayoutVertical) {
    UPLayoutVerticalDefault,
    UPLayoutVerticalTop,
    UPLayoutVerticalMiddle,
    UPLayoutVerticalBottom,
};

typedef NS_ENUM(NSInteger, UPLayoutOverflow) {
    UPLayoutOverflowDefault,
    UPLayoutOverflowAllow,
    UPLayoutOverflowPrevent,
};

@interface UPLayoutRule : NSObject

@property (nonatomic, readonly) CGRect referenceFrame;
@property (nonatomic, readonly) UPLayoutHorizontal hLayout;
@property (nonatomic, readonly) UPLayoutVertical vLayout;
@property (nonatomic, readonly) UPLayoutOverflow hOverflow;
@property (nonatomic, readonly) UPLayoutOverflow vOverflow;

+ (UPLayoutRule *)layoutRuleWithReferenceFrame:(CGRect)referenceFrame
                                       hLayout:(UPLayoutHorizontal)hLayout
                                       vLayout:(UPLayoutVertical)vLayout;

+ (UPLayoutRule *)layoutRuleWithReferenceFrame:(CGRect)referenceFrame
                                       hLayout:(UPLayoutHorizontal)hLayout
                                       vLayout:(UPLayoutVertical)vLayout
                                     hOverflow:(UPLayoutOverflow)hOverflow
                                     vOverflow:(UPLayoutOverflow)vOverflow;

- (CGRect)layoutFrameForBoundsSize:(CGSize)boundsSize;

- (CGFloat)layoutFrameYOriginForBoundsSize:(CGSize)boundsSize;
- (CGFloat)layoutFrameXOriginForBoundsSize:(CGSize)boundsSize;
- (CGFloat)layoutFrameHeightForBoundsSize:(CGSize)boundsSize;
- (CGFloat)layoutFrameWidthForBoundsSize:(CGSize)boundsSize;

@end
