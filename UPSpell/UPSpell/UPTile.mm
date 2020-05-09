//
//  UPTile.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPTile.h"

@interface UPTile ()
{
    UP::Tile inner;
}
@end

@implementation UPTile

+ (UPTile *)tileWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    return [[UPTile alloc] initWithGlyph:glyph score:score multiplier:multiplier];
}

- (instancetype)initWithGlyph:(char32_t)glyph score:(int)score multiplier:(int)multiplier
{
    self = [super init];
    
    inner = UP::Tile(glyph, score, multiplier);
    
    return self;
}

@dynamic glyph;
- (char32_t)glyph
{
    return inner.glyph();
}

@dynamic score;
- (int)score
{
    return inner.score();
}

@dynamic multiplier;
- (int)multiplier
{
    return inner.multiplier();
}

@end
