//
//  UPSpellAboutPaneLexicon.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UIColor+UP.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutPaneLexicon.h"
#import "UPSpellLayout.h"
#import "UPSpellSettings.h"

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;

@interface UPSpellAboutPaneLexicon ()
@property (nonatomic) UITextView *lexiconDescription;
@end

@implementation UPSpellAboutPaneLexicon

+ (UPSpellAboutPaneLexicon *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();
    self.lexiconDescription = [[UITextView alloc] initWithFrame:layout.frame_for(Role::AboutThanksDescription)];
    self.lexiconDescription.editable = NO;
    self.lexiconDescription.opaque = NO;
    self.lexiconDescription.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lexiconDescription];

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

    SpellLayout &layout = SpellLayout::instance();

    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *fileURL = [bundle URLForResource:@"lexicon" withExtension:@"rtf"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithURL:fileURL options:@{
        NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType
    } documentAttributes:nil error:nil];
    
    UIColor *color = [UIColor themeColorWithCategory:UPColorCategoryControlText];
    
    [attrString setFont:layout.about_font()];
    [attrString setTextColor:color];

    self.lexiconDescription.linkTextAttributes = @{
        NSForegroundColorAttributeName: color,
        NSUnderlineColorAttributeName: color,
        NSUnderlineStyleAttributeName: @(1)
    };
    self.lexiconDescription.attributedText = attrString;
}

@end
