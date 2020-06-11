//
//  UPDialogPause.mm
//  Copyright © 2020 Up Games. All rights reserved.
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

@interface UPDialogGameOver ()
@property (nonatomic, readwrite) UPBezierPathView *messagePathView;
@property (nonatomic, readwrite) UPLabel *noteLabel;
@end

@implementation UPDialogGameOver

+ (UPDialogGameOver *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogGameOver *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogGameOver alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.messagePathView = [UPBezierPathView bezierPathView];
    self.messagePathView.canonicalSize = SpellLayout::CanonicalDialogTitleSize;
    self.messagePathView.path = UP::TextPathDialogGameOver();
    self.messagePathView.frame = layout.frame_for(SpellLayout::Role::DialogMessageCenter);
    [self addSubview:self.messagePathView];

    self.noteLabel = [UPLabel label];
    self.noteLabel.string = @"‘GRUBMITS’ WAS YOUR HIGHEST SCORING WORD (32)";
    self.noteLabel.font = layout.game_note_font();
    self.noteLabel.textColorCategory = UPColorCategoryInformation;
    self.noteLabel.textAlignment = NSTextAlignmentCenter;
    self.noteLabel.frame = layout.frame_for(SpellLayout::Role::DialogNote);
    [self addSubview:self.noteLabel];

    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    self.messagePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryDialogTitle];
}

@end
