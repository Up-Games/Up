//
//  UPTimeSpanning.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>
#import <UPKit/UPMacros.h>
#import <UPKit/UPRole.h>
#import <UPKit/UPSerialNumber.h>

@class UPAnimator;

@protocol UPTimeSpanning <NSObject>
@property (nonatomic, readonly) UP::Role role;
@property (nonatomic, readonly) uint32_t serialNumber;
- (void)start;
- (void)pause;
- (void)reset;
- (void)cancel;
@end

#if __cplusplus

namespace UP {
namespace TimeSpanning {

void init();

UPAnimator *bloop(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint position,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *fade(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, void (^completion)(UIViewAnimatingPosition));

UPAnimator *shake(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *slide(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *slide_to(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint point,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *spring(UP::Role role, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *set_color(UP::Role role, NSArray<UPControl *> *controls, CFTimeInterval duration, UPControlElement element,
    UPControlState fromControlState, UPControlState toControlState, void (^completion)(UIViewAnimatingPosition));

NSObject<UPTimeSpanning> *delay(UP::Role role, double delay_in_seconds, void (^block)(void));

void cancel(NSObject<UPTimeSpanning> *);
void cancel(UP::Role role);
void cancel_all();

void pause(NSObject<UPTimeSpanning> *);
void pause(UP::Role role);
void pause_all();

void start(NSObject<UPTimeSpanning> *);
void start(UP::Role role);
void start_all();

void add(NSObject<UPTimeSpanning> *);
void remove(NSObject<UPTimeSpanning> *);

}  // namespace TimeSpanning
}  // namespace UP

#endif  // __cplusplus
