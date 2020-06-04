//
//  UPViewTo.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIView.h>

#import <UpKit/UPMacros.h>

@interface UPViewTo : NSObject
@property (nonatomic, readonly) UIView *view;
@property (nonatomic, readonly) CGPoint beginning;
@property (nonatomic, readonly) CGPoint destination;

+ (UPViewTo *)view:(UIView *)view destination:(CGPoint)destination;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithView:(UIView *)view destination:(CGPoint)destination;

@end

UP_STATIC_INLINE UPViewTo *UPViewToMake(UIView *view, CGPoint destination) {
    return [UPViewTo view:view destination:destination];
}
