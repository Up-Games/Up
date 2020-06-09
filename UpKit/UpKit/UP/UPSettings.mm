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
- (NSInteger)getIntegerKey:(NSString *)key;
- (void)setInteger:(NSInteger)value key:(NSString *)key overwrite:(BOOL)overwrite;

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
                    break;
                case ObjCProperty::Type::Int:
                    break;
                case ObjCProperty::Type::Short:
                    break;
                case ObjCProperty::Type::Long:
                    break;
                case ObjCProperty::Type::LongLong:
                    m_defaults_selector = @selector(getIntegerKey:);
                    break;
                case ObjCProperty::Type::UChar:
                    break;
                case ObjCProperty::Type::UShort:
                    break;
                case ObjCProperty::Type::UInt:
                    break;
                case ObjCProperty::Type::ULong:
                    break;
                case ObjCProperty::Type::ULongLong:
                    break;
                case ObjCProperty::Type::Float:
                    break;
                case ObjCProperty::Type::Double:
                    break;
                case ObjCProperty::Type::Bool:
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
                    break;
                case ObjCProperty::Type::Int:
                    break;
                case ObjCProperty::Type::Short:
                    break;
                case ObjCProperty::Type::Long:
                    break;
                case ObjCProperty::Type::LongLong:
                    m_defaults_selector = @selector(setInteger:key:overwrite:);
                    break;
                case ObjCProperty::Type::UChar:
                    break;
                case ObjCProperty::Type::UShort:
                    break;
                case ObjCProperty::Type::UInt:
                    break;
                case ObjCProperty::Type::ULong:
                    break;
                case ObjCProperty::Type::ULongLong:
                    break;
                case ObjCProperty::Type::Float:
                    break;
                case ObjCProperty::Type::Double:
                    break;
                case ObjCProperty::Type::Bool:
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

- (NSInteger)getIntegerKey:(NSString *)key
{
    LOG(General, "getInteger: on %@", key);
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (void)setInteger:(NSInteger)value key:(NSString *)key overwrite:(BOOL)overwrite
{
    BOOL write = overwrite || ![self valueForKey:key];
    LOG(General, "setInteger: %ld on %@ (%s : %s)", value, key, write ? "Y" : "N", overwrite ? "Y" : "N");
    if (write) {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    }
}

@end
