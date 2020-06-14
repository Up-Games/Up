//
//  UPControl+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>

namespace UP {

UIBezierPath *RoundGameButtonFillPath();
UIBezierPath *RoundGameButtonStrokePath();
UIBezierPath *RoundBackButtonFillPath();
UIBezierPath *RoundBackButtonStrokePath();
UIBezierPath *RoundGameButtonMinusSignIconPath();
UIBezierPath *RoundGameButtonTrashIconPath();
UIBezierPath *RoundGameButtonDownArrowIconPath();
UIBezierPath *RoundBackButtonLeftArrowIconPath();
UIBezierPath *RoundBackButtonRightArrowIconPath();
UIBezierPath *TextButtonFillPath();
UIBezierPath *TextButtonStrokePath();
UIBezierPath *WordTrayFillPath();
UIBezierPath *WordTrayStrokePath();
UIBezierPath *ChoiceRowLeftFillPathSelected();
UIBezierPath *ChoiceRowRightFillPathSelected();

}  // namespace UP

@interface UPControl (UPSpell)

+ (UPControl *)roundGameButton;
+ (UPControl *)roundGameButtonMinusSign;

+ (UPControl *)roundBackButton;
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
