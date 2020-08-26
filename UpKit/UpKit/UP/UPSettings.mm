//
//  UPSettings.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <sstream>
#import <string>
#import <map>

#import <objc/runtime.h>

#import "UPAssertions.h"
#import "UPObjCProperty.h"
#import "UPSettings.h"
#import "UPStringTools.h"

using UP::cpp_str;
using UP::ns_str;
using UP::ObjCProperty;

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

- (NSString *)getStringKey:(NSString *)key;
- (NSData *)getDataKey:(NSString *)key;
- (NSNumber *)getNumberKey:(NSString *)key;
- (NSDate *)getDateKey:(NSString *)key;
- (NSArray *)getArrayKey:(NSString *)key;
- (NSDictionary *)getDictionaryKey:(NSString *)key;

- (id)getObjectKey:(NSString *)key;
- (void)setObject:(NSObject *)value key:(NSString *)key overwrite:(BOOL)overwrite;

@end

// =========================================================================================================================================

namespace UP {

class SettingsProperty {
public:
    enum class Type { Getter, Setter };
    
    SettingsProperty() {}
    SettingsProperty(NSString *defaults_key_prefix, const std::string &property_name, const ObjCProperty &property, Type type);

    const ObjCProperty &property() const { return m_property; }
    Type type() const { return m_type; }
    NSString *defaults_key() const { return m_defaults_key; }
    SEL defaults_selector() const { return m_defaults_selector; }

private:
    std::string m_property_name;
    ObjCProperty m_property;
    Type m_type = Type::Getter;
    __strong NSString *m_defaults_key;
    SEL m_defaults_selector = nullptr;
};

SettingsProperty::SettingsProperty(NSString *defaults_key_prefix, const std::string &property_name,
                                   const ObjCProperty &property, Type type) :
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
                case ObjCProperty::Type::String:
                    m_defaults_selector = @selector(getStringKey:);
                    break;
                case ObjCProperty::Type::Data:
                    m_defaults_selector = @selector(getDataKey:);
                    break;
                case ObjCProperty::Type::Number:
                    m_defaults_selector = @selector(getNumberKey:);
                    break;
                case ObjCProperty::Type::Date:
                    m_defaults_selector = @selector(getDateKey:);
                    break;
                case ObjCProperty::Type::Array:
                    m_defaults_selector = @selector(getArrayKey:);
                    break;
                case ObjCProperty::Type::Dictionary:
                    m_defaults_selector = @selector(getDictionaryKey:);
                    break;
                case ObjCProperty::Type::Object:
                    m_defaults_selector = @selector(getObjectKey:);
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
                case ObjCProperty::Type::String:
                case ObjCProperty::Type::Data:
                case ObjCProperty::Type::Number:
                case ObjCProperty::Type::Date:
                case ObjCProperty::Type::Array:
                case ObjCProperty::Type::Dictionary:
                case ObjCProperty::Type::Object:
                    m_defaults_selector = @selector(setObject:key:overwrite:);
                    break;
            }
        }
    }
}

}  // namespace UP

using UP::SettingsProperty;

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

using SelectorPropertyMap = std::map<std::string, SettingsProperty>;
using SettingsMap = std::map<Class, SelectorPropertyMap>;

static SettingsMap m_map;

@interface UPSettings ()
{
    BOOL m_setter_always_overwrites;
}
@end

@implementation UPSettings

+ (void)initialize
{
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
    
    SelectorPropertyMap property_map;
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    for (unsigned int idx = 0; idx < outCount; idx++) {
        objc_property_t property = properties[idx];
        std::string property_name = property_getName(property);
        std::string getter_name = property_name;
        std::string setter_name = up_property_setter_name(property_name);
        ObjCProperty up_objc_property(property);
        property_map.emplace(getter_name, SettingsProperty(defaults_key_prefix, property_name, up_objc_property,
                                                           SettingsProperty::Type::Getter));
        property_map.emplace(setter_name, SettingsProperty(defaults_key_prefix, property_name, up_objc_property,
                                                           SettingsProperty::Type::Setter));
    }
    
    m_map.emplace(self.class, property_map);
}

- (instancetype)init
{
    self = [super init];
    
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
        IMP imp = [cls instanceMethodForSelector:sel];
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
    std::string selector_name = cpp_str(NSStringFromSelector(invocation.selector));

    Class cls = self.class;
    do {
        SelectorPropertyMap selector_map = m_map[cls];
        const auto it = selector_map.find(selector_name);
        if (it != selector_map.end()) {
            LOG(Settings, "forwardInvocation: %s", selector_name.c_str());
            const SettingsProperty &settings_property = it->second;
            invocation.selector = settings_property.defaults_selector();
            NSString *key = settings_property.defaults_key();
            LOG(Settings, "   key: %@", key);
            switch (settings_property.type()) {
                case SettingsProperty::Type::Getter:
                    [invocation setArgument:&key atIndex:2];
                    break;
                case SettingsProperty::Type::Setter:
                    [invocation setArgument:&key atIndex:3];
                    [invocation setArgument:&m_setter_always_overwrites atIndex:4];
                    break;
            }
            break;
        }
        cls = class_getSuperclass(cls);
    } while (cls != [UPSettings class]);

    [invocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    LOG(Settings, "methodSignatureForSelector: %@ : %@", self, NSStringFromSelector(selector));

    std::string selector_name = cpp_str(NSStringFromSelector(selector));
    Class cls = self.class;
    do {
        SelectorPropertyMap selector_map = m_map[cls];
        const auto it = selector_map.find(selector_name);
        if (it != selector_map.end()) {
            const SettingsProperty &settings_property = it->second;
            return [cls instanceMethodSignatureForSelector:settings_property.defaults_selector()];
        }
        cls = class_getSuperclass(cls);
    } while (cls != [UPSettings class]);

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
    LOG(Settings, "getCharKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val charValue] : 0;
}

- (void)setChar:(char)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setChar: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (short)getShortKey:(NSString *)key
{
    LOG(Settings, "getShortKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val shortValue] : 0;
}

- (void)setShort:(short)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setShort: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (int)getIntKey:(NSString *)key
{
    LOG(Settings, "getIntKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val intValue] : 0;
}

- (void)setInt:(int)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setInt: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (long)getLongKey:(NSString *)key
{
    LOG(Settings, "getLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val longValue] : 0;
}

- (void)setLong:(long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setLong: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (long long)getLongLongKey:(NSString *)key
{
    LOG(Settings, "getLongLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val longLongValue] : 0;
}

- (void)setLongLong:(long long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setLongLong: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned char)getUnsignedCharKey:(NSString *)key
{
    LOG(Settings, "getUnsignedCharKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedCharValue] : 0;
}

- (void)setUnsignedChar:(unsigned char)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setUnsignedChar: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned short)getUnsignedShortKey:(NSString *)key
{
    LOG(Settings, "getUnsignedShortKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedShortValue] : 0;
}

- (void)setUnsignedShort:(unsigned short)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setUnsignedShort: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned int)getUnsignedIntKey:(NSString *)key
{
    LOG(Settings, "getUnsignedIntKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedIntValue] : 0;
}

- (void)setUnsignedInt:(unsigned int)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setUnsignedInt: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned long)getUnsignedLongKey:(NSString *)key
{
    LOG(Settings, "getUnsignedLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedLongValue] : 0;
}

- (void)setUnsignedLong:(unsigned long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setUnsignedLong: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (unsigned long long)getUnsignedLongLongKey:(NSString *)key
{
    LOG(Settings, "getUnsignedLongLongKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val unsignedLongLongValue] : 0;
}

- (void)setUnsignedLongLong:(unsigned long long)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setUnsignedLongLong: %ld on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (float)getFloatKey:(NSString *)key
{
    LOG(Settings, "getFloatKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val floatValue] : 0;
}

- (void)setFloat:(float)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setFloat: %.3f on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (double)getDoubleKey:(NSString *)key
{
    LOG(Settings, "getDoubleKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val doubleValue] : 0;
}

- (void)setDouble:(double)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setDouble: %.3f on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (BOOL)getBoolKey:(NSString *)key
{
    LOG(Settings, "getBoolKey: on %@", key);
    id val = [self valueForKey:key];
    return val ? [val boolValue] : 0;
}

- (void)setBool:(BOOL)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setBool: %s on %@ (%s)", value ? "Y" : "N", key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    }
}

- (NSString *)getStringKey:(NSString *)key
{
    LOG(Settings, "getStringKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSString class]] ? (NSString *)val : @"";
}

- (NSData *)getDataKey:(NSString *)key
{
    LOG(Settings, "getDataKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSData class]] ? (NSData *)val : [NSData data];
}

- (NSNumber *)getNumberKey:(NSString *)key
{
    LOG(Settings, "getNumberKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSNumber class]] ? (NSNumber *)val : @(0);
}

- (NSDate *)getDateKey:(NSString *)key
{
    LOG(Settings, "getDateKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSDate class]] ? (NSDate *)val : [NSDate date];
}

- (NSArray *)getArrayKey:(NSString *)key
{
    LOG(Settings, "getArrayKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSArray class]] ? (NSArray *)val : @[];
}

- (NSDictionary *)getDictionaryKey:(NSString *)key
{
    LOG(Settings, "getDictionaryKey: on %@", key);
    id val = [self valueForKey:key];
    return val && [val isKindOfClass:[NSDictionary class]] ? (NSDictionary *)val : @{};
}

- (id)getObjectKey:(NSString *)key
{
    LOG(Settings, "getObjectKey: on %@", key);
    id val = [self valueForKey:key];
    return val ?: nil;
}

- (void)setObject:(NSObject *)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    if (write) {
        LOG(Settings, "setObject: %@ on %@ (%s)", value, key, overwrite ? "Y" : "N");
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    }
}

@end
