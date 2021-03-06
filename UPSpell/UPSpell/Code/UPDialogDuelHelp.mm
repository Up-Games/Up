//
//  UPDialogDuelHelp.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogDuelHelp.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogDuelHelp ()
@property (nonatomic, readwrite) UPLabel *titleLabel;
@property (nonatomic, readwrite) UIView *helpLabelContainer;
@property (nonatomic, readwrite) UPLabel *helpLabel;
@property (nonatomic, readwrite) UPButton *okButton;
@end

@implementation UPDialogDuelHelp

+ (UPDialogDuelHelp *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogDuelHelp *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogDuelHelp alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.titleLabel = [UPLabel label];
    self.titleLabel.string = @"ABOUT DUELS";
    self.titleLabel.font = layout.dialog_title_font();
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = layout.frame_for(Role::DialogDuelHelpTitle);
    [self addSubview:self.titleLabel];

    self.helpLabelContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.helpLabelContainer.frame = layout.frame_for(Role::DialogDuelHelpText);
    [self addSubview:self.helpLabelContainer];

    self.helpLabel = [UPLabel label];
    self.helpLabel.string =
        @"A DUEL is a game you play against a friend. Tap OK, then send your\n"
        "friend the link the game creates for you. The Game Key in the link\n"
        "ensures that both of you get a game with the same letters. After\n"
        "you play, share your score to see who won. Good luck and have fun!";
    self.helpLabel.font = layout.description_font();
    self.helpLabel.textAlignment = NSTextAlignmentLeft;
    self.helpLabel.frame = layout.frame_for(Role::DialogDuelHelpText);
    [self.helpLabelContainer addSubview:self.helpLabel];

    self.okButton = [UPTextButton smallTextButton];
    self.okButton.labelString = @"OK";
    [self.okButton setLabelColorCategory:UPColorCategoryContent];
    self.okButton.frame = layout.frame_for(Role::DialogDuelHelpOKButton);
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
