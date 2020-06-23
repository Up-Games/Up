//
//  UPHueStepperIndicator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPHueStepperIndicatorDelegate;

@interface UPHueStepperIndicator : UIView

+ (UPHueStepperIndicator *)hueStepperIndicator;

@property (nonatomic) CGFloat hue;
@property (nonatomic, weak) NSObject<UPHueStepperIndicatorDelegate> *delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

@protocol UPHueStepperIndicatorDelegate <NSObject>
- (void)hueStepperIndicatorDidUpdate:(UPHueStepperIndicator *)hueStepperIndicator;
@end

