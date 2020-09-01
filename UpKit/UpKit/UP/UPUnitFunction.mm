//
//  UPUnitFunction.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPUnitFunction.h"

namespace UP {

//
// unchecked_unit_curve_value and unit_curve_value
// Compute a UPUnit output value for a UPUnit input value, using the provided exponent and
// easing factor, where:
//     input_value: a UPUnit value from 0 to 1
//     exponent:    a floating point value from 1 to any value,
//                  although all values larger than 20 or so are largely equal, and
//                  1 gives a linear mapping from input values to output values
//     ease_factor: a UPUnit value from an espilon value to one minus that espilon value
//                  0.5 gives an ease-in-ease-out curve, espilon gives an ease-out curve,
//                  and one minus espilon gives an ease-in curve
//

UPUnit unchecked_unit_curve_value(UPUnit input_value, UPFloat exponent, UPUnit ease_factor)
{
    UPUnit output_value = input_value;
    if (input_value <= ease_factor) {
        output_value = (ease_factor * UPUnit(pow(UPFloat(input_value / ease_factor), exponent)));
    }
    else {
        output_value = UPUnitOne - ((UPUnitOne - ease_factor) *
            UPUnit(pow(UPFloat((UPUnitOne - input_value) / (UPUnitOne - ease_factor)), exponent)));
    }
    return output_value;
}

UPUnit unit_curve_value(UPUnit input_value, UPFloat exponent, UPUnit ease_factor)
{
    UPFloat maxed_exponent = UPMaxT(UPFloat, exponent, UPUnitOne);
    UPUnit clamped_ease_factor = UPClampT(UPFloat, ease_factor, UPUnit(UPEpsilon), UPUnit(UPUnitOne - UPEpsilon));
    return unchecked_unit_curve_value(input_value, maxed_exponent, clamped_ease_factor);
}

UPUnitFunction::UPUnitFunction(UPUnitFunctionType _type): m_type(_type)
{
    switch (type()) {
        default:
        case UPUnitFunctionTypeDefault:
            m_fn = UPUnitFunction::default_value_for_t;
            break;
        case UPUnitFunctionTypeLinear:
            m_fn = UPUnitFunction::linear_value_for_t;
            break;
        case UPUnitFunctionTypeEaseIn:
            m_fn = UPUnitFunction::ease_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOut:
            m_fn = UPUnitFunction::ease_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOut:
            m_fn = UPUnitFunction::ease_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInQuad:
            m_fn = UPUnitFunction::ease_in_quad_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutQuad:
            m_fn = UPUnitFunction::ease_out_quad_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutQuad:
            m_fn = UPUnitFunction::ease_inout_quad_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInCubic:
            m_fn = UPUnitFunction::ease_in_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutCubic:
            m_fn = UPUnitFunction::ease_out_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutCubic:
            m_fn = UPUnitFunction::ease_inout_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInQuart:
            m_fn = UPUnitFunction::ease_in_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutQuart:
            m_fn = UPUnitFunction::ease_out_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutQuart:
            m_fn = UPUnitFunction::ease_inout_cubic_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInQuint:
            m_fn = UPUnitFunction::ease_in_quint_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutQuint:
            m_fn = UPUnitFunction::ease_out_quint_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutQuint:
            m_fn = UPUnitFunction::ease_inout_quint_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInBounce:
            m_fn = UPUnitFunction::bounce_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutBounce:
            m_fn = UPUnitFunction::bounce_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutBounce:
            m_fn = UPUnitFunction::bounce_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInCirc:
            m_fn = UPUnitFunction::circ_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutCirc:
            m_fn = UPUnitFunction::circ_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutCirc:
            m_fn = UPUnitFunction::circ_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInBack:
            m_fn = UPUnitFunction::back_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutBack:
            m_fn = UPUnitFunction::back_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutBack:
            m_fn = UPUnitFunction::back_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInElastic:
            m_fn = UPUnitFunction::elastic_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutElastic:
            m_fn = UPUnitFunction::elastic_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutElastic:
            m_fn = UPUnitFunction::elastic_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInExpo:
            m_fn = UPUnitFunction::expo_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutExpo:
            m_fn = UPUnitFunction::expo_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutExpo:
            m_fn = UPUnitFunction::expo_inout_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInSine:
            m_fn = UPUnitFunction::sine_in_value_for_t;
            break;
        case UPUnitFunctionTypeEaseOutSine:
            m_fn = UPUnitFunction::sine_out_value_for_t;
            break;
        case UPUnitFunctionTypeEaseInEaseOutSine:
            m_fn = UPUnitFunction::sine_inout_value_for_t;
            break;
    }
}

} // namespace UP

// =========================================================================================================================================

@interface UPUnitFunction ()
@property UP::UPUnitFunction inner;
@end

@implementation UPUnitFunction

+ (UPUnitFunction *)unitFunctionWithType:(UPUnitFunctionType)type
{
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(UPUnitFunctionType)type
{
    self = [super init];
    self.inner = UP::UPUnitFunction(type);
    return self;
}

- (UPFloat)valueForInput:(UPFloat)input
{
    return self.inner.value_for_t(input);
}

@dynamic type;
- (UPUnitFunctionType)type
{
    return self.inner.type();
}

@end
