//
//  UPDeferredBlock.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UPKit/UPTypes.h>

@interface UPDeferredBlock : NSObject

@property (nonatomic, readonly) UPTick interval;
@property (nonatomic, copy, readonly) void (^block)(void);
@property (nonatomic, readonly) BOOL valid;

- (id)initWithInterval:(UPTick)interval block:(void (^)(void))block;

- (void)touch;
- (void)touchWithInterval:(UPTick)interval;
- (void)invalidate;

@end
