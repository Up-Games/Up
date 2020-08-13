//
//  UPRandom.h
//  Copyright © 2020 Up Games. All rights reserved.
//

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
    Random() {
        std::uniform_int_distribution<int> dist(0, 511);
        std::random_device rd;
        seed({ dist(rd), dist(rd), dist(rd) });
    }
    Random(std::seed_seq sseq) : m_generator(sseq) {}

    Random(Random &&) = delete;
    Random(Random const &) = delete;
    void operator=(Random const &) = delete;

    static Random &instance();

    std::mt19937 &generator() { return m_generator; }

    void seed(std::seed_seq sseq) {
        m_generator.seed(sseq);
    }
    
    void seed_value(uint32_t value) {
        m_generator.seed(value);
    }

    uint32_t uint_32() {
        return m_generator();
    }

    uint8_t byte() {
        std::uniform_int_distribution<uint8_t> dis(0, std::numeric_limits<uint8_t>::max() - 1);
        return dis(m_generator);
    }
    
    uint32_t uint32_less_than(uint32_t bound) {
        std::uniform_int_distribution<uint32_t> dis(0, bound - 1);
        return dis(m_generator);
    }

    uint32_t uint32_between(uint32_t gte_lo, uint32_t lt_hi) {
        if (gte_lo >= lt_hi) {
            return gte_lo;
        }
        std::uniform_int_distribution<uint32_t> dis(gte_lo, lt_hi - 1);
        return dis(m_generator);
    }

    uint32_t uint32_in_range(uint32_t gte_lo, uint32_t lte_hi) {
        if (gte_lo >= lte_hi) {
            return gte_lo;
        }
        std::uniform_int_distribution<uint32_t> dis(gte_lo, lte_hi);
        return dis(m_generator);
    }

    float unit() {
        std::uniform_real_distribution<float> dis(0.0, 1.0);
        return dis(m_generator);
    }

private:
    std::mt19937 m_generator;
};

} // namescape UP

#endif  // __cplusplus
