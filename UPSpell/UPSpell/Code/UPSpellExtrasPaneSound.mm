//
//  UPSpellExtrasPaneSound.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPDivider.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLayoutRule.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPPlacard.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPBallot.h"
#import "UPControl+UPSpell.h"
#import "UPDialogTopMenu.h"
#import "UPHueWheel.h"
#import "UPSoundPlayer.h"
#import "UPSlider.h"
#import "UPSpellExtrasPaneSound.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameRetry.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPStepper.h"
#import "UPTextButton.h"
#import "UPTileView.h"
#import "UPViewMove+UPSpell.h"

using UP::BandSettingsUI;
using UP::BandSettingsAnimationDelay;
using UP::BandSettingsUpdateDelay;
using UP::GameKey;
using UP::SpellGameSummary;
using UP::SpellLayout;
using UP::SpellModel;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;

using UP::cpp_str;
using UP::ns_str;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

using Role = UP::SpellLayout::Role;

@interface UPSpellExtrasPaneSound ()
@property (nonatomic) UPBallot *effectsCheckbox;
@property (nonatomic) UPSlider *effectsVolumeSlider;
@property (nonatomic) UPBallot *tunesCheckbox;
@property (nonatomic) UPSlider *tunesVolumeSlider;
@property (nonatomic) UPLabel *soundDescription;
@property (nonatomic) BOOL soundEffectsLevelChanged;
@property (nonatomic) NSUInteger previousSoundEffectsLevel;
@property (nonatomic) NSUInteger previousTunesLevel;
@end

@implementation UPSpellExtrasPaneSound

+ (UPSpellExtrasPaneSound *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.soundDescription = [UPLabel label];
    self.soundDescription.frame = layout.frame_for(Role::ExtrasSoundDescription);
    self.soundDescription.font = layout.settings_description_font();
    self.soundDescription.colorCategory = UPColorCategoryControlText;
    self.soundDescription.textAlignment = NSTextAlignmentCenter;
    self.soundDescription.string = @"EFFECTS play in response to your actions and\nthe game timer. TUNES are in-game music.";
    [self addSubview:self.soundDescription];

    self.effectsCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.effectsCheckbox.labelString = @"EFFECTS";
    [self.effectsCheckbox setTarget:self action:@selector(effectsCheckboxTapped)];
    self.effectsCheckbox.frame = layout.frame_for(Role::ExtrasSoundEffectsCheckbox);
    [self addSubview:self.effectsCheckbox];
    
    self.effectsVolumeSlider = [UPSlider discreteSliderWithMarks:6];
    [self.effectsVolumeSlider setTarget:self action:@selector(effectsSliderChanged)];
    self.effectsVolumeSlider.frame = layout.frame_for(Role::ExtrasSoundEffectsSlider);
    [self addSubview:self.effectsVolumeSlider];
    
    self.tunesCheckbox = [UPBallot ballotWithType:UPBallotTypeCheckbox];
    self.tunesCheckbox.labelString = @"TUNES";
    [self.tunesCheckbox setTarget:self action:@selector(tunesCheckboxTapped)];
    self.tunesCheckbox.frame = layout.frame_for(Role::ExtrasSoundTunesCheckbox);
    [self addSubview:self.tunesCheckbox];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    UPSpellSettings *settings = [UPSpellSettings instance];
    [self.effectsCheckbox setSelected:settings.soundEffectsEnabled];
    [self.tunesCheckbox setSelected:settings.tunesEnabled];

    [self.tunesCheckbox setSelected:settings.tunesEnabled];

    self.previousSoundEffectsLevel = settings.soundEffectsLevel;
    self.previousTunesLevel = settings.tunesLevel;
}

- (void)effectsCheckboxTapped
{
    BOOL selected = self.effectsCheckbox.selected;
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.soundEffectsEnabled = selected;
    
    UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
    if (selected) {
        [soundPlayer setVolumeFromLevel:self.previousSoundEffectsLevel];
        delay(BandSettingsUpdateDelay, 0.1, ^{
            [soundPlayer playSoundID:UPSoundIDHappy1];
        });
    }
    else {
        [soundPlayer setVolumeFromLevel:0];
    }
}

- (void)effectsSliderChanged
{
    NSUInteger mark = self.effectsVolumeSlider.valueAsMark + 1;

    UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
    [soundPlayer prepare];

    if (self.effectsVolumeSlider.slideGesture.state == UIGestureRecognizerStateBegan) {
        self.soundEffectsLevelChanged = NO;
    }
    
    BOOL sameAsPrevious = self.previousSoundEffectsLevel == mark;
    if (!sameAsPrevious) {
        self.soundEffectsLevelChanged = YES;
        self.previousSoundEffectsLevel = mark;
        [soundPlayer setVolumeFromLevel:mark];
        delay(BandSettingsUpdateDelay, 0.1, ^{
            [soundPlayer playSoundID:UPSoundIDTap];
        });
    }

    if (self.effectsVolumeSlider.slideGesture.state == UIGestureRecognizerStateEnded) {
        delay(BandSettingsUpdateDelay, 0.1, ^{
            [soundPlayer playSoundID:UPSoundIDHappy1];
        });
        UPSpellSettings *settings = [UPSpellSettings instance];
        settings.soundEffectsLevel = mark;
        LOG(General, "*** soundEffectsLevel: %ld", mark);
    }
}

- (void)tunesCheckboxTapped
{
    BOOL selected = self.tunesCheckbox.selected;
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.retryMode = selected;
}

#pragma mark - Target / Action

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
