//
//  UPControl+UPSpell.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPButton.h>
#import <UpKit/UPControl.h>

namespace UP {

UIBezierPath *RoundGameButtonFillPath();
UIBezierPath *RoundGameButtonStrokePath();
UIBezierPath *RoundBackButtonFillPath();
UIBezierPath *RoundBackButtonStrokePath();
UIBezierPath *RoundGameButtonPauseIconPath();
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
+ (UPControl *)roundGameControlPause;
+ (UPControl *)wordTrayControl;

@end

@interface UPButton (UPSpell)

+ (UPButton *)roundBackButton;
+ (UPButton *)roundBackButtonLeftArrow;
+ (UPButton *)roundBackButtonRightArrow;
+ (UPButton *)roundBackButtonEx;
+ (UPButton *)roundHelpButton;
+ (UPButton *)roundShareButton;

@end
