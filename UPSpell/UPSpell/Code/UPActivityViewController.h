//
//  UPActivityViewController.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPShareType) {
    UPShareTypeDefault,
    UPShareTypeLastGameScore,
    UPShareTypeHighScore,
};

@interface UPActivityViewController : UIActivityViewController

- (instancetype)initWithShareType:(UPShareType)shareType;

- (instancetype)initWithActivityItems:(NSArray *)activityItems NS_UNAVAILABLE;

@end
