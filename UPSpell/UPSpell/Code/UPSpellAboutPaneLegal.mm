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
@property (nonatomic) UITextView *legalDescription;
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

    self.legalDescription = [[UITextView alloc] initWithFrame:layout.frame_for(Role::AboutLexiconDescription)];
    self.legalDescription.editable = NO;
    self.legalDescription.backgroundColor = [UIColor clearColor];
    [self addSubview:self.legalDescription];

    [self updateThemeColors];

    return self;
}

- (void)prepare
{
    self.legalDescription.userInteractionEnabled = YES;
    [self updateThemeColors];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    self.legalDescription.linkTextAttributes = @{ NSForegroundColorAttributeName: [UIColor themeColorWithCategory:UPColorCategoryControlText] };

    SpellLayout &layout = SpellLayout::instance();

    NSString *path = [[NSBundle mainBundle] pathForResource:@"legal" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableAttributedString *attributedAtring = [[NSMutableAttributedString alloc] initWithString:string];
    
    attributedAtring.font = layout.legal_font();
    [attributedAtring setTextAlignment:NSTextAlignmentLeft paragraphSpacing:0];
    attributedAtring.textColor = [UIColor themeColorWithCategory:UPColorCategoryControlText];
    
    self.legalDescription.attributedText = attributedAtring;
}

@end
