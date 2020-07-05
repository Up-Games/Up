//
//  UPSpellExtrasPaneColors.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIDevice+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPBallot.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasPaneColors.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextButton.h"
#import "UPTileView.h"
#import "UPViewMove+UPSpell.h"

@interface UPSpellExtrasPaneColors ()  <UPHueWheelDelegate>
@property (nonatomic, readwrite) CGFloat hue;
@property (nonatomic, readwrite) UPLabel *modesLabel;
@property (nonatomic, readwrite) UPBallot *darkModeCheckbox;
@property (nonatomic, readwrite) UPBallot *starkModeCheckbox;
@property (nonatomic, readwrite) UPBallot *quarkModeCheckbox;
@property (nonatomic, readwrite) UPHueWheel *hueWheel;
@property (nonatomic, readwrite) UPStepper *hueStepLess;
@property (nonatomic, readwrite) UPStepper *hueStepMore;
@property (nonatomic) UPLabel *hueDescription;
@property (nonatomic) UIView *exampleTilesContainer;
@property (nonatomic) UPLabel *iconPrompt;
@property (nonatomic) UPTextButton *iconButtonNope;
@property (nonatomic) UPTextButton *iconButtonYep;
@property (nonatomic) BOOL showingIconEasterEgg;
@end

using UP::BandSettingsUI;
using UP::BandSettingsAnimationDelay;
using UP::BandSettingsUpdateDelay;
using UP::SpellLayout;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Place;

static const int HueCount = 360;
static const int MilepostHue = 15;

@implementation UPSpellExtrasPaneColors

+ (UPSpellExtrasPaneColors *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();
    
    self.darkModeCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.darkModeCheckbox.labelString = @"DARK";
    [self.darkModeCheckbox setTarget:self action:@selector(darkModeCheckboxTapped)];
    self.darkModeCheckbox.frame = layout.frame_for(Role::ExtrasColorsDarkMode);
    [self addSubview:self.darkModeCheckbox];
    
    self.starkModeCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.starkModeCheckbox.labelString = @"STARK";
    [self.starkModeCheckbox setTarget:self action:@selector(starkModeCheckboxTapped)];
    self.starkModeCheckbox.frame = layout.frame_for(Role::ExtrasColorsStarkMode);
    [self addSubview:self.starkModeCheckbox];
    
    self.quarkModeCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.quarkModeCheckbox.labelString = @"QUARK";
    self.quarkModeCheckbox.frame = layout.frame_for(Role::ExtrasColorsQuarkMode);
    [self addSubview:self.quarkModeCheckbox];

    self.hueWheel = [UPHueWheel hueWheel];
    self.hueWheel.frame = layout.frame_for(Role::ExtrasColorsHueWheel);
    self.hueWheel.delegate = self;
    [self addSubview:self.hueWheel];
    
    self.hueStepMore = [UPStepper stepperWithDirection:UPStepperDirectionUp];
    [self.hueStepMore setTarget:self action:@selector(handleHueStepMore)];
    self.hueStepMore.frame = layout.frame_for(Role::ExtrasColorsHueStepMore);
    [self addSubview:self.hueStepMore];
    
    self.hueStepLess = [UPStepper stepperWithDirection:UPStepperDirectionDown];
    [self.hueStepLess setTarget:self action:@selector(handleHueStepLess)];
    self.hueStepLess.frame = layout.frame_for(Role::ExtrasColorsHueStepLess);
    [self addSubview:self.hueStepLess];
    
    self.hueDescription = [UPLabel label];
    self.hueDescription.frame = layout.frame_for(Role::ExtrasColorsDescription);
    self.hueDescription.font = layout.settings_description_font();
    self.hueDescription.textColorCategory = UPColorCategoryControlText;
    self.hueDescription.backgroundColorCategory = UPColorCategoryClear;
    self.hueDescription.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.hueDescription];
    
    CGRect examplesFrame = CGRectMake(0, 0, SpellLayout::CanonicalTilesLayoutWidth, up_size_height(SpellLayout::CanonicalTileSize));
    self.exampleTilesContainer = [[UPContainerView alloc] initWithFrame:examplesFrame];
    [self addSubview:self.exampleTilesContainer];
    
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
    self.exampleTilesContainer.transform = layout.extras_example_transform();
    self.exampleTilesContainer.center = layout.center_for(Role::ExtrasColorsExample);

    self.iconPrompt = [UPLabel label];
    self.iconPrompt.string = @"Change the UP Spell app icon on your homescreen\nto match the hue on the wheel?";
    self.iconPrompt.frame = layout.frame_for(Role::ExtrasColorsIconPrompt);
    self.iconPrompt.font = layout.settings_description_font();
    self.iconPrompt.textColorCategory = UPColorCategoryControlText;
    self.iconPrompt.backgroundColorCategory = UPColorCategoryClear;
    self.iconPrompt.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.iconPrompt];

    self.iconButtonNope = [UPTextButton textButtonWithLabelString:@"NOPE"];
    [self.iconButtonNope setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    [self.iconButtonNope setTarget:self action:@selector(hideIconEasterEgg)];
    [self addSubview:self.iconButtonNope];
    self.iconButtonNope.frame = layout.frame_for(Role::ExtrasColorsIconButtonNope);

    self.iconButtonYep = [UPTextButton textButtonWithLabelString:@"YEP!"];
    [self.iconButtonYep setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    [self.iconButtonYep setTarget:self action:@selector(iconButtonYepTapped)];
    [self addSubview:self.iconButtonYep];
    self.iconButtonYep.frame = layout.frame_for(Role::ExtrasColorsIconButtonYep);

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

- (void)prepare
{
    self.showingIconEasterEgg = NO;
    self.userInteractionEnabled = YES;

    SpellLayout &layout = SpellLayout::instance();
    self.hueDescription.frame = layout.frame_for(Role::ExtrasColorsDescription);
    self.exampleTilesContainer.center = layout.center_for(Role::ExtrasColorsExample);
    self.iconPrompt.frame = layout.frame_for(Role::ExtrasColorsIconPrompt, Spot::OffBottomFar);
    self.iconButtonNope.frame = layout.frame_for(Role::ExtrasColorsIconButtonNope, Spot::OffBottomFar);
    self.iconButtonYep.frame = layout.frame_for(Role::ExtrasColorsIconButtonYep, Spot::OffBottomFar);
}

- (void)showIconEasterEgg
{
    if (self.showingIconEasterEgg) {
        return;
    }
    self.userInteractionEnabled = NO;
    self.showingIconEasterEgg = YES;
    
    NSArray <UPViewMove *> *outMoves = @[
        UPViewMoveMake(self.hueDescription, Role::ExtrasColorsDescription, Spot::OffBottomFar),
        UPViewMoveMake(self.exampleTilesContainer, Role::ExtrasColorsExample, Spot::OffBottomFar),
    ];

    NSArray <UPViewMove *> *inMoves = @[
        UPViewMoveMake(self.iconPrompt, Role::ExtrasColorsIconPrompt),
        UPViewMoveMake(self.iconButtonNope, Role::ExtrasColorsIconButtonNope),
        UPViewMoveMake(self.iconButtonYep, Role::ExtrasColorsIconButtonYep),
    ];

    CFTimeInterval duration = 0.3;
    
    start(bloop_out(BandSettingsUI, outMoves, duration, ^(UIViewAnimatingPosition) {
        start(bloop_in(BandSettingsUI, inMoves, duration, ^(UIViewAnimatingPosition) {
            self.userInteractionEnabled = YES;
        }));
    }));
}

- (void)hideIconEasterEgg
{
    if (!self.showingIconEasterEgg) {
        return;
    }
    self.userInteractionEnabled = NO;
    self.showingIconEasterEgg = NO;
    
    NSArray <UPViewMove *> *outMoves = @[
        UPViewMoveMake(self.iconPrompt, Role::ExtrasColorsIconPrompt, Spot::OffBottomFar),
        UPViewMoveMake(self.iconButtonNope, Role::ExtrasColorsIconButtonNope, Spot::OffBottomFar),
        UPViewMoveMake(self.iconButtonYep, Role::ExtrasColorsIconButtonYep, Spot::OffBottomFar),
    ];
    
    NSArray <UPViewMove *> *inMoves = @[
        UPViewMoveMake(self.hueDescription, Role::ExtrasColorsDescription),
        UPViewMoveMake(self.exampleTilesContainer, Role::ExtrasColorsExample),
    ];
    
    CFTimeInterval duration = 0.3;
    
    start(bloop_out(BandSettingsUI, outMoves, duration, ^(UIViewAnimatingPosition) {
        start(bloop_in(BandSettingsUI, inMoves, duration, ^(UIViewAnimatingPosition) {
            self.userInteractionEnabled = YES;
        }));
    }));
}

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
        [string appendString:@"Slowly-changing colors "];
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
        case UIGestureRecognizerStateEnded: {
            tileView.highlighted = NO;
            if (tileView.glyph == U'X') {
                delay(BandSettingsAnimationDelay, 0.1, ^{
                    [self showIconEasterEgg];
                });
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            tileView.highlighted = NO;
            break;
        }
    }
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

- (void)iconButtonYepTapped
{
    CGFloat hue = [UIColor themeColorHue];
    if (fmod(hue, MilepostHue) > 1) {
        CGFloat hueMore = [self nextHueForHue:hue];
        CGFloat hueLess = [self prevHueForHue:hue];
        CGFloat diffMore = up_angular_difference(hue, hueMore);
        CGFloat diffLess = up_angular_difference(hue, hueLess);
        if (diffMore < diffLess) {
            hue = hueMore;
        }
        else {
            hue = hueLess;
        }
        if (up_is_fuzzy_equal(hue, 360)) {
            hue = 0;
        }
    }
    UIApplication *app = [UIApplication sharedApplication];
    UIDevice *device = [UIDevice currentDevice];
    NSString *iconName = nil;
    if ([device.model isEqualToString:@"iPhone"]) {
        iconName = [NSString stringWithFormat:@"up-games-icon-%03d-60", (int)hue];
    }
    else if ([device.model isEqualToString:@"iPad"]) {
        if ([device isiPadPro]) {
            iconName = [NSString stringWithFormat:@"up-games-icon-%03d-83", (int)hue];
        }
        else {
            iconName = [NSString stringWithFormat:@"up-games-icon-%03d-76", (int)hue];
        }
    }
    LOG(General, "iconName: %@ : %@ : %@", iconName, device.model, [device fullModel]);
    [app setAlternateIconName:iconName completionHandler:^(NSError *error) {
        [self hideIconEasterEgg];
        if (error) {
            LOG(General, "setAlternateIconName error: %@", error);
        }
    }];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.exampleTilesContainer.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self updateHueDescription];
}

@end
