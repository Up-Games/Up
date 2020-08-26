//
//  UPLexiconTests.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UpKit/UpKit.h>

using UP::Lexicon;

@interface UPLexiconTests : XCTestCase
@end

@implementation UPLexiconTests

- (void)testLexiconContains1
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    bool contains = lexicon.contains(U"GERBIL");
    XCTAssert(contains, "Lexicon should contain 'GERBIL'");
}

- (void)testLexiconContains1A
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    Lexicon::Lookup result = lexicon.lookup(U"GERBIL");
    XCTAssert(result.found, "Lexicon should contain 'GERBIL'");
    XCTAssert(result.word == std::u32string(U"GERBIL"), "Lexicon should contain 'GERBIL' for 'GERBIL'");
}

- (void)testLexiconContains2
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    bool contains = lexicon.contains(U"FOOABC");
    XCTAssertFalse(contains, "Lexicon should not contain 'FOOABC'");
}

- (void)testLexiconContains2A
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    Lexicon::Lookup result = lexicon.lookup(U"FOOABC");
    XCTAssertFalse(result.found, "Lexicon should not contain 'FOOABC'");
    XCTAssert(result.word.length() == 0, "Lexicon should not contain a word for 'GERBIL'");
}

- (void)testLexiconContains3
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    bool contains = lexicon.contains(U"PINATA");
    XCTAssert(contains, "Lexicon should contain 'PINATA'");
}

- (void)testLexiconContains3A
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    Lexicon::Lookup result = lexicon.lookup(U"PINATA");
    XCTAssert(result.found, "Lexicon should contain 'PINATA'");
    XCTAssert(result.word == std::u32string(U"PIÑATA"), "Lexicon should contain 'PIÑATA' for 'PINATA'");
}

- (void)testLexiconContainsTime1
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    [self measureBlock:^{
        lexicon.contains(U"VERILY");
    }];
}

@end
