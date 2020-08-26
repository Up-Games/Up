//
//  UPTileView.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>

#import "UPSpellLayout.h"

@interface UPTileView : UPControl

@property (nonatomic) char32_t glyph;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int multiplier;

@property (nonatomic) UP::SpellLayout::Location submitLocation;

+ (UPTileView *)viewWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier;

@end
