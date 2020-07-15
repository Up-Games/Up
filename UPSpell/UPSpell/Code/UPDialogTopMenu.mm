//
//  UPDialogTopMenu.mm
//  Copyright © 2020 Up Games. All rights reserved.
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

@interface UPDialogTopMenu ()
@property (nonatomic, readwrite) UPBezierPathView *messagePathView;
@property (nonatomic, readwrite) UPTextButton *extrasButton;
@property (nonatomic, readwrite) UPTextButton *playButton;
@property (nonatomic, readwrite) UPTextButton *aboutButton;
@end

@implementation UPDialogTopMenu

+ (UPDialogTopMenu *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogTopMenu *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogTopMenu alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.messagePathView = [UPBezierPathView bezierPathView];
    self.messagePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.messagePathView.path = UP::TextPathDialogReady();
    self.messagePathView.frame = layout.frame_for(SpellLayout::Role::DialogMessageVerticallyCentered);
    [self addSubview:self.messagePathView];

    self.extrasButton = [UPTextButton textButton];
    self.extrasButton.behavior = UPTextButtonBehaviorModeButton;
    self.extrasButton.labelString = @"EXTRAS";
    self.extrasButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonTopLeft);
    [self addSubview:self.extrasButton];

    self.playButton = [UPTextButton textButton];
    self.playButton.labelString = @"PLAY";
    self.playButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonTopCenter);
    [self addSubview:self.playButton];

    UPSpellSettings *settings = [UPSpellSettings instance];
    if (settings.retryMode) {
        self.playButton.behavior = UPTextButtonBehaviorModeButton;
    }
    
    self.aboutButton = [UPTextButton textButton];
    self.aboutButton.behavior = UPTextButtonBehaviorModeButton;
    self.aboutButton.labelString = @"ABOUT";
    self.aboutButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonTopRight);
    [self addSubview:self.aboutButton];
    
    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.messagePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    [self.extrasButton updateThemeColors];
    [self.playButton updateThemeColors];
    [self.aboutButton updateThemeColors];
}

@end
