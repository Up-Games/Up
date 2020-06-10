//
//  UPObjCProperty.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPAssertions.h"
#import "UPObjCProperty.h"
#import "UPStringTools.h"

namespace UP {
//
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5
//
// R: The property is read-only (readonly).
// C: The property is a copy of the value last assigned (copy).
// &: The property is a reference to the value last assigned (retain).
// N: The property is non-atomic (nonatomic).
// G<name> : The property defines a custom getter selector name. The name follows the G (for example, GcustomGetter,).
// S<name>: The property defines a custom setter selector name. The name follows the S (for example, ScustomSetter:,).
// D: The property is dynamic (@dynamic).
// W: The property is a weak reference (__weak).
// P: The property is eligible for garbage collection.
// t<encoding>: Specifies the type using old-style encoding.

//
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
//
// c: A char
// i: An int
// s: A short
// l: A long (l is treated as a 32-bit quantity on 64-bit programs.)
// q: A long long
// C: An unsigned char
// I: An unsigned int
// S: An unsigned short
// L: An unsigned long
// Q: An unsigned long long
// f: A float
// d: A double
// B: A C++ bool or a C99 _Bool
// v: A void
// *: A character string (char *)
// @: An object (whether statically typed or typed id)
// #: A class object (Class)
// :: A method selector (SEL)
// [array type]: An array
// {name=type...}: A structure
// (name=type...): A union
// bnum: A bit field of num bits
// ^type: A pointer to type
// ?: An unknown type (among other things, this code is used for function pointers)

ObjCProperty::ObjCProperty(const objc_property_t &property)
{
    std::string attrs = property_getAttributes(property);
    std::vector<std::string> attrs_v;
    UP::tokenize(attrs, attrs_v, ",");
    for (const auto &attr : attrs_v) {
        if (attr.length() == 0) {
            continue;
        }
        switch (attr[0]) {
            case 'T': {
                if (attr.length() == 2) {
                    switch (attr[1]) {
                        case 'c':
                            m_type = Type::Char;
                            break;
                        case 'i':
                            m_type = Type::Int;
                            break;
                        case 's':
                            m_type = Type::Short;
                            break;
                        case 'l':
                            m_type = Type::Long;
                            break;
                        case 'q':
                            m_type = Type::LongLong;
                            break;
                        case 'C':
                            m_type = Type::UChar;
                            break;
                        case 'I':
                            m_type = Type::UInt;
                            break;
                        case 'S':
                            m_type = Type::UShort;
                            break;
                        case 'L':
                            m_type = Type::ULong;
                            break;
                        case 'Q':
                            m_type = Type::ULongLong;
                            break;
                        case 'f':
                            m_type = Type::Float;
                            break;
                        case 'd':
                            m_type = Type::Double;
                            break;
                        case 'B':
                            m_type = Type::Bool;
                            break;
                    }
                }
                else if (attr.length() > 2) {
                    if (attr[1] == '@') {
                        // Yields "NSString" from a string in the form T@"NSString"
                        std::string type_str = attr.substr(3, attr.length() - 4);
                        if (type_str == "NSString") {
                            m_type = Type::String;
                        }
                        else if (type_str == "NSData") {
                            m_type = Type::Data;
                        }
                        else if (type_str == "NSNumber") {
                            m_type = Type::Number;
                        }
                        else if (type_str == "NSDate") {
                            m_type = Type::Date;
                        }
                        else if (type_str == "NSArray") {
                            m_type = Type::Array;
                        }
                        else if (type_str == "NSDictionary") {
                            m_type = Type::Dictionary;
                        }
                        else {
                            m_type = Type::Object;
                        }
                    }
                }
                break;
            }
            case 'V':
                m_ivar = attr.substr(1);
                break;
            case 'R':
                m_flags |= AttributeFlagReadOnly;
                break;
            case 'C':
                m_flags |= AttributeFlagCopy;
                break;
            case '&':
                m_flags |= AttributeFlagRetain;
                break;
            case 'N':
                m_flags |= AttributeFlagNonAtomic;
                break;
            case 'G':
                m_flags |= AttributeFlagCustomGetter;
                m_custom_getter = attr.substr(1);
                break;
            case 'S':
                m_flags |= AttributeFlagCustomSetter;
                m_custom_setter = attr.substr(1);
                break;
            case 'D':
                m_flags |= AttributeFlagDynamic;
                break;
            case 'W':
                m_flags |= AttributeFlagWeak;
                break;
        }
    }

}

const char * const ObjCProperty::c_str(Type type)
{
    switch (type) {
        case Type::Unsupported:
            return "?";
        case Type::Char:
            return "char";
        case Type::Int:
            return "int";
        case Type::Short:
            return "short";
        case Type::Long:
            return "long";
        case Type::LongLong:
            return "long long";
        case Type::UChar:
            return "unsigned char";
        case Type::UShort:
            return "unsigned short";
        case Type::UInt:
            return "unsigned int";
        case Type::ULong:
            return "unsigned int";
        case Type::ULongLong:
            return "unsigned long long";
        case Type::Float:
            return "float";
        case Type::Double:
            return "double";
        case Type::Bool:
            return "bool";
        case Type::Object:
            return "object";
        case Type::String:
            return "NSString";
        case Type::Data:
            return "NSData";
        case Type::Number:
            return "NSNumber";
        case Type::Date:
            return "NSDate";
        case Type::Array:
            return "NSArray";
        case Type::Dictionary:
            return "NSDictionary";
    }
}

}  // namespace UP
