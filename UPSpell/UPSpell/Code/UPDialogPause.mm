//
//  UPDialogPause.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>

#import "UPControl+UPSpell.h"
#import "UPDialogPause.h"
#import "UPSpellLayout.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

@interface UPDialogPause ()
@property (nonatomic, readwrite) UPBezierPathView *titlePathView;
@property (nonatomic, readwrite) UPControl *quitButton;
@property (nonatomic, readwrite) UPControl *resumeButton;
@end

@implementation UPDialogPause

+ (UPDialogPause *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogPause *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogPause alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.titlePathView = [UPBezierPathView bezierPathView];
    self.titlePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.titlePathView.path = UP::TextPathDialogPaused();
    self.titlePathView.frame = layout.frame_for(SpellLayout::Role::DialogMessageHigh);
    [self addSubview:self.titlePathView];

    self.quitButton = [UPControl textButtonQuit];
    self.quitButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonAlternativeResponse);
    [self addSubview:self.quitButton];

    self.resumeButton = [UPControl textButtonResume];
    self.resumeButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonDefaultResponse);
    [self addSubview:self.resumeButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.titlePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryDialogTitle];
}

@end
