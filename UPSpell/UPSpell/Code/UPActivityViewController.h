//
//  UPActivityViewController.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPShareType) {
    UPShareTypeDefault,
    UPShareTypeLastGameScore,
    UPShareTypeHighScore,
    UPShareTypeChallengeReply,
    UPShareTypeDuel,
    UPShareTypeDuelReply,
};

@class UPGameKey;

@interface UPActivityViewController : UIActivityViewController

- (instancetype)initWithShareType:(UPShareType)shareType;
- (instancetype)initWithShareType:(UPShareType)shareType gameKey:(UPGameKey *)gameKey;

- (instancetype)initWithActivityItems:(NSArray *)activityItems NS_UNAVAILABLE;

@end
