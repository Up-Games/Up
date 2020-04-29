//
//  UPDeferredBlock.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPDeferredBlock.h"

@interface UPDeferredBlock ()
@property (nonatomic) UPTick interval;
@property (nonatomic, copy) void (^block)(void);
@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL valid;
@end

@implementation UPDeferredBlock

- (id)initWithInterval:(UPTick)interval block:(void (^)(void))block;
{
    self = [super init];
    
    self.interval = interval;
    self.block = block;
    self.valid = YES;
    
    [self touchWithInterval:self.interval];
    
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.block = nil;
}

- (void)touch
{
    [self touchWithInterval:self.interval];
}

- (void)touchWithInterval:(UPTick)interval
{
    if (!self.valid || !self.block || interval < 0) {
        [self invalidate];
        return;
    }
    
    self.valid = YES;
    self.interval = interval;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:interval];
    if (self.timer) {
        [self.timer setFireDate:date];
    }
    else {
        self.timer = [[NSTimer alloc] initWithFireDate:date interval:interval target:self selector:@selector(_timerFired:)
                                              userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)invalidate
{
    self.valid = NO;
    [self.timer invalidate];
    self.timer = nil;
    self.block = nil;
}

- (void)_timerFired:(NSTimer *)timer
{
    if (self.valid && self.block) {
        self.block();
    }
    [self invalidate];
}

@end
