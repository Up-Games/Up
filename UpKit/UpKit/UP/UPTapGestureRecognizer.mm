//
//  UPTapGestureRecognizer.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPTapGestureRecognizer.h>

@interface UPTapGestureRecognizer ()
@property (nonatomic, readwrite) BOOL touchInside;
@end

@implementation UPTapGestureRecognizer

+ (UPTapGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action
{
    return [[UPTapGestureRecognizer alloc] initWithTarget:target action:action];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ASSERT(self.view.userInteractionEnabled);
    
    if (!self.isEnabled) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.touchInside = [self.view pointInside:[touch locationInView:self.view] withEvent:event];
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isEnabled) {
        return;
    }

    UITouch *touch = [touches anyObject];
    self.touchInside = [self.view pointInside:[touch locationInView:self.view] withEvent:event];
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isEnabled) {
        return;
    }

    UITouch *touch = [touches anyObject];
    self.touchInside = [self.view pointInside:[touch locationInView:self.view] withEvent:event];
    self.state = self.touchInside ? UIGestureRecognizerStateEnded : UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateCancelled;
}

@end
