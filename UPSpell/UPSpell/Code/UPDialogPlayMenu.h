//
//  UPDialogPlayMenu.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UpKit.h>

@class UPButton;
@class UPChoice;
@class UPPlacard;

@interface UPDialogPlayMenu : UPContainerView

@property (nonatomic, readonly) UPButton *backButton;
@property (nonatomic, readonly) UPButton *goButton;
@property (nonatomic, readonly) UPChoice *choice1;
@property (nonatomic, readonly) UPChoice *choice2;
@property (nonatomic, readonly) UPChoice *choice3;
@property (nonatomic, readonly) NSArray<UPChoice *> *choices;

+ (UPDialogPlayMenu *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
