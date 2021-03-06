//
//  UPAccessoryPaneController.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
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
using Spot = UP::SpellLayout::Spot;
using Location = UP::SpellLayout::Location;

@implementation UPAccessoryPaneController

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

- (void)delayedInit
{
    }

- (void)choiceSelected:(UPChoice *)sender
{
}

- (void)setSelectedPaneFromSettingsWithDuration:(CFTimeInterval)duration
{
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
    
    if (previousSelectedPane) {
        [previousSelectedPane finish];
    }
    
    if (selectedPane) {
        [self.view bringSubviewToFront:selectedPane];
        [selectedPane prepare];
    }
    
    if (up_is_fuzzy_zero(duration)) {
        if (previousSelectedPane) {
            previousSelectedPane.center = layout.center_for(Role::Screen, Spot::OffTopFar);
        }
        if (selectedPane) {
            selectedPane.center = layout.center_for(Role::Screen);
        }
    }
    else {
        [self lock];
        
        selectedPane.center = layout.center_for(Role::Screen, Spot::OffBottomFar);
        if (previousSelectedPane && previousSelectedPane != selectedPane) {
            NSArray *outMoves = @[UPViewMoveMake(previousSelectedPane, Role::Screen, Spot::OffTopFar)];
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
