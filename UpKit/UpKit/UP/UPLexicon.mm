//
//  UPLexicon.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPLexicon.h"
#import "UPStringTools.h"

#if __cplusplus

#import <random>
#import <sstream>
#import <ios>

#import "UPLexicon.h"
#import "UPRandom.hpp"
#import "UPStringTools.h"

const NSUInteger UPLexiconLanguageCount = 1;

namespace UP {

std::mutex Lexicon::g_mutex;

static NSString *lexicon_file_name(UPLexiconLanguage language)
{
    switch (language) {
        case UPLexiconLanguageEnglish:
            return @"en-lexicon";
    }
}

static Lexicon *_Instance;

void Lexicon::set_language(UPLexiconLanguage language)
{
    std::lock_guard<std::mutex> guard(Lexicon::g_mutex);
    if (_Instance) {
        delete _Instance;
        _Instance = nullptr;
    }
    NSBundle *upkitBundle = [NSBundle bundleForClass:[UPLexicon class]];
    NSString *fileName = lexicon_file_name(language);
    NSString *wordsFilePath = [upkitBundle pathForResource:fileName ofType:@"txt"];
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfFile:wordsFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"*** error reading lexicon: %@", error.localizedDescription);
    }
    else {
        _Instance = new Lexicon(cpp_str(contents));
    }
}

Lexicon &Lexicon::instance()
{
    return *_Instance;
}

Lexicon::Lexicon(const std::string &contents)
{
    if (contents.length() == 0) {
        return;
    }
    std::istringstream iss(contents);
    for (std::string line; std::getline(iss, line); ) {
        std::u32string word(cpp_u32str(line));
        m_words.insert(word);
        m_word_list.push_back(word);
    }
}

bool Lexicon::contains(const std::u32string &word)
{
    return m_words.find(word) != m_words.end();
}

bool Lexicon::is_vowel(char32_t c) {
    switch (c) {
        case U'A':
        case U'E':
        case U'I':
        case U'O':
        case U'U':
            return true;
    }
    return false;
}

std::u32string Lexicon::random_word(Random &r) const
{
    uint32_t idx = r.uint32_between(0, (uint32_t)m_words.size());
    return m_word_list[idx];
}

} // namespace UP

#endif  // __cplusplus

// =========================================================================================================================================

@interface UPLexicon ()
@end

@implementation UPLexicon

//+ (UPLexicon *)instanceForLanguage:(UPLexiconLanguage)language
//{
//    return [[UPLexicon alloc] initForLanguage:language];
//}
//
//- (instancetype)initForLanguage:(UPLexiconLanguage)language
//{
//    self = [super init];
//    self.language = language;
//    return self;
//}
//
//- (BOOL)containsWord:(NSString *)word
//{
//    UP::Lexicon &lexicon = UP::Lexicon::instance_for_language(self.language);
//    return lexicon.contains(UP::cpp_u32str(word));
//}

@end
