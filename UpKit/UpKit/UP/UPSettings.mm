//
//  UPSettings.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <sstream>
#import <string>
#import <map>
#import <set>
#import <unordered_map>
#import <vector>

#import <objc/runtime.h>

#import "UPAssertions.h"
#import "UPObjCProperty.h"
#import "UPSettings.h"
#import "UPStringTools.h"

using UP::cpp_str;
using UP::ns_str;
using UP::ObjCProperty;

// =========================================================================================================================================

@interface NSObject (UPSettings)
- (void)ensureDefaultValues;
- (void)resetDefaultValues;
@end

// =========================================================================================================================================

@interface UPSettings (NSUserDefaults)

- (id)valueForKey:(NSString *)key;

- (char)getCharKey:(NSString *)key;
- (void)setChar:(char)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (int)getIntKey:(NSString *)key;
- (void)setInt:(int)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (short)getShortKey:(NSString *)key;
- (void)setShort:(short)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (long)getLongKey:(NSString *)key;
- (void)setLong:(long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (long long)getLongLongKey:(NSString *)key;
- (void)setLongLong:(long long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned char)getUnsignedCharKey:(NSString *)key;
- (void)setUnsignedChar:(unsigned char)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned short)getUnsignedShortKey:(NSString *)key;
- (void)setUnsignedShort:(unsigned short)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned int)getUnsignedIntKey:(NSString *)key;
- (void)setUnsignedInt:(unsigned int)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned long)getUnsignedLongKey:(NSString *)key;
- (void)setUnsignedLong:(unsigned long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (unsigned long long)getUnsignedLongLongKey:(NSString *)key;
- (void)setUnsignedLongLong:(unsigned long long)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (float)getFloatKey:(NSString *)key;
- (void)setFloat:(float)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (double)getDoubleKey:(NSString *)key;
- (void)setDouble:(double)value key:(NSString *)key overwrite:(BOOL)overwrite;

- (BOOL)getBoolKey:(NSString *)key;
- (void)setBool:(BOOL)value key:(NSString *)key overwrite:(BOOL)overwrite;

@end

// =========================================================================================================================================

namespace UP {

class PropertyGlue {
public:
    enum class Type { Getter, Setter };
    
    PropertyGlue() {}
    PropertyGlue(NSString *defaults_key_prefix, const std::string &property_name, const ObjCProperty &property, Type type);

    const std::string &property_name() const { return m_property_name; }
    const ObjCProperty &property() const { return m_property; }
    Type type() const { return m_type; }
    NSString *defaults_key() const { return m_defaults_key; }
    SEL defaults_selector() const { return m_defaults_selector; }

private:
    std::string m_property_name;
    ObjCProperty m_property;
    Type m_type = Type::Getter;
    __strong NSString *m_defaults_key;
    SEL m_defaults_selector;
};

PropertyGlue::PropertyGlue(NSString *defaults_key_prefix, const std::string &property_name, const ObjCProperty &property, Type type) :
    m_property_name(property_name), m_property(property), m_type(type)
{
    NSMutableString *key = [NSMutableString stringWithString:defaults_key_prefix];
    [key appendString:ns_str(m_property_name)];
    m_defaults_key = key;
    
    switch (type) {
        case Type::Getter: {
            switch (property.type()) {
                case ObjCProperty::Type::Unsupported:
                    ASSERT_NOT_REACHED();
                    break;
                case ObjCProperty::Type::Char:
                    m_defaults_selector = @selector(getCharKey:);
                    break;
                case ObjCProperty::Type::Short:
                    m_defaults_selector = @selector(getShortKey:);
                    break;
                case ObjCProperty::Type::Int:
                    m_defaults_selector = @selector(getIntKey:);
                    break;
                case ObjCProperty::Type::Long:
                    m_defaults_selector = @selector(getLongKey:);
                    break;
                case ObjCProperty::Type::LongLong:
                    m_defaults_selector = @selector(getLongLongKey:);
                    break;
                case ObjCProperty::Type::UChar:
                    m_defaults_selector = @selector(getUnsignedCharKey:);
                    break;
                case ObjCProperty::Type::UShort:
                    m_defaults_selector = @selector(getUnsignedShortKey:);
                    break;
                case ObjCProperty::Type::UInt:
                    m_defaults_selector = @selector(getUnsignedIntKey:);
                    break;
                case ObjCProperty::Type::ULong:
                    m_defaults_selector = @selector(getUnsignedLongKey:);
                    break;
                case ObjCProperty::Type::ULongLong:
                    m_defaults_selector = @selector(getUnsignedLongLongKey:);
                    break;
                case ObjCProperty::Type::Float:
                    m_defaults_selector = @selector(getFloatKey:);
                    break;
                case ObjCProperty::Type::Double:
                    m_defaults_selector = @selector(getDoubleKey:);
                    break;
                case ObjCProperty::Type::Bool:
                    m_defaults_selector = @selector(getBoolKey:);
                    break;
                case ObjCProperty::Type::Object:
                    break;
            }
            break;
        }
        case Type::Setter: {
            switch (property.type()) {
                case ObjCProperty::Type::Unsupported:
                    ASSERT_NOT_REACHED();
                    break;
                case ObjCProperty::Type::Char:
                    m_defaults_selector = @selector(setChar:key:overwrite:);
                    break;
                case ObjCProperty::Type::Short:
                    m_defaults_selector = @selector(setShort:key:overwrite:);
                    break;
                case ObjCProperty::Type::Int:
                    m_defaults_selector = @selector(setInt:key:overwrite:);
                    break;
                case ObjCProperty::Type::Long:
                    m_defaults_selector = @selector(setLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::LongLong:
                    m_defaults_selector = @selector(setLongLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::UChar:
                    m_defaults_selector = @selector(setUnsignedChar:key:overwrite:);
                    break;
                case ObjCProperty::Type::UShort:
                    m_defaults_selector = @selector(setUnsignedShort:key:overwrite:);
                    break;
                case ObjCProperty::Type::UInt:
                    m_defaults_selector = @selector(setUnsignedInt:key:overwrite:);
                    break;
                case ObjCProperty::Type::ULong:
                    m_defaults_selector = @selector(setUnsignedLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::ULongLong:
                    m_defaults_selector = @selector(setUnsignedLongLong:key:overwrite:);
                    break;
                case ObjCProperty::Type::Float:
                    m_defaults_selector = @selector(setFloat:key:overwrite:);
                    break;
                case ObjCProperty::Type::Double:
                    m_defaults_selector = @selector(setDouble:key:overwrite:);
                    break;
                case ObjCProperty::Type::Bool:
                    m_defaults_selector = @selector(setBool:key:overwrite:);
                    break;
                case ObjCProperty::Type::Object:
                    break;
            }
        }
    }
}

}  // namespace UP

using UP::PropertyGlue;

// =========================================================================================================================================

static std::string up_property_setter_name(const std::string &property_name)
{
    std::string upper_property_name = property_name;
    upper_property_name[0] = std::toupper(upper_property_name[0]);
    
    std::ostringstream sstr;
    sstr << "set" << upper_property_name << ":";
    
    return sstr.str();
}

// =========================================================================================================================================

@interface UPSettings ()
{
    std::map<std::string, PropertyGlue> m_glue_map;
    BOOL m_setter_always_overwrites;
}
@end

@implementation UPSettings

- (instancetype)init
{
    self = [super init];

    std::vector<std::string> cls_names;
    Class settings_cls = objc_getClass("UPSettings");
    Class cls = self.class;
    while (cls != Nil && settings_cls != cls) {
        cls_names.push_back(class_getName(cls));
        cls = class_getSuperclass(cls);
    }
    std::ostringstream sstr;
    sstr << "/";
    for (auto it = cls_names.rbegin(); it != cls_names.rend(); ++it) {
        sstr << *it << "/";
    }
    NSString *defaults_key_prefix = [NSString stringWithUTF8String:sstr.str().c_str()];

    cls = self.class;
    do {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(cls, &outCount);
        for (unsigned int idx = 0; idx < outCount; idx++) {
            objc_property_t property = properties[idx];
            std::string property_name = property_getName(property);
            std::string getter_name = property_name;
            std::string setter_name = up_property_setter_name(property_name);
            ObjCProperty up_objc_property(property);
            m_glue_map.emplace(getter_name, PropertyGlue(defaults_key_prefix, property_name, up_objc_property, PropertyGlue::Type::Getter));
            m_glue_map.emplace(setter_name, PropertyGlue(defaults_key_prefix, property_name, up_objc_property, PropertyGlue::Type::Setter));
        }
        cls = class_getSuperclass(cls);
    } while (cls != [UPSettings class]);
    
    [self ensureDefaultValues];
    
    m_setter_always_overwrites = YES;
    
    return self;
}

- (void)ensureDefaultValues
{
    m_setter_always_overwrites = NO;
    [self resetDefaultValues];
    m_setter_always_overwrites = YES;
}

- (void)resetDefaultValues
{
    Class cls = self.class;
    SEL sel = @selector(setDefaultValues);
    do {
        IMP imp = [cls instanceMethodForSelector:@selector(setDefaultValues)];
        typedef void (*fn)(id, SEL);
        fn f = (fn)imp;
        f(self, sel);
        cls = class_getSuperclass(cls);
    } while (cls != [UPSettings class]);
}

- (void)setDefaultValues
{
    // for subclasses
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *selectorName = NSStringFromSelector(invocation.selector);
    const auto it = m_glue_map.find(cpp_str(selectorName));
    if (it == m_glue_map.end()) {
        [invocation invoke];
    }
    else {
        const PropertyGlue &glue = it->second;
        LOG(General, "forwardInvocation: %@", selectorName);
        invocation.selector = glue.defaults_selector();
        NSString *key = glue.defaults_key();
        switch (glue.type()) {
            case PropertyGlue::Type::Getter:
                [invocation setArgument:&key atIndex:2];
                break;
            case PropertyGlue::Type::Setter:
                [invocation setArgument:&key atIndex:3];
                [invocation setArgument:&m_setter_always_overwrites atIndex:4];
                break;
        }
        [invocation invoke];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    LOG(General, "methodSignatureForSelector: %@ : %@", self, NSStringFromSelector(selector));

    std::string property_name = ObjCProperty::name_from_selector(selector);
    if (property_name.length() == 0) {
        return [super methodSignatureForSelector:selector];
    }

    std::string selector_name = cpp_str(NSStringFromSelector(selector));
    const auto it = m_glue_map.find(selector_name);
    if (it != m_glue_map.end()) {
        const PropertyGlue &glue = it->second;
        return [self methodSignatureForSelector:glue.defaults_selector()];
    }
    
    return [super methodSignatureForSelector:selector];
}

@end

@implementation UPSettings (NSUserDefaults)

- (id)valueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (char)getCharKey:(NSString *)key
{
    LOG(General, "getCharKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val charValue] : 0;
}

- (void)setChar:(char)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setChar: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (short)getShortKey:(NSString *)key
{
    LOG(General, "getShortKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val shortValue] : 0;
}

- (void)setShort:(short)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setShort: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (int)getIntKey:(NSString *)key
{
    LOG(General, "getIntKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val intValue] : 0;
}

- (void)setInt:(int)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setInt: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (long)getLongKey:(NSString *)key
{
    LOG(General, "getLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val longValue] : 0;
}

- (void)setLong:(long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setLong: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (long long)getLongLongKey:(NSString *)key
{
    LOG(General, "getLongLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val longLongValue] : 0;
}

- (void)setLongLong:(long long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setLongLong: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned char)getUnsignedCharKey:(NSString *)key
{
    LOG(General, "getUnsignedCharKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedCharValue] : 0;
}

- (void)setUnsignedChar:(unsigned char)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setUnsignedChar: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned short)getUnsignedShortKey:(NSString *)key
{
    LOG(General, "getUnsignedShortKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedShortValue] : 0;
}

- (void)setUnsignedShort:(unsigned short)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setUnsignedShort: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned int)getUnsignedIntKey:(NSString *)key
{
    LOG(General, "getUnsignedIntKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedIntValue] : 0;
}

- (void)setUnsignedInt:(unsigned int)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setUnsignedInt: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned long)getUnsignedLongKey:(NSString *)key
{
    LOG(General, "getUnsignedLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedLongValue] : 0;
}

- (void)setUnsignedLong:(unsigned long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setUnsignedLong: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned long long)getUnsignedLongLongKey:(NSString *)key
{
    LOG(General, "getUnsignedLongLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedLongLongValue] : 0;
}

- (void)setUnsignedLongLong:(unsigned long long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setUnsignedLongLong: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (float)getFloatKey:(NSString *)key
{
    LOG(General, "getFloatKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val floatValue] : 0;
}

- (void)setFloat:(float)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setFloat: %.3f on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (double)getDoubleKey:(NSString *)key
{
    LOG(General, "getDoubleKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val doubleValue] : 0;
}

- (void)setDouble:(double)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setDouble: %.3f on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (BOOL)getBoolKey:(NSString *)key
{
    LOG(General, "getBoolKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val boolValue] : 0;
}

- (void)setBool:(BOOL)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setBool: %s on %@ (%s : %s)", value ? "Y" : "N", key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

@end
