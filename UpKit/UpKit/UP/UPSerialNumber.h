//
//  UPSerialNumber.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#if __cplusplus

#import <UpKit/UPAssertions.h>

#import <atomic>
#import <limits>

namespace UP {

static constexpr uint32_t NotASerialNumber = std::numeric_limits<uint32_t>::max();

uint32_t next_serial_number();

}  // namespace UP

#endif  // __cplusplus
