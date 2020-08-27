//
//  UPSpellAboutController.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPButton.h>

#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutController.h"
#import "UPSpellAboutPaneGame.h"
#import "UPSpellAboutPaneLexicon.h"
#import "UPSpellAboutPanePlaying.h"
#import "UPSpellAboutPaneThanks.h"
#import "UPSpellSettings.h"
#import "UPSpellLayout.h"

@interface UPSpellAboutController ()
@property (nonatomic) UPSpellAboutPaneGame *gamePane;
@property (nonatomic) UPSpellAboutPanePlaying *playingPane;
@property (nonatomic) UPSpellAboutPaneLexicon *lexiconPane;
@property (nonatomic) UPSpellAboutPaneThanks *thanksPane;
@end

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;
using Place = UP::SpellLayout::Place;

static UPSpellAboutController *_Instance;

@implementation UPSpellAboutController

+ (UPSpellAboutController *)instance
{
    return _Instance;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    _Instance = self;
    
    SpellLayout &layout = SpellLayout::instance();
    
    self.backButton = [UPButton roundBackButtonRightArrow];
    self.backButton.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    self.backButton.frame = layout.frame_for(Role::ChoiceBackRight, Place::OffRightNear);
    self.backButton.chargeOutsets = UPOutsetsMake(0, 200 * layout.layout_scale(), 0, 0);
    [self.view addSubview:self.backButton];
    
    self.choice1 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice1.labelString = @"UP SPELL";
    self.choice1.tag = 0;
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Right, Place::OffRightNear);
    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice2.labelString = @"PLAYING";
    self.choice2.tag = 1;
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Right, Place::OffRightNear);
    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice3.labelString = @"LEXICON";
    self.choice3.tag = 2;
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Right, Place::OffRightNear);
    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice3];
    
    self.choice4 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice4.labelString = @"THANKS";
    self.choice4.tag = 3;
    self.choice4.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice4.frame = layout.frame_for(Role::ChoiceItem4Right, Place::OffRightNear);
    [self.choice4 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice4];

    self.gamePane = [UPSpellAboutPaneGame pane];
    self.gamePane.center = layout.center_for(Role::Screen, Place::OffBottomFar);
    [self.view addSubview:self.gamePane];
    
    self.playingPane = [UPSpellAboutPanePlaying pane];
    self.playingPane.center = layout.center_for(Role::Screen, Place::OffBottomFar);
    [self.view addSubview:self.playingPane];
    
    self.lexiconPane = [UPSpellAboutPaneLexicon pane];
    self.lexiconPane.center = layout.center_for(Role::Screen, Place::OffBottomFar);
    [self.view addSubview:self.lexiconPane];

    self.thanksPane = [UPSpellAboutPaneThanks pane];
    self.thanksPane.center = layout.center_for(Role::Screen, Place::OffBottomFar);
    [self.view addSubview:self.thanksPane];

    self.choices = @[ self.choice1, self.choice2, self.choice3, self.choice4 ];
    
    self.panes = @[
        self.gamePane,
        self.playingPane,
        self.lexiconPane,
        self.thanksPane
    ];

    return self;
}

#pragma mark - Overrides

- (void)choiceSelected:(UPChoice *)sender
{
    for (UPChoice *choice in self.choices) {
        if (choice != sender) {
            choice.selected = NO;
            [choice invalidate];
            [choice update];
        }
    }
    
    NSUInteger aboutSelectedIndex = sender.tag;
    [self setSelectedPane:self.panes[aboutSelectedIndex] duration:0.5];
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.aboutSelectedIndex = aboutSelectedIndex;
}

- (void)setSelectedPaneFromSettingsWithDuration:(CFTimeInterval)duration
{
    UPSpellSettings *settings = [UPSpellSettings instance];
    NSUInteger index = settings.aboutSelectedIndex;
    ASSERT(index < self.choices.count);
    UPChoice *choice = self.choices[index];
    choice.selected = YES;
    [self setSelectedPane:self.panes[index] duration:duration];
}

@end
