//
//  UPHueWheel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPControl.h>

@protocol UPHueWheelDelegate;

@interface UPHueWheel : UPControl

@property (nonatomic) CGFloat hue;
@property (nonatomic, weak) NSObject<UPHueWheelDelegate> *delegate;

+ (UPHueWheel *)hueWheel;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)cancelAnimations;

@end

@protocol UPHueWheelDelegate <NSObject>
- (void)hueWheelDidUpdate:(UPHueWheel *)hueWheel;
- (void)hueWheelFinishedUpdating:(UPHueWheel *)hueWheel;
@end

