//
//  UPSpellExtrasController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
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
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextPaths.h"
#import "UPTileView.h"

@interface UPSpellExtrasController () <UPHueWheelDelegate>
@property (nonatomic, readwrite) UPButton *backButton;
@property (nonatomic, readwrite) UPChoice *choice1;
@property (nonatomic, readwrite) UPChoice *choice2;
@property (nonatomic, readwrite) UPChoice *choice3;
@property (nonatomic, readwrite) UPChoice *choice4;
@property (nonatomic, readwrite) UPDivider *divider;

@property (nonatomic, readwrite) CGFloat hue;
@property (nonatomic, readwrite) UPLabel *modesLabel;
@property (nonatomic, readwrite) UPCheckbox *darkModeCheckbox;
@property (nonatomic, readwrite) UPCheckbox *starkModeCheckbox;
@property (nonatomic, readwrite) UPCheckbox *quarkModeCheckbox;
@property (nonatomic, readwrite) UPHueWheel *hueWheel;
@property (nonatomic, readwrite) UPStepper *hueStepLess;
@property (nonatomic, readwrite) UPStepper *hueStepMore;
@property (nonatomic) UPLabel *hueDescription;
@property (nonatomic) UIView *exampleTilesContainer;

@end

using UP::BandSettingsUI;
using UP::BandSettingsUpdateDelay;
using UP::SpellLayout;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;

using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

static const int HueCount = 360;
static const int MilepostHue = 15;

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
    
//    self.divider = [UPDivider divider];
//    self.divider.frame = CGRectMake(312, 0, 3 * layout.layout_scale(), up_rect_height(layout.screen_bounds()));
//    self.divider.colorCategory = UPColorCategoryPrimaryStroke;
//    [self.view addSubview:self.divider];

    self.darkModeCheckbox = [UPCheckbox checkbox];
    self.darkModeCheckbox.labelString = @"DARK";
    [self.darkModeCheckbox setTarget:self action:@selector(darkModeCheckboxTapped)];
    self.darkModeCheckbox.frame = CGRectMake(670, 34, up_size_width(self.darkModeCheckbox.canonicalSize), up_size_height(self.darkModeCheckbox.canonicalSize));
    [self.view addSubview:self.darkModeCheckbox];
    
    self.starkModeCheckbox = [UPCheckbox checkbox];
    self.starkModeCheckbox.labelString = @"STARK";
    [self.starkModeCheckbox setTarget:self action:@selector(starkModeCheckboxTapped)];
    self.starkModeCheckbox.frame = CGRectMake(670, 94, up_size_width(self.starkModeCheckbox.canonicalSize), up_size_height(self.starkModeCheckbox.canonicalSize));
    [self.view addSubview:self.starkModeCheckbox];
    
    self.quarkModeCheckbox = [UPCheckbox checkbox];
    self.quarkModeCheckbox.labelString = @"QUARK";
    [self.quarkModeCheckbox setTarget:self action:@selector(quarkModeCheckboxTapped)];
    self.quarkModeCheckbox.frame = CGRectMake(670, 154, up_size_width(self.quarkModeCheckbox.canonicalSize), up_size_height(self.quarkModeCheckbox.canonicalSize));
    [self.view addSubview:self.quarkModeCheckbox];
    
    self.hueWheel = [UPHueWheel hueWheel];
    self.hueWheel.frame = CGRectMake(380, 26, 170, 170);
    self.hueWheel.delegate = self;
    [self.view addSubview:self.hueWheel];
    
    self.hueStepMore = [UPStepper stepperWithDirection:UPStepperDirectionUp];
    [self.hueStepMore setTarget:self action:@selector(handleHueStepMore)];
    self.hueStepMore.frame = CGRectMake(580, 71, 36, 36);
    [self.view addSubview:self.hueStepMore];

    self.hueStepLess = [UPStepper stepperWithDirection:UPStepperDirectionDown];
    [self.hueStepLess setTarget:self action:@selector(handleHueStepLess)];
    self.hueStepLess.frame = CGRectMake(580, 121, 36, 36);
    [self.view addSubview:self.hueStepLess];

    self.hueDescription = [UPLabel label];
    self.hueDescription.frame = CGRectMake(350, 214, 470, 60);
    self.hueDescription.font = [UIFont settingsDescriptionFontOfSize:23];
    self.hueDescription.textColorCategory = UPColorCategoryControlText;
    self.hueDescription.backgroundColorCategory = UPColorCategoryClear;
    self.hueDescription.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hueDescription];
    
    CGRect examplesFrame = CGRectMake(0, 0, SpellLayout::CanonicalTilesLayoutWidth, up_size_height(SpellLayout::CanonicalTileSize));
    self.exampleTilesContainer = [[UPContainerView alloc] initWithFrame:examplesFrame];
    [self.view addSubview:self.exampleTilesContainer];

    CGFloat tileX = 0;
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        TileModel model;
        switch (idx) {
            case 0:
                model = TileModel(U'E');
                break;
            case 1:
                model = TileModel(U'X');
                break;
            case 2:
                model = TileModel(U'A');
                break;
            case 3:
                model = TileModel(U'M');
                break;
            case 4:
                model = TileModel(U'P');
                break;
            case 5:
                model = TileModel(U'L');
                break;
            case 6:
                model = TileModel(U'E');
                break;
        }
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tileView.band = BandSettingsUI;
        tileView.frame = CGRectMake(tileX, 0, up_size_width(SpellLayout::CanonicalTileSize), up_size_height(SpellLayout::CanonicalTileSize));
        [self.exampleTilesContainer addSubview:tileView];
        [tileView addGestureRecognizer:[UPTapGestureRecognizer gestureWithTarget:self action:@selector(handleTappedTile:)]];
        tileX += up_size_width(SpellLayout::CanonicalTileSize) + SpellLayout::CanonicalTileGap;
    }
    self.exampleTilesContainer.transform = CGAffineTransformMakeScale(0.55, 0.55);
    self.exampleTilesContainer.center = CGPointMake(590, 330);
    
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

    [self updateHueDescription];

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

- (void)handleTappedTile:(UPTapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    UPTileView *tileView = nil;
    if ([view isKindOfClass:[UPTileView class]]) {
        tileView = (UPTileView *)view;
    }
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible: {
            break;
        }
        case UIGestureRecognizerStateBegan: {
            tileView.highlighted = gesture.touchInside;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            tileView.highlighted = gesture.touchInside;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            tileView.highlighted = NO;
            break;
        }
    }
}

#pragma mark - Hue Controls

- (void)hueWheelDidUpdate:(UPHueWheel *)hueWheel
{
    CGFloat hue = self.hueWheel.hue;
    if (up_is_fuzzy_equal(hue, [UIColor themeColorHue])) {
        return;
    }
    [UIColor setThemeColorHue:hue];
    [[UPSpellNavigationController instance] updateThemeColors];
}

- (void)hueWheelFinishedUpdating:(UPHueWheel *)hueWheel
{
    CGFloat hue = self.hueWheel.hue;
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.themeColorHue = hue;
}

- (int)prevHueForHue:(int)hue
{
    int dv = hue % MilepostHue;
    if (dv == 0) {
        dv = MilepostHue;
    }
    hue -= dv;
    if (hue < 0) {
        hue = HueCount - MilepostHue;
    }
    return hue;
}

- (int)nextHueForHue:(int)hue
{
    int dv = hue % MilepostHue;
    if (dv == 0) {
        hue += MilepostHue;
    }
    else {
        hue += (MilepostHue - dv);
    }
    if (hue >= HueCount) {
        hue = 0;
    }
    return hue;
}

- (void)handleHueStepLess
{
    CGFloat hue = [UIColor themeColorHue];
    hue = [self prevHueForHue:hue];
    self.hueWheel.hue = hue;
    [self.hueWheel cancelAnimations];
    [UIColor setThemeColorHue:hue];
    [[UPSpellNavigationController instance] updateThemeColors];
}

- (void)handleHueStepMore
{
    CGFloat hue = [UIColor themeColorHue];
    hue = [self nextHueForHue:hue];
    self.hueWheel.hue = hue;
    [self.hueWheel cancelAnimations];
    [UIColor setThemeColorHue:hue];
    [[UPSpellNavigationController instance] updateThemeColors];
}

- (void)updateHueDescription
{
    NSMutableString *string = [NSMutableString string];
    if (self.quarkModeCheckbox.selected) {
        [string appendString:@"Randomly-changing colors "];
    }
    else {
        [string appendFormat:@"Colors based on HUE #%03d ", (int)[UIColor themeColorHue]];
    }
    if (self.starkModeCheckbox.selected) {
        [string appendString:@"with more outlined shapes\nthan filled-in shapes "];
    }
    else {
        [string appendString:@"with more filled-in shapes\nthan outlined shapes "];
    }
    if (self.darkModeCheckbox.selected) {
        [string appendString:@"on a dark background"];
    }
    else {
        [string appendString:@"on a light background"];
    }
    self.hueDescription.string = string;
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
    [[UPSpellNavigationController instance] updateThemeColors];

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
    [[UPSpellNavigationController instance] updateThemeColors];
}

- (void)quarkModeCheckboxTapped
{
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.quarkMode = self.quarkModeCheckbox.selected;
    [self updateHueDescription];
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
    [self.exampleTilesContainer.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self updateHueDescription];
}

@end
