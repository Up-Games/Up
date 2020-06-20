//
//  UPViewMove.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIView.h>

#import <UpKit/UPMacros.h>

@interface UPViewMove : NSObject
@property (nonatomic, readonly) UIView *view;
@property (nonatomic, readonly) CGPoint beginning;
@property (nonatomic) CGPoint destination;

+ (UPViewMove *)view:(UIView *)view beginning:(CGPoint)beginning destination:(CGPoint)destination;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithView:(UIView *)view beginning:(CGPoint)beginning destination:(CGPoint)destination;

@end

UP_STATIC_INLINE UPViewMove *UPViewMoveMake(UIView *view, CGPoint destination) {
    return [UPViewMove view:view beginning:view.center destination:destination];
}
