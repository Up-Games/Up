//
//  UPLetterTileView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPLetterTile.h>

@interface UPLetterTileView : UIView

@property (nonatomic, readonly) UP::LetterTile letterTile;
@property (nonatomic, readonly) char32_t glyph;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int multiplier;
@property (nonatomic, readonly) BOOL isSentinel;

+ (UPLetterTileView *)viewWithLetterTile:(const UP::LetterTile &)letterTile;

- (instancetype)init NS_UNAVAILABLE;

@end
