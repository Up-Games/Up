//
//  UPDialogChallenge.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLogoView.h>

#import "UPControl+UPSpell.h"
#import "UPDialogChallenge.h"
#import "UPChallenge.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogChallenge ()
@property (nonatomic, readwrite) UPLogoView *logoView;
@property (nonatomic, readwrite) UPLabel *wordMarkLabel;
@property (nonatomic, readwrite) UPLabel *challengePromptLabel;
@property (nonatomic, readwrite) UPLabel *scorePromptLabel;
@property (nonatomic, readwrite) UPButton *cancelButton;
@property (nonatomic, readwrite) UPButton *confirmButton;
@property (nonatomic, readwrite) UPButton *helpButton;
@end

@implementation UPDialogChallenge

+ (UPDialogChallenge *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogChallenge *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogChallenge alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.logoView = [UPLogoView logoView];
    [self addSubview:self.logoView];
    self.logoView.frame = CGRectMake(0, 0, 148, 148);
    self.logoView.center = layout.center_for(Role::HeroLogo);

    self.wordMarkLabel = [UPLabel label];
    self.wordMarkLabel.string = @"UP SPELL";
    self.wordMarkLabel.font = layout.word_mark_font();
    self.wordMarkLabel.textAlignment = NSTextAlignmentCenter;
    self.wordMarkLabel.frame = layout.frame_for(Role::HeroWordMark);
    [self addSubview:self.wordMarkLabel];
    
    self.challengePromptLabel = [UPLabel label];
    self.challengePromptLabel.string = @"CHALLENGE!";
    self.challengePromptLabel.font = layout.challenge_prompt_font();
    self.challengePromptLabel.textAlignment = NSTextAlignmentCenter;
    self.challengePromptLabel.frame = layout.frame_for(Role::ChallengePrompt);
    [self addSubview:self.challengePromptLabel];

    self.scorePromptLabel = [UPLabel label];
    self.scorePromptLabel.font = layout.challenge_score_font_font();
    self.scorePromptLabel.textAlignment = NSTextAlignmentCenter;
    self.scorePromptLabel.frame = layout.frame_for(Role::ChallengeScore);
    [self addSubview:self.scorePromptLabel];

    self.cancelButton = [UPTextButton textButton];
    self.cancelButton.labelString = @"CANCEL";
    [self.cancelButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.cancelButton.frame = layout.frame_for(Role::DialogButtonAlternativeResponse);
    [self addSubview:self.cancelButton];

    self.confirmButton = [UPTextButton textButton];
    self.confirmButton.labelString = @"PLAY";
    [self.confirmButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.confirmButton.frame = layout.frame_for(Role::DialogButtonDefaultResponse);
    [self addSubview:self.confirmButton];

    self.helpButton = [UPButton roundHelpButton];
    [self.helpButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.helpButton.frame = layout.frame_for(Role::DialogHelpButton);
    [self addSubview:self.helpButton];

    [self updateThemeColors];

    return self;
}

- (void)updateWithChallenge:(UPChallenge *)challenge
{
    if (challenge.valid) {
        if (challenge.score < 0) {
            self.challengePromptLabel.string = @"INVITE";
            self.scorePromptLabel.string = @"GOOD LUCK & HAVE FUN!";
            self.cancelButton.labelString = @"CANCEL";
            self.confirmButton.hidden = NO;
        }
        else {
            self.challengePromptLabel.string = @"CHALLENGE!";
            self.scorePromptLabel.string = [NSString stringWithFormat:@"SCORE TO BEAT: %d", challenge.score];
            self.cancelButton.labelString = @"CANCEL";
            self.confirmButton.hidden = NO;
        }
    }
    else {
        self.challengePromptLabel.string = @"OOPS!";
        self.scorePromptLabel.string = @"LINK IS BAD. SORRY!";
        self.cancelButton.labelString = @"OK";
        self.confirmButton.hidden = YES;
    }
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
