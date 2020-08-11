//
//  UPDialogTaunt.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPButton;
@class UPLabel;
@class UPTaunt;

@interface UPDialogTaunt : UIView

@property (nonatomic, readonly) UPLabel *tauntLabel;
@property (nonatomic, readonly) UPLabel *scoreToBeatLabel;
@property (nonatomic, readonly) UPButton *cancelButton;
@property (nonatomic, readonly) UPButton *goButton;
@property (nonatomic, readonly) UPButton *helpButton;

+ (UPDialogTaunt *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)updateWithTaunt:(UPTaunt *)taunt;

@end
