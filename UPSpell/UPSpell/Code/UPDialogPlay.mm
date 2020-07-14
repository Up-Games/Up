//
//  UPDialogPlay.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UPControl+UPSpell.h"
#import "UPDialogPlay.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextSettingsButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

using Place = SpellLayout::Place;
using Role = SpellLayout::Role;

@interface UPDialogPlay ()
@property (nonatomic, readwrite) UIScrollView *placardCarouselScrollView;
@property (nonatomic, readwrite) UIPageControl *placardCarouselPageControl;
@property (nonatomic, readwrite) UPButton *okButton;
@property (nonatomic, readwrite) UPButton *cancelButton;
@property (nonatomic, readwrite) UPPlacard *highScorePlacard;
@property (nonatomic, readwrite) UPPlacard *lastGamePlacard;
@property (nonatomic, readwrite) UPPlacard *randomizedGamePlacard;
@end

@implementation UPDialogPlay

+ (UPDialogPlay *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogPlay *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogPlay alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.placardCarouselScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.placardCarouselScrollView.frame = layout.frame_for(Role::PlayDialogCarouselScrollView, Place::OffBottomFar);
    [self addSubview:self.placardCarouselScrollView];
//    self.placardCarouselScrollView.backgroundColor = [UIColor testColor1];

    self.placardCarouselPageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.placardCarouselPageControl.frame = layout.frame_for(Role::PlayDialogCarouselPagingDots, Place::OffBottomFar);
    self.placardCarouselPageControl.numberOfPages = 3;
    self.placardCarouselPageControl.currentPage = 0;
    [self addSubview:self.placardCarouselPageControl];
//    self.placardCarouselPageControl.backgroundColor = [UIColor testColor2];

    self.okButton = [UPTextButton textButton];
    self.okButton.labelString = @"OK";
    [self.okButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.okButton.frame = layout.frame_for(Role::PlayDialogButtonOK, Place::OffBottomFar);
    [self addSubview:self.okButton];
    
    self.cancelButton = [UPTextButton textButton];
    self.cancelButton.labelString = @"CANCEL";
    [self.cancelButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.cancelButton.frame = layout.frame_for(Role::PlayDialogButtonCancel, Place::OffBottomFar);
    [self addSubview:self.cancelButton];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    
    UIColor *pageControlColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    self.placardCarouselPageControl.currentPageIndicatorTintColor = pageControlColor;
    self.placardCarouselPageControl.pageIndicatorTintColor = [pageControlColor colorWithAlphaComponent:[UIColor themeDisabledAlpha]];
}

@end
