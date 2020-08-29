//
//  UPTileView.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>

#import "UPSpellLayout.h"

@interface UPTileView : UPControl

@property (nonatomic) char32_t glyph;
@property (nonatomic) int score;
@property (nonatomic) int multiplier;
@property (nonatomic) BOOL hasLeadingApostrophe;
@property (nonatomic) BOOL hasTrailingApostrophe;

@property (nonatomic) UP::SpellLayout::Location submitLocation;

+ (UPTileView *)viewWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier;

- (void)updateTile;

@end
