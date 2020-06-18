//
//  UPButton.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPButton.h"
#import "UPTapGestureRecognizer.h"

@interface UPButton ()
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPButton

+ (UPButton *)button
{
    return [[UPButton alloc] initWithTarget:nil action:nullptr];
}

+ (UPButton *)buttonWithTarget:(id)target action:(SEL)action
{
    return [[UPButton alloc] initWithTarget:target action:action];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    self.target = target;
    self.action = action;
    [self addGestureRecognizer:[UPTapGestureRecognizer gestureWithTarget:self action:@selector(handleTap:)]];
    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)handleTap:(UPTapGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible: {
            break;
        }
        case UIGestureRecognizerStateBegan: {
            if (self.autoHighlights) {
                self.highlighted = gesture.touchInside;
            }
            if (self.autoSelects) {
                self.selected = gesture.touchInside;
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.autoHighlights) {
                self.highlighted = gesture.touchInside;
            }
            if (self.autoSelects) {
                self.selected = gesture.touchInside;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.autoHighlights) {
                self.highlighted = NO;
            }
            if (self.autoSelects) {
                self.selected = gesture.touchInside;
            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([self.target respondsToSelector:self.action]) {
                if ([NSStringFromSelector(self.action) hasSuffix:@":"]) {
                    [self.target performSelector:self.action withObject:self];
                }
                else {
                    [self.target performSelector:self.action];
                }
            }
            else {
                LOG(General, "Target does not respond to selector: %@ : %@", self.target, NSStringFromSelector(self.action));
            }
#pragma clang diagnostic pop
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (self.autoHighlights) {
                self.highlighted = NO;
            }
            if (self.autoSelects) {
                self.selected = NO;
            }
            break;
        }
    }
}

@end


