//
//  UPLexicon.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <random>
#import <sstream>
#import <ios>

#import "UPLexicon.h"
#import "UPRandom.h"
#import "UPStringTools.h"

const size_t UPLexiconLanguageCount = 1;

// A class to help NSBundle find us.
@interface UPLexiconDummy : NSObject
@end
@implementation UPLexiconDummy
@end

namespace UP {

static NSString *lexicon_file_name(UPLexiconLanguage language)
{
    switch (language) {
        case UPLexiconLanguageEnglish:
            return @"en-lexicon";
    }
}

static Lexicon *g_instance;
static UPLexiconLanguage g_language;
static std::mutex g_mutex;

void Lexicon::set_language(UPLexiconLanguage language)
{
    std::lock_guard<std::mutex> guard(g_mutex);
    bool has_instance = (g_instance != nullptr);
    if (has_instance && g_language == language) {
        return;
    }
    if (has_instance) {
        delete g_instance;
        g_instance = nullptr;
    }
    NSBundle *upkitBundle = [NSBundle bundleForClass:[UPLexiconDummy class]];
    NSString *fileName = lexicon_file_name(language);
    NSString *wordsFilePath = [upkitBundle pathForResource:fileName ofType:@"txt"];
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfFile:wordsFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"*** error reading lexicon: %@", error.localizedDescription);
    }
    else {
        g_instance = new Lexicon(cpp_str(contents));
        g_language = language;
    }
}

Lexicon &Lexicon::instance()
{
    return *g_instance;
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
