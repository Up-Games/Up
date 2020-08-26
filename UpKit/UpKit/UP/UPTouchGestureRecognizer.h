//
//  UPTouchGestureRecognizer.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UpKit.h>

@interface UPTouchGestureRecognizer : UPGestureRecognizer

+ (UPTouchGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action;

@end
