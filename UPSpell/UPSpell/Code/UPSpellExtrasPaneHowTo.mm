//
//  UPSpellExtrasPaneHowTo.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <map>
#import <vector>

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPRandom.h>
#import <UpKit/UPGameTimer.h>
#import <UpKit/UPGameTimerLabel.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellExtrasPaneHowTo.h"
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
using UP::Random;
using UP::SpellLayout;
using UP::TileArray;
using UP::TileCount;
using UP::TileIndex;
using UP::TileModel;
using UP::TilePosition;
using UP::TileTray;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;
using UP::TimeSpanning::slide;
using UP::TimeSpanning::ease;
using UP::TimeSpanning::shake;

using UP::TimeSpanning::cancel;
using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

@interface UPSpellExtrasPaneHowTo ()
@property (nonatomic) BOOL active;
@property (nonatomic) int step;
@property (nonatomic) UPSpellGameView *gameView;
@property (nonatomic) UPLabel *bottomPromptLabel;
@property (nonatomic) UIView *botSpot;
@property (nonatomic) UIView *botSpotTapIndicator;
@property (nonatomic) NSArray *tileViews;
@property (nonatomic) Role bottomPromptLabelRole;
@property (nonatomic) Spot bottomPromptLabelOffscreenSpot;
@end

@implementation UPSpellExtrasPaneHowTo

+ (UPSpellExtrasPaneHowTo *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.gameView = [[UPSpellGameView alloc] init];
    self.gameView.center = layout.center_for(Role::ExtrasHowToGameView);
    self.gameView.transform = layout.about_playing_game_view_transform();
    self.gameView.userInteractionEnabled = NO;
    [self addSubview:self.gameView];

    CGRect botSpotFrame = up_rect_scaled(CGRectMake(0, 0, 92, 92), layout.layout_scale());
    self.botSpot = [[UIView alloc] initWithFrame:botSpotFrame];

    CGRect botSpotTapIndicatorFrame = up_rect_scaled(CGRectMake(15, 15, 62, 62), layout.layout_scale());
    self.botSpotTapIndicator = [[UIView alloc] initWithFrame:botSpotTapIndicatorFrame];
    self.botSpotTapIndicator.layer.cornerRadius = up_float_scaled(31, layout.layout_scale());
    [self.botSpot addSubview:self.botSpotTapIndicator];
    [self.gameView addSubview:self.botSpot];

    self.gameTimer = [[UPGameTimer alloc] initWithDuration:UPGameTimerDefaultDuration];
    [self.gameTimer addObserver:self.gameView.timerLabel];
    [self.gameTimer notifyObservers];
    
    self.bottomPromptLabel = [UPLabel label];
    self.bottomPromptLabelRole = Role::ExtrasHowToBottomPrompt;
    self.bottomPromptLabelOffscreenSpot = Spot::OffBottomNear;
    self.bottomPromptLabel.frame = layout.frame_for(self.bottomPromptLabelRole);
    self.bottomPromptLabel.font = layout.placard_description_font();
    self.bottomPromptLabel.colorCategory = UPColorCategoryInformation;
    self.bottomPromptLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bottomPromptLabel];
    
    return self;
}

- (void)configureForFullScreen
{
    SpellLayout &layout = SpellLayout::instance();
    self.gameView.center = layout.center_for(Role::Screen);
    self.gameView.transform = CGAffineTransformIdentity;
}

- (void)commonConfigure
{
    SpellLayout &layout = SpellLayout::instance();
    
    self.gameView.alpha = 1;
    self.bottomPromptLabel.alpha = 1;
    self.botSpot.alpha = 1;
    self.botSpot.transform = CGAffineTransformIdentity;
    self.botSpot.frame = up_rect_scaled(CGRectMake(0, 0, 92, 92), layout.layout_scale());
    self.botSpot.cornerRadius = up_rect_width(self.botSpot.frame) * 0.5;
    self.botSpot.borderWidth = up_float_scaled(6, layout.layout_scale());
    self.gameView.wordTrayControl.active = NO;
    self.step = 1;
    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        TileModel model;
        switch (idx) {
            case 0:
                model = TileModel(U'B');
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
        tileView.tag = idx;
        tileView.band = BandAboutPlayingUI;
        tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
        [self.gameView.tileContainerView addSubview:tileView];
    }
    
    self.tileViews = self.gameView.tileContainerView.subviews;
    
    [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];
    
    [self updateThemeColors];
    
    self.active = YES;
    
    self.bottomPromptLabel.string = @"";
    self.bottomPromptLabel.frame = layout.frame_for(self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    self.botSpot.center = layout.center_for(Role::DialogMessageCenteredInWordTray);
    
    self.gameView.wordScoreLabel.hidden = YES;
    self.gameView.gameScoreLabel.string = @"0";
    
    [self.gameTimer resetTo:60];
}

// =========================================================================================================================================

- (void)configureForBot
{
    SpellLayout &layout = SpellLayout::instance();
    
    self.gameView.alpha = 1;
    self.botSpot.alpha = 1;
    self.botSpot.transform = CGAffineTransformIdentity;
    self.botSpot.frame = up_rect_scaled(CGRectMake(0, 0, 92, 92), layout.layout_scale());
    self.botSpot.cornerRadius = up_rect_width(self.botSpot.frame) * 0.5;
    self.botSpot.borderWidth = up_float_scaled(6, layout.layout_scale());
    self.gameView.wordTrayControl.active = NO;
    
    [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];
    
    [self updateThemeColors];
    
    self.gameView.wordScoreLabel.hidden = YES;
    self.gameView.gameScoreLabel.string = @"0";
    
    [self.gameTimer resetTo:120];
}

- (void)centerBotSpotWithDuration:(CFTimeInterval)duration
{
    if (duration == 0) {
        SpellLayout &layout = SpellLayout::instance();
        self.botSpot.center = layout.center_for(Role::DialogMessageCenteredInWordTray);
    }
    else {
        UPViewMove *move = UPViewMoveMake(self.botSpot, Role::DialogMessageCenteredInWordTray);
        start(ease(BandAboutPlayingUI, @[ move ], duration, nil));
    }
}

- (void)setTilesFromString:(NSString *)string
{
    if (string.length != TileCount) {
        LOG(General, "setTilesFromString requires a string of 7 letters; got: %@", string);
        return;
    }
    
    SpellLayout &layout = SpellLayout::instance();
    
    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        char32_t c = [string characterAtIndex:idx];
        TileModel model(c);
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tileView.tag = idx;
        tileView.band = BandAboutPlayingUI;
        tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, idx)));
        [self.gameView.tileContainerView addSubview:tileView];
    }
    self.tileViews = self.gameView.tileContainerView.subviews;
}

- (void)bloopInTilesFromString:(NSString *)string
{
    if (string.length != TileCount) {
        LOG(General, "bloopInTilesFromString requires a string of 7 letters; got: %@", string);
        return;
    }
    
    [self setTilesFromString:string];
    
    SpellLayout &layout = SpellLayout::instance();
    for (UPTileView *tileView in self.tileViews) {
        tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, tileView.tag)), Spot::OffBottomNear);
    }

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    for (UPTileView *tileView in self.tileViews) {
        UPViewMove *move = UPViewMoveMake(tileView, role_in_player_tray(TilePosition(TileTray::Player, tileView.tag)));
        [moves addObject:move];
    }

    start(bloop_in(BandAboutPlayingUI, moves, 0.3, nil));
}

- (void)_botSpellWordWithWordTiles:(NSMutableArray *)wordTiles remainingTiles:(NSMutableArray *)remainingTiles wordLength:(int)wordLength completion:(void (^)(void))completion
{
    if (remainingTiles.count == 0) {
        return;
    }
    
    UPTileView *tileView = remainingTiles.firstObject;
    [remainingTiles removeObjectAtIndex:0];
    
    // move the bot spot
    UPViewMove *botSpotMove = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, tileView.tag)));
    start(ease(BandAboutPlayingUI, @[ botSpotMove ], 0.4, ^(UIViewAnimatingPosition) {
        // tap
        [self botSpotTap];
        
        // shift existing word tiles
        NSMutableArray<UPViewMove *> *tileShifts = [NSMutableArray array];
        int wordIdx = 1;
        for (UPTileView *wordTile in wordTiles) {
            Role wordTileRole = Role::WordTile1of1;
            switch (wordLength) {
                case 0: {
                    wordTileRole = Role::WordTile1of1;
                    break;
                }
                case 1: {
                    switch (wordIdx) {
                        case 1:
                            wordTileRole = Role::WordTile1of2;
                            break;
                        case 2:
                            wordTileRole = Role::WordTile2of2;
                            break;
                    }
                    break;
                }
                case 2: {
                    switch (wordIdx) {
                        case 1:
                            wordTileRole = Role::WordTile1of3;
                            break;
                        case 2:
                            wordTileRole = Role::WordTile2of3;
                            break;
                        case 3:
                            wordTileRole = Role::WordTile3of3;
                            break;
                    }
                    break;
                }
                case 3: {
                    switch (wordIdx) {
                        case 1:
                            wordTileRole = Role::WordTile1of4;
                            break;
                        case 2:
                            wordTileRole = Role::WordTile2of4;
                            break;
                        case 3:
                            wordTileRole = Role::WordTile3of4;
                            break;
                        case 4:
                            wordTileRole = Role::WordTile4of4;
                            break;
                    }
                    break;
                }
                case 4: {
                    switch (wordIdx) {
                        case 1:
                            wordTileRole = Role::WordTile1of5;
                            break;
                        case 2:
                            wordTileRole = Role::WordTile2of5;
                            break;
                        case 3:
                            wordTileRole = Role::WordTile3of5;
                            break;
                        case 4:
                            wordTileRole = Role::WordTile4of5;
                            break;
                        case 5:
                            wordTileRole = Role::WordTile5of5;
                            break;
                    }
                    break;
                }
                case 5: {
                    switch (wordIdx) {
                        case 1:
                            wordTileRole = Role::WordTile1of6;
                            break;
                        case 2:
                            wordTileRole = Role::WordTile2of6;
                            break;
                        case 3:
                            wordTileRole = Role::WordTile3of6;
                            break;
                        case 4:
                            wordTileRole = Role::WordTile4of6;
                            break;
                        case 5:
                            wordTileRole = Role::WordTile5of6;
                            break;
                        case 6:
                            wordTileRole = Role::WordTile6of6;
                            break;
                    }
                    break;
                }
                case 6: {
                    switch (wordIdx) {
                        case 1:
                            wordTileRole = Role::WordTile1of7;
                            break;
                        case 2:
                            wordTileRole = Role::WordTile2of7;
                            break;
                        case 3:
                            wordTileRole = Role::WordTile3of7;
                            break;
                        case 4:
                            wordTileRole = Role::WordTile4of7;
                            break;
                        case 5:
                            wordTileRole = Role::WordTile5of7;
                            break;
                        case 6:
                            wordTileRole = Role::WordTile6of7;
                            break;
                        case 7:
                            wordTileRole = Role::WordTile7of7;
                            break;
                    }
                    break;
                }
            }
            wordTile.submitLocation = Location(wordTileRole);
            UPViewMove *tileShift = UPViewMoveMake(wordTile, wordTileRole);
            [tileShifts addObject:tileShift];
            wordIdx++;
        }
        start(slide(BandAboutPlayingUI, tileShifts, 0.1, nil));

        [wordTiles addObject:tileView];
        
        Role tapTileRole = Role::WordTile1of1;
        switch (wordIdx) {
            case 1:
                tapTileRole = Role::WordTile1of1;
                break;
            case 2:
                tapTileRole = Role::WordTile2of2;
                break;
            case 3:
                tapTileRole = Role::WordTile3of3;
                break;
            case 4:
                tapTileRole = Role::WordTile4of4;
                break;
            case 5:
                tapTileRole = Role::WordTile5of5;
                break;
            case 6:
                tapTileRole = Role::WordTile6of6;
                break;
            case 7:
                tapTileRole = Role::WordTile7of7;
                break;

        }

        // move tapped tile
        UPViewMove *tileMove = UPViewMoveMake(tileView, tapTileRole);
        tileView.submitLocation = Location(tapTileRole);
        tileView.highlighted = YES;
        [self botSpotTap];
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
        start(bloop_in(BandAboutPlayingUI, @[ tileMove ], 0.3, nil));
        delay(BandAboutPlayingDelay, 0.2, ^{
            [self botSpotRelease];
            tileView.highlighted = NO;
        });

        if (remainingTiles.count) {
            [self _botSpellWordWithWordTiles:wordTiles remainingTiles:remainingTiles wordLength:wordLength + 1 completion:completion];
        }
        else {
            if (completion) {
                completion();
            }
        }
        
    }));
}

- (void)botSpellWord:(NSString *)string completion:(void (^)(void))completion
{
    std::map<NSInteger, TilePosition> letter_tray_positions;
    for (UPTileView *tileView in self.tileViews) {
        letter_tray_positions[tileView.tag] = TilePosition(TileTray::Player, tileView.tag);
    }
    
    NSMutableArray *tapTiles = [NSMutableArray array];
    
    for (int idx = 0; idx < string.length; idx++) {
        char32_t c = [string characterAtIndex:idx];
        UPTileView *foundTileView = nil;
        for (UPTileView *tileView in self.tileViews) {
            TilePosition position = letter_tray_positions[tileView.tag];
            if (position.in_word_tray() || tileView.glyph != c || [tapTiles containsObject:tileView]) {
                continue;
            }
            foundTileView = tileView;
            break;
        }
        if (!foundTileView) {
            LOG(General, "botSpellWord can't spell: %@", string);
            return;
        }
        [tapTiles addObject:foundTileView];
        LOG(General, "found tile: %c => %ld", c, foundTileView.tag);
    }

    [self _botSpellWordWithWordTiles:[NSMutableArray array] remainingTiles:tapTiles wordLength:0 completion:completion];
}

- (void)submitWordReplacingWithTilesFromString:(NSString *)string
{
    NSMutableArray<UPViewMove *> *tileMoves = [NSMutableArray array];
    NSMutableArray<UPTileView *> *remainingTiles = [NSMutableArray array];
    [remainingTiles addObjectsFromArray:self.tileViews];
    
    int score = 0;
    int multiplier = 1;

    for (UPTileView *tileView in self.tileViews) {
        Location location = tileView.submitLocation;
        Role role = location.role();
        if (role == Role::WordTile1of1 ||
            role == Role::WordTile1of2 || role == Role::WordTile2of2 ||
            role == Role::WordTile1of3 || role == Role::WordTile2of3 || role == Role::WordTile3of3 ||
            role == Role::WordTile1of4 || role == Role::WordTile2of4 || role == Role::WordTile3of4 || role == Role::WordTile4of4 ||
            role == Role::WordTile1of5 || role == Role::WordTile2of5 || role == Role::WordTile3of5 || role ==  Role::WordTile4of5 || role ==  Role::WordTile5of5 ||
            role == Role::WordTile1of6 || role == Role::WordTile2of6 || role == Role::WordTile3of6 || role ==  Role::WordTile4of6 || role ==  Role::WordTile5of6 || role ==  Role::WordTile6of6 ||
            role == Role::WordTile1of7 || role == Role::WordTile2of7 || role == Role::WordTile3of7 || role ==  Role::WordTile4of7 || role ==  Role::WordTile5of7 || role ==  Role::WordTile6of7 || role ==  Role::WordTile7of7) {
            Location location(role, Spot::OffTopNear);
            [tileMoves addObject:UPViewMoveMake(tileView, location)];
            [remainingTiles removeObject:tileView];
            score += tileView.score;
            multiplier *= tileView.multiplier;
            LOG(General, "found tile: %@", tileView);
        }
    }

    SpellLayout &layout = SpellLayout::instance();
    self.gameView.wordScoreLabel.frame = layout.frame_for(Role::WordScore, Spot::OffBottomFar);
    self.gameView.wordScoreLabel.hidden = NO;

    UPViewMove *wordScoreInMove = UPViewMoveMake(self.gameView.wordScoreLabel, Role::WordScore);
    UIColor *wordScoreColor = [UIColor themeColorWithCategory:self.gameView.wordScoreLabel.colorCategory];
    NSString *scoreString = [NSString stringWithFormat:@"+%d", score * multiplier];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:scoreString];
    NSRange range = NSMakeRange(0, scoreString.length);
    [attrString addAttribute:NSFontAttributeName value:layout.word_score_font() range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:wordScoreColor range:range];
    self.gameView.wordScoreLabel.attributedString = attrString;
    
    UPViewMove *botSpotMove = UPViewMoveMake(self.botSpot, Role::WordTile2of6);
    start(ease(BandAboutPlayingUI, @[ botSpotMove ], 0.4, ^(UIViewAnimatingPosition) {
        
        delay(BandAboutPlayingDelay, 0.5, ^{
            self.gameView.wordTrayControl.highlighted = YES;
            [self botSpotTap];
            [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];

            int gameScore = [self.gameView.gameScoreLabel.string intValue];
            gameScore += score * multiplier;
            self.gameView.gameScoreLabel.string = [NSString stringWithFormat:@"%d", gameScore];

            start(bloop_out(BandAboutPlayingUI, tileMoves, 0.3, ^(UIViewAnimatingPosition) {
                for (UPViewMove *move in tileMoves) {
                    [move.view removeFromSuperview];
                }
                self.tileViews = self.gameView.tileContainerView.subviews;
                NSMutableSet *partialTileViewsIndexes = [NSMutableSet set];
                for (UPTileView *tileView in self.tileViews) {
                    [partialTileViewsIndexes addObject:@(tileView.tag)];
                }
                int sidx = 0;
                NSMutableArray *newTiles = [NSMutableArray array];
                for (size_t tidx = 0; tidx < TileCount; tidx++) {
                    if ([partialTileViewsIndexes containsObject:@(tidx)]) {
                        continue;
                    }
                    char32_t c = [string characterAtIndex:sidx];
                    TileModel model;
                    if (sidx == 0) {
                        model = TileModel(c, 2);
                    }
                    else {
                        model = TileModel(c);
                    }
                    sidx++;
                    UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
                    tileView.tag = tidx;
                    tileView.band = BandAboutPlayingUI;
                    tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, tidx)));
                    [self.gameView.tileContainerView addSubview:tileView];
                    [newTiles addObject:tileView];
                }
                self.tileViews = self.gameView.tileContainerView.subviews;
                
                for (UPTileView *tileView in newTiles) {
                    tileView.frame = layout.frame_for(role_in_player_tray(TilePosition(TileTray::Player, tileView.tag)), Spot::OffBottomNear);
                }
                
                NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
                for (UPTileView *tileView in newTiles) {
                    UPViewMove *move = UPViewMoveMake(tileView, role_in_player_tray(TilePosition(TileTray::Player, tileView.tag)));
                    [moves addObject:move];
                }
                
                start(bloop_in(BandAboutPlayingUI, moves, 0.3, nil));
                
            }));

            delay(BandAboutPlayingDelay, 0.2, ^{
                self.gameView.wordTrayControl.highlighted = NO;
                self.gameView.wordTrayControl.active = NO;
                [self botSpotRelease];
            });
        });

        delay(BandAboutPlayingDelay, 0.75, ^{
            start(bloop_in(BandAboutPlayingUI, @[wordScoreInMove], 0.3, ^(UIViewAnimatingPosition) {
                delay(BandAboutPlayingUI, 1.2, ^{
                    UPViewMove *wordScoreOutMove = UPViewMoveMake(self.gameView.wordScoreLabel, Role::WordScore, Spot::OffTopNear);
                    start(bloop_out(BandAboutPlayingUI, @[wordScoreOutMove], 0.2, ^(UIViewAnimatingPosition) {
                        self.gameView.wordScoreLabel.hidden = YES;
                    }));
                });
            }));
        });
    }));

    
}

// =========================================================================================================================================

- (void)startTutorial
{
    [self.gameTimer start];
    
    self.step = 0;
    delay(BandAboutPlayingDelay, 1.5, ^{
        [self nextStep];
    });
}

- (void)prepare
{
    [self commonConfigure];
    [self.gameTimer start];
    
    delay(BandAboutPlayingDelay, 1.5, ^{
        [self nextStep];
    });
}

- (void)finish
{
    cancel(BandAboutPlaying);
    SpellLayout &layout = SpellLayout::instance();
    self.bottomPromptLabel.string = @"";
    self.bottomPromptLabel.frame = layout.frame_for(self.bottomPromptLabelRole);
    self.active = NO;
    [self.gameTimer stop];
}

- (void)botSpotTap
{
    self.botSpotTapIndicator.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.botSpotTapIndicator.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryCanonical];
    self.botSpotTapIndicator.alpha = 0.7;

    [UIView animateWithDuration:0.15 animations:^{
        self.botSpotTapIndicator.transform = CGAffineTransformIdentity;
        self.botSpotTapIndicator.alpha = 0;
    }];
}

- (void)botSpotRelease
{
//    self.botSpot.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)highlight2XLetterFive
{
    [UIView animateWithDuration:0.3 animations:^{
        SpellLayout &layout = SpellLayout::instance();
        self.botSpot.transform = CGAffineTransformIdentity;
        self.botSpot.backgroundColor = [UIColor clearColor];
        self.botSpot.frame = layout.frame_for(Role::ExtrasHowTo2xCallout);
        self.botSpot.cornerRadius = up_rect_width(self.botSpot.frame) * 0.5;
        self.botSpot.borderWidth = up_float_scaled(4, layout.layout_scale());
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.botSpot.transform = CGAffineTransformMakeScale(7, 7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.75 animations:^{
                self.botSpot.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.botSpot.alpha = 0;
                }];
            }];
        }];
    }];
}

- (void)animateToStepOne
{
    if (!self.active) {
        return;
    }
    
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    [moves addObject:UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot)];
    start(bloop_out(BandAboutPlayingUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        if (self.active) {
            [self nextStep];
        }
    }));
}

- (void)animateToStepTwo
{
    if (!self.active) {
        return;
    }

    self.bottomPromptLabel.string = @"TAP LETTERS TO SPELL WORDS";
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    [moves addObject:UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole)];
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
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 0.4, ^(UIViewAnimatingPosition) {
        
        if (!self.active) {
            return;
        }

        UPViewMove *tileMove1 = UPViewMoveMake(tileView1, Role::WordTile1of1);
        tileView1.highlighted = YES;
        [self botSpotTap];
        start(bloop_in(BandAboutPlayingUI, @[ tileMove1 ], 0.3, nil));
        delay(BandAboutPlayingDelay, 0.2, ^{
            [self botSpotRelease];
            tileView1.highlighted = NO;
            [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
        });
                                               
        UPViewMove *botSpotMove2 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 1)));
        start(ease(BandAboutPlayingUI, @[ botSpotMove2 ], 0.4, ^(UIViewAnimatingPosition) {

            if (!self.active) {
                return;
            }

            UPViewMove *tileMove1a = UPViewMoveMake(tileView1, Role::WordTile1of2);
            start(slide(BandAboutPlayingUI, @[ tileMove1a ], 0.1, nil));

            UPViewMove *tileMove2 = UPViewMoveMake(tileView2, Role::WordTile2of2);
            tileView2.highlighted = YES;
            [self botSpotTap];
            start(bloop_in(BandAboutPlayingUI, @[ tileMove2 ], 0.3, nil));
            delay(BandAboutPlayingDelay, 0.2, ^{
                [self botSpotRelease];
                tileView2.highlighted = NO;
            });

            UPViewMove *botSpotMove3 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 6)));
            start(ease(BandAboutPlayingUI, @[ botSpotMove3 ], 0.4, ^(UIViewAnimatingPosition) {

                if (!self.active) {
                    return;
                }

                UPViewMove *tileMove1b = UPViewMoveMake(tileView1, Role::WordTile1of3);
                UPViewMove *tileMove2b = UPViewMoveMake(tileView2, Role::WordTile2of3);
                start(slide(BandAboutPlayingUI, @[ tileMove1b, tileMove2b ], 0.1, nil));
                
                UPViewMove *tileMove3 = UPViewMoveMake(tileView3, Role::WordTile3of3);
                [self botSpotTap];
                tileView3.highlighted = YES;
                start(bloop_in(BandAboutPlayingUI, @[ tileMove3 ], 0.3, nil));
                delay(BandAboutPlayingDelay, 0.2, ^{
                    [self botSpotRelease];
                    tileView3.highlighted = NO;
                });

                UPViewMove *botSpotMove4 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 2)));
                start(ease(BandAboutPlayingUI, @[ botSpotMove4 ], 0.4, ^(UIViewAnimatingPosition) {

                    if (!self.active) {
                        return;
                    }

                    UPViewMove *tileMove1c = UPViewMoveMake(tileView1, Role::WordTile1of4);
                    UPViewMove *tileMove2c = UPViewMoveMake(tileView2, Role::WordTile2of4);
                    UPViewMove *tileMove3c = UPViewMoveMake(tileView3, Role::WordTile3of4);
                    start(slide(BandAboutPlayingUI, @[ tileMove1c, tileMove2c, tileMove3c ], 0.1, nil));
                    
                    UPViewMove *tileMove4 = UPViewMoveMake(tileView4, Role::WordTile4of4);
                    [self botSpotTap];
                    tileView4.highlighted = YES;
                    start(bloop_in(BandAboutPlayingUI, @[ tileMove4 ], 0.3, nil));
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        [self botSpotRelease];
                        tileView4.highlighted = NO;
                    });
                    delay(BandAboutPlayingDelay, 1, ^{
                        [self animateToStepThreeB];
                    });
                }));
            }));
        }));
    }));
}

- (void)animateToStepThreeB
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        if (!self.active) {
            return;
        }
        
        self.bottomPromptLabel.string = @"WHEN YOU’VE SPELLED A WORD…";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
            
            delay(BandAboutPlayingDelay, 1.75, ^{
                [self animateToStepThreeC];
            });

        }));
    }));
}

- (void)animateToStepThreeC
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        if (!self.active) {
            return;
        }
        
        self.bottomPromptLabel.string = @"THE WORD TRAY LIGHTS UP";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
            
            delay(BandAboutPlayingDelay, 1.25, ^{
                self.gameView.wordTrayControl.active = YES;
                delay(BandAboutPlayingDelay, 1.0, ^{
                    [self nextStep];
                });
            });
            
        }));
    }));
}

- (void)animateToStepFour
{
    if (!self.active) {
        return;
    }

    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        if (!self.active) {
            return;
        }

        self.bottomPromptLabel.string = @"TAP A LIT-UP WORD TRAY TO SCORE POINTS";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandAboutPlayingDelay, 1.25, ^{
                [self nextStep];
            });
        }));
    }));
}

- (void)animateToStepFive
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *botSpotMove = UPViewMoveMake(self.botSpot, Role::WordTile2of6);
    start(ease(BandAboutPlayingUI, @[ botSpotMove ], 0.4, ^(UIViewAnimatingPosition) {
        if (!self.active) {
            return;
        }

        delay(BandAboutPlayingDelay, 0.5, ^{
            self.gameView.wordTrayControl.highlighted = YES;
            [self botSpotTap];

            delay(BandAboutPlayingDelay, 0.2, ^{
                self.gameView.wordTrayControl.highlighted = NO;
                self.gameView.wordTrayControl.active = NO;
                [self botSpotRelease];
                [self nextStep];
            });
        });
    }));
}

- (void)animateToStepSix
{
    if (!self.active) {
        return;
    }

    SpellLayout &layout = SpellLayout::instance();

    UPTileView *tileView1 = self.tileViews[4];
    UPTileView *tileView2 = self.tileViews[1];
    UPTileView *tileView3 = self.tileViews[6];
    UPTileView *tileView4 = self.tileViews[2];
    
    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    [moves addObject:UPViewMoveMake(tileView1, Role::WordTile1of4, Spot::OffTopNear)];
    [moves addObject:UPViewMoveMake(tileView2, Role::WordTile2of4, Spot::OffTopNear)];
    [moves addObject:UPViewMoveMake(tileView3, Role::WordTile3of4, Spot::OffTopNear)];
    [moves addObject:UPViewMoveMake(tileView4, Role::WordTile4of4, Spot::OffTopNear)];
    start(bloop_out(BandAboutPlayingUI, moves, 0.3, ^(UIViewAnimatingPosition) {
        [tileView1 removeFromSuperview];
        [tileView2 removeFromSuperview];
        [tileView3 removeFromSuperview];
        [tileView4 removeFromSuperview];

        NSMutableArray<UPViewMove *> *tileMoves = [NSMutableArray array];
        for (TileIndex idx = 0; idx < TileCount; idx++) {
            TileModel model;
            switch (idx) {
                case 0:
                case 3:
                case 5:
                    continue;
                case 1:
                    model = TileModel(U'Z');
                    break;
                case 2:
                    model = TileModel(U'W');
                    break;
                case 4:
                    model = TileModel(U'J');
                    break;
                case 6:
                    model = TileModel(U'X');
                    break;
            }
            UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
            tileView.tag = idx;
            tileView.band = BandAboutPlayingUI;
            Role role = role_in_player_tray(TilePosition(TileTray::Player, idx));
            tileView.frame = layout.frame_for(role, Spot::OffBottomNear);
            [tileMoves addObject:UPViewMoveMake(tileView, role)];
            [self.gameView.tileContainerView addSubview:tileView];
        }
        self.tileViews = self.gameView.tileContainerView.subviews;
        start(bloop_in(BandAboutPlayingUI, tileMoves, 0.3, nil));
    }));

    self.gameView.wordScoreLabel.frame = layout.frame_for(Role::WordScore, Spot::OffBottomFar);
    self.gameView.wordScoreLabel.hidden = NO;

    self.gameView.gameScoreLabel.string = @"7";
    
    UPViewMove *wordScoreInMove = UPViewMoveMake(self.gameView.wordScoreLabel, Role::WordScore);
    UIColor *wordScoreColor = [UIColor themeColorWithCategory:self.gameView.wordScoreLabel.colorCategory];
    NSString *scoreString = @"+7";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:scoreString];
    NSRange range = NSMakeRange(0, scoreString.length);
    [attrString addAttribute:NSFontAttributeName value:layout.word_score_font() range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:wordScoreColor range:range];
    self.gameView.wordScoreLabel.attributedString = attrString;
    
    [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];

    self.tileViews = self.gameView.tileContainerView.subviews;

    delay(BandAboutPlayingDelay, 0.25, ^{
        start(bloop_in(BandAboutPlayingUI, @[wordScoreInMove], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandAboutPlayingUI, 1.2, ^{
                UPViewMove *wordScoreOutMove = UPViewMoveMake(self.gameView.wordScoreLabel, Role::WordScore, Spot::OffTopNear);
                start(bloop_out(BandAboutPlayingUI, @[wordScoreOutMove], 0.2, ^(UIViewAnimatingPosition) {
                    self.gameView.wordScoreLabel.hidden = YES;
                }));
            });
        }));
    });

    delay(BandAboutPlayingDelay, 2, ^{
        [self animateToStepSixB];
    });

}

- (void)animateToStepSixB
{
    if (!self.active) {
        return;
    }

    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
    }));

    UPTileView *tileView1 = self.tileViews[0];
    UPTileView *tileView2 = self.tileViews[1];
    UPTileView *tileView3 = self.tileViews[4];
    UPTileView *tileView4 = self.tileViews[2];
    
    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 0)));
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 0.4, ^(UIViewAnimatingPosition) {
        
        if (!self.active) {
            return;
        }
        
        UPViewMove *tileMove1 = UPViewMoveMake(tileView1, Role::WordTile1of1);
        tileView1.highlighted = YES;
        [self botSpotTap];
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
        start(bloop_in(BandAboutPlayingUI, @[ tileMove1 ], 0.3, nil));
        delay(BandAboutPlayingDelay, 0.2, ^{
            tileView1.highlighted = NO;
            [self botSpotRelease];
        });
        
        UPViewMove *botSpotMove2 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 3)));
        start(ease(BandAboutPlayingUI, @[ botSpotMove2 ], 0.4, ^(UIViewAnimatingPosition) {
            
            if (!self.active) {
                return;
            }
            
            UPViewMove *tileMove1a = UPViewMoveMake(tileView1, Role::WordTile1of2);
            start(slide(BandAboutPlayingUI, @[ tileMove1a ], 0.1, nil));
            
            UPViewMove *tileMove2 = UPViewMoveMake(tileView2, Role::WordTile2of2);
            tileView2.highlighted = YES;
            [self botSpotTap];
            start(bloop_in(BandAboutPlayingUI, @[ tileMove2 ], 0.3, nil));
            delay(BandAboutPlayingDelay, 0.2, ^{
                tileView2.highlighted = NO;
                [self botSpotRelease];
            });
            
            UPViewMove *botSpotMove3 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 2)));
            start(ease(BandAboutPlayingUI, @[ botSpotMove3 ], 0.4, ^(UIViewAnimatingPosition) {
                
                if (!self.active) {
                    return;
                }
                
                UPViewMove *tileMove1b = UPViewMoveMake(tileView1, Role::WordTile1of3);
                UPViewMove *tileMove2b = UPViewMoveMake(tileView2, Role::WordTile2of3);
                start(slide(BandAboutPlayingUI, @[ tileMove1b, tileMove2b ], 0.1, nil));
                
                UPViewMove *tileMove3 = UPViewMoveMake(tileView3, Role::WordTile3of3);
                tileView3.highlighted = YES;
                [self botSpotTap];
                start(bloop_in(BandAboutPlayingUI, @[ tileMove3 ], 0.3, nil));
                delay(BandAboutPlayingDelay, 0.2, ^{
                    tileView3.highlighted = NO;
                    [self botSpotRelease];
                });
                
                UPViewMove *botSpotMove4 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 5)));
                start(ease(BandAboutPlayingUI, @[ botSpotMove4 ], 0.4, ^(UIViewAnimatingPosition) {
                    
                    if (!self.active) {
                        return;
                    }
                    
                    UPViewMove *tileMove1c = UPViewMoveMake(tileView1, Role::WordTile1of4);
                    UPViewMove *tileMove2c = UPViewMoveMake(tileView2, Role::WordTile2of4);
                    UPViewMove *tileMove3c = UPViewMoveMake(tileView3, Role::WordTile3of4);
                    start(slide(BandAboutPlayingUI, @[ tileMove1c, tileMove2c, tileMove3c ], 0.1, nil));
                    
                    UPViewMove *tileMove4 = UPViewMoveMake(tileView4, Role::WordTile4of4);
                    tileView4.highlighted = YES;
                    [self botSpotTap];
                    start(bloop_in(BandAboutPlayingUI, @[ tileMove4 ], 0.3, nil));
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        tileView4.highlighted = NO;
                        [self botSpotRelease];
                    });
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        [self animateToStepSixC];
                    });
                    
                }));
            }));
        }));
    }));
}

- (void)animateToStepSixC
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        self.bottomPromptLabel.string = @"TAPPING AN UNLIT WORD TRAY…";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {

            delay(BandAboutPlayingDelay, 0.5, ^{
                UPViewMove *botSpotMove = UPViewMoveMake(self.botSpot, Role::WordTile4of5);
                start(ease(BandAboutPlayingUI, @[ botSpotMove ], 0.4, ^(UIViewAnimatingPosition) {
                    if (!self.active) {
                        return;
                    }
                    delay(BandAboutPlayingDelay, 0.3, ^{
                        [self animateToStepSixD];
                    });
                }));
            });

        }));
    }));
}

- (void)animateToStepSixD
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        self.bottomPromptLabel.string = @"ASSESSES A TIME PENALTY";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {

            delay(BandAboutPlayingDelay, 1.0, ^{
                self.gameView.wordTrayControl.highlighted = YES;
                [self botSpotTap];
                
                delay(BandAboutPlayingDelay, 0.2, ^{
                    self.gameView.wordTrayControl.highlighted = NO;
                    [self botSpotRelease];
                    [self animateToStepSixE];
                });
            });

        }));
    }));
}

- (void)animateToStepSixE
{
    if (!self.active) {
        return;
    }

    SpellLayout &layout = SpellLayout::instance();

    CGFloat alpha = [UIColor themeDisabledAlpha];

    UPTileView *tileView1 = self.tileViews[0];
    UPTileView *tileView2 = self.tileViews[1];
    UPTileView *tileView3 = self.tileViews[4];
    UPTileView *tileView4 = self.tileViews[2];

    NSArray<UIView *> *shakeViews = @[
        self.gameView.wordTrayControl,
        tileView1,
        tileView2,
        tileView3,
        tileView4
    ];
    
    [UIView animateWithDuration:0.15 animations:^{
        for (UIView *view in shakeViews) {
            view.alpha = alpha;
        }
        self.gameView.tileContainerView.alpha = alpha;
        self.gameView.clearControl.alpha = alpha;
    }];

    delay(BandAboutPlayingDelay, 0.5, ^{
        start(shake(BandAboutPlayingUI, shakeViews, 0.9, layout.word_tray_shake_offset(), ^(UIViewAnimatingPosition finishedPosition) {
            delay(BandAboutPlayingDelay, 0.1, ^{
                [UIView animateWithDuration:0.15 animations:^{
                    for (UIView *view in shakeViews) {
                        view.alpha = 1;
                    }
                    self.gameView.tileContainerView.alpha = 1;
                    self.gameView.clearControl.alpha = 1;
                }];
            });
            delay(BandAboutPlayingDelay, 1.5, ^{
                [self animateToStepSixF];
            });
        }));
    });

}

- (void)animateToStepSixF
{
    if (!self.active) {
        return;
    }

    [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];

    UPTileView *tileView1 = self.tileViews[0];
    UPTileView *tileView2 = self.tileViews[1];
    UPTileView *tileView3 = self.tileViews[4];
    UPTileView *tileView4 = self.tileViews[2];

    UPViewMove *tileMove1 = UPViewMoveMake(tileView1, role_in_player_tray(TilePosition(TileTray::Player, 0)));
    UPViewMove *tileMove2 = UPViewMoveMake(tileView2, role_in_player_tray(TilePosition(TileTray::Player, 3)));
    UPViewMove *tileMove3 = UPViewMoveMake(tileView3, role_in_player_tray(TilePosition(TileTray::Player, 2)));
    UPViewMove *tileMove4 = UPViewMoveMake(tileView4, role_in_player_tray(TilePosition(TileTray::Player, 5)));
    start(bloop_in(BandAboutPlayingUI, @[ tileMove1, tileMove2, tileMove3, tileMove4 ], 0.3, ^(UIViewAnimatingPosition finishedPosition) {
        delay(BandAboutPlayingDelay, 1.5, ^{
            [self nextStep];
        });
    }));
}



- (void)animateToStepSeven
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        self.bottomPromptLabel.string = @"TAP TRASH TO DUMP LETTERS";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandAboutPlayingDelay, 1.5, ^{
                [self nextStep];
            });
        }));
    }));
}

- (void)animateToStepEight
{
    if (!self.active) {
        return;
    }

    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, Role::ExtrasHowToTopRightButtonClick);
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 0.8, ^(UIViewAnimatingPosition) {
        delay(BandAboutPlayingDelay, 0.2, ^{
            self.gameView.clearControl.highlighted = YES;
            [self botSpotTap];
            delay(BandAboutPlayingDelay, 0.2, ^{
                self.gameView.clearControl.highlighted = NO;
                [self botSpotRelease];
                [self nextStep];
            });
        });
    }));
}

- (void)animateToStepNine
{
    if (!self.active) {
        return;
    }

    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, nil));
    
    Random &random = Random::instance();
    
    std::array<size_t, TileCount> ridxs;
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        ridxs[idx] = idx;
    }
    std::shuffle(ridxs.begin(), ridxs.end(), random.generator());
    
    CFTimeInterval baseDelay = 0.125;
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        for (UPTileView *tileView in self.tileViews) {
            if (tileView.tag == idx) {
                Location location = Location(role_in_player_tray(TilePosition(TileTray::Player, idx)), Spot::OffBottomNear);
                UPAnimator *animator = slide(BandAboutPlayingUI, @[UPViewMoveMake(tileView, location)], 0.75, ^(UIViewAnimatingPosition) {
                    [tileView removeFromSuperview];
                });
                delay(BandAboutPlayingDelay, ridxs[idx] * baseDelay, ^{
                    start(animator);
                });
                break;
            }
        }
    }
    
    delay(BandAboutPlayingDelay, 2, ^{
        [self nextStep];
    });
}

- (void)animateToStepTen
{
    SpellLayout &layout = SpellLayout::instance();

    [self.gameView.tileContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray<UPViewMove *> *tileMoves = [NSMutableArray array];
    for (TileIndex idx = 0; idx < TileCount; idx++) {
        TileModel model;
        switch (idx) {
            case 0:
                model = TileModel(U'G');
                break;
            case 1:
                model = TileModel(U'L');
                break;
            case 2:
                model = TileModel(U'A');
                break;
            case 3:
                model = TileModel(U'E');
                break;
            case 4:
                model = TileModel(U'B');
                break;
            case 5:
                model = TileModel(U'S');
                break;
            case 6:
                model = TileModel(U'T', 2);
                break;
        }
        UPTileView *tileView = [UPTileView viewWithGlyph:model.glyph() score:model.score() multiplier:model.multiplier()];
        tileView.tag = idx;
        tileView.band = BandAboutPlayingUI;
        Role role = role_in_player_tray(TilePosition(TileTray::Player, idx));
        tileView.frame = layout.frame_for(role, Spot::OffBottomNear);
        [tileMoves addObject:UPViewMoveMake(tileView, role)];
        [self.gameView.tileContainerView addSubview:tileView];
    }
    self.tileViews = self.gameView.tileContainerView.subviews;
    start(bloop_in(BandAboutPlayingUI, tileMoves, 0.3, ^(UIViewAnimatingPosition) {
        [self nextStep];
    }));
}

- (void)animateToStepEleven
{
    if (!self.active) {
        return;
    }
    
    UPTileView *tileView1 = self.tileViews[0];
    UPTileView *tileView2 = self.tileViews[2];
    UPTileView *tileView3 = self.tileViews[4];
    UPTileView *tileView4 = self.tileViews[1];
    
    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 0)));
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 0.4, ^(UIViewAnimatingPosition) {
        
        if (!self.active) {
            return;
        }
        
        UPViewMove *tileMove1 = UPViewMoveMake(tileView1, Role::WordTile1of1);
        tileView1.highlighted = YES;
        [self botSpotTap];
        [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
        start(bloop_in(BandAboutPlayingUI, @[ tileMove1 ], 0.3, nil));
        delay(BandAboutPlayingDelay, 0.2, ^{
            tileView1.highlighted = NO;
            [self botSpotRelease];
        });
        
        UPViewMove *botSpotMove2 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 2)));
        start(ease(BandAboutPlayingUI, @[ botSpotMove2 ], 0.4, ^(UIViewAnimatingPosition) {
            
            if (!self.active) {
                return;
            }
            
            UPViewMove *tileMove1a = UPViewMoveMake(tileView1, Role::WordTile1of2);
            start(slide(BandAboutPlayingUI, @[ tileMove1a ], 0.1, nil));
            
            UPViewMove *tileMove2 = UPViewMoveMake(tileView2, Role::WordTile2of2);
            tileView2.highlighted = YES;
            [self botSpotTap];
            start(bloop_in(BandAboutPlayingUI, @[ tileMove2 ], 0.3, nil));
            delay(BandAboutPlayingDelay, 0.2, ^{
                tileView2.highlighted = NO;
                [self botSpotRelease];
            });
            
            UPViewMove *botSpotMove3 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 4)));
            start(ease(BandAboutPlayingUI, @[ botSpotMove3 ], 0.4, ^(UIViewAnimatingPosition) {
                
                if (!self.active) {
                    return;
                }
                
                UPViewMove *tileMove1b = UPViewMoveMake(tileView1, Role::WordTile1of3);
                UPViewMove *tileMove2b = UPViewMoveMake(tileView2, Role::WordTile2of3);
                start(slide(BandAboutPlayingUI, @[ tileMove1b, tileMove2b ], 0.1, nil));
                
                UPViewMove *tileMove3 = UPViewMoveMake(tileView3, Role::WordTile3of3);
                tileView3.highlighted = YES;
                [self botSpotTap];
                start(bloop_in(BandAboutPlayingUI, @[ tileMove3 ], 0.3, nil));
                delay(BandAboutPlayingDelay, 0.2, ^{
                    tileView3.highlighted = NO;
                    [self botSpotRelease];
                });
                
                UPViewMove *botSpotMove4 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 1)));
                start(ease(BandAboutPlayingUI, @[ botSpotMove4 ], 0.4, ^(UIViewAnimatingPosition) {
                    
                    if (!self.active) {
                        return;
                    }
                    
                    UPViewMove *tileMove1c = UPViewMoveMake(tileView1, Role::WordTile1of4);
                    UPViewMove *tileMove2c = UPViewMoveMake(tileView2, Role::WordTile2of4);
                    UPViewMove *tileMove3c = UPViewMoveMake(tileView3, Role::WordTile3of4);
                    start(slide(BandAboutPlayingUI, @[ tileMove1c, tileMove2c, tileMove3c ], 0.1, nil));
                    
                    UPViewMove *tileMove4 = UPViewMoveMake(tileView4, Role::WordTile4of4);
                    tileView4.highlighted = YES;
                    [self botSpotTap];
                    start(bloop_in(BandAboutPlayingUI, @[ tileMove4 ], 0.3, nil));
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        tileView4.highlighted = NO;
                        [self botSpotRelease];
                    });
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        [self nextStep];
                    });
                    
                }));
            }));
        }));
    }));
}

- (void)animateToStepTwelve
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        if (!self.active) {
            return;
        }
        
        self.bottomPromptLabel.string = @"TAP DOWN ARROW TO CLEAR WORD TRAY";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandAboutPlayingDelay, 1.5, ^{
                [self nextStep];
            });
        }));
    }));
}

- (void)animateToStepThirteen
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, Role::ExtrasHowToTopRightButtonClick);
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 0.8, ^(UIViewAnimatingPosition) {
        delay(BandAboutPlayingDelay, 0.2, ^{
            self.gameView.clearControl.highlighted = YES;
            [self botSpotTap];
            delay(BandAboutPlayingDelay, 0.2, ^{
                self.gameView.clearControl.highlighted = NO;
                [self botSpotRelease];
                [self nextStep];
            });
        });
    }));
}

- (void)animateToStepFourteen
{
    if (!self.active) {
        return;
    }

    [self.gameView.clearControl setContentPath:UP::RoundGameButtonTrashIconPath() forState:UPControlStateNormal];

    UPTileView *tileView1 = self.tileViews[0];
    UPTileView *tileView2 = self.tileViews[1];
    UPTileView *tileView3 = self.tileViews[2];
    UPTileView *tileView4 = self.tileViews[4];

    NSMutableArray<UPViewMove *> *moves = [NSMutableArray array];
    [moves addObject:UPViewMoveMake(tileView1, role_in_player_tray(TilePosition(TileTray::Player, 0)))];
    [moves addObject:UPViewMoveMake(tileView2, role_in_player_tray(TilePosition(TileTray::Player, 1)))];
    [moves addObject:UPViewMoveMake(tileView3, role_in_player_tray(TilePosition(TileTray::Player, 2)))];
    [moves addObject:UPViewMoveMake(tileView4, role_in_player_tray(TilePosition(TileTray::Player, 4)))];
    start(bloop_in(BandAboutPlayingUI, moves, 0.2, ^(UIViewAnimatingPosition) {
        delay(BandAboutPlayingDelay, 1, ^{
            [self nextStep];
        });
    }));
}

- (void)animateToStepFifteen
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        [self nextStep];
        self.bottomPromptLabel.string = @"TAP PAUSE BUTTON TO PAUSE GAME";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, nil));
    }));
}

- (void)animateToStepSixteen
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, Role::ExtrasHowToTopLeftButtonClick);
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 1.5, ^(UIViewAnimatingPosition) {
        delay(BandAboutPlayingDelay, 0.2, ^{
            delay(BandAboutPlayingDelay, 1.5, ^{
                UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
                start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, nil));
                [self nextStep];
            });
        });
    }));
}

- (void)animateToStepSeventeen
{
    if (!self.active) {
        return;
    }
    
    UPTileView *tileView1 = self.tileViews[4];
    UPTileView *tileView2 = self.tileViews[1];
    UPTileView *tileView3 = self.tileViews[2];
    UPTileView *tileView4 = self.tileViews[6];
    UPTileView *tileView5 = self.tileViews[5];

    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 4)));
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 0.4, ^(UIViewAnimatingPosition) {
        
        if (!self.active) {
            return;
        }
        
        UPViewMove *tileMove1 = UPViewMoveMake(tileView1, Role::WordTile1of1);
        tileView1.highlighted = YES;
        [self botSpotTap];
        start(bloop_in(BandAboutPlayingUI, @[ tileMove1 ], 0.3, nil));
        delay(BandAboutPlayingDelay, 0.2, ^{
            tileView1.highlighted = NO;
            [self botSpotRelease];
            [self.gameView.clearControl setContentPath:UP::RoundGameButtonDownArrowIconPath() forState:UPControlStateNormal];
        });
        
        UPViewMove *botSpotMove2 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 1)));
        start(ease(BandAboutPlayingUI, @[ botSpotMove2 ], 0.4, ^(UIViewAnimatingPosition) {
            
            if (!self.active) {
                return;
            }
            
            UPViewMove *tileMove1a = UPViewMoveMake(tileView1, Role::WordTile1of2);
            start(slide(BandAboutPlayingUI, @[ tileMove1a ], 0.1, nil));
            
            UPViewMove *tileMove2 = UPViewMoveMake(tileView2, Role::WordTile2of2);
            tileView2.highlighted = YES;
            [self botSpotTap];
            start(bloop_in(BandAboutPlayingUI, @[ tileMove2 ], 0.3, nil));
            delay(BandAboutPlayingDelay, 0.2, ^{
                tileView2.highlighted = NO;
                [self botSpotRelease];
            });
            
            UPViewMove *botSpotMove3 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 2)));
            start(ease(BandAboutPlayingUI, @[ botSpotMove3 ], 0.2, ^(UIViewAnimatingPosition) {
                
                if (!self.active) {
                    return;
                }
                
                UPViewMove *tileMove1b = UPViewMoveMake(tileView1, Role::WordTile1of3);
                UPViewMove *tileMove2b = UPViewMoveMake(tileView2, Role::WordTile2of3);
                start(slide(BandAboutPlayingUI, @[ tileMove1b, tileMove2b ], 0.1, nil));
                
                UPViewMove *tileMove3 = UPViewMoveMake(tileView3, Role::WordTile3of3);
                tileView3.highlighted = YES;
                [self botSpotTap];
                start(bloop_in(BandAboutPlayingUI, @[ tileMove3 ], 0.3, nil));
                delay(BandAboutPlayingDelay, 0.2, ^{
                    tileView3.highlighted = NO;
                    [self botSpotRelease];
                });
                
                UPViewMove *botSpotMove4 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 6)));
                start(ease(BandAboutPlayingUI, @[ botSpotMove4 ], 0.4, ^(UIViewAnimatingPosition) {
                    
                    if (!self.active) {
                        return;
                    }
                    
                    UPViewMove *tileMove1c = UPViewMoveMake(tileView1, Role::WordTile1of4);
                    UPViewMove *tileMove2c = UPViewMoveMake(tileView2, Role::WordTile2of4);
                    UPViewMove *tileMove3c = UPViewMoveMake(tileView3, Role::WordTile3of4);
                    start(slide(BandAboutPlayingUI, @[ tileMove1c, tileMove2c, tileMove3c ], 0.1, nil));
                    
                    UPViewMove *tileMove4 = UPViewMoveMake(tileView4, Role::WordTile4of4);
                    tileView4.highlighted = YES;
                    [self botSpotTap];
                    start(bloop_in(BandAboutPlayingUI, @[ tileMove4 ], 0.3, nil));
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        tileView4.highlighted = NO;
                        [self botSpotRelease];
                    });
                    delay(BandAboutPlayingDelay, 0.2, ^{
                        UPViewMove *botSpotMove5 = UPViewMoveMake(self.botSpot, role_in_player_tray(TilePosition(TileTray::Player, 5)));
                        start(ease(BandAboutPlayingUI, @[ botSpotMove5 ], 0.2, ^(UIViewAnimatingPosition) {
                            
                            if (!self.active) {
                                return;
                            }
                            
                            UPViewMove *tileMove1d = UPViewMoveMake(tileView1, Role::WordTile1of5);
                            UPViewMove *tileMove2d = UPViewMoveMake(tileView2, Role::WordTile2of5);
                            UPViewMove *tileMove3d = UPViewMoveMake(tileView3, Role::WordTile3of5);
                            UPViewMove *tileMove4d = UPViewMoveMake(tileView4, Role::WordTile4of5);
                            start(slide(BandAboutPlayingUI, @[ tileMove1d, tileMove2d, tileMove3d, tileMove4d ], 0.1, nil));
                            
                            UPViewMove *tileMove5 = UPViewMoveMake(tileView5, Role::WordTile5of5);
                            tileView5.highlighted = YES;
                            [self botSpotTap];
                            start(bloop_in(BandAboutPlayingUI, @[ tileMove5 ], 0.3, nil));
                            delay(BandAboutPlayingDelay, 0.2, ^{
                                tileView5.highlighted = NO;
                                [self botSpotRelease];
                            });
                            delay(BandAboutPlayingDelay, 1, ^{
                                [self nextStep];
                            });
                        }));
                    });
                }));
            }));
        }));
    }));
}

- (void)animateToStepEighteen
{
    self.bottomPromptLabel.string = @"DRAG TO REARRANGE LETTERS";
    UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
    start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
        delay(BandAboutPlayingDelay, 1.25, ^{
            [self nextStep];
        });
    }));
}

- (void)animateToStepNineteen
{
    if (!self.active) {
        return;
    }

    UPViewMove *botSpotMove1 = UPViewMoveMake(self.botSpot, Role::WordTile5of5);
    start(ease(BandAboutPlayingUI, @[ botSpotMove1 ], 0.5, ^(UIViewAnimatingPosition) {
        delay(BandAboutPlayingDelay, 0.3, ^{
            UPViewMove *botSpotMove2 = UPViewMoveMake(self.botSpot, Role::WordTile4of5);
            UPTileView *tileView1 = self.tileViews[5];
            UPTileView *tileView2 = self.tileViews[6];
            UPViewMove *tileMove1 = UPViewMoveMake(tileView1, Role::WordTile4of5);
            UPViewMove *tileMove2 = UPViewMoveMake(tileView2, Role::WordTile5of5);
            [self botSpotTap];
            start(ease(BandAboutPlayingUI, @[ botSpotMove2, tileMove1, tileMove2 ], 0.3, ^(UIViewAnimatingPosition) {
                [self botSpotRelease];
                self.gameView.wordTrayControl.active = YES;
                delay(BandAboutPlayingDelay, 1, ^{
                    [self nextStep];
                });
            }));
        });
    }));
}

- (void)animateToStepTwenty
{
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        self.bottomPromptLabel.string = @"2x TILES DOUBLE YOUR WORD SCORE";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandAboutPlayingDelay, 1, ^{
                [UIView animateWithDuration:0.3 animations:^{
                    self.botSpot.backgroundColor = [UIColor clearColor];
                    self.botSpot.transform = CGAffineTransformMakeScale(2.5, 2.5);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        SpellLayout &layout = SpellLayout::instance();
                        self.botSpot.transform = CGAffineTransformIdentity;
                        self.botSpot.frame = layout.frame_for(Role::ExtrasHowTo2xCallout);
                        self.botSpot.cornerRadius = up_rect_width(self.botSpot.frame) * 0.5;
                        self.botSpot.borderWidth = up_float_scaled(4, layout.layout_scale());
                    } completion:^(BOOL finished) {
                        delay(BandAboutPlayingDelay, 0.25, ^{
                            [self nextStep];
                        });
                    }];
                }];
            });
        }));
    }));
}

- (void)animateToStepTwentyOne
{
    if (!self.active) {
        return;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        self.botSpot.transform = CGAffineTransformMakeScale(7, 7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.75 animations:^{
            self.botSpot.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.75 animations:^{
                self.botSpot.transform = CGAffineTransformMakeScale(7, 7);
                self.botSpot.alpha = 0;
            } completion:^(BOOL finished) {
                delay(BandAboutPlayingDelay, 0.5, ^{
                    if (!self.active) {
                        return;
                    }
                    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
                    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
                        self.bottomPromptLabel.string = @"SPELL ALL YOU CAN IN TWO MINUTES!";
                        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
                        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
                            delay(BandAboutPlayingDelay, 2.5, ^{
                                [self nextStep];
                            });
                        }));
                    }));
                });
            }];
        }];
    }];
}

- (void)animateToStepTwentyTwo
{
    if (!self.active) {
        return;
    }
    
    UPViewMove *moveOut = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole, self.bottomPromptLabelOffscreenSpot);
    start(bloop_out(BandAboutPlayingUI, @[ moveOut ], 0.3, ^(UIViewAnimatingPosition) {
        self.bottomPromptLabel.string = @"GOOD LUCK & HAVE FUN!";
        UPViewMove *moveIn = UPViewMoveMake(self.bottomPromptLabel, self.bottomPromptLabelRole);
        start(bloop_in(BandAboutPlayingUI, @[ moveIn ], 0.3, ^(UIViewAnimatingPosition) {
            delay(BandAboutPlayingDelay, 1.75, ^{
                [self nextStep];
            });
        }));
    }));
}

- (void)animateToStepTwentyX
{
    if (!self.active) {
        return;
    }
    
    [UIView animateWithDuration:1.75 animations:^{
        self.gameView.alpha = 0;
        self.bottomPromptLabel.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.active) {
            delay(BandAboutPlayingDelay, 0.5, ^{
                if (self.active) {
                    [self prepare];
                    self.gameView.alpha = 0;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.gameView.alpha = 1;
                    }];
                }
            });
        }
    }];
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
        case 4:
            [self animateToStepFour];
            break;
        case 5:
            [self animateToStepFive];
            break;
        case 6:
            [self animateToStepSix];
            break;
        case 7:
            [self animateToStepSeven];
            break;
        case 8:
            [self animateToStepEight];
            break;
        case 9:
            [self animateToStepNine];
            break;
        case 10:
            [self animateToStepTen];
            break;
        case 11:
            [self animateToStepEleven];
            break;
        case 12:
            [self animateToStepTwelve];
            break;
        case 13:
            [self animateToStepThirteen];
            break;
        case 14:
            [self animateToStepFourteen];
            break;
        case 15:
            [self animateToStepFifteen];
            break;
        case 16:
            [self animateToStepSixteen];
            break;
        case 17:
            [self animateToStepSeventeen];
            break;
        case 18:
            [self animateToStepEighteen];
            break;
        case 19:
            [self animateToStepNineteen];
            break;
        case 20:
            [self animateToStepTwenty];
            break;
        case 21:
            [self animateToStepTwentyOne];
            break;
        case 22:
            [self animateToStepTwentyTwo];
            break;
        case 23:
            [self animateToStepTwentyX];
            break;
    }
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
     
    self.botSpot.borderColor = [UIColor themeColorWithCategory:UPColorCategoryCanonicalHighlighted];
    self.botSpot.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

@end
