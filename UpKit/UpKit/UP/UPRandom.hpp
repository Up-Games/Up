//
//  UPRandom.hpp
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_RANDOM_HPP
#define UP_RANDOM_HPP

#if __cplusplus

#import <iterator>
#import <limits>
#import <mutex>
#import <random>
#import <sstream>

#import <iostream>

namespace UP {

class Random {
public:
    Random() {}
    Random(std::seed_seq sseq) : m_g(sseq) {}

    static Random &gameplay_instance() {
        static Random r;
        return r;
    }

    static Random &general_instance() {
        static Random r;
        static std::once_flag flag1;
        std::call_once(flag1, [](){
            std::uniform_int_distribution<int> dist(0, 511);
            std::random_device rd;
            r.seed({ dist(rd), dist(rd), dist(rd) });
        });
        return r;
    }

    std::mt19937 &g() { return m_g; }

    void seed(std::seed_seq sseq) {
        m_g.seed(sseq);
    }
    
    void seed_value(uint32_t value) {
        m_g.seed(value);
    }

    uint32_t uint_32() {
        return m_g();
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
    std::mt19937 m_g;
};

} // namescape UP

#endif  // __cplusplus

#endif // UP_RANDOM_HPP
