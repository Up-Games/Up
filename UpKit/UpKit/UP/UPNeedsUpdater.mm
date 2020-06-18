//
//  UPNeedsUpdater.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>

#import "UPAssertions.h"
#import "UPNeedsUpdater.h"

@interface UPNeedsUpdater ()
{
    std::multimap<NSUInteger, __strong NSObject<UPNeedsUpdatable> *> m_map;
}
@end

@implementation UPNeedsUpdater

+ (UPNeedsUpdater *)instance
{
    static dispatch_once_t onceToken;
    static UPNeedsUpdater *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPNeedsUpdater alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    self = [super init];

    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeWaiting, YES, 0,
                                                                       ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (self->m_map.size()) {
            std::multimap<NSUInteger, __strong NSObject<UPNeedsUpdatable> *> update_map;
            update_map.swap(self->m_map);
            for (const auto &it : update_map) {
                NSObject<UPNeedsUpdatable> *updatable = it.second;
                [updatable update];
            }
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);

    return self;
}

- (void)setNeedsUpdate:(NSObject<UPNeedsUpdatable> *)needsUpdatable
{
    [self setNeedsUpdate:needsUpdatable order:UPNeedsUpdaterOrderFirst];
}

- (void)setNeedsUpdate:(NSObject<UPNeedsUpdatable> *)needsUpdatable order:(NSUInteger)order
{
    m_map.emplace(order, needsUpdatable);
}

@end
