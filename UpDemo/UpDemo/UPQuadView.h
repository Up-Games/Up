//
//  UPQuadView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UPKit/UPGeometry.h>

@interface UPQuadView : UIView
@property (nonatomic) UPQuadOffsets quadOffsets;
@property (nonatomic) UPQuad quad;
@property (nonatomic, readonly) UPQuad effectiveQuad;

- (void)newBloop;

@end
