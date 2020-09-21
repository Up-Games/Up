//
//  UPSpellExtrasController.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPButton.h>

#import "UPAccessoryPane.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPSpellExtrasController.h"
#import "UPSpellExtrasPaneHowTo.h"
#import "UPSpellExtrasPaneColors.h"
#import "UPSpellExtrasPaneSound.h"
#import "UPSpellExtrasPaneShare.h"
#import "UPSpellExtrasPaneAbout.h"
#import "UPSpellLayout.h"
#import "UPSpellSettings.h"

@interface UPSpellExtrasController ()
@property (nonatomic) UPSpellExtrasPaneHowTo *howToPane;
@property (nonatomic) UPSpellExtrasPaneColors *colorsPane;
@property (nonatomic) UPSpellExtrasPaneSound *soundPane;
@property (nonatomic) UPSpellExtrasPaneShare *sharePane;
@property (nonatomic) UPSpellExtrasPaneAbout *aboutPane;
@end

using UP::SpellLayout;

using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;
using Location = UP::SpellLayout::Location;

static UPSpellExtrasController *_Instance;

@implementation UPSpellExtrasController

+ (UPSpellExtrasController *)instance
{
    return _Instance;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _Instance = self;
    return self;
}

- (void)delayedInit
{
    SpellLayout &layout = SpellLayout::instance();

    self.backButton = [UPButton roundBackButtonLeftArrow];
    self.backButton.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    self.backButton.frame = layout.frame_for(Role::ChoiceBackLeft, Spot::OffLeftNear);
    self.backButton.chargeOutsets = UPOutsetsMake(0, 0, 0, 200 * layout.layout_scale());
    [self.view addSubview:self.backButton];

    self.choice1 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice1.labelString = @"HOW-TO";
    self.choice1.tag = 0;
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Left, Spot::OffLeftNear);
    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice2.labelString = @"THEME";
    self.choice2.tag = 1;
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Left, Spot::OffLeftNear);
    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice3.labelString = @"SOUND";
    self.choice3.tag = 2;
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Left, Spot::OffLeftNear);
    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice3];
    
    self.choice4 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice4.labelString = @"SHARE";
    self.choice4.tag = 3;
    self.choice4.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice4.frame = layout.frame_for(Role::ChoiceItem4Left, Spot::OffLeftNear);
    [self.choice4 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice4];
    
    self.choice5 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice5.labelString = @"ABOUT";
    self.choice5.tag = 4;
    self.choice5.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice5.frame = layout.frame_for(Role::ChoiceItem5Left, Spot::OffLeftNear);
    [self.choice5 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice5];

    self.howToPane = [UPSpellExtrasPaneHowTo pane];
    self.howToPane.center = layout.center_for(Role::Screen, Spot::OffBottomFar);
    [self.view addSubview:self.howToPane];

    self.colorsPane = [UPSpellExtrasPaneColors pane];
    self.colorsPane.center = layout.center_for(Role::Screen, Spot::OffBottomFar);
    [self.view addSubview:self.colorsPane];
    
    self.soundPane = [UPSpellExtrasPaneSound pane];
    self.soundPane.center = layout.center_for(Role::Screen, Spot::OffBottomFar);
    [self.view addSubview:self.soundPane];
    
    self.sharePane = [UPSpellExtrasPaneShare pane];
    self.sharePane.center = layout.center_for(Role::Screen, Spot::OffBottomFar);
    [self.view addSubview:self.sharePane];
    
    self.aboutPane = [UPSpellExtrasPaneAbout pane];
    self.aboutPane.center = layout.center_for(Role::Screen, Spot::OffBottomFar);
    [self.view addSubview:self.aboutPane];
    
    self.choices = @[ self.choice1, self.choice2, self.choice3, self.choice4, self.choice5 ];

    self.panes = @[
        self.howToPane,
        self.colorsPane,
        self.soundPane,
        self.sharePane,
        self.aboutPane,
    ];
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
    
    NSUInteger extrasSelectedIndex = sender.tag;
    [self setSelectedPane:self.panes[extrasSelectedIndex] duration:0.5];
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.extrasSelectedIndex = extrasSelectedIndex;
}

- (void)setSelectedPaneFromSettingsWithDuration:(CFTimeInterval)duration
{
    UPSpellSettings *settings = [UPSpellSettings instance];
    NSUInteger index = settings.extrasSelectedIndex;
    ASSERT(index < self.choices.count);
    UPChoice *choice = self.choices[index];
    choice.selected = YES;
    [self setSelectedPane:self.panes[index] duration:duration];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.colorsPane updateThemeColors];
}

@end
