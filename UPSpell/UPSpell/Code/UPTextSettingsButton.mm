//
//  UPTextSettingsButton.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>

#import "UPTextSettingsButton.h"

@implementation UPTextSettingsButton

+ (UPTextSettingsButton *)textSettingsButton;
{
    return [[UPTextSettingsButton alloc] initWithTarget:nil action:nullptr];
}

+ (UPTextSettingsButton *)textSettingsButtonWithLabelString:(NSString *)labelString;
{
    UPTextSettingsButton *button = [[UPTextSettingsButton alloc] initWithTarget:nil action:nullptr];
    [button setLabelString:labelString];
    return button;
}

+ (UPTextSettingsButton *)textSettingsButtonWithTarget:(id)target action:(SEL)action;
{
    return [[UPTextSettingsButton alloc] initWithTarget:target action:action];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    [self setFillColorCategory:UPColorCategoryHighlightedFill forState:(UPControlStateSelected | UPControlStateHighlighted)];
    [self setFillColorCategory:UPColorCategoryClear forState:UPControlStateSelected];
    [self setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:(UPControlStateSelected | UPControlStateHighlighted)];
    [self setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateSelected];
    [self setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    [self setLabelColorCategory:UPColorCategoryControlText forState:UPControlStateSelected];
    [self setLabelColorAnimationDuration:0.5 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
    [self setLabelColorAnimationDuration:0.5 fromState:UPControlStateSelected toState:UPControlStateNormal];
    self.autoHighlights = YES;
    self.autoSelects = YES;
    self.band = UP::BandModeUI;
    return self;
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];

    switch ([UIColor themeColorStyle]) {
        case UPThemeColorStyleDefault:
        case UPThemeColorStyleLight:
        case UPThemeColorStyleDark:
            [self setFillColorAnimationDuration:0.5 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
            [self setFillColorAnimationDuration:0.3 fromState:UPControlStateSelected toState:UPControlStateNormal];
            [self setStrokeColorAnimationDuration:0 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
            [self setStrokeColorAnimationDuration:0 fromState:UPControlStateSelected toState:UPControlStateNormal];
            break;
        case UPThemeColorStyleLightStark:
        case UPThemeColorStyleDarkStark:
            [self setFillColorAnimationDuration:0 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
            [self setFillColorAnimationDuration:0 fromState:UPControlStateSelected toState:UPControlStateNormal];
            [self setStrokeColorAnimationDuration:0.5 fromState:(UPControlStateSelected | UPControlStateHighlighted) toState:UPControlStateSelected];
            [self setStrokeColorAnimationDuration:0.5 fromState:UPControlStateSelected toState:UPControlStateNormal];
            break;
    }
}

@end