//
//  UPView.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <map>
#import <set>
#import <vector>

#import "UPAnimator.h"
#import "UPAny.hpp"
#import "UPLayoutRule.h"
#import "UPMath.h"
#import "UPUnitFunction.hpp"
#import "UPView.h"

using namespace UP;

namespace UP {

enum UPAnimatableProperty {
    UPAnimatablePropertyFrame,
    UPAnimatablePropertyBackgroundColor,
};

//class AnimationPropertyState {
//public:
//
//    class Key {
//    public:
//        Key(NSInteger tag, UPAnimatableProperty property) : m_tag(tag), m_property(property) {}
//        NSInteger tag() const { return m_tag; }
//        UPAnimatableProperty property() const { return m_property; }
//    private:
//        NSInteger m_tag;
//        UPAnimatableProperty m_property;
//    };
//
//    AnimationPropertyState::Key key() const { return m_key; }
//
//    AnimationPropertyState(NSInteger tag, CGRect current, CGRect target) :
//        m_key(Key(tag, UPAnimatableProperty::UPAnimatablePropertyFrame)), m_current(current), m_target(target) {}
//
//private:
//    Key m_key;
//    Any m_current;
//    Any m_target;
//};

//bool operator<(const AnimationPropertyState::Key &a, const AnimationPropertyState::Key &b) {
//    return a.tag() != b.tag() ? a.tag() < b.tag() : a.property() < b.property();
//}
//bool operator==(const AnimationPropertyState::Key &a, const AnimationPropertyState::Key &b) {
//    return a.tag() == b.tag() && a.property() == b.property();
//}

class ViewAnimation {
public:
    ViewAnimation(UPTick duration, UP::UPUnitFunction timing_function, CGRect current, CGRect target) :
        m_tag(s_tag_counter++), m_duration(duration), m_timing_function(timing_function) {}

    void step(UPView *view, UPUnit fraction) {
        view.frame = up_lerp_rects(any_cast<CGRect>(m_current), any_cast<CGRect>(m_target), fraction);
    }
    
    uint32_t tag() const { return m_tag; }
    
private:
    static inline uint32_t s_tag_counter;
    uint32_t m_tag;
    UPTick m_duration;
    UP::UPUnitFunction m_timing_function;
    Any m_current;
    Any m_target;
};

class Animation {
public:
    Animation() {}
    void add_view_animation_tag(uint32_t tag) { m_view_animation_tags.insert(tag); }
private:
    std::set<uint32_t> m_view_animation_tags;
};

class Animator {
public:
    class State {
    public:
        State() {}
        State(UPTick duration, UP::UPUnitFunction timing_function) : m_duration(duration), m_timing_function(timing_function) {}
        UPTick duration() const { return m_duration; }
        UP::UPUnitFunction timing_function() const { return m_timing_function; }
        Animation &animation() { return m_animation; }
        
    private:
        UPTick m_duration = 0;
        UP::UPUnitFunction m_timing_function = UPUnitFunction();
        Animation m_animation;
    };

    static Animator instance() {
        static Animator instance;
        return instance;
    }

    void push_state(UPTick duration, UP::UPUnitFunction timing_function) {
        m_states.emplace_back(duration, timing_function);
    }

    void pop_state() {
        if (m_states.size()) {
            m_states.pop_back();
        }
    }

    State peek_state() const {
        return m_states.size() ? m_states.back() : State();
    }

    bool has_states() const {
        return m_states.size() > 0;
    }

    

private:
    std::vector<State> m_states;
    std::vector<UIView *> m_animating_views;
    std::vector<Animation> m_animations;
};

};  // namespace UP


#pragma mark - UPView

@interface UPView ()
//@property (nonatomic) std::map<UPAnimatableProperty, ViewAnimation> view_animations;
@end

@implementation UPView

+ (UPView *)viewWithBoundsSize:(CGSize)boundsSize
{
    return [[UPView alloc] initWithBoundsSize:boundsSize];
}

- (instancetype)initWithBoundsSize:(CGSize)boundsSize
{
    return [self initWithFrame:CGRectMake(0, 0, boundsSize.width, boundsSize.height)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    static NSInteger _TagCounter;
    self.tag = _TagCounter++;
    return self;
}

#pragma mark - UPLayoutRule

- (void)layoutWithRule
{
    self.frame = [self.layoutRule layoutFrameForBoundsSize:self.bounds.size];
}

#pragma mark - Animations

//- (void)setFrame:(CGRect)frame
//{
//    const auto &animator = Animator::instance();
//    if (animator.has_states()) {
//        Animator::State state = animator.peek_state();
//        const auto &result = self.view_animations.emplace(UPAnimatablePropertyFrame, ViewAnimation(state.duration(), state.timing_function(), self.frame, frame));
//        if (result.second) {
//            state.animation().add_view_animation_tag(result.first->second.tag());
//        }
//    }
//    else {
//        [super setFrame:frame];
//    }
//}

//- (UPViewState *)currentState
//{
//    UPViewState *currentState = [[UPViewState alloc] init];
//    currentState.frame = self.frame;
//    currentState.backgroundColor = self.backgroundColor;
//    return currentState;
//}
//
//- (void)applyState:(UPViewState *)state
//{
//    self.backgroundColor = state.backgroundColor;
//}
//
//- (void)applyInterpolatedWithStartState:(UPViewState *)startState endState:(UPViewState *)endState fraction:(UPUnit)fraction
//{
//    self.frame = up_lerp_rects(startState.frame, endState.frame, fraction);
////    NSLog(@"fraction: %.2f : %@", fraction, NSStringFromCGRect(self.frame));
//}
//
//- (void)applyInterpolatedStateWithFraction:(UPUnit)fraction
//{
//}

@end
