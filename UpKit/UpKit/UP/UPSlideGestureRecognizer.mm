//
//  UPSlideGestureRecognizer.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UPSlideGestureRecognizer.h>

@interface UPSlideGestureRecognizer ()
@property (nonatomic, readwrite) CGPoint locationInView;
@property (nonatomic, readwrite) CGPoint translationInView;
@property (nonatomic) CGPoint startLocation;
@end

@implementation UPSlideGestureRecognizer

+ (UPSlideGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action
{
    return [[UPSlideGestureRecognizer alloc] initWithTarget:target action:action];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ASSERT(self.view.userInteractionEnabled);
    
    if (!self.isEnabled) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.startLocation = [touch locationInView:self.view];
    self.locationInView = [touch locationInView:self.view];
    self.translationInView = CGPointZero;
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isEnabled) {
        if (self.state != UIGestureRecognizerStateCancelled) {
            self.state = UIGestureRecognizerStateCancelled;
        }
        return;
    }

    UITouch *touch = [touches anyObject];
    self.locationInView = [touch locationInView:self.view];
    self.translationInView = CGPointMake(self.locationInView.x - self.startLocation.x, self.locationInView.y - self.startLocation.y);
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isEnabled) {
        if (self.state != UIGestureRecognizerStateCancelled) {
            self.state = UIGestureRecognizerStateCancelled;
        }
        return;
    }

    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateCancelled;
}

@end
