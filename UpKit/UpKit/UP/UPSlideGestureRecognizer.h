//
//  UPSlideGestureRecognizer.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPGestureRecognizer.h>

@interface UPSlideGestureRecognizer : UPGestureRecognizer

@property (nonatomic, readonly) CGPoint locationInView;
@property (nonatomic, readonly) CGPoint translationInView;

+ (UPSlideGestureRecognizer *)gestureWithTarget:(id)target action:(SEL)action;

@end
