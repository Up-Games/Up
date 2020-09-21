//
//  UIFont+UPSpell.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <CoreText/CoreText.h>

#import <UpKit/UIFont+UP.h>

#import "UIFont+UPSpell.h"

NSString * const UPTextButtonFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPGameInformationFontName = @"MalloryNarrow-Bold";
NSString * const UPGameNoteFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPGameNoteWordFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPWordScoreBonusFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPCheckboxControlFontName = @"MalloryCondensed-Black";
NSString * const UPChoiceControlFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPRotorControlFontName = @"MalloryCondensed-Black";
NSString * const UPDialogTitleFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPDescriptionFontName = @"MalloryCondensed-Bold";
NSString * const UPAboutFontName = @"MalloryCondensed-Bold";
NSString * const UPGameLinkFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPPlacardValueFontName = @"MalloryCondensed-Black";
NSString * const UPPlacardDescriptionFontName = @"MalloryCondensed-Black";
NSString * const UPWordMarkFontName = @"MalloryCondensed-Black";
NSString * const UPLegalFontName = @"MalloryCondensed-Bold";
NSString * const UPHelpPromptFontName = @"MalloryCondensed-BlackItalic";
NSString * const UPDingbatsFontName = @"ZapfDingbatsITC";

//
//  Below, the UIFontFeatureTypeIdentifierKey and UIFontFeatureSelectorIdentifierKey are set from
//  from the information in the CTFontRef that can be retrived like so:
//    NSArray *features = CFBridgingRelease(CTFontCopyFeatures((__bridge CTFontRef)(font)));
//    NSLog(@"features: %@", features);

@implementation UIFont (UPSpell)

+ (UIFont *)textButtonFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPTextButtonFontName size:fontSize];
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

+ (UIFont *)textButtonFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPTextButtonFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont textButtonFontOfSize:pointSize];
}

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
    UIFont *font = [UIFont fontWithName:UPGameNoteFontName size:fontSize];
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

+ (UIFont *)gameNoteFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPGameNoteFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont gameNoteFontOfSize:pointSize];
}

+ (UIFont *)gameNoteWordFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPGameNoteWordFontName size:fontSize];
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

+ (UIFont *)gameNoteWordFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPGameNoteWordFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont gameNoteWordFontOfSize:pointSize];
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

+ (UIFont *)dialogTitleFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPDialogTitleFontName size:fontSize];
}

+ (UIFont *)dialogTitleFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPDialogTitleFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont dialogTitleFontOfSize:pointSize];
}

+ (UIFont *)descriptionFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPDescriptionFontName size:fontSize];
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

+ (UIFont *)descriptionFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPDescriptionFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont descriptionFontOfSize:pointSize];
}

+ (UIFont *)aboutFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPAboutFontName size:fontSize];
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

+ (UIFont *)aboutFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPAboutFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont aboutFontOfSize:pointSize];
}

+ (UIFont *)gameLinkFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPGameLinkFontName size:fontSize];
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

+ (UIFont *)gameLinkFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPGameLinkFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont gameLinkFontOfSize:pointSize];
}

+ (UIFont *)placardValueFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPPlacardValueFontName size:fontSize];
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

+ (UIFont *)placardValueFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPPlacardValueFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont placardValueFontOfSize:pointSize];
}

+ (UIFont *)placardDescriptionFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPPlacardDescriptionFontName size:fontSize];
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

+ (UIFont *)placardDescriptionFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPPlacardDescriptionFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont placardDescriptionFontOfSize:pointSize];
}

+ (UIFont *)wordMarkFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPWordMarkFontName size:fontSize];
}

+ (UIFont *)wordMarkFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPWordMarkFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont wordMarkFontOfSize:pointSize];
}

+ (UIFont *)legalFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPLegalFontName size:fontSize];
}

+ (UIFont *)legalFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPLegalFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont legalFontOfSize:pointSize];
}

+ (UIFont *)helpPromptFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPHelpPromptFontName size:fontSize];
}

+ (UIFont *)helpPromptFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPHelpPromptFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont helpPromptFontOfSize:pointSize];
}

+ (UIFont *)dingbatsFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPDingbatsFontName size:fontSize];
}

+ (UIFont *)dingbatsFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPDingbatsFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont dingbatsFontOfSize:pointSize];
}

@end
