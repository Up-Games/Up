//
//  UPTimeSpanning.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPMacros.h>

@class UPAnimator;

@protocol UPTimeSpanning <NSObject>
@property (nonatomic, readonly) const char *label;
@property (nonatomic, readonly) uint32_t serialNumber;
- (void)start;
- (void)pause;
- (void)reset;
- (void)cancel;
@end

#if __cplusplus

#import <atomic>

namespace UP {
namespace TimeSpanning {

extern const char * const AnimationLabel;
extern const char * const DelayLabel;
extern const char * const TestLabel;

void init();

UP_STATIC_INLINE uint32_t next_serial_number() {
    static std::atomic_uint32_t g_counter;
    return ++g_counter;
}

UPAnimator *bloop_animator(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint position,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *fade_animator(const char *label, NSArray<UIView *> *views, CFTimeInterval duration,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *slide_animator(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *shake_animator(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *spring_animator(const char *label, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

NSObject<UPTimeSpanning> *delay(const char *label, double delay_in_seconds, void (^block)(void));

void cancel(NSObject<UPTimeSpanning> *);
void cancel(const char *label);
void cancel_all();

void pause(NSObject<UPTimeSpanning> *);
void pause(const char *label);
void pause_all();

void start(NSObject<UPTimeSpanning> *);
void start(const char *label);
void start_all();

void remove(NSObject<UPTimeSpanning> *);

}  // namespace TimeSpanning
}  // namespace UP

#endif  // __cplusplus
