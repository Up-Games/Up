//
//  UPTextPaths.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIBezierPath.h>

#if __cplusplus

namespace UP {

UIBezierPath *TextPathContentAbout();
UIBezierPath *TextPathContentExtras();
UIBezierPath *TextPathContentMenu();
UIBezierPath *TextPathContentPlay();
UIBezierPath *TextPathContentQuit();
UIBezierPath *TextPathContentResume();
UIBezierPath *TextPathContentStats();
UIBezierPath *TextPathDialogGameOver();
UIBezierPath *TextPathDialogPaused();
UIBezierPath *TextPathDialogReady();

UIBezierPath *TextPathChoiceRowLeftColors();
UIBezierPath *TextPathChoiceRowLeftSounds();
UIBezierPath *TextPathChoiceRowLeftStats();
UIBezierPath *TextPathChoiceRowLeftGameKeys();

UIBezierPath *TextPathChoiceRowRightUpSpell();
UIBezierPath *TextPathChoiceRowRightRules();
UIBezierPath *TextPathChoiceRowRightLegal();
UIBezierPath *TextPathChoiceRowRightThanks();

}  // namespace UP

#endif  // __cplusplus
