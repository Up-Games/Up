//
//  UPControl+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>

@interface UPControl (UPSpell)

+ (UPControl *)roundButtonPause;
+ (UPControl *)roundButtonTrash;
+ (UPControl *)roundButtonClear;
+ (UPControl *)wordTray;

+ (UPControl *)textButtonAbout;
+ (UPControl *)textButtonExtras;
+ (UPControl *)textButtonMenu;
+ (UPControl *)textButtonPlay;
+ (UPControl *)textButtonQuit;
+ (UPControl *)textButtonResume;

@end
