//
//  UPStringTools.cpp
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPStringTools.h"

#import <sstream>

namespace UP {

std::vector<std::string> split(const std::string &str, char delim)
{
    std::vector<std::string> result;
    std::stringstream ss(str);
    std::string item;

    while (getline(ss, item, delim)) {
        result.push_back(item);
    }

    return result;
}

}  // namespace UP
