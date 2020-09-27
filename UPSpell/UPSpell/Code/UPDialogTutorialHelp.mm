//
//  UPDialogTutorialHelp.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLogoView.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogTutorialHelp.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogTutorialHelp ()
@property (nonatomic, readwrite) UPLogoView *logoView;
@property (nonatomic, readwrite) UPLabel *wordMarkLabel;
@property (nonatomic, readwrite) UPLabel *welcomeLabel;
@property (nonatomic, readwrite) UPLabel *tutorialLabel;
@property (nonatomic, readwrite) UIView *graduationLabelContainer;
@property (nonatomic, readwrite) UPLabel *graduationLabel;
@property (nonatomic, readwrite) UPTextButton *tutorialDoneButton;
@property (nonatomic, readwrite) UPTextButton *graduationOKButton;
@end

@implementation UPDialogTutorialHelp

+ (UPDialogTutorialHelp *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogTutorialHelp *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogTutorialHelp alloc] _init];
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
    self.logoView.center = layout.center_for(Role::WelcomeLogo);
    
    self.wordMarkLabel = [UPLabel label];
    self.wordMarkLabel.string = @"UP SPELL";
    self.wordMarkLabel.font = layout.word_mark_font();
    self.wordMarkLabel.textAlignment = NSTextAlignmentCenter;
    self.wordMarkLabel.frame = layout.frame_for(Role::WelcomeWordMark);
    [self addSubview:self.wordMarkLabel];
    
    self.welcomeLabel = [UPLabel label];
    self.welcomeLabel.string = @"HERE’S HOW TO PLAY\n";
    self.welcomeLabel.font = layout.text_button_font();
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.frame = layout.frame_for(Role::GameLinkTitle);
    [self addSubview:self.welcomeLabel];
    
    self.tutorialLabel = [UPLabel label];
    self.tutorialLabel.string =
        @"The How-To loops\n"
         "until you tap DONE.\n"
         "Each loop takes\n"
         "one minute.\n";
    self.tutorialLabel.font = layout.description_font();
    self.tutorialLabel.textAlignment = NSTextAlignmentLeft;
    self.tutorialLabel.frame = layout.frame_for(Role::TutorialDonePrompt);
    [self addSubview:self.tutorialLabel];

    self.graduationLabelContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.graduationLabelContainer.frame = layout.frame_for(Role::DialogHelpText);
    [self addSubview:self.graduationLabelContainer];
    
    self.graduationLabel = [UPLabel label];
    self.graduationLabel.string =
    @"Later on, you can watch the How-To again by\n"
    "tapping EXTRAS. Tap OK to start playing!";
    
    self.graduationLabel.font = layout.description_font();
    self.graduationLabel.textAlignment = NSTextAlignmentLeft;
    self.graduationLabel.frame = layout.frame_for(Role::DialogHelpText);
    [self.graduationLabelContainer addSubview:self.graduationLabel];
    self.graduationLabelContainer.hidden = YES;
    
    self.tutorialDoneButton = [UPTextButton smallTextButton];
    self.tutorialDoneButton.labelString = @"DONE";
    [self.tutorialDoneButton setLabelColorCategory:UPColorCategoryContent];
    self.tutorialDoneButton.frame = layout.frame_for(Role::TutorialDoneButton);
    [self addSubview:self.tutorialDoneButton];

    self.graduationOKButton = [UPTextButton smallTextButton];
    self.graduationOKButton.labelString = @"OK";
    [self.graduationOKButton setLabelColorCategory:UPColorCategoryContent];
    self.graduationOKButton.frame = layout.frame_for(Role::GraduationOKButton);
    [self addSubview:self.graduationOKButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self.graduationLabel centerInSuperview];
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.graduationLabel updateThemeColors];
}

@end
