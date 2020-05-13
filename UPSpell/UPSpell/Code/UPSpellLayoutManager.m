//
//  UPSpellLayoutManager.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSpellLayoutManager.h"

const CGRect UPSpellCanonicalTileLayoutFrame = { 101, 371, 798, 120 };
const CGSize UPSpellCanonicalTileSize = { 102, 120 };
const CGFloat UPSpellCanonicalTileGap = 14;

@implementation UPSpellLayoutManager

+ (UPSpellLayoutManager *)instance
{
    static dispatch_once_t onceToken;
    static UPSpellLayoutManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@dynamic tileFrame;
- (CGRect)tileFrame
{
    switch (self.aspectMode) {
        case UPLayoutManagerAspectModeCanonical:
            return UPSpellCanonicalTileLayoutFrame;
        case UPLayoutManagerAspectModeWiderThanCanonical: {
            CGRect layoutFrame = self.layoutFrame;
            CGFloat heightFraction = CGRectGetMinY(UPSpellCanonicalTileLayoutFrame) / UPCanonicalCanvasHeight;
            CGFloat y = CGRectGetHeight(layoutFrame) * heightFraction;
            CGFloat layoutScale = self.layoutScale;
            // Width is not adjusted
            CGFloat width = CGRectGetWidth(UPSpellCanonicalTileLayoutFrame) * layoutScale;
            CGFloat height = CGRectGetHeight(UPSpellCanonicalTileLayoutFrame) * layoutScale;
            CGRect frame = CGRectMake(0, y, width, height);
            frame = up_rect_centered_x_in_rect(frame, layoutFrame);
            return frame;
        }
        case UPLayoutManagerAspectModeTallerThanCanonical: {
            CGRect layoutFrame = self.layoutFrame;
            CGFloat heightFraction = CGRectGetMinY(UPSpellCanonicalTileLayoutFrame) / UPCanonicalCanvasHeight;
            CGFloat y = CGRectGetHeight(layoutFrame) * heightFraction;
            CGFloat layoutScale = self.layoutScale;
            CGFloat widthFraction = CGRectGetWidth(UPSpellCanonicalTileLayoutFrame) / UPCanonicalCanvasWidth;
            CGFloat width = CGRectGetWidth(layoutFrame) * layoutScale * widthFraction;
            CGFloat height = CGRectGetHeight(UPSpellCanonicalTileLayoutFrame) * layoutScale * widthFraction;
            CGRect frame = CGRectMake(0, y, width, height);
            frame = up_rect_centered_x_in_rect(frame, layoutFrame);
            return frame;
        }
    }
}

@end
