//
//  UPRandom.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_RANDOM_H
#define UP_RANDOM_H

#if __cplusplus

#import <iterator>
#import <limits>
#import <memory>
#import <mutex>
#import <random>
#import <sstream>

#import <iostream>

namespace UP {

class Random {
public:
    Random() : m_generator(std::make_shared<std::mt19937>()) {}
    Random(std::seed_seq sseq) : m_generator(std::make_shared<std::mt19937>(sseq)) {}

    static Random &instance() {
        static Random r;
        static std::once_flag flag1;
        std::call_once(flag1, [](){
            std::uniform_int_distribution<int> dist(0, 511);
            std::random_device rd;
            r.seed({ dist(rd), dist(rd), dist(rd) });
        });
        return r;
    }

    std::shared_ptr<std::mt19937> generator() { return m_generator; }

    void seed(std::seed_seq sseq) {
        m_generator->seed(sseq);
    }
    
    void seed_value(uint32_t value) {
        m_generator->seed(value);
    }

    uint32_t uint_32() {
        return (*m_generator)();
    }

    uint32_t uint32_less_than(uint32_t bound) {
        return uint_32() % bound;
    }

    uint32_t uint32_between(uint32_t gte_lo, uint32_t lt_hi) {
        if (gte_lo >= lt_hi) {
            return gte_lo;
        }
        return (uint_32() % (lt_hi - gte_lo)) + gte_lo;
    }

    uint32_t uint32_in_range(uint32_t gte_lo, uint32_t lte_hi) {
        if (gte_lo >= lte_hi) {
            return gte_lo;
        }
        return (uint_32() % (lte_hi - gte_lo + 1)) + gte_lo;
    }

    float unit() {
        return (float)uint_32() / std::numeric_limits<uint32_t>::max();
    }

private:
    std::shared_ptr<std::mt19937> m_generator;
};

} // namescape UP

#endif  // __cplusplus

#endif // UP_RANDOM_H
