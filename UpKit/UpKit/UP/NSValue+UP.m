//
//  NSValue+UP.m
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "NSValue+UP.h"

@implementation NSValue (UP)

+ (NSValue *)valueWithQuadOffsets:(UPQuadOffsets)quadOffsets
{
    return [NSValue valueWithBytes:&quadOffsets objCType:@encode(UPQuadOffsets)];
}

- (UPQuadOffsets)quadOffsetsValue
{
    UPQuadOffsets result;
    [self getValue:&result];
    return result;
}

@end
