//
//  UPDialogPause.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UPControl+UPSpell.h"
#import "UPDialogGameOver.h"
#import "UPSpellLayout.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

using Role = SpellLayout::Role;
using Spot = SpellLayout::Spot;

@interface UPDialogGameOver ()
@property (nonatomic, readwrite) UPBezierPathView *messagePathView;
@property (nonatomic, readwrite) UPLabel *noteLabel;
@property (nonatomic, readwrite) UPButton *shareButton;
@end

@implementation UPDialogGameOver

+ (UPDialogGameOver *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogGameOver *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogGameOver alloc] init];
    });
    return _Instance;
}

- (instancetype)init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super init];

    self.messagePathView = [UPBezierPathView bezierPathView];
    self.messagePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.messagePathView.path = UP::TextPathDialogGameOver();
    self.messagePathView.frame = layout.frame_for(SpellLayout::Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);

    self.noteLabel = [UPLabel label];
    self.noteLabel.font = layout.game_note_font();
    self.noteLabel.colorCategory = UPColorCategoryInformation;
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel.frame = layout.frame_for(SpellLayout::Role::DialogGameNote, Spot::OffBottomFar);
    
    self.shareButton = [UPButton roundShareButton];
    self.shareButton.frame = layout.frame_for(SpellLayout::Role::GameShareButton, Spot::OffBottomFar);
    self.shareButton.band = UP::BandModeUI;
    [self.shareButton setFillColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self.shareButton setStrokeColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.messagePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    [self.noteLabel updateThemeColors];
    [self.shareButton updateThemeColors];
}

@end
