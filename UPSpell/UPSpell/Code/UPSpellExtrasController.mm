//
//  UPSpellExtrasController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIDevice+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPButton.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTouchGestureRecognizer.h>

#import "UIFont+UPSpell.h"
#import "UPCheckbox.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasController.h"
#import "UPSpellExtrasColorsPane.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextPaths.h"
#import "UPTileView.h"

@interface UPSpellExtrasController ()
@property (nonatomic, readwrite) UPButton *backButton;
@property (nonatomic, readwrite) UPChoice *choice1;
@property (nonatomic, readwrite) UPChoice *choice2;
@property (nonatomic, readwrite) UPChoice *choice3;
@property (nonatomic, readwrite) UPChoice *choice4;

@property (nonatomic) UPSpellExtrasColorsPane *colorsPane;

@end

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

@implementation UPSpellExtrasController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    SpellLayout &layout = SpellLayout::instance();

    self.backButton = [UPButton roundBackButtonLeftArrow];
    self.backButton.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    self.backButton.frame = layout.frame_for(Role::ChoiceBackLeft, Spot::OffLeftNear);
    [self.view addSubview:self.backButton];

    self.choice1 = [UPChoice choiceLeftColors];
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Left, Spot::OffLeftNear);
    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceLeftSounds];
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Left, Spot::OffLeftNear);
    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceLeftStats];
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Left, Spot::OffLeftNear);
    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice3];
    
    self.choice4 = [UPChoice choiceLeftGameKeys];
    self.choice4.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice4.frame = layout.frame_for(Role::ChoiceItem4Left, Spot::OffLeftNear);
    [self.choice4 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice4];

    self.colorsPane = [[UPSpellExtrasColorsPane alloc] initWithFrame:layout.screen_bounds()];
    [self.view addSubview:self.colorsPane];

    return self;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

- (void)choiceSelected:(UPChoice *)sender
{
    if (self.choice1 != sender) {
        self.choice1.selected = NO;
        [self.choice1 invalidate];
        [self.choice1 update];
    }
    if (self.choice2 != sender) {
        self.choice2.selected = NO;
        [self.choice2 invalidate];
        [self.choice2 update];
    }
    if (self.choice3 != sender) {
        self.choice3.selected = NO;
        [self.choice3 invalidate];
        [self.choice3 update];
    }
    if (self.choice4 != sender) {
        self.choice4.selected = NO;
        [self.choice4 invalidate];
        [self.choice4 update];
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
}

@end
