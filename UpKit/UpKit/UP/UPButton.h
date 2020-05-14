//
//  UPButton.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>

@interface UPButton : UPControl

@property (nonatomic) CGSize canonicalSize;

+ (UPButton *)button;

- (void)setFillPath:(UIBezierPath *)path;
- (void)setFillPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;
- (void)setStrokePath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;
- (void)setBackgroundFillPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;
- (void)setBackgroundStrokePath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;

@end
