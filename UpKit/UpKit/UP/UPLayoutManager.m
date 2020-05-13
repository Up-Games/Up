//
//  UPLayoutManager.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UPGeometry.h"
#import "UPLayoutManager.h"
#import "UPMath.h"

NSString * const UPLayoutManagerCanvasFrameWillChange = @"UPLayoutManagerCanvasFrameWillChange";
NSString * const UPLayoutManagerCanvasFrameDidChange = @"UPLayoutManagerCanvasFrameDidChange";
NSString * const UPLayoutManagerCanvasFrameKey = @"UPLayoutManagerCanvasFrameKey";

const CGFloat UPCanonicalCanvasWidth = 1000;
const CGFloat UPCanonicalCanvasHeight = 530;
const CGSize UPCanonicalCanvasSize = { UPCanonicalCanvasWidth, UPCanonicalCanvasHeight };
const CGFloat UPCanonicalAspectRatio = UPCanonicalCanvasWidth / UPCanonicalCanvasHeight;

@interface UPLayoutManager ()
@property (nonatomic, readwrite) UPLayoutManagerAspectMode aspectMode;
@property (nonatomic, readwrite) CGFloat aspectRatio;
@property (nonatomic, readwrite) CGFloat layoutScale;
@property (nonatomic, readwrite) CGRect layoutFrame;
@end

@implementation UPLayoutManager

- (void)setCanvasFrame:(CGRect)canvasFrame
{
    if (CGRectEqualToRect(_canvasFrame, canvasFrame)) {
        return;
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:UPLayoutManagerCanvasFrameWillChange object:nil userInfo:@{
        UPLayoutManagerCanvasFrameKey : [NSValue valueWithCGRect:_canvasFrame]
    }];
    _canvasFrame = canvasFrame;
    
    self.aspectRatio = up_aspect_ratio_for_rect(_canvasFrame);
    if (up_is_fuzzy_equal(self.aspectRatio, UPCanonicalAspectRatio)) {
        self.aspectMode = UPLayoutManagerAspectModeCanonical;
        self.layoutScale = 1;
    }
    else if (self.aspectRatio > UPCanonicalAspectRatio) {
        self.aspectMode = UPLayoutManagerAspectModeWiderThanCanonical;
        CGFloat canvasWidth = CGRectGetWidth(_canvasFrame);
        CGFloat canvasHeight = CGRectGetHeight(_canvasFrame);
        CGFloat conversionFactor = UPCanonicalCanvasSize.width / canvasWidth;
        CGFloat convertedHeight = CGRectGetHeight(_canvasFrame) * conversionFactor;
        self.layoutScale = convertedHeight / UPCanonicalCanvasSize.height;
        CGFloat width = round(canvasWidth * self.layoutScale);
        
        // layout frame is letterboxed, leaving gaps on the left and right.
        self.layoutFrame = up_rect_centered_in_rect(CGRectMake(0, 0, width, canvasHeight), _canvasFrame);
        NSLog(@"aspect wider: %.2f, %.2f : (%.3f)", width, canvasHeight, self.layoutScale);
        NSLog(@"        frame: %@", NSStringFromCGRect(self.layoutFrame));
    }
    else {
        self.aspectMode = UPLayoutManagerAspectModeTallerThanCanonical;
        CGFloat canvasWidth = CGRectGetWidth(_canvasFrame);
        CGFloat canvasHeight = CGRectGetHeight(_canvasFrame);
        CGFloat conversionFactor = UPCanonicalCanvasSize.height / canvasHeight;
        CGFloat convertedWidth = CGRectGetWidth(_canvasFrame) * conversionFactor;
        self.layoutScale = convertedWidth / UPCanonicalCanvasSize.width;
        CGFloat height = canvasHeight;
        // layout frame fills the canvas, and elements will layout to leave extra vertical gaps.
        self.layoutFrame = up_rect_centered_in_rect(CGRectMake(0, 0, canvasWidth, height), _canvasFrame);
        NSLog(@"aspect taller: %.2f, %.2f : (%.3f)", canvasWidth, height, self.layoutScale);
        NSLog(@"        frame: %@", NSStringFromCGRect(self.layoutFrame));
    }

    [nc postNotificationName:UPLayoutManagerCanvasFrameDidChange object:nil userInfo:@{
        UPLayoutManagerCanvasFrameKey : [NSValue valueWithCGRect:_canvasFrame]
    }];
}

- (CGPoint)positionForKey:(UPLayoutKey)key
{
    return CGPointZero;
}

- (CGSize)sizeForKey:(UPLayoutKey)key
{
    return CGSizeZero;
}

- (CGRect)frameForKey:(UPLayoutKey)key
{
    CGPoint point = [self positionForKey:key];
    CGSize size = [self sizeForKey:key];
    return CGRectMake(point.x, point.y, size.width, size.height);
}

@end
