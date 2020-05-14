//
//  UPButton.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPControl.h>

@interface UPButton : UPControl

@property (nonatomic) CGSize canonicalSize;

+ (UPButton *)button;

- (void)setContentPath:(UIBezierPath *)path;
- (void)setContentPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;

- (void)setFillPath:(UIBezierPath *)path;
- (void)setFillPath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;

- (void)setStrokePath:(UIBezierPath *)path;
- (void)setStrokePath:(UIBezierPath *)path forControlStates:(UIControlState)controlStates;

@end
