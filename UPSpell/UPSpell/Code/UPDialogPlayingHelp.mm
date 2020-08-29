//
//  UPDialogPlayingHelp.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPBezierPathView.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPContainerView.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogPlayingHelp.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogPlayingHelp ()
@property (nonatomic, readwrite) UPContainerView *containerView;
@property (nonatomic, readwrite) UPBezierPathView *containerClipView;
@property (nonatomic, readwrite) UPLabel *helpLabel;
@end

@implementation UPDialogPlayingHelp

+ (UPDialogPlayingHelp *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogPlayingHelp *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogPlayingHelp alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.screen_bounds()];

    self.containerView = [[UPContainerView alloc] initWithFrame:CGRectZero];
    self.containerView.frame = layout.screen_bounds();
    [self addSubview:self.containerView];
    
    self.containerClipView = [UPBezierPathView bezierPathView];
    self.containerClipView.canonicalSize = UP::SpellLayout::CanonicalWordTrayFrame.size;
    self.containerClipView.frame = layout.word_tray_layout_frame();
    self.containerClipView.path = UP::WordTrayFullMaskPath();
    self.containerClipView.fillColor = [UIColor blackColor];
    self.containerView.layer.mask = self.containerClipView.shapeLayer;
    
    self.helpLabel = [UPLabel label];
    self.helpLabel.string = @"NEED HELP? TAP ABOUT.";
    self.helpLabel.colorCategory = UPColorCategoryInformation;
    self.helpLabel.font = layout.dialog_title_font();
    self.helpLabel.textAlignment = NSTextAlignmentCenter;
    self.helpLabel.frame = layout.frame_for(Role::WordScore);
    [self.containerView addSubview:self.helpLabel];

    [self updateThemeColors];

    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.helpLabel updateThemeColors];
}

@end
