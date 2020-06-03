//
//  UPRole.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UPKit/UPAssertions.h>

#import <string.h>

namespace UP {

using Role = const char * const;

static constexpr Role RoleGameAll = "game.*";
static constexpr Role RoleGameDelay = "game.delay";
static constexpr Role RoleGameUI = "game.ui";
static constexpr Role RoleModeAll = "mode.*";
static constexpr Role RoleModeDelay = "mode.delay";
static constexpr Role RoleModeUI = "mode.ui";
static constexpr Role RoleTest = "test";

template <bool B = true> bool role_match(Role pattern, Role role)
{
    bool b = (pattern == role) || (strcmp(pattern, role) == 0);
    if (!b) {
        const char *star = strchr(pattern, '*');
        if (star) {
            size_t len = star - pattern;
            b = strncmp(pattern, role, len) == 0;
        }
    }
    return b == B;
}

}  // namespace UP
