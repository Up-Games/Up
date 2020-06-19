//
//  UPTileGestureRecognizer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPGestureRecognizer.h>

@interface UPTileGestureRecognizer : UPGestureRecognizer
@property (nonatomic, readonly) BOOL touchInside;
@property (nonatomic, readonly) CGPoint startTouchPoint;     // in window coordinates
@property (nonatomic, readonly) CGPoint touchPoint;          // in window coordinates
@property (nonatomic, readonly) CGPoint previousTouchPoint;  // in window coordinates
@property (nonatomic, readonly) CGPoint translation;         // as a point representing total distance
@property (nonatomic, readonly) CGPoint velocity;            // as a point representing points/second
@property (nonatomic, readonly) CGPoint startPanPoint;       // in superview coordinates
@property (nonatomic, readonly) CGPoint panPoint;            // in superview coordinates
@property (nonatomic, readonly) CGFloat currentPanDistance;
@property (nonatomic, readonly) CGFloat totalPanDistance;
@property (nonatomic, readonly) CGFloat furthestPanDistance;
@property (nonatomic, readonly) BOOL panEverMovedUp;
@end
