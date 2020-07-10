//
//  UPSpellSettings.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPSpellSettings.h"

@implementation UPSpellSettings

@dynamic databaseSchemaVersion;
@dynamic themeColorStyle;
@dynamic themeColorHue;
@dynamic quarkMode;
@dynamic extrasSelectedIndex;
@dynamic statsSelectedTabIndex;
@dynamic obsessMode;
@dynamic obsessGameKeyValue;

+ (UPSpellSettings *)instance
{
    static dispatch_once_t onceToken;
    static UPSpellSettings *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[self alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    self = [super init];
    return self;
}

- (void)setDefaultValues
{
    self.databaseSchemaVersion = 0;
    self.themeColorStyle = UPThemeColorStyleLight;
    self.themeColorHue = 225;
    self.quarkMode = NO;
    self.extrasSelectedIndex = 0;
    self.statsSelectedTabIndex = 0;
    self.obsessMode = NO;
    self.obsessGameKeyValue = 0;
}

@end
