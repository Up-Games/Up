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
@property (nonatomic, readwrite) UPLabel *helpLabel;
@property (nonatomic, readwrite) UPTextButton *okButton;
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
    self.wordMarkLabel.string = @"WELCOME";
    self.wordMarkLabel.font = layout.word_mark_font();
    self.wordMarkLabel.textAlignment = NSTextAlignmentCenter;
    self.wordMarkLabel.frame = layout.frame_for(Role::WelcomeWordMark);
    [self addSubview:self.wordMarkLabel];
    
    self.welcomeLabel = [UPLabel label];
    self.welcomeLabel.string = @"HOW TO PLAY UP SPELL\n";
    self.welcomeLabel.font = layout.text_button_font();
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.frame = layout.frame_for(Role::GameLinkTitle);
    [self addSubview:self.welcomeLabel];
    
    self.helpLabel = [UPLabel label];
    self.helpLabel.string =
        @"This how-to loops.\n"
         "It takes 1 minute.\n"
         "To start playing,\n"
         "tap OK.";
    self.helpLabel.font = layout.description_font();
    self.helpLabel.textAlignment = NSTextAlignmentLeft;
    self.helpLabel.frame = layout.frame_for(Role::TutorialDonePrompt);
    [self addSubview:self.helpLabel];

    self.okButton = [UPTextButton smallTextButton];
    self.okButton.labelString = @"OK";
    [self.okButton setLabelColorCategory:UPColorCategoryContent];
    self.okButton.frame = layout.frame_for(Role::TutorialDoneButton);
    [self addSubview:self.okButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.helpLabel updateThemeColors];
}

@end
