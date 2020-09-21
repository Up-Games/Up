//
//  UPDialogGameLinkHelp.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogGameLinkHelp.h"
#import "UPGameLink.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogGameLinkHelp ()
@property (nonatomic, readwrite) UPLabel *titleLabel;
@property (nonatomic, readwrite) UIView *helpLabelContainer;
@property (nonatomic, readwrite) UPLabel *helpLabel;
@property (nonatomic, readwrite) UPButton *okButton;
@end

@implementation UPDialogGameLinkHelp

+ (UPDialogGameLinkHelp *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogGameLinkHelp *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogGameLinkHelp alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.titleLabel = [UPLabel label];
    self.titleLabel.font = layout.dialog_title_font();
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = layout.frame_for(Role::DialogHelpTitle);
    [self addSubview:self.titleLabel];

    self.helpLabelContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.helpLabelContainer.frame = layout.frame_for(Role::DialogHelpText);
    [self addSubview:self.helpLabelContainer];

    self.helpLabel = [UPLabel label];
    self.helpLabel.font = layout.description_font();
    self.helpLabel.textAlignment = NSTextAlignmentLeft;
    self.helpLabel.frame = layout.frame_for(Role::DialogHelpText);
    [self.helpLabelContainer addSubview:self.helpLabel];

    self.okButton = [UPTextButton smallTextButton];
    self.okButton.labelString = @"OK";
    [self.okButton setLabelColorCategory:UPColorCategoryContent];
    self.okButton.frame = layout.frame_for(Role::DialogHelpOKButton);
    [self addSubview:self.okButton];

    [self updateThemeColors];

    return self;
}

- (void)updateWithGameLink:(UPGameLink *)gameLink
{
    switch (gameLink.type) {
        case UPGameLinkTypeDuel:
            self.titleLabel.string = @"ABOUT DUELING";
            self.helpLabel.string =
                @"A DUEL is a game with the same\n"
                "letters someone else is also playing.\n"
                "Try to beat their score.";
            break;
        case UPGameLinkTypeChallenge:
            self.titleLabel.string = @"ABOUT CHALLENGES";
            self.helpLabel.string =
                @"A CHALLENGE is a new game with the same\n"
                "letters someone else has already played.\n"
                "Try to beat their score.";
            break;
    }
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
