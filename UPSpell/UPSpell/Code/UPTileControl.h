//
//  UPTileControl.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>

#import "UPSpellGameModel.h"
#import "UPTile.h"

@interface UPTileView : UPControl

@property (nonatomic, readonly) UP::Tile tile;
@property (nonatomic, readonly) char32_t glyph;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int multiplier;
@property (nonatomic, readonly) BOOL isSentinel;
@property (nonatomic) UP::SpellGameModel::Position position;

+ (UPTileView *)controlWithTile:(const UP::Tile &)tile;

@end
