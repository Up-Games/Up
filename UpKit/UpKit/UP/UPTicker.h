//
//  UPTicker.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class UPTickingAnimator;
@protocol UPTicking;

extern CFTimeInterval UPTickerInterval;

@interface UPTicker : NSObject

+ (UPTicker *)instance;
- (instancetype)init NS_UNAVAILABLE;

- (void)addTicking:(NSObject<UPTicking> *)ticking;
- (void)removeTicking:(NSObject<UPTicking> *)ticking;
- (void)removeAllTickings;

- (void)start;
- (void)stop;

@end

@protocol UPTicking <NSObject>
- (void)tick:(CFTimeInterval)now;
@end
