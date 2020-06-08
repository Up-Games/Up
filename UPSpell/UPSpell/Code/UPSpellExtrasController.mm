//
//  UPSpellExtrasController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>

#import "UPControl+UPSpell.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPTextPaths.h"

@interface UPSpellExtrasController ()
@property (nonatomic, readwrite) UPControl *choiceTitle;
@property (nonatomic, readwrite) UPControl *choiceItemColors;
@property (nonatomic, readwrite) UPControl *choiceItem2;
@property (nonatomic, readwrite) UPControl *choiceItem3;
@property (nonatomic, readwrite) UPControl *choiceItem4;
@end

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

@implementation UPSpellExtrasController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SpellLayout &layout = SpellLayout::instance();

    self.choiceTitle = [UPControl choiceTitleRowLeftExtras];
    self.choiceTitle.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceTitle.frame = layout.frame_for(Role::ChoiceTitleLeft);
    [self.view addSubview:self.choiceTitle];
    
    self.choiceItemColors = [UPControl choiceItemRowLeftColors];
    self.choiceItemColors.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItemColors.frame = layout.frame_for(Role::ChoiceItem1Left);
    [self.choiceItemColors addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchUpInside];
    [self.view addSubview:self.choiceItemColors];
    
    self.choiceItem2 = [UPControl choiceItemRowLeftSounds];
    self.choiceItem2.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItem2.frame = layout.frame_for(Role::ChoiceItem2Left);
    [self.choiceItem2 addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchUpInside];
    [self.view addSubview:self.choiceItem2];
    
    self.choiceItem3 = [UPControl choiceItemRowLeftStats];
    self.choiceItem3.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItem3.frame = layout.frame_for(Role::ChoiceItem3Left);
    [self.choiceItem3 addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchUpInside];
    [self.view addSubview:self.choiceItem3];
    
    self.choiceItem4 = [UPControl choiceItemRowLeftGameCodes];
    self.choiceItem4.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItem4.frame = layout.frame_for(Role::ChoiceItem4Left);
    [self.choiceItem4 addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchUpInside];
    [self.view addSubview:self.choiceItem4];
    
    [self updateThemeColors];
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

#pragma mark - Target / Action

- (void)choiceItemTapped:(id)sender
{
}


#pragma mark - Theme colors

- (void)updateThemeColors
{
//    self.titlePathView.fillColor = [UIColor themeColorWithCategory:UPColorCategoryDialogTitle];
}

@end
