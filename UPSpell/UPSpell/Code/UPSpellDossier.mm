//
//  UPSpellDossier.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/runtime.h>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPMacros.h>

#import "UPSpellDossier.h"

@interface UPSpellDossier ()
@end

@implementation UPSpellDossier

+ (UPSpellDossier *)instance
{
    static dispatch_once_t onceToken;
    static UPSpellDossier *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [UPSpellDossier restore];
        if (!_Instance) {
            _Instance = [[UPSpellDossier alloc] init];
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

- (void)updateWithModel:(UP::SpellModelPtr)model
{
    ASSERT(model->back_opcode() == UP::SpellModel::Opcode::END);
    
    UPSpellDossier *data = [UPSpellDossier instance];
    
    if (data.highScore <= model->game_score() && model->game_score() > 0) {
        data.highScore = model->game_score();
        data.highGameKey = model->game_key().value();
    }
    
    data.lastScore = model->game_score();
    data.lastGameKey = model->game_key().value();
    
    data.totalGamesPlayed++;
    data.totalGameScore += model->game_score();
    data.totalWordsSubmitted += model->game_words_submitted();
    data.totalTilesSubmitted += model->game_tiles_submitted();
}

static NSString * const UPSpellDossierFileName = @"up-spell-dossier.dat";

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
        NSString *saveFilePath = save_file_path(UPSpellDossierFileName);
        if (saveFilePath) {
            [data writeToFile:saveFilePath atomically:YES];
            LOG(General, "savePersistentData: %@", saveFilePath);
        }
        else {
            NSLog(@"error writing persistent data: save file unavailable");
        }
    }
}

+ (UPSpellDossier *)restore
{
    NSString *saveFilePath = save_file_path(UPSpellDossierFileName);
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
    Class cls = [UPSpellDossier class];
    UPSpellDossier *persistentData = [NSKeyedUnarchiver unarchivedObjectOfClass:cls fromData:data error:&error];
    if (error) {
        NSLog(@"error reading persistent data: %@ : %@", saveFilePath, error);
        return nil;
    }
    return persistentData;
}

@end
