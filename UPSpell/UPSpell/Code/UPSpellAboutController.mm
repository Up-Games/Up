//
//  UPSpellAboutController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>

#import "UPControl+UPSpell.h"
#import "UPSpellAboutController.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPTextPaths.h"

@interface UPSpellAboutController ()
@property (nonatomic, readwrite) UPControl *backButton;
@property (nonatomic, readwrite) UPControl *choiceItem1;
@property (nonatomic, readwrite) UPControl *choiceItem2;
@property (nonatomic, readwrite) UPControl *choiceItem3;
@property (nonatomic, readwrite) UPControl *choiceItem4;
@end

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

@implementation UPSpellAboutController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    SpellLayout &layout = SpellLayout::instance();
    
    self.backButton = [UPControl roundBackButtonRightArrow];
    self.backButton.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    self.backButton.frame = layout.frame_for(Role::ChoiceBackRight);
    [self.view addSubview:self.backButton];
    
    self.choiceItem1 = [UPControl choiceItemRowRightUpSpell];
    self.choiceItem1.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItem1.frame = layout.frame_for(Role::ChoiceItem1Right);
    [self.choiceItem1 addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchDown];
    [self.view addSubview:self.choiceItem1];
    
    self.choiceItem2 = [UPControl choiceItemRowRightRules];
    self.choiceItem2.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItem2.frame = layout.frame_for(Role::ChoiceItem2Right);
    [self.choiceItem2 addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchDown];
    [self.view addSubview:self.choiceItem2];
    
    self.choiceItem3 = [UPControl choiceItemRowRightLegal];
    self.choiceItem3.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItem3.frame = layout.frame_for(Role::ChoiceItem3Right);
    [self.choiceItem3 addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchDown];
    [self.view addSubview:self.choiceItem3];
    
    self.choiceItem4 = [UPControl choiceItemRowRightThanks];
    self.choiceItem4.canonicalSize = SpellLayout::CanonicalChoiceRowSize;
    self.choiceItem4.frame = layout.frame_for(Role::ChoiceItem4Right);
    [self.choiceItem4 addTarget:self action:@selector(choiceItemTapped:) forEvents:UPControlEventTouchDown];
    [self.view addSubview:self.choiceItem4];
    
    return self;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

#pragma mark - Target / Action

- (void)choiceItemTapped:(id)sender
{
    if (self.choiceItem1 != sender) {
        self.choiceItem1.selected = NO;
    }
    if (self.choiceItem2 != sender) {
        self.choiceItem2.selected = NO;
    }
    if (self.choiceItem3 != sender) {
        self.choiceItem3.selected = NO;
    }
    if (self.choiceItem4 != sender) {
        self.choiceItem4.selected = NO;
    }
}


@end
