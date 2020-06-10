//
//  UPGameCodeTests.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UpKit/UpKit.h>

using UP::GameKey;

@interface UPGameCodeTests : XCTestCase
@end

@implementation UPGameCodeTests

- (void)testGameCodeFromString1
{
    GameKey game_code("GKW-8745");
    uint32_t value = game_code.value();
    GameKey test_game_code = GameKey(value);
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromString2
{
    GameKey game_code("BHU--726282");
    uint32_t value = game_code.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameCodeFromString3
{
    GameKey game_code("AAA-0000");
    uint32_t value = game_code.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameCodeFromString4
{
    GameKey game_code("ZZZ-9999");
    uint32_t value = game_code.value();
    XCTAssert(value == GameKey::MaxValue, "Game code should be %zu", GameKey::MaxValue);
}

- (void)testGameCodeFromString5
{
    GameKey game_code(GameCode::DefaultCharString);
    uint32_t value = game_code.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameCodeFromValue1
{
    GameKey game_code(48337101);
    GameKey test_game_code = GameCode("HDX-7101");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue2
{
    GameKey game_code(1);
    GameKey test_game_code = GameCode("AAA-0001");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue3
{
    GameKey game_code(GameKey::MaxValue - 2);
    GameKey test_game_code = GameCode("ZZZ-9997");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue4
{
    GameKey game_code(GameKey::MaxValue);
    GameKey test_game_code = GameCode("ZZZ-9999");
    XCTAssert(game_code == test_game_code, "Game codes should be equal.");
}

- (void)testGameCodeFromValue5
{
    GameKey game_code(GameKey::MaxValue + 10);
    XCTAssert(game_code.value() == 0, "Game code should be 0.");
}

- (void)testGameCodeRandom
{
    UP::Random::create_instance();
    GameKey game_code = GameKey::random();
    XCTAssert(game_code.value() > 0, "Game code should be > 0.");
    XCTAssert(game_code.value() <= GameKey::MaxValue, "Game code should be >= GameCode::MaxValue.");
}


@end
