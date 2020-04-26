//
//  UPUnitFunction.hpp
//  Copyright © 2020 Up Games. All rights reserved.
//

//
//  The following easing functions equations:
//  bounce, back, circ, elastic, expo, and sine, are:

//  Copyright © 2001 Robert Penner
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#ifndef UP_UNITFUNCTION_HPP
#define UP_UNITFUNCTION_HPP

#import <UpKit/UPTypes.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPUnitFunction.h>

namespace UP {

UPUnit unit_curve_value(UPUnit input_value, UPFloat exponent, UPUnit ease_factor);
UPUnit unchecked_unit_curve_value(UPUnit input_value, UPFloat exponent, UPUnit ease_factor);

class UPUnitFunction {
public:
    static constexpr UPFloat DefaultEaseExponent = UPFloatFour;
    static constexpr UPFloat c1 = 1.70158;
    static constexpr UPFloat c2 = c1 * 1.525;
    static constexpr UPFloat c3 = c1 + UPUnitOne;
    static constexpr UPFloat c4 = c2 + UPUnitOne;
    static constexpr UPFloat c5 = (UPUnitTwo * M_PI) / 3;
    static constexpr UPFloat c6 = (UPUnitTwo * M_PI) / 4.5;

    UPUnitFunction() {}
    UPUnitFunction(UPUnitFunctionType type);

    UPUnitFunctionType type() const { return m_type; }
    UPUnit value_for_t(UPUnit t) const { return m_fn(t); }
    
    static UPUnit linear_value_for_t(UPUnit t) { return t; }
    static UPUnit default_value_for_t(UPUnit t) { return linear_value_for_t(t); }
    
    static UPUnit ease_in_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, DefaultEaseExponent, UPUnitOne - UPEpsilon); }
    static UPUnit ease_out_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, DefaultEaseExponent, UPEpsilon); }
    static UPUnit ease_inout_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, DefaultEaseExponent, UPUnitHalf); }
    static UPUnit ease_in_quad_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, UPUnitTwo, UPUnitOne - UPEpsilon); }
    static UPUnit ease_out_quad_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, UPUnitTwo, UPEpsilon); }
    static UPUnit ease_inout_quad_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, UPUnitTwo, UPUnitHalf); }
    static UPUnit ease_in_cubic_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 3, UPUnitOne - UPEpsilon); }
    static UPUnit ease_out_cubic_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 3, UPEpsilon); }
    static UPUnit ease_inout_cubic_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 3, UPUnitHalf); }
    static UPUnit ease_in_quart_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 4, UPUnitOne - UPEpsilon); }
    static UPUnit ease_out_quart_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 4, UPEpsilon); }
    static UPUnit ease_inout_quart_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 4, UPUnitHalf); }
    static UPUnit ease_in_quint_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 5, UPUnitOne - UPEpsilon); }
    static UPUnit ease_out_quint_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 5, UPEpsilon); }
    static UPUnit ease_inout_quint_value_for_t(UPUnit t) { return unchecked_unit_curve_value(t, 5, UPUnitHalf); }
    static UPUnit bounce_in_value_for_t(UPUnit t) { return UPUnitOne - bounce_out(UPUnitOne - t); }
    static UPUnit bounce_out_value_for_t(UPUnit t) { return bounce_out(t); }
    static UPUnit bounce_inout_value_for_t(UPUnit t) {
        return t < UPUnitHalf ? (UPUnitOne - bounce_out(UPUnitOne - UPUnitTwo * t)) / UPUnitTwo : (UPUnitOne + bounce_out(UPUnitTwo * t - UPUnitOne )) / UPUnitTwo;
    }
    static UPUnit circ_in_value_for_t(UPUnit t) { return UPUnitOne - sqrtf(UPUnitOne - powf(t, UPUnitTwo)); }
    static UPUnit circ_out_value_for_t(UPUnit t) { return sqrtf(UPUnitOne - pow(t - UPUnitOne, UPUnitTwo)); }
    static UPUnit circ_inout_value_for_t(UPUnit t) {
        return t < UPUnitHalf ? (UPUnitOne - sqrtf(UPUnitOne - pow(UPUnitTwo * t, UPUnitTwo))) / UPUnitTwo : (sqrtf(UPUnitOne - pow(-UPUnitTwo * t + UPUnitTwo, UPUnitTwo)) + UPUnitOne) / UPUnitTwo;
    }
    static UPUnit back_in_value_for_t(UPUnit t) { return c3 * t * t * t - c1 * t * t; }
    static UPUnit back_out_value_for_t(UPUnit t) { return UPUnitOne + c3 * pow(t - UPUnitOne, 3) + c1 * pow(t - UPUnitOne, UPUnitTwo); }
    static UPUnit back_inout_value_for_t(UPUnit t) {
        return t < UPUnitHalf ? (powf(UPUnitTwo * t, UPUnitTwo) * ((c4) * UPUnitTwo * t - c2)) / UPUnitTwo : (powf(UPUnitTwo * t - UPUnitTwo, UPUnitTwo) * ((c4) * (t * UPUnitTwo - UPUnitTwo) + c2) + UPUnitTwo) / UPUnitTwo;
    }
    static UPUnit elastic_in_value_for_t(UPUnit t) { return t == UPUnitZero ? UPUnitZero : t == UPUnitOne ? UPUnitOne : -powf(UPUnitTwo, 10 * t - 10) * sinf((t * 10 - 10.75) * c5); }
    static UPUnit elastic_out_value_for_t(UPUnit t) { return t == UPUnitZero ? UPUnitZero : t == UPUnitOne ? UPUnitOne : powf(UPUnitTwo, -10 * t) * sinf((t * 10 - 0.75) * c5) + UPUnitOne; }
    static UPUnit elastic_inout_value_for_t(UPUnit t) {
        return t == UPUnitZero ? UPUnitZero : t == UPUnitOne ? UPUnitOne : t < UPUnitHalf ?
            -(powf(UPUnitTwo, 20 * t - 10) * sinf((20 * t - 11.125) * c6)) / UPUnitTwo :
                powf(UPUnitTwo, -20 * t + 10) * sinf((20 * t - 11.125 ) * c6) / UPUnitTwo + UPUnitOne;
    }
    static UPUnit expo_in_value_for_t(UPUnit t) { return t == UPUnitZero ? UPUnitZero : powf(UPUnitTwo, 10 * t - 10); }
    static UPUnit expo_out_value_for_t(UPUnit t) { return t == UPUnitOne ? UPUnitOne : UPUnitOne - powf(UPUnitTwo, -10 * t); }
    static UPUnit expo_inout_value_for_t(UPUnit t) {
        return t == UPUnitZero ? UPUnitZero : t == UPUnitOne ? UPUnitOne : t < UPUnitHalf ? powf(UPUnitTwo, 20 * t - 10) / UPUnitTwo : (UPUnitTwo - powf(UPUnitTwo, -20 * t + 10)) / UPUnitTwo;
    }
    static UPUnit sine_in_value_for_t(UPUnit t) { return UPUnitOne - cosf(t * M_PI_2); }
    static UPUnit sine_out_value_for_t(UPUnit t) { return sinf(t * M_PI_2); }
    static UPUnit sine_inout_value_for_t(UPUnit t) { return -(cosf(t * M_PI) - UPUnitOne) / UPUnitTwo; }

private:
    static UPUnit bounce_out(UPUnit t) {
        static constexpr UPFloat n1 = 7.5625;
        static constexpr UPFloat d1 = 2.75;

        if (t < UPUnitOne / d1) {
            return n1 * t * t;
        }
        else if (t < UPUnitTwo / d1) {
            UPUnit t1 = t - (0.5 / d1);
            return n1 * t1 * t1 + 0.75;
        }
        else if (t < 2.5 / d1) {
            UPUnit t1 = t - (0.25 / d1);
            return n1 * t1 * t1 + 0.9375;
        }
        else {
            UPUnit t1 = t - (2.625 / d1);
            return n1 * t1 * t1 + 0.984375;
        }
    }

    UPUnitFunctionType m_type = UPUnitFunctionTypeDefault;
    UPUnit(*m_fn)(UPUnit);
};

} // namespace UP

#endif  // UP_UNITFUNCTION_HPP
