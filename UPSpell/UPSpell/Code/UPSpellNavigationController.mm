//
//  UPSpellNavigationController.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPDialogMenu.h"
#import "UPSceneDelegate.h"
#import "UPSpellNavigationController.h"
#import "UPSpellAboutController.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameController.h"
#import "UPSpellLayout.h"
#import "UPTilePaths.h"
#import "UPViewMove+UPSpell.h"

@interface UPSpellNavigationController () <UINavigationControllerDelegate>
@property (nonatomic) UPDialogMenu *dialogMenu;
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
using UP::TimeSpanning::bloop_out;
using UP::TimeSpanning::delay;
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
    
    [UIColor setThemeStyle:UPColorStyleLight];
    [UIColor setThemeHue:222];

    UP::TimeSpanning::init();
    UP::Lexicon::set_language(UPLexiconLanguageEnglish);
    UP::TilePaths::create_instance();

    SpellLayout &layout = SpellLayout::create_instance();
    layout.set_screen_bounds([[UIScreen mainScreen] bounds]);
    layout.set_screen_scale([[UIScreen mainScreen] scale]);
    layout.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout.calculate();

    self.view.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];
    
    self.gameController = [[UPSpellGameController alloc] initWithNibName:nil bundle:nil];
    
    self.aboutController = [[UPSpellAboutController alloc] initWithNibName:nil bundle:nil];
    self.aboutController.modalPresentationStyle = UIModalPresentationCustom;
    [self.aboutController.backButton addTarget:self action:@selector(dismissPresentedController:) forEvents:UPControlEventTouchUpInside];

    self.extrasController = [[UPSpellExtrasController alloc] initWithNibName:nil bundle:nil];
    self.extrasController.modalPresentationStyle = UIModalPresentationCustom;
    [self.extrasController.backButton addTarget:self action:@selector(dismissPresentedController:) forEvents:UPControlEventTouchUpInside];

    self.dialogMenu = [UPDialogMenu instance];
    [self.view addSubview:self.dialogMenu];
    [self.dialogMenu.playButton addTarget:self action:@selector(dialogMenuPlayButtonTapped:) forEvents:UPControlEventTouchUpInside];
    [self.dialogMenu.extrasButton addTarget:self action:@selector(dialogMenuExtrasButtonTapped:) forEvents:UPControlEventTouchUpInside];
    [self.dialogMenu.aboutButton addTarget:self action:@selector(dialogMenuAboutButtonTapped:) forEvents:UPControlEventTouchUpInside];
    self.dialogMenu.hidden = YES;
    self.dialogMenu.frame = layout.screen_bounds();
    
    NSArray<UIViewController *> *viewControllers = @[
        self.gameController
    ];
    [self setViewControllers:viewControllers animated:NO];
}

#pragma mark - Control target/action and gestures

- (void)dialogMenuPlayButtonTapped:(id)sender
{
    [self.gameController setMode:UP::SpellGameMode::Ready];
}

- (void)dialogMenuExtrasButtonTapped:(id)sender
{
    [self presentExtrasController];
}

- (void)dialogMenuAboutButtonTapped:(id)sender
{
    [self presentAboutController];
}

- (void)presentExtrasController
{
    [self.gameController setMode:UP::SpellGameMode::Extras];
    [self presentViewController:self.extrasController animated:YES completion:nil];
}

- (void)presentAboutController
{
    [self.gameController setMode:UP::SpellGameMode::About];
    [self presentViewController:self.aboutController animated:YES completion:nil];
}

- (void)dismissPresentedController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.dialogMenu.extrasButton.selected = NO;
        self.dialogMenu.aboutButton.selected = NO;
        [self.gameController setMode:UP::SpellGameMode::Init];
    }];
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
    if (dismissed == self.extrasController) {
        return [[UPSpellExtrasDismissAnimationController alloc] init];
    }
    else if (dismissed == self.aboutController) {
        return [[UPSpellAboutDismissAnimationController alloc] init];
    }
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
    
    delay(BandModeDelay, 0.7, ^{
        NSArray <UPViewMove *> *itemMoves = @[
            UPViewMoveMake(extrasController.backButton, Role::ChoiceBackLeft),
            UPViewMoveMake(extrasController.choiceItem1, Role::ChoiceItem1Left),
            UPViewMoveMake(extrasController.choiceItem2, Role::ChoiceItem2Left),
            UPViewMoveMake(extrasController.choiceItem3, Role::ChoiceItem3Left),
            UPViewMoveMake(extrasController.choiceItem4, Role::ChoiceItem4Left),
        ];
        start(bloop_in(BandModeUI, itemMoves, [self transitionDuration:transitionContext], ^(UIViewAnimatingPosition) {
            [transitionContext completeTransition:YES];
        }));
    });
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.65;
}

@end

// =========================================================================================================================================

@interface UPSpellExtrasDismissAnimationController ()
@end

@implementation UPSpellExtrasDismissAnimationController

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

    NSArray <UPViewMove *> *moves = @[
        UPViewMoveMake(extrasController.backButton, Role::ChoiceBackLeft, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choiceItem1, Role::ChoiceItem1Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choiceItem2, Role::ChoiceItem2Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choiceItem3, Role::ChoiceItem3Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choiceItem4, Role::ChoiceItem4Left, Spot::OffLeftNear),
    ];
    start(bloop_out(BandModeUI, moves, [self transitionDuration:transitionContext], ^(UIViewAnimatingPosition) {
        [transitionContext completeTransition:YES];
    }));
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
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
    
    delay(BandModeDelay, 0.7, ^{
        NSArray <UPViewMove *> *itemMoves = @[
            UPViewMoveMake(aboutController.backButton, Role::ChoiceBackRight),
            UPViewMoveMake(aboutController.choiceItem1, Role::ChoiceItem1Right),
            UPViewMoveMake(aboutController.choiceItem2, Role::ChoiceItem2Right),
            UPViewMoveMake(aboutController.choiceItem3, Role::ChoiceItem3Right),
            UPViewMoveMake(aboutController.choiceItem4, Role::ChoiceItem4Right),
        ];
        start(bloop_in(BandModeUI, itemMoves, [self transitionDuration:transitionContext], ^(UIViewAnimatingPosition) {
            [transitionContext completeTransition:YES];
        }));
    });
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.65;
}

@end

// =========================================================================================================================================

@interface UPSpellAboutDismissAnimationController ()
@end

@implementation UPSpellAboutDismissAnimationController

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
    
    NSArray <UPViewMove *> *moves = @[
        UPViewMoveMake(aboutController.backButton, Role::ChoiceBackLeft, Spot::OffRightNear),
        UPViewMoveMake(aboutController.choiceItem1, Role::ChoiceItem1Left, Spot::OffRightNear),
        UPViewMoveMake(aboutController.choiceItem2, Role::ChoiceItem2Left, Spot::OffRightNear),
        UPViewMoveMake(aboutController.choiceItem3, Role::ChoiceItem3Left, Spot::OffRightNear),
        UPViewMoveMake(aboutController.choiceItem4, Role::ChoiceItem4Left, Spot::OffRightNear),
    ];
    start(bloop_out(BandModeUI, moves, [self transitionDuration:transitionContext], ^(UIViewAnimatingPosition) {
        [transitionContext completeTransition:YES];
    }));
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

@end

// =========================================================================================================================================

