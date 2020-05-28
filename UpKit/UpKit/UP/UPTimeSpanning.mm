//
//  UPTimeSpanning.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <unordered_map>
#import <vector>

#import "UPAnimator.h"
#import "UPDelayedAction.h"
#import "UPTimeSpanning.h"

namespace UP {
namespace TimeSpanning {

static std::unordered_map<uint32_t, __weak NSObject<UPTimeSpanning> *> *g_map;

const char * const AnimationLabel = "animation";
const char * const DelayLabel = "delay";
const char * const TestLabel = "test";

void init()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_map = new std::unordered_map<uint32_t, __weak NSObject<UPTimeSpanning> *>();
    });
}

NSObject<UPTimeSpanning> *delay(const char *label, double delay_in_seconds, void (^block)(void))
{
    UPDelayedAction *action = [UPDelayedAction delayedActionWithLabel:label duration:delay_in_seconds block:block];
    g_map->emplace(action.serialNumber, action);
    [action start];
    return action;
}

UPAnimator *bloop(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint position,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator bloopAnimatorWithLabel:label views:views duration:duration position:position completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *fade(const char *label, NSArray<UIView *> *views, CFTimeInterval duration,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator fadeAnimatorWithLabel:label views:views duration:duration completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *shake(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator shakeAnimatorWithLabel:label views:views duration:duration offset:offset completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *slide(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator slideAnimatorWithLabel:label views:views duration:duration offset:offset completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *slide_to(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint point,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator slideToAnimatorWithLabel:label views:views duration:duration point:point completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *spring(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator springAnimatorWithLabel:label views:views duration:duration offset:offset completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *set_color(const char *label, NSArray<UPControl *> *controls, CFTimeInterval duration, UPControlElement element,
    UPControlState fromControlState, UPControlState toControlState, void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator setColorAnimatorWithLabel:label controls:controls duration:duration element:element
        fromControlState:fromControlState toControlState:toControlState completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

void cancel(NSObject<UPTimeSpanning> *obj)
{
    if (obj) {
        g_map->erase(obj.serialNumber);
        [obj cancel];
    }
}

void cancel(const char *label)
{
    for (auto it = g_map->begin(); it != g_map->end();) {
        NSObject<UPTimeSpanning> *obj = it->second;
        if (label == obj.label || strcmp(label, obj.label) == 0) {
            it = g_map->erase(it);
            [obj cancel];
        }
        else {
            ++it;
        }
    }
}

void cancel_all()
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        [obj cancel];
    }
    g_map->clear();
}

void pause(NSObject<UPTimeSpanning> *obj)
{
    [obj pause];
}

void pause(const char *label)
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        if (label == obj.label || strcmp(label, obj.label) == 0) {
            [obj pause];
        }
    }
}

void pause_all()
{
    for (const auto &it : *g_map) {
        [it.second pause];
    }
}

void start(NSObject<UPTimeSpanning> *obj)
{
    [obj start];
}

void start(const char *label)
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        if (label == obj.label || strcmp(label, obj.label) == 0) {
            [obj start];
        }
    }
}

void start_all()
{
    for (const auto &it : *g_map) {
        [it.second start];
    }
}

void remove(NSObject<UPTimeSpanning> *obj)
{
    g_map->erase(obj.serialNumber);
}

}  // namespace TimeSpanning
}  // namespace UP
