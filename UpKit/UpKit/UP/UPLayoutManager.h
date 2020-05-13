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

typedef NS_ENUM(NSInteger, UPLayoutManagerAspectMode) {
    UPLayoutManagerAspectModeCanonical,
    UPLayoutManagerAspectModeWiderThanCanonical,
    UPLayoutManagerAspectModeTallerThanCanonical,
};

@interface UPLayoutManager : NSObject

@property (nonatomic, readonly) CGSize canonicalCanvasSize;
@property (nonatomic, readonly) CGFloat canonicalAspectRatio;
@property (nonatomic) CGRect canvasFrame;
@property (nonatomic, readonly) UPLayoutManagerAspectMode aspectMode;
@property (nonatomic, readonly) CGFloat aspectRatio;
@property (nonatomic, readonly) CGFloat layoutScale;
@property (nonatomic, readonly) CGRect layoutFrame;

+ (UPLayoutManager *)instance;

- (CGPoint)positionForKey:(UPLayoutKey)key;
- (CGSize)sizeForKey:(UPLayoutKey)key;
- (CGRect)frameForKey:(UPLayoutKey)key;

@end
