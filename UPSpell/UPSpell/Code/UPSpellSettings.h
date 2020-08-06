//
//  UPSpellSettings.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

@interface UPSpellSettings : UPSettings
@property (nonatomic) NSUInteger dataVersion;
@property (nonatomic) UPThemeColorStyle themeColorStyle;
@property (nonatomic) CGFloat themeColorHue;
@property (nonatomic) BOOL quarkMode;
@property (nonatomic) NSUInteger extrasSelectedIndex;
@property (nonatomic) BOOL retryMode;
@property (nonatomic) NSUInteger playMenuSelectedIndex;
@property (nonatomic) NSArray<NSNumber *> *tuneHistory;
@property (nonatomic) BOOL tunesEnabled;
@property (nonatomic) NSUInteger tunesLevel;
@property (nonatomic) BOOL soundEffectsEnabled;
@property (nonatomic) NSUInteger soundEffectsLevel;

+ (UPSpellSettings *)instance;
- (instancetype)init NS_UNAVAILABLE;

@end
