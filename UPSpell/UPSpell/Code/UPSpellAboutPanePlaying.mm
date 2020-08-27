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
#import <UpKit/UPTimeSpanning.h>

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

using UP::BandAboutPlaying;
using UP::BandAboutPlayingDelay;
using UP::BandAboutPlayingUI;
using UP::SpellLayout;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;
using UP::TilePosition;
using UP::TileTray;
using Role = UP::SpellLayout::Role;
using Place = UP::SpellLayout::Place;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;
using UP::TimeSpanning::slide;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

@interface UPSpellAboutPanePlaying ()
@property (nonatomic) BOOL active;
@property (nonatomic) int step;
@property (nonatomic) UPSpellGameView *gameView;
@property (nonatomic) UPGameTimer *gameTimer;
@property (nonatomic) UPLabel *bottomPromptLabel;
@property (nonatomic) UIView *botSpot;
@property (nonatomic) NSArray *tileViews;
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
    self.gameView.clipsToBounds = YES;
    self.gameView.center = layout.center_for(Role::AboutPlayingGameView);
    self.gameView.transform = layout.about_playing_game_view_transform();
    [self addSubview:self.gameView];

    CGRect botSpotFrame = up_rect_scaled(CGRectMake(0, 0, 92, 92), layout.layout_scale());
    self.botSpot = [[UIView alloc] initWithFrame:botSpotFrame];
    self.botSpot.layer.cornerRadius = up_rect_width(botSpotFrame) * 0.5;
    self.botSpot.layer.borderWidth = 4;
    [self.gameView addSubview:self.botSpot];

    self.gameTimer = [[UPGameTimer alloc] initWithDuration:UPGameTimerDefaultDuration];
    [self.gameTimer addObserver:self.gameView.timerLabel];
    [self.gameTimer notifyObservers];
    
    self.bottomPromptLabel = [UPLabel label];
    self.bottomPromptLabel.frame = layout.frame_for(Role::AboutPlayingBottomPrompt);
    self.bottomPromptLabel.font = layout.placard_description_font();
    self.bottomPromptLabel.colorCategory = UPColorCategoryControlText;
    self.bottomPromptLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bottomPromptLabel];
    
    return self;
}

- (void)prepare
{
    self.step = 1;

    SpellLayout &layout = SpellLayout::instance();

    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        TileModel model;
        switch (idx) {
            case 0:
                model = TileModel(U'E');
                break;
            case 1:
                model = TileModel(U'O');
                break;
            case 2:
                model = TileModel(U'D');
                break;
            case 3:
                model = TileModel(U'Q');
                break;
            case 4:
                model = TileModel(U'G');
                break;
            case 5:
                model = TileModel(U'L');
                break;
            case 6:
                model = TileModel(U'O');
                break;
        }
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tileView.band = BandAboutPlayingUI;
        tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
        [self.gameView.tileContainerView addSubview:tileView];
    }

    self.tileViews = self.gameView.tileContainerView.subviews;
    
    [self updateThemeColors];

    self.active = YES;
    
    delay(BandAboutPlayingDelay, 1.2, ^{
        [self nextStep];
    });
    
    self.bottomPromptLabel.string = @"";
    self.bottomPromptLabel.frame = layout.frame_for(Role::AboutPlayingBottomPrompt, Place::OffBottomNear);
    self.botSpot.center = layout.center_for(Role::DialogMessageCenteredInWordTray);

}

- (void)finish
{
    cancel(BandAboutPlaying);
    self.active = NO;
}

- (void)animateToStepOne
{
    if (!self.active) {
        return;
    }
}

- (void)animateToStepTwo
{
    if (!self.active) {
        return;
    }

    self.bottomPromptLabel.string = @"TAP LETTERS TO SPELL WORDS";
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    [moves addObject:UPViewMoveMake(self.bottomPromptLabel, Role::AboutPlayingBottomPrompt)];
    start(bloop_in(BandAboutPlayingUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        if (self.active) {
            delay(BandAboutPlayingDelay, 1, ^{
                [self nextStep];
            });
        }
    }));
}

- (void)animateToStepThree
{
    if (!self.active) {
        return;
    }

    UPTileView *tileView1 = self.tileViews[4];
    UPTileView *tileView2 = self.tileViews[1];
    UPTileView *tileView3 = self.tileViews[6];
    UPTileView *tileView4 = self.tileViews[2];

    SpellLayout &layout = SpellLayout::instance();
    self.botSpot.center = layout.center_for(Role::DialogMessageCenteredInWordTray);
    
    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 4)));
    start(slide(BandAboutPlayingUI, @[ botSpotMove1 ], 0.4, ^(UIViewAnimatingPosition) {
        
        UPViewMove *tileMove1 = UPViewMoveMake(tileView1, Role::WordTile1of1);
        tileView1.highlighted = YES;
        start(bloop_in(BandAboutPlayingUI, @[ tileMove1 ], 0.3, nil));
        delay(BandAboutPlayingDelay, 0.2, ^{
            tileView1.highlighted = NO;
            [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
            [self.gameView.clearControl setNeedsUpdate];
        });
                                               
        UPViewMove *botSpotMove2 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 1)));
        start(slide(BandAboutPlayingUI, @[ botSpotMove2 ], 0.4, ^(UIViewAnimatingPosition) {

            UPViewMove *tileMove1a = UPViewMoveMake(tileView1, Role::WordTile1of2);
            start(slide(BandAboutPlayingUI, @[ tileMove1a ], 0.1, nil));

            UPViewMove *tileMove2 = UPViewMoveMake(tileView2, Role::WordTile2of2);
            tileView2.highlighted = YES;
            start(bloop_in(BandAboutPlayingUI, @[ tileMove2 ], 0.3, nil));
            delay(BandAboutPlayingDelay, 0.2, ^{
                tileView2.highlighted = NO;
            });

            UPViewMove *botSpotMove3 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 6)));
            start(slide(BandAboutPlayingUI, @[ botSpotMove3 ], 0.4, ^(UIViewAnimatingPosition) {

                UPViewMove *tileMove1b = UPViewMoveMake(tileView1, Role::WordTile1of3);
                UPViewMove *tileMove2b = UPViewMoveMake(tileView2, Role::WordTile2of3);
                start(slide(BandAboutPlayingUI, @[ tileMove1b, tileMove2b ], 0.1, nil));
                
                UPViewMove *tileMove3 = UPViewMoveMake(tileView3, Role::WordTile3of3);
                tileView3.highlighted = YES;
                start(bloop_in(BandAboutPlayingUI, @[ tileMove3 ], 0.3, nil));
                delay(BandAboutPlayingDelay, 0.2, ^{
                    tileView3.highlighted = NO;
                });

                UPViewMove *botSpotMove4 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 2)));
                start(slide(BandAboutPlayingUI, @[ botSpotMove4 ], 0.4, ^(UIViewAnimatingPosition) {

                    self.gameView.wordTrayControl.active = YES;
                    [self.gameView.wordTrayControl setNeedsUpdate];

                    UPViewMove *tileMove1c = UPViewMoveMake(tileView1, Role::WordTile1of4);
                    UPViewMove *tileMove2c = UPViewMoveMake(tileView2, Role::WordTile2of4);
                    UPViewMove *tileMove3c = UPViewMoveMake(tileView3, Role::WordTile3of4);
                    start(slide(BandAboutPlayingUI, @[ tileMove1c, tileMove2c, tileMove3c ], 0.1, nil));
                    
                    UPViewMove *tileMove4 = UPViewMoveMake(tileView4, Role::WordTile4of4);
                    tileView4.highlighted = YES;
                    start(bloop_in(BandAboutPlayingUI, @[ tileMove4 ], 0.3, nil));
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        tileView4.highlighted = NO;

                    });
                    delay(BandAboutPlayingDelay, 1, ^{
                        [self nextStep];
                    });

                }));
            }));
        }));
    }));
}

- (void)nextStep
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
        case 3:
            [self animateToStepThree];
            break;
    }
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    
    UIColor *borderColor = [UIColor themeColorWithCategory:UPColorCategoryCanonical];
    self.botSpot.layer.borderColor = [borderColor colorWithAlphaComponent:0.6].CGColor;
    self.botSpot.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
}

@end
