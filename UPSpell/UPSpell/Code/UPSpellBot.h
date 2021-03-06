//
//  UPSpellBot.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPSpellModel.h"

@interface UPSpellBot : NSObject

- (void)takeTurn:(std::shared_ptr<UP::SpellModel>)model;

- (void)start;
- (void)stop;

@end
