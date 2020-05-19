//
//  UIFont+UPSpell.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "UIFont+UPSpell.h"

NSString * const UPGameplayInformationFontName = @"MalloryNarrow-Bold";

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

+ (UIFont *)gameplayInformationFontWithCapHeight:(CGFloat)capHeight
{
    UIFont *canonicalFont = [UIFont fontWithName:UPGameplayInformationFontName size:1];
    CGFloat factor = capHeight / canonicalFont.capHeight;
    CGFloat pointSize = canonicalFont.pointSize * factor;
    return [UIFont gameplayInformationFontOfSize:pointSize];
}

@end
