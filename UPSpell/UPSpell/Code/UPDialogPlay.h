//
//  UPDialogPlay.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UpKit.h>

@class UPButton;
@class UPPlacard;

@interface UPDialogPlay : UPContainerView

@property (nonatomic, readonly) UIScrollView *placardCarouselScrollView;
@property (nonatomic, readonly) UIPageControl *placardCarouselPageControl;
@property (nonatomic, readonly) UPButton *okButton;
@property (nonatomic, readonly) UPButton *cancelButton;
@property (nonatomic, readonly) UPPlacard *highScorePlacard;
@property (nonatomic, readonly) UPPlacard *lastGamePlacard;
@property (nonatomic, readonly) UPPlacard *randomizedGamePlacard;

+ (UPDialogPlay *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
