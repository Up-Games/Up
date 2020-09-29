//
//  UPDialogWelcome.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <CoreText/CoreText.h>

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLogoView.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogWelcome.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogWelcome ()
@property (nonatomic, readwrite) UPLogoView *logoView;
@property (nonatomic, readwrite) UPLabel *wordMarkLabel;
@property (nonatomic, readwrite) UPLabel *welcomeTitleLabel;
@property (nonatomic, readwrite) UPLabel *welcomeDetailLabel;
@property (nonatomic, readwrite) UPTextButton *welcomeOKButton;
@end

@implementation UPDialogWelcome

+ (UPDialogWelcome *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogWelcome *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogWelcome alloc] _init];
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
    
    self.welcomeTitleLabel = [UPLabel label];
    self.welcomeTitleLabel.string = @"WELCOME";
    self.welcomeTitleLabel.font = layout.dialog_title_font();
    self.welcomeTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeTitleLabel.frame = layout.frame_for(Role::DialogHelpTitle);
    [self addSubview:self.welcomeTitleLabel];

    self.welcomeDetailLabel = [UPLabel label];
    self.welcomeDetailLabel.string =
    @"Up Spell is easy to play.\n"
    "Tap letters to spell words. Tap words to score points.\n"
    "For a complete How-To, tap OK, then EXTRAS.\n"
    "Good luck & have fun!";
    self.welcomeDetailLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeDetailLabel.font = layout.description_font();
    self.welcomeDetailLabel.frame = layout.frame_for(Role::DialogHelpText);
    [self addSubview:self.welcomeDetailLabel];

    self.welcomeOKButton = [UPTextButton smallTextButton];
    self.welcomeOKButton.labelString = @"OK";
    [self.welcomeOKButton setLabelColorCategory:UPColorCategoryContent];
    self.welcomeOKButton.frame = layout.frame_for(Role::DialogHelpOKButton);
    [self addSubview:self.welcomeOKButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
