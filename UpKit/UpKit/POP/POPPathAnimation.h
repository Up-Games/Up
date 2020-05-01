//
//  POPPathAnimation.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIBezierPath.h>
#import <UpKit/POPCustomAnimation.h>
#import <UpKit/UPTypes.h>

@interface POPPathAnimation : POPCustomAnimation

@property (nonatomic) UIBezierPath *fromPath;
@property (nonatomic) UIBezierPath *toPath;
@property (nonatomic, readonly) UIBezierPath *interpolatedPath;

+ (instancetype)animation;

- (BOOL)advanceWithTarget:(id)target;
- (void)computeInterpolatedPathWithFraction:(UPUnit)fraction;

/**
 @abstract The duration in seconds. Defaults to 0.4.
 */
@property (assign, nonatomic) CFTimeInterval duration;

@end


@interface POPPathAnimationDelegate : NSObject
- (void)pathAnimationUpdated:(POPPathAnimation *)animation;
@end
