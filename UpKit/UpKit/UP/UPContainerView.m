//
//  UPContainerView.m
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPContainerView.h"

@implementation UPContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView == self ? nil : hitView;
}

@end
