//
//  UPUnitFunction.cpp
//

#import <UpKit/UPUnitFunction.hpp>

namespace UP {

//
// unchecked_unit_curve_value and unit_curve_value
// Compute a Unit output value for a Unit input value, using the provided exponent and
// easing factor, where:
//     input_value: a Unit value from 0 to 1
//     exponent:    a floating point value from 1 to any value,
//                  although all values larger than 20 or so are largely equal, and
//                  1 gives a linear mapping from input values to output values
//     ease_factor: a Unit value from an espilon value to one minus that espilon value
//                  0.5 gives an ease-in-ease-out curve, espilon gives an ease-out curve,
//                  and one minus espilon gives an ease-in curve
//

Unit unchecked_unit_curve_value(Unit input_value, Float exponent, Unit ease_factor)
{
    Unit output_value = input_value;
    if (input_value <= ease_factor) {
        output_value = (ease_factor * Unit(powf(Float(input_value / ease_factor), exponent)));
    }
    else {
        output_value = UnitOne - ((UnitOne - ease_factor) *
            Unit(powf(Float((UnitOne - input_value) / (UnitOne - ease_factor)), exponent)));
    }
    return output_value;
}

Unit unit_curve_value(Unit input_value, Float exponent, Unit ease_factor)
{
    Float maxed_exponent = UPMaxT(Float, exponent, UnitOne);
    Unit clamped_ease_factor = UPClampT(Float, ease_factor, Unit(UPEpsilon), Unit(UnitOne - UPEpsilon));
    return unchecked_unit_curve_value(input_value, maxed_exponent, clamped_ease_factor);
}

UnitFunction::UnitFunction(UPUnitFunctionType _type): m_type(_type)
{
    switch (type()) {
        default:
        case UPUnitFunctionTypeDefault:
            m_fn = UnitFunction::default_value_for_t;
            break;
        case UPUnitFunctionTypeLinear:
            m_fn = UnitFunction::linear_value_for_t;
            break;
        case UPUnitFunctionTypeEaseIn:
            m_fn = UnitFunction::ease_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOut:
            m_fn = UnitFunction::ease_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOut:
            m_fn = UnitFunction::ease_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInQuad:
            m_fn = UnitFunction::ease_in_quad_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutQuad:
            m_fn = UnitFunction::ease_out_quad_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutQuad:
            m_fn = UnitFunction::ease_inout_quad_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInCubic:
            m_fn = UnitFunction::ease_in_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutCubic:
            m_fn = UnitFunction::ease_out_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutCubic:
            m_fn = UnitFunction::ease_inout_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInQuart:
            m_fn = UnitFunction::ease_in_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutQuart:
            m_fn = UnitFunction::ease_out_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutQuart:
            m_fn = UnitFunction::ease_inout_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInQuint:
            m_fn = UnitFunction::ease_in_quint_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutQuint:
            m_fn = UnitFunction::ease_out_quint_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutQuint:
            m_fn = UnitFunction::ease_inout_quint_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInBounce:
            m_fn = UnitFunction::bounce_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutBounce:
            m_fn = UnitFunction::bounce_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutBounce:
            m_fn = UnitFunction::bounce_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInCirc:
            m_fn = UnitFunction::circ_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutCirc:
            m_fn = UnitFunction::circ_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutCirc:
            m_fn = UnitFunction::circ_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInBack:
            m_fn = UnitFunction::back_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutBack:
            m_fn = UnitFunction::back_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutBack:
            m_fn = UnitFunction::back_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInElastic:
            m_fn = UnitFunction::elastic_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutElastic:
            m_fn = UnitFunction::elastic_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutElastic:
            m_fn = UnitFunction::elastic_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInExpo:
            m_fn = UnitFunction::expo_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutExpo:
            m_fn = UnitFunction::expo_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutExpo:
            m_fn = UnitFunction::expo_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInSine:
            m_fn = UnitFunction::sine_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutSine:
            m_fn = UnitFunction::sine_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutSine:
            m_fn = UnitFunction::sine_inout_value_for_t;
            break;
    }
}

} // namespace UP
