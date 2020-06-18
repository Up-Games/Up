//
//  UPTouchGestureRecognizer.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPTouchGestureRecognizer.h"

@implementation UPTouchGestureRecognizer

+ (UPTouchGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action
{
    return [[UPTouchGestureRecognizer alloc] initWithTarget:target action:action];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateRecognized;
}

@end
