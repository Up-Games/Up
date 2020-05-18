//
//  UPTileView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>
#import <UPKit/UPTile.h>

@interface UPTileView : UPControl

@property (nonatomic, readonly) UP::Tile tile;
@property (nonatomic, readonly) char32_t glyph;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int multiplier;
@property (nonatomic, readonly) BOOL isSentinel;
@property (nonatomic) NSUInteger index;

+ (UPTileView *)viewWithTile:(const UP::Tile &)tile;

- (instancetype)init NS_UNAVAILABLE;

@end
