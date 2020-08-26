//
//  UPNeedsUpdater.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UpKit/UPMacros.h>

@protocol UPNeedsUpdatable <NSObject>
- (void)update;
@end

typedef NS_ENUM(NSInteger, UPNeedsUpdaterOrder) {
    UPNeedsUpdaterOrderFirst =  0,
    UPNeedsUpdaterOrderSecond = 1,
};

@interface UPNeedsUpdater : NSObject

+ (UPNeedsUpdater *)instance;

- (instancetype)init NS_UNAVAILABLE;

- (void)setNeedsUpdate:(NSObject<UPNeedsUpdatable> *)needsUpdatable;
- (void)setNeedsUpdate:(NSObject<UPNeedsUpdatable> *)needsUpdatable order:(NSUInteger)order;

@end
