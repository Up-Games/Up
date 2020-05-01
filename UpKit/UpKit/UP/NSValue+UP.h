//
//  NSValue+UP.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UpKit/UPGeometry.h>

@interface NSValue (UP)

+ (NSValue *)valueWithQuadOffsets:(UPQuadOffsets)quadOffsets;
- (UPQuadOffsets)quadOffsetsValue;

@end
