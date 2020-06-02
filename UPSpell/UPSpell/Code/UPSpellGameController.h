//
//  UPSpellGameController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UPSpellGameMode.h"

@interface UPSpellGameController : UIViewController

@property (nonatomic) UPSpellGameMode mode;

- (void)setMode:(UPSpellGameMode)mode animated:(BOOL)animated;

@end
