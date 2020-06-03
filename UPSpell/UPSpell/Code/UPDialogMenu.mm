//
//  UPDialogMenu.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>

#import "UPControl+UPSpell.h"
#import "UPDialogMenu.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

@interface UPDialogMenu ()
@property (nonatomic, readwrite) UPControl *extrasButton;
@property (nonatomic, readwrite) UPControl *playButton;
@property (nonatomic, readwrite) UPControl *aboutButton;
@end

@implementation UPDialogMenu

+ (UPDialogMenu *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogMenu *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogMenu alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.extrasButton = [UPControl textButtonExtras];
    self.extrasButton.frame = layout.menu_button_left_layout_frame();
    [self addSubview:self.extrasButton];

    self.playButton = [UPControl textButtonPlay];
    self.playButton.frame = layout.menu_button_center_layout_frame();
    [self addSubview:self.playButton];

    self.aboutButton = [UPControl textButtonAbout];
    self.aboutButton.frame = layout.menu_button_right_layout_frame();
    [self addSubview:self.aboutButton];

    return self;
}

@end
