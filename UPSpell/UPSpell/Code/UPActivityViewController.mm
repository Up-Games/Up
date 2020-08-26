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
    return [self shareURL];
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
        case UPShareTypeLastGameScore:
            gameKey = [UPGameKey gameKeyWithValue:dossier.lastGameKeyValue];
            score = dossier.lastScore;
            break;
        case UPShareTypeHighScore:
            gameKey = [UPGameKey gameKeyWithValue:dossier.highScoreGameKeyValue];
            score = dossier.highScore;
            break;
    }
    
    UPChallenge *challenge = [UPChallenge challengeWithGameKey:gameKey score:score];
    return challenge.URL;
}

- (NSString *)_makeShareString
{
    UPSpellDossier *dossier = [UPSpellDossier instance];
    int score = 0;
    switch (self.shareType) {
        case UPShareTypeDefault:
        case UPShareTypeLastGameScore:
            score = dossier.lastScore;
            break;
            break;
        case UPShareTypeHighScore:
            score = dossier.highScore;
            break;
    }
    return [NSString stringWithFormat:@"I scored %d in Up Spell. Top that!", score];
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
        UIActivityTypeOpenInIBooks
    ];

    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
