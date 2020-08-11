//
//  UPDialogShare.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPVectorLogoView.h>

#import "UPControl+UPSpell.h"
#import "UPDialogShare.h"
#import "UPShareRequest.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogShare ()
@property (nonatomic, readwrite) UPVectorLogoView *vectorLogoView;
@property (nonatomic, readwrite) UPLabel *wordMarkLabel;
@property (nonatomic, readwrite) UPLabel *shareLabel;
@property (nonatomic, readwrite) UPLabel *scoreToTopLabel;
@property (nonatomic, readwrite) UPButton *cancelButton;
@property (nonatomic, readwrite) UPButton *goButton;
@property (nonatomic, readwrite) UPButton *helpButton;
@end

@implementation UPDialogShare

+ (UPDialogShare *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogShare *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogShare alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.vectorLogoView = [UPVectorLogoView vectorLogoView];
    [self addSubview:self.vectorLogoView];
    self.vectorLogoView.frame = CGRectMake(0, 0, 160, 160);
    self.vectorLogoView.center = layout.center_for(Role::ChallengeInterstitialLogo);

    self.wordMarkLabel = [UPLabel label];
    self.wordMarkLabel.string = @"UP SPELL";
    self.wordMarkLabel.font = layout.word_mark_font();
    self.wordMarkLabel.textAlignment = NSTextAlignmentCenter;
    self.wordMarkLabel.frame = layout.frame_for(Role::ChallengeInterstitialWordMark);
    self.wordMarkLabel.colorCategory = UPColorCategoryCanonical;
    [self addSubview:self.wordMarkLabel];
    
    self.shareLabel = [UPLabel label];
    self.shareLabel.string = @"CHALLENGE!";
    self.shareLabel.font = layout.share_prompt_font();
    self.shareLabel.textAlignment = NSTextAlignmentCenter;
    self.shareLabel.frame = layout.frame_for(Role::DialogMessageSharePrompt);
    [self addSubview:self.shareLabel];

    self.scoreToTopLabel = [UPLabel label];
    self.scoreToTopLabel.font = layout.share_score_to_beat_font();
    self.scoreToTopLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreToTopLabel.frame = layout.frame_for(Role::DialogMessageShareScoreToBeat);
    [self addSubview:self.scoreToTopLabel];

    self.cancelButton = [UPTextButton textButton];
    self.cancelButton.labelString = @"CANCEL";
    [self.cancelButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.cancelButton.frame = layout.frame_for(Role::DialogButtonAlternativeResponse);
    [self addSubview:self.cancelButton];

    self.goButton = [UPTextButton textButton];
    self.goButton.labelString = @"PLAY";
    [self.goButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.goButton.frame = layout.frame_for(Role::DialogButtonDefaultResponse);
    [self addSubview:self.goButton];

    self.helpButton = [UPButton roundHelpButton];
    [self.helpButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.helpButton.frame = layout.frame_for(Role::DialogHelpButton);
    [self addSubview:self.helpButton];

    [self updateThemeColors];

    return self;
}

- (void)updateWithShare:(UPShareRequest *)share
{
    self.scoreToTopLabel.string = [NSString stringWithFormat:@"SCORE TO TOP: %d", share.score];
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
