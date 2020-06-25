//
//  UIFont+UPSpell.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "UIFont+UPSpell.h"

NSString * const UPGameInformationFontName = @"MalloryNarrow-Bold";
NSString * const UPGameNoteFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPWordScoreBonusFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPCheckboxControlFontName = @"MalloryCondensed-Black";
NSString * const UPChoiceControlFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPSettingsDescriptionFontName = @"MalloryCondensed-BoldItalic";

//
//  Below, the UIFontFeatureTypeIdentifierKey and UIFontFeatureSelectorIdentifierKey are set from
//  from the information in the CTFontRef that can be retrived like so:
//    NSArray *features = CFBridgingRelease(CTFontCopyFeatures((__bridge CTFontRef)(font)));
//    NSLog(@"features: %@", features);

@implementation UIFont (UPSpell)

+ (UIFont *)gameInformationFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPGameInformationFontName size:fontSize];
    UIFontDescriptor *descriptor = [font fontDescriptor];
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
            @{
                UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)
            },
            @{
                UIFontFeatureTypeIdentifierKey: @(35),     // Alternative Stylistic Sets
                UIFontFeatureSelectorIdentifierKey: @(22)  // Raised Colon (Lining Figures Only)
            },
        ]
    };
    UIFontDescriptor *fontDescriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
}

+ (UIFont *)gameInformationFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPGameInformationFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont gameInformationFontOfSize:pointSize];
}

+ (UIFont *)gameNoteFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPGameNoteFontName size:fontSize];
}

+ (UIFont *)gameNoteFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPGameNoteFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont gameNoteFontOfSize:pointSize];
}

+ (UIFont *)wordScoreFontOfSize:(CGFloat)fontSize
{
    return [UIFont gameInformationFontOfSize:fontSize];
}

+ (UIFont *)wordScoreFontWithCapHeight:(CGFloat)capHeight
{
    return [UIFont gameInformationFontWithCapHeight:capHeight];
}

+ (UIFont *)wordScoreBonusFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPWordScoreBonusFontName size:fontSize];
    UIFontDescriptor *descriptor = [font fontDescriptor];
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
                @{
                    UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                    UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)
                }
        ]
    };
    UIFontDescriptor *fontDescriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
}

+ (UIFont *)wordScoreBonusFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPWordScoreBonusFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont wordScoreBonusFontOfSize:pointSize];
}

+ (UIFont *)checkboxControlFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPCheckboxControlFontName size:fontSize];
    UIFontDescriptor *descriptor = [font fontDescriptor];
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
                @{
                    UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                    UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)
                }
        ]
    };
    UIFontDescriptor *fontDescriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
}

+ (UIFont *)checkboxControlFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPCheckboxControlFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont checkboxControlFontOfSize:pointSize];
}

+ (UIFont *)choiceControlFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPChoiceControlFontName size:fontSize];
    UIFontDescriptor *descriptor = [font fontDescriptor];
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
                @{
                    UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                    UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)
                }
        ]
    };
    UIFontDescriptor *fontDescriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
}

+ (UIFont *)choiceControlFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPChoiceControlFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont choiceControlFontOfSize:pointSize];
}

+ (UIFont *)settingsDescriptionFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPSettingsDescriptionFontName size:fontSize];
    UIFontDescriptor *descriptor = [font fontDescriptor];
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
                @{
                    UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                    UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)
                }
        ]
    };
    UIFontDescriptor *fontDescriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
}

+ (UIFont *)settingsDescriptionFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPSettingsDescriptionFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont settingsDescriptionFontOfSize:pointSize];
}

@end
