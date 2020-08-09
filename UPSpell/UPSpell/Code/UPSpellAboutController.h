//
//  UPSpellAboutController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPChoice;
@class UPAccessoryPane;

@interface UPSpellAboutController : UIViewController
@property (nonatomic, readonly) UPButton *backButton;
@property (nonatomic, readonly) UPChoice *choice1;
@property (nonatomic, readonly) UPChoice *choice2;
@property (nonatomic, readonly) UPChoice *choice3;
@property (nonatomic, readonly) UPChoice *choice4;
@property (nonatomic, readonly) UPAccessoryPane *selectedPane;
@end
