//
//  UPSpellNavigationController.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "UPAccessoryPane.h"
#import "UPChoice.h"
#import "UPDialogTopMenu.h"
#import "UPHowToViewController.h"
#import "UPMode.h"
#import "UPSceneDelegate.h"
#import "UPSpellNavigationController.h"
#import "UPSpellExtrasController.h"
#import "UPSpellGameController.h"
#import "UPSpellLayout.h"
#import "UPSpellSettings.h"
#import "UPTextButton.h"
#import "UPTilePaths.h"
#import "UPTilePaths.h"
#import "UPViewMove+UPSpell.h"

@interface UPSpellNavigationController () <UINavigationControllerDelegate>
@property (nonatomic) UPDialogTopMenu *dialogTopMenu;
@property (nonatomic) UPSpellGameController *gameController;
@property (nonatomic) UPSpellExtrasController *extrasController;
@property (nonatomic) UPHowToViewController *howToController;
@end

static UPSpellNavigationController *_Instance;

using UP::SpellLayout;
using Location = UP::SpellLayout::Location;
using Mode = UP::Mode;
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
    LOG_CHANNEL_ON(Lexicon);
    //LOG_CHANNEL_ON(Mode);
    //LOG_CHANNEL_ON(SaveRestore);
    //LOG_CHANNEL_ON(Settings);
    //LOG_CHANNEL_ON(Sound);
    //LOG_CHANNEL_ON(State);

    _Instance = self;
    
    [super viewDidLoad];

    self.navigationBarHidden = YES;
    self.delegate = self;

    UPSpellSettings *settings = [UPSpellSettings instance];
    [UIColor setTheme:settings.theme];

    UP::TimeSpanning::init();
    UP::Lexicon::set_language(UPLexiconLanguageEnglish);
    UP::TilePaths::create_instance();

    SpellLayout &layout = SpellLayout::create_instance();
    layout.set_screen_bounds([[UIScreen mainScreen] bounds]);
    layout.set_screen_scale([[UIScreen mainScreen] scale]);
    layout.set_canvas_frame([[UPSceneDelegate instance] canvasFrame]);
    layout.calculate();

    self.view.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];

    self.dialogTopMenu = [UPDialogTopMenu instance];
    
    self.gameController = [[UPSpellGameController alloc] initWithNibName:nil bundle:nil];
    
    self.extrasController = [[UPSpellExtrasController alloc] initWithNibName:nil bundle:nil];
    self.extrasController.modalPresentationStyle = UIModalPresentationCustom;

    self.howToController = [[UPHowToViewController alloc] initWithNibName:nil bundle:nil];

    NSArray<UIViewController *> *viewControllers = @[
        self.gameController
    ];
    [self setViewControllers:viewControllers animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.extrasController delayedInit];
        [self.extrasController.backButton setTarget:self action:@selector(dismissPresentedController)];
        self.dialogTopMenu.extrasButton.userInteractionEnabled = YES;
        self.dialogTopMenu.duelButton.userInteractionEnabled = YES;
    });
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.gameController updateThemeColors];
    [self.extrasController updateThemeColors];
    [self.dialogTopMenu updateThemeColors];
    self.view.backgroundColor = [UIColor themeColorWithCategory:UPColorCategoryInfinity];
}

#pragma mark - Control target/action and gestures

- (void)dialogMenuPlayButtonTapped
{
    [self.gameController setMode:Mode::Ready];
}

- (void)dialogMenuExtrasButtonTapped
{
    [self presentExtrasController];
}

- (void)presentExtrasController
{
    [self.gameController setMode:Mode::Extras];
    [self presentViewController:self.extrasController animated:YES completion:nil];
}

- (void)dismissPresentedController
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.dialogTopMenu.extrasButton.selected = NO;
        self.dialogTopMenu.duelButton.selected = NO;
        self.gameController.retry = nil;
        [self.gameController setMode:Mode::Init];
    }];
}

- (void)dismissPresentedControllerImmediateIfNecessary
{
    Mode mode = self.gameController.mode;
    if (mode != Mode::Extras) {
        return;
    }
    
    if (self.extrasController.presentedViewController) {
        [self.extrasController dismissViewControllerAnimated:NO completion:nil];
    }
    [self dismissViewControllerAnimated:NO completion:nil];

    NSArray<UPViewMove *> *moves = @[
        UPViewMoveMake(self.extrasController.backButton, Role::ChoiceBackLeft, Spot::OffLeftNear),
        UPViewMoveMake(self.extrasController.choice1, Role::ChoiceItem1Left, Spot::OffLeftNear),
        UPViewMoveMake(self.extrasController.choice2, Role::ChoiceItem2Left, Spot::OffLeftNear),
        UPViewMoveMake(self.extrasController.choice3, Role::ChoiceItem3Left, Spot::OffLeftNear),
        UPViewMoveMake(self.extrasController.choice4, Role::ChoiceItem4Left, Spot::OffLeftNear),
        UPViewMoveMake(self.extrasController.choice5, Role::ChoiceItem5Left, Spot::OffLeftNear),
        UPViewMoveMake(self.extrasController.selectedPane, Role::Screen, Spot::OffBottomFar),
    ];
    for (UPViewMove *move in moves) {
        move.view.center = move.destination;
    }
    
    self.gameController.retry = nil;
    [self.gameController setMode:Mode::Init transitionScenario:UPModeTransitionScenarioWillEnterForeground];
    self.dialogTopMenu.extrasButton.selected = NO;
    self.dialogTopMenu.duelButton.selected = NO;
}

// =========================================================================================================================================

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    if (presented == self.extrasController) {
        return [[UPSpellExtrasPresentAnimationController alloc] init];
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (dismissed == self.extrasController) {
        return [[UPSpellExtrasDismissAnimationController alloc] init];
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
    
    delay(BandModeDelay, 0.55, ^{
        NSArray <UPViewMove *> *itemMoves = @[
            UPViewMoveMake(extrasController.backButton, Role::ChoiceBackLeft),
            UPViewMoveMake(extrasController.choice1, Role::ChoiceItem1Left),
            UPViewMoveMake(extrasController.choice2, Role::ChoiceItem2Left),
            UPViewMoveMake(extrasController.choice3, Role::ChoiceItem3Left),
            UPViewMoveMake(extrasController.choice4, Role::ChoiceItem4Left),
            UPViewMoveMake(extrasController.choice5, Role::ChoiceItem5Left),
        ];
        start(bloop_in(BandModeUI, itemMoves, [self transitionDuration:transitionContext], ^(UIViewAnimatingPosition) {
            [transitionContext completeTransition:YES];
        }));
        [extrasController setSelectedPaneFromSettingsWithDuration:[self transitionDuration:transitionContext]];
    });
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
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
    [extrasController.selectedPane finish];

    SpellLayout &layout = SpellLayout::instance();

    [transitionContext.containerView addSubview:extrasController.view];
    transitionContext.containerView.frame = layout.frame_for(Role::Screen);

    NSArray <UPViewMove *> *moves = @[
        UPViewMoveMake(extrasController.backButton, Role::ChoiceBackLeft, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choice1, Role::ChoiceItem1Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choice2, Role::ChoiceItem2Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choice3, Role::ChoiceItem3Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choice4, Role::ChoiceItem4Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.choice5, Role::ChoiceItem5Left, Spot::OffLeftNear),
        UPViewMoveMake(extrasController.selectedPane, Role::Screen, Spot::OffBottomFar),
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
