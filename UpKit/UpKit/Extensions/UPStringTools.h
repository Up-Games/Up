//
//  UPStringTools.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_STRING_TOOLS_H
#define UP_STRING_TOOLS_H

#import <UPKit/UPMacros.h>

#if __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#if __cplusplus

#import <vector>
#import <string>

namespace UP {

std::vector<std::string> split(const std::string &str, char delim);

#if __OBJC__
UP_STATIC_INLINE NSString *ns_str(const std::string &str) { return [NSString stringWithUTF8String:str.c_str()]; }
UP_STATIC_INLINE NSString *ns_str(const char *str) { return [NSString stringWithUTF8String:str]; }
UP_STATIC_INLINE std::string cpp_str(NSString *str) { return std::string([str UTF8String]); }
#endif  // __OBJC__

}  // namespace UP

#endif  // __cplusplus

#endif  // UP_STRING_TOOLS_H
