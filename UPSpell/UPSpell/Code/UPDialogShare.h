//
//  UPDialogShare.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;
@class UPChallenge;

@interface UPDialogShare : UIView

@property (nonatomic, readonly) UPVectorLogoView *vectorLogoView;
@property (nonatomic, readonly) UPLabel *wordMarkLabel;
@property (nonatomic, readonly) UPLabel *challengePromptLabel;
@property (nonatomic, readonly) UPLabel *scorePromptLabel;
@property (nonatomic, readonly) UPButton *cancelButton;
@property (nonatomic, readonly) UPButton *goButton;
@property (nonatomic, readonly) UPButton *helpButton;

+ (UPDialogShare *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)updateWithShare:(UPChallenge *)share;

@end
