//
//  UPGestureRecognizer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPGestureRecognizer : UIGestureRecognizer

- (void)preempt;
- (void)handlePreemption; // for subclasses

@end
