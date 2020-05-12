//
//  UPGameCodeTests.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UpKit/UpKit.h>

using UP::GameCode;

@interface UPGameCodeTests : XCTestCase
@end

@implementation UPGameCodeTests

- (void)testGameCodeFromString1
{
    GameCode game_code("GKW-8745");
    uint32_t value = game_code.value();
    GameCode test_game_code = GameCode(value);
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromString2
{
    GameCode game_code("BHU--726282");
    uint32_t value = game_code.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameCodeFromString3
{
    GameCode game_code("AAA-0000");
    uint32_t value = game_code.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameCodeFromString4
{
    GameCode game_code("ZZZ-9999");
    uint32_t value = game_code.value();
    XCTAssert(value == GameCode::MaxValue, "Game code should be %zu", GameCode::MaxValue);
}

- (void)testGameCodeFromString5
{
    GameCode game_code(GameCode::DefaultCharString);
    uint32_t value = game_code.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameCodeFromValue1
{
    GameCode game_code(48337101);
    GameCode test_game_code = GameCode("HDX-7101");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue2
{
    GameCode game_code(1);
    GameCode test_game_code = GameCode("AAA-0001");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue3
{
    GameCode game_code(GameCode::MaxValue - 2);
    GameCode test_game_code = GameCode("ZZZ-9997");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue4
{
    GameCode game_code(GameCode::MaxValue);
    GameCode test_game_code = GameCode("ZZZ-9999");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue5
{
    GameCode game_code(GameCode::MaxValue + 10);
    XCTAssert(game_code.value() == 0, "Game code should be 0.");
}

- (void)testGameCodeRandom
{
    UP::Random::create_instance();
    GameCode game_code = GameCode::random();
    XCTAssert(game_code.value() > 0, "Game code should be > 0.");
    XCTAssert(game_code.value() <= GameCode::MaxValue, "Game code should be >= GameCode::MaxValue.");
}


@end
