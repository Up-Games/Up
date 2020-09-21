//
//  UPSpellExtrasPaneAbout.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <WebKit/WebKit.h>

#import <UpKit/UIColor+UP.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellExtrasPaneAbout.h"
#import "UPSpellLayout.h"
#import "UPSpellSettings.h"

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;

@interface UPSpellExtrasPaneAbout () <WKNavigationDelegate>
@property (nonatomic) UITextView *thanksDescription;
@end

@implementation UPSpellExtrasPaneAbout

+ (UPSpellExtrasPaneAbout *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    SpellLayout &layout = SpellLayout::instance();
    self.thanksDescription = [[UITextView alloc] initWithFrame:layout.frame_for(Role::ExtrasAbout)];
    self.thanksDescription.editable = NO;
    self.thanksDescription.opaque = NO;
    self.thanksDescription.backgroundColor = [UIColor clearColor];
    self.thanksDescription.contentInset = UIEdgeInsetsMake(22, 0, 0, 0);
    [self addSubview:self.thanksDescription];

    return self;
}

- (void)prepare
{
    self.thanksDescription.contentOffset = CGPointMake(0, -22);
    self.thanksDescription.userInteractionEnabled = YES;
    [self updateThemeColors];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];

    SpellLayout &layout = SpellLayout::instance();
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *introFileURL = [bundle URLForResource:@"about-intro" withExtension:@"rtf"];
    NSMutableAttributedString *introAttrString = [[NSMutableAttributedString alloc] initWithURL:introFileURL options:@{
        NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType
    } documentAttributes:nil error:nil];
    NSURL *licensesFileURL = [bundle URLForResource:@"about-licenses" withExtension:@"rtf"];
    NSMutableAttributedString *licensesAttrString = [[NSMutableAttributedString alloc] initWithURL:licensesFileURL options:@{
        NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType
    } documentAttributes:nil error:nil];

    UIColor *color = [UIColor themeColorWithCategory:UPColorCategoryControlText];
    
    [introAttrString setFont:layout.about_font()];
    [introAttrString setTextColor:color];

    [licensesAttrString setFont:layout.legal_font()];
    [licensesAttrString setTextColor:color];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString appendAttributedString:introAttrString];
    [attrString appendAttributedString:licensesAttrString];

    self.thanksDescription.linkTextAttributes = @{
        NSForegroundColorAttributeName: color,
        NSUnderlineColorAttributeName: color,
        NSUnderlineStyleAttributeName: @(1)
    };
    self.thanksDescription.attributedText = attrString;

    switch ([UIColor themeColorStyle]) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
        case UPThemeColorStyleLightStark:
            self.thanksDescription.indicatorStyle = UIScrollViewIndicatorStyleDefault;
            break;
        case UPThemeColorStyleDark:
        case UPThemeColorStyleDarkStark:
            self.thanksDescription.indicatorStyle = UIScrollViewIndicatorStyleWhite;
            break;
    }
}

@end
