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
#import "UPChoice.h"
#import "UPDialogPlay.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextSettingsButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

using Place = SpellLayout::Place;
using Role = SpellLayout::Role;

@interface UPDialogPlay ()
@property (nonatomic, readwrite) UPButton *backButton;
@property (nonatomic, readwrite) UPButton *goButton;
@property (nonatomic, readwrite) UPChoice *choice1;
@property (nonatomic, readwrite) UPChoice *choice2;
@property (nonatomic, readwrite) UPChoice *choice3;
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

    self.backButton = [UPButton roundBackButtonEx];
    self.backButton.frame = layout.frame_for(Role::ChoiceBackCenter, Place::OffTopNear);
    self.backButton.chargeOutsets = UPOutsetsMake(0, 0, 0, 200 * layout.layout_scale());
    [self addSubview:self.backButton];

    self.goButton = [UPTextButton textButton];
    self.goButton.labelString = @"GO";
    [self.goButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.goButton.frame = layout.frame_for(Role::ChoiceGoButtonCenter, Place::OffBottomFar);
    [self addSubview:self.goButton];

    self.choice1 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice1.labelString = @"REPEAT";
    self.choice1.tag = 0;
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Center, Place::OffBottomNear);
    //    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice2.labelString = @"REPEAT";
    self.choice2.tag = 1;
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Center, Place::OffBottomNear);
    //    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceWithSide:UPChoiceSideLeft];
    self.choice3.labelString = @"NEW GAME";
    self.choice3.tag = 2;
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Center, Place::OffBottomNear);
    //    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self addSubview:self.choice3];
    
    [self updateThemeColors];

    return self;
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
