//
//  UPSerialNumber.cpp
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#if __cplusplus

#import <UpKit/UPAssertions.h>

#import "UPSerialNumber.h"

namespace UP {

UP_NEVER_INLINE uint32_t next_serial_number() {
    static std::atomic_uint32_t g_counter;
    return ++g_counter;
}

}  // namespace UP

#endif  // __cplusplus
