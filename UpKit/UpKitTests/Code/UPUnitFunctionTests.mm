//
//  UPUnitFunctionTests.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UpKit/UpKit.h>

@interface UPUnitFunctionTests : XCTestCase
@end

@implementation UPUnitFunctionTests

- (void)testZeroUnitFunction
{
    UPUnitFunction *fn = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeDefault];
    UPFloat value = [fn valueForInput:0.0f];
    XCTAssert(value == 0.0f, "Value should be 0.0");
}

- (void)testOneUnitFunction
{
    UPUnitFunction *fn = [UPUnitFunction unitFunctionWithType:UPUnitFunctionTypeDefault];
    UPFloat value = [fn valueForInput:1.0f];
    XCTAssert(value == 1.0f, "Value should be 1.0");
}

@end
