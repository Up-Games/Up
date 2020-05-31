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

void init()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_map = new std::unordered_map<uint32_t, __weak NSObject<UPTimeSpanning> *>();
    });
}

NSObject<UPTimeSpanning> *delay(UP::Role role, double delay_in_seconds, void (^block)(void))
{
    UPDelayedAction *action = [UPDelayedAction delayedAction:role duration:delay_in_seconds block:block];
    g_map->emplace(action.serialNumber, action);
    [action start];
    return action;
}

UPAnimator *bloop(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint position,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator bloopAnimatorWithRole:role views:views duration:duration position:position completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *fade(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator fadeAnimatorWithRole:role views:views duration:duration completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *shake(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator shakeAnimatorWithRole:role views:views duration:duration offset:offset completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *slide(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator slideAnimatorWithRole:role views:views duration:duration offset:offset completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *slide_to(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint point,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator slideToAnimatorWithRole:role views:views duration:duration point:point completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *spring(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator springAnimatorWithRole:role views:views duration:duration offset:offset completion:completion];
    g_map->emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *set_color(UP::Role role, NSArray<UPControl *> *controls, CFTimeInterval duration, UPControlElement element,
    UPControlState fromControlState, UPControlState toControlState, void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator setColorAnimatorWithRole:role controls:controls duration:duration element:element
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

void cancel(UP::Role role)
{
    for (auto it = g_map->begin(); it != g_map->end();) {
        NSObject<UPTimeSpanning> *obj = it->second;
        if (role == obj.role || strcmp(role, obj.role) == 0) {
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

void pause(UP::Role role)
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        if (role == obj.role || strcmp(role, obj.role) == 0) {
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

void start(UP::Role role)
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        if (role == obj.role || strcmp(role, obj.role) == 0) {
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
