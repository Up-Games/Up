//
//  UPSpellSettings.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPSpellSettings.h"

@implementation UPSpellSettings

@dynamic dataVersion;
@dynamic theme;
@dynamic extrasSelectedIndex;
@dynamic tuneHistory;
@dynamic tunesEnabled;
@dynamic tunesLevel;
@dynamic soundEffectsEnabled;
@dynamic soundEffectsLevel;
@dynamic showShareHelp;
@dynamic showDuelHelp;
@dynamic showWelcome;

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
    self.theme = UPThemeBlueLight;
    self.extrasSelectedIndex = 0;
    self.tuneHistory = [NSArray array];
    self.tunesEnabled = YES;
    self.tunesLevel = 4;
    self.soundEffectsEnabled = YES;
    self.soundEffectsLevel = 4;
    self.showShareHelp = YES;
    self.showDuelHelp = YES;
    self.showWelcome = YES;
}

@end
