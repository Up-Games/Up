//
//  UPTileControl.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>

@protocol UPTileViewGestureDelegate;

@interface UPTileView : UPControl

@property (nonatomic, readonly) char32_t glyph;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int multiplier;

@property (nonatomic, readonly) UITapGestureRecognizer *tap;
@property (nonatomic, readonly) UIPanGestureRecognizer *pan;
@property (nonatomic) BOOL tapEnabled;
@property (nonatomic) BOOL panEnabled;
@property (nonatomic) NSObject<UPTileViewGestureDelegate> *gestureDelegate;

+ (UPTileView *)viewWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier;

- (void)clearGestures;

@end

@protocol UPTileViewGestureDelegate <NSObject>
- (BOOL)beginTracking:(UPTileView *)tileView touch:(UITouch *)touch event:(UIEvent *)event;
- (BOOL)continueTracking:(UPTileView *)tileView touch:(UITouch *)touch event:(UIEvent *)event;
- (void)endTracking:(UPTileView *)tileView touch:(UITouch *)touch event:(UIEvent *)event;
- (void)cancelTracking:(UPTileView *)tileView event:(UIEvent *)event;
- (void)tileViewTapped:(UPTileView *)tileView;
- (void)tileViewPanned:(UPTileView *)tileView;
@end

