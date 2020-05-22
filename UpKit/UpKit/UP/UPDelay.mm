//
//  UPDelay.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <mutex>
#import <unordered_map>

#import "UPAssertions.h"
#import "UPDelay.h"
#import "UPMath.h"

namespace UP {

static std::unordered_map<uint32_t, DelayToken> g_token_map;
static std::mutex g_mutex;

DelayToken delay(const std::string &tag, dispatch_time_t when, dispatch_queue_t queue, void (^block)(void))
{
    DelayToken token(tag);
    g_mutex.lock();
    ASSERT(g_token_map.find(token.serial_number()) == g_token_map.end());
    g_token_map.emplace(token.serial_number(), token);
    g_mutex.unlock();
    dispatch_after(when, queue, ^{
        g_mutex.lock();
        size_t erased = g_token_map.erase(token.serial_number());
        g_mutex.unlock();
        if (erased == 0) {
            LOG(General, "not running canceled: %d", token.serial_number());
        }
        else if (erased && block) {
            block();
        }
    });
    return token;
}

DelayToken delay(double interval_in_seconds, void (^block)(void))
{
    return delay("<default>", interval_in_seconds, block);
}

DelayToken delay(const std::string &tag, double interval_in_seconds, void (^block)(void))
{
    double interval = UPMaxT(double, interval_in_seconds, 0.0);
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(interval * NSEC_PER_SEC));
    return delay(tag, when, dispatch_get_main_queue(), block);
}

void cancel_delayed(const DelayToken &token)
{
    std::lock_guard<std::mutex> guard(g_mutex);
    g_token_map.erase(token.serial_number());
}

void cancel_delayed(const std::string &tag)
{
    std::lock_guard<std::mutex> guard(g_mutex);
    for (auto it = g_token_map.begin(); it != g_token_map.end();) {
        if (tag == it->second.tag()) {
            it = g_token_map.erase(it);
        }
        else {
            ++it;
        }
    }
}

void cancel_all_delayed()
{
    std::lock_guard<std::mutex> guard(g_mutex);
    g_token_map.clear();
}

}  // namespace UP
