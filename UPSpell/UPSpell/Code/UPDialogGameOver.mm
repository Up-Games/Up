//
//  UPDialogPause.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLayoutRule.h>

#import "UPControl+UPSpell.h"
#import "UPDialogGameOver.h"
#import "UPSpellLayout.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

@interface UPDialogGameOver ()
@property (nonatomic, readwrite) UPBezierPathView *titlePathView;
@property (nonatomic, readwrite) UPControl *menuButton;
@property (nonatomic, readwrite) UPControl *playButton;
@property (nonatomic, readwrite) UPLabel *noteLabel;
@end

@implementation UPDialogGameOver

+ (UPDialogGameOver *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogGameOver *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogGameOver alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout_manager = SpellLayout::instance();
    self = [super initWithFrame:layout_manager.canvas_frame()];

    self.titlePathView = [UPBezierPathView bezierPathView];
    self.titlePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.titlePathView.path = UP::TextPathDialogGameOver();
    self.titlePathView.frame = layout_manager.dialog_over_interstitial_title_layout_frame();
    [self addSubview:self.titlePathView];

    self.menuButton = [UPControl textButtonMenu];
    self.menuButton.frame = layout_manager.dialog_over_interstitial_button_left_frame();
    [self addSubview:self.menuButton];

    self.playButton = [UPControl textButtonPlay];
    self.playButton.frame = layout_manager.dialog_over_interstitial_button_right_frame();
    [self addSubview:self.playButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.titlePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryDialogTitle];
}

@end
