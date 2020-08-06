//
//  UPSpellSettings.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPSpellSettings.h"

@implementation UPSpellSettings

@dynamic dataVersion;
@dynamic themeColorStyle;
@dynamic themeColorHue;
@dynamic quarkMode;
@dynamic extrasSelectedIndex;
@dynamic retryMode;
@dynamic playMenuSelectedIndex;
@dynamic tuneHistory;
@dynamic tunesEnabled;
@dynamic tunesLevel;
@dynamic soundEffectsEnabled;
@dynamic soundEffectsLevel;

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
    self.dataVersion = 0;
    self.themeColorStyle = UPThemeColorStyleLight;
    self.themeColorHue = 225;
    self.quarkMode = NO;
    self.extrasSelectedIndex = 0;
    self.retryMode = NO;
    self.playMenuSelectedIndex = 2;
    self.tuneHistory = [NSArray array];
    self.tunesEnabled = YES;
    self.tunesLevel = 4;
    self.soundEffectsEnabled = YES;
    self.soundEffectsLevel = 4;
}

@end
