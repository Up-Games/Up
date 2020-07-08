//
//  UPSpellAboutController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPButton.h>
#import <UpKit/UPTouchGestureRecognizer.h>

#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutController.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPTextPaths.h"

@interface UPSpellAboutController ()
@property (nonatomic, readwrite) UPButton *backButton;
@property (nonatomic, readwrite) UPChoice *choice1;
@property (nonatomic, readwrite) UPChoice *choice2;
@property (nonatomic, readwrite) UPChoice *choice3;
@property (nonatomic, readwrite) UPChoice *choice4;
@end

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Place;

@implementation UPSpellAboutController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    SpellLayout &layout = SpellLayout::instance();
    
    self.backButton = [UPButton roundBackButtonRightArrow];
    self.backButton.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    self.backButton.frame = layout.frame_for(Role::ChoiceBackRight, Spot::OffRightNear);
    self.backButton.chargeOutsets = UPOutsetsMake(0, 200 * layout.layout_scale(), 0, 0);
    [self.view addSubview:self.backButton];
    
    self.choice1 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice1.labelString = @"UP SPELL";
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Right, Spot::OffRightNear);
    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice2.labelString = @"RULES";
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Right, Spot::OffRightNear);
    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice3.labelString = @"LEGAL";
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Right, Spot::OffRightNear);
    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice3];
    
    self.choice4 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice4.labelString = @"THANKS";
    self.choice4.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice4.frame = layout.frame_for(Role::ChoiceItem4Right, Spot::OffRightNear);
    [self.choice4 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice4];
    
    return self;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate
{
    return [UPSpellNavigationController instance];
}

#pragma mark - Target / Action

- (void)choiceSelected:(UPChoice *)sender
{
    if (self.choice1 != sender) {
        self.choice1.selected = NO;
    }
    if (self.choice2 != sender) {
        self.choice2.selected = NO;
    }
    if (self.choice3 != sender) {
        self.choice3.selected = NO;
    }
    if (self.choice4 != sender) {
        self.choice4.selected = NO;
    }
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.view.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
