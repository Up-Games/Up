//
//  UPSpellSettings.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPSpellSettings.h"

@implementation UPSpellSettings

@dynamic themeColorStyle;
@dynamic themeColorHue;

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
    self.themeColorStyle = UPThemeColorStyleLight;
    self.themeColorHue = 225;
    self.extrasSelectedIndex = 0;
    self.databaseSchemaVersion = 0;
}

@end
