//
//  UPTimeSpanning.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <unordered_map>
#import <vector>

#import "UPAssertions.h"
#import "UPAnimator.h"
#import "UPDelayedAction.h"
#import "UPTimeSpanning.h"

namespace UP {
namespace TimeSpanning {

static std::unordered_map<uint32_t, __strong NSObject<UPTimeSpanning> *> *g_map;

void init()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_map = new std::unordered_map<uint32_t, __strong NSObject<UPTimeSpanning> *>();
    });
}

UP_STATIC_INLINE void emplace(uint32_t serial_number, NSObject<UPTimeSpanning> *obj)
{
#if LOG_DISABLED
    g_map->emplace(serial_number, obj);
#else
    auto r = g_map->emplace(serial_number, obj);
    if (r.second) {
        LOG(Leaks, "add: %d (%ld)", serial_number, g_map->size());
    }
#endif
}

UP_STATIC_INLINE void erase(uint32_t serial_number)
{
#if LOG_DISABLED
    g_map->erase(serial_number);
#else
    auto r = g_map->erase(serial_number);
    if (r) {
        LOG(Leaks, "rem: %d (%ld)", serial_number, g_map->size());
    }
#endif
}

NSObject<UPTimeSpanning> *delay(UP::Role role, double delay_in_seconds, void (^block)(void))
{
    UPDelayedAction *action = [UPDelayedAction delayedAction:role duration:delay_in_seconds block:block];
    emplace(action.serialNumber, action);
    [action start];
    return action;
}

UPAnimator *bloop(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint position,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator bloopAnimatorWithRole:role views:views duration:duration position:position completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *fade(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator fadeAnimatorWithRole:role views:views duration:duration completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *shake(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator shakeAnimatorWithRole:role views:views duration:duration offset:offset completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *slide(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator slideAnimatorWithRole:role views:views duration:duration offset:offset completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *slide_to(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint point,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator slideToAnimatorWithRole:role views:views duration:duration point:point completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *spring(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator springAnimatorWithRole:role views:views duration:duration offset:offset completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *set_color(UP::Role role, NSArray<UPControl *> *controls, CFTimeInterval duration, UPControlElement element,
    UPControlState fromControlState, UPControlState toControlState, void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator setColorAnimatorWithRole:role controls:controls duration:duration element:element
        fromControlState:fromControlState toControlState:toControlState completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

void cancel(NSObject<UPTimeSpanning> *obj)
{
    if (obj) {
        NSObject<UPTimeSpanning> *ref = obj;
        erase(obj.serialNumber);
        [obj cancel];
        ref = nil;
    }
}

void cancel(uint32_t serial_number)
{
    auto it = g_map->find(serial_number);
    if (it != g_map->end()) {
        NSObject<UPTimeSpanning> *obj = it->second;
        NSObject<UPTimeSpanning> *ref = obj;
        g_map->erase(it);
        [obj cancel];
        ref = nil;
#if !LOG_DISABLED
        LOG(Leaks, "rem: %d (%ld)", serial_number, g_map->size());
#endif
    }
}

void cancel(NSArray<UIView *> *views)
{
    for (auto it = g_map->begin(); it != g_map->end();) {
        NSObject<UPTimeSpanning> *obj = it->second;
        if ([obj isKindOfClass:[UPAnimator class]] && [views isEqualToArray:((UPAnimator *)obj).views]) {
            NSObject<UPTimeSpanning> *ref = obj;
            uint32_t serial_number = obj.serialNumber;
            it = g_map->erase(it);
            [obj cancel];
#if !LOG_DISABLED
            LOG(Leaks, "rem: %d (%ld)", serial_number, g_map->size());
#endif
            ref = nil;
        }
        else {
            ++it;
        }
    }
}

void cancel(UP::Role role)
{
    for (auto it = g_map->begin(); it != g_map->end();) {
        NSObject<UPTimeSpanning> *obj = it->second;
        if (role_match(role, obj.role)) {
            NSObject<UPTimeSpanning> *ref = obj;
            uint32_t serial_number = obj.serialNumber;
            it = g_map->erase(it);
            [obj cancel];
#if !LOG_DISABLED
            LOG(Leaks, "rem: %d (%ld)", serial_number, g_map->size());
#endif
            ref = nil;
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

void pause(uint32_t serial_number)
{
    auto it = g_map->find(serial_number);
    if (it != g_map->end()) {
        NSObject<UPTimeSpanning> *obj = it->second;
        [obj pause];
    }
}

void pause(UP::Role role)
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        if (role_match(role, obj.role)) {
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
        if (role_match(role, obj.role)) {
            [obj start];
        }
    }
}

void start(uint32_t serial_number)
{
    auto it = g_map->find(serial_number);
    if (it != g_map->end()) {
        NSObject<UPTimeSpanning> *obj = it->second;
        [obj start];
    }
}

void start_all()
{
    for (const auto &it : *g_map) {
        [it.second start];
    }
}

void add(NSObject<UPTimeSpanning> *obj)
{
    emplace(obj.serialNumber, obj);
}

void remove(NSObject<UPTimeSpanning> *obj)
{
    erase(obj.serialNumber);
}

void remove(uint32_t serial_number)
{
    erase(serial_number);
}

}  // namespace TimeSpanning
}  // namespace UP
