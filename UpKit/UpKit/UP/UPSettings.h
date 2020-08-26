//
//  UPSettings.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPSettings : NSObject

- (void)ensureDefaultValues;
- (void)resetDefaultValues;

// for subclasses
- (void)setDefaultValues;

@end
