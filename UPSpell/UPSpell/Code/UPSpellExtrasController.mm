//
//  UPSpellExtrasController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPButton.h>
#import <UpKit/UPChoice.h>
#import <UpKit/UPTouchGestureRecognizer.h>

#import "UPCheckbox.h"
#import "UPControl+UPSpell.h"
#import "UPHueStepperIndicator.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPStepper.h"
#import "UPTextPaths.h"

@interface UPSpellExtrasController () <UPHueWheelDelegate, UPHueStepperIndicatorDelegate>
@property (nonatomic, readwrite) UPButton *backButton;
@property (nonatomic, readwrite) UPChoice *choice1;
@property (nonatomic, readwrite) UPChoice *choice2;
@property (nonatomic, readwrite) UPChoice *choice3;
@property (nonatomic, readwrite) UPChoice *choice4;
@property (nonatomic, readwrite) UPLabel *modesLabel;
@property (nonatomic, readwrite) UPCheckbox *darkModeCheckbox;
@property (nonatomic, readwrite) UPCheckbox *starkModeCheckbox;
@property (nonatomic, readwrite) UPCheckbox *quarkModeCheckbox;
@property (nonatomic, readwrite) UPHueWheel *hueWheel;
@property (nonatomic, readwrite) UPHueStepperIndicator *hueStepperIndicator;
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
    
    self.modesLabel = [UPLabel label];
    self.modesLabel.textColorCategory = UPColorCategoryDialogTitle;
    self.modesLabel.string = @"MODES:";
    self.modesLabel.font = layout.checkbox_font();
    [self.modesLabel sizeToFit];
    self.modesLabel.frame = CGRectMake(350, 71.5, up_rect_width(self.modesLabel.bounds), up_rect_height(self.modesLabel.bounds));
    [self.view addSubview:self.modesLabel];

    self.darkModeCheckbox = [UPCheckbox checkbox];
    self.darkModeCheckbox.labelString = @"DARK";
    self.darkModeCheckbox.frame = CGRectMake(455, 70, up_size_width(self.darkModeCheckbox.canonicalSize), up_size_height(self.darkModeCheckbox.canonicalSize));
    [self.view addSubview:self.darkModeCheckbox];
    
    self.starkModeCheckbox = [UPCheckbox checkbox];
    self.starkModeCheckbox.labelString = @"STARK";
    self.starkModeCheckbox.frame = CGRectMake(580, 70, up_size_width(self.starkModeCheckbox.canonicalSize), up_size_height(self.starkModeCheckbox.canonicalSize));
    [self.view addSubview:self.starkModeCheckbox];
    
    self.quarkModeCheckbox = [UPCheckbox checkbox];
    self.quarkModeCheckbox.labelString = @"QUARK";
    self.quarkModeCheckbox.frame = CGRectMake(710, 70, up_size_width(self.quarkModeCheckbox.canonicalSize), up_size_height(self.quarkModeCheckbox.canonicalSize));
    [self.view addSubview:self.quarkModeCheckbox];
    
    self.hueWheel = [UPHueWheel hueWheel];
    self.hueWheel.frame = CGRectMake(435, 130, 170, 170);
    self.hueWheel.delegate = self;
    [self.view addSubview:self.hueWheel];
    
    self.hueStepperIndicator = [UPHueStepperIndicator hueStepperIndicator];
    self.hueStepperIndicator.frame = CGRectMake(644, 130, 118, 170);
    self.hueStepperIndicator.delegate = self;
    [self.view addSubview:self.hueStepperIndicator];
    return self;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

#pragma mark - Hue Controls

- (void)hueWheelDidUpdate:(UPHueWheel *)hueWheel
{
    self.hueStepperIndicator.hue = self.hueWheel.hue;
}

- (void)hueStepperIndicatorDidUpdate:(UPHueStepperIndicator *)hueStepperIndicator
{
    [self.hueWheel cancelAnimations];
    self.hueWheel.hue = self.hueStepperIndicator.hue;
}

#pragma mark - Target / Action

- (void)choiceSelected:(UPChoice *)sender
{
    if (self.choice1 != sender) {
        self.choice1.selected = NO;
    }
    if (self.choice2 != sender) {
        self.choice2.selected = NO;
    }
    if (self.choice3 != sender) {
        self.choice3.selected = NO;
    }
    if (self.choice4 != sender) {
        self.choice4.selected = NO;
    }
}

@end
