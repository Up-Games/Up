//
//  UIFont+UPSpell.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "UIFont+UPSpell.h"

static NSString * const UPLetterGameplayInformationFontFontName = @"MalloryNarrow-Bold";
static NSString * const UPLetterTileGlyphFontName = @"MalloryCondensed-Bold";
static NSString * const UPLetterTileScoreFontName = @"MalloryMPNarrow-Bold";

@interface UIFontDescriptor (UPSpell)
+ (UIFontDescriptor *)monospacedDigitFontDescriptor;
@end

@implementation UIFontDescriptor (UPSpell)

+ (UIFontDescriptor *)monospacedDigitFontDescriptor
{
    return nil;
}

@end

// =========================================================================================================================================
//
//  Below, the UIFontFeatureTypeIdentifierKey and UIFontFeatureSelectorIdentifierKey are set from
//  from the information in the CTFontRef that can be retrived like so:
//    NSArray *features = CFBridgingRelease(CTFontCopyFeatures((__bridge CTFontRef)(font)));
//    NSLog(@"features: %@", features);

@implementation UIFont (UPSpell)

+ (UIFont *)gameplayInformationFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPLetterGameplayInformationFontFontName size:fontSize];
    UIFontDescriptor *descriptor = [font fontDescriptor];
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
            @{
                UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector),
            },
            @{
                UIFontFeatureTypeIdentifierKey: @(35),     // Alternative Stylistic Sets
                UIFontFeatureSelectorIdentifierKey: @(22), // Raised Colon (Lining Figures Only)
            },
        ]
    };
    UIFontDescriptor *fontDescriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
}

+ (UIFont *)letterTileGlyphFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPLetterTileGlyphFontName size:fontSize];
}

+ (UIFont *)letterTileScoreFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPLetterTileScoreFontName size:fontSize];
    UIFontDescriptor *descriptor = [font fontDescriptor];
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
            @{
                UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType),
                UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector),
            },
        ]
    };
    UIFontDescriptor *fontDescriptor = [descriptor fontDescriptorByAddingAttributes:attributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
}

@end
