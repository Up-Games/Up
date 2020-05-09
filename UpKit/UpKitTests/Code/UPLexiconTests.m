//
//  UPLexiconTests.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UpKit/UpKit.h>

@interface UPLexiconTests : XCTestCase
@end

@implementation UPLexiconTests

- (void)testLexiconContains1
{
    UPLexicon *lexicon = [UPLexicon instanceForLanguage:UPLexiconLanguageEnglish];
    BOOL contains = [lexicon containsWord:@"foo"];
    XCTAssert(contains, "Lexicon should have contained 'foo'");
}

- (void)testLexiconContains2
{
    UPLexicon *lexicon = [UPLexicon instanceForLanguage:UPLexiconLanguageEnglish];
    BOOL contains = [lexicon containsWord:@"fooa"];
    XCTAssertFalse(contains, "Lexicon should have contained 'fooa'");
}

- (void)testLexiconContains3
{
    UPLexicon *lexicon = [UPLexicon instanceForLanguage:UPLexiconLanguageEnglish];
    BOOL contains = [lexicon containsWord:@"gerbil"];
    XCTAssert(contains, "Lexicon should have contained 'gerbil'");
}

- (void)testLexiconContainsTime1
{
    UPLexicon *lexicon = [UPLexicon instanceForLanguage:UPLexiconLanguageEnglish];
    [self measureBlock:^{
        [lexicon containsWord:@"foo"];
    }];
}

- (void)testLexiconLoadTime
{
    [self measureBlock:^{
        UPLexicon *lexicon = [[UPLexicon alloc] initForLanguage:UPLexiconLanguageEnglish];
        [lexicon containsWord:@"foo"];
    }];
}

@end
