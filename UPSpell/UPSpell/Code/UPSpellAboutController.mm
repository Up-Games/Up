//
//  UPSpellAboutController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPButton.h>

#import "UPChoice.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutController.h"
#import "UPSpellLayout.h"

@interface UPSpellAboutController ()
@end

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;
using Place = UP::SpellLayout::Place;

static UPSpellAboutController *_Instance;

@implementation UPSpellAboutController

+ (UPSpellAboutController *)instance
{
    return _Instance;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    _Instance = self;
    
    SpellLayout &layout = SpellLayout::instance();
    
    self.backButton = [UPButton roundBackButtonRightArrow];
    self.backButton.canonicalSize = SpellLayout::CanonicalRoundBackButtonSize;
    self.backButton.frame = layout.frame_for(Role::ChoiceBackRight, Place::OffRightNear);
    self.backButton.chargeOutsets = UPOutsetsMake(0, 200 * layout.layout_scale(), 0, 0);
    [self.view addSubview:self.backButton];
    
    self.choice1 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice1.labelString = @"UP SPELL";
    self.choice1.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice1.frame = layout.frame_for(Role::ChoiceItem1Right, Place::OffRightNear);
    [self.choice1 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice1];
    
    self.choice2 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice2.labelString = @"RULES";
    self.choice2.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice2.frame = layout.frame_for(Role::ChoiceItem2Right, Place::OffRightNear);
    [self.choice2 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice2];
    
    self.choice3 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice3.labelString = @"LEXICON";
    self.choice3.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice3.frame = layout.frame_for(Role::ChoiceItem3Right, Place::OffRightNear);
    [self.choice3 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice3];
    
    self.choice4 = [UPChoice choiceWithSide:UPChoiceSideRight];
    self.choice4.labelString = @"LEGAL";
    self.choice4.canonicalSize = SpellLayout::CanonicalChoiceSize;
    self.choice4.frame = layout.frame_for(Role::ChoiceItem4Right, Place::OffRightNear);
    [self.choice4 setTarget:self action:@selector(choiceSelected:)];
    [self.view addSubview:self.choice4];
    
    return self;
}

@end
