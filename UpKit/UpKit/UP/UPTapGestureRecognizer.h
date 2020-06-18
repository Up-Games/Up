//
//  UPTapGestureRecognizer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPGestureRecognizer.h>

@interface UPTapGestureRecognizer : UPGestureRecognizer
@property (nonatomic, readonly) BOOL touchInside;

+ (UPTapGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action;

@end
