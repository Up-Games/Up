//
//  UPLayoutRule.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPLayoutRule.h"

@interface UPLayoutRule ()
@property (nonatomic, readwrite) CGRect referenceFrame;
@property (nonatomic, readwrite) UPLayoutHorizontal hLayout;
@property (nonatomic, readwrite) UPLayoutVertical vLayout;
@property (nonatomic, readwrite) UPLayoutOverflow hOverflow;
@property (nonatomic, readwrite) UPLayoutOverflow vOverflow;
@end

@implementation UPLayoutRule

+ (UPLayoutRule *)layoutRuleWithReferenceFrame:(CGRect)referenceFrame
                                       hLayout:(UPLayoutHorizontal)hLayout
                                       vLayout:(UPLayoutVertical)vLayout
{
    return [self layoutRuleWithReferenceFrame:referenceFrame hLayout:hLayout vLayout:vLayout
                                    hOverflow:UPLayoutOverflowDefault vOverflow:UPLayoutOverflowDefault];
}

+ (UPLayoutRule *)layoutRuleWithReferenceFrame:(CGRect)referenceFrame
                                       hLayout:(UPLayoutHorizontal)hLayout
                                       vLayout:(UPLayoutVertical)vLayout
                                     hOverflow:(UPLayoutOverflow)hOverflow
                                     vOverflow:(UPLayoutOverflow)vOverflow
{
    return [[self alloc] initWithReferenceFrame:referenceFrame hLayout:hLayout vLayout:vLayout hOverflow:hOverflow vOverflow:vOverflow];
}

- (instancetype)initWithReferenceFrame:(CGRect)referenceFrame
                               hLayout:(UPLayoutHorizontal)hLayout
                               vLayout:(UPLayoutVertical)vLayout
                             hOverflow:(UPLayoutOverflow)hOverflow
                             vOverflow:(UPLayoutOverflow)vOverflow
{
    self = [super init];
    
    self.referenceFrame = referenceFrame;
    self.hLayout = hLayout;
    self.vLayout = vLayout;
    self.hOverflow = hOverflow;
    self.vOverflow = vOverflow;

    return self;
}

- (CGRect)layoutFrameForBoundsSize:(CGSize)boundsSize
{
    CGFloat x = [self layoutFrameXOriginForBoundsSize:boundsSize];
    CGFloat y = [self layoutFrameYOriginForBoundsSize:boundsSize];
    CGFloat w = [self layoutFrameWidthForBoundsSize:boundsSize];
    CGFloat h = [self layoutFrameHeightForBoundsSize:boundsSize];
    return CGRectMake(x, y, w, h);
}

- (CGFloat)layoutFrameXOriginForBoundsSize:(CGSize)boundsSize
{
    CGFloat result = CGRectGetMinX(self.referenceFrame);
    switch (self.hLayout) {
        case UPLayoutHorizontalDefault:
        case UPLayoutHorizontalLeft: {
            // no-op
            break;
        }
        case UPLayoutHorizontalMiddle: {
            result = CGRectGetMidX(self.referenceFrame);
            result -= boundsSize.width * 0.5;
            break;
        }
        case UPLayoutHorizontalRight: {
            result = CGRectGetMaxX(self.referenceFrame);
            result -= boundsSize.width;
            break;
        }
    }
    return result;
}

- (CGFloat)layoutFrameYOriginForBoundsSize:(CGSize)boundsSize
{
    CGFloat result = CGRectGetMinY(self.referenceFrame);
    switch (self.vLayout) {
        case UPLayoutVerticalDefault:
        case UPLayoutVerticalTop: {
            // no-op
            break;
        }
        case UPLayoutVerticalMiddle: {
            result = CGRectGetMidY(self.referenceFrame);
            result -= boundsSize.height * 0.5;
            break;
        }
        case UPLayoutVerticalBottom: {
            result = CGRectGetMaxY(self.referenceFrame);
            result -= boundsSize.height;
            break;
        }
    }
    return result;
    return 0;
}

- (CGFloat)layoutFrameWidthForBoundsSize:(CGSize)boundsSize
{
    return boundsSize.width;
}

- (CGFloat)layoutFrameHeightForBoundsSize:(CGSize)boundsSize
{
    return boundsSize.height;
}


@end
