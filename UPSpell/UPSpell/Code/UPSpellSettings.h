//
//  UPSpellSettings.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UpKit.h>

@interface UPSpellSettings : UPSettings
@property (nonatomic) NSUInteger dataVersion;
@property (nonatomic) UPTheme theme;
@property (nonatomic) NSUInteger extrasSelectedIndex;
@property (nonatomic) NSArray<NSNumber *> *tuneHistory;
@property (nonatomic) BOOL tunesEnabled;
@property (nonatomic) NSUInteger tunesLevel;
@property (nonatomic) BOOL soundEffectsEnabled;
@property (nonatomic) NSUInteger soundEffectsLevel;
@property (nonatomic) BOOL showDuelHelp;
@property (nonatomic) BOOL showShareHelp;

+ (UPSpellSettings *)instance;
- (instancetype)init NS_UNAVAILABLE;

@end
