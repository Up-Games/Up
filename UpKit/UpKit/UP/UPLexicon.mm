//
//  UPLexicon.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <mutex>
#import <random>
#import <string>

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

static NSString *fixed_lexicon_file_name(UPLexiconLanguage language)
{
    switch (language) {
        case UPLexiconLanguageEnglish:
            return @"en-fixed-lexicon";
    }
}

static Lexicon *g_instance;
static Lexicon *g_fixed_instance;
static UPLexiconLanguage g_language;
static std::mutex g_mutex;

void Lexicon::set_language(UPLexiconLanguage language)
{
    std::lock_guard<std::mutex> guard(g_mutex);
    bool has_instance = (g_instance != nullptr);
    if (has_instance && g_language == language) {
        return;
    }
    g_language = language;
    NSBundle *upkitBundle = [NSBundle bundleForClass:[UPLexiconDummy class]];
    if (g_instance) {
        delete g_instance;
        g_instance = nullptr;
    }
    if (!g_instance) {
        NSString *fileName = lexicon_file_name(language);
        NSString *wordsFilePath = [upkitBundle pathForResource:fileName ofType:@"txt"];
        NSError *error;
        NSString *contents = [NSString stringWithContentsOfFile:wordsFilePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"*** error reading lexicon: %@", error.localizedDescription);
        }
        else {
            g_instance = new Lexicon(cpp_u32str(contents));
        }
    }
    if (g_fixed_instance) {
        delete g_fixed_instance;
        g_fixed_instance = nullptr;
    }
    if (!g_fixed_instance) {
        NSString *fileName = fixed_lexicon_file_name(language);
        NSString *wordsFilePath = [upkitBundle pathForResource:fileName ofType:@"txt"];
        NSError *error;
        NSString *contents = [NSString stringWithContentsOfFile:wordsFilePath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"*** error reading fixed lexicon: %@", error.localizedDescription);
        }
        else {
            g_fixed_instance = new Lexicon(cpp_u32str(contents));
        }
    }
}

Lexicon &Lexicon::instance()
{
    return *g_instance;
}

Lexicon &Lexicon::fixed_instance()
{
    return *g_fixed_instance;
}

Lexicon::Lexicon(std::u32string &&contents) : m_contents(std::move(contents))
{
    if (m_contents.length() == 0) {
        return;
    }
    static constexpr char32_t newline = U'\n';
    static constexpr char32_t colon = U':';
    const char32_t *ptr = m_contents.data();
    size_t start = 0;
    std::u32string_view key;
    for (size_t count = 0; count < m_contents.length(); count++) {
        char32_t c = m_contents[count];
        if (c == colon) {
            key = std::u32string_view(ptr + start, count - start);
            start = count + 1;
        }
        else if (c == newline) {
            std::u32string_view string(ptr + start, count - start);
            if (key.length() == 0) {
                key = string;
            }
            start = count + 1;
            m_lookup.emplace(key, string);
            m_keys.push_back(key);
            key = std::u32string_view();
        }
    }
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

} // namespace UP
