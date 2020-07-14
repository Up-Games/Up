//
//  UPSpellGameController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPGameKey.h>

#import "UPMode.h"

@class UPSpellGameRetry;

@interface UPSpellGameController : UIViewController

@property (nonatomic) UP::Mode mode;
@property (nonatomic) UPSpellGameRetry *retry;

@end
