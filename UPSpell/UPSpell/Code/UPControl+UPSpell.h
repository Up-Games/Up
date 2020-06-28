//
//  UPControl+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPButton.h>
#import <UpKit/UPControl.h>

#import "UPChoice.h"

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
UIBezierPath *ChoiceLeftFillPathSelected();
UIBezierPath *ChoiceRightFillPathSelected();

}  // namespace UP

@interface UPControl (UPSpell)

+ (UPControl *)roundGameControl;
+ (UPControl *)roundGameControlMinusSign;
+ (UPControl *)wordTrayControl;

@end

@interface UPButton (UPSpell)

+ (UPButton *)roundBackButton;
+ (UPButton *)roundBackButtonLeftArrow;
+ (UPButton *)roundBackButtonRightArrow;

+ (UPButton *)textButtonAbout;
+ (UPButton *)textButtonExtras;
+ (UPButton *)textButtonPlay;
+ (UPButton *)textButtonQuit;
+ (UPButton *)textButtonResume;

@end

@interface UPChoice (UPSpell)

+ (UPChoice *)choiceLeftColors;
+ (UPChoice *)choiceLeftSounds;
+ (UPChoice *)choiceLeftStats;
+ (UPChoice *)choiceLeftGameKeys;

+ (UPChoice *)choiceRightUpSpell;
+ (UPChoice *)choiceRightRules;
+ (UPChoice *)choiceRightLegal;
+ (UPChoice *)choiceRightThanks;

@end
