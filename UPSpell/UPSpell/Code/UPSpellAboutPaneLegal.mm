//
//  UPSpellAboutPaneLegal.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutPaneLegal.h"
#import "UPSpellLayout.h"
#import "UPSpellSettings.h"

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;

@interface UPSpellAboutPaneLegal ()
@property (nonatomic) UITextView *lexiconDescription;
@end

@implementation UPSpellAboutPaneLegal

+ (UPSpellAboutPaneLegal *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();

    self.lexiconDescription = [[UITextView alloc] initWithFrame:layout.frame_for(Role::AboutLexiconDescription)];
    self.lexiconDescription.editable = NO;
    self.lexiconDescription.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lexiconDescription];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.lexiconDescription.userInteractionEnabled = YES;
    [self updateThemeColors];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    self.lexiconDescription.linkTextAttributes = @{ NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryControlText] };

    SpellLayout &layout = SpellLayout::instance();

    NSString *string =
    @"The LEXICON is the game’s word list. It’s built for fun. It contains everyday words, proper names, acronyms, tech terms, texting slang, "
    "the names of Santa’s reindeer, and much more. Try stuff.\n"
    "Some derisive terms are not in the lexicon. Many impolite words are. Use them or not.\n"
    "Due to randomness, bad words might appear in the letter tray. No offense intended.\n"
    "Find out more: ";
    NSMutableAttributedString *attributedAtring = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc] initWithString:@"https://upgames.dev/upspell/lexicon"];
    [linkString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"https://upgames.dev/upspell/lexicon"] range:NSMakeRange(0, linkString.length)];
    [linkString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, linkString.length)];
    [linkString addAttribute:NSUnderlineColorAttributeName value:[UIColor themeColorWithCategory:UPColorCategoryControlText] range:NSMakeRange(0, linkString.length)];
    [attributedAtring appendAttributedString:linkString];
    
    attributedAtring.font = layout.about_font();
    CGFloat spacing = up_float_scaled(14, layout.layout_scale());
    [attributedAtring setTextAlignment:NSTextAlignmentLeft paragraphSpacing:spacing];
    attributedAtring.textColor = [UIColor themeColorWithCategory:UPColorCategoryControlText];
    
    self.lexiconDescription.attributedText = attributedAtring;
}

@end
