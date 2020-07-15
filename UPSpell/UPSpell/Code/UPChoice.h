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
@property (nonatomic) BOOL variableWidth;

+ (UPChoice *)choiceWithSide:(UPChoiceSide)side;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

@end
