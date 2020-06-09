//
//  UPObjCProperty.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <objc/runtime.h>

namespace UP {

class ObjCProperty
{
public:
    static constexpr uint32_t AttributeFlagNone =         0;
    static constexpr uint32_t AttributeFlagReadOnly =     1 << 0;
    static constexpr uint32_t AttributeFlagCopy =         1 << 1;
    static constexpr uint32_t AttributeFlagRetain =       1 << 2;
    static constexpr uint32_t AttributeFlagNonAtomic =    1 << 3;
    static constexpr uint32_t AttributeFlagCustomGetter = 1 << 4;
    static constexpr uint32_t AttributeFlagCustomSetter = 1 << 5;
    static constexpr uint32_t AttributeFlagDynamic =      1 << 6;
    static constexpr uint32_t AttributeFlagWeak =         1 << 7;
    // P : Not supported
    // t<encoding> : Not supported
    
    enum class Type {
        Unsupported,
        Char,
        Int,
        Short,
        Long,
        LongLong,
        UChar,
        UShort,
        UInt,
        ULong,
        ULongLong,
        Float,
        Double,
        Bool,
        Object,
    };

    ObjCProperty() {}
    ObjCProperty(const objc_property_t &property);

    Type type() const { return m_type; }
    const std::string &ivar() const { return m_ivar; }
    const std::string &custom_getter() const { return m_custom_getter; }
    const std::string &custom_setter() const { return m_custom_setter; }
    uint32_t flags() const { return m_flags; }

    static const char * const c_str(Type);
    static std::string name_from_selector(SEL);
    static bool is_setter(SEL);
    
private:
    Type m_type = Type::Unsupported;
    uint32_t m_flags = AttributeFlagNone;
    std::string m_ivar;
    std::string m_custom_getter;
    std::string m_custom_setter;
};

}  // namespace UP
