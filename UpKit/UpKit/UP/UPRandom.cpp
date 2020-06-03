//
//  UPRandom.cpp
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <dispatch/dispatch.h>

#if __cplusplus

#import <UpKit/UPAssertions.h>

#import "UPRandom.h"

namespace UP {

UP_NEVER_INLINE Random &Random::instance() {
    static dispatch_once_t once_token;
    static Random *g_instance;
    dispatch_once(&once_token, ^{
        std::uniform_int_distribution<int> dist(0, 511);
        std::random_device rd;
        g_instance = new Random({ dist(rd), dist(rd), dist(rd) });
    });
    return *g_instance;
}

}  // namespace UP

#endif  // __cplusplus
