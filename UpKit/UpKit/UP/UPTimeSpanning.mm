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

NSObject<UPTimeSpanning> *delay(UP::Band band, double delay_in_seconds, void (^block)(void))
{
    UPDelayedAction *action = [UPDelayedAction delayedAction:band duration:delay_in_seconds block:block];
    emplace(action.serialNumber, action);
    [action start];
    return action;
}

UPAnimator *bloop_in(UP::Band band, NSArray<UPViewMove *> *moves, CFTimeInterval duration, void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator bloopInAnimatorInBand:band moves:moves duration:duration completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *bloop_out(UP::Band band, NSArray<UPViewMove *> *moves, CFTimeInterval duration, void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator bloopOutAnimatorInBand:band moves:moves duration:duration completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *fade(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator fadeAnimatorInBand:band views:views duration:duration completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *shake(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator shakeAnimatorInBand:band views:views duration:duration offset:offset completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *slide(UP::Band band, NSArray<UPViewMove *> *moves, CFTimeInterval duration, void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator slideAnimatorInBand:band moves:moves duration:duration completion:completion];
    emplace(animator.serialNumber, animator);
    return animator;
}

UPAnimator *set_color(UP::Band band, NSArray<UPControl *> *controls, CFTimeInterval duration, UPControlElement element,
    UPControlState fromControlState, UPControlState toControlState, void (^completion)(UIViewAnimatingPosition))
{
    UPAnimator *animator = [UPAnimator setColorAnimatorInBand:band controls:controls duration:duration element:element
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

void cancel(UP::Band band)
{
    for (auto it = g_map->begin(); it != g_map->end();) {
        NSObject<UPTimeSpanning> *obj = it->second;
        if (band_match(band, obj.band)) {
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

void cancel(NSArray<UIView *> *views, uint32_t type)
{
    for (auto it = g_map->begin(); it != g_map->end();) {
        NSObject<UPTimeSpanning> *obj = it->second;
        if (![obj isKindOfClass:[UPAnimator class]]) {
            continue;
        }
        UPAnimator *animator = (UPAnimator *)obj;
        if ((animator.type & type) && [views isEqualToArray:animator.views]) {
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

void pause(UP::Band band)
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        if (band_match(band, obj.band)) {
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

void start(UP::Band band)
{
    for (const auto &it : *g_map) {
        NSObject<UPTimeSpanning> *obj = it.second;
        if (band_match(band, obj.band)) {
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
