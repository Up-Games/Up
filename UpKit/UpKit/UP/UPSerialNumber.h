//
//  UPSerialNumber.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#if __cplusplus

#import <atomic>
#import <limits>

namespace UP {

static constexpr uint32_t NotASerialNumber = std::numeric_limits<uint32_t>::max();

UP_STATIC_INLINE uint32_t next_serial_number() {
    static std::atomic_uint32_t g_counter;
    return ++g_counter;
}

}  // namespace UP

#endif  // __cplusplus
