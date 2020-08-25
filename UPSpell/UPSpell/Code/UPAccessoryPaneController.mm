//
//  UPAccessoryPaneController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPButton.h>
#import <UpKit/UPTimeSpanning.h>
#import <UpKit/UPViewMove.h>

#import "UIFont+UPSpell.h"
#import "UPAccessoryPane.h"
#import "UPBallot.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPAccessoryPaneController.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPViewMove+UPSpell.h"

@interface UPAccessoryPaneController ()
@end

using UP::SpellLayout;
using UP::BandSettingsUI;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

using Role = UP::SpellLayout::Role;
using Place = UP::SpellLayout::Place;
using Location = UP::SpellLayout::Location;

@implementation UPAccessoryPaneController

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

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.view.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
