//
//  UPGameKeyTests.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UpKit/UpKit.h>

using UP::GameKey;

@interface UPGameKeyTests : XCTestCase
@end

@implementation UPGameKeyTests

- (void)testGameKeyFromString1
{
    GameKey game_key("GKW-8745");
    uint32_t value = game_key.value();
    GameKey test_game_key = GameKey(value);
    XCTAssert(game_key == test_game_key, "Game codes should be equal.");
}

- (void)testGameKeyFromString2
{
    GameKey game_key("BHU--726282");
    uint32_t value = game_key.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameKeyFromString3
{
    GameKey game_key("AAA-0000");
    uint32_t value = game_key.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameKeyFromString4
{
    GameKey game_key("ZZZ-9999");
    uint32_t value = game_key.value();
    XCTAssert(value == GameKey::MaxValue, "Game code should be %zu", GameKey::MaxValue);
}

- (void)testGameKeyFromString5
{
    GameKey game_key(GameKey::DefaultCharString);
    uint32_t value = game_key.value();
    XCTAssert(value == 0, "Game code should be 0");
}

- (void)testGameKeyFromValue1
{
    GameKey game_key(48337101);
    GameKey test_game_key = GameKey("HDX-7101");
    XCTAssert(game_key == test_game_key, "Game codes should be equal.");
}

- (void)testGameKeyFromValue2
{
    GameKey game_key(1);
    GameKey test_game_key = GameKey("AAA-0001");
    XCTAssert(game_key == test_game_key, "Game codes should be equal.");
}

- (void)testGameKeyFromValue3
{
    GameKey game_key(GameKey::MaxValue - 2);
    GameKey test_game_key = GameKey("ZZZ-9997");
    XCTAssert(game_key == test_game_key, "Game codes should be equal.");
}

- (void)testGameKeyFromValue4
{
    GameKey game_key(GameKey::MaxValue);
    GameKey test_game_key = GameKey("ZZZ-9999");
    XCTAssert(game_key == test_game_key, "Game codes should be equal.");
}

- (void)testGameKeyFromValue5
{
    GameKey game_key(GameKey::MaxValue + 10);
    XCTAssert(game_key.value() == 0, "Game code should be 0.");
}

- (void)testGameKeyRandom
{
    UP::Random::instance();
    GameKey game_key = GameKey::random();
    XCTAssert(game_key.value() > 0, "Game code should be > 0.");
    XCTAssert(game_key.value() <= GameKey::MaxValue, "Game code should be >= GameKey::MaxValue.");
}


@end
