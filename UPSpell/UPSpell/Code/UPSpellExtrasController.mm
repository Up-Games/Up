//
//  UPSpellExtrasController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPButton.h>
#import <UpKit/UPChoice.h>
#import <UpKit/UPDelayedAction.h>
#import <UpKit/UPTouchGestureRecognizer.h>

#import "UIFont+UPSpell.h"
#import "UPCheckbox.h"
#import "UPControl+UPSpell.h"
#import "UPHueStepperIndicator.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
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
@property (nonatomic, readwrite) UPLabel *hueDescription;
@property (nonatomic) UPDelayedAction *settingsDelayedAction;
@end

using UP::BandSettingsUpdateDelay;
using UP::SpellLayout;
using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
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
    self.modesLabel.textColorCategory = UPColorCategoryControlText;
    self.modesLabel.string = @"MODES:";
    self.modesLabel.font = layout.checkbox_font();
    [self.modesLabel sizeToFit];
    self.modesLabel.frame = CGRectMake(350, 71.5, up_rect_width(self.modesLabel.bounds), up_rect_height(self.modesLabel.bounds));
    [self.view addSubview:self.modesLabel];

    self.darkModeCheckbox = [UPCheckbox checkbox];
    self.darkModeCheckbox.labelString = @"DARK";
    [self.darkModeCheckbox setTarget:self action:@selector(darkModeCheckboxTapped)];
    self.darkModeCheckbox.frame = CGRectMake(455, 70, up_size_width(self.darkModeCheckbox.canonicalSize), up_size_height(self.darkModeCheckbox.canonicalSize));
    [self.view addSubview:self.darkModeCheckbox];
    
    self.starkModeCheckbox = [UPCheckbox checkbox];
    self.starkModeCheckbox.labelString = @"STARK";
    [self.starkModeCheckbox setTarget:self action:@selector(starkModeCheckboxTapped)];
    self.starkModeCheckbox.frame = CGRectMake(580, 70, up_size_width(self.starkModeCheckbox.canonicalSize), up_size_height(self.starkModeCheckbox.canonicalSize));
    [self.view addSubview:self.starkModeCheckbox];
    
    self.quarkModeCheckbox = [UPCheckbox checkbox];
    self.quarkModeCheckbox.labelString = @"QUARK";
    [self.quarkModeCheckbox setTarget:self action:@selector(quarkModeCheckboxTapped)];
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

    self.hueDescription = [UPLabel label];
    self.hueDescription.frame = CGRectMake(350, 314, 470, 100);
    self.hueDescription.font = [UIFont settingsDescriptionFontOfSize:22];
    self.hueDescription.textColorCategory = UPColorCategoryControlText;
    self.hueDescription.backgroundColorCategory = UPColorCategoryClear;
    self.hueDescription.textAlignment = NSTextAlignmentCenter;
    self.hueDescription.string = @"Colors based on hue #10 with more outlined shapes\nthan filled-in shapes on a light background";
    [self.view addSubview:self.hueDescription];

    UPSpellSettings *settings = [UPSpellSettings instance];
    UPThemeColorStyle themeColorStyle = settings.themeColorStyle;
    switch (themeColorStyle) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
            self.darkModeCheckbox.selected = NO;
            self.starkModeCheckbox.selected = NO;
            break;
        case UPThemeColorStyleDark:
            self.darkModeCheckbox.selected = YES;
            self.starkModeCheckbox.selected = NO;
            break;
        case UPThemeColorStyleLightStark:
            self.darkModeCheckbox.selected = NO;
            self.starkModeCheckbox.selected = YES;
            break;
        case UPThemeColorStyleDarkStark:
            self.darkModeCheckbox.selected = YES;
            self.starkModeCheckbox.selected = YES;
            break;
    }
    
    CGFloat themeColorHue = settings.themeColorHue;
    self.hueWheel.hue = themeColorHue;
    self.hueStepperIndicator.hue = themeColorHue;

    return self;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

- (void)cancelAnimations
{
    [self.hueWheel cancelAnimations];
}

#pragma mark - Hue Controls

- (void)hueWheelDidUpdate:(UPHueWheel *)hueWheel
{
    CGFloat hue = self.hueWheel.hue;
    self.hueStepperIndicator.hue = hue;
    [UIColor setThemeColorHue:hue];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPThemeColorsChangedNotification object:nil];
}

- (void)hueWheelFinishedUpdating:(UPHueWheel *)hueWheel
{
    CGFloat hue = self.hueWheel.hue;
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.themeColorHue = hue;
}

- (void)hueStepperIndicatorDidUpdate:(UPHueStepperIndicator *)hueStepperIndicator
{
    [self.hueWheel cancelAnimations];
    CGFloat hue = self.hueStepperIndicator.hue;
    self.hueWheel.hue = hue;
    [UIColor setThemeColorHue:hue];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPThemeColorsChangedNotification object:nil];

    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.themeColorHue = hue;
}

- (void)updateHueDescription
{
    
}

#pragma mark - Target / Action

- (void)darkModeCheckboxTapped
{
    UPThemeColorStyle themeColorStyle = [UIColor themeColorStyle];
    if (self.darkModeCheckbox.selected) {
        switch (themeColorStyle) {
            case UPThemeColorStyleDefault:
            case UPThemeColorStyleLight:
                themeColorStyle = UPThemeColorStyleDark;
                break;
            case UPThemeColorStyleLightStark:
                themeColorStyle = UPThemeColorStyleDarkStark;
                break;
            case UPThemeColorStyleDark:
            case UPThemeColorStyleDarkStark:
                // no-op
                break;
        }
    }
    else {
        switch (themeColorStyle) {
            case UPThemeColorStyleDefault:
            case UPThemeColorStyleLight:
            case UPThemeColorStyleLightStark:
                // no-op
                break;
            case UPThemeColorStyleDark:
                themeColorStyle = UPThemeColorStyleLight;
                break;
            case UPThemeColorStyleDarkStark:
                themeColorStyle = UPThemeColorStyleLightStark;
                break;
        }
    }
    [UIColor setThemeColorStyle:themeColorStyle];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPThemeColorsChangedNotification object:nil];

    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.themeColorStyle = themeColorStyle;
}

- (void)starkModeCheckboxTapped
{
    UPThemeColorStyle themeColorStyle = [UIColor themeColorStyle];
    if (self.starkModeCheckbox.selected) {
        switch (themeColorStyle) {
            case UPThemeColorStyleDefault:
            case UPThemeColorStyleLight:
                themeColorStyle = UPThemeColorStyleLightStark;
                break;
            case UPThemeColorStyleDark:
                themeColorStyle = UPThemeColorStyleDarkStark;
                break;
            case UPThemeColorStyleLightStark:
            case UPThemeColorStyleDarkStark:
                // no-op
                break;
        }
    }
    else {
        switch (themeColorStyle) {
            case UPThemeColorStyleDefault:
            case UPThemeColorStyleLight:
            case UPThemeColorStyleDark:
                // no-op
                break;
            case UPThemeColorStyleLightStark:
                themeColorStyle = UPThemeColorStyleLight;
                break;
            case UPThemeColorStyleDarkStark:
                themeColorStyle = UPThemeColorStyleDark;
                break;
        }
    }
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.themeColorStyle = themeColorStyle;
    [UIColor setThemeColorStyle:themeColorStyle];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPThemeColorsChangedNotification object:nil];
}

- (void)quarkModeCheckboxTapped
{
}

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

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.view.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
