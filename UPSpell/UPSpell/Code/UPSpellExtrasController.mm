//
//  UPSpellExtrasController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UIDevice+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPButton.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>
#import <UpKit/UPTouchGestureRecognizer.h>
#import <UpKit/UPViewMove.h>

#import "UIFont+UPSpell.h"
#import "UPAccessoryPane.h"
#import "UPBallot.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasController.h"
#import "UPSpellExtrasPaneColors.h"
#import "UPSpellExtrasPaneRetry.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextPaths.h"
#import "UPTileView.h"
#import "UPViewMove+UPSpell.h"

@interface UPSpellExtrasController ()
@property (nonatomic, readwrite) UPButton *backButton;
@property (nonatomic, readwrite) UPChoice *choice1;
@property (nonatomic, readwrite) UPChoice *choice2;
@property (nonatomic, readwrite) UPChoice *choice3;
@property (nonatomic, readwrite) UPChoice *choice4;
@property (nonatomic, readwrite) UPAccessoryPane *selectedPane;

@property (nonatomic) UPSpellExtrasPaneColors *colorsPane;
@property (nonatomic) UPSpellExtrasPaneRetry *repeatPane;

@property (nonatomic) NSArray<UPChoice *> *choices;
@property (nonatomic) NSArray<UPAccessoryPane *> *panes;

@end

using UP::SpellLayout;
using UP::BandSettingsUI;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;
using UP::TimeSpanning::slide;

using UP::TimeSpanning::cancel_all;
using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::find_move;
using UP::TimeSpanning::start;

using Role = UP::SpellLayout::Role;
using Place = UP::SpellLayout::Place;
using Location = UP::SpellLayout::Location;

@implementation UPSpellExtrasController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    SpellLayout &layout = SpellLayout::instance();

    self.backButton = [UPButton roundBackButtonLeftArrow];
    self.backButton.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    self.backButton.frame = layout.frame_for(Role::ChoiceBackLeft, Place::OffLeftNear);
    self.backButton.chargeOutsets = UPOutsetsMake(0, 0, 0, 200 * layout.layout_scale());
    [self.view addSubview:self.backButton];

    self.choice1 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice1.labelString = @"COLOR";
    self.choice1.tag = 0;
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Left, Place::OffLeftNear);
    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice2.labelString = @"SOUND";
    self.choice2.tag = 1;
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Left, Place::OffLeftNear);
    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice3.labelString = @"REPEAT";
    self.choice3.tag = 2;
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Left, Place::OffLeftNear);
    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice3];
    
    self.choice4 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice4.labelString = @"SHARE";
    self.choice4.tag = 3;
    self.choice4.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice4.frame = layout.frame_for(Role::ChoiceItem4Left, Place::OffLeftNear);
    [self.choice4 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice4];

    self.colorsPane = [UPSpellExtrasPaneColors pane];
    self.colorsPane.center = layout.center_for(Role::Screen, Place::OffBottomFar);
    [self.view addSubview:self.colorsPane];

    self.repeatPane = [UPSpellExtrasPaneRetry pane];
    self.repeatPane.center = layout.center_for(Role::Screen, Place::OffBottomFar);
    [self.view addSubview:self.repeatPane];
    
    self.choices = @[ self.choice1, self.choice2, self.choice3, self.choice4 ];
    
    self.panes = @[
        self.colorsPane,
        [UPAccessoryPane pane],
        self.repeatPane,
        [UPAccessoryPane pane],
    ];
    
    return self;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

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

- (void)setSelectedPane:(UPAccessoryPane *)selectedPane
{
    [self setSelectedPane:selectedPane duration:0];
}

- (void)setSelectedPane:(UPAccessoryPane *)selectedPane duration:(CFTimeInterval)duration
{
    [self cancelAnimations];
    
    SpellLayout &layout = SpellLayout::instance();

    UPAccessoryPane *previousSelectedPane = _selectedPane;
    _selectedPane = selectedPane;
    
    if (selectedPane) {
        [self.view bringSubviewToFront:selectedPane];
        [selectedPane prepare];
    }
    
    if (up_is_fuzzy_zero(duration)) {
        if (previousSelectedPane) {
            previousSelectedPane.center = layout.center_for(Role::Screen, Place::OffTopFar);
        }
        if (selectedPane) {
            selectedPane.center = layout.center_for(Role::Screen);
        }
    }
    else {
        [self lock];
        
        selectedPane.center = layout.center_for(Role::Screen, Place::OffBottomFar);
        if (previousSelectedPane && previousSelectedPane != selectedPane) {
            NSArray *outMoves = @[UPViewMoveMake(previousSelectedPane, Role::Screen, Place::OffTopFar)];
            start(bloop_out(BandSettingsUI, outMoves, duration,
                            ^(UIViewAnimatingPosition) {
                start(bloop_in(BandSettingsUI, @[UPViewMoveMake(selectedPane, Role::Screen)], duration, ^(UIViewAnimatingPosition) {
                    [self unlock];
                }));
            }));
        }
        else {
            start(bloop_in(BandSettingsUI, @[UPViewMoveMake(selectedPane, Role::Screen)], duration, ^(UIViewAnimatingPosition) {
                [self unlock];
            }));
        }
    }
}

- (void)lock
{
    for (UPAccessoryPane *pane in self.panes) {
        pane.userInteractionEnabled = NO;
    }
    for (UPChoice *choice in self.choices) {
        choice.userInteractionEnabled = NO;
    }
}

- (void)unlock
{
    for (UPAccessoryPane *pane in self.panes) {
        pane.userInteractionEnabled = YES;
    }
    for (UPChoice *choice in self.choices) {
        choice.userInteractionEnabled = YES;
    }
}

- (void)cancelAnimations
{
    [self.colorsPane cancelAnimations];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.view.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.colorsPane updateThemeColors];
}

@end
