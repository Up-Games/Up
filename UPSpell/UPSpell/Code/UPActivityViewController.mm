//
//  UPActivityViewController.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <LinkPresentation/LinkPresentation.h>

#import <UpKit/UIColor+UP.h>

#import "UPActivityViewController.h"
#import "UPChallenge.h"
#import "UPSpellDossier.h"

// =========================================================================================================================================

@interface UPActivityViewItemSource : NSObject <UIActivityItemSource>
@property (nonatomic) UPShareType shareType;
@property (nonatomic) NSString *shareString;
@property (nonatomic) NSString *shareURLString;
@property (nonatomic) NSURL *shareURL;
@end

@implementation UPActivityViewItemSource

- (instancetype)initWithShareType:(UPShareType)shareType
{
    self = [super init];
    self.shareType = shareType;
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
    UPGameKey *gameKey = nil;
    int score = 0;
    switch (self.shareType) {
        case UPShareTypeDefault:
        case UPShareTypeLastGameScore: {
            gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            score = dossier.lastScore;
            break;
        }
        case UPShareTypeHighScore: {
            gameKey = [UPGameKey gameKeyWithValue:dossier.highScoreGameKeyValue];
            score = dossier.highScore;
            break;
        }
        case UPShareTypeChallengeReply: {
            UPSpellDossier *dossier = [UPSpellDossier instance];
            ASSERT(dossier.lastGameWasChallenge);
            score = dossier.lastScore;
            if (score >= dossier.lastGameChallengeScore) {
                gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            }
            else {
                gameKey = [UPGameKey randomGameKey];
            }
            break;
        }
    }
    
    UPChallenge *challenge = [UPChallenge challengeWithGameKey:gameKey score:score];
    return challenge.URL;
}

- (NSString *)_makeMailSubject
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    switch (self.shareType) {
        case UPShareTypeDefault:
        case UPShareTypeLastGameScore:
        case UPShareTypeHighScore: {
            return [NSString stringWithFormat:@"I scored %d in Up Spell!", dossier.lastScore];
        }
        case UPShareTypeChallengeReply: {
            ASSERT(dossier.lastGameWasChallenge);
            int challengeScore = dossier.lastGameChallengeScore;
            int score = dossier.lastScore;
            if (score > challengeScore) {
                return [NSString stringWithFormat:@"I beat you in Up Spell!"];
            }
            else if (score == challengeScore) {
                return [NSString stringWithFormat:@"We tied in Up Spell!"];
            }
            else {
                return [NSString stringWithFormat:@"You beat me in Up Spell."];
            }
            break;
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
            int challengeScore = dossier.lastGameChallengeScore;
            int score = dossier.lastScore;
            if (score > challengeScore) {
                return [NSString stringWithFormat:@"You scored %d. I got %d! Back at you!", challengeScore, score];
            }
            else if (score == challengeScore) {
                return [NSString stringWithFormat:@"Both of us got %d. Try to break the tie!", score];
            }
            else {
                return [NSString stringWithFormat:@"You scored %d. I got %d. Top my score in a new game!", challengeScore, score];
            }
            break;
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
            return [NSString stringWithFormat:@"I scored %d in Up Spell. Top that!", dossier.lastScore];
        }
        case UPShareTypeHighScore: {
            return [NSString stringWithFormat:@"My high score in Up Spell is %d. Top that!", dossier.highScore];
        }
        case UPShareTypeChallengeReply: {
            ASSERT(dossier.lastGameWasChallenge);
            int challengeScore = dossier.lastGameChallengeScore;
            int score = dossier.lastScore;
            if (score > challengeScore) {
                return [NSString stringWithFormat:@"I beat you in Up Spell %d to %d. Back at you!", score, challengeScore];
            }
            else if (score == challengeScore) {
                return [NSString stringWithFormat:@"We both scored %d in Up Spell. Try to break the tie!", score];
            }
            else {
                return [NSString stringWithFormat:@"You beat me in Up Spell %d to %d. Top my score in a new game!", challengeScore, score];
            }
            break;
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
    UPActivityViewItemSource *itemSource = [[UPActivityViewItemSource alloc] initWithShareType:shareType];
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
