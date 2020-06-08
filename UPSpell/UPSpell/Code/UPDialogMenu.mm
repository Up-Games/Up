//
//  UPDialogMenu.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>

#import "UPControl+UPSpell.h"
#import "UPDialogMenu.h"
#import "UPSpellLayout.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

@interface UPDialogMenu ()
@property (nonatomic, readwrite) UPBezierPathView *titlePathView;
@property (nonatomic, readwrite) UPControl *extrasButton;
@property (nonatomic, readwrite) UPControl *playButton;
@property (nonatomic, readwrite) UPControl *aboutButton;
@end

@implementation UPDialogMenu

+ (UPDialogMenu *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogMenu *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogMenu alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.titlePathView = [UPBezierPathView bezierPathView];
    self.titlePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.titlePathView.path = UP::TextPathDialogReady();
    self.titlePathView.frame = layout.frame_for(SpellLayout::Role::DialogMessageCenter);
    [self addSubview:self.titlePathView];

    self.extrasButton = [UPControl textButtonExtras];
    self.extrasButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonTopLeft);
    [self addSubview:self.extrasButton];

    self.playButton = [UPControl textButtonPlay];
    self.playButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonTopCenter);
    [self addSubview:self.playButton];

    self.aboutButton = [UPControl textButtonAbout];
    self.aboutButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonTopRight);
    [self addSubview:self.aboutButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.titlePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryDialogTitle];
}

@end
