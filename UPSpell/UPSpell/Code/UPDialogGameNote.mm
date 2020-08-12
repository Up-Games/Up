//
//  UPDialogGameNote.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UPControl+UPSpell.h"
#import "UPDialogGameNote.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

@interface UPDialogGameNote ()
@property (nonatomic, readwrite) UPLabel *noteLabel;
@property (nonatomic, readwrite) UPButton *shareButton;
@end

@implementation UPDialogGameNote

+ (UPDialogGameNote *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogGameNote *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogGameNote alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];
    
    self.noteLabel = [UPLabel label];
    self.noteLabel.font = layout.game_note_font();
    self.noteLabel.colorCategory = UPColorCategoryInformation;
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel.frame = layout.frame_for(SpellLayout::Role::DialogGameNote);
    [self addSubview:self.noteLabel];
    
    self.shareButton = [UPButton roundShareButton];
    self.shareButton.frame = layout.frame_for(SpellLayout::Role::GameShareButton);
    self.shareButton.band = UP::BandModeUI;
    [self.shareButton setFillColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self.shareButton setStrokeColorAnimationDuration:0.1 fromState:UPControlStateHighlighted toState:UPControlStateNormal];
    [self addSubview:self.shareButton];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
