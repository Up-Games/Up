//
//  UPSpellPersistentData.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPMacros.h>

#import "UPSpellPersistentData.h"

@interface UPSpellPersistentData ()
@end

@implementation UPSpellPersistentData

+ (UPSpellPersistentData *)instance
{
    static dispatch_once_t onceToken;
    static UPSpellPersistentData *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [UPSpellPersistentData restore];
        if (!_Instance) {
            _Instance = [[UPSpellPersistentData alloc] init];
        }
    });
    return _Instance;
}

- (instancetype)init
{
    self = [super init];

    self.highScore = 0;
    self.highGameKey = 0;
    self.lastScore = 0;
    self.lastGameKey = 0;
    
    self.totalGamesPlayed = 0;
    self.totalGameScore = 0;
    self.totalWordsSubmitted = 0;
    self.totalTilesSubmitted = 0;

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];

    UP_DECODE(coder, highScore, Int);
    UP_DECODE(coder, highGameKey, Int32);
    UP_DECODE(coder, lastScore, Int);
    UP_DECODE(coder, lastGameKey, Int32);

    UP_DECODE(coder, totalGamesPlayed, Integer);
    UP_DECODE(coder, totalGameScore, Integer);
    UP_DECODE(coder, totalWordsSubmitted, Integer);
    UP_DECODE(coder, totalTilesSubmitted, Integer);

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    UP_ENCODE(coder, highScore, Int);
    UP_ENCODE(coder, highGameKey, Int32);
    UP_ENCODE(coder, lastScore, Int);
    UP_ENCODE(coder, lastGameKey, Int32);
    
    UP_ENCODE(coder, totalGamesPlayed, Integer);
    UP_ENCODE(coder, totalGameScore, Integer);
    UP_ENCODE(coder, totalWordsSubmitted, Integer);
    UP_ENCODE(coder, totalTilesSubmitted, Integer);
}

@dynamic supportsSecureCoding;
+ (BOOL)supportsSecureCoding
{
    return YES;
}

static NSString * const UPSpellPersistentDataFileName = @"up-spell-persistent.dat";

static NSString *save_file_path(NSString *name)
{
    NSString *path = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *possibleURLs = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (possibleURLs.count > 0) {
        NSURL *documentDirectoryURL = [possibleURLs objectAtIndex:0];
        NSURL *archiveFileURL = [documentDirectoryURL URLByAppendingPathComponent:name];
        path = [NSString stringWithUTF8String:[[archiveFileURL path] fileSystemRepresentation]];
    }
    return path;
}

- (void)save
{
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"error writing persistent data: %@", error);
    }
    else {
        NSString *saveFilePath = save_file_path(UPSpellPersistentDataFileName);
        if (saveFilePath) {
            [data writeToFile:saveFilePath atomically:YES];
            LOG(General, "savePersistentData: %@", saveFilePath);
        }
        else {
            NSLog(@"error writing persistent data: save file unavailable");
        }
    }
}

+ (UPSpellPersistentData *)restore
{
    NSString *saveFilePath = save_file_path(UPSpellPersistentDataFileName);
    if (!saveFilePath) {
        NSLog(@"error reading persistent data: save file unavailable: %@", saveFilePath);
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:saveFilePath];
    if (!data) {
        NSLog(@"error reading persistent data: save data unavailable: %@", saveFilePath);
        return nil;
    }
    NSError *error;
    Class cls = [UPSpellPersistentData class];
    UPSpellPersistentData *persistentData = [NSKeyedUnarchiver unarchivedObjectOfClass:cls fromData:data error:&error];
    if (error) {
        NSLog(@"error reading persistent data: %@ : %@", saveFilePath, error);
        return nil;
    }
    return persistentData;
}

@end
