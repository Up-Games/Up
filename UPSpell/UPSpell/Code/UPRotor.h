//
//  UPRotor.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

@interface UPRotor : UPControl

@property (nonatomic, readonly) NSArray<NSString *> *elements;
@property (nonatomic, readonly) NSString *selectedString;
@property (nonatomic, readonly) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL changing;

+ (UPRotor *)rotorWithElements:(NSArray<NSString *> *)elements;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

- (void)selectIndex:(NSUInteger)index;

@end
