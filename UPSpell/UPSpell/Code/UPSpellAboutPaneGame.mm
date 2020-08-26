//
//  UPSpellAboutPaneGame.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPBand.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLayoutRule.h>
#import <UpKit/UPLogoView.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPTapGestureRecognizer.h>
#import <UpKit/UPTimeSpanning.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPDialogTopMenu.h"
#import "UPSpellAboutPaneGame.h"
#import "UPSpellExtrasController.h"
#import "UPSpellLayout.h"
#import "UPSpellNavigationController.h"
#import "UPSpellSettings.h"
#import "UPViewMove+UPSpell.h"

using UP::BandSettingsUI;
using UP::BandSettingsAnimationDelay;
using UP::BandSettingsUpdateDelay;
using UP::SpellLayout;
using UP::SpellModel;

using UP::cpp_str;
using UP::ns_str;

using UP::TimeSpanning::bloop_in;
using UP::TimeSpanning::bloop_out;

using UP::TimeSpanning::delay;
using UP::TimeSpanning::start;

using Role = UP::SpellLayout::Role;

@interface UPSpellAboutPaneGame ()
@property (nonatomic) UPLogoView *logoView;
@property (nonatomic) UPLabel *wordMarkLabel;
@property (nonatomic) UITextView *aboutGameDescription;
@end

@implementation UPSpellAboutPaneGame

+ (UPSpellAboutPaneGame *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.logoView = [UPLogoView logoView];
    [self addSubview:self.logoView];
    self.logoView.frame = layout.frame_for(Role::AboutLogo);
    
    self.wordMarkLabel = [UPLabel label];
    self.wordMarkLabel.string = @"UP SPELL";
    self.wordMarkLabel.font = layout.word_mark_font();
    self.wordMarkLabel.textAlignment = NSTextAlignmentCenter;
    self.wordMarkLabel.frame = layout.frame_for(Role::AboutWordMark);
    self.wordMarkLabel.colorCategory = UPColorCategoryControlText;
    [self addSubview:self.wordMarkLabel];

    self.aboutGameDescription = [[UITextView alloc] initWithFrame:layout.frame_for(Role::AboutGameDescription)];
    self.aboutGameDescription.editable = NO;
    self.aboutGameDescription.backgroundColor = [UIColor clearColor];
    [self addSubview:self.aboutGameDescription];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.aboutGameDescription.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    [self updateThemeColors];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];

    self.aboutGameDescription.linkTextAttributes = @{ NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryControlText] };

    NSMutableAttributedString *attributedAtring = [[NSMutableAttributedString alloc] initWithString:@"by Ken Kocienda\n"];
    
    NSMutableAttributedString *URLString = [[NSMutableAttributedString alloc] initWithString:@"https://upgames.dev/upspell\n"];
    [URLString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"https://upgames.dev/upspell"] range:NSMakeRange(0, URLString.length)];
    [URLString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, URLString.length)];
    [URLString addAttribute:NSUnderlineColorAttributeName value:[UIColor themeColorWithCategory:UPColorCategoryControlText] range:NSMakeRange(0, URLString.length)];
    [attributedAtring appendAttributedString:URLString];
    
    NSString *versionString = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    NSMutableAttributedString *versionAttributedString = [[NSMutableAttributedString alloc] initWithString:versionString];
    [attributedAtring appendAttributedString:versionAttributedString];
    
    SpellLayout &layout = SpellLayout::instance();
    attributedAtring.font = layout.about_font();
    [attributedAtring setTextAlignment:NSTextAlignmentCenter];
    attributedAtring.textColor = [UIColor themeColorWithCategory:UPColorCategoryControlText];
    self.aboutGameDescription.attributedText = attributedAtring;
}

@end
