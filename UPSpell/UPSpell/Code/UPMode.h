//
//  Mode.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <objc/objc.h>

#import <tuple>
#import <vector>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPMacros.h>

namespace UP {

enum class Mode {
    None,
    Init,
    About,
    Extras,
    Attract,
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
        case Mode::Attract:
            return "Attract";
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

UP_STATIC_INLINE SEL transition_selector(const Mode from_mode, const Mode to_mode, const ModeTransitionTable &table)
{
    for (const auto &transition : table) {
        if (std::get<0>(transition) == from_mode && std::get<1>(transition) == to_mode) {
            return std::get<2>(transition);
        }
    }
    ASSERT_WITH_MESSAGE(false, "No mode transition from %d to %d", (int)from_mode, (int)to_mode);
    return nullptr;
}

}  // namespace UP
