//
//  UPTileTray.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPTile.h"

@interface UPTileTray : NSObject

- (UPTile *)tileAtIndex:(size_t)index;

- (void)fill;
- (void)markAtIndex:(size_t)index;
- (void)unmarkAtIndex:(size_t)index;
- (void)markAll;
- (void)unmarkAll;
- (void)sentinelizeMarked;
- (size_t)countMarked;

@end

