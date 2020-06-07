//
//  UPControl+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>

@interface UPControl (UPSpell)

+ (UPControl *)roundButtonMinusSign;
+ (UPControl *)roundButtonTrash;
+ (UPControl *)roundButtonDownArrow;
+ (UPControl *)roundButtonLeftArrow;
+ (UPControl *)roundButtonRightArrow;

+ (UPControl *)wordTray;

+ (UPControl *)textButtonAbout;
+ (UPControl *)textButtonExtras;
+ (UPControl *)textButtonMenu;
+ (UPControl *)textButtonPlay;
+ (UPControl *)textButtonQuit;
+ (UPControl *)textButtonResume;
+ (UPControl *)textButtonStats;

+ (UPControl *)choiceTitleRowLeftExtras;
+ (UPControl *)choiceItemRowLeftColors;

@end
