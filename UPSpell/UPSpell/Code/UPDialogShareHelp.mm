//
//  UPDialogShareHelp.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogShareHelp.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogShareHelp ()
@property (nonatomic, readwrite) UPLabel *titleLabel;
@property (nonatomic, readwrite) UIView *helpLabelContainer;
@property (nonatomic, readwrite) UPLabel *helpLabel;
@property (nonatomic, readwrite) UPButton *okButton;
@end

@implementation UPDialogShareHelp

+ (UPDialogShareHelp *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogShareHelp *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogShareHelp alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.titleLabel = [UPLabel label];
    self.titleLabel.string = @"ABOUT SHARING";
    self.titleLabel.font = layout.dialog_title_font();
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = layout.frame_for(Role::DialogHelpTitle);
    [self addSubview:self.titleLabel];

    self.helpLabelContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.helpLabelContainer.frame = layout.frame_for(Role::DialogHelpText);
    [self addSubview:self.helpLabelContainer];

    self.helpLabel = [UPLabel label];
    self.helpLabel.string = @"Sharing creates a link to a new game with the\n"
                             "same letters as the game you just played.\n"
                             "Challenge friends to top your score!";
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
