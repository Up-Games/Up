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
#import "UPTunePlayer.h"
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
@property (nonatomic) UIView *soundDescriptionContainer;
@property (nonatomic) UPLabel *soundDescription;
@property (nonatomic) BOOL soundEffectsLevelChanged;
@property (nonatomic) NSUInteger previousSoundEffectsLevel;
@property (nonatomic) NSUInteger previousTunesLevel;
@property (nonatomic) BOOL changingTunesLevel;
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

    self.soundDescriptionContainer = [[UIView alloc] initWithFrame:layout.frame_for(Role::ExtrasSoundDescription)];
    [self addSubview:self.soundDescriptionContainer];

    self.soundDescription = [UPLabel label];
    self.soundDescription.frame = layout.frame_for(Role::ExtrasSoundDescription);
    self.soundDescription.font = layout.description_font();
    self.soundDescription.colorCategory = UPColorCategoryControlText;
    self.soundDescription.textAlignment = NSTextAlignmentLeft;
    self.soundDescription.string = @"EFFECTS play in response to your actions and to\nthe game timer. TUNES are the in-game music.";
    [self.soundDescriptionContainer addSubview:self.soundDescription];

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

    self.tunesVolumeSlider = [UPSlider discreteSliderWithMarks:6];
    [self.tunesVolumeSlider setTarget:self action:@selector(tunesSliderChanged)];
    self.tunesVolumeSlider.frame = layout.frame_for(Role::ExtrasSoundTunesSlider);
    [self addSubview:self.tunesVolumeSlider];

    [self updateThemeColors];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(tunePlayerFinishedPlaying:) name:UPTunePlayerFinishedPlayingNotification object:nil];
    
    return self;
}

- (void)prepare
{
    self.userInteractionEnabled = YES;

    UPSpellSettings *settings = [UPSpellSettings instance];
    [self.effectsCheckbox setSelected:settings.soundEffectsEnabled];
    [self.tunesCheckbox setSelected:settings.tunesEnabled];

    self.effectsVolumeSlider.enabled = self.effectsCheckbox.selected;
    self.tunesVolumeSlider.enabled = self.tunesCheckbox.selected;

    self.previousSoundEffectsLevel = settings.soundEffectsLevel;
    [self.effectsVolumeSlider setMarkValue:self.previousSoundEffectsLevel - 1];

    self.previousTunesLevel = settings.tunesLevel;
    [self.tunesVolumeSlider setMarkValue:self.previousTunesLevel - 1];

    NSBundle *bundle = [NSBundle mainBundle];
    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    [tunePlayer setFilePath:[bundle pathForResource:@"Demo-Tune" ofType:@"aac"] forTuneID:UPTuneIDDemo segment:UPTuneSegmentMain];
}

- (void)effectsCheckboxTapped
{
    BOOL selected = self.effectsCheckbox.selected;
    self.effectsVolumeSlider.enabled = selected;

    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.soundEffectsEnabled = selected;
    
    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    [tunePlayer stop];

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
    UIGestureRecognizerState gestureState = self.effectsVolumeSlider.slideGesture.state;

    NSUInteger mark = self.effectsVolumeSlider.valueAsMark + 1;

    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    [tunePlayer stop];

    UPSoundPlayer *soundPlayer = [UPSoundPlayer instance];
    [soundPlayer prepare];

    if (gestureState == UIGestureRecognizerStateBegan) {
        self.effectsCheckbox.userInteractionEnabled = NO;
        self.tunesCheckbox.userInteractionEnabled = NO;
        self.tunesVolumeSlider.userInteractionEnabled = NO;
        self.soundEffectsLevelChanged = NO;
    }
    
    BOOL sameAsPrevious = self.previousSoundEffectsLevel == mark;
    if (!sameAsPrevious) {
        self.soundEffectsLevelChanged = YES;
        self.previousSoundEffectsLevel = mark;
        [soundPlayer setVolumeFromLevel:mark];
        cancel(BandSettingsUpdateDelay);
        delay(BandSettingsUpdateDelay, 0.1, ^{
            [soundPlayer playSoundID:UPSoundIDTap];
        });
    }

    if (gestureState == UIGestureRecognizerStateEnded) {
        cancel(BandSettingsUpdateDelay);
        delay(BandSettingsUpdateDelay, 0.1, ^{
            [soundPlayer playSoundID:UPSoundIDHappy1];
        });
        UPSpellSettings *settings = [UPSpellSettings instance];
        settings.soundEffectsLevel = mark;
    }

    if (gestureState == UIGestureRecognizerStateEnded || gestureState == UIGestureRecognizerStateCancelled) {
        self.effectsCheckbox.userInteractionEnabled = YES;
        self.tunesCheckbox.userInteractionEnabled = YES;
        self.tunesVolumeSlider.userInteractionEnabled = YES;
    }
}

- (void)tunesCheckboxTapped
{
    BOOL selected = self.tunesCheckbox.selected;
    self.tunesVolumeSlider.enabled = selected;

    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.tunesEnabled = selected;

    self.changingTunesLevel = NO;

    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    [tunePlayer stop];
    if (selected) {
        [tunePlayer setVolumeFromLevel:self.previousSoundEffectsLevel];
        delay(BandSettingsUpdateDelay, 0.1, ^{
            [tunePlayer playTuneID:UPTuneIDDemo segment:UPTuneSegmentMain properties:{ 1.0, NO, 0, 0, 0 }];
        });
    }
    else {
        [tunePlayer setVolumeFromLevel:0];
    }
}

- (void)tunesSliderChanged
{
    UIGestureRecognizerState gestureState = self.tunesVolumeSlider.slideGesture.state;

    NSUInteger mark = self.tunesVolumeSlider.valueAsMark + 1;
    
    UPTunePlayer *tunePlayer = [UPTunePlayer instance];
    
    if (gestureState == UIGestureRecognizerStateBegan) {
        self.changingTunesLevel = YES;
        self.effectsCheckbox.userInteractionEnabled = NO;
        self.effectsVolumeSlider.userInteractionEnabled = NO;
        self.tunesCheckbox.userInteractionEnabled = NO;
        self.previousTunesLevel = NO;
        if (![tunePlayer isPlayingTuneID:UPTuneIDDemo segment:UPTuneSegmentMain]) {
            [tunePlayer playTuneID:UPTuneIDDemo segment:UPTuneSegmentMain properties:{ 1.0, NO, 0, 0, 0 }];
        }
    }
    
    
    BOOL sameAsPrevious = self.previousSoundEffectsLevel == mark;
    if (!sameAsPrevious) {
        self.previousTunesLevel = YES;
        self.previousSoundEffectsLevel = mark;
        [tunePlayer setVolumeFromLevel:mark];
    }
    
    if (gestureState == UIGestureRecognizerStateEnded) {
        UPSpellSettings *settings = [UPSpellSettings instance];
        settings.tunesLevel = mark;
    }

    if (gestureState == UIGestureRecognizerStateEnded || gestureState == UIGestureRecognizerStateCancelled) {
        self.effectsCheckbox.userInteractionEnabled = YES;
        self.effectsVolumeSlider.userInteractionEnabled = YES;
        self.tunesCheckbox.userInteractionEnabled = YES;
        self.changingTunesLevel = NO;
    }
}

- (void)tunePlayerFinishedPlaying:(NSNotification *)notification
{
    if (!self.changingTunesLevel) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"tuneID"] intValue] == UPTuneIDDemo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UPTunePlayer *tunePlayer = [UPTunePlayer instance];
            [tunePlayer stop];
            [tunePlayer playTuneID:UPTuneIDDemo segment:UPTuneSegmentMain properties:{ 1.0, NO, 0, 0, 0 }];
        });
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self.soundDescription centerInSuperview];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.soundDescription updateThemeColors];
}

@end
