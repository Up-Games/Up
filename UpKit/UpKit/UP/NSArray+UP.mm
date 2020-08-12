//
//  NSArray+UP.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "NSArray+UP.h"

#import "UPRandom.h"

@implementation NSArray (UP)

- (id)randomElement
{
    return self.count == 0 ? nil : self[UP::Random::instance().uint32_less_than((uint32_t)self.count)];
}

@end
