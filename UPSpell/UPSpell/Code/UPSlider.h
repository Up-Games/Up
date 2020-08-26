//
//  UPSlider.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPControl.h>

@class UPSlideGestureRecognizer;

@interface UPSlider : UPControl

@property (nonatomic, readonly) BOOL discrete;
@property (nonatomic, readonly) NSUInteger marks;

@property (nonatomic, readonly) NSUInteger valueAsMark;
@property (nonatomic, readonly) CGFloat valueAsFraction;

@property (nonatomic, readonly) UPSlideGestureRecognizer *slideGesture;

+ (UPSlider *)discreteSliderWithMarks:(NSUInteger)marks;
+ (UPSlider *)continuousSliderWithMarks:(NSUInteger)marks;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)setTarget:(id)target action:(SEL)action;

- (void)setMarkValue:(NSUInteger)markValue;
- (void)setFractionValue:(CGFloat)fractionValue;

@end
