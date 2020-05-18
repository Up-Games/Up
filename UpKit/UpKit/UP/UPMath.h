//
//  UPMath.h
//  Copyright © 2020 Up Games. All rights reserved.
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
