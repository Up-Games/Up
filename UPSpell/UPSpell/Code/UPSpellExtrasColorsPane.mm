//
//  UPSpellExtrasColorsPane.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIDevice+UP.h>
#import <UpKit/UPTapGestureRecognizer.h>

#import "UIFont+UPSpell.h"
#import "UPCheckbox.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPHueWheel.h"
#import "UPSpellExtrasColorsPane.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTileView.h"

@interface UPSpellExtrasColorsPane ()  <UPHueWheelDelegate>
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

@implementation UPSpellExtrasColorsPane

+ (UPSpellExtrasColorsPane *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();
    
    self.darkModeCheckbox = [UPCheckbox checkbox];
    self.darkModeCheckbox.labelString = @"DARK";
    [self.darkModeCheckbox setTarget:self action:@selector(darkModeCheckboxTapped)];
    self.darkModeCheckbox.frame = layout.frame_for(Role::ExtrasColorsDarkMode);
    [self addSubview:self.darkModeCheckbox];
    
    self.starkModeCheckbox = [UPCheckbox checkbox];
    self.starkModeCheckbox.labelString = @"STARK";
    [self.starkModeCheckbox setTarget:self action:@selector(starkModeCheckboxTapped)];
    self.starkModeCheckbox.frame = layout.frame_for(Role::ExtrasColorsStarkMode);
    [self addSubview:self.starkModeCheckbox];
    
    self.quarkModeCheckbox = [UPCheckbox checkbox];
    self.quarkModeCheckbox.labelString = @"QUARK";
    [self.quarkModeCheckbox setTarget:self action:@selector(setAppIconButtonTapped)];
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
        case UIGestureRecognizerStateEnded:
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

- (void)setAppIconButtonTapped
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
