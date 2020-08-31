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
@property (nonatomic, readwrite) UPBezierPathView *gameOverMessagePathView;
@property (nonatomic, readwrite) UPLabel *gameOverNoteLabel;
@property (nonatomic, readwrite) UPButton *gameOverShareButton;
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

    self.gameOverMessagePathView = [UPBezierPathView bezierPathView];
    self.gameOverMessagePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.gameOverMessagePathView.path = UP::TextPathDialogGameOver();
    self.gameOverMessagePathView.frame = layout.frame_for(SpellLayout::Role::DialogMessageVerticallyCentered, Spot::OffBottomNear);

    self.gameOverNoteLabel = [UPLabel label];
    self.gameOverNoteLabel.font = layout.game_note_font();
    self.gameOverNoteLabel.colorCategory = UPColorCategoryInformation;
    self.gameOverNoteLabel.textAlignment = NSTextAlignmentCenter;
    self.gameOverNoteLabel.frame = layout.frame_for(SpellLayout::Role::DialogGameNote, Spot::OffBottomFar);
    
    self.gameOverShareButton = [UPButton roundShareButton];
    self.gameOverShareButton.frame = layout.frame_for(SpellLayout::Role::GameShareButton, Spot::OffBottomFar);
    self.gameOverShareButton.band = UP::BandModeUI;
    [self.gameOverShareButton setFillColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self.gameOverShareButton setStrokeColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.gameOverMessagePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    [self.gameOverNoteLabel updateThemeColors];
    [self.gameOverShareButton updateThemeColors];
}

@end
