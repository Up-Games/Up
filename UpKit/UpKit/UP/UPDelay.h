//
//  UPDelay.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <dispatch/dispatch.h>

#import <UPKit/UPMacros.h>

#if __cplusplus

#import <atomic>
#import <cstdint>
#import <functional>
#import <string>

namespace UP {

class DelayToken {
public:
    explicit DelayToken(const std::string &tag = "") : m_tag(tag), m_serial_number(++g_counter) {}

    std::string tag() const { return m_tag; }
    uint32_t serial_number() const { return m_serial_number; }
    
private:
    static inline std::atomic_uint32_t g_counter;
    std::string m_tag;
    uint32_t m_serial_number;
};

UP_STATIC_INLINE bool operator==(const DelayToken &a, const DelayToken &b) { return a.serial_number() == b.serial_number(); }
UP_STATIC_INLINE bool operator!=(const DelayToken &a, const DelayToken &b) { return !(a == b); }
UP_STATIC_INLINE bool operator<(const DelayToken &a, const DelayToken &b) { return a.serial_number() < b.serial_number(); }

DelayToken delay(dispatch_time_t when, dispatch_queue_t queue, void (^block)(void));
DelayToken delay(double interval_in_seconds, void (^block)(void));
DelayToken delay(const std::string &tag, double interval_in_seconds, void (^block)(void));
void cancel_delayed(const DelayToken &);
void cancel_delayed(const std::string &tag);
void cancel_all_delayed();

}  // namespace UP

#endif  // __cplusplus
