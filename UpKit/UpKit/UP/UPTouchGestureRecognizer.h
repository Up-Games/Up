//
//  UPTouchGestureRecognizer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

@interface UPTouchGestureRecognizer : UPGestureRecognizer

+ (UPTouchGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action;

@end
