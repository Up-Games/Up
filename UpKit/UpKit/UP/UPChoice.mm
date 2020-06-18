//
//  UPChoice.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPChoice.h"

#import "UPTouchGestureRecognizer.h"

@interface UPChoice ()
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPChoice

+ (UPChoice *)choice
{
    return [[UPChoice alloc] initWithTarget:nil action:nullptr];
}

+ (UPChoice *)choiceWithTarget:(id)target action:(SEL)action
{
    return [[UPChoice alloc] initWithTarget:target action:action];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    self.target = target;
    self.action = action;
    [self addGestureRecognizer:[UPTouchGestureRecognizer gestureWithTarget:self action:@selector(handleTouch:)]];
    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)handleTouch:(UPTouchGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    [self setSelected];
    
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
}

@end
