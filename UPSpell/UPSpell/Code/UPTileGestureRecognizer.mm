//
//  UPTileGestureRecognizer.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPTapGestureRecognizer.h>

#import "UPTileGestureRecognizer.h"

@interface UPTileGestureRecognizer ()
@property (nonatomic, readwrite) BOOL touchInside;
@property (nonatomic, readwrite) CGPoint translation;
@property (nonatomic, readwrite) CGPoint velocity;
@property (nonatomic, readwrite) CGPoint startTouchPoint;
@property (nonatomic, readwrite) CGPoint touchPoint;
@property (nonatomic, readwrite) CGPoint previousTouchPoint;
@property (nonatomic, readwrite) CGPoint startPanPoint;
@property (nonatomic, readwrite) CGPoint panPoint;
@property (nonatomic, readwrite) CGFloat totalPanDistance;
@property (nonatomic, readwrite) CGFloat currentPanDistance;
@property (nonatomic, readwrite) CGFloat furthestPanDistance;
@property (nonatomic, readwrite) BOOL panEverMovedUp;
@property (nonatomic) CFTimeInterval previousNow;
@end

@implementation UPTileGestureRecognizer

+ (UPTileGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action
{
    return [[UPTileGestureRecognizer alloc] initWithTarget:target action:action];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ASSERT(self.view.userInteractionEnabled);
    
    if (!self.isEnabled) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPointInView = [touch locationInView:self.view];
    self.touchInside = [self.view pointInside:touchPointInView withEvent:event];
    
    self.touchPoint = [touch locationInView:self.view.window];
    self.startTouchPoint = self.touchPoint;
    self.translation = CGPointZero;
    
    self.velocity = CGPointZero;
    self.previousTouchPoint = self.touchPoint;
    self.previousNow = CACurrentMediaTime();

    CGPoint center = up_rect_center(self.view.bounds);
    CGFloat dx = center.x - touchPointInView.x;
    CGFloat dy = center.y - touchPointInView.y;
    CGPoint pointInSuperview = [self.view convertPoint:touchPointInView toView:self.view.superview];
    self.startPanPoint = CGPointMake(pointInSuperview.x + dx, pointInSuperview.y + dy);
    self.panPoint = self.startPanPoint;
    self.totalPanDistance = 0;
    self.furthestPanDistance = 0;
    self.panEverMovedUp = NO;

    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.isEnabled) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    self.touchInside = [self.view pointInside:[touch locationInView:self.view] withEvent:event];

    self.touchPoint = [touch locationInView:self.view.window];
    CGFloat tx = self.touchPoint.x - self.startTouchPoint.x;
    CGFloat ty = self.touchPoint.y - self.startTouchPoint.y;
    self.translation = CGPointMake(tx, ty);

    CGFloat dx = self.touchPoint.x - self.previousTouchPoint.x;
    CGFloat dy = self.touchPoint.y - self.previousTouchPoint.y;

    self.panPoint = CGPointMake(self.startPanPoint.x + tx, self.startPanPoint.y + ty);
    self.totalPanDistance += up_point_distance(self.touchPoint, self.previousTouchPoint);
    self.currentPanDistance = up_point_distance(self.touchPoint, self.startTouchPoint);
    self.furthestPanDistance = UPMaxT(CGFloat, self.furthestPanDistance, self.currentPanDistance);

    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval elapsed = now - self.previousNow;
    CGFloat vx = dx / elapsed;
    CGFloat vy = dy / elapsed;
    CGFloat avx = (self.velocity.x * 0.6) + (vx * 0.4);
    CGFloat avy = (self.velocity.y * 0.6) + (vy * 0.4);
    self.velocity = CGPointMake(avx, avy);
    self.previousTouchPoint = self.touchPoint;
    self.previousNow = now;

    self.panEverMovedUp = self.panEverMovedUp || avy < 0;

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

- (void)handlePreemption
{
    LOG(General, "handlePreemption: %@", self);
    if (!self.isEnabled || !self.touchInside) {
        self.state = UIGestureRecognizerStateFailed;
    }
    else {
        self.state = UIGestureRecognizerStateEnded;
    }
}

@end
