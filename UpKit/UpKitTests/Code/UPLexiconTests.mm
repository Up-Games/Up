//
//  UPLexiconTests.mm
//  Copyright © 2020 Up Games. All rights reserved.
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
    XCTAssert(contains, "Lexicon should have contained 'GERBIL'");
}

- (void)testLexiconContains2
{
    Lexicon::set_language(UPLexiconLanguageEnglish);
    Lexicon &lexicon = Lexicon::instance();
    bool contains = lexicon.contains(U"FOOABC");
    XCTAssertFalse(contains, "Lexicon should not have contained 'FOOABC'");
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
