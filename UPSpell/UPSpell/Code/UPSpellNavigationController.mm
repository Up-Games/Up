//
//  UPSpellNavigationController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPSceneDelegate.h"
#import "UPSpellNavigationController.h"
#import "UPSpellAboutController.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameController.h"
#import "UPSpellLayout.h"
#import "UPTilePaths.h"
#import "UPViewMove+UPSpell.h"

@interface UPSpellNavigationController () <UINavigationControllerDelegate>
@property (nonatomic) UPSpellGameController *gameController;
@property (nonatomic) UPSpellExtrasController *extrasController;
@property (nonatomic) UPSpellAboutController *aboutController;
@end

static UPSpellNavigationController *_Instance;

using UP::SpellLayout;
using Location = UP::SpellLayout::Location;
using Role = UP::SpellLayout::Role;
using Spot = UP::SpellLayout::Spot;

using UP::BandModeDelay;
using UP::BandModeUI;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::slide;
using UP::TimeSpanning::start;

@implementation UPSpellNavigationController

+ (UPSpellNavigationController *)instance
{
    return _Instance;
}

- (void)viewDidLoad
{
    LOG_CHANNEL_ON(General);
    //LOG_CHANNEL_ON(Gestures);
    //LOG_CHANNEL_ON(Layout);
    //LOG_CHANNEL_ON(Leaks);
    //LOG_CHANNEL_ON(Mode);
    
    _Instance = self;
    
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    self.delegate = self;

    UP::TimeSpanning::init();
    UP::Lexicon::set_language(UPLexiconLanguageEnglish);
    
    [UIColor setThemeStyle:UPColorStyleLight];
    [UIColor setThemeHue:222];
    SpellLayout &layout = SpellLayout::create_instance();
    UP::TilePaths::create_instance();
    
    layout.set_screen_bounds([[UIScreen mainScreen] bounds]);
    layout.set_screen_scale([[UIScreen mainScreen] scale]);
    layout.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout.calculate();

    self.view.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];
    
    self.gameController = [[UPSpellGameController alloc] initWithNibName:nil bundle:nil];
    
    self.aboutController = [[UPSpellAboutController alloc] initWithNibName:nil bundle:nil];
    self.aboutController.modalPresentationStyle = UIModalPresentationCustom;

    self.extrasController = [[UPSpellExtrasController alloc] initWithNibName:nil bundle:nil];
    self.extrasController.modalPresentationStyle = UIModalPresentationCustom;
    
    NSArray<UIViewController *> *viewControllers = @[
        self.gameController
        //self.extrasController
    ];
    [self setViewControllers:viewControllers animated:NO];
}

- (void)presentExtrasController
{
    [self presentViewController:self.extrasController animated:YES completion:^{
    }];
}

- (void)dismissExtrasController
{
}

- (void)presentAboutController
{
    [self presentViewController:self.aboutController animated:YES completion:^{
    }];
}

- (void)dismissAboutController
{
}

// =========================================================================================================================================

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    if (presented == self.extrasController) {
        return [[UPSpellExtrasPresentAnimationController alloc] init];
    }
    else if (presented == self.aboutController) {
        return [[UPSpellAboutPresentAnimationController alloc] init];
    }
    
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return nil;
}

@end

// =========================================================================================================================================

@interface UPSpellExtrasPresentAnimationController ()
@end

@implementation UPSpellExtrasPresentAnimationController

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UPSpellNavigationController *spellNavigationController = [UPSpellNavigationController instance];
    UPSpellExtrasController *extrasController = spellNavigationController.extrasController;
    
    SpellLayout &layout = SpellLayout::instance();
    
    [transitionContext.containerView addSubview:extrasController.view];
    
    transitionContext.containerView.frame = layout.frame_for(Role::Screen);
    
    extrasController.backButton.frame = layout.frame_for(Role::ChoiceBackLeft, Spot::OffLeftNear);
    
    CFTimeInterval duration = [self transitionDuration:transitionContext];
    
    UPViewMove *backButtonMove = UPViewMoveMake(extrasController.backButton, Role::ChoiceBackLeft);
    
    start(bloop_in(BandModeUI, @[backButtonMove], duration, ^(UIViewAnimatingPosition) {
        [transitionContext completeTransition:YES];
    }));
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.35;
}

@end

// =========================================================================================================================================

@interface UPSpellAboutPresentAnimationController ()
@end

@implementation UPSpellAboutPresentAnimationController

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UPSpellNavigationController *spellNavigationController = [UPSpellNavigationController instance];
    UPSpellAboutController *aboutController = spellNavigationController.aboutController;
    
    SpellLayout &layout = SpellLayout::instance();
    
    [transitionContext.containerView addSubview:aboutController.view];
    
    transitionContext.containerView.frame = layout.frame_for(Role::Screen);
    
    aboutController.backButton.frame = layout.frame_for(Role::ChoiceBackRight, Spot::OffRightNear);
    
    CFTimeInterval duration = [self transitionDuration:transitionContext];
    
    UPViewMove *backButtonMove = UPViewMoveMake(aboutController.backButton, Role::ChoiceBackRight);
    
    start(bloop_in(BandModeUI, @[backButtonMove], duration, ^(UIViewAnimatingPosition) {
        [transitionContext completeTransition:YES];
    }));
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.35;
}

@end

// =========================================================================================================================================

