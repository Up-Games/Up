//
//  UPDialogInviteHelp.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogInviteHelp.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogInviteHelp ()
@property (nonatomic, readwrite) UPLabel *titleLabel;
@property (nonatomic, readwrite) UIView *helpLabelContainer;
@property (nonatomic, readwrite) UPLabel *helpLabel;
@property (nonatomic, readwrite) UPButton *okButton;
@end

@implementation UPDialogInviteHelp

+ (UPDialogInviteHelp *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogInviteHelp *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogInviteHelp alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.titleLabel = [UPLabel label];
    self.titleLabel.string = @"ABOUT INVITE";
    self.titleLabel.font = layout.dialog_title_font();
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = layout.frame_for(Role::DialogInviteHelpTitle);
    [self addSubview:self.titleLabel];

    self.helpLabelContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.helpLabelContainer.frame = layout.frame_for(Role::DialogInviteHelpText);
    [self addSubview:self.helpLabelContainer];

    self.helpLabel = [UPLabel label];
    self.helpLabel.string =
        @"Invite a friend to play a game with you. Tap OK, then\n"
         "use the share sheet to send your friend a link. When your\n"
         "friend taps the link, Up Spell will open for them, and\n"
         "you’ll both get a game with the same letters.\n\n"
         "May the better speller win! Tap the PLAY button at the\n"
         "same time for extra drama!";
    self.helpLabel.font = layout.description_font();
    self.helpLabel.textAlignment = NSTextAlignmentLeft;
    self.helpLabel.frame = layout.frame_for(Role::DialogInviteHelpText);
    [self.helpLabelContainer addSubview:self.helpLabel];

    self.okButton = [UPTextButton smallTextButton];
    self.okButton.labelString = @"OK";
    [self.okButton setLabelColorCategory:UPColorCategoryContent];
    self.okButton.frame = layout.frame_for(Role::DialogInviteHelpOKButton);
    [self addSubview:self.okButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self.helpLabel centerInSuperview];
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    [self.helpLabel updateThemeColors];
}

@end
