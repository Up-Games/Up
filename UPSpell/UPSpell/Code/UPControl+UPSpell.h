//
//  UPControl+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>

@interface UPControl (UPSpell)

+ (UPControl *)roundGameButtonMinusSign;
+ (UPControl *)roundGameButtonTrash;
+ (UPControl *)roundGameButtonDownArrow;

+ (UPControl *)roundBackButtonLeftArrow;
+ (UPControl *)roundBackButtonRightArrow;

+ (UPControl *)wordTray;

+ (UPControl *)textButtonAbout;
+ (UPControl *)textButtonExtras;
+ (UPControl *)textButtonPlay;
+ (UPControl *)textButtonQuit;
+ (UPControl *)textButtonResume;
+ (UPControl *)textButtonStats;

+ (UPControl *)choiceItemRowLeftColors;
+ (UPControl *)choiceItemRowLeftSounds;
+ (UPControl *)choiceItemRowLeftStats;
+ (UPControl *)choiceItemRowLeftGameKeys;

+ (UPControl *)choiceItemRowRightUpSpell;
+ (UPControl *)choiceItemRowRightRules;
+ (UPControl *)choiceItemRowRightLegal;
+ (UPControl *)choiceItemRowRightThanks;

@end
