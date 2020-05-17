//
//  UIFont+UPSpell.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "UIFont+UPSpell.h"

NSString * const UPGameplayInformationFontName = @"MalloryNarrow-Bold";
NSString * const UPTileGlyphFontName = @"MalloryCondensed-Bold";
NSString * const UPTileScoreFontName = @"MalloryMPNarrow-Bold";
NSString * const UPTileMultiplierFontName = @"MalloryMPNarrow-Bold";

//
//  Below, the UIFontFeatureTypeIdentifierKey and UIFontFeatureSelectorIdentifierKey are set from
//  from the information in the CTFontRef that can be retrived like so:
//    NSArray *features = CFBridgingRelease(CTFontCopyFeatures((__bridge CTFontRef)(font)));
//    NSLog(@"features: %@", features);

@implementation UIFont (UPSpell)

+ (UIFont *)gameplayInformationFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPGameplayInformationFontName size:fontSize];
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

+ (UIFont *)gameplayInformationFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPGameplayInformationFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont gameplayInformationFontOfSize:pointSize];
}

+ (UIFont *)tileGlyphFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:UPTileGlyphFontName size:fontSize];
}

+ (UIFont *)tileGlyphFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPTileGlyphFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont tileGlyphFontOfSize:pointSize];
}

+ (UIFont *)tileScoreFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPTileScoreFontName size:fontSize];
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

+ (UIFont *)tileScoreFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPTileScoreFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont tileScoreFontOfSize:pointSize];
}

+ (UIFont *)tileMultiplierFontOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:UPTileMultiplierFontName size:fontSize];
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

+ (UIFont *)tileMultiplierFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPTileMultiplierFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont tileMultiplierFontOfSize:pointSize];
}

@end
