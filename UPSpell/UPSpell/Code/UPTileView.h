//
//  UPTileView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>

#import "UPSpellLayout.h"
#import "UPTileGestureRecognizer.h"

@protocol UPTileGestureDelegate;

@interface UPTileView : UPControl

@property (nonatomic, readonly) char32_t glyph;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int multiplier;

@property (nonatomic, readonly) UPTileGestureRecognizer *tileGesture;
@property (nonatomic) NSObject<UPTileGestureDelegate> *tileGestureDelegate;

@property (nonatomic) UP::SpellLayout::Location submitLocation;

+ (UPTileView *)viewWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier;

@end

@protocol UPTileGestureDelegate <NSObject>
- (void)handleTileGesture:(UPTileView *)tileView;
@end

