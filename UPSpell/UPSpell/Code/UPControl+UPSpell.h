//
//  UPControl+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPButton.h>
#import <UpKit/UPControl.h>

#import "UPChoice.h"
#import "UPTextButton.h"
#import "UPTextSettingsButton.h"

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

@end

@interface UPTextButton (UPSpell)

+ (UPTextButton *)textButtonPlay;
+ (UPTextButton *)textButtonQuit;
+ (UPTextButton *)textButtonResume;

@end

@interface UPTextSettingsButton (UPSpell)

+ (UPTextSettingsButton *)textButtonAbout;
+ (UPTextSettingsButton *)textButtonExtras;

@end

@interface UPChoice (UPSpell)

+ (UPChoice *)choiceRightUpSpell;
+ (UPChoice *)choiceRightRules;
+ (UPChoice *)choiceRightLegal;
+ (UPChoice *)choiceRightThanks;

@end
