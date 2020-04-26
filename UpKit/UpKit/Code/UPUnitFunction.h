//
//  UPUnitFunction.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPTypes.h>

typedef enum {
    UPUnitFunctionTypeDefault = 0,
    UPUnitFunctionTypeLinear = 1,
    UPUnitFunctionTypeEaseIn = 2,
    UPUnitFunctionTypeEaseOut = 3,
    UPUnitFunctionTypeEaseInEaseOut = 4,
    UPUnitFunctionTypeEaseInQuad = 13,
    UPUnitFunctionTypeEaseOutQuad = 14,
    UPUnitFunctionTypeEaseInEaseOutQuad = 15,
    UPUnitFunctionTypeEaseInCubic = 16,
    UPUnitFunctionTypeEaseOutCubic = 17,
    UPUnitFunctionTypeEaseInEaseOutCubic = 18,
    UPUnitFunctionTypeEaseInQuart = 19,
    UPUnitFunctionTypeEaseOutQuart = 20,
    UPUnitFunctionTypeEaseInEaseOutQuart = 21,
    UPUnitFunctionTypeEaseInQuint = 22,
    UPUnitFunctionTypeEaseOutQuint = 23,
    UPUnitFunctionTypeEaseInEaseOutQuint = 24,
    UPUnitFunctionTypeEaseInBack = 50,
    UPUnitFunctionTypeEaseOutBack = 51,
    UPUnitFunctionTypeEaseInEaseOutBack = 52,
    UPUnitFunctionTypeEaseInBounce = 53,
    UPUnitFunctionTypeEaseOutBounce = 54,
    UPUnitFunctionTypeEaseInEaseOutBounce = 55,
    UPUnitFunctionTypeEaseInCirc = 56,
    UPUnitFunctionTypeEaseOutCirc = 57,
    UPUnitFunctionTypeEaseInEaseOutCirc = 58,
    UPUnitFunctionTypeEaseInElastic = 59,
    UPUnitFunctionTypeEaseOutElastic = 60,
    UPUnitFunctionTypeEaseInEaseOutElastic = 61,
    UPUnitFunctionTypeEaseInExpo = 62,
    UPUnitFunctionTypeEaseOutExpo = 63,
    UPUnitFunctionTypeEaseInEaseOutExpo = 64,
    UPUnitFunctionTypeEaseInSine = 65,
    UPUnitFunctionTypeEaseOutSine = 66,
    UPUnitFunctionTypeEaseInEaseOutSine = 67,
} UPUnitFunctionType;

#ifdef __OBJC__

#import <Foundation/Foundation.h>

@interface UPUnitFunction : NSObject

+ (UPUnitFunction *)unitFunctionWithType:(UPUnitFunctionType)type;
- (instancetype)initWithType:(UPUnitFunctionType)type;
- (UPFloat)valueForInput:(UPFloat)input;

@end

#endif  // __OBJC__
