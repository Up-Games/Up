//
//  UPSpellLayoutManager.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

typedef NS_ENUM(UPLayoutKey, UPSpellLayoutManagerKey) {
    UPSpellLayoutManagerKeyNone,
    UPSpellLayoutManagerKeyTile1InPlayerTray,
};

extern const CGRect UPSpellCanonicalTileLayoutFrame;
extern const CGSize UPSpellCanonicalTileSize;
extern const CGFloat UPSpellCanonicalTileGap;

@interface UPSpellLayoutManager : UPLayoutManager

@property (nonatomic, readonly) CGRect tileFrame;

+ (UPSpellLayoutManager *)instance;

@end
