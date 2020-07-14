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
#import "UIFont+UPSpell.h"
#import "UPDialogPlay.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextSettingsButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

using Place = SpellLayout::Place;
using Role = SpellLayout::Role;

@interface UPDialogPlay () <UIScrollViewDelegate>
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
    self.placardCarouselScrollView.pagingEnabled = YES;
    self.placardCarouselScrollView.delegate = self;
//    self.placardCarouselScrollView.backgroundColor = [UIColor testColor1];

    CGSize placardSize = self.placardCarouselScrollView.bounds.size;
    CGRect placardContainerFrame = CGRectMake(0, 0, up_size_width(placardSize), up_size_height(placardSize));
    UIView *placardContainerView = [[UPContainerView alloc] initWithFrame:placardContainerFrame];
    
    self.highScorePlacard = [UPPlacard placard];
    self.highScorePlacard.frame = CGRectMake(up_size_width(placardSize) * 0, 0, up_size_width(placardSize), up_size_height(placardSize));
    self.highScorePlacard.attributedString = [self placardRetryStringWithTitle:@"HIGH-SCORE GAME" score:232];
    [placardContainerView addSubview:self.highScorePlacard];

    self.lastGamePlacard = [UPPlacard placard];
    self.lastGamePlacard.frame = CGRectMake(up_size_width(placardSize) * 1, 0, up_size_width(placardSize), up_size_height(placardSize));
    self.lastGamePlacard.attributedString = [self placardRetryStringWithTitle:@"LAST GAME" score:165];
    [placardContainerView addSubview:self.lastGamePlacard];
    
    self.randomizedGamePlacard = [UPPlacard placard];
    self.randomizedGamePlacard.frame = CGRectMake(up_size_width(placardSize) * 2, 0, up_size_width(placardSize), up_size_height(placardSize));
    self.randomizedGamePlacard.attributedString = [self placardNewGameString];
    [placardContainerView addSubview:self.randomizedGamePlacard];
    
    [self.placardCarouselScrollView addSubview:placardContainerView];
    self.placardCarouselScrollView.contentSize = CGSizeMake(up_size_width(placardSize) * 3, up_size_height(placardSize));
    self.placardCarouselScrollView.showsVerticalScrollIndicator = NO;
    self.placardCarouselScrollView.showsHorizontalScrollIndicator = NO;

    self.placardCarouselPageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.placardCarouselPageControl.frame = layout.frame_for(Role::PlayDialogCarouselPagingDots, Place::OffBottomFar);
    self.placardCarouselPageControl.numberOfPages = 3;
    self.placardCarouselPageControl.currentPage = 0;
    [self addSubview:self.placardCarouselPageControl];

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

- (NSAttributedString *)placardRetryStringWithTitle:(NSString *)modifier score:(int)score
{
    SpellLayout &layout = SpellLayout::instance();
    NSMutableAttributedString *newline = [[NSMutableAttributedString alloc] initWithString:@"\n"];

    NSMutableAttributedString *placardString = [[NSMutableAttributedString alloc] init];

    NSMutableAttributedString *retryLine = [[NSMutableAttributedString alloc] initWithString:@"RETRY"];
    [retryLine setFont:[UIFont checkboxControlFontOfSize:84 * layout.layout_scale()]];
    [retryLine appendAttributedString:newline];
    [retryLine setTextAlignment:NSTextAlignmentCenter paragraphSpacing:-14 * layout.layout_scale()];
    [placardString appendAttributedString:retryLine];

    NSMutableAttributedString *modifierLine = [[NSMutableAttributedString alloc] initWithString:modifier];
    [modifierLine setFont:[UIFont checkboxControlFontOfSize:42 * layout.layout_scale()]];
    [modifierLine appendAttributedString:newline];
    [modifierLine setTextAlignment:NSTextAlignmentCenter paragraphSpacing:-12 * layout.layout_scale()];
    [placardString appendAttributedString:modifierLine];

    NSString *scoreString = score >= 0 ? [NSString stringWithFormat:@"%d", score] : @"–";
    NSMutableAttributedString *scoreLine = [[NSMutableAttributedString alloc] initWithString:scoreString];
    [scoreLine setFont:[UIFont checkboxControlFontOfSize:64 * layout.layout_scale()]];
    [scoreLine setTextAlignment:NSTextAlignmentCenter paragraphSpacing:0];
    [placardString appendAttributedString:scoreLine];

    return placardString;
}

- (NSAttributedString *)placardNewGameString
{
    SpellLayout &layout = SpellLayout::instance();

    NSMutableAttributedString *newline = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *placardString = [[NSMutableAttributedString alloc] initWithString:@"NEW\nGAME"];
    [placardString setFont:[UIFont checkboxControlFontOfSize:84 * layout.layout_scale()]];
    [placardString appendAttributedString:newline];
    [placardString setTextAlignment:NSTextAlignmentCenter paragraphSpacing:-20 * layout.layout_scale()];
    
    return placardString;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    if (pageIndex != self.placardCarouselPageControl.currentPage) {
        self.placardCarouselPageControl.currentPage = pageIndex;
        [self.placardCarouselPageControl updateCurrentPageDisplay];
    }
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    
    UIColor *pageControlColor = [UIColor themeColorWithCategory:UPColorCategoryInformation];
    self.placardCarouselPageControl.currentPageIndicatorTintColor = pageControlColor;
    self.placardCarouselPageControl.pageIndicatorTintColor = [pageControlColor colorWithAlphaComponent:[UIColor themeControlContentInactiveAlpha]];
}

@end
