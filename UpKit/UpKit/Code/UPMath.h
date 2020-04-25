//
//  UPMath.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_MATH_H
#define UP_MATH_H

#import <math.h>
#import <stdbool.h>

#import <UpKit/UPTypes.h>
#import <UpKit/UPConstants.h>

static inline bool is_fuzzy_equal_with_epsilon(Float fuzzy, Float solid, Float epsilon)
{
    return fabs(fuzzy - solid) < epsilon;
}

static inline bool is_fuzzy_equal(Float fuzzy, Float solid)
{
    return is_fuzzy_equal_with_epsilon(fuzzy, solid, UPEpsilon);
}

static inline bool is_fuzzy_zero(Float num)
{
    return is_fuzzy_equal(num, 0.0);
}

static inline bool is_fuzzy_one(Float num)
{
    return is_fuzzy_equal(num, 1.0);
}

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
    _type __z = (_x); \
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
    _type __z = (_x); \
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

#endif  // UP_MATH_H
