//
//  UPTimeSpanning.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UPControl.h>
#import <UPKit/UPMacros.h>
#import <UPKit/UPBand.h>
#import <UPKit/UPSerialNumber.h>
#import <UPKit/UPViewTo.h>

@class UPAnimator;

@protocol UPTimeSpanning <NSObject>
@property (nonatomic, readonly) UP::Band band;
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

UPAnimator *bloop(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint position,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *bloop_to(UP::Band band, NSArray<UPViewTo *> *viewTos, CFTimeInterval duration, void (^completion)(UIViewAnimatingPosition));

UPAnimator *fade(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration, void (^completion)(UIViewAnimatingPosition));

UPAnimator *shake(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *slide(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *slide_to(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration, CGPoint point,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *spring(UP::Band band, NSArray<UIView *> *views, CFTimeInterval duration, UIOffset offset,
    void (^completion)(UIViewAnimatingPosition));

UPAnimator *set_color(UP::Band band, NSArray<UPControl *> *controls, CFTimeInterval duration, UPControlElement element,
    UPControlState fromControlState, UPControlState toControlState, void (^completion)(UIViewAnimatingPosition));

NSObject<UPTimeSpanning> *delay(UP::Band band, double delay_in_seconds, void (^block)(void));

void cancel(NSObject<UPTimeSpanning> *);
void cancel(uint32_t);
void cancel(NSArray<UIView *> *);
void cancel(UP::Band);
void cancel_all();

void pause(NSObject<UPTimeSpanning> *);
void pause(uint32_t);
void pause(UP::Band);
void pause_all();

void start(NSObject<UPTimeSpanning> *);
void start(uint32_t);
void start(UP::Band);
void start_all();

void add(NSObject<UPTimeSpanning> *);
void remove(NSObject<UPTimeSpanning> *);
void remove(uint32_t);

}  // namespace TimeSpanning
}  // namespace UP

#endif  // __cplusplus
