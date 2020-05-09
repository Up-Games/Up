//
//  UPStringTools.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_STRING_TOOLS_H
#define UP_STRING_TOOLS_H

#ifndef UP_STANDALONE_HEADER
#import <UPKit/UPMacros.h>
#else
#import "UPMacros.h"
#endif

#if __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#if __cplusplus

#import <codecvt>
#import <locale>
#import <string>
#import <vector>

namespace UP {

std::vector<std::string> split(const std::string &str, char delim);

UP_STATIC_INLINE std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> &utf8_char32_conv() {
    static std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> conv;
    return conv;
}

UP_STATIC_INLINE std::string cpp_str(const std::u32string &str) {
    return utf8_char32_conv().to_bytes(str);
}
UP_STATIC_INLINE std::u32string cpp_u32str(const std::string &str) {
    return utf8_char32_conv().from_bytes(str);
}

#if __OBJC__
UP_STATIC_INLINE NSString *ns_str(const char *str) { return [NSString stringWithUTF8String:str]; }
UP_STATIC_INLINE NSString *ns_str(const std::string &str) { return [NSString stringWithUTF8String:str.c_str()]; }
UP_STATIC_INLINE NSString *ns_str(const std::u32string &str) {
    return ns_str(utf8_char32_conv().to_bytes(str));
}
UP_STATIC_INLINE NSString *ns_str(char32_t c) {
    std::u32string str(1, c);
    return ns_str(str);
}
UP_STATIC_INLINE std::string cpp_str(NSString *str) { return std::string([str UTF8String]); }
UP_STATIC_INLINE std::u32string cpp_u32str(NSString *str) {
    return utf8_char32_conv().from_bytes(cpp_str(str));
}
#endif  // __OBJC__


}  // namespace UP

#endif  // __cplusplus

#endif  // UP_STRING_TOOLS_H
