//
//  UPDialogTaunt.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UPControl+UPSpell.h"
#import "UPDialogTaunt.h"
#import "UPTaunt.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

@interface UPDialogTaunt ()
@property (nonatomic, readwrite) UPLabel *tauntLabel;
@property (nonatomic, readwrite) UPLabel *scoreToBeatLabel;
@property (nonatomic, readwrite) UPButton *cancelButton;
@property (nonatomic, readwrite) UPButton *goButton;
@property (nonatomic, readwrite) UPButton *helpButton;
@end

@implementation UPDialogTaunt

+ (UPDialogTaunt *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogTaunt *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogTaunt alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.tauntLabel = [UPLabel label];
    self.tauntLabel.string = @"UP SPELL TAUNT!";
    self.tauntLabel.font = layout.taunt_prompt_font();
    self.tauntLabel.textAlignment = NSTextAlignmentCenter;
    self.tauntLabel.frame = layout.frame_for(SpellLayout::Role::DialogMessageTauntPrompt);
    [self addSubview:self.tauntLabel];

    self.scoreToBeatLabel = [UPLabel label];
    self.scoreToBeatLabel.font = layout.taunt_score_to_beat_font();
    self.scoreToBeatLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreToBeatLabel.frame = layout.frame_for(SpellLayout::Role::DialogMessageTauntScoreToBeat);
    [self addSubview:self.scoreToBeatLabel];

    self.cancelButton = [UPTextButton textButton];
    self.cancelButton.labelString = @"CANCEL";
    [self.cancelButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.cancelButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonAlternativeResponse);
    [self addSubview:self.cancelButton];

    self.goButton = [UPTextButton textButton];
    self.goButton.labelString = @"PLAY";
    [self.goButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.goButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonDefaultResponse);
    [self addSubview:self.goButton];

    self.helpButton = [UPButton roundHelpButton];
    [self.helpButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.helpButton.frame = layout.frame_for(SpellLayout::Role::DialogHelpButton);
    [self addSubview:self.helpButton];

    [self updateThemeColors];

    return self;
}

- (void)updateWithTaunt:(UPTaunt *)taunt
{
//    self.tauntLabel.string = [NSString stringWithFormat:@"YOU’VE BEEN TAUNTED!\nSCORE TO BEAT: %d", taunt.score];
    self.scoreToBeatLabel.string = [NSString stringWithFormat:@"SCORE TO BEAT: %d", taunt.score];
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
