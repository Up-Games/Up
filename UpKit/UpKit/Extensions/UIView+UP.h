//
//  UIView+UPLayout.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPTypes.h>

@interface UPViewState : NSObject
@property (nonatomic) CGRect frame;
@property (nonatomic) UIColor *backgroundColor;
@end

@interface UIView (UP)

// layout
@property (nonatomic) UPLayoutRule *layoutRule;
+ (UIView *)viewWithBoundsSize:(CGSize)boundsSize;
- (instancetype)initWithBoundsSize:(CGSize)boundsSize;
- (void)layoutWithRule;

// animation
- (UPViewState *)currentState;
- (void)applyState:(UPViewState *)state;
- (void)applyInterpolatedWithStartState:(UPViewState *)startState endState:(UPViewState *)endState fraction:(UPUnit)fraction;

@end
