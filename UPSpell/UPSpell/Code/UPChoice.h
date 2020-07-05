//
//  UPChoice.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPControl.h>

typedef NS_ENUM(NSInteger, UPChoiceSide) {
    UPChoiceSideDefault,
    UPChoiceSideLeft,
    UPChoiceSideRight,
};

@interface UPChoice : UPControl

@property (nonatomic, readonly) UPChoiceSide side;

+ (UPChoice *)choiceWithSide:(UPChoiceSide)side;
+ (UPChoice *)choiceWithSide:(UPChoiceSide)side target:(id)target action:(SEL)action;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
