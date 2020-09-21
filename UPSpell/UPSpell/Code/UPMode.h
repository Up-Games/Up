//
//  UPMode.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <objc/objc.h>

#import <tuple>
#import <vector>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPMacros.h>

typedef NS_ENUM(NSInteger, UPModeTransitionScenario) {
    UPModeTransitionScenarioDefault,
    UPModeTransitionScenarioDidBecomeActive,
    UPModeTransitionScenarioWillEnterForeground,
    UPModeTransitionScenarioWillResignActive,
    UPModeTransitionScenarioDidEnterBackground,
};

namespace UP {

enum class Mode {
    None,
    Init,
    About,
    Extras,
    DuelHelp,
    ShareHelp,
    GameLink,
    GameLinkHelp,
    Ready,
    Play,
    Pause,
    GameOver,
    Quit,
    End,
};

UP_STATIC_INLINE const char *cstr_for(Mode mode)
{
    switch (mode) {
        case Mode::None:
            return "None";
        case Mode::Init:
            return "Init";
        case Mode::About:
            return "About";
        case Mode::Extras:
            return "Extras";
        case Mode::DuelHelp:
            return "DuelHelp";
        case Mode::ShareHelp:
            return "ShareHelp";
        case Mode::GameLink:
            return "GameLink";
        case Mode::GameLinkHelp:
            return "GameLinkHelp";
        case Mode::Ready:
            return "Ready";
        case Mode::Play:
            return "Play";
        case Mode::Pause:
            return "Pause";
        case Mode::GameOver:
            return "GameOver";
        case Mode::Quit:
            return "Quit";
        case Mode::End:
            return "End";
    }
    ASSERT_NOT_REACHED();
    return "?";
}

using ModeTransition = std::tuple<Mode, Mode, SEL>;
using ModeTransitionTable = std::vector<ModeTransition>;

template <class ForwardIt>
SEL transition_selector(const Mode from_mode, const Mode to_mode, const ForwardIt &table)
{
    for (const auto &transition : table) {
        if (std::get<0>(transition) == from_mode && std::get<1>(transition) == to_mode) {
            return std::get<2>(transition);
        }
    }
    ASSERT_WITH_MESSAGE(false, "No mode transition from %s to %s", cstr_for(from_mode), cstr_for(to_mode));
    return nullptr;
}

}  // namespace UP
