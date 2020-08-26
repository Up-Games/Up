//
//  UPMath.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <math.h>
#import <stdbool.h>

#import <UpKit/UPMacros.h>
#import <UpKit/UPTypes.h>
#import <UpKit/UPConstants.h>

#define UPMinT(_type, _x, _y) ({ \
    _type __x = (_x); \
    _type __y = (_y); \
    ((__x) < (__y)) ? (__x) : (__y); \
})

#define UPMaxT(_type, _x, _y) ({ \
    _type __x = (_x); \
    _type __y = (_y); \
    ((__x) > (__y)) ? (__x) : (__y); \
})

#define UPMultiMinT(_type, _x, ...) ({ \
    _type __elems[] = { (_x), __VA_ARGS__ }; \
    unsigned __count = sizeof(__elems) / sizeof(_type); \
    _type __z = __elems[0]; \
    for (unsigned _i = 1; _i < __count; _i++) { \
    if (__elems[_i] < __z) { \
    __z = __elems[_i]; \
    } \
    } \
    __z; \
})

#define UPMultiMaxT(_type, _x, ...) ({ \
    _type __elems[] = { (_x), __VA_ARGS__ }; \
    unsigned __count = sizeof(__elems) / sizeof(_type); \
    _type __z = __elems[0]; \
    for (unsigned _i = 1; _i < __count; _i++) { \
    if (__elems[_i] > __z) { \
    __z = __elems[_i]; \
    } \
    } \
    __z; \
})

#define UPClampT(_type, _x, _lo, _hi) ({ \
    _type __x = (_x); \
    _type __lo = (_lo); \
    _type __hi = (_hi); \
    _type __z = ((__x) < (__lo)) ? (__lo) : ((__x) > (__hi)) ? (__hi) : (__x); \
    __z; \
})

#define UPClampUnitZeroToOne(_x) ({ \
    UPClampT(UPUnit, (_x), UPUnitZero, UPUnitOne); \
})

#ifdef __cplusplus
extern "C" {
#endif

UP_STATIC_INLINE bool up_is_fuzzy_equal_with_epsilon(UPFloat fuzzy, UPFloat solid, UPFloat epsilon)
{
    return fabs(fuzzy - solid) < epsilon;
}

UP_STATIC_INLINE bool up_is_fuzzy_equal(UPFloat fuzzy, UPFloat solid)
{
    return up_is_fuzzy_equal_with_epsilon(fuzzy, solid, UPEpsilon);
}

UP_STATIC_INLINE bool up_is_fuzzy_zero(UPFloat num)
{
    return up_is_fuzzy_equal(num, UPFloatZero);
}

UP_STATIC_INLINE bool up_is_fuzzy_one(UPFloat num)
{
    return up_is_fuzzy_equal(num, UPFloatOne);
}

UP_STATIC_INLINE UPFloat up_lerp_floats(UPFloat a, UPFloat b, UPUnit f)
{
    return a + ((b - a) * f);
}

#ifdef __cplusplus
}  // extern "C"
#endif

// =========================================================================================================================================
// Hash goodness cribbed from Wolfgang Brehm: https://stackoverflow.com/a/50978188

#ifdef __cplusplus

#import <limits>
#import <cstdint>

namespace UP {

template <class T>
T xorshift(const T &n, int i) {
    return n^(n>>i);
}

UP_STATIC_INLINE uint64_t distribute(const uint64_t &n) {
    uint64_t p = 0x5555555555555555;     // pattern of alternating 0 and 1
    uint64_t c = 17316035218449499591ull;// random uneven integer constant;
    return c * xorshift(p * xorshift(n, 32), 32);
}

template <class T, class S>
typename std::enable_if_t<std::is_unsigned<T>::value, T>
constexpr rotl(const T n, const S i){
    const T m = (std::numeric_limits<T>::digits - 1);
    const T c = i & m;
    return (n << c) | (n >> ((T(0) - c) & m));
}

template <class T>
inline size_t hash_combine(std::size_t &seed, const T &v)
{
    return rotl(seed, std::numeric_limits<size_t>::digits / 3) ^ distribute(std::hash<T>{}(v));
}

}  // namespace UP

#endif  // __cplusplus
