//
//  UPMath.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_MATH_H
#define UP_MATH_H

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

#define UPClampUnitZeroToOne(_x) ({ \
    UPClampT(UPUnit, (_x), UPUnitZero, UPUnitOne); \
})

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

UP_STATIC_CONST UPUnit UPUnitRecip255 = 1.0 / 255.0;
UP_STATIC_CONST UPUnit up_from_255(uint8_t _u) { return _u * UPUnitRecip255; }
UP_STATIC_CONST uint8_t up_to_255(UPUnit _u) { return _u * 255; }

UP_STATIC_CONST UPFloat RAD2DEG = 180.0 / M_PI;
UP_STATIC_CONST UPFloat DEG2RAD = M_PI / 180.0;


#if __APPLE__

#import <CoreGraphics/CoreGraphics.h>

UP_STATIC_INLINE double up_lerp_doubles(double a, double b, UPUnit f)
{
    return a + ((b - a) * f);
}

UP_STATIC_INLINE CGPoint up_lerp_points(CGPoint a, CGPoint b, UPUnit f)
{
    return CGPointMake(a.x + ((b.x - a.x) * f), a.y + ((b.y - a.y) * f));
}

UP_STATIC_INLINE CGSize up_lerp_sizes(CGSize a, CGSize b, UPUnit f)
{
    return CGSizeMake(a.width + ((b.width - a.width) * f), a.height + ((b.height - a.height) * f));
}

UP_STATIC_INLINE CGRect up_lerp_rects(CGRect a, CGRect b, UPUnit f)
{
    CGPoint p = up_lerp_points(a.origin, b.origin, f);
    CGSize s = up_lerp_sizes(a.size, b.size, f);
    return CGRectMake(p.x, p.y, s.width, s.height);
}

UP_STATIC_INLINE CGAffineTransform up_lerp_transforms(CGAffineTransform a, CGAffineTransform b, UPUnit f)
{
    CGFloat fa = a.a + ((b.a - a.a) * f);
    CGFloat fb = a.b + ((b.b - a.b) * f);
    CGFloat fc = a.c + ((b.c - a.c) * f);
    CGFloat fd = a.d + ((b.d - a.d) * f);
    CGFloat ftx = a.tx + ((b.tx - a.tx) * f);
    CGFloat fty = a.ty + ((b.ty - a.ty) * f);
    return CGAffineTransformMake(fa, fb, fc, fd, ftx, fty);
}

#endif  // __APPLE__

#endif  // UP_MATH_H
