//
//  UPLayoutManager.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NSInteger UPLayoutKey;

extern NSString * const UPLayoutManagerCanvasFrameWillChange;
extern NSString * const UPLayoutManagerCanvasFrameDidChange;
extern NSString * const UPLayoutManagerCanvasFrameKey;

extern const CGFloat UPCanonicalCanvasWidth;
extern const CGFloat UPCanonicalCanvasHeight;
extern const CGSize UPCanonicalCanvasSize;
extern const CGFloat UPCanonicalAspectRatio;

typedef NS_ENUM(NSInteger, UPLayoutManagerAspectMode) {
    UPLayoutManagerAspectModeCanonical,
    UPLayoutManagerAspectModeWiderThanCanonical,
    UPLayoutManagerAspectModeTallerThanCanonical,
};

@interface UPLayoutManager : NSObject

@property (nonatomic) CGRect canvasFrame;
@property (nonatomic, readonly) UPLayoutManagerAspectMode aspectMode;
@property (nonatomic, readonly) CGFloat aspectRatio;
@property (nonatomic, readonly) CGFloat layoutScale;
@property (nonatomic, readonly) CGRect layoutFrame;

- (CGPoint)positionForKey:(UPLayoutKey)key;
- (CGSize)sizeForKey:(UPLayoutKey)key;
- (CGRect)frameForKey:(UPLayoutKey)key;

@end
