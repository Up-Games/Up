//
//  UPHueWheel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPHueWheelDelegate;

@interface UPHueWheel : UIView

@property (nonatomic) CGFloat hue;
@property (nonatomic, weak) NSObject<UPHueWheelDelegate> *delegate;

+ (UPHueWheel *)hueWheel;

- (void)cancelAnimations;

@end

@protocol UPHueWheelDelegate <NSObject>
- (void)hueWheelDidUpdate:(UPHueWheel *)hueWheel;
- (void)hueWheelFinishedUpdating:(UPHueWheel *)hueWheel;
@end

