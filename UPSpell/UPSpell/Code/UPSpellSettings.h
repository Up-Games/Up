//
//  UPSpellSettings.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

@interface UPSpellSettings : UPSettings
@property (nonatomic) NSUInteger databaseSchemaVersion;
@property (nonatomic) UPThemeColorStyle themeColorStyle;
@property (nonatomic) CGFloat themeColorHue;
@property (nonatomic) BOOL quarkMode;
@property (nonatomic) NSUInteger extrasSelectedIndex;
@property (nonatomic) NSUInteger statsSelectedTabIndex;

+ (UPSpellSettings *)instance;
- (instancetype)init NS_UNAVAILABLE;

@end
