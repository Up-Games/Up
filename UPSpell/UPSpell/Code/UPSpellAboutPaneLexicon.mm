//
//  UPSpellAboutPaneLexicon.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <WebKit/WebKit.h>

#import <UpKit/UIColor+UP.h>

#import "UIFont+UPSpell.h"
#import "UPControl+UPSpell.h"
#import "UPSpellAboutPaneLexicon.h"
#import "UPSpellLayout.h"
#import "UPSpellSettings.h"

using UP::SpellLayout;
using Role = UP::SpellLayout::Role;

@interface UPSpellAboutPaneLexicon () <WKNavigationDelegate>
@property (nonatomic) WKWebView *lexiconDescription;
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
    
    self.lexiconDescription.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lexiconDescription];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.lexiconDescription = [[WKWebView alloc] initWithFrame:layout.frame_for(Role::AboutLegalDescription) configuration:configuration];
    self.lexiconDescription.opaque = NO;
    self.lexiconDescription.backgroundColor = [UIColor clearColor];
    self.lexiconDescription.scrollView.backgroundColor = [UIColor clearColor];
    self.lexiconDescription.navigationDelegate = self;
    [self addSubview:self.lexiconDescription];
    
    [self updateThemeColors];
    
    return self;
}

- (void)prepare
{
    self.lexiconDescription.userInteractionEnabled = YES;
    [self updateThemeColors];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript:@"window.scrollTo(0,0)" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    if (URL.isFileURL) {
        if (decisionHandler) {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    else {
        if (decisionHandler) {
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *baseURL = [NSURL fileURLWithPath:bundle.resourcePath];
    NSString *path = [bundle pathForResource:@"lexicon" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *textColorString = [[UIColor themeColorWithCategory:UPColorCategoryControlText] asCSSRGBAString];
    NSString *cssColorString = [NSString stringWithFormat:@"color: %@;", textColorString];
    NSString *aLinkString = [[UIColor themeColorWithCategory:UPColorCategoryControlText] asCSSRGBAString];
    NSString *cssALinkString = [NSString stringWithFormat:@"color: %@;", aLinkString];
    NSString *aVisitedString = [[UIColor themeColorWithCategory:UPColorCategoryControlText] asCSSRGBAString];
    NSString *cssAVisitedString = [NSString stringWithFormat:@"color: %@;", aVisitedString];
    NSString *aActiveString = [[UIColor themeColorWithCategory:UPColorCategoryHighlightedFill] asCSSRGBAString];
    NSString *cssAActiveString = [NSString stringWithFormat:@"color: %@;", aActiveString];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"/* --color-- */" withString:cssColorString];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"/* --a:link-- */" withString:cssALinkString];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"/* --a:visited-- */" withString:cssAVisitedString];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"/* --a:active-- */" withString:cssAActiveString];
    [self.lexiconDescription loadHTMLString:htmlString baseURL:baseURL];
}

@end