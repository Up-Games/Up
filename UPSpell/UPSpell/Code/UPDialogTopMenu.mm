//
//  UPDialogTopMenu.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UPControl+UPSpell.h"
#import "UPDialogTopMenu.h"
#import "UPSpellLayout.h"
#import "UPSpellSettings.h"
#import "UPTextButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

using Role = SpellLayout::Role;
using Spot = SpellLayout::Spot;

@interface UPDialogTopMenu ()
@property (nonatomic, readwrite) UPBezierPathView *readyMessagePathView;
@property (nonatomic, readwrite) UPTextButton *extrasButton;
@property (nonatomic, readwrite) UPTextButton *playButton;
@property (nonatomic, readwrite) UPTextButton *inviteButton;
@end

@implementation UPDialogTopMenu

+ (UPDialogTopMenu *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogTopMenu *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogTopMenu alloc] init];
    });
    return _Instance;
}

- (instancetype)init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super init];

    self.readyMessagePathView = [UPBezierPathView bezierPathView];
    self.readyMessagePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.readyMessagePathView.path = UP::TextPathDialogReady();
    self.readyMessagePathView.frame = layout.frame_for(Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);

    self.extrasButton = [UPTextButton textButton];
    self.extrasButton.behavior = UPTextButtonBehaviorModeButton;
    self.extrasButton.labelString = @"EXTRAS";
    self.extrasButton.frame = layout.frame_for(Role::DialogButtonTopLeft);

    self.playButton = [UPTextButton textButton];
    self.playButton.labelString = @"PLAY";
    self.playButton.frame = layout.frame_for(Role::DialogButtonTopCenter);

    UPSpellSettings *settings = [UPSpellSettings instance];
    if (settings.retryMode) {
        self.playButton.behavior = UPTextButtonBehaviorModeButton;
    }
    
    self.inviteButton = [UPTextButton textButton];
    self.inviteButton.behavior = UPTextButtonBehaviorPushButton;
    self.inviteButton.labelString = @"INVITE";
    self.inviteButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonTopRight);
    
    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.readyMessagePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    [self.extrasButton updateThemeColors];
    [self.playButton updateThemeColors];
    [self.inviteButton updateThemeColors];
}

@end
