//
//  UPActivityViewController.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <LinkPresentation/LinkPresentation.h>

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPGameKey.h>

#import "UPActivityViewController.h"
#import "UPGameLink.h"
#import "UPSpellDossier.h"

// =========================================================================================================================================

@interface UPActivityViewItemSource : NSObject <UIActivityItemSource>
@property (nonatomic) UPShareType shareType;
@property (nonatomic) NSString *shareString;
@property (nonatomic) NSString *shareURLString;
@property (nonatomic) NSURL *shareURL;
@property (nonatomic) UPGameKey *gameKey;
@end

@implementation UPActivityViewItemSource

- (instancetype)initWithShareType:(UPShareType)shareType gameKey:(UPGameKey *)gameKey
{
    self = [super init];
    self.shareType = shareType;
    self.gameKey = gameKey;
    self.shareString = [self _makeShareString];
    self.shareURL = [self _makeShareURL];
    self.shareURLString = [self _makeShareURLString];
    return self;
}


#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return [self shareURL];
    
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(UIActivityType)activityType
{
    if ([activityType isEqualToString:UIActivityTypeMessage]) {
        return [self shareURL];
    }
    else if ([activityType isEqualToString:UIActivityTypeMail]) {
        return [NSString stringWithFormat:@"%@ %@", [self _makeMailMessage], [self shareURL]];
    }
    return [NSString stringWithFormat:@"%@ %@", [self shareString], [self shareURL]];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(UIActivityType)activityType
{
    if ([activityType isEqualToString:UIActivityTypeMessage]) {
        return nil;
    }
    else if ([activityType isEqualToString:UIActivityTypeMail]) {
        return [self _makeMailSubject];
    }
    return [self shareString];
}

- (LPLinkMetadata *)activityViewControllerLinkMetadata:(UIActivityViewController *)activityViewController
{
    LPLinkMetadata *metadata = [[LPLinkMetadata alloc] init];
    metadata.originalURL = [self shareURL];
    metadata.URL = [self shareURL];
    metadata.title = [self shareString];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSString *iconName = [NSString stringWithFormat:@"%@@%dx", up_theme_icon_name(), (int)scale];
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *iconURL = [bundle URLForResource:[iconName lastPathComponent] withExtension:@"png"];
    metadata.iconProvider = [[NSItemProvider alloc] initWithContentsOfURL:iconURL];
    
    return metadata;
}

- (NSString *)_makeShareURLString
{
    return [self.shareURL absoluteString];
}

- (NSURL *)_makeShareURL
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    UPGameLink *gameLink = nil;
    UPGameKey *gameKey = nil;
    switch (self.shareType) {
        case UPShareTypeDefault:
        case UPShareTypeLastGameScore: {
            gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            gameLink = [UPGameLink challengeGameLinkWithGameKey:gameKey score:dossier.lastScore];
            break;
        }
        case UPShareTypeHighScore: {
            gameKey = [UPGameKey gameKeyWithValue:dossier.highScoreGameKeyValue];
            gameLink = [UPGameLink challengeGameLinkWithGameKey:gameKey score:dossier.highScore];
            break;
        }
        case UPShareTypeChallengeReply: {
            UPSpellDossier *dossier = [UPSpellDossier instance];
            ASSERT(dossier.lastGameWasChallenge);
            UPGameKey *gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            int challengeScore = dossier.lastGameChallengeScore;
            int score = dossier.lastScore;
            if (score >= challengeScore) {
                gameLink = [UPGameLink challengeGameLinkWithGameKey:gameKey score:score];
            }
            else {
                gameLink = [UPGameLink challengeGameLinkWithGameKey:gameKey score:challengeScore];
            }
            break;
        }
        case UPShareTypeDuel: {
            gameKey = self.gameKey;
            gameLink = [UPGameLink duelGameLinkWithGameKey:gameKey];
            break;
        }
        case UPShareTypeDuelReply: {
            gameKey = self.gameKey;
            gameLink = [UPGameLink challengeGameLinkWithGameKey:gameKey score:dossier.lastScore];
            break;
        }
    }
    
    return gameLink.URL;
}

- (NSString *)_makeMailSubject
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    switch (self.shareType) {
        case UPShareTypeDefault:
        case UPShareTypeLastGameScore:
        case UPShareTypeHighScore: {
            UPGameKey *gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            return [NSString stringWithFormat:@"I scored %d in Up Spell! (Game ID: %@)", dossier.lastScore, gameKey.string];
        }
        case UPShareTypeChallengeReply: {
            ASSERT(dossier.lastGameWasChallenge);
            int challengeScore = dossier.lastGameChallengeScore;
            int score = dossier.lastScore;
            if (score > challengeScore) {
                return [NSString stringWithFormat:@"I won an Up Spell challenge!"];
            }
            else if (score == challengeScore) {
                return [NSString stringWithFormat:@"I tied an Up Spell challenge!"];
            }
            else {
                return [NSString stringWithFormat:@"I lost an Up Spell challenge."];
            }
        }
        case UPShareTypeDuel: {
            return [NSString stringWithFormat:@"Let’s play Up Spell! (Game ID: %@)", self.gameKey.string];
        }
        case UPShareTypeDuelReply: {
            ASSERT(dossier.lastGameWasDuel);
            int score = dossier.lastScore;
            return [NSString stringWithFormat:@"I scored %d in Up Spell! (Game ID: %@)", score, self.gameKey.string];
        }
    }
    return nil;
}

- (NSString *)_makeMailMessage
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    switch (self.shareType) {
        case UPShareTypeDefault:
        case UPShareTypeLastGameScore: {
            return @"Top that!";
        }
        case UPShareTypeHighScore: {
            return @"Top that!";
        }
        case UPShareTypeChallengeReply: {
            ASSERT(dossier.lastGameWasChallenge);
            UPGameKey *gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            int challengeScore = dossier.lastGameChallengeScore;
            int score = dossier.lastScore;
            if (score > challengeScore) {
                return [NSString stringWithFormat:@"I won %d–%d! (Game ID: %@)", score, challengeScore, gameKey.string];
            }
            else if (score == challengeScore) {
                return [NSString stringWithFormat:@"I tied %d–%d! (Game ID: %@)", score, score, gameKey.string];
            }
            else {
                return [NSString stringWithFormat:@"I lost %d–%d. (Game ID: %@)", challengeScore, score, gameKey.string];
            }
            break;
        }
        case UPShareTypeDuel: {
            return @"Tap the link to play!";
        }
        case UPShareTypeDuelReply: {
            return @"Top that!";
        }
    }
    return nil;
}

- (NSString *)_makeShareString
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    switch (self.shareType) {
        case UPShareTypeDefault:
        case UPShareTypeLastGameScore: {
            UPGameKey *gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            return [NSString stringWithFormat:@"I scored %d in Up Spell. Top that! (Game ID: %@)", dossier.lastScore, gameKey.string];
        }
        case UPShareTypeHighScore: {
            UPGameKey *gameKey = [UPGameKey gameKeyWithValue:dossier.highScoreGameKeyValue];
            return [NSString stringWithFormat:@"My Up Spell high score is %d. Top that! (Game ID: %@)", dossier.highScore, gameKey.string];
        }
        case UPShareTypeChallengeReply: {
            ASSERT(dossier.lastGameWasChallenge);
            UPGameKey *gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            int challengeScore = dossier.lastGameChallengeScore;
            int score = dossier.lastScore;
            if (score > challengeScore) {
                return [NSString stringWithFormat:@"I won an Up Spell challenge %d–%d! (Game ID: %@)", score, challengeScore, gameKey.string];
            }
            else if (score == challengeScore) {
                return [NSString stringWithFormat:@"I tied an Up Spell challenge %d–%d! (Game ID: %@)", score, score, gameKey.string];
            }
            else {
                return [NSString stringWithFormat:@"I lost an Up Spell challenge %d–%d. (Game ID: %@)", challengeScore, score, gameKey.string];
            }
            break;
        }
        case UPShareTypeDuel: {
            return [NSString stringWithFormat:@"Let’s play Up Spell! (Game ID: %@)", self.gameKey.string];
        }
        case UPShareTypeDuelReply: {
            ASSERT(dossier.lastGameWasDuel);
            int score = dossier.lastScore;
            return [NSString stringWithFormat:@"I scored %d. Top that! (Game ID: %@)", score, self.gameKey.string];
        }
    }
    return nil;
}

@end

// =========================================================================================================================================

@interface UPActivityViewController ()
@end

@implementation UPActivityViewController

- (instancetype)initWithShareType:(UPShareType)shareType
{
    return [self initWithShareType:shareType gameKey:nil];
}

- (instancetype)initWithShareType:(UPShareType)shareType gameKey:(UPGameKey *)gameKey
{
    UPActivityViewItemSource *itemSource = [[UPActivityViewItemSource alloc] initWithShareType:shareType gameKey:gameKey];
    self = [super initWithActivityItems:@[ itemSource ] applicationActivities:nil];
    
    self.excludedActivityTypes = @[
        UIActivityTypeAirDrop,
        UIActivityTypePrint,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
        UIActivityTypeMarkupAsPDF,
        UIActivityTypeAddToReadingList,
        UIActivityTypeOpenInIBooks,
        UIActivityTypePostToFacebook,
    ];
    
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
