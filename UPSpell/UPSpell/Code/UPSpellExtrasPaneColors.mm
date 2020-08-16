//
//  UPSpellExtrasPaneColors.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPBallot.h"
#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPRotor.h"
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

@interface UPSpellExtrasPaneColors ()
@property (nonatomic, readwrite) UPRotor *themeRotor;
@property (nonatomic) UIView *hueDescriptionContainer;
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

@implementation UPSpellExtrasPaneColors

+ (UPSpellExtrasPaneColors *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();
    
    self.themeRotor = [UPRotor rotorWithElements:@[
        @"RED/LIGHT",
        @"GREEN/LIGHT",
        @"BLUE/LIGHT",
        @"PURPLE/LIGHT",
        @"ORANGE/DARK",
        @"GREEN/DARK",
        @"BLUE/DARK",
        @"PURPLE/DARK",
        @"RED/LIGHT/STARK",
        @"GREEN/LIGHT/STARK",
        @"BLUE/LIGHT/STARK",
        @"PURPLE/LIGHT/STARK",
        @"YELLOW/DARK/STARK",
        @"GREEN/DARK/STARK",
        @"BLUE/DARK/STARK",
        @"PURPLE/DARK/STARK",
    ]];
    
    self.themeRotor.frame = layout.frame_for(Role::ExtrasColorsThemeRotor);
    [self.themeRotor setTarget:self action:@selector(themeRotorChanged)];
    [self addSubview:self.themeRotor];
    
    self.hueDescriptionContainer = [[UIView alloc] initWithFrame:layout.frame_for(Role::ExtrasColorsDescription)];
    [self addSubview:self.hueDescriptionContainer];

    self.hueDescription = [UPLabel label];
    self.hueDescription.font = layout.description_font();
    self.hueDescription.colorCategory = UPColorCategoryControlText;
    self.hueDescription.textAlignment = NSTextAlignmentLeft;
    [self.hueDescriptionContainer addSubview:self.hueDescription];

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
    self.iconPrompt.string = @"Change the UP Spell app icon on your homescreen\nto match theme color?";
    self.iconPrompt.frame = layout.frame_for(Role::ExtrasColorsIconPrompt);
    self.iconPrompt.font = layout.description_font();
    self.iconPrompt.colorCategory = UPColorCategoryControlText;
    self.iconPrompt.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.iconPrompt];

    self.iconButtonNope = [UPTextButton textButton];
    self.iconButtonNope.labelString = @"NOPE";
    [self.iconButtonNope setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    [self.iconButtonNope setTarget:self action:@selector(hideIconEasterEgg)];
    [self addSubview:self.iconButtonNope];
    self.iconButtonNope.frame = layout.frame_for(Role::ExtrasColorsIconButtonNope);

    self.iconButtonYep = [UPTextButton textButton];
    self.iconButtonYep.labelString = @"YEP!";
    [self.iconButtonYep setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    [self.iconButtonYep setTarget:self action:@selector(iconButtonYepTapped)];
    [self addSubview:self.iconButtonYep];
    self.iconButtonYep.frame = layout.frame_for(Role::ExtrasColorsIconButtonYep);

    [self updateHueDescription];
    
    return self;
}

- (void)prepare
{
    self.showingIconEasterEgg = NO;
    self.userInteractionEnabled = YES;

    SpellLayout &layout = SpellLayout::instance();
    
    UPTheme theme = [UIColor theme];
    NSUInteger rotorIndex = 0;
    if (theme == UPThemeDefault) {
        rotorIndex = UPThemeBlueLight - 1;
    }
    else {
        rotorIndex = theme - 1;
    }
    [self.themeRotor selectIndex:rotorIndex];
    
     self.hueDescriptionContainer.frame = layout.frame_for(Role::ExtrasColorsDescription);
    [self.hueDescription centerInSuperview];
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
        UPViewMoveMake(self.hueDescriptionContainer, Role::ExtrasColorsDescription, Spot::OffBottomFar),
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
        UPViewMoveMake(self.hueDescriptionContainer, Role::ExtrasColorsDescription),
        UPViewMoveMake(self.exampleTilesContainer, Role::ExtrasColorsExample),
    ];
    
    CFTimeInterval duration = 0.3;
    
    start(bloop_out(BandSettingsUI, outMoves, duration, ^(UIViewAnimatingPosition) {
        start(bloop_in(BandSettingsUI, inMoves, duration, ^(UIViewAnimatingPosition) {
            self.userInteractionEnabled = YES;
        }));
    }));
}

- (void)updateHueDescription
{
    [self.hueDescription updateThemeColors];

    NSString *colorString = nil;
    switch ([UIColor theme]) {
        case UPThemeRedLight:
        case UPThemeRedLightStark:
            colorString = @"RED";
            break;
        case UPThemeGreenLight:
        case UPThemeGreenDark:
        case UPThemeGreenLightStark:
        case UPThemeGreenDarkStark:
            colorString = @"GREEN";
            break;
        case UPThemeDefault:
        case UPThemeBlueLight:
        case UPThemeBlueDark:
        case UPThemeBlueLightStark:
        case UPThemeBlueDarkStark:
            colorString = @"BLUE";
            break;
        case UPThemePurpleLight:
        case UPThemePurpleDark:
        case UPThemePurpleLightStark:
        case UPThemePurpleDarkStark:
            colorString = @"PURPLE";
            break;
        case UPThemeOrangeDark:
            colorString = @"ORANGE";
            break;
        case UPThemeYellowDarkStark:
            colorString = @"YELLOW";
            break;
    }
    
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"Colors based on "];
    [string appendString:colorString];
    [string appendFormat:@" "];

    UPThemeColorStyle style = [UIColor themeColorStyle];
    if (style == UPThemeColorStyleLightStark || style == UPThemeColorStyleDarkStark) {
        [string appendString:@"with more outlined shapes\nthan filled-in shapes "];
    }
    else {
        [string appendString:@"with more filled-in shapes\nthan outlined shapes "];
    }
    if (style == UPThemeColorStyleDark || style == UPThemeColorStyleDarkStark) {
        [string appendString:@"on a dark background."];
    }
    else {
        [string appendString:@"on a light background."];
    }
    self.hueDescription.string = string;
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

- (void)themeRotorChanged
{
    NSUInteger index = self.themeRotor.selectedIndex;
    UPTheme theme = (UPTheme)(index + 1);

    cancel(BandSettingsUpdateDelay);

    delay(BandSettingsUpdateDelay, 0.15, ^{
        [UIColor setTheme:theme];
        [[UPSpellNavigationController instance] updateThemeColors];
        UPSpellSettings *settings = [UPSpellSettings instance];
        settings.theme = theme;
    });
}

- (void)iconButtonYepTapped
{
    UIApplication *app = [UIApplication sharedApplication];
    NSString *iconName = up_theme_icon_name();
    [app setAlternateIconName:iconName completionHandler:^(NSError *error) {
        [self hideIconEasterEgg];
        if (error) {
            LOG(General, "setAlternateIconName error: %@", error);
        }
    }];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self.hueDescription centerInSuperview];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.exampleTilesContainer.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self updateHueDescription];
}

@end
