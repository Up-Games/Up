//
//  UPControl.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPControl.h"

@interface UPControl ()
@property (nonatomic) UIControlState additionalState;
@end

@implementation UPControl

- (UIControlState)state
{
    return super.state | self.additionalState;
}

- (void)setNormal
{
    [super setEnabled:YES];
    [super setSelected:NO];
    [super setHighlighted:NO];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setHighlighted
{
    [super setEnabled:YES];
    [super setSelected:NO];
    [super setHighlighted:YES];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setDisabled
{
    [super setEnabled:NO];
    [super setSelected:NO];
    [super setHighlighted:NO];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setSelected
{
    [super setEnabled:YES];
    [super setSelected:YES];
    [super setHighlighted:NO];
    self.additionalState = 0;
    [self _controlStateChanged];
}

- (void)setActive
{
    [super setEnabled:YES];
    [super setSelected:NO];
    [super setHighlighted:NO];
    [self setActive:YES];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self _controlStateChanged];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self _controlStateChanged];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self _controlStateChanged];
}

- (void)setActive:(BOOL)active
{
    if (active) {
        self.additionalState |= UPControlStateActive;
    }
    else {
        self.additionalState &= ~UPControlStateActive;
    }
    [self _controlStateChanged];
}

- (void)_controlStateChanged
{
    [self setNeedsLayout];
    [self updateControl];
}

- (void)updateControl
{
    // override point
}

@end
