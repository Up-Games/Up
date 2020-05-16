//
//  UPLetterTileView.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPLabel.h>

#import "UPLetterTileView.h"
#import "UPSpellLayoutManager.h"

using UP::LetterTile;

@interface UPLetterTileView ()
@property (nonatomic, readwrite) UP::LetterTile letterTile;
@property (nonatomic) UPLabel *glyphLabel;
@property (nonatomic) UPLabel *scoreLabel;
@property (nonatomic) UPLabel *multiplierLabel;
@end

@implementation UPLetterTileView

+ (UPLetterTileView *)viewWithLetterTile:(const UP::LetterTile &)letterTile
{
    return [[self alloc] _initWithLetterTile:letterTile];
}

- (instancetype)_initWithLetterTile:(const UP::LetterTile &)letterTile
{
    self = [super initWithFrame:CGRectZero];
    self.letterTile = letterTile;
    return self;
}

@dynamic glyph;
- (char32_t)glyph
{
    return self.letterTile.glyph();
}

@dynamic score;
- (int)score
{
    return self.letterTile.score();
}

@dynamic multiplier;
- (int)multiplier
{
    return self.letterTile.multiplier();
}

@dynamic isSentinel;
- (BOOL)isSentinel
{
    return self.letterTile.is_sentinel();
}

#pragma mark - Layout

- (void)layoutSubviews
{

}

@end
