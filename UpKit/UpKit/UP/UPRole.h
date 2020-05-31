//
//  UPRole.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string.h>

namespace UP {

using Role = const char * const;

static constexpr Role RoleGame = "game";
static constexpr Role RoleGameDelay = "game.delay";
static constexpr Role RoleGameUI = "game.ui";
static constexpr Role RoleMode = "mode";
static constexpr Role RoleModeDelay = "mode.delay";
static constexpr Role RoleModeUI = "mode.ui";
static constexpr Role RoleTest = "test";

}  // namespace UP
