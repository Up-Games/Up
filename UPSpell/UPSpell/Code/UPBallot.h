//
//  UPCheckbox.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPControl.h>

typedef NS_ENUM(NSInteger, UPBallotType) {
    UPBallotTypeDefault,
    UPBallotTypeCheck,
    UPBallotTypeRadio,
};

@interface UPBallot : UPControl

@property (nonatomic, readonly) UPBallotType type;

+ (UPBallot *)ballotWithType:(UPBallotType)type;
+ (UPBallot *)ballotWithType:(UPBallotType)type target:(id)target action:(SEL)action;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
