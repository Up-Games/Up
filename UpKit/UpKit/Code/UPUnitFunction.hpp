//
//  UnitFunction.hpp
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

Unit unit_curve_value(Unit input_value, Float exponent, Unit ease_factor);
Unit unchecked_unit_curve_value(Unit input_value, Float exponent, Unit ease_factor);

class UnitFunction {
public:
    static constexpr Float DefaultEaseExponent = 4;
    static constexpr Float c1 = 1.70158;
    static constexpr Float c2 = c1 * 1.525;
    static constexpr Float c3 = c1 + 1;
    static constexpr Float c4 = c2 + 1;
    static constexpr Float c5 = (2 * M_PI) / 3;
    static constexpr Float c6 = (2 * M_PI) / 4.5;

    UnitFunction() {}
    UnitFunction(UPUnitFunctionType type);

    UPUnitFunctionType type() const { return m_type; }
    Unit value_for_t(Unit t) const { return m_fn(t); }
    
    static Unit linear_value_for_t(Unit t) { return t; }
    static Unit default_value_for_t(Unit t) { return linear_value_for_t(t); }
    
    static Unit ease_in_value_for_t(Unit t) { return unchecked_unit_curve_value(t, DefaultEaseExponent, 1.0 - UPEpsilon); }
    static Unit ease_out_value_for_t(Unit t) { return unchecked_unit_curve_value(t, DefaultEaseExponent, UPEpsilon); }
    static Unit ease_inout_value_for_t(Unit t) { return unchecked_unit_curve_value(t, DefaultEaseExponent, 0.5); }
    static Unit ease_in_quad_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 2, 1.0 - UPEpsilon); }
    static Unit ease_out_quad_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 2, UPEpsilon); }
    static Unit ease_inout_quad_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 2, 0.5); }
    static Unit ease_in_cubic_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 3, 1.0 - UPEpsilon); }
    static Unit ease_out_cubic_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 3, UPEpsilon); }
    static Unit ease_inout_cubic_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 3, 0.5); }
    static Unit ease_in_quart_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 4, 1.0 - UPEpsilon); }
    static Unit ease_out_quart_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 4, UPEpsilon); }
    static Unit ease_inout_quart_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 4, 0.5); }
    static Unit ease_in_quint_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 5, 1.0 - UPEpsilon); }
    static Unit ease_out_quint_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 5, UPEpsilon); }
    static Unit ease_inout_quint_value_for_t(Unit t) { return unchecked_unit_curve_value(t, 5, 0.5); }
    static Unit bounce_in_value_for_t(Unit t) { return 1 - bounce_out(1 - t); }
    static Unit bounce_out_value_for_t(Unit t) { return bounce_out(t); }
    static Unit bounce_inout_value_for_t(Unit t) {
        return t < 0.5 ? (1 - bounce_out(1 - 2 * t)) / 2 : (1 + bounce_out(2 * t - 1 )) / 2;
    }
    static Unit circ_in_value_for_t(Unit t) { return 1 - sqrt(1 - powf(t, 2)); }
    static Unit circ_out_value_for_t(Unit t) { return sqrt(1 - pow(t - 1, 2)); }
    static Unit circ_inout_value_for_t(Unit t) {
        return t < 0.5 ? (1 - sqrt(1 - pow(2 * t, 2))) / 2 : (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2;
    }
    static Unit back_in_value_for_t(Unit t) { return c3 * t * t * t - c1 * t * t; }
    static Unit back_out_value_for_t(Unit t) { return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2); }
    static Unit back_inout_value_for_t(Unit t) {
        return t < 0.5 ? (pow(2 * t, 2) * ((c4) * 2 * t - c2)) / 2 : (pow(2 * t - 2, 2) * ((c4) * (t * 2 - 2) + c2) + 2) / 2;
    }
    static Unit elastic_in_value_for_t(Unit t) { return t == 0 ? 0 : t == 1 ? 1 : -powf(2, 10 * t - 10) * sinf((t * 10 - 10.75) * c5); }
    static Unit elastic_out_value_for_t(Unit t) { return t == 0 ? 0 : t == 1 ? 1 : powf(2, -10 * t) * sinf((t * 10 - 0.75) * c5) + 1; }
    static Unit elastic_inout_value_for_t(Unit t) {
        return t == 0 ? 0 : t == 1 ? 1 : t < 0.5 ?
            -(powf(2, 20 * t - 10) * sinf((20 * t - 11.125) * c6)) / 2 :
                powf(2, -20 * t + 10) * sinf((20 * t - 11.125 ) * c6) / 2 + 1;
    }
    static Unit expo_in_value_for_t(Unit t) { return t == 0 ? 0 : powf(2, 10 * t - 10); }
    static Unit expo_out_value_for_t(Unit t) { return t == 1 ? 1 : 1 - pow(2, -10 * t); }
    static Unit expo_inout_value_for_t(Unit t) {
        return t == 0 ? 0 : t == 1 ? 1 : t < 0.5 ? powf(2, 20 * t - 10) / 2 : (2 - powf(2, -20 * t + 10)) / 2;
    }
    static Unit sine_in_value_for_t(Unit t) { return 1 - cosf(t * M_PI_2); }
    static Unit sine_out_value_for_t(Unit t) { return sinf(t * M_PI_2); }
    static Unit sine_inout_value_for_t(Unit t) { return -(cosf(t * M_PI) - 1) / 2; }

private:
    static Unit bounce_out(Unit t)
    {
        const Float n1 = 7.5625;
        const Float d1 = 2.75;

        if (t < 1 / d1) {
            return n1 * t * t;
        }
        else if (t < 2 / d1) {
            Unit t1 = t - (1.5 / d1);
            return n1 * t1 * t1 + 0.75;
        }
        else if (t < 2.5 / d1) {
            Unit t1 = t - (2.25 / d1);
            return n1 * t1 * t1 + 0.9375;
        }
        else {
            Unit t1 = t - (2.625 / d1);
            return n1 * t1 * t1 + 0.984375;
        }
    }

    UPUnitFunctionType m_type = UPUnitFunctionTypeDefault;
    Unit(*m_fn)(Unit);
};

} // namespace UP

#endif  // UP_UNITFUNCTION_HPP
