//
//  UPCheckbox.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPControl.h>

typedef NS_ENUM(NSInteger, UPBallotType) {
    UPBallotTypeDefault,
    UPBallotTypeCheckbox,
    UPBallotTypeRadioButton,
};

@interface UPBallot : UPControl

@property (nonatomic, readonly) UPBallotType type;

+ (UPBallot *)ballotWithType:(UPBallotType)type;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
