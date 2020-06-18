//
//  UPTextPaths.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIBezierPath.h>

#if __cplusplus

namespace UP {

UIBezierPath *TextPathContentAbout();
UIBezierPath *TextPathContentExtras();
UIBezierPath *TextPathContentPlay();
UIBezierPath *TextPathContentQuit();
UIBezierPath *TextPathContentResume();
UIBezierPath *TextPathContentStats();
UIBezierPath *TextPathDialogGameOver();
UIBezierPath *TextPathDialogPaused();
UIBezierPath *TextPathDialogReady();

UIBezierPath *TextPathChoiceLeftColors();
UIBezierPath *TextPathChoiceLeftSounds();
UIBezierPath *TextPathChoiceLeftStats();
UIBezierPath *TextPathChoiceLeftGameKeys();

UIBezierPath *TextPathChoiceRightUpSpell();
UIBezierPath *TextPathChoiceRightRules();
UIBezierPath *TextPathChoiceRightLegal();
UIBezierPath *TextPathChoiceRightThanks();

}  // namespace UP

#endif  // __cplusplus
