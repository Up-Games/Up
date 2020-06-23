//
//  UPHueIndicator.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPHueStepperIndicator : UIView

+ (UPHueStepperIndicator *)hueIndicator;

@property (nonatomic) CGFloat hue;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
