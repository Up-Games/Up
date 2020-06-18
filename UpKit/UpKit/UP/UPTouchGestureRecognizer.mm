//
//  UPTouchGestureRecognizer.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPTouchGestureRecognizer.h"

@implementation UPTouchGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateRecognized;
}

@end
