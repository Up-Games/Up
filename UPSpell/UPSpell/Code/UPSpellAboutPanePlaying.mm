//
//  UPSpellAboutPanePlaying.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPGameTimer.h>
#import <UpKit/UPGameTimerLabel.h>
#import <UpKit/UPMath.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutPanePlaying.h"
#import "UPSpellGameView.h"
#import "UPSpellLayout.h"
#import "UPSpellModel.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPTileView.h"
#import "UPViewMove+UPSpell.h"

using UP::BandSettingsUI;
using UP::SpellLayout;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;
using UP::TilePosition;
using UP::TileTray;
using Role = UP::SpellLayout::Role;

@interface UPSpellAboutPanePlaying ()
@property (nonatomic) BOOL active;
@property (nonatomic) int step;
@property (nonatomic) UPSpellGameView *gameView;
@property (nonatomic) UPGameTimer *gameTimer;
@end

@implementation UPSpellAboutPanePlaying

+ (UPSpellAboutPanePlaying *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.gameView = [[UPSpellGameView alloc] init];
    self.gameView.center = up_pixel_point(up_point_scaled(SpellLayout::CanonicalAboutPlayingGameViewCenter, layout.layout_scale()), layout.screen_scale());
    self.gameView.transform = layout.about_playing_game_view_transform();
    [self addSubview:self.gameView];
    
    self.gameTimer = [[UPGameTimer alloc] initWithDuration:UPGameTimerDefaultDuration];
    [self.gameTimer addObserver:self.gameView.timerLabel];
    [self.gameTimer notifyObservers];

    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        TileModel model;
        switch (idx) {
            case 0:
                model = TileModel(U'U');
                break;
            case 1:
                model = TileModel(U'P');
                break;
            case 2:
                model = TileModel(U'S');
                break;
            case 3:
                model = TileModel(U'P');
                break;
            case 4:
                model = TileModel(U'E');
                break;
            case 5:
                model = TileModel(U'L');
                break;
            case 6:
                model = TileModel(U'L');
                break;
        }
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tileView.band = BandSettingsUI;
        tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
        [self.gameView.tileContainerView addSubview:tileView];
    }
    
    
    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    [self updateThemeColors];
    
    self.step = 0;

}

- (void)finish
{
    
}

- (void)animateToStepOne
{
}

- (void)animateToStepTwo
{
}

- (void)animationFinished
{
    if (!self.active) {
        return;
    }
    
    self.step++;
    
    switch (self.step) {
        case 1:
            [self animateToStepOne];
            break;
        case 2:
            [self animateToStepTwo];
            break;
    }
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
