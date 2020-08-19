//
//  UPDialogPlayMenu.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGameKey.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPStringTools.h>

#import "UPControl+UPSpell.h"
#import "UIFont+UPSpell.h"
#import "UPChoice.h"
#import "UPDialogPlayMenu.h"
#import "UPSpellDossier.h"
#import "UPSpellGameSummary.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellSettings.h"
#import "UPTextButton.h"
#import "UPTextPaths.h"

using UP::GameKey;
using UP::SpellGameSummary;
using UP::SpellLayout;
using UP::SpellModel;
using UP::ns_str;

using Place = SpellLayout::Place;
using Role = SpellLayout::Role;

@interface UPDialogPlayMenu ()
{
    SpellGameSummary m_high_score_summary;
    SpellGameSummary m_last_game_summary;
}
@property (nonatomic, readwrite) UPButton *backButton;
@property (nonatomic, readwrite) UPButton *goButton;
@property (nonatomic, readwrite) UPChoice *choice1;
@property (nonatomic, readwrite) UPChoice *choice2;
@property (nonatomic, readwrite) UPChoice *choice3;
@property (nonatomic, readwrite) NSArray<UPChoice *> *choices;
@end

@implementation UPDialogPlayMenu

+ (UPDialogPlayMenu *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogPlayMenu *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogPlayMenu alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.backButton = [UPButton roundBackButtonEx];
    self.backButton.frame = layout.frame_for(Role::ChoiceBackCenter, Place::OffTopNear);
    self.backButton.chargeOutsets = UPOutsetsMake(0, 0, 0, 140 * layout.layout_scale());
    [self addSubview:self.backButton];

    self.goButton = [UPTextButton textButton];
    self.goButton.labelString = @"GO";
    [self.goButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.goButton.frame = layout.frame_for(Role::ChoiceGoButtonCenter, Place::OffBottomFar);
    [self addSubview:self.goButton];

    self.choice1 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice1.variableWidth = YES;
    self.choice1.tag = UPDialogPlayMenuChoiceRetryHighScore;
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Center, Place::OffBottomNear);
    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice2.variableWidth = YES;
    self.choice2.tag = UPDialogPlayMenuChoiceRetryLastGame;
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Center, Place::OffBottomNear);
    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice3.labelString = @"NEW GAME";
    self.choice3.variableWidth = YES;
    self.choice3.tag = UPDialogPlayMenuChoiceNewGame;
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Center, Place::OffBottomNear);
    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self addSubview:self.choice3];
    
    self.choices = @[ self.choice1, self.choice2, self.choice3 ];
    
    [self updateThemeColors];

    return self;
}

- (void)updateChoiceLabels
{
    self.choice1.userInteractionEnabled = YES;
    self.choice2.userInteractionEnabled = YES;

    UPSpellDossier *dossier = [UPSpellDossier instance];
    
    LOG(General, "High Score: %@", ns_str(GameKey(dossier.highScoreGameKeyValue).string()));
    LOG(General, "Last Game:  %@", ns_str(GameKey(dossier.lastGameKeyValue).string()));

    UPSpellSettings *settings = [UPSpellSettings instance];
    NSUInteger playMenuSelectedIndex = settings.playMenuSelectedIndex;
    for (UPChoice *choice in self.choices) {
        choice.selected = (choice.tag == playMenuSelectedIndex);
    }

    if (dossier.totalGamesPlayed == 0) {
        self.choice1.labelString = @"RETRY HIGH SCORE GAME";
        self.choice2.labelString = @"RETRY LAST GAME";
        [self.choice1 setDisabled:YES];
        [self.choice2 setDisabled:YES];
        self.choice1.userInteractionEnabled = NO;
        self.choice2.userInteractionEnabled = NO;
        [self.choice3 setSelected:YES];
    }
    else if (dossier.highScore == 0) {
        self.choice1.labelString = @"RETRY HIGH SCORE GAME";
        self.choice2.labelString = @"RETRY LAST GAME (0)";
        [self.choice1 setDisabled:YES];
        self.choice1.userInteractionEnabled = NO;
    }
    else {
        self.choice1.labelString = [NSString stringWithFormat:@"RETRY HIGH SCORE GAME (%d)", dossier.highScore];
        [self.choice1 setDisabled:NO];

        if (dossier.highScore == dossier.lastScore) {
            self.choice2.labelString = @"LAST GAME WAS HIGH SCORE";
            if (self.choice2.selected) {
                [self.choice2 setSelected:NO];
                [self.choice1 setSelected:YES];
            }
            [self.choice2 setDisabled:YES];
            self.choice2.userInteractionEnabled = NO;
        }
        else if (dossier.highScoreGameKeyValue == dossier.lastGameKeyValue) {
            self.choice2.labelString = [NSString stringWithFormat:@"LAST GAME (%d) RETRIED HIGH SCORE", dossier.lastScore];
            if (self.choice2.selected) {
                [self.choice2 setSelected:NO];
                [self.choice1 setSelected:YES];
            }
            [self.choice2 setDisabled:YES];
            self.choice2.userInteractionEnabled = NO;
        }
        else {
            self.choice2.labelString = [NSString stringWithFormat:@"RETRY LAST GAME (%d)", dossier.lastScore];
            [self.choice2 setDisabled:NO];
        }

    }

    [self.choice1 invalidate];
    [self.choice2 invalidate];
    [self.choice3 invalidate];
}

- (void)choiceSelected:(UPChoice *)sender
{
    for (UPChoice *choice in self.choices) {
        if (choice != sender) {
            choice.selected = NO;
            [choice invalidate];
            [choice update];
        }
    }
    
    UPSpellSettings *settings = [UPSpellSettings instance];
    settings.playMenuSelectedIndex = sender.tag;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
