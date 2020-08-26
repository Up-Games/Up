//
//  UPAccessoryPaneController.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPAccessoryPane;
@class UPButton;
@class UPBallot;
@class UPChoice;

@interface UPAccessoryPaneController : UIViewController

@property (nonatomic) UPButton *backButton;
@property (nonatomic) UPChoice *choice1;
@property (nonatomic) UPChoice *choice2;
@property (nonatomic) UPChoice *choice3;
@property (nonatomic) UPChoice *choice4;
@property (nonatomic) UPAccessoryPane *selectedPane;
@property (nonatomic) NSArray<UPChoice *> *choices;
@property (nonatomic) NSArray<UPAccessoryPane *> *panes;

- (void)setSelectedPaneFromSettingsWithDuration:(CFTimeInterval)duration;
- (void)setSelectedPane:(UPAccessoryPane *)selectedPane duration:(CFTimeInterval)duration;

- (void)choiceSelected:(UPChoice *)sender;

- (void)lock;
- (void)unlock;

@end
